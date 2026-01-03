# Publisher build runbook

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

### Success checks
- `output/index.html` and `output/qa.html` exist and open locally.
- `output/qa.html` (and `qa.json`) reflect the current error counts—note anything unexpected before publishing.
- `startDockerPublisher.sh` exits 0 with the SUSHI summary showing 0 errors/warnings.

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
- Capture the first ~50 and last ~100 lines of the console output for deeper debugging.

## CI / publisher workflow
- Main branch renders continuously at [build.fhir.org/ig/euridice-org/jwg-api/en/](https://build.fhir.org/ig/euridice-org/jwg-api/en/).
- Feature branches publish under `https://build.fhir.org/ig/euridice-org/jwg-api/branches/<branch>/` once the HL7 builder finishes. The `/branches/` index only lists branches that have produced artifacts, so new branches may take a little while to appear.
- Branch diagnostics:
  - `branches/<branch>/build.log` — full console log (200 means a build ran; 404 means no trigger).
  - `branches/<branch>/failure/build.log` — exists only when a build aborts early.
- If the log 404s, check the repo’s GitHub **Settings → Webhooks** for the `ig-commit-trigger` (or the **FHIR IG Builder** GitHub App under **Settings → Integrations → GitHub Apps**). Confirm a recent delivery for `refs/heads/<branch>` returned 200.
- To retrigger quickly, push an empty commit on the branch:
  ```sh
  git commit --allow-empty -m "Trigger IG build"
  git push
  ```
- Verify the branch output by opening `branches/<branch>/en/index.html` and comparing it to the local `output/` artifacts.

