# CLAUDE.md - Claude Code Configuration

## Project Overview

FHIR Implementation Guide for EU Health Data API (EURIDICE) - co-branded HL7 Europe / IHE Europe specification for EHDS EHR interoperability.

## Build Commands

```bash
# Local build (Docker required)
./startDockerPublisher.sh

# Output location
open output/index.html
open output/qa.html
```

## CI Build (build.fhir.org)

Builds are triggered automatically on push. Published at:
- **Main branch**: https://build.fhir.org/ig/euridice-org/jwg-api/
- **Feature branches**: https://build.fhir.org/ig/euridice-org/jwg-api/branches/{branch}/

### Check Build Logs

```bash
# Build log (full output)
curl https://build.fhir.org/ig/euridice-org/jwg-api/branches/jp/build.log

# Just the end (timing + errors)
curl -s https://build.fhir.org/ig/euridice-org/jwg-api/branches/jp/build.log | tail -20

# Failure log (only exists if build aborted)
curl https://build.fhir.org/ig/euridice-org/jwg-api/branches/jp/failure/build.log
```

### Build Status

- QA Report: https://build.fhir.org/ig/euridice-org/jwg-api/branches/jp/qa.html
- Typical build time: ~15-17 minutes

## Key Directories

- `input/pagecontent/` - Markdown narrative pages
- `input/fsh/` - FSH definitions (profiles, capabilitystatements, valuesets)
- `ig-template/` - Custom IG template overrides
- `josh/plans/` - Implementation plans (gitignored from repo)

## Markdown Conventions

- **No H1 headings** in pagecontent markdown - titles come from sushi-config.yaml
- Use `###` for top-level sections (renders as H3, numbered X.1.1, X.1.2)
- Use `####` for subsections (renders as H4, numbered X.1.1.1)

## Known Issues

See `open-issues.md` for documented known issues acceptable for wide review.
