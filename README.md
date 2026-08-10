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

## Rebuild the web font

The site uses Roboto for Latin text and a content-specific subset of LXGW
WenKai GB Screen for Chinese text. Rebuild the subset after adding transcripts
that contain new Chinese characters:

```bash
.venv/bin/python -m pip install -r requirements-dev.txt
./build-font.sh
```

Place the original TTF at `fonts/LXGWWenKaiGBScreen.ttf` before rebuilding the
subset. The `fonts/` directory is ignored by Git. Set `TRANSCRIPTS_FONT_FILE`
to use another local font file.

The original font is licensed under the SIL Open Font License 1.1. A copy is
included at `docs/fonts/OFL-LXGW-WenKai-Screen.txt`.
