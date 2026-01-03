# Docker build quickstart

## Prereqs
- Docker Desktop running (`docker version`, `docker run --rm hello-world`).

## Run
```sh
./startDockerPublisher.sh
```

What the script does:
- mounts the repo at `/home/publisher/ig`;
- mounts the host cache `~/.fhir` → `/home/publisher/.fhir` so packages persist;
- wipes `temp/`, `template/`, and `output/` before building;
- runs `_updatePublisher.sh -y && _genonce.sh` inside the container with `JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m`.

Outputs appear in `output/` (`index.html`, `qa.html`, `qa.json`, etc.). Spot-check `qa.html` after each run.

## Cache hygiene
- Cache lives at `~/.fhir`; delete it (or specific packages) to refresh `#current` dependencies.
- Set `PUBLISHER_FHIR_CACHE_MODE=tmpfs` for a one-off disposable cache.
- Set `PUBLISHER_FHIR_CACHE_DIR=/path/to/cache` to redirect the cache elsewhere.

## Useful overrides
- `PUBLISHER_IMAGE=<tag>` to pin the publisher image.
- `PUBLISHER_JAVA_TOOL_OPTIONS="-Xmx8g -Xms512m"` to adjust heap.
- `PUBLISHER_COMMAND="<custom>"` if you need different build steps.
- `DOCKER_INTERACTIVE_FLAGS=` to force non-interactive logging.

## Troubleshooting
- Still downloading packages every run? Ensure `~/.fhir` exists and is writable.
- Terminology server flake: re-run (cache avoids refetching large packages).
- Stale templates or partial builds: rerun; the script clears generated folders each time.

