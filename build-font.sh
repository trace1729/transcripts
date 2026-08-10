#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
font_url="https://raw.githubusercontent.com/lxgw/LxgwWenKai/main/fonts/TTF/LXGWWenKai-Regular.ttf"
output_file="$repo_root/docs/fonts/lxgw-wenkai-subset.woff2"
tmp_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

if [[ ! -x "$repo_root/.venv/bin/pyftsubset" ]]; then
  echo "Install requirements-dev.txt before rebuilding the font." >&2
  exit 1
fi

curl -fsSL "$font_url" -o "$tmp_dir/LXGWWenKai-Regular.ttf"
"$repo_root/.venv/bin/zensical" build --clean
find "$repo_root/docs" "$repo_root/site" -type f \
  \( -name '*.md' -o -name '*.html' -o -name '*.js' \) \
  -exec cat {} + > "$tmp_dir/corpus.txt"

"$repo_root/.venv/bin/pyftsubset" "$tmp_dir/LXGWWenKai-Regular.ttf" \
  --text-file="$tmp_dir/corpus.txt" \
  --output-file="$output_file" \
  --flavor=woff2 \
  --layout-features='*' \
  --notdef-glyph \
  --notdef-outline \
  --recommended-glyphs \
  --name-IDs='*' \
  --name-legacy \
  --name-languages='*'

"$repo_root/.venv/bin/zensical" build --clean
echo "Built $output_file"
