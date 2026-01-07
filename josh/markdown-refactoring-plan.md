# Markdown Refactoring Plan
## Aligning IG Pages with New 5-Actor Model

**Date:** 2026-01-02
**Updated:** 2026-01-02 (revised scope)
**Goal:** Create shell pages for new functional content. User to write narrative and update existing pages.

**Status:** 5 new functional shell pages created (capability-discovery.md, authorization.md, patient-matching.md, document-exchange.md, resource-access.md)

**Note:** Using IHE transaction numbers (ITI-65, ITI-67, ITI-68, ITI-78, PCC-44) instead of T1/T2/T3 numbering.

---

## What Was Done

✅ **Created 5 new functional shell pages** (in `/input/pagecontent/`):
1. `capability-discovery.md` - Priority category discovery, content registry concept
2. `authorization.md` - SMART Backend Services + IUA (required, not optional)
3. `patient-matching.md` - PDQm Patient Demographics Query (ITI-78)
4. `document-exchange.md` - MHD transactions (ITI-65, ITI-67, ITI-68)
5. `resource-access.md` - QEDm resource query (PCC-44), read/search only

Each page has:
- Terse overview
- Actor references
- IHE transaction references
- Basic structure
- Links to IHE specifications

## What's Left for User

- [ ] Write narrative for `index.md` (home page)
- [ ] Expand `regulatoryAnchors.md` with Xt-EHR 5.1 content
- [ ] Update existing pages as needed:
  - [ ] `context.md` (reframe to deployment patterns)
  - [ ] `api-specification.md` (update to 5-actor model, remove ITI-1)
  - [ ] `main-usecases.md` (remove Administrator actor)
  - [ ] `use-cases.md` (reframe as deployment patterns)
  - [ ] `transaction-T1.md`, `transaction-T2.md` (minor updates)
  - [ ] Priority area pages (minor updates)
- [ ] Update `sushi-config.yaml` menu to include new functional pages
- [ ] Test IG build
- [ ] **Later:** Delete old transaction-T4.md (Import) and transaction-T5.md (Export) when confident nothing important is lost

---

## Current State vs Target State

### Current State (Old Model)
- 6 actors: Document Producer, Document Access Provider, Document Consumer, Resource Access Provider, Resource Consumer, **Administrator**
- Transactions: T1 (Inspect), T2 (Find Patient), T4 (Import via UI), T5 (Export via UI/Bulk)
- Authorization is "optional"
- Missing programmatic document push (MHD ITI-65)
- Multiple APIs for different use cases
- Mixed content (API + clinical content profiles)

### Target State (New Model)
- **5 actors**: Document Producer, Document Access Provider, Document Consumer, Resource Access Provider, Resource Consumer
- **Transactions**: T1 (Inspect), T2 (Find Patient), **T3 (Publish Docs - NEW!)**, T4 (Search Docs), T5 (Retrieve Doc), T6 (Search Resources - optional)
- **Authorization required** (SMART Backend Services + IUA)
- **MHD document push** (ITI-65 Provide Document Bundle)
- **One API, multiple deployment patterns**
- **Separation**: API-level requirements here, clinical content in external HL7 EU IGs
- **Content registry** concept (priority categories → external IGs)

### Ground Truth Documents
- `/README.md` - High-level overview, actor summary, links to key pages
- `/input/pagecontent/actors.md` - Detailed 5-actor model with IHE groupings
- `/input/pagecontent/regulatoryAnchors.md` - EHDS ANNEX II interpretation (stub, needs expansion)
- `/josh/plan.md` - ChatGPT exchange-focused IG design notes
- `/josh/outline.md` - Page structure matching HL7 EU IG format
- `/josh/claudediff.md` - Diff between old and new approaches

---

## Refactoring Phases

### Phase 1: Create New Foundational Pages
New pages that don't exist or need complete rewrites.

### Phase 2: Update Existing Core Pages
Pages that exist but need significant updates to align with new model.

### Phase 3: Delete or Archive Obsolete Content
Pages that are out of scope in the new model.

### Phase 4: Create Missing Transaction Pages
New transaction pages for the updated transaction model.

### Phase 5: Update Configuration
Update sushi-config.yaml and any navigation includes.

---

## Phase 1: Create New Foundational Pages

### 1.1 Core Pages

#### **`index.md`** (Home Page) - REWRITE
**Status:** Exists but needs complete rewrite
**Priority:** HIGH
**Content:**
- Quick description of EURIDICE / EU Health Data API
- Goals: (1) Define exchange patterns for EEHRxF data, (2) Satisfy EHDS interoperability requirements
- Co-branded HL7 Europe / IHE Europe initiative
- Link to 6 priority category content IGs:
  - European Patient Summary (HL7 EU)
  - Medication Prescription & Dispense (HL7 EU)
  - Laboratory Report (HL7 EU)
  - Hospital Discharge Report (HL7 EU)
  - Imaging Report (HL7 EU)
  - Imaging Study Manifest (HL7 EU)
- Basic 5-actor definitions summary (with diagram)
- Example story with sequence diagram showing base use case
- Audience (implementers, member states, EHR vendors)
- Dependencies/References
- Remove all references to old 6-actor model
- Remove Administrator actor mentions

#### **`actors.md`** - COMPLETE ✓
**Status:** Already drafted, in good shape
**Priority:** HIGH
**Content:**
- 5 composite actors documented
- IHE actor groupings shown with diagrams
- Required transactions table
- Link to ResourceExchange.md for explanation of no Resource Producer

#### **`ResourceExchange.md`** (or `resource-exchange.md`) - CREATE
**Status:** Stub exists (one line), needs full content
**Priority:** HIGH
**Content:**
- Explain why no Resource Producer actor (complexity)
- Four ways Resource Access Provider gets resources:
  1. Generate internally (grouped with implied Resource Producer)
  2. Consume from another Resource Access Provider (grouped with Resource Consumer)
  3. Extract from documents received (grouped with MHD Document Responder)
  4. Translate from another exchange format
- Reference to IHE MPD as example of prescription resource exchange complexity
- Note that generic resource push is out of scope
- Link back from actors.md

#### **`regulatoryAnchors.md`** - EXPAND
**Status:** Stub exists, needs content
**Priority:** HIGH
**Content:**
- EHDS ANNEX II interpretation (diagram from Xt-EHR 5.1)
- Table from Xt-EHR 5.1 listing functional requirements
- Map requirements to technical capabilities in this IG
- Patient rights section:
  - Which rights require interoperability specs
  - Which rights are member state internal (e.g., opt-out registry)
  - Example: patient right to insert info into their EHR (underspecified)
- Caveat: Requirements owned by EC/EHDS Implementing Acts, we inherit Xt-EHR work

---

### 1.2 New Functional Pages

#### **`capability-discovery.md`** - CREATE
**Status:** Does not exist
**Priority:** MEDIUM
**Content:**
- How to use FHIR CapabilityStatement (GET /metadata)
- How to discover which priority categories a server supports
- Priority category declaration mechanism (TBD - in CapabilityStatement.instantiates? extension?)
- Content registry concept (priority category → external IG canonical URL + version)

#### **`authorization.md`** - CREATE
**Status:** Does not exist
**Priority:** HIGH
**Content:**
- SMART Backend Services (required, not optional)
- IUA integration (IUA Authorization Client, Authorization Server, Resource Server)
- OAuth2 client_credentials + JWT client assertion
- Discovery via /.well-known/smart-configuration
- Scopes model:
  - Producer: system/DocumentReference.c, system/Binary.c (optional: system/DocumentReference.u)
  - Consumer: system/Patient.rs, system/DocumentReference.rs, system/Binary.r
  - Resource Consumer: additional system/*.rs scopes for resources
- Token-level enforcement (scope gate)
- API-level enforcement (surface-area gate)
- No wildcards (avoid system/*.*, system/*.cruds)

#### **`patient-matching.md`** - CREATE
**Status:** Does not exist
**Priority:** HIGH
**Content:**
- PDQm Patient Demographics Query
- Patient search using identifier
- Patient.$match operation
- Supported identifier systems (SupportedIdentifier extension from T2.fsh)
- Ambiguity handling (return candidates vs error)
- Link to transaction-T2.md for detailed choreography

#### **`document-exchange.md`** - CREATE
**Status:** Does not exist
**Priority:** HIGH
**Content:**
- MHD overview (IHE Mobile Health Documents)
- Three actors: Document Source (Producer), Document Recipient + Responder (Access Provider), Document Consumer
- Shared DocumentReference search parameters across all priority categories:
  - patient (required)
  - type, date, category, format, _count
  - Paging with next links
- Envelope constraints (metadata requirements):
  - subject references valid patient
  - attachment contentType in allowlist
  - type/format bound to allowed value sets
  - author present
  - custodian present (pick custodian model: producer org vs AP org)
  - optional: facilityType, practiceSetting for routing/filtering
- Content registry enforcement (priority category allowlists)
- Link to transaction pages T3, T4, T5

#### **`resource-access.md`** - CREATE
**Status:** Does not exist
**Priority:** MEDIUM
**Content:**
- FHIR Core Search patterns (IPA/QEDm)
- Read/search only (no create/update/delete)
- Patient-scoped queries (patient parameter required)
- Curated minimal resource set:
  - AllergyIntolerance, Condition, Observation, DiagnosticReport
  - MedicationRequest/MedicationStatement, Immunization
  - Optional: Encounter
- Search parameters per resource (patient always required)
- Derived resource traceability (if resources extracted from docs):
  - Provenance linking derived resources to source DocumentReference
- Hard constraint: reject searches without patient parameter (unless bulk option)
- Link to transaction-T6.md

---

### 1.3 New Introduction/Background Pages

#### **`scope.md`** - CREATE
**Status:** Does not exist
**Priority:** MEDIUM
**Content:**
- **In Scope:**
  - Base EHR interoperability component (EHDS ANNEX II)
  - System-to-system PULL architecture
  - Generic actors (applicable to all priority areas)
  - API-level requirements (transactions, authentication, actors)
  - Exchange patterns using IHE profiles (MHD, PDQm, QEDm, IUA)
- **Out of Scope:**
  - Network-level exchange infrastructure
  - Member state-specific implementations
  - Priority category-specific content profiles (defined in separate HL7 EU IGs)
  - Cross-border infrastructure and trust framework (handled by MyHealth@EU / NCP)
  - Generic "full FHIR server" requirements beyond curated resource query

#### **`resources-vs-documents.md`** - CREATE
**Status:** Does not exist
**Priority:** MEDIUM
**Content:**
- Simple visual explanation of FHIR Documents vs FHIR Resources
- FHIR Document: collection of resources in a Bundle with Composition (narrative + structure)
- FHIR Resource: atomic data element (Patient, Observation, etc.)
- Use cases for each:
  - Documents: snapshot in time, clinical summaries, cross-border exchange, legal documents
  - Resources: current state, fine-grained queries, detailed analytics
- Differentiate document discovery (DocumentReference) from document data model (Bundle content)
- Persistence considerations:
  - Documents can be generated on-demand or as stored snapshots
  - Resources represent current state
- When to use which

#### **`relationship-to-xds.md`** - CREATE
**Status:** Does not exist
**Priority:** LOW
**Content:**
- MHD as bridge between XDS/XCA and FHIR environments
- **From FHIR server perspective:** MHD is an ad-hoc index of that server's FHIR documents
- **From XDS environment perspective:** MHD is a FHIR facade to a document registry
- XDS/XCA actors can be grouped with MHD actors
- This enables member states with existing XDS infrastructure to support FHIR-based access
- Diagram showing grouping options

#### **`member-state-architectures.md`** - CREATE
**Status:** Does not exist
**Priority:** LOW
**Content:**
- Different member state architectures exist today:
  - Central repository (e.g., national EHR)
  - Federated (peer-to-peer between organizations)
  - Hybrid (regional hubs)
- How the Interoperability Component defined here fits in each architecture
- Actor grouping examples showing different deployment patterns
- Modeled after IHE MPD "Actor grouping examples" page
- Greenfield considerations (new implementations)
- Example: Hospital system acting as Document Producer + Access Provider (grouped)

---

## Phase 2: Update Existing Core Pages

### 2.1 Core Specification Pages

#### **`api-specification.md`** - UPDATE
**Status:** Exists, needs significant updates
**Priority:** HIGH
**Actions:**
- Remove 6-actor model, replace with 5-actor model
- Remove Administrator actor
- Remove ITI-1 (Maintain Time) references
- Add **T3: Publish Documents (MHD ITI-65)**
- Update transaction summary table:
  - T1: Inspect (metadata)
  - T2: Find Patient
  - T3: Publish Documents (NEW)
  - T4: Search Documents (was MHD ITI-67)
  - T5: Retrieve Document (was MHD ITI-68)
  - T6: Search Resources (optional, QEDm PCC-44)
- Remove "Authorization Option" section (authorization is now required)
- Update to reference new functional pages (authorization.md, patient-matching.md, etc.)
- Update actor diagrams
- Harvest useful content before major surgery

#### **`specification.md`** - UPDATE OR DELETE
**Status:** Exists, currently placeholder
**Priority:** LOW
**Actions:**
- Review current content
- Either:
  - **Option A:** Expand with high-level specification overview (volume 1-ish)
  - **Option B:** Consolidate into api-specification.md and delete
  - **Option C:** Make it a landing page linking to functional pages
- Decision: Likely consolidate into api-specification.md

#### **`functional.md`** - UPDATE OR DELETE
**Status:** Exists, currently placeholder
**Priority:** LOW
**Actions:**
- Review current content
- Either:
  - **Option A:** Expand with volume 1-ish content (actors, transactions, options, groupings)
  - **Option B:** Delete and replace with links to new functional pages
  - **Option C:** Make it a landing page for functional section
- Decision: Likely make it a landing page linking to: actors.md, capability-discovery.md, authorization.md, patient-matching.md, document-exchange.md, resource-access.md

---

### 2.2 Context & Use Cases

#### **`context.md`** - REFRAME
**Status:** Exists, needs reframing
**Priority:** MEDIUM
**Actions:**
- **Key change:** Shift from "different APIs for different use cases" to **"one API, multiple deployment patterns"**
- Update architectural context showing where this API fits in broader EHDS ecosystem
- Business actors vs system actors
- Relationship to national infrastructure
- Update actor diagrams to show 5-actor model
- Deployment patterns:
  - Direct EHR-to-EHR
  - EHR with facade
  - Central national repository
  - Federated regional hubs
  - National Contact Point (cross-border)
  - Health Professional Access Service (HPAS)
  - Health Data Access Service (patient portal)
- Each deployment uses the same API, just different groupings

#### **`main-usecases.md`** - UPDATE
**Status:** Exists
**Priority:** MEDIUM
**Actions:**
- Remove Administrator actor
- Update to 5-actor model
- Primary actors: Health Professional, Patient, System (not Administrator)
- Use cases: Inspect, Access, Import (via pull, not UI push), Export (via API, not bulk UI)
- Update diagrams
- Ensure alignment with new approach

#### **`use-cases.md`** - UPDATE
**Status:** Exists
**Priority:** MEDIUM
**Actions:**
- **Reframe as deployment patterns**, not different APIs
- Examples to include:
  - Base: EHR System IC query and retrieve
  - Organization to Organization Exchange (Federated National Infrastructure)
  - Organization to Organization (Central Repository National Infrastructure)
  - National Contact Point: MyHealth@EU cross-border query
  - Patient Access (Health Data Access Service / patient portal)
  - Health Professional Access Service (HPAS)
  - EHR Facade: Legacy system with FHIR facade
  - Wellness App: Consumer app accessing EHR data
  - System Replacement: Bulk Export/Import for EHR migration
- Each scenario shows actor groupings and how same API supports different deployments
- Remove any implication that these are different APIs

---

### 2.3 Existing Transaction Pages

#### **`transaction-T1.md`** (Inspect) - MINOR UPDATE
**Status:** Exists
**Priority:** MEDIUM
**Actions:**
- Verify alignment with new CapabilityStatement approach
- Add reference to capability-discovery.md
- Update actor references (5-actor model)
- Content should cover: GET /metadata, CapabilityStatement structure, priority category discovery

#### **`transaction-T2.md`** (Find Patient) - MINOR UPDATE
**Status:** Exists
**Priority:** MEDIUM
**Actions:**
- Verify alignment with PDQm approach
- Add reference to patient-matching.md
- Update actor references (5-actor model)
- SupportedIdentifier extension (from T2.fsh)
- Patient.$match operation
- Demographics search patterns

---

### 2.4 Supporting Pages

#### **`xtehr-mapping.md`** - MINOR UPDATE
**Status:** Exists
**Priority:** LOW
**Actions:**
- Ensure links to Xt-EHR deliverables are current
- Note relationship to Xt-EHR 5.1 Functional Requirements
- Verify any actor model references

#### **`design-considerations.md`** - REVIEW & UPDATE
**Status:** Exists
**Priority:** LOW
**Actions:**
- Update any references to old actor model
- Add considerations for new MHD push approach (T3)
- Envelope validation strategies
- Content registry enforcement patterns
- Custodian model choices
- Provenance patterns

#### **`adapting.md`** - REVIEW & UPDATE
**Status:** Exists
**Priority:** LOW
**Actions:**
- Ensure guidance aligns with new model
- Extension points for member state customization
- How to profile for national use
- Content registry customization
- Additional scopes/constraints

---

### 2.5 Priority Area Pages

#### **`priority-areas.md`** (Overview) - MINOR UPDATE
**Status:** Exists
**Priority:** LOW
**Actions:**
- Verify 6 EHDS ANNEX II priority categories listed:
  1. European Patient Summary (EPS)
  2. Medication Prescription & Dispense (MPD)
  3. Laboratory Test Results
  4. Hospital Discharge Reports (HDR)
  5. Imaging Manifests
  6. Imaging Reports
- Update support matrix visualization if needed
- Emphasize separation: API requirements here, content profiles in external IGs

#### **`priority-area-eps.md`** - MINOR UPDATE
**Status:** Exists, most developed
**Priority:** LOW
**Actions:**
- Verify references to API-level requirements only
- Link to external HL7 EU EPS IG for content profiles
- Update actor model references if needed

#### **`priority-area-laboratory.md`** - MINOR UPDATE
**Status:** Exists, placeholder
**Priority:** LOW
**Actions:**
- Same as EPS

#### **`priority-area-hdr.md`** - MINOR UPDATE
**Status:** Exists, placeholder
**Priority:** LOW
**Actions:**
- Same as EPS

#### **`priority-area-imaging-manifest.md`** - MINOR UPDATE
**Status:** Exists, placeholder
**Priority:** LOW
**Actions:**
- Same as EPS

#### **`priority-area-imaging-report.md`** - MINOR UPDATE
**Status:** Exists, placeholder
**Priority:** LOW
**Actions:**
- Same as EPS

#### **`priority-area-mpd.md`** - MINOR UPDATE
**Status:** Exists, placeholder
**Priority:** LOW
**Actions:**
- Same as EPS

---

### 2.6 About Pages (Minimal Changes)

#### **`contributors.md`** - NO CHANGE
**Status:** Exists
**Priority:** LOW

#### **`changes.md`** - UPDATE
**Status:** Exists, currently empty
**Priority:** LOW
**Actions:**
- Add change log entry for major refactoring to 5-actor model

#### **`copyright.md`** - NO CHANGE
**Status:** Exists
**Priority:** LOW

#### **`references.md`** - MINOR UPDATE
**Status:** Exists
**Priority:** LOW
**Actions:**
- Verify links to IHE specifications current
- Verify links to HL7 EU IGs current
- Add any new references

#### **`dependencies.md`** - MINOR UPDATE
**Status:** Exists
**Priority:** LOW
**Actions:**
- Verify package dependencies listed correctly
- Update versions if needed

---

## Phase 3: Delete or Archive Obsolete Content

### 3.1 Delete Transaction Pages

#### **`transaction-T4.md`** (OLD - Import via UI) - DELETE
**Status:** Exists, no longer in scope
**Priority:** HIGH
**Actions:**
- This was admin UI import flow (out of scope)
- **Before deleting:** Review for any useful content to harvest
- Move to `/old/` directory if you want to preserve history
- Or simply delete

#### **`transaction-T5.md`** (OLD - Export via UI/Bulk) - DELETE
**Status:** Exists, no longer in scope
**Priority:** HIGH
**Actions:**
- This was admin UI / bulk export flow (out of scope)
- **Before deleting:** Review for any useful content to harvest
- Move to `/old/` directory if you want to preserve history
- Or simply delete

---

### 3.2 Review and Potentially Delete

#### **`content-FHIR-file.md`** - REVIEW
**Status:** Exists
**Priority:** MEDIUM
**Actions:**
- Review content - was this specific to T4/T5 import/export?
- If it contains useful Bundle format info (JSON/NDJSON, file naming conventions), keep and update
- If specific to deleted transactions, archive or delete
- Decision: Probably has useful content about FHIR Bundle structure, keep and update

#### **`eps-specification.md`** - REVIEW
**Status:** Exists
**Priority:** LOW
**Actions:**
- Review content
- Does this duplicate `priority-area-eps.md`?
- If duplicate, consolidate into priority-area-eps.md and delete
- If unique content, keep but ensure it fits new model

#### **`old.md`** - KEEP OR DELETE
**Status:** Exists, already archived content
**Priority:** LOW
**Actions:**
- Review - is this useful as historical reference?
- Can delete entirely or keep in place

---

## Phase 4: Create Missing Transaction Pages

### Critical New Transactions

#### **`transaction-T3.md`** - CREATE (CRITICAL!)
**Status:** Does not exist - THIS IS THE KEY MISSING PIECE
**Priority:** CRITICAL
**Content:**
- **T3: Publish Documents** (MHD ITI-65 Provide Document Bundle)
- Actors: Document Producer (client) → Document Access Provider (server)
- Scope enforcement:
  - Producer requests: system/DocumentReference.c, system/Binary.c
  - Optional: system/DocumentReference.u (for replace/amend)
- Publication patterns:
  - Option A: MHD ITI-65 Provide Document Bundle (transaction bundle)
  - Option B: Simple DocumentReference + Binary create
  - Decision: Probably require ITI-65 for consistency
- Envelope validation rules:
  - subject references valid Patient
  - attachment contentType in allowlist
  - type/format bound to allowed value sets per priority category
  - author present
  - custodian present (choose model: producer org vs AP org)
  - Optional: facilityType, practiceSetting
- Content registry enforcement:
  - AP SHALL reject publication where DocumentReference.type/format/mime not allowed for declared priority category
  - Priority category declaration mechanism (in DocumentReference? or as part of submit?)
- Error handling:
  - 400/403/422 for validation failures (pick one normatively)
  - 401 for missing/invalid token
- Sequence diagram
- Example request/response

#### **`transaction-T4.md`** (NEW - Search Documents) - CREATE
**Status:** Old T4 was Import, this is NEW T4
**Priority:** HIGH
**Content:**
- **T4: Search Documents** (MHD ITI-67 Find Document References)
- Actors: Document Consumer (client) → Document Access Provider (server)
- Required search parameters:
  - patient (required)
  - _count (required for paging support)
- Optional search parameters:
  - type, date, category, format, status
- Paging:
  - Next link required when applicable
  - No duplicate entries across pages
- Scope: system/DocumentReference.rs
- Response: Bundle of type searchset with DocumentReference entries
- Sequence diagram
- Example request/response

#### **`transaction-T5.md`** (NEW - Retrieve Document) - CREATE
**Status:** Old T5 was Export, this is NEW T5
**Priority:** HIGH
**Content:**
- **T5: Retrieve Document** (MHD ITI-68 Retrieve Document)
- Actors: Document Consumer (client) → Document Access Provider (server)
- Retrieval: GET /Binary/{id}
- Content-type matching:
  - Binary.contentType MUST match DocumentReference.content.attachment.contentType
  - Server SHALL reject mismatches with 4xx error
- Scope: system/Binary.r
- Format options: FHIR+JSON, PDF, CDA, others per priority category
- Sequence diagram
- Example request/response

#### **`transaction-T6.md`** (Search Resources - OPTIONAL) - CREATE
**Status:** Does not exist
**Priority:** MEDIUM
**Content:**
- **T6: Search Resources** (QEDm PCC-44 / IPA)
- Actors: Resource Consumer (client) → Resource Access Provider (server)
- **OPTIONAL transaction** (not required for all implementations)
- Read/search only (no create/update/delete)
- Patient-scoped queries (patient parameter required)
- Curated resource set:
  - AllergyIntolerance, Condition, Observation, DiagnosticReport
  - MedicationRequest/MedicationStatement, Immunization
  - Optional: Encounter
- Search parameters per resource (examples):
  - AllergyIntolerance?patient=X
  - Condition?patient=X&clinical-status=active
  - Observation?patient=X&category=vital-signs&date=ge2024-01-01
- Hard constraint: searches without patient parameter rejected (unless bulk option explicitly enabled)
- Derived resource traceability:
  - If resources derived from documents, Provenance SHOULD link to source DocumentReference
- Scopes: system/AllergyIntolerance.rs, system/Condition.rs, etc.
- Sequence diagram
- Example request/response

---

## Phase 5: Update Configuration

### **`sushi-config.yaml`** - UPDATE
**Status:** Exists
**Priority:** HIGH (after pages are ready)
**Actions:**
- Update `pages` menu structure to reflect new organization:

```yaml
pages:
  index.md:
    title: Home

  # Introduction / Background
  scope.md:
    title: Scope
  regulatoryAnchors.md:
    title: Regulatory Anchors
  resources-vs-documents.md:
    title: Resources vs Documents
  relationship-to-xds.md:
    title: Relationship to XDS/XCA
  member-state-architectures.md:
    title: Member State Architectures

  # Functional (Volume 1-ish)
  functional.md:
    title: Functional Requirements
  actors.md:
    title: Actors and Transactions
  ResourceExchange.md:
    title: Resource Exchange
  capability-discovery.md:
    title: Capability Discovery
  authorization.md:
    title: Authorization
  patient-matching.md:
    title: Patient Matching
  document-exchange.md:
    title: Document Exchange
  resource-access.md:
    title: Resource Access

  # Transactions
  transaction-T1.md:
    title: "T1: Inspect"
  transaction-T2.md:
    title: "T2: Find Patient"
  transaction-T3.md:
    title: "T3: Publish Documents"
  transaction-T4.md:
    title: "T4: Search Documents"
  transaction-T5.md:
    title: "T5: Retrieve Document"
  transaction-T6.md:
    title: "T6: Search Resources"

  # Implementation / Use Cases
  context.md:
    title: Context
  main-usecases.md:
    title: Main Use Cases
  use-cases.md:
    title: Deployment Patterns

  # Design & Adaptation
  design-considerations.md:
    title: Design Considerations
  adapting.md:
    title: Adapting for National Use
  content-FHIR-file.md:
    title: FHIR File Format

  # Priority Areas
  priority-areas.md:
    title: Priority Areas Overview
  priority-area-eps.md:
    title: European Patient Summary
  priority-area-mpd.md:
    title: Medication Prescription & Dispense
  priority-area-laboratory.md:
    title: Laboratory Results
  priority-area-hdr.md:
    title: Hospital Discharge Reports
  priority-area-imaging-report.md:
    title: Imaging Reports
  priority-area-imaging-manifest.md:
    title: Imaging Manifests

  # About
  contributors.md:
    title: Contributors
  changes.md:
    title: Change Log
  copyright.md:
    title: Copyright
  references.md:
    title: References
  dependencies.md:
    title: Dependencies
  xtehr-mapping.md:
    title: Xt-EHR Mapping
```

- Remove old T4 (Import) and T5 (Export) from pages
- Add new pages created in Phase 1 and Phase 4
- Organize into logical sections matching HL7 EU IG format

### **Navigation Includes** - UPDATE IF NEEDED
**Status:** Depends on template
**Priority:** MEDIUM
**Actions:**
- If using custom includes for navigation (`ig-template/includes/`), update those
- Otherwise, rely on sushi-config.yaml menu structure

---

## Suggested Work Order

### Critical Path (Must Do First)
1. ✓ **`actors.md`** (already done)
2. **`index.md`** (rewrite home page with new model)
3. **`ResourceExchange.md`** (explain no Resource Producer)
4. **`authorization.md`** (SMART Backend - required, critical concept)
5. **`transaction-T3.md`** (Publish - THE KEY MISSING TRANSACTION)
6. **`api-specification.md`** (update to new model)
7. **Delete old T4 and T5** (clear confusion)
8. **`sushi-config.yaml`** (update menu so it builds)

### High Priority (Core Functionality)
9. **`patient-matching.md`** (PDQm)
10. **`document-exchange.md`** (MHD overview)
11. **`transaction-T1.md`** (update)
12. **`transaction-T2.md`** (update)
13. **`transaction-T4.md`** (new - Search Docs)
14. **`transaction-T5.md`** (new - Retrieve Doc)
15. **`capability-discovery.md`** (priority categories)
16. **`regulatoryAnchors.md`** (expand with Xt-EHR 5.1 content)

### Medium Priority (Context & Background)
17. **`scope.md`** (clear in/out scope)
18. **`context.md`** (reframe to deployment patterns)
19. **`use-cases.md`** (deployment patterns, not different APIs)
20. **`main-usecases.md`** (update to 5 actors)
21. **`resources-vs-documents.md`** (explanation)
22. **`resource-access.md`** (QEDm/IPA)
23. **`transaction-T6.md`** (optional - Search Resources)

### Low Priority (Nice to Have)
24. **`relationship-to-xds.md`** (MHD as bridge)
25. **`member-state-architectures.md`** (deployment examples)
26. **`functional.md`** (landing page or consolidate)
27. **`specification.md`** (landing page or consolidate)
28. Review priority area pages (minor updates)
29. **`design-considerations.md`** (update)
30. **`adapting.md`** (update)
31. **`content-FHIR-file.md`** (review and update if keeping)
32. **`eps-specification.md`** (review for consolidation)
33. **`xtehr-mapping.md`** (verify links)
34. **`dependencies.md`**, **`references.md`** (minor updates)
35. **`changes.md`** (add change log entry)

---

## Quick Reference: Page Mapping

| **Old Concept** | **New Concept** | **File Action** |
|---|---|---|
| 6 actors | 5 actors (no Administrator) | Update everywhere |
| T1: Inspect | T1: Inspect | `transaction-T1.md` - minor update |
| T2: Find Patient | T2: Find Patient | `transaction-T2.md` - minor update |
| (missing MHD push) | **T3: Publish Docs** | **`transaction-T3.md` - CREATE (critical!)** |
| T4: Import (UI) | (removed) | `transaction-T4.md` (old) - DELETE |
| T5: Export (UI/Bulk) | (removed) | `transaction-T5.md` (old) - DELETE |
| (MHD ITI-67 implied) | T4: Search Docs | `transaction-T4.md` (new) - CREATE |
| (MHD ITI-68 implied) | T5: Retrieve Doc | `transaction-T5.md` (new) - CREATE |
| (QEDm PCC-44 implied) | T6: Search Resources (optional) | `transaction-T6.md` - CREATE |
| Authorization Option | Required Auth | Update everywhere, create `authorization.md` |
| Multiple APIs for use cases | One API, multiple deployments | Reframe `context.md`, `use-cases.md` |
| Mixed API + content profiles | API here, content in external IGs | Emphasize in priority area pages |
| Administrator actor | (removed) | Remove from `main-usecases.md`, diagrams |
| ITI-1 Maintain Time | (removed) | Remove from `api-specification.md` |

---

## Content to Harvest Before Deletion

Before deleting these files, extract any useful content:

### From `api-specification.md`
- Useful diagrams (save to `/images` or redraw)
- Clear explanations of concepts (reuse in new pages)
- Transaction flows (adapt to new model)

### From `transaction-T4.md` (old Import)
- Any relevant considerations about importing EEHRxF data
- File format details (move to `content-FHIR-file.md` if keeping)
- Bundle validation rules (adapt to T3 Publish)

### From `transaction-T5.md` (old Export)
- Any relevant considerations about bulk data
- Export format details (move to `content-FHIR-file.md` if keeping)
- Bundle construction patterns (adapt to document generation context)

### From `content-FHIR-file.md` (if deleting)
- Bundle structure details
- File naming conventions
- JSON/NDJSON format specs

---

## Key Principles for Refactoring

1. **Simplest thing that works** - avoid over-engineering
2. **Required auth** - SMART Backend Services is not optional
3. **Programmatic document push** - MHD ITI-65 is critical
4. **One API, multiple deployment patterns** - not different APIs
5. **Clinical content lives in external IGs** - we define API only
6. **Content registry** - priority categories link to external IGs
7. **5 actors, not 6** - no Administrator actor
8. **Read/search only for resources** - no generic resource push

---

## Completion Checklist

- [ ] All Phase 1 pages created
- [ ] All Phase 2 pages updated
- [ ] All Phase 3 deletions complete
- [ ] All Phase 4 transaction pages created
- [ ] `sushi-config.yaml` updated
- [ ] Build runs successfully (`_genonce.bat`)
- [ ] No broken links in rendered IG
- [ ] All diagrams updated to 5-actor model
- [ ] No references to Administrator actor remain
- [ ] No references to old T4/T5 (Import/Export) remain
- [ ] All pages reference new functional pages appropriately
- [ ] Authorization consistently described as required
- [ ] Content registry concept explained in relevant pages
- [ ] Priority area pages emphasize API-level requirements only

---

## Notes

- **Transaction T3 (Publish)** is the single most critical missing piece - prioritize this
- **Authorization** shift from optional to required affects many pages
- **Actor model** change from 6 to 5 affects every page with actor references
- **Use case reframing** (one API, multiple deployments) is philosophical shift needed throughout
- **Content separation** (API here, clinical content in external IGs) must be emphasized in priority area pages

