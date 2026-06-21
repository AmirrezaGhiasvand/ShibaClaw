import pytest
import asyncio
from unittest.mock import AsyncMock, MagicMock, patch
from collections import deque

from shibaclaw.webui.ws_handler import (
    _handle_user_message,
    processing_state,
    sessions,
    _ws_clients,
)
from shibaclaw.webui.agent_manager import agent_manager
from shibaclaw.webui.gateway_client import gateway_client


@pytest.mark.asyncio
async def test_ws_handler_multi_tab_race_condition():
    agent_manager.config = MagicMock()
    agent_manager._pack_manager = MagicMock()

    ws1 = MagicMock()
    ws2 = MagicMock()
    _ws_clients["ws1"] = ws1
    _ws_clients["ws2"] = ws2

    session_key = "webui:shared_session"
    sessions["ws1"] = {
        "session_key": session_key,
        "processing": False,
        "queue": deque(),
    }
    sessions["ws2"] = {
        "session_key": session_key,
        "processing": False,
        "queue": deque(),
    }

    first_job_started = asyncio.Event()
    first_job_can_finish = asyncio.Event()

    async def mock_chat_stream(payload, request_id):
        first_job_started.set()
        await first_job_can_finish.wait()
        yield {"t": "rt", "c": "Hello!"}

    with patch("shibaclaw.webui.ws_handler._emit_to_session", AsyncMock()) as mock_emit_sess, \
         patch("shibaclaw.webui.ws_handler._emit_to_ws", AsyncMock()) as mock_emit_ws, \
         patch("shibaclaw.webui.ws_handler._emit_session_status_all", AsyncMock()) as mock_emit_status, \
         patch.object(gateway_client, "chat_stream", side_effect=mock_chat_stream):

        task1 = asyncio.create_task(
            _handle_user_message("ws1", ws1, {"content": "First message", "id": "msg1"})
        )

        await first_job_started.wait()

        assert processing_state[session_key]["processing"] is True

        await _handle_user_message("ws2", ws2, {"content": "Second message", "id": "msg2"})

        assert len(sessions["ws2"]["queue"]) == 1
        assert sessions["ws2"]["queue"][0]["id"] == "msg2"

        first_job_can_finish.set()
        await task1

        await asyncio.sleep(0.05)

        assert len(sessions["ws2"]["queue"]) == 1
        assert session_key not in processing_state

    sessions.clear()
    _ws_clients.clear()
    processing_state.clear()
