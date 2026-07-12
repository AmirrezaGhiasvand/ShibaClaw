import subprocess
import json
import os
from collections import defaultdict

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip().split('\n') if result.stdout.strip() else []

git_files = run_cmd("git ls-files")
changed_files = set(run_cmd("git log --since=30.days --name-only --pretty=format: | sort | uniq"))

def get_role(f):
    if f.endswith(('.py', '.js', '.mjs', '.html', '.css', '.html')):
        return 'Source code'
    if f.endswith(('.json', '.yaml', '.yml', '.toml', '.ini', '.conf')):
        if f in ['package.json', 'pyproject.toml', 'package-lock.json']:
            return 'Runtime config' # or constraint?
        if 'manifest' in f.lower() or 'schema' in f.lower():
            return 'Constraint files'
        return 'Runtime config'
    if f in ['CLAUDE.md', 'AGENTS.md', 'GEMINI.md', '.logic-lens.yaml'] or f.endswith('.schema.json') or f.endswith('.proto'):
        return 'Constraint files'
    if f in ['README.md', 'CONTRIBUTING.md', 'ARCHITECTURE.md'] or (f.startswith('docs/') and f.endswith('.md')):
        return 'Behavioral docs'
    return 'Exclude'

files = []
for f in git_files:
    if f.startswith(('node_modules/', 'dist/', 'build/', '.next/', '.nuxt/', 'coverage/', '.venv/', 'venv/', '__pycache__/', '.pytest_cache/', '.mypy_cache/', '.ruff_cache/')): continue
    if f.startswith(('.git/', '.DS_Store')): continue
    if f.endswith(('.lock', 'package-lock.json', 'yarn.lock', 'Pipfile.lock', 'poetry.lock', 'Cargo.lock', 'go.sum')): continue
    if f.endswith(('.png', '.jpg', '.gif', '.pdf', '.wasm', '.zip', '.tar', '.gz', '.woff', '.ttf', '.webp')): continue
    
    role = get_role(f)
    if role == 'Exclude':
        continue
        
    tier = 'Low'
    if f in changed_files:
        tier = 'High'
    elif role in ['Constraint files', 'Behavioral docs']:
        tier = 'Medium'
    elif 'tests/' in f or 'test_' in f:
        tier = 'Low'
    else:
        # Default to medium for utility, High for core, but let's say Medium
        tier = 'Medium'
        
    lines = 0
    try:
        with open(f, 'r', encoding='utf-8') as file:
            lines = sum(1 for _ in file)
    except:
        pass
        
    files.append({'name': f, 'role': role, 'tier': tier, 'lines': lines})

# Sort: High -> Medium -> Low; descending line count
tier_order = {'High': 0, 'Medium': 1, 'Low': 2}
files.sort(key=lambda x: (tier_order[x['tier']], -x['lines']))

if len(files) > 100:
    files = files[:100]
    
with open('logic_lens_scope.json', 'w') as out:
    json.dump(files, out, indent=2)

print(f"Classified {len(files)} files.")
