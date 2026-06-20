#!/usr/bin/env bash
set -euo pipefail

FORCE=0
DRY_RUN=0

usage() {
    cat <<'EOF'
Usage: uninstall.sh [--force] [--dry-run]

  --force      Skip the confirmation prompt.
  --dry-run    Show what would be removed without deleting anything.
  -h, --help   Show this help message.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force|-f)
            FORCE=1
            ;;
        --dry-run|-n)
            DRY_RUN=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

confirm_uninstall() {
    if [[ "$FORCE" -eq 1 ]]; then
        return 0
    fi

    read -r -p "This will remove the ShibaClaw installation and local files. Continue? [y/N] " answer
    case "$answer" in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            echo "Uninstall cancelled."
            return 1
            ;;
    esac
}

run_or_echo() {
    local command="$1"
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[dry-run] $command"
    else
        eval "$command"
    fi
}

echo ">> Starting ShibaClaw uninstall..."

if ! confirm_uninstall; then
    exit 0
fi

if command -v pipx >/dev/null 2>&1; then
    echo ">> Removing pipx installation..."
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[dry-run] pipx uninstall shibaclaw"
    else
        pipx uninstall shibaclaw >/dev/null 2>&1 || true
    fi
fi

for target in "$HOME/.shibaclaw" "$HOME/.local/bin/shibaclaw" "$HOME/.local/bin/shibaclaw-desktop"; do
    if [[ -e "$target" || -L "$target" ]]; then
        run_or_echo "rm -rf '$target'"
    fi
done

if [[ -L /usr/local/bin/shibaclaw ]]; then
    run_or_echo "rm -f /usr/local/bin/shibaclaw"
fi

if [[ -L /usr/local/bin/shibaclaw-desktop ]]; then
    run_or_echo "rm -f /usr/local/bin/shibaclaw-desktop"
fi

echo "[OK] ShibaClaw has been removed."
