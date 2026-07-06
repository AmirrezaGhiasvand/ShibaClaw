import io
import zipfile
from shibaclaw.agent.skills import SkillsLoader


def test_skills_loader_import_zip_slip_protection(tmp_path):
    loader = SkillsLoader(tmp_path)

    # Create a zip containing normal files and a traversal file
    zip_buffer = io.BytesIO()
    with zipfile.ZipFile(zip_buffer, "w", zipfile.ZIP_DEFLATED) as zf:
        zf.writestr("my_skill/SKILL.md", "name: my_skill\ndescription: test\n")
        zf.writestr("my_skill/scripts/helper.py", "print('hello')\n")
        zf.writestr("my_skill/../../traversal_file.txt", "should not exist")

    # Import the zip
    res = loader.import_skills_zip(zip_buffer.getvalue())
    assert "my_skill" in res["imported"]

    # Verify normal extraction succeeded
    skill_dir = tmp_path / "skills" / "my_skill"
    assert (skill_dir / "SKILL.md").exists()
    assert (skill_dir / "scripts" / "helper.py").exists()

    # Verify Zip Slip path traversal was prevented
    traversal_file = tmp_path / "traversal_file.txt"
    assert not traversal_file.exists()
