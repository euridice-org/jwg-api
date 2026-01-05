GPT's recommendations for getting docker running on work machine.


## design doc: get jwg-api fhir ig building locally on windows 11 (docker-first)

### tl;dr

set up a **repeatable local build** of the `euridice-org/jwg-api` fhir ig on a win11 work laptop using **docker desktop + wsl2**, matching the already-working mac docker flow. optimize for: minimal installs, low friction, reproducibility, and “agent can run this without me babysitting it”.

---

## context + current state

### repo

* github: `https://github.com/euridice-org/jwg-api/`
* this repo already contains standard ig-publisher scripts:

  * `startDockerPublisher.sh`
  * `_updatePublisher.sh`
  * `_genonce.sh` / `_gencontinuous.sh`
  * `ig.ini`, `sushi-config.yaml`, `input/`, `ig-template/`, etc.

### known working baseline (mac)

* build succeeds inside docker using image:

  * `hl7fhir/ig-publisher-base`
* command pattern used successfully:

  * run container
  * run `./_updatePublisher.sh -y && ./_genonce.sh`
* outputs appear in repo folder:

  * `output/qa.html` exists and is the primary “did it build” artifact
* observed behavior:

  * the base image’s entrypoint **clones HL7/ig-publisher-scripts and installs fsh-sushi every run** (annoying but expected)
  * using `--tmpfs /home/publisher/ig/.fhir` causes **cache resets** every run (forces redownloads)
  * build can be heavy: ~4gb heap usage was seen; memory tuning matters

### build errors encountered (useful for troubleshooting later)

* earlier: `java: command not found` (ended up being because command was run before entrypoint env was set / or wrong invocation; later fixed)
* one failure: `java.lang.OutOfMemoryError: Java heap space` (solved by increasing heap / docker memory)
* one failure: `Resource deadlock avoided` while copying template fragments (likely file-locking / filesystem semantics; wiping `output temp template` helped once; may recur on windows if building from windows filesystem mount)

### branch publishing confusion (don’t block local build)

* user expected branches to appear under `https://build.fhir.org/ig/euridice-org/jwg-api/branches/`
* likely the build.fhir branch publishing is **whitelisted** or otherwise controlled by build.fhir infra (not every branch auto-publishes)
* local build task does **not** require build.fhir publishing to work

---

## goals

### primary goal

get the IG building locally on a **windows 11 work laptop** using docker, producing `output/` with `qa.html` and a rendered site.

### secondary goals

* avoid re-downloading huge artifacts on every run
* provide a single command entrypoint the agent (and josh) can use repeatedly
* reduce build time where possible without drifting from “expected” publisher behavior

### non-goals

* fixing all QA errors/warnings/broken links (the build already shows many broken links)
* changing the IG content or dependencies
* solving build.fhir branch publishing policy (separate track)

---

## constraints / assumptions

* corporate laptop may have restricted admin privileges
* wsl2 may or may not be allowed; docker desktop may or may not be allowed
* the simplest path is **docker desktop + wsl2 + ubuntu**
* avoid native installs of java/ruby/node if possible

---

## proposed approach

### approach A (preferred): docker desktop + wsl2 + ubuntu + build from linux filesystem

1. install/enable wsl2
2. install docker desktop using wsl backend
3. clone repo inside ubuntu (`~/src/jwg-api`, NOT `/mnt/c/...`)
4. run `./startDockerPublisher.sh` or an equivalent docker command
5. verify `output/qa.html`

**why this is best**

* fewer windows filesystem locking issues
* faster file i/o
* easiest to keep behavior consistent with mac

### approach B (fallback): docker desktop only, build from windows filesystem

* run from powershell in `c:\...`
* mount repo into container
* more likely to hit “resource deadlock avoided” / slow i/o

### approach C (last resort): no docker allowed

* native install: java + ruby/jekyll + node + sushi + publisher jar
* high hassle; only do if corp policy blocks docker

---

## implementation details the agent should follow

### 1) environment setup checklist (win11)

* confirm hardware + os
* confirm whether these commands work:

  * `wsl --status`
  * `wsl --install` (if not installed)
  * `docker version`
  * `docker run hello-world`

**success condition:** can run linux containers and mount a folder.

### 2) repo placement guidance

* if using wsl: clone into ubuntu home

  * `~/src/jwg-api`
* avoid `/mnt/c/...` for builds unless forced

### 3) docker image choice

use:

* `hl7fhir/ig-publisher-base`

reason:

* matches mac working build
* includes java + jekyll toolchain; entrypoint bootstraps sushi + ig-publisher-scripts

### 4) caching strategy (biggest bang-for-buck)

don’t use tmpfs for `/home/publisher/.fhir` if you want speed.

**problem observed**

* `--tmpfs /home/publisher/ig/.fhir` nukes cache each run → re-downloads packages/publisher

**solution**

* mount a persistent cache dir from host to container:

  * `-v "$HOME/.fhir":/home/publisher/.fhir`

optional:

* consider also persisting `input-cache/` in repo (it already lives there); don’t delete it between runs

### 5) memory settings

* set heap via env:

  * `JAVA_TOOL_OPTIONS="-Xmx6g -Xms512m -Dfile.encoding=UTF-8"`
* set docker desktop memory allocation (if possible) to 8–12gb for stability

### 6) “one command to build” wrapper

agent should create a script that:

* ensures cache dir exists
* runs the container
* executes `_updatePublisher.sh -y` then `_genonce.sh`
* returns non-zero on failure
* prints where to find `output/qa.html`

suggested wsl script: `dev-build.sh` (store in repo root)

* makes build reproducible for josh + others

### 7) verification steps

after build:

* confirm these exist:

  * `output/qa.html`
  * `output/index.html` (or `output/en/index.html` depending on template)
* open qa report locally (browser) to confirm it rendered

record:

* runtime duration
* whether it redownloaded packages
* peak memory (publisher logs show max used)

---

## optimization ideas (with tradeoffs)

### a) persist fhir package cache (HIGH impact, low risk)

* do: mount `~/.fhir` into `/home/publisher/.fhir`
* saves: big downloads + time each run
* tradeoff: uses disk space (can be multiple gb)

### b) stop re-downloading the publisher jar every run (MED impact, low risk)

* `_updatePublisher.sh -y` fetches latest publisher
* if you’re ok with “keep current local version unless broken”, you can:

  * run `_updatePublisher.sh` only when needed
* tradeoff: you may diverge slightly from CI if CI auto-updates publisher every build

### c) build from wsl filesystem (HIGH impact, low risk)

* reduces file-locking + improves speed
* tradeoff: none, unless corp blocks wsl

### d) pin dependencies (MED impact, medium risk)

* `#current` dependencies can shift; pinning can stabilize
* tradeoff: deviates from “always latest” behavior; might differ from upstream expectations

### e) reduce terminology server dependency (LOW/MED impact, medium risk)

* terminology server calls can be slow
* local tx cache helps (already happens)
* tradeoff: forcing offline behavior can change validation outputs

---

## risks + mitigations

### risk 1: wsl blocked by policy

* mitigation: try docker desktop without wsl integration (powershell run)
* mitigation: if docker blocked too, fall back to native install doc

### risk 2: build fails due to file locking / “resource deadlock avoided”

* mitigation: build in wsl filesystem
* mitigation: ensure no aggressive antivirus scanning repo folder
* mitigation: on failure, wipe generated dirs and rebuild:

  * `rm -rf output temp template` (as previously used)

### risk 3: persistent caches cause “works on my machine” drift

* mitigation: document how to clear caches:

  * delete `~/.fhir/packages` (or whole `~/.fhir`)
  * wipe repo `input-cache/txcache` if needed
* mitigation: record publisher version shown in logs

---

## deliverables (what the agent should produce)

1. **working build on windows 11**

   * proof: `output/qa.html` generated successfully

2. **a short runbook** (markdown in repo, e.g. `BUILD_WINDOWS.md`)

   * prerequisites
   * exact commands (wsl + fallback powershell)
   * troubleshooting section for the known errors

3. **a single build script**

   * `dev-build.sh` (for wsl)
   * optional `dev-build.ps1` (fallback)

4. **notes on performance**

   * first run time vs second run time (with caching)
   * whether downloads still happen every run (they will for entrypoint sushi/scripts unless we customize image; note it)

---

## acceptance criteria

* from a fresh clone on win11:

  * one command triggers docker build
  * build completes without manual interactive steps
  * `output/qa.html` exists
* second run (with cache mount) avoids re-downloading the whole universe and is materially faster

---

## extra project-specific notes to pass along

* the ig build is heavy; expect:

  * lots of dependency package downloads on first run
  * many broken links + warnings in qa (that’s not a build failure)
* seeing “internal error in IG ihe.pharm.mpd...” in logs did **not** stop successful builds; treat as noisy unless it becomes fatal
* build.fhir branch auto-publishing appears controlled externally, though branches are typically built within 10-30m. 

