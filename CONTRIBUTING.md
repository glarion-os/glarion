# Contributing to Glarion

## Bug reports

Open an issue with:

- Your hardware (CPU/GPU at minimum — Glarion targets all-AMD systems)
- The image version (`just status` shows it)
- What you expected and what happened

Display and gaming issues especially benefit from knowing the exact monitor
connection (HDMI vs USB-C/DisplayPort) — see the known limitations in the README.

## Pull requests

- Keep changes small and focused — one concern per PR
- Test by building the image locally (see "Building from source" in the README)
  and, where practical, rebasing a test machine onto your build
- For anything structural (base image, gaming layer, update mechanics), open an
  issue to discuss before investing significant work

## Principles

Every decision in the stack is a conscious choice, not an inherited default.
If you're proposing to lift something from another distribution, explain what it
does and why Glarion should adopt it — "upstream does it" is context, not a reason.
