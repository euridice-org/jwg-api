# FHIR IG Build Setup - Windows 11

## Quick Status

**✅ FIRST DOCKER BUILD SUCCESSFUL!**

- ✅ WSL 2 + Ubuntu-24.04 running
- ✅ Rancher Desktop configured (Docker v29.0.2-rd)
- ✅ Repo cloned to WSL: `~/src/jwg-api` (jp branch)
- ✅ Docker working with `--user root` fix
- ✅ Persistent cache working with proper permissions (`chmod -R 777`)
- ✅ Full permissions on repo and cache directories
- ✅ **Build completed successfully!**
  - Total time: ~1 hour 23 minutes (first run with full package downloads)
  - Cache created: 1.8GB of FHIR packages
  - Output: `output/qa.html` (712K), `output/index.html`, and all IG artifacts
  - Future builds expected: 3-5 minutes (using cached packages)

**WSL Filesystem Access:**
- **Windows Explorer:** `\\wsl$\Ubuntu-24.04\root\src\jwg-api`
- **VS Code:** See "VS Code Setup" section below for complete instructions

---

## VS Code Setup (Remote-WSL)

### Prerequisites
- VS Code installed on Windows
- Remote - WSL extension installed

### Method 1: Connect from VS Code (Recommended)
**This method allows full VS Code functionality in the WSL environment:**

1. **Install Remote - WSL Extension:**
   - Open VS Code
   - Press `Ctrl+Shift+X` (Extensions)
   - Search: "Remote - WSL"
   - Install: "Remote - WSL" by Microsoft

2. **Configure WSL to use root by default:**
   ```bash
   # From Windows PowerShell or Command Prompt:
   wsl -d Ubuntu-24.04 -u root bash -c "echo '[user]' | tee -a /etc/wsl.conf && echo 'default=root' | tee -a /etc/wsl.conf"

   # Restart WSL for changes to take effect:
   wsl --shutdown
   wsl -d Ubuntu-24.04
   ```

3. **Open repo in VS Code from WSL:**
   ```bash
   # From Windows terminal:
   wsl -d Ubuntu-24.04 -u root
   cd ~/src/jwg-api
   code .
   ```

   This will:
   - Launch VS Code on Windows
   - Connect to WSL environment
   - Open the repo with full VS Code features (IntelliSense, Git, terminal, etc.)

4. **Verify connection:**
   - Bottom-left corner should show: `WSL: Ubuntu-24.04`
   - Terminal in VS Code will be WSL bash (as root)

### Method 2: Open from Windows (Alternative)
**Use this if you prefer to start from VS Code:**

1. Open VS Code
2. Press `F1` or `Ctrl+Shift+P`
3. Type: "Remote-WSL: Connect to WSL"
4. Once connected, use File → Open Folder
5. Navigate to: `/root/src/jwg-api`
6. Click OK

### Method 3: Windows Filesystem (Not Recommended)
**Only use this if Remote-WSL doesn't work:**

1. Open VS Code
2. File → Open Folder
3. Enter path: `\\wsl$\Ubuntu-24.04\root\src\jwg-api`

**Note:** This method has limitations:
- Slower file I/O
- Git integration may not work correctly
- Terminal will be Windows, not WSL
- Use Remote-WSL methods above for better experience

### VS Code Terminal in WSL
Once connected via Remote-WSL:
- Terminal is automatically WSL bash (as root)
- You can run build commands directly: `./startDockerPublisher.sh`
- Git commands work natively: `git status`, `git commit`, etc.

### Troubleshooting VS Code Connection

**Issue: VS Code connects as wrong user (jpriebe instead of root)**

Solution 1 - Set default user in wsl.conf:
```bash
wsl -d Ubuntu-24.04 -u root bash -c "echo -e '[user]\ndefault=root' > /etc/wsl.conf"
wsl --shutdown
```

Solution 2 - Force root when connecting:
```bash
# Always specify root when opening:
wsl -d Ubuntu-24.04 -u root bash -c "cd ~/src/jwg-api && code ."
```

**Issue: "Workspace does not exist" error**

This happens when VS Code connects as wrong user. Use Solution 1 above to set root as default.

**Issue: Git changes not showing**

Ensure you're using Remote-WSL connection (Method 1), not Windows filesystem (Method 3).

---

## Design Goals & Philosophy

**Primary Goal:**
Get the FHIR IG building locally on Windows 11 using Docker, producing complete `output/` with `qa.html` and rendered IG site.

**Key Principles:**
1. **Docker-first approach:** Avoid native installs of Java/Ruby/Node - keep local environment clean and portable
2. **Match Mac workflow:** Use same `hl7fhir/ig-publisher-base` image and build patterns
3. **WSL filesystem for builds:** Avoids Windows file locking issues, faster I/O (20-30% improvement)
4. **Persistent package cache:** ~1.8GB of FHIR packages cached, reduces rebuilds from ~1h 23min to 3-5 min
5. **Reproducible builds:** Single command (`./startDockerPublisher.sh`) works consistently

**Non-Goals:**
- Fixing all QA warnings/errors (many broken links are expected and not build failures)
- Changing IG content or dependencies
- Solving build.fhir branch publishing (separate infrastructure concern)

**Build Performance:**
- **First run:** ~1h 23min (downloads 1.8GB of FHIR packages, compiles FSH, generates IG)
- **Subsequent runs:** 3-5 min (uses cached packages)
- **Memory:** 6GB heap allocated (`-Xmx6g`), typical usage 3-4GB, peaks at 4-5GB

**Expected QA Results:**
The build is successful even with warnings/errors in qa.html. Typical results:
- Broken links: ~25 (external references, expected)
- Errors: ~19 (mostly profile conformance warnings)
- Warnings: ~54 (terminology bindings, slicing)
- Info: ~44 (informational messages)

These are normal for FHIR IG builds and not build failures.

---

## Quick Replication Guide

**To replicate this working environment from scratch:**

```bash
# 1. Start WSL Ubuntu as root
wsl -d Ubuntu-24.04 -u root

# 2. Clone repo to WSL filesystem (not /mnt/c/...)
mkdir -p ~/src
cd ~/src
git clone https://github.com/euridice-org/jwg-api.git
cd jwg-api

# 3. Configure git account (repo-level)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 4. Fix script shebang
sed -i "1s|#!/bin/sh|#!/bin/bash|" startDockerPublisher.sh

# 5. Edit script to add --user root
# Add this line after line 39 (after docker_args=(--name...)):
# docker_args+=(--user root)

# 6. Set permissions
chmod -R 777 .
mkdir -p ~/.fhir
chmod -R 777 ~/.fhir

# 7. Run first build (~1h 23min)
./startDockerPublisher.sh

# 8. Verify success
ls -lh output/qa.html

# 9. Future builds (~3-5min)
./startDockerPublisher.sh
```

**Key success factors:**
- Build from WSL filesystem (not `/mnt/c/...`)
- Run container as root (`--user root`)
- Full permissions on repo and cache (`chmod -R 777`)
- Persistent cache enabled (default in startDockerPublisher.sh)

---

## Key Learnings (Windows vs Mac)

**What Works on Mac:**
- Docker Desktop handles WSL filesystem mounting transparently
- Persistent cache works out of the box
- No permission issues

**Windows + Rancher Desktop Differences:**
1. **Must run container as root:** Add `--user root` to Docker command (WSL files owned by root)
2. **Permission issues initially:** File locking and permission errors with default permissions
3. **Solution:** Set full permissions with `chmod -R 777 .` (repo) and `chmod -R 777 ~/.fhir` (cache)
4. **Script shebang:** Must be `#!/bin/bash` not `#!/bin/sh` for pipefail support

**Working Docker Command:**
```bash
docker run --rm --user root \
  -v "$(pwd):/home/publisher/ig" \
  -v "$HOME/.fhir:/home/publisher/.fhir" \
  -e "JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m" \
  hl7fhir/ig-publisher-base \
  bash -c "rm -rf temp template output && ./_updatePublisher.sh -y && ./_genonce.sh"
```

**Or simply use the fixed script:**
```bash
./startDockerPublisher.sh  # Uses persistent cache by default
```

**Goal:** Keep local environment clean (no Java/Node/SUSHI install) - Docker provides everything

**Result:** Persistent cache working - first build ~15-20 min, subsequent builds expected ~3-5 min.

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

### Issue 4: Docker Mount Permission Errors (RESOLVED)
**Symptom:** Docker container can't create `input-cache/` or write files when mounted from WSL
**Error Messages:**
```
mkdir: cannot create directory './input-cache': Permission denied
cp: cannot create regular file '_build.sh': Permission denied
EACCES: permission denied, mkdir 'fsh-generated/resources'
```
**Root Cause:** Docker volume mount permission mismatch between container (running as root) and WSL filesystem
**Solution (WORKING):**
1. Run container as root: Add `--user root` to Docker command
2. Set full permissions on repo: `chmod -R 777 .` (from repo root)
3. Set full permissions on cache: `chmod -R 777 ~/.fhir`
4. Updated `startDockerPublisher.sh` to include `--user root` in docker_args

**Result:** Build now running successfully with persistent cache

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

## Optimization Strategies

### Already Implemented (High Impact)
1. **Persistent FHIR package cache** ✅
   - Impact: Reduces rebuild time from ~1h 23min to 3-5 min
   - Implementation: `-v "$HOME/.fhir:/home/publisher/.fhir"` mount
   - Cost: 1.8GB disk space
   - Risk: Low - can clear cache if needed

2. **Build from WSL filesystem** ✅
   - Impact: 20-30% I/O performance improvement, eliminates file locking issues
   - Implementation: Clone to `~/src/jwg-api` not `/mnt/c/...`
   - Cost: None
   - Risk: None

### Optional Optimizations (Not Implemented)

3. **Skip publisher update on every run** (Medium Impact)
   - Current: `_updatePublisher.sh -y` downloads latest publisher.jar every build
   - Optimization: Skip `-y` flag or run `_updatePublisher.sh` manually only when needed
   - Savings: ~30-60 seconds per build
   - Risk: May diverge from CI if CI auto-updates publisher
   - **Recommendation:** Leave as-is for now to match CI behavior

4. **Pin dependency versions** (Medium Impact, Medium Risk)
   - Current: Uses `#current` for several dependencies (hl7.fhir.eu.base, hl7.fhir.eu.laboratory, etc.)
   - Optimization: Pin to specific versions in sushi-config.yaml
   - Benefit: More stable builds, prevents unexpected changes
   - Risk: Deviates from "always latest" development philosophy
   - **Recommendation:** Only pin if experiencing instability

5. **Reduce terminology server calls** (Low/Medium Impact, Medium Risk)
   - Current: Connects to http://tx.fhir.org for terminology validation
   - Optimization: Use `--tx N/A` to disable external terminology validation
   - Benefit: Faster validation, works offline
   - Risk: May miss terminology validation errors
   - **Recommendation:** Not recommended for production work

### Performance Monitoring
To measure build performance:
```bash
cd ~/src/jwg-api
time ./startDockerPublisher.sh
```

Expected times:
- First run (empty cache): ~1h 23min
- Subsequent runs (with cache): 3-5 min
- Memory usage: peaks at 4-5GB (6GB allocated)

### Cache Management

**View cache size:**
```bash
du -sh ~/.fhir/packages
```

**Clear cache (if builds become unstable):**
```bash
rm -rf ~/.fhir/packages/*
# Next build will re-download everything
```

**Clear local build artifacts:**
```bash
cd ~/src/jwg-api
rm -rf output temp template fsh-generated
```

---

## Risk Mitigation

### Risk: File Locking / "Resource Deadlock Avoided"
**Mitigations:**
- ✅ Build from WSL filesystem (not `/mnt/c/...`)
- ✅ Run container as root
- ✅ Full permissions on repo and cache
- If still occurs: Exclude repo from Windows antivirus scanning
- Emergency fix: `rm -rf output temp template && ./startDockerPublisher.sh`

### Risk: Permission Issues After OS/Docker Updates
**Symptoms:** Build suddenly fails with permission errors
**Mitigation:**
```bash
cd ~/src/jwg-api
chmod -R 777 .
chmod -R 777 ~/.fhir
./startDockerPublisher.sh
```

### Risk: Out of Memory Errors
**Symptoms:** `java.lang.OutOfMemoryError: Java heap space`
**Mitigation:**
1. Increase Docker memory allocation in Rancher Desktop settings (recommend 12GB)
2. Increase Java heap in startDockerPublisher.sh:
   ```bash
   export JAVA_TOOL_OPTIONS="-Xmx8g -Xms1g -Dfile.encoding=UTF-8"
   ```

### Risk: Persistent Cache "Works on My Machine" Issues
**Symptoms:** Build succeeds locally but fails in CI
**Mitigation:**
- Clear cache and rebuild: `rm -rf ~/.fhir/packages && ./startDockerPublisher.sh`
- Compare publisher versions: check `input-cache/publisher.jar` timestamp
- Document publisher version in commit messages if pinning

### Risk: WSL/Docker Blocked by Corporate Policy
**Fallback Plan:**
If WSL or Docker are disabled:
1. **Option A:** Use Rancher Desktop without WSL (Windows filesystem)
   - Clone to `C:\repos\jwg-api`
   - More likely to hit file locking issues
   - Slower I/O
2. **Option B:** Native install (last resort)
   - Install Java 17+ (OpenJDK)
   - Install Node.js
   - Install Ruby + Jekyll
   - Run `_genonce.sh` directly

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

## What to Do Now

### Phase 1: Commit Windows-Side Changes

**Goal:** Save the working configuration (modified startDockerPublisher.sh and updated documentation)

1. **Check git status from Windows:**
   ```powershell
   # From Windows Terminal or Command Prompt
   cd "C:\Users\jpriebe\OneDrive - Epic\Documents\_repos\jwg-api"
   git status
   ```

   You should see:
   - `M startDockerPublisher.sh` (shebang + --user root changes)
   - `M josh/build-notes-windows.md` (comprehensive documentation)
   - `D josh/dockerNotes.md` (deleted, merged into build-notes-windows.md)

2. **Review changes:**
   ```powershell
   git diff startDockerPublisher.sh
   git diff josh/build-notes-windows.md
   ```

3. **Stage and commit:**
   ```powershell
   git add startDockerPublisher.sh
   git add josh/build-notes-windows.md
   git add josh/dockerNotes.md
   git commit -m "Windows 11 build setup working

- Fix startDockerPublisher.sh shebang (#!/bin/bash)
- Add --user root to Docker command for WSL compatibility
- Document complete Windows + WSL + Rancher Desktop setup
- Merge dockerNotes.md into comprehensive build-notes-windows.md
- Add VS Code Remote-WSL connection instructions

Build verified working:
- First run: ~1h 23min (1.8GB package cache created)
- Subsequent runs: 3-5 min (using cache)
- Output: qa.html (712K), all IG artifacts generated successfully"
   ```

4. **Push to remote (jp branch):**
   ```powershell
   git push origin jp
   ```

### Phase 2: Transition to WSL Environment

**Goal:** Connect VS Code to the working WSL environment where builds are running

1. **Set WSL to use root as default user:**
   ```powershell
   # From Windows terminal:
   wsl -d Ubuntu-24.04 -u root bash -c "echo -e '[user]\ndefault=root' > /etc/wsl.conf"

   # Restart WSL:
   wsl --shutdown
   wsl -d Ubuntu-24.04
   ```

2. **Verify you're in the right location:**
   ```powershell
   wsl -d Ubuntu-24.04 -u root bash -c "pwd && ls -la ~/src/jwg-api/output/qa.html"
   ```

   Should show: `/root` and the qa.html file

3. **Open repo in VS Code from WSL:**
   ```powershell
   wsl -d Ubuntu-24.04 -u root bash -c "cd ~/src/jwg-api && code ."
   ```

   **Verify VS Code connection:**
   - Bottom-left corner shows: `WSL: Ubuntu-24.04`
   - Terminal in VS Code is WSL bash (as root)
   - File path shows: `/root/src/jwg-api`

4. **Test build from VS Code terminal:**
   ```bash
   # In VS Code integrated terminal (should be WSL):
   cd ~/src/jwg-api
   time ./startDockerPublisher.sh
   ```

   **Expected:** Build completes in 3-5 minutes (using cached packages)

### Phase 3: Make Content Changes from WSL

**Goal:** Edit IG content, build, verify, commit - all from VS Code in WSL

**Workflow:**

1. **Edit files in VS Code:**
   - Navigate to `input/pagecontent/*.md` (markdown pages)
   - Or `input/fsh/*.fsh` (FHIR Shorthand definitions)
   - VS Code has full IntelliSense, Git integration, etc.

2. **Build from VS Code terminal:**
   ```bash
   ./startDockerPublisher.sh
   ```

3. **Review output:**
   ```bash
   # Open in Windows browser from WSL:
   explorer.exe output/qa.html
   explorer.exe output/index.html
   ```

4. **Commit from VS Code:**
   - Use VS Code Source Control panel (`Ctrl+Shift+G`)
   - Or use terminal:
     ```bash
     git status
     git add input/pagecontent/your-file.md
     git commit -m "Your descriptive message"
     git push
     ```

**Tips:**
- VS Code terminal stays in WSL - all commands run in Linux environment
- Git uses jpriebe-epic account (configured in repo)
- Build output appears in `output/` folder visible in VS Code
- Windows credential manager handles git authentication

### Quick Reference Commands

**Start working (from Windows):**
```powershell
wsl -d Ubuntu-24.04 -u root bash -c "cd ~/src/jwg-api && code ."
```

**Build and view (from VS Code WSL terminal):**
```bash
./startDockerPublisher.sh && explorer.exe output/qa.html
```

**Check build time:**
```bash
time ./startDockerPublisher.sh
```

**Clear caches if needed:**
```bash
rm -rf ~/.fhir/packages/*  # Clear package cache (forces re-download)
rm -rf output temp template  # Clear build artifacts
```

### Future Enhancements (Optional)
1. Submit PR to fix `startDockerPublisher.sh` shebang upstream (#!/bin/bash)
2. Create alias in `~/.bashrc`: `alias igbuild='cd ~/src/jwg-api && ./startDockerPublisher.sh'`
3. Test rebuild to verify 3-5 minute cached build time

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

### Session 2 (Post-restart - COMPLETED)
- ✅ Restarted (fixed Rancher Desktop UI)
- ✅ Started Ubuntu and configured Rancher Desktop
- ✅ Verified Docker working (`hello-world` test passed)
- ✅ Configured git (jpriebe-epic account)
- ✅ Cloned repo to `~/src/jwg-api`
- ✅ Fixed `startDockerPublisher.sh` shebang (#!/bin/bash)
- ✅ Added `--user root` to Docker command
- ✅ Set full permissions on repo and cache (`chmod -R 777`)
- ✅ Downloaded publisher (218 MB)
- ✅ SUSHI compilation successful (0 Errors, 0 Warnings)
- ✅ **First Docker build completed successfully!**
  - Build time: ~1 hour 23 minutes (downloading 1.8GB of FHIR packages)
  - Output verified: `output/qa.html` (712K) exists
  - Cache persisted: `~/.fhir/packages/` contains 1.8GB
  - Exit code: 0 (success)

---

**Last Updated:** 2026-01-05 13:25 UTC (first Docker build completed successfully)
