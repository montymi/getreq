"""Exercise the installed documentation dependencies without changing the checkout."""
from pathlib import Path
import subprocess
import sys
import tempfile

import click
import mistune
import toml

assert toml.loads('ready = true')['ready'] is True
assert '<h1>Ready</h1>' in mistune.html('# Ready')
assert click.unstyle('\x1b[31mReady\x1b[0m') == 'Ready'
with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    (root / 'docs').mkdir()
    source = Path(__file__).resolve().parents[1] / 'README.md'
    (root / 'docs' / 'index.md').write_text(source.read_text(encoding='utf-8'), encoding='utf-8')
    (root / 'mkdocs.yml').write_text('site_name: ClearDocs\n', encoding='utf-8')
    subprocess.run([sys.executable, '-m', 'mkdocs', 'build', '--strict',
                    '-f', str(root / 'mkdocs.yml')], check=True)
    html = (root / 'site' / 'index.html').read_text(encoding='utf-8')
    assert 'ClearDocs' in html and 'OSS Documentation Assistant' in html
print('Documentation dependency smoke checks passed')
