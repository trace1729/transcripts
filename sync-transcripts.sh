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

transcript_count="$(find "$docs_dir" -maxdepth 1 -type f -name '*.md' ! -name index.md | wc -l)"
{
  printf '# 视频转录\n\n'
  printf '共 %s 篇。\n\n' "$transcript_count"
  while IFS= read -r -d '' path; do
    filename="${path##*/}"
    title="${filename%.md}"
    link_target="${filename//%/%25}"
    printf -- '- [%s](%s)\n' "$title" "$link_target"
  done < <(find "$docs_dir" -maxdepth 1 -type f -name '*.md' ! -name index.md -print0 | LC_ALL=C sort -z)
} > "$index_file"

echo "Mirrored $transcript_count transcripts from $source_dir to $docs_dir"
