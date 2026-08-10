# transcripts

Standalone Zensical site for video transcripts.

## Local build

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
./sync-transcripts.sh
.venv/bin/zensical build --clean
```

Set `TRANSCRIPTS_SOURCE_DIR` to override the default local transcript path.
