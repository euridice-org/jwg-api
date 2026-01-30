# FHIR IG Publisher Build Guide

This guide covers building the EURIDICE API FHIR Implementation Guide locally using Docker on both Mac and Windows.

## Quick Start

### Mac
```sh
# Ensure Docker Desktop is running
docker version

# Clone and build
git clone https://github.com/euridice-org/jwg-api.git
cd jwg-api
./startDockerPublisher.sh
```

### Windows (WSL 2)
```bash
# Start WSL as root
wsl -d Ubuntu-24.04 -u root

# Install and start Docker
apt update && apt install -y docker.io
dockerd > /var/log/dockerd.log 2>&1 &

# Clone to WSL filesystem and build
mkdir -p ~/src && cd ~/src
git clone https://github.com/euridice-org/jwg-api.git
cd jwg-api
chmod -R 777 . && mkdir -p ~/.fhir && chmod -R 777 ~/.fhir
./startDockerPublisher.sh
```

---

## Platform Setup

### Mac Setup

**Prerequisites:**
- Docker Desktop installed and running
- Git

**Setup:**
1. Install Docker Desktop from https://www.docker.com/products/docker-desktop/
2. Start Docker Desktop
3. Verify: `docker version` should show both client and server
4. Clone the repository
5. Run `./startDockerPublisher.sh`

**Expected build times:**
- First build: 10-20 minutes (downloads ~1.8GB of FHIR packages)
- Subsequent builds: 3-5 minutes (uses cached packages)

**Notes:**
- Docker Desktop handles filesystem mounting and permissions automatically
- Persistent cache at `~/.fhir/packages/` speeds up rebuilds
- No special configuration needed

---

### Windows Setup

**Prerequisites:**
- Windows 11 with WSL 2
- Ubuntu-24.04 distribution

**Architecture:**
```
Windows 11
  └─> WSL 2 (Ubuntu 24.04)
      ├─> docker.io package (v28.2.2)
      ├─> dockerd running natively in WSL
      └─> Repository in WSL filesystem (~/)
```

#### Option A: docker.io in WSL (Recommended)

**Why this approach:**
- No additional Windows software required
- Direct control of Docker daemon
- Simpler setup
- Lightweight

**Step-by-step setup:**

```bash
# 1. Open WSL Ubuntu as root
wsl -d Ubuntu-24.04 -u root

# 2. Install Docker in WSL
apt update
apt install -y docker.io

# 3. Start Docker daemon
dockerd > /var/log/dockerd.log 2>&1 &
sleep 3

# 4. Verify Docker is working
docker version
# Should show both client and server

# 5. Clone repo to WSL filesystem (NOT /mnt/c/...)
mkdir -p ~/src
cd ~/src
git clone https://github.com/euridice-org/jwg-api.git
cd jwg-api

# 6. Configure git
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 7. Set permissions (critical for WSL)
chmod -R 777 .
mkdir -p ~/.fhir
chmod -R 777 ~/.fhir

# 8. Run build
./startDockerPublisher.sh

# 9. Verify success
ls -lh output/qa.html  # Should show ~712K file
```

**Daily workflow:**
```bash
# Each time you open WSL, start Docker:
dockerd > /var/log/dockerd.log 2>&1 &

# Or check if it's running and start if needed:
docker ps 2>/dev/null || dockerd > /var/log/dockerd.log 2>&1 &

# Then build:
cd ~/src/jwg-api
./startDockerPublisher.sh
```

**Expected build times:**
- First build: ~1 hour 23 minutes (downloads 1.8GB FHIR packages)
- Subsequent builds: 3-5 minutes (uses cached packages)

#### Option B: Rancher Desktop (Alternative)

**Why this approach:**
- GUI for Docker management
- Auto-starts with Windows
- No manual daemon startup

**Setup:**
1. Install Rancher Desktop from https://rancherdesktop.io/
2. Open Rancher Desktop → Settings → WSL
3. Enable integration for "Ubuntu-24.04"
4. Restart WSL: `wsl --shutdown` then `wsl -d Ubuntu-24.04 -u root`
5. Verify: `docker version` should show both client and server
6. Follow steps 5-9 from Option A above

**Note:** Some organizations may have licensing restrictions on Docker Desktop. Rancher Desktop is a free alternative, though the docker.io approach is simpler.

#### Windows-Specific Requirements

**Why WSL filesystem?**
- 20-30% faster I/O than Windows filesystem (`/mnt/c/...`)
- Avoids file locking issues with Windows antivirus
- Better Docker volume mount performance

**Why `chmod -R 777`?**
- Docker container runs as root (UID 0)
- WSL files are owned by root
- Prevents permission errors during build

**Access from Windows:**
- **File Explorer:** `\\wsl$\Ubuntu-24.04\root\src\jwg-api`
- **VS Code:** Install "Remote - WSL" extension, run `code .` from WSL

---

## Build Script

The `./startDockerPublisher.sh` script:
- Uses `hl7fhir/ig-publisher-base` Docker image (includes Java, SUSHI, Jekyll)
- Mounts repo at `/home/publisher/ig`
- Mounts persistent cache `~/.fhir` → `/home/publisher/.fhir`
- Wipes `temp/`, `template/`, `output/` before building
- Runs `_updatePublisher.sh -y && _genonce.sh` with 6GB Java heap

### Success Indicators

✅ **Build succeeded if:**
- Exit code is 0
- `output/qa.html` exists (~712K)
- `output/index.html` exists
- SUSHI summary shows "0 Errors"

⚠️ **Expected warnings/errors in qa.html:**
- ~25 broken links (external references)
- ~19 errors (profile conformance warnings)
- ~54 warnings (terminology bindings)
- These are normal and not build failures

### Script Options

**Cache Management:**
```bash
# Default: persistent cache at ~/.fhir
./startDockerPublisher.sh

# One-time disposable cache
PUBLISHER_FHIR_CACHE_MODE=tmpfs ./startDockerPublisher.sh

# Custom cache location
PUBLISHER_FHIR_CACHE_DIR=/path/to/cache ./startDockerPublisher.sh
```

**Other Overrides:**
```bash
# Pin publisher image version
PUBLISHER_IMAGE=hl7fhir/ig-publisher-base:3.1.0 ./startDockerPublisher.sh

# Increase Java heap
PUBLISHER_JAVA_TOOL_OPTIONS="-Xmx8g -Xms1g" ./startDockerPublisher.sh

# Custom build command
PUBLISHER_COMMAND="./_genonce.sh" ./startDockerPublisher.sh

# Non-interactive mode
DOCKER_INTERACTIVE_FLAGS="" ./startDockerPublisher.sh
```

---

## Alternative Build Methods

### Manual Docker Command
```bash
docker run --rm -it --user root \
  -v "$(pwd):/home/publisher/ig" \
  -v "$HOME/.fhir:/home/publisher/.fhir" \
  -e "JAVA_TOOL_OPTIONS=-Xmx6g -Xms512m" \
  hl7fhir/ig-publisher-base \
  bash -c "rm -rf temp template output && ./_updatePublisher.sh -y && ./_genonce.sh"
```

### Direct Shell Scripts (without Docker)
```bash
# Update publisher
./_updatePublisher.sh -y

# One-time build
./_genonce.sh

# Watch mode (rebuilds on changes)
./_gencontinuous.sh
```

**Requirements for direct builds:**
- Java 17+ (OpenJDK recommended)
- Node.js and npm (for SUSHI)
- Ruby and Jekyll (for site generation)
- Not recommended - Docker approach is simpler

---

## Cache Management

### FHIR Package Cache
- **Location:** `~/.fhir/packages/`
- **Size:** ~1.8GB
- **Purpose:** Stores downloaded FHIR packages (avoid re-downloading)
- **Impact:** Reduces rebuild from ~1h to 3-5 minutes

**View cache:**
```bash
du -sh ~/.fhir/packages
ls -lh ~/.fhir/packages
```

**Clear cache (force fresh download):**
```bash
rm -rf ~/.fhir/packages/*
```

### Build Artifacts (can be deleted safely)
```bash
rm -rf output temp template fsh-generated
```

### Publisher JAR Cache
- **Location:** `input-cache/publisher.jar`
- **Size:** ~218MB
- **Updated by:** `_updatePublisher.sh -y` (runs automatically)

---

## Troubleshooting

### Mac Issues

**Docker not running:**
```bash
# Start Docker Desktop application
# Verify: docker version
```

**Out of memory:**
- Open Docker Desktop → Settings → Resources
- Increase memory to 8-12GB
- Restart Docker Desktop

### Windows Issues

**Docker not working in WSL:**
```bash
# Check if dockerd is running
docker version

# If fails, start dockerd
dockerd > /var/log/dockerd.log 2>&1 &
sleep 3
docker version  # Should work now
```

**Permission errors:**
```bash
# Set full permissions
cd ~/src/jwg-api
chmod -R 777 .
chmod -R 777 ~/.fhir
```

**File locking errors / "Resource deadlock avoided":**
- Ensure you're building from WSL filesystem (`~/src/jwg-api`), NOT `/mnt/c/...`
- Clear build artifacts: `rm -rf output temp template`
- May need to exclude repo from Windows antivirus

**Slow I/O performance:**
- Verify repo is on WSL filesystem, not Windows filesystem
- Check: `pwd` should show `/root/src/jwg-api`, NOT `/mnt/c/...`

### Common Issues (Both Platforms)

**Out of Memory Error:**
```bash
# Increase Java heap
PUBLISHER_JAVA_TOOL_OPTIONS="-Xmx8g -Xms1g" ./startDockerPublisher.sh
```

**Packages downloading every build:**
- Verify cache directory exists: `ls -la ~/.fhir`
- Check permissions: `chmod -R 777 ~/.fhir` (Windows)
- Ensure not using `PUBLISHER_FHIR_CACHE_MODE=tmpfs`

**Stale template issues:**
- Script clears `temp/`, `template/`, `output/` each run
- If issues persist, manually delete and rebuild

**Terminology server flake:**
- Re-run the build
- Cache prevents refetching large packages

**Build fails with 0 changes:**
- Check `output/qa.html` for actual errors
- Review last ~100 lines of console output
- Check specific SUSHI compilation errors

---

## CI / Publisher Workflow

### Continuous Integration
- **Main branch:** Published at [build.fhir.org/ig/euridice-org/jwg-api/en/](https://build.fhir.org/ig/euridice-org/jwg-api/en/)
- **Feature branches:** Published at `https://build.fhir.org/ig/euridice-org/jwg-api/branches/<branch>/`

### Branch Diagnostics
```bash
# Full build log
curl https://build.fhir.org/ig/euridice-org/jwg-api/branches/<branch>/build.log

# Failure log (only exists if build aborted)
curl https://build.fhir.org/ig/euridice-org/jwg-api/branches/<branch>/failure/build.log
```

**Status codes:**
- `200` - Build ran (check log for success/failure)
- `404` - No build triggered yet

### Troubleshooting CI

**Branch not appearing in /branches/:**
- New branches take time to appear after first build
- Check GitHub → Settings → Webhooks for `ig-commit-trigger`
- Or check Settings → Integrations → GitHub Apps for "FHIR IG Builder"
- Verify recent delivery for `refs/heads/<branch>` returned 200

**Force rebuild:**
```bash
git commit --allow-empty -m "Trigger IG build"
git push
```

**Verify output:**
- Open `branches/<branch>/en/index.html`
- Compare to local `output/` artifacts
- Check `branches/<branch>/qa.html` for errors

---

## Performance Expectations

### Mac
- **First build:** 10-20 minutes
- **Cached builds:** 3-5 minutes
- **Memory:** 4-6GB peak usage

### Windows (WSL)
- **First build:** 60-90 minutes (1.8GB package download)
- **Cached builds:** 3-5 minutes
- **Memory:** 4-6GB peak usage

### Optimization Tips
1. ✅ **Use persistent cache** (enabled by default)
2. ✅ **Keep `input-cache/publisher.jar`** (script updates automatically)
3. ⚠️ **Don't use tmpfs cache** for regular development
4. ✅ **Windows: Build from WSL filesystem** for best performance

---

## Resources

- **Repository:** https://github.com/euridice-org/jwg-api
- **IG Publisher:** https://github.com/HL7/fhir-ig-publisher
- **SUSHI (FSH compiler):** https://fshschool.org/
- **FHIR Specification:** https://www.hl7.org/fhir/
- **WSL Documentation:** https://learn.microsoft.com/en-us/windows/wsl/

---

## Additional Notes

### About This Project
- **Project:** EURIDICE API Specification (HL7 Europe / IHE Europe)
- **Purpose:** FHIR IG for EHDS EHR Interoperability Component
- **Package ID:** `hl7.fhir.eu.euridice-api`
- **FHIR Version:** 4.0.1

### Build Tools
- **SUSHI:** Compiles FSH (FHIR Shorthand) → FHIR resources
- **IG Publisher:** Generates complete IG site with documentation
- **Jekyll:** Renders HTML from templates
- **Docker:** Provides isolated build environment

### For detailed Windows setup and troubleshooting, see: [`josh/build-notes-windows.md`](josh/build-notes-windows.md)
