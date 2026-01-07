JEP: Result of initial scoping chat with chatGPT, referenging MHDS and the structure.

chatGPT:

# exchange ig notes (fhir + ihe) — week-later pickup doc
date: 2025-12-20  
goal: define an exchange-focused implementation guide (ig) that bundles ihe actor/transaction modeling with fhir-native artifacts (capabilitystatement, profiles, tests), while inheriting clinical content from external repos.

---

## 0) scope and non-scope

in scope:
- exchange + conformance modeling: actors, transactions, groupings, options, security, patient resolution, document publish/query/retrieve
- envelope constraints (documentreference + publication bundle) to keep “scoped content” enforceable without owning clinical profiles

out of scope:
- clinical content profiles (live in external repos)
- generic “full fhir server” requirements beyond a small curated resource query option

---

## 1) high-level architecture (3 bundles)

you defined 3 roles (capability bundles):

- producer
  - oauth client (smart backend services style client_credentials)
  - patient consumer (if needed to resolve patient ids)
  - mhd push (publication)

- access provider (ap)
  - receives mhd push (document recipient)
  - serves mhd queries (document responder)
  - is source for patient + auth
  - optionally serves resource queries (scoped, read/search only)

- consumer
  - oauth client (smart backend services)
  - patient client (pdqm)
  - mhd search/retrieve consumer

### ascii: end-to-end “dance”
```
producer (backend svc)              access provider (authz + rs)                 consumer (backend svc)
---------------------              ---------------------------                 -----------------------
GET /.well-known/smart-configuration  <------------------------------------->  GET /.well-known/smart-configuration
POST /token (client_credentials+jwt)  <------------------------------------->  POST /token (client_credentials+jwt)
PUSH docs (mhd publish)  --------------------------------------->  store/index
                                                          GET /Patient?...  <-------------------------
                                                          GET /DocumentReference?... <---------------
                                                          GET /Binary/{id}  <-------------------------
(optional)                                              GET /Observation?... <------------------------
```

---

## 2) approach taken by mhds (pattern to inherit)

mhds is an “orchestration ig”: it composes a higher-level actor by requiring groupings with actors from mhd + identity + auth + terminology/directory. the key idea to steal:

- define composite actors (your bundles)
- implement them via **required actor groupings** to existing ihe/fhir actor defs
- use **options + dependencies** to avoid combinatorial explosion
- keep transactions as named interaction patterns (not new endpoints)

you can reuse ihe “volume 1” modeling:
- actors + transactions tables
- required actor groupings tables
- options/dependencies tables

and then express the same requirements fhir-native via capabilitystatement + constraints + tests.

---

## 3) “not a write-anything cannon” (publish controls)

you were explicit: producer MUST NOT be able to write arbitrary resources.

we captured 3 enforcement layers:

### 3.1 scope gate (token-level)
limit producer to the smallest smart-like system scopes:
- system/documentreference.c
- system/binary.c
- optional: system/documentreference.u (only if you support replace/amend semantics)

avoid wildcards (`system/*.*`, `system/*.cruds`).

### 3.2 api gate (surface-area)
producer bundle supports only publication interactions:
- create documentreference
- create binary
- (optional) transaction bundle publish (if you use provide-bundle)

explicitly no patient read/search and no document searches for producer.

### 3.3 payload gate (envelope-level)
even with content external, enforce “envelope invariants” on documentreference metadata:
- subject references a patient id in this server
- attachment contenttype in allowlist (and per-category allowlist)
- type and/or format bound to allowed value sets
- author present (or require provenance)
- custodian present; pick one custodian model and lock it (producer org vs ap org)
- optional facilitytype/practicesetting required if you want routing/filtering

---

## 4) “module registry” renamed to content registry (priority category igs)

rename: **module registry** → **content registry**  
purpose: define a machine-enforceable allowlist keyed by “priority category” and pointing to external “priority category” igs.

### concept
you don’t enforce external clinical structuredefs directly; you enforce that documents declare their category via docref metadata (type/format/mime), then the ap rejects anything outside the registry.

### ascii: content registry model
```
content registry (exchange ig)
├─ content-registry.md  (normative table)
├─ valueset: vs-allowed-document-type
├─ valueset: vs-allowed-format-code
└─ valueset: vs-allowed-mime-type
```

### content-registry.md table shape
```
| priority category | external ig canonical | external ig version | allowed docref.type vs | allowed format vs | allowed mime types | notes |
|------------------|-----------------------|---------------------|------------------------|-------------------|-------------------|------|
| pc-01            | <priority ig url>     | 1.0.x               | vs-pc01-type           | vs-pc01-format    | pdf,fhir+json     | ...  |
| pc-02            | <priority ig url>     | 1.0.x               | vs-pc02-type           | vs-pc02-format    | pdf               | ...  |
```

normative enforcement:
- ap SHALL reject publication where docref.type/format/mime are not allowed for the declared priority category
- ap SHALL only expose documents whose priority categories it declares support for

---

## 5) envelope profiles (exchange-only)

you want to inherit content from external repos, so your ig owns only envelope-level artifacts:

recommended baseline parents:
- ihe mhd comprehensive documentreference (or uncontained variant)
- ihe mhd comprehensive provide-bundle (if you do iti-65 style publication)

you produce:
- sd-exchange-documentreference (derived from mhd comprehensive docref) with your added invariants/bindings
- sd-exchange-provide-bundle (derived from mhd provide-bundle) if you need a strict publish bundle shape

---

## 6) resource query option (read/search only)

you want to support both:
1) ap as a full fhir server (grouped producer/ap)
2) xds doc repo that “breaks apart” docs and serves derived resources

design: keep base ap = docs + patient + auth. add a separate OPTIONAL bundle:
- **resource responder** (grouped with ap, separate conformance claim)

key rule: **no generic resource push** from producers. docs only. resource access is read/search only.

### curated minimal resource set (starter pack)
keep it small and patient-scoped:
- patient: patient?identifier=...
- allergyintolerance: ?patient=
- condition: ?patient=&clinical-status=
- observation: ?patient=&category=&date=&code=
- diagnosticreport: ?patient=&category=&date=
- medicationrequest (or medicationstatement): ?patient=&status=&authoredon=
- immunization: ?patient=&date=&status=
- optional: encounter: ?patient=&date=

hard constraint: every search SHALL include `patient` (unless you later define a deliberate bulk option).

### derived-resource traceability (doc repo projection case)
require provenance (preferred) or an equivalent trace marker:
```
doc push -> store docref+binary (authoritative)
         -> derive/index resources (read-only)
              -> provenance.entity.what = DocumentReference/{id}
              -> provenance.target = derived resources
```

---

## 7) modeling actors + transactions in the ig

### actor modeling
use ihe-style “capability bundles”:
- define actors (producer/ap/consumer)
- define required groupings to parent ihe actors (mhd/pdqm) and smart-style auth
- define options + dependencies

### transaction modeling
transaction = named interaction choreography page + examples + error rules.
capabilitystatement captures the static surface; transaction pages capture runtime semantics.

recommended tx set:
- tx-01 backend auth (discovery + client_credentials + jwt assertion)
- tx-02 patient resolve (search and/or $match)
- tx-03 document publish (mhd push)
- tx-04 document search (docref search + paging)
- tx-05 document retrieve (binary read + content-type rules)
- tx-06 optional resource query (if resource responder enabled)

---

## 8) testscripts (optional but high leverage)

minimal tests we said make the ig “real”:
- auth-required rejection (no token → 401/403; pick one normatively)
- patient match success + ambiguity (define ambiguity handling)
- doc query pagination (next links + no duplicate entries across pages)
- retrieve content-type mismatch (binary content-type must match docref declared contentType)
additional publish-safety tests:
- producer trying to create Patient → 403
- publish docref with disallowed type/format/mime → reject (400/403/422; pick and standardize)

---

## 9) ascii: objects to create in the exchange ig repo

```
exchange ig package (your repo)
├─ implementationguide
│  └─ ImplementationGuide: ig-exchange
│     ├─ dependsOn: IHE.ITI.MHD
│     ├─ dependsOn: IHE.ITI.PDQm
│     └─ dependsOn: (doc reference) smart backend services
│
├─ actors (capability bundles)
│  ├─ CapabilityStatement: cs-producer
│  ├─ CapabilityStatement: cs-access-provider
│  ├─ CapabilityStatement: cs-consumer
│  └─ (optional) CapabilityStatement: cs-resource-responder
│
├─ envelope profiles (exchange-only)
│  ├─ StructureDefinition: sd-exchange-documentreference
│  │    └─ parent: IHE.MHD comprehensive documentreference (or uncontained)
│  └─ StructureDefinition: sd-exchange-provide-bundle
│       └─ parent: IHE.MHD comprehensive provide-bundle (iti-65)
│
├─ content registry (priority categories)
│  ├─ markdown: content-registry.md
│  ├─ ValueSet: vs-allowed-document-type
│  ├─ ValueSet: vs-allowed-format-code
│  └─ ValueSet: vs-allowed-mime-type
│
├─ transactions (choreography pages)
│  ├─ tx-01-auth-backend-service.md
│  ├─ tx-02-patient-resolve.md
│  ├─ tx-03-document-publish.md
│  ├─ tx-04-document-search.md
│  ├─ tx-05-document-retrieve.md
│  └─ tx-06-resource-query.md (optional)
│
├─ conformance tables (ihe-style)
│  ├─ actors-and-transactions.md
│  ├─ required-actor-groupings.md
│  └─ options-and-dependencies.md
│
└─ tests (optional)
   ├─ TestScript: ts-auth-required-rejection
   ├─ TestScript: ts-patient-ambiguity
   ├─ TestScript: ts-docsearch-pagination
   ├─ TestScript: ts-retrieve-contenttype-mismatch
   └─ TestScript: ts-publish-reject-disallowed
```

---

## 10) ascii: capabilitystatement shapes (bundles)

### cs-producer
```
capabilitystatement: cs-producer
  mode: client (expectations)
  security:
    oauth2 REQUIRED
    smart backend services:
      - /.well-known/smart-configuration
      - client_credentials + jwt client assertion
    requested scopes:
      - system/documentreference.c
      - system/binary.c
      - (opt) system/documentreference.u

  expected interactions:
    documentreference: create
    binary: create
    (opt) bundle: transaction (publish)
  explicitly out-of-bundle:
    no patient read/search
    no doc search
    no other creates
```

### cs-access-provider (base)
```
capabilitystatement: cs-access-provider
  mode: server
  security:
    bearer REQUIRED
    smart well-known advertised
    enforce 401/403 rules

  resources:
    patient:
      - search-type REQUIRED
      - search param: identifier REQUIRED
      - (opt) $match
    documentreference:
      - search-type REQUIRED
      - search params: patient REQUIRED, _count REQUIRED
      - (opt) type/date/category
      - paging: next link REQUIRED when applicable
    binary:
      - read REQUIRED
      - content-type MUST match docref declared contentType

  publish reception (if applicable):
    - accepts mhd publish (iti-65 provide-bundle) or your defined create pattern
    - validates content registry (priority categories)
```

### cs-consumer
```
capabilitystatement: cs-consumer
  mode: client (expectations)
  security:
    oauth2 REQUIRED
    smart backend services flow
    requested scopes:
      - system/patient.rs
      - system/documentreference.rs
      - system/binary.r

  expected interactions:
    patient search (identifier)
    docref search (patient + paging)
    binary read
```

### cs-resource-responder (optional)
```
capabilitystatement: cs-resource-responder
  mode: server
  security: same oauth2, separate/additive scopes

  resources (read/search only, patient required):
    - allergyintolerance?patient=
    - condition?patient=&clinical-status=
    - observation?patient=&category=&date=&code=
    - diagnosticreport?patient=&category=&date=
    - medicationrequest?patient=&status=&authoredon=
    - immunization?patient=&date=&status=
    - (opt) encounter?patient=&date=

  invariant:
    searches without patient rejected (unless bulk option explicitly enabled)
  invariant:
    no create/update/delete on these resources
  traceability (if derived):
    provenance links derived resources to source documentreference
```

---

## 11) decisions to make when you resume

these are the “one-way doors” to pick explicitly:

- publication shape:
  - do you require iti-65 provide-bundle, or allow simple docref+binary create, or both?
- patient resolve:
  - patient search only, or pdqm $match?
  - ambiguity behavior (return candidates vs error)
- custodian model:
  - custodian = producer org OR custodian = access provider org
- provenance:
  - metadata-only attribution OR require provenance resource
- resource query option:
  - which resources make the cut (keep list short)
  - whether resource responder is a separate bundle (recommended) vs baked into ap (risky)

---

## 12) next steps (minimal plan)

1) create the conformance tables:
   - actors-and-transactions.md
   - required-actor-groupings.md
   - options-and-dependencies.md

2) author sd-exchange-documentreference (derived from mhd comprehensive) and add envelope invariants + bindings to content registry value sets

3) write content-registry.md keyed by priority category and link each row to external priority category ig canonical + pinned version

4) draft the 5 core transaction pages (auth, patient, publish, search, retrieve), then wire each to bundles

5) (optional) implement the 4 core testscripts + publish reject test

done. no scope creep, no accidental generic fhir server spec, vibes minimized.
