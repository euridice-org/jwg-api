# Josh's Windows Build Environment Notes

This document tracks the setup and configuration history for building the EURIDICE FHIR IG on Josh's Windows 11 development environment.

**For general Windows setup instructions, see: [`../build-notes.md`](../build-notes.md)**

---

## Current Environment Status

**✅ DOCKER BUILD WORKING!**

### Environment Details
- **Machine:** EPIC114702 / Windows 11
- **WSL Version:** WSL 2
- **Distribution:** Ubuntu-24.04
- **User:** root (default)
- **Docker:** docker.io v28.2.2 (native in WSL)
- **Repository:** `~/src/jwg-api` (jp branch)
- **Working Directory:** `/root/src/jwg-api`

### Current Architecture
```
Windows 11 (EPIC114702)
  └─> WSL 2 (Ubuntu 24.04)
      ├─> docker.io package (v28.2.2-0ubuntu1~24.04.1)
      ├─> dockerd running as PID 7220
      ├─> Repository: ~/src/jwg-api
      └─> Cache: ~/.fhir/packages/ (1.8GB)
```

### Performance Metrics
- **First build:** ~1h 23min (with full package download)
- **Cached builds:** 3-5 minutes
- **Latest build:** 4m 47s (verified 2026-01-05)
- **Cache size:** 1.8GB in `~/.fhir/packages/`
- **Memory usage:** 4-6GB peak (6GB allocated)

### Access Methods
- **WSL Terminal:** `wsl -d Ubuntu-24.04 -u root`
- **Windows Explorer:** `\\wsl$\Ubuntu-24.04\root\src\jwg-api`
- **VS Code:** Remote-WSL extension (`code .` from WSL)

---

## Setup History

### Session 1: Initial Exploration (Rancher Desktop)
**Date:** 2025-12-xx

**Actions:**
- Installed Ubuntu-24.04 in WSL 2
- Explored Rancher Desktop approach
- Encountered Rancher Desktop UI issues
- Decided on WSL filesystem approach (`~/src/` not `/mnt/c/`)

**Outcome:** Decided to try Rancher Desktop after restart

### Session 2: Rancher Desktop Setup (Initial Success)
**Date:** 2025-12-xx

**Actions:**
- Restarted computer (fixed Rancher Desktop UI)
- Configured Rancher Desktop WSL integration for Ubuntu-24.04
- Verified Docker working with hello-world test
- Cloned repo to `~/src/jwg-api` (jp branch)
- Configured git with jpriebe-epic account
- Fixed `startDockerPublisher.sh` shebang: `#!/bin/sh` → `#!/bin/bash`
- Added `--user root` to Docker command for WSL compatibility
- Set full permissions: `chmod -R 777 . ~/.fhir`
- **First successful Docker build!**
  - Build time: ~1h 23min
  - Downloaded 1.8GB FHIR packages
  - Output verified: `output/qa.html` (712K) exists
  - Exit code: 0

**Key Fixes Applied:**
1. **Shebang fix:** Changed from `#!/bin/sh` to `#!/bin/bash`
   - Reason: Script uses bash-specific `set -o pipefail`
2. **Permission fix:** Added `--user root` to docker command
   - Reason: WSL files owned by root, container needs root to write
3. **Permission fix:** `chmod -R 777` on repo and cache
   - Reason: Ensures container can read/write mounted volumes

**Outcome:** ✅ Build working with Rancher Desktop

### Session 3: Transition to docker.io (Current Setup)
**Date:** 2026-01-05

**Actions:**
- Verified Rancher Desktop approach working but wanted simpler setup
- Installed docker.io package directly in WSL: `apt install docker.io`
- Started dockerd manually: `dockerd > /var/log/dockerd.log 2>&1 &`
- Removed dependency on Rancher Desktop
- **Cached build verified working!**
  - Build time: 4m 47s
  - Using existing 1.8GB cache
  - QA report: 19 errors, 54 warnings (expected)
  - 1658 HTML files generated
  - Exit code: 0

**Rationale for Change:**
- Simpler - no Windows software required
- Direct control of Docker daemon
- Lighter weight
- Both approaches work identically

**Outcome:** ✅ docker.io approach verified, now primary method

---

## Script Modifications

### startDockerPublisher.sh Changes

**1. Shebang fix:**
```bash
# Before:
#!/bin/sh

# After:
#!/bin/bash
# Updated shebang from /bin/sh to /bin/bash for better compatibility
```

**2. Added --user root:**
```bash
docker_args=(--name "$instance_name" --rm)

# Added this line:
# Run container as root user to avoid file permission issues on Linux
docker_args+=(--user root)
```

**Why these changes are needed:**
- **Shebang:** Script uses `set -o pipefail` which is bash-specific
- **--user root:** WSL files owned by root (UID 0), container must match

**Status:** Both changes committed to jp branch

---

## Daily Workflow

### Starting Work

```bash
# From Windows, open WSL as root
wsl -d Ubuntu-24.04 -u root

# Start Docker daemon (if not running)
docker ps 2>/dev/null || dockerd > /var/log/dockerd.log 2>&1 &

# Navigate to repo
cd ~/src/jwg-api

# Optional: Open in VS Code
code .
```

### Building

```bash
# Quick build
./startDockerPublisher.sh

# Timed build (for performance testing)
time ./startDockerPublisher.sh

# View results in Windows browser
explorer.exe output/qa.html
explorer.exe output/index.html
```

### Git Workflow

```bash
# Check status
git status

# Make changes, then commit
git add .
git commit -m "Description of changes"
git push origin jp

# Note: Using jpriebe-epic account (configured at repo level)
```

---

## Issues Encountered & Solutions

### Issue 1: Script Shebang Incompatibility
**Symptom:** `set: Illegal option -o pipefail`

**Cause:** Script had `#!/bin/sh` but used bash syntax

**Solution:** Changed to `#!/bin/bash`
```bash
sed -i "1s|#!/bin/sh|#!/bin/bash|" startDockerPublisher.sh
```

### Issue 2: Docker Mount Permission Errors
**Symptom:**
```
mkdir: cannot create directory './input-cache': Permission denied
cp: cannot create regular file '_build.sh': Permission denied
EACCES: permission denied, mkdir 'fsh-generated/resources'
```

**Cause:** Permission mismatch between container and WSL filesystem

**Solution:**
1. Run container as root: `--user root` in docker command
2. Set full permissions on repo: `chmod -R 777 ~/src/jwg-api`
3. Set full permissions on cache: `chmod -R 777 ~/.fhir`

### Issue 3: Rancher Desktop UI Not Opening
**Symptom:** Taskbar icon present, no window, no menu

**Solution:** Computer restart fixed it

### Issue 4: Ubuntu Stopped When Rancher Desktop Started
**Symptom:** "Error managing distribution Ubuntu-24.04"

**Cause:** Ubuntu was stopped when Rancher tried to integrate

**Solution:**
```bash
wsl -d Ubuntu-24.04 echo "test"  # Start Ubuntu first
# Then enable WSL integration in Rancher Desktop settings
```

---

## Environment-Specific Configuration

### Git Configuration (Repo-level)
```bash
cd ~/src/jwg-api
git config user.name "Josh Priebe"
git config user.email "jpriebe@epic.com"
```

### Docker Daemon Startup
```bash
# Manual startup (current method)
dockerd > /var/log/dockerd.log 2>&1 &

# Check if running
docker ps

# Or auto-start on WSL open (add to ~/.bashrc):
if ! docker ps > /dev/null 2>&1; then
    sudo dockerd > /var/log/dockerd.log 2>&1 &
    sleep 3
fi
```

### File Permissions (Applied Once)
```bash
cd ~/src/jwg-api
chmod -R 777 .
chmod -R 777 ~/.fhir
```

---

## Build Verification Tests

### Test 1: First Full Build (Session 2)
```bash
./startDockerPublisher.sh
```
- **Duration:** ~1h 23min
- **Downloaded:** 1.8GB FHIR packages
- **Output:** qa.html (712K), 1658 HTML files
- **Result:** ✅ Success

### Test 2: Cached Build (Session 3)
```bash
time ./startDockerPublisher.sh
```
- **Duration:** 4m 47s
- **Cache used:** 1.8GB from ~/.fhir/packages/
- **Output:** qa.html (711K), 1658 HTML files
- **Result:** ✅ Success

### Test 3: Current Status Verification (2026-01-05)
```bash
# Check Docker
docker version
# Client: 28.2.2, Server: 28.2.2 ✅

# Check dockerd
ps aux | grep dockerd
# PID 7220 running ✅

# Check repo
ls -lh output/qa.html
# 711K file exists ✅

# Check cache
du -sh ~/.fhir/packages
# 1.8GB cached ✅
```

---

## Quick Reference Commands

### Docker Management
```bash
# Check if dockerd is running
docker ps

# Start dockerd
dockerd > /var/log/dockerd.log 2>&1 &

# Check dockerd process
ps aux | grep dockerd

# View dockerd logs
tail -f /var/log/dockerd.log
```

### Build Commands
```bash
# Standard build
./startDockerPublisher.sh

# Timed build
time ./startDockerPublisher.sh

# With custom options
PUBLISHER_JAVA_TOOL_OPTIONS="-Xmx8g" ./startDockerPublisher.sh
```

### Cache Management
```bash
# View cache size
du -sh ~/.fhir/packages

# List cached packages
ls -lh ~/.fhir/packages

# Clear cache (force re-download)
rm -rf ~/.fhir/packages/*

# Clear build artifacts
rm -rf output temp template fsh-generated
```

### File Access
```bash
# Open in Windows Explorer
explorer.exe .
explorer.exe output/qa.html

# Open in VS Code
code .

# View from Windows
# Navigate to: \\wsl$\Ubuntu-24.04\root\src\jwg-api
```

---

## Performance Benchmarks

### Build Times
| Build Type | Duration | Cache State | Date |
|------------|----------|-------------|------|
| First build (Rancher) | 1h 23min | Empty | 2025-12-xx |
| Cached build (docker.io) | 4m 47s | Full (1.8GB) | 2026-01-05 |
| Cached build (docker.io) | 3m 49s | Full (1.8GB) | 2026-01-05 |

### Memory Usage
- **Allocated:** 6GB Java heap (`-Xmx6g`)
- **Typical usage:** 3-4GB
- **Peak usage:** 5GB during validation

### Cache Statistics
- **Location:** `~/.fhir/packages/`
- **Size:** 1.8GB (compressed FHIR packages)
- **Impact:** Reduces build from ~1h to 3-5 min
- **Packages:** ~50 FHIR package versions

---

## Troubleshooting Tips for This Environment

### dockerd Won't Start
```bash
# Check if already running
docker version

# Kill existing daemon
pkill dockerd

# Start fresh
dockerd > /var/log/dockerd.log 2>&1 &
tail -f /var/log/dockerd.log  # Watch for errors
```

### Permission Errors Reappear
```bash
# Re-apply permissions
cd ~/src/jwg-api
chmod -R 777 .
chmod -R 777 ~/.fhir
```

### Build Hangs or Slows Down
```bash
# Check if building from Windows filesystem (slow!)
pwd
# Should show: /root/src/jwg-api
# NOT: /mnt/c/...

# Check disk space
df -h ~

# Check memory
free -h
```

### Can't Access Files from Windows
```bash
# Ensure WSL distribution is running
wsl -l -v
# Should show Ubuntu-24.04 as "Running"

# Access via Windows Explorer:
# \\wsl$\Ubuntu-24.04\root\src\jwg-api
```

---

## Future Enhancements

### Potential Improvements
1. Auto-start dockerd on WSL startup (add to `~/.bashrc` or `/etc/wsl.conf`)
2. Create shell alias: `alias igbuild='cd ~/src/jwg-api && ./startDockerPublisher.sh'`
3. Setup VS Code launch tasks for build
4. Consider systemd service for dockerd (if WSL systemd enabled)

### Documentation To-Do
- [ ] Submit PR for `startDockerPublisher.sh` shebang fix
- [x] Document Windows setup in main build-notes.md
- [x] Create environment-specific notes (this file)
- [ ] Test Rancher Desktop approach on another machine

---

## Notes & Observations

### What Works Well
✅ docker.io approach is simple and reliable
✅ WSL filesystem provides good I/O performance
✅ Persistent cache works perfectly (1.8GB cached)
✅ 3-5 minute builds with cache are very usable
✅ VS Code Remote-WSL integration is seamless

### What Could Be Better
⚠️ Must manually start dockerd each WSL session
⚠️ First build takes 1h+ (unavoidable - large download)
⚠️ chmod 777 is permissive (acceptable for personal dev env)

### Comparison: Rancher Desktop vs docker.io
| Feature | Rancher Desktop | docker.io |
|---------|----------------|-----------|
| Setup complexity | Higher | Lower |
| Windows software | Required | None |
| Auto-start | Yes | No |
| Control | GUI | CLI only |
| Performance | Same | Same |
| **Recommendation** | GUI users | CLI users ✅ |

---

**Last Updated:** 2026-01-05 14:45 UTC
**Current Branch:** jp
**Last Commit:** 71df5c3 (windows build)
**Build Status:** ✅ Working (4m 47s cached builds)
**Environment:** docker.io v28.2.2 in WSL 2
