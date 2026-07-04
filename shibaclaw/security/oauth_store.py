"""Encrypted OAuth token store for MCP server credentials."""

from __future__ import annotations

import json
import os
import time
from pathlib import Path
from typing import Any

from loguru import logger

_STORE_FILENAME = "oauth_tokens.enc"
_KEY_FILENAME = "oauth_store.key"


def _get_store_dir() -> Path:
    """Return the stable ~/.shibaclaw directory for token storage."""
    from shibaclaw.config.paths import get_app_root

    return get_app_root()


def _load_or_create_key(key_path: Path) -> bytes:
    """Load an existing Fernet key or generate and persist a new one."""
    from cryptography.fernet import Fernet

    if key_path.exists():
        return key_path.read_bytes()

    key = Fernet.generate_key()
    key_path.parent.mkdir(parents=True, exist_ok=True)
    key_path.write_bytes(key)
    # Owner-read-only permissions on POSIX
    try:
        os.chmod(key_path, 0o600)
    except OSError:
        pass
    logger.debug("OAuthTokenStore: generated new encryption key at {}", key_path)
    return key


class OAuthTokenStore:
    """
    Fernet-encrypted, JSON-backed store for OAuth tokens.

    All tokens are stored in a single encrypted file under ~/.shibaclaw/.
    The encryption key lives in a sibling file with 0o600 permissions.
    """

    def __init__(self, store_dir: Path | None = None) -> None:
        base = store_dir or _get_store_dir()
        self._store_path = base / _STORE_FILENAME
        self._key_path = base / _KEY_FILENAME
        self._fernet = self._build_fernet()

    def _build_fernet(self):
        from cryptography.fernet import Fernet

        key = _load_or_create_key(self._key_path)
        return Fernet(key)

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _load_all(self) -> dict[str, Any]:
        """Decrypt and deserialise the token store. Returns empty dict on any error."""
        if not self._store_path.exists():
            return {}
        try:
            raw = self._store_path.read_bytes()
            plaintext = self._fernet.decrypt(raw)
            return json.loads(plaintext)
        except Exception as exc:
            logger.warning("OAuthTokenStore: failed to read token store: {}", exc)
            return {}

    def _save_all(self, data: dict[str, Any]) -> None:
        """Serialise and encrypt the entire token store to disk."""
        try:
            plaintext = json.dumps(data).encode()
            ciphertext = self._fernet.encrypt(plaintext)
            self._store_path.parent.mkdir(parents=True, exist_ok=True)
            self._store_path.write_bytes(ciphertext)
            try:
                os.chmod(self._store_path, 0o600)
            except OSError:
                pass
        except Exception as exc:
            logger.error("OAuthTokenStore: failed to save token store: {}", exc)

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def save_token(self, server_name: str, token_data: dict[str, Any]) -> None:
        """Persist *token_data* for *server_name*, adding a ``_saved_at`` timestamp."""
        all_tokens = self._load_all()
        token_data = dict(token_data)  # defensive copy
        token_data["_saved_at"] = int(time.time())
        all_tokens[server_name] = token_data
        self._save_all(all_tokens)
        logger.debug("OAuthTokenStore: saved token for server '{}'", server_name)

    def load_token(self, server_name: str) -> dict[str, Any] | None:
        """Return the stored token dict for *server_name*, or ``None`` if absent."""
        return self._load_all().get(server_name)

    def delete_token(self, server_name: str) -> None:
        """Remove the stored token for *server_name* (no-op if not present)."""
        all_tokens = self._load_all()
        if server_name in all_tokens:
            del all_tokens[server_name]
            self._save_all(all_tokens)
            logger.debug("OAuthTokenStore: deleted token for server '{}'", server_name)

    def is_expired(self, server_name: str, *, buffer_seconds: int = 60) -> bool:
        """
        Return ``True`` when the stored access token for *server_name* has expired
        (or will expire within *buffer_seconds*).

        Returns ``True`` also when no token exists or when it carries no
        expiry information, so callers can treat it as "needs refresh".
        """
        token = self.load_token(server_name)
        if not token:
            return True

        expires_at = token.get("expires_at")
        if expires_at:
            return int(time.time()) >= (int(expires_at) - buffer_seconds)

        # Derive expiry from saved_at + expires_in if present
        saved_at = token.get("_saved_at")
        expires_in = token.get("expires_in")
        if saved_at and expires_in:
            return int(time.time()) >= (int(saved_at) + int(expires_in) - buffer_seconds)

        # No expiry info → assume still valid (conservative)
        return False

    def has_refresh_token(self, server_name: str) -> bool:
        """Return ``True`` when a non-empty refresh_token is stored."""
        token = self.load_token(server_name)
        return bool(token and token.get("refresh_token"))

    def list_servers(self) -> list[str]:
        """Return the names of all servers with stored tokens."""
        return list(self._load_all().keys())
