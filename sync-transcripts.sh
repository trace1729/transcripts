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

emit_tree() { # $1=目录绝对路径, $2=标题层级(##/###...)
  local dir="$1" heading="$2"
  while IFS= read -r -d '' path; do
    local rel="${path#$docs_dir/}"
    local filename="${path##*/}"
    local title="${filename%.md}"
    printf -- '- [%s](%s)\n' "$title" "${rel//%/%25}"
  done < <(find "$dir" -maxdepth 1 -type f -name '*.md' ! -name index.md -print0 | LC_ALL=C sort -z)
  local sub heading_next
  while IFS= read -r -d '' sub; do
    printf '\n%s %s\n\n' "$heading" "$(basename "$sub")"
    heading_next="${heading}#"
    emit_tree "$sub" "$heading_next"
  done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -print0 | LC_ALL=C sort -z)
}

{
  printf '# 视频转录\n\n'
  printf '共 %s 篇。\n\n' "$transcript_count"
  emit_tree "$docs_dir" "##"
} > "$index_file"

echo "Mirrored $transcript_count transcripts from $source_dir to $docs_dir"