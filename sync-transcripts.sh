#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_dir="${TRANSCRIPTS_SOURCE_DIR:-/nfs/home/gongkaichen/learning/video-summary/transcripts}"
docs_dir="$repo_root/docs"
index_file="$docs_dir/index.md"

if [[ ! -d "$source_dir" ]]; then
  echo "Transcript directory not found: $source_dir" >&2
  exit 1
fi

mkdir -p "$docs_dir"
rsync --archive --delete \
  --exclude index.md \
  --exclude fonts/ \
  --exclude javascripts/ \
  --exclude stylesheets/ \
  "$source_dir/" "$docs_dir/"

transcript_count="$(find "$docs_dir" -type f -name '*.md' ! -name index.md | wc -l)"

# Generate explicit Zensical navigation from the copied directory tree.
python3 - "$docs_dir" "$repo_root/.generated-nav.toml" <<'PY'
import sys
from pathlib import Path
from urllib.parse import quote as url_quote

docs = Path(sys.argv[1]).resolve()
out = Path(sys.argv[2])

def quote(value: str) -> str:
    return '"' + value.replace('\\', '\\\\').replace('"', '\\"') + '"'

def page(path: Path, title: str | None = None) -> str:
    return '{ ' + quote(title or path.stem) + ' = ' + quote(path.relative_to(docs).as_posix()) + ' }'

def section(directory: Path) -> str:
    entries = []
    index = directory / "index.md"
    if index.exists():
        entries.append(page(index))
    entries.extend(page(path) for path in sorted(directory.glob("*.md"), key=lambda p: p.name.casefold()) if path.name != "index.md")
    entries.extend(section(path) for path in sorted(directory.iterdir(), key=lambda p: p.name.casefold()) if path.is_dir() and path.name not in {"fonts", "javascripts", "stylesheets"})
    return '{ ' + quote(directory.name) + ' = [' + ', '.join(entries) + '] }'

root_pages = [page(path) for path in sorted(docs.glob("*.md"), key=lambda p: p.name.casefold()) if path.name != "index.md"]
entries = [page(docs / "index.md", "首页")]
if root_pages:
    entries.append('{ "单篇" = [' + ', '.join(root_pages) + '] }')
entries.extend(section(path) for path in sorted(docs.iterdir(), key=lambda p: p.name.casefold()) if path.is_dir() and path.name not in {"fonts", "javascripts", "stylesheets"})
out.write_text("nav = [\n  " + ",\n  ".join(entries) + "\n]\n", encoding="utf-8")

def markdown_title(value: str) -> str:
    return value.replace("\\", "\\\\").replace("[", "\\[").replace("]", "\\]")

def markdown_link(path: Path) -> str:
    rel = path.relative_to(docs).as_posix()
    return f"- [{markdown_title(path.stem)}]({url_quote(rel, safe='/')})"

def index_tree(directory: Path, level: int) -> list[str]:
    lines = [
        markdown_link(path)
        for path in sorted(directory.glob("*.md"), key=lambda p: p.name.casefold())
        if path.name != "index.md"
    ]
    for child in sorted(directory.iterdir(), key=lambda p: p.name.casefold()):
        if not child.is_dir() or child.name in {"fonts", "javascripts", "stylesheets"}:
            continue
        lines.extend(["", "#" * level + " " + child.name, ""])
        lines.extend(index_tree(child, level + 1))
    return lines

count = sum(1 for path in docs.rglob("*.md") if path.name != "index.md")
index_lines = ["# 视频转录", "", f"共 {count} 篇。", ""]
index_lines.extend(index_tree(docs, 2))
(docs / "index.md").write_text("\n".join(index_lines) + "\n", encoding="utf-8")
PY

python3 - "$repo_root/zensical.toml" "$repo_root/.generated-nav.toml" <<'PY'
import sys
from pathlib import Path

config = Path(sys.argv[1])
nav = Path(sys.argv[2]).read_text(encoding="utf-8").rstrip()
text = config.read_text(encoding="utf-8")
begin = "# BEGIN GENERATED NAV"
end = "# END GENERATED NAV"
block = f"{begin}\n{nav}\n{end}"
if begin in text and end in text:
    start = text.index(begin)
    finish = text.index(end, start) + len(end)
    text = text[:start] + block + text[finish:]
else:
    marker = "[project]\n"
    if marker not in text:
        raise SystemExit("[project] section not found")
    text = text.replace(marker, marker + block + "\n\n", 1)
config.write_text(text, encoding="utf-8")
PY
rm -f "$repo_root/.generated-nav.toml"

echo "Mirrored $transcript_count transcripts from $source_dir to $docs_dir"
