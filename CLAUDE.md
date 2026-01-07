# Claude Code Configuration

## Git Commits

Do NOT include the Claude Code tag or Co-Authored-By lines in commit messages.

Commit messages should be clean and professional without any AI attribution.

## Build System

- Use `./startDockerPublisher.sh` to build the IG
- Build output goes to `/output/`
- QA report at `/output/qa.html`

## Private Directories

The following directories are private and should not be committed:
- `/plans/` - Working plans and notes
- `/josh/` - Personal working files
- `/old/` - Archived content

These are in `.gitignore`.

## Project Context

This is a FHIR Implementation Guide for the EU Health Data API (EURIDICE).
- Main content in `input/pagecontent/`
- FSH definitions in `input/fsh/`
- Configuration in `sushi-config.yaml`
