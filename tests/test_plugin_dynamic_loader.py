import sys

from shibaclaw.integrations.base import BaseChannel
from shibaclaw.integrations.registry import discover_local_plugins

def test_discover_local_plugins(tmp_path, monkeypatch):
    # Mock get_plugins_dir to return a temporary directory
    import shibaclaw.config.paths
    monkeypatch.setattr(shibaclaw.config.paths, "get_plugins_dir", lambda: tmp_path)
    
    # Create a fake plugin module
    plugin_dir = tmp_path / "fake_plugin"
    plugin_dir.mkdir()
    
    init_file = plugin_dir / "__init__.py"
    init_file.write_text("""
from shibaclaw.integrations.base import BaseChannel

class MyFakeChannel(BaseChannel):
    @classmethod
    def get_id(cls): return "fake_channel"
    
    def get_name(self): return "fake"
    def initialize(self): pass
    def start(self): pass
    def stop(self): pass
    async def send_message(self, *args, **kwargs): pass
""", encoding="utf-8")

    # Call discover_local_plugins
    plugins = discover_local_plugins()
    
    assert "fake_plugin" in plugins
    assert issubclass(plugins["fake_plugin"], BaseChannel)
    assert plugins["fake_plugin"].__name__ == "MyFakeChannel"

    # Verify sys.path was updated
    assert str(tmp_path) in sys.path
