#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
font_file="${TRANSCRIPTS_FONT_FILE:-$repo_root/fonts/LXGWWenKaiGBScreen.ttf}"
output_file="$repo_root/docs/fonts/lxgw-wenkai-screen-subset.woff2"
cache_file="$repo_root/.cache/font-corpus.sha256"
tmp_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

if [[ ! -x "$repo_root/.venv/bin/pyftsubset" ]]; then
  echo "Install requirements-dev.txt before rebuilding the font." >&2
  exit 1
fi

if [[ ! -f "$font_file" ]]; then
  echo "Font file not found: $font_file" >&2
  exit 1
fi

# 语料只扫 docs 下的 md（正文已全覆盖），避免依赖 site 构建结果
find "$repo_root/docs" -type f -name '*.md' -exec cat {} + > "$tmp_dir/corpus.txt"
corpus_hash="$(sha256sum "$tmp_dir/corpus.txt" | cut -d' ' -f1)"

if [[ -f "$cache_file" ]] && [[ "$(cat "$cache_file")" == "$corpus_hash" ]] && [[ -f "$output_file" ]]; then
  echo "No new characters since last build, skipping font subset."
else
  echo "Using $font_file"
  "$repo_root/.venv/bin/pyftsubset" "$font_file" \
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
  echo "$corpus_hash" > "$cache_file"
  echo "Built $output_file"
fi

# 本地增量构建（CI 部署时全量 --clean，本地残留页面不影响发布）
"$repo_root/.venv/bin/zensical" build
echo "Site build finished"