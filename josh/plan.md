# jwg-api onboarding plan

## Objectives
- Establish a reproducible Docker-based build for the IG.
- Capture prerequisites and fallbacks for native tooling.
- Leave breadcrumbs for future work on a feature branch.
- Track gaps so collaborators know what’s still in flight.
- Respect existing tooling/conventions so team members aren’t surprised.

## Collaboration reminders
- Note every material change in this plan (what/why) so others can follow along.
- Prefer extending current scripts/templates over inventing new ones; if the repo already has a pattern on disk, reuse it unless there’s a strong reason not to.
- Keep personal scratch files in `/josh/` (gitignored) to avoid cluttering shared history.
- Target shared work on branch `jp`; remember to authenticate with the alternate GitHub account before pushing.

## Current context
- Repo location: `/Users/joshpriebe/Documents/AI/repo/jwg-api`.
- Host architecture: `arm64` (Apple Silicon).
- Docker Desktop installed; `docker --version` → `29.1.3`, `docker run --rm hello-world` succeeds.
- `startDockerPublisher.sh` now:
  - auto-selects `linux/amd64` on arm64 hosts;
  - toggles interactive flags only when a TTY exists;
  - sets default `JAVA_TOOL_OPTIONS` to `-Xmx6g -Xms512m` (override with `PUBLISHER_JAVA_TOOL_OPTIONS`);
  - persists `/home/publisher/.fhir` by mounting host cache `~/.fhir` (override with `PUBLISHER_FHIR_CACHE_DIR` or disable via `PUBLISHER_FHIR_CACHE_MODE=tmpfs`);
  - cleans `temp/`, `template/`, and `output/` before invoking `_updatePublisher.sh -y && _genonce.sh`.

## Next steps
1. Review the latest `output/qa.html` (current run: 18 errors, 48 warnings, 12 broken links) and triage blocking issues.
   - Capture highlights plus planned fixes here so collaborators see the path forward.
2. Create working branch once we understand QA impact: `git checkout -b jp`.
   - Prompt for Git credential switch before the first `git push`.
   - Document branch purpose and remaining work in this plan.
3. Coordinate with other contributors on any planned template or tooling tweaks before committing changes.
4. Keep native-tooling fallback notes handy (_only_ if Docker path regresses).
5. Record any additional environment tweaks or secrets in `/josh/` notes so others can reproduce.

## Open questions
- Confirm whether any repo-specific environment variables or secrets are required for the publisher (none seen yet).
- Image pinning: current use of `hl7fhir/ig-publisher-base:latest` is acceptable; revisit only if builds drift.
- CI enhancements: defer until local build is green; existing GitHub Actions may already publish.
- Team helpers: monitor repo conventions; add new helper scripts only when reuse isn’t possible.

## Build notes (2026-01-03)
- First Docker run failed (`input device is not a TTY`); script now detects terminal support automatically.
- Encountered IG Publisher OOM at ~2 GB heap; default `JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m` resolves it.
- FHIR package cache persists under `~/.fhir`; clear specific packages or the whole directory when refreshing `#current` dependencies. Set `PUBLISHER_FHIR_CACHE_MODE=tmpfs` for disposable runs.
- Ant copy step conflicted with stale `temp/`/`template/` dirs; script now pre-cleans those paths.
- Successful build produces `output/index.html`, `output/qa.html`, `output/qa.json`; review QA counts above before sharing artifacts.


