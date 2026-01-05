# FHIR IG Build Setup - Windows 11

## Quick Status

**🔄 FIRST DOCKER BUILD IN PROGRESS**

- ✅ WSL 2 + Ubuntu-24.04 running
- ✅ Rancher Desktop configured (Docker v29.0.2-rd)
- ✅ Repo cloned to WSL: `~/src/jwg-api` (jp branch)
- ✅ Docker working with `--user root` fix
- ✅ Using tmpfs for cache (no persistent cache for now)
- 🔄 **First build running** (expected: 10-15 minutes)

**WSL Filesystem Access:**
- **Windows Explorer:** `\\wsl$\Ubuntu-24.04\root\src\jwg-api`
- **VS Code:** Install "Remote - WSL" extension, then `code .` from WSL

---

## Key Learnings (Windows vs Mac)

**What Works on Mac:**
- Docker Desktop handles WSL filesystem mounting transparently
- Persistent cache works out of the box
- No permission issues

**Windows + Rancher Desktop Differences:**
1. **Must run container as root:** Add `--user root` to Docker command (WSL files owned by root)
2. **Cache locking issues:** Persistent cache (`-v ~/.fhir:/home/publisher/.fhir`) causes file locking errors
3. **Solution for now:** Use tmpfs (`--tmpfs /home/publisher/.fhir`) - no persistent cache
4. **Script shebang:** Must be `#!/bin/bash` not `#!/bin/sh` for pipefail support

**Working Docker Command:**
```bash
docker run --rm --user root \
  -v "$(pwd):/home/publisher/ig" \
  --tmpfs /home/publisher/.fhir \
  -e "JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m" \
  hl7fhir/ig-publisher-base \
  bash -c "rm -rf temp template output && ./_updatePublisher.sh -y && ./_genonce.sh"
```

**Goal:** Keep local environment clean (no Java/Node/SUSHI install) - Docker provides everything

**Future Optimization:** Fix persistent cache (Docker named volumes or different mount options) - but 10min builds are acceptable for now. **Priority is getting a working build first.**

---

## Overview

Setting up `euridice-org/jwg-api` FHIR IG build on Windows 11 using **Rancher Desktop + WSL 2 + Ubuntu**.

### Project Context
- **Project:** EURIDICE API Specification (HL7 Europe / IHE Europe)
- **Purpose:** FHIR IG for EHDS EHR Interoperability Component
- **Package:** `hl7.fhir.eu.euridice-api` v0.1.0
- **Build tools:** SUSHI (FSH → FHIR) + IG Publisher (Java-based)
- **Expected output:** `output/qa.html` (QA report), `output/index.html` (IG website)

---

## Setup Completed

### 1. WSL 2 + Ubuntu
- **Status:** ✅ Configured and running
- **Distribution:** Ubuntu-24.04 (WSL 2)
- **User:** root (default)
- **Location:** `\\wsl$\Ubuntu-24.04\root\src\jwg-api`

### 2. Rancher Desktop
- **Status:** ✅ Configured and working
- **Version:** Docker v29.0.2-rd
- **Why Rancher:** Docker Desktop requires paid license at Epic (under review, ID 2028). Rancher Desktop approved (ID 3070, Apache 2.0)
- **Configuration:**
  - Container engine: dockerd (moby) ✅
  - WSL integration: Enabled for Ubuntu-24.04 ✅
  - Docker commands working: `docker run hello-world` passed ✅

### 3. Repository
- **WSL Location:** `~/src/jwg-api`
- **Windows Path:** `\\wsl$\Ubuntu-24.04\root\src\jwg-api`
- **Branch:** `jp` (commit 6b1561a)
- **Git Config:** jpriebe-epic account (repo-level)
- **Remote:** https://github.com/euridice-org/jwg-api

### 4. IG Publisher
- **Status:** ✅ Downloaded to `input-cache/publisher.jar`
- **Size:** 218 MB
- **Method:** Ran `_updatePublisher.sh -y` directly in WSL

---

## Issues & Solutions

### Issue 1: Rancher Desktop UI Not Opening
**Symptom:** Taskbar icon present, but no window, no right-click menu
**Solution:** Computer restart fixed this

### Issue 2: Ubuntu Stopped When Rancher Desktop Started
**Symptom:** "Error managing distribution Ubuntu-24.04: kubeconfig: wsl.exe exited with code 1"
**Root Cause:** Ubuntu-24.04 was stopped when Rancher Desktop tried to integrate
**Solution:**
```bash
wsl -d Ubuntu-24.04 echo "test"  # Start Ubuntu
# Then enable WSL integration in Rancher Desktop settings
```

### Issue 3: Script Shebang Incompatibility
**Symptom:** `set: Illegal option -o pipefail` error from `startDockerPublisher.sh`
**Root Cause:** Script had `#!/bin/sh` but used bash-specific syntax (`-o pipefail`)
**Solution:** Changed shebang to `#!/bin/bash`
```bash
sed -i "1s|#!/bin/sh|#!/bin/bash|" startDockerPublisher.sh
```
**Action Item:** Submit PR to fix this upstream

### Issue 4: Docker Mount Permission Errors (CURRENT)
**Symptom:** Docker container can't create `input-cache/` or write files when mounted from WSL
**Error Messages:**
```
mkdir: cannot create directory './input-cache': Permission denied
cp: cannot create regular file '_build.sh': Permission denied
```
**Root Cause:** Docker volume mount permission mismatch between container and WSL filesystem
**Workaround Options:**
1. **Install Java in WSL** and run `_genonce.sh` directly (no Docker)
2. **Fix Docker mount** with proper user mapping (needs investigation)
3. **Use different Docker mount options** (e.g., `:z` suffix for SELinux contexts)

---

## Known Working Patterns (from Mac)

These patterns work successfully on Mac and should guide Windows solution:

### Docker Command Pattern
```bash
docker run --rm \
  -v "$(pwd):/home/publisher/ig" \
  -v "$HOME/.fhir:/home/publisher/.fhir" \
  -e "JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m" \
  hl7fhir/ig-publisher-base \
  bash -c "rm -rf temp template output && ./_updatePublisher.sh -y && ./_genonce.sh"
```

### Key Success Factors
- **Persistent cache:** Mount `~/.fhir` to avoid re-downloading packages (several GB)
- **Memory:** Allocate 6GB heap (`-Xmx6g`), Docker needs 8-12GB total
- **Clean build:** Remove `temp`, `template`, `output` before building
- **File locking:** Build from Linux filesystem (not `/mnt/c/...`) to avoid Windows FS issues

### Build Artifacts
- `output/qa.html` - Primary success indicator (QA report)
- `output/index.html` - IG landing page
- `fsh-generated/` - SUSHI-generated FHIR resources
- `input-cache/` - Downloaded publisher.jar (218MB)
- `~/.fhir/packages/` - FHIR package cache (several GB, reused across builds)

### Performance Expectations
- **First build:** 10-20 minutes (downloads packages, compiles FSH, generates IG)
- **Subsequent builds:** 3-5 minutes (uses cached packages)
- **Known quirks:**
  - Docker image entrypoint clones `ig-publisher-scripts` and installs `fsh-sushi` every run
  - Many broken link warnings expected in QA (not build failures)
  - "Internal error in IG ihe.pharm.mpd..." logs are noisy but non-fatal

---

## Build Options

### Option A: Docker Build (Preferred - needs fix)
**Pros:** Isolated environment, matches Mac/CI, no local Java install
**Cons:** Currently has mount permission issues
**Status:** ⚠️ Blocked - needs permission fix

```bash
cd ~/src/jwg-api
./startDockerPublisher.sh
# OR custom command with explicit options
```

### Option B: Direct WSL Build (Workaround)
**Pros:** Avoids Docker mount issues, faster iteration
**Cons:** Requires Java install in Ubuntu, diverges from Mac pattern
**Status:** ⏳ Ready once Java installed

```bash
# Install Java in Ubuntu
sudo apt update && sudo apt install -y openjdk-17-jdk

# Run build
cd ~/src/jwg-api
./_genonce.sh

# View results
explorer.exe output/qa.html
```

### Option C: Native Windows Build (Last Resort)
**Pros:** No Docker/WSL complexity
**Cons:** High setup cost (Java, Ruby/Jekyll, Node, SUSHI), slower I/O, file locking issues
**Status:** ❌ Not recommended

---

## Caching Strategy (Critical for Performance)

### FHIR Package Cache
**Location (Mac):** `~/.fhir/packages/`
**Location (WSL):** `~/.fhir/packages/` (or `/root/.fhir/packages/`)
**Size:** Several GB
**Impact:** **HIGH** - Saves 5-10 minutes per build by not re-downloading packages

**Docker mount:**
```bash
-v "$HOME/.fhir:/home/publisher/.fhir"
```

**⚠️ DON'T USE:** `--tmpfs /home/publisher/.fhir` (nukes cache every run)

### Input Cache
**Location:** `input-cache/publisher.jar`
**Size:** 218 MB
**Impact:** **MEDIUM** - `_updatePublisher.sh -y` re-downloads if missing
**Strategy:** Keep `input-cache/` between runs (already in `.gitignore`)

### Build Artifacts (Ephemeral)
**Locations:** `output/`, `temp/`, `template/`, `fsh-generated/`
**Strategy:** Can safely delete between builds. The `_genonce.sh` script starts with:
```bash
rm -rf temp template output
```

---

## Memory Configuration

### Java Heap Settings
```bash
export JAVA_TOOL_OPTIONS="-Xmx6g -Xms512m -Dfile.encoding=UTF-8"
```
- `-Xmx6g`: Maximum heap (6GB) - increase if OOM errors occur
- `-Xms512m`: Initial heap (512MB)
- Build typically uses 3-4GB, peaks at 4-5GB

### Docker Desktop Settings
- **Recommended:** 8-12GB memory allocation
- **Why:** Publisher + Jekyll + terminology server calls can be heavy
- **Settings:** Rancher Desktop → Preferences → Resources → Memory

---

## File Permissions & Ownership

### Why WSL Filesystem?
- **20-30% faster I/O** vs `/mnt/c/...` (Windows filesystem mount)
- **Fewer file locking issues** (Windows antivirus, FS semantics)
- **Better Docker volume mount performance**

### Current Ownership (WSL)
```bash
$ ls -la ~/src/jwg-api
drwxr-xr-x  root root  jwg-api/
```
- Everything owned by `root:root`
- Docker container runs as `root` (UID 0)
- **Should work** but currently doesn't due to Docker mount issue

---

## Troubleshooting

### Docker Permission Errors
**Symptoms:** `mkdir: cannot create directory`, `cp: cannot create regular file`
**Possible Causes:**
1. SELinux contexts (unlikely on Windows WSL)
2. Docker mount options need adjustment
3. Rancher Desktop specific mount behavior

**Debug Steps:**
```bash
# Check Docker mount is writable from inside container
docker run --rm -v "$(pwd):/home/publisher/ig" ubuntu bash -c "cd /home/publisher/ig && touch test.txt && ls -l test.txt"

# Check ownership
ls -la ~/src/jwg-api
```

### Out of Memory Errors
**Symptom:** `java.lang.OutOfMemoryError: Java heap space`
**Solution:** Increase heap size
```bash
export JAVA_TOOL_OPTIONS="-Xmx8g -Xms1g"
```

### Resource Deadlock Avoided
**Symptom:** Build fails with "Resource deadlock avoided" during template copying
**Causes:** File locking on Windows filesystem, aggressive antivirus scanning
**Solutions:**
1. Build from WSL filesystem (not `/mnt/c/...`) ✅ Already doing this
2. Wipe build artifacts: `rm -rf output temp template`
3. Exclude repo from antivirus scanning (if allowed)

### Slow Package Downloads
**Symptom:** First build takes 20+ minutes downloading packages
**Expected:** Yes, on first build (several GB of FHIR packages)
**Mitigation:** Mount persistent `~/.fhir` cache (see Caching Strategy)
**Verify cache:** `ls -lh ~/.fhir/packages/` should show downloaded packages after first run

---

## Daily Workflow (Once Working)

### Quick Build
```bash
# Open Ubuntu terminal (Windows Terminal or `wsl`)
cd ~/src/jwg-api

# Edit files (VS Code Remote-WSL recommended)
code .

# Run build
./startDockerPublisher.sh

# View results
explorer.exe output/qa.html
explorer.exe output/index.html
```

### Editing Options
1. **VS Code Remote-WSL** (recommended):
   - Install "Remote - WSL" extension
   - From WSL: `code .`
   - Edit with full VS Code features

2. **Windows File Explorer**:
   - Navigate to: `\\wsl$\Ubuntu-24.04\root\src\jwg-api`
   - Edit with any Windows editor

3. **Direct in WSL**:
   - Use `vim`, `nano`, etc.

### Git Workflow
```bash
cd ~/src/jwg-api

# Make changes, build, verify
./startDockerPublisher.sh
explorer.exe output/qa.html

# Commit
git add .
git commit -m "Your message"
git push

# Note: Uses jpriebe-epic account (set via repo-level config)
```

---

## Next Steps

### Immediate
1. **Fix Docker mount issue** OR install Java in Ubuntu
2. **Run successful build** and verify `output/qa.html`
3. **Document build time** (first run vs cached run)
4. **Test rebuild** (verify cache persistence)

### After First Successful Build
1. Create simple wrapper script (`dev-build.sh`) that:
   - Checks prerequisites
   - Runs build with correct options
   - Reports build time
   - Opens QA report on success

2. Submit PR to fix `startDockerPublisher.sh` shebang upstream

3. Test full workflow:
   - Edit FSH file
   - Build
   - Verify changes in `output/`
   - Commit to branch
   - Verify CI build matches

---

## Build Command Reference

### Update Publisher (Only When Needed)
```bash
cd ~/src/jwg-api
./_updatePublisher.sh -y
# Downloads latest publisher.jar to input-cache/
```

### One-Time Build
```bash
cd ~/src/jwg-api
./_genonce.sh
# Runs SUSHI + IG Publisher once
```

### Continuous Build (Watch Mode)
```bash
cd ~/src/jwg-api
./_gencontinuous.sh
# Watches for changes, rebuilds automatically
```

### Docker Build (Mac Pattern)
```bash
cd ~/src/jwg-api
docker run --rm -it \
  -v "$(pwd):/home/publisher/ig" \
  -v "$HOME/.fhir:/home/publisher/.fhir" \
  -e "JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m" \
  hl7fhir/ig-publisher-base \
  bash -c "rm -rf temp template output && ./_updatePublisher.sh -y && ./_genonce.sh"
```

### Clean Build (Fresh Start)
```bash
cd ~/src/jwg-api
rm -rf output temp template fsh-generated
./_genonce.sh
```

---

## Resources

- **Rancher Desktop:** https://rancherdesktop.io/
- **Repo:** https://github.com/euridice-org/jwg-api
- **IG Publisher:** https://github.com/HL7/fhir-ig-publisher
- **SUSHI:** https://fshschool.org/
- **WSL Docs:** https://learn.microsoft.com/en-us/windows/wsl/

---

## Session History

### Session 1 (Pre-restart)
- Installed Ubuntu-24.04 in WSL 2
- Installed Rancher Desktop (UI issue)
- Decided on WSL filesystem approach

### Session 2 (Post-restart - Current)
- ✅ Restarted (fixed Rancher Desktop UI)
- ✅ Started Ubuntu and configured Rancher Desktop
- ✅ Verified Docker working (`hello-world` test passed)
- ✅ Configured git (jpriebe-epic account)
- ✅ Cloned repo to `~/src/jwg-api`
- ✅ Fixed `startDockerPublisher.sh` shebang
- ✅ Downloaded publisher (218 MB)
- ⚠️ Hit Docker mount permission errors
- ⏳ Exploring workarounds (Java install or mount fix)

---

**Last Updated:** 2026-01-05 (mid-setup, investigating Docker mount issue)
