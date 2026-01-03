# IPA vs QEDm: Resource Search Constraint Analysis

**Date:** 2026-01-03
**Status:** Decision Analysis - Current implementation uses QEDm; IPA and synthesis approaches under consideration

## Executive Summary

At their core, both IPA and QEDm are collections of atomic search constraints for FHIR resources. The choice comes down to:
1. **Resource coverage** - which clinical data types to support
2. **Search constraint strictness** - how prescriptive to be (SHALL vs SHOULD)
3. **Actor model fit** - how these map to EURIDICE's composite actors

The current `/input/fsh/resource-all.fsh` implements QEDm. This analysis compares the two approaches to inform the final decision.

---

## High-Level Structure

### QEDm Clinical Data Source CapabilityStatement

```
┌─────────────────────────────────────────────────────────────────────┐
│           IHE QEDm Clinical Data Source (EURIDICE API)              │
│                      PCC-44: Mobile Query Existing Data             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │  CORE DESIGN PRINCIPLES       │
                    ├───────────────────────────────┤
                    │ • Patient-scoped queries ONLY │
                    │ • Read/Search ONLY (no write) │
                    │ • Document-derived resources  │
                    │ • Provenance tracking         │
                    └───────────────┬───────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
    ┌───▼────┐              ┌──────▼──────┐           ┌───────▼──────┐
    │Clinical│              │ Medications │           │  Provenance  │
    │ Data   │              │             │           │  & Context   │
    └────────┘              └─────────────┘           └──────────────┘
        │                           │                         │
    ┌───┴────────┐          ┌──────┴──────┐         ┌────────┴────────┐
    │• Allergy   │          │• Medication │         │• Provenance     │
    │• Condition │          │• MedRequest │         │• Patient        │
    │• Immunize  │          │• MedStmt    │         │• Practitioner   │
    │• Observe   │          └─────────────┘         │• PractRole      │
    │• DiagRpt   │                                  │• Encounter      │
    │• Procedure │                                  └─────────────────┘
    └────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                     SEARCH PATTERN MATRIX                           │
├─────────────────────────────────────────────────────────────────────┤
│  Resource Type    │ Base Query         │ Refinement Options        │
├───────────────────┼────────────────────┼───────────────────────────┤
│  AllergyIntoler   │ patient (SHALL)    │ (none specified)          │
│  Condition        │ patient (SHALL)    │ +category, +clinical-stat │
│  Observation      │ patient (combo)    │ +category, +code, +date   │
│  DiagnosticReport │ patient (SHALL)    │ +category, +code, +date   │
│  MedicationReq    │ patient (SHALL)    │ (none)                    │
│  Immunization     │ patient (SHALL)    │ (none)                    │
│  Procedure        │ patient (SHALL)    │ +date                     │
│  Encounter        │ patient (SHALL)    │ +date                     │
└───────────────────┴────────────────────┴───────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                   PROVENANCE LINKAGE MODEL                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   DocumentReference ◄────────────────┐                             │
│   (Source Document)                  │                             │
│                                      │                             │
│                            ┌─────────┴──────────┐                  │
│                            │   Provenance       │                  │
│                            │ • target: resource │                  │
│                            │ • entity: DocRef   │                  │
│                            └─────────┬──────────┘                  │
│                                      │                             │
│   Observation/Condition/etc ◄────────┘                             │
│   (Derived Resource)                                               │
│                                                                     │
│   Use: _revinclude=Provenance:target to trace source              │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Resource Coverage Comparison

### Resources Supported

| Resource | IPA | QEDm | Notes |
|----------|-----|------|-------|
| **AllergyIntolerance** | ✓ (SHALL) | ✓ (SHOULD) | Core clinical data |
| **Condition** | ✓ (SHALL) | ✓ (SHOULD) | Core clinical data |
| **DocumentReference** | ✓ (SHALL) | ✓ (commented: "see MHD") | IPA uses $docref; QEDm defers to MHD |
| **Immunization** | ✓ (SHALL) | ✓ (SHOULD) | Core clinical data |
| **Medication** | ✓ (SHOULD) | ✓ (SHOULD) | Referenced from Requests/Statements |
| **MedicationRequest** | ✓ (SHALL) | ✓ (SHOULD) | Prescriptions |
| **MedicationStatement** | ✓ (SHALL) | ✓ (SHOULD) | Medication history |
| **Observation** | ✓ (SHALL) | ✓ (SHOULD) | Core clinical data |
| **Patient** | ✓ (SHALL) | ✓ (commented: "see PDQm") | IPA defines search; QEDm defers to PDQm |
| **Practitioner** | ✓ (SHOULD) | ✓ (SHOULD, commented) | Context resource |
| **PractitionerRole** | ✓ (SHOULD) | ✓ (SHOULD, commented) | Context resource |
| **DiagnosticReport** | ✗ | ✓ (SHOULD) | **QEDm adds this** |
| **Procedure** | ✗ | ✓ (SHOULD) | **QEDm adds this** |
| **Encounter** | ✗ | ✓ (SHOULD) | **QEDm adds this** |
| **Provenance** | ✗ | ✓ (SHOULD) | **QEDm adds this** |

**Summary:**
- **IPA:** 11 resources (9 core, 2 context)
- **QEDm:** 15 resources (13 active, 2 commented for other specs)
- **QEDm additions:** DiagnosticReport, Procedure, Encounter, Provenance
- **Overlap:** 11 resources common to both

---

## Search Constraint Comparison

### AllergyIntolerance

| Search Parameter | IPA | QEDm |
|------------------|-----|------|
| `patient` | SHALL | SHALL |
| `clinical-status` | MAY | (not specified) |

**Conclusion:** Essentially identical. IPA adds optional clinical-status filter.

---

### Condition

| Search Parameter | IPA | QEDm | Search Combinations |
|------------------|-----|------|---------------------|
| `patient` | SHALL | SHALL | - |
| `category` | SHALL | SHOULD | IPA: SHALL support patient+category |
| `clinical-status` | SHALL | SHOULD | QEDm: SHOULD support patient+clinical-status |
| `code` | MAY | (commented out) | QEDm: SHOULD support patient+category |
| `onset-date` | MAY | (commented out) | - |

**Conclusion:** IPA is more prescriptive (category+clinical-status are SHALL). QEDm is more flexible (SHOULD).

---

### Observation

| Search Parameter | IPA | QEDm | Search Combinations |
|------------------|-----|------|---------------------|
| `patient` | SHALL | SHALL (in combo) | - |
| `category` | SHALL | SHALL | IPA: SHALL patient+category |
| `code` | SHALL | SHALL | QEDm: SHALL patient+category, patient+code |
| `date` | SHALL | SHALL | QEDm: SHALL patient+category+date, SHOULD patient+code+date |
| `status` | MAY | (not specified) | - |

**Conclusion:** Very similar. Both require patient+category+code+date. QEDm specifies more combinations explicitly.

---

### MedicationRequest

| Search Parameter | IPA | QEDm |
|------------------|-----|------|
| `patient` | SHALL | SHALL |
| `intent` | SHALL | (commented out) |
| `status` | SHALL | (commented out) |
| `authoredon` | SHOULD | (commented out) |

**Conclusion:** IPA requires intent+status filters. QEDm only requires patient (simpler).

---

### MedicationStatement

| Search Parameter | IPA | QEDm |
|------------------|-----|------|
| `patient` | SHALL | SHALL |
| `status` | SHALL | (commented out) |

**Conclusion:** IPA requires status filter. QEDm only requires patient.

---

### DiagnosticReport (QEDm only)

| Search Parameter | Expectation | Search Combinations |
|------------------|-------------|---------------------|
| `patient` | SHALL | - |
| `category` | SHALL | patient+category (SHALL) |
| `code` | SHALL | patient+category+code (SHALL) |
| `date` | SHALL | patient+category+date (SHALL) |
| `status` | MAY | - |

**Conclusion:** QEDm provides comprehensive lab/imaging report query capability. IPA doesn't include this resource.

---

### Procedure (QEDm only)

| Search Parameter | Expectation | Search Combinations |
|------------------|-------------|---------------------|
| `patient` | SHALL | - |
| `date` | SHALL | patient+date (SHALL) |

**Conclusion:** QEDm provides procedure history queries. IPA doesn't include this resource.

---

### Encounter (QEDm only)

| Search Parameter | Expectation | Search Combinations |
|------------------|-------------|---------------------|
| `patient` | SHALL | - |
| `date` | SHALL | patient+date (SHALL) |

**Conclusion:** QEDm provides encounter history queries. IPA doesn't include this resource.

---

### Provenance (QEDm only)

| Search Parameter | Expectation |
|------------------|-------------|
| `target` | SHALL |

**Conclusion:** QEDm supports tracing resources back to source documents. IPA doesn't include this capability.

---

## Search Constraint Philosophy

### IPA Approach
- **Stricter requirements:** More SHALL constraints, especially for filtered searches
- **Patient summary focus:** Resources/searches optimized for "show me my health record"
- **Mandatory filters:** Requires status/intent parameters to ensure clients can filter active/completed items
- **9 core resources:** Focused scope for patient access use case

### QEDm Approach
- **Flexible requirements:** More SHOULD constraints, fewer mandatory filters
- **Clinical query focus:** Resources/searches optimized for "query patient data in another system"
- **Simple base queries:** Often just patient parameter required; refinements optional
- **13+ resources:** Broader scope including diagnostics, procedures, encounters
- **Provenance tracking:** Explicit support for linking resources to source documents

---

## Actor Model Fit

### Current EURIDICE Actor Model

From `/input/pagecontent/actors.md`:

```
Composite Actor: Resource Access Provider
├─ IHE Clinical Data Source (QEDm) OR HL7 IPA Server (alternative)
└─ grouped with optional Resource Producer (generates resources internally)
```

### Mapping Options

**Option 1: Pure QEDm**
```
Resource Access Provider CapabilityStatement = QEDm Clinical Data Source
- 13 resources with SHOULD constraints
- Provenance support
- Works with MHD for document extraction
```

**Option 2: Pure IPA**
```
Resource Access Provider CapabilityStatement = IPA Server
- 9 resources with SHALL constraints
- Stricter interoperability guarantees
- Well-adopted specification
```

**Option 3: Synthesis (QEDm base + IPA profiles)**
```
Resource Access Provider CapabilityStatement = Custom
- QEDm resource coverage (13 resources)
- IPA profile constraints for shared resources (stricter interop)
- QEDm extensions: DiagnosticReport, Procedure, Encounter, Provenance
- Best of both worlds
```

**Option 4: Dual Support**
```
Resource Access Provider offers TWO CapabilityStatements:
- /metadata?mode=ipa → IPA-compliant subset
- /metadata?mode=qedm → Full QEDm capabilities
- Clients choose based on their needs
```

---

## Current Implementation State

### `/input/fsh/resource-all.fsh` (931 lines)

**Current state:** Implements QEDm Clinical Data Source
- Single CapabilityStatement instance: `IHE.QEDm.Clinical-Data-Source`
- 13 resource types with detailed search parameters
- All IPA profile references commented out:
  ```fsh
  // Line 49:  //* rest.resource[=].profile = "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-allergyintolerance"
  // Line 120: //* rest.resource[=].profile = "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-condition"
  ```
- Uses base FHIR resources, not IPA profiles

**Dependencies in `sushi-config.yaml`:**
```yaml
dependencies:
  hl7.fhir.uv.bulkdata: current
  hl7.fhir.eu.base: current
  ihe.iti.pdqm: 3.1.0
  ihe.iti.mhd: 4.2.2
  # Note: NO IPA dependency
```

**TODO comment in codebase:**
> "TODO: Analysis of what to inherit from IPA vs IHE QEDm vs EU Core."

---

## Decision Factors

### Factors Favoring QEDm

1. **Broader resource coverage**
   - DiagnosticReport, Procedure, Encounter not in IPA
   - Provenance for document traceability

2. **Flexibility for EU implementations**
   - SHOULD constraints allow diverse national EHR capabilities
   - Less prescriptive = easier conformance

3. **Document-first alignment**
   - Designed to work alongside MHD
   - Provenance links resources → source documents

4. **Current implementation**
   - Already implemented in resource-all.fsh
   - No breaking changes needed

### Factors Favoring IPA

1. **Stricter interoperability**
   - More SHALL constraints = better consistency
   - Well-defined MustSupport elements

2. **Broader adoption**
   - HL7 International standard
   - Growing ecosystem of IPA-compliant systems

3. **Patient-centric design**
   - Optimized for "patient summary" use case
   - Mandatory filters (status, intent) improve usability

4. **Proven specification**
   - Mature, published IG
   - Extensive implementation experience

### Factors Favoring Synthesis

1. **Best of both worlds**
   - QEDm resource coverage + IPA profile rigor
   - EU flexibility + international interop

2. **Layered approach**
   - Base: QEDm search capabilities
   - Profiles: IPA constraints on shared resources
   - Extensions: QEDm-specific resources

3. **Future-proofing**
   - Align with both IHE and HL7 ecosystems
   - Easier to adapt as specifications evolve

---

## Key Decision Points

### 1. Resource Scope Decision
**Question:** Which resources must EURIDICE support?

- **If 9 core resources sufficient:** IPA is simpler
- **If DiagnosticReport/Procedure/Encounter needed:** QEDm or synthesis required
- **Action:** Separate analysis of EEHRxF priority areas → required FHIR resources

### 2. Constraint Strictness Decision
**Question:** How prescriptive should search constraints be?

- **Strict (IPA):** Better interop, harder for diverse EU systems to conform
- **Flexible (QEDm):** Easier conformance, potential for inconsistency
- **Hybrid:** SHALL for core searches, SHOULD for refinements

### 3. Profile Decision
**Question:** Use IPA profiles, EU Core profiles, or base FHIR?

- **IPA profiles:** International consistency, MustSupport clarity
- **EU Core profiles:** European-specific requirements (dependency already present)
- **Base FHIR:** Maximum flexibility, no profile constraints
- **Synthesis:** EU Core base + IPA search patterns

### 4. Actor Model Decision
**Question:** What does "Resource Access Provider" declare in its CapabilityStatement?

- **Single CS:** Choose one specification (IPA or QEDm)
- **Dual CS:** Support both patterns, clients choose
- **Custom CS:** Synthesize requirements from both

---

## Provenance Model (QEDm-specific)

### Document-to-Resource Linkage

```
┌─────────────────────────────────────────────────────────────────────┐
│                   PROVENANCE LINKAGE MODEL                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   DocumentReference ◄────────────────────────────────┐             │
│   (EEHRxF Source Document)                           │             │
│                                                      │             │
│                            ┌─────────────────────────┴──┐          │
│                            │   Provenance               │          │
│                            │ • target: Observation/123  │          │
│                            │ • entity.what: DocRef/abc  │          │
│                            │ • entity.role: source      │          │
│                            └─────────────────────────┬──┘          │
│                                                      │             │
│   Observation/123 ◄──────────────────────────────────┘             │
│   (Extracted FHIR Resource)                                        │
│                                                                     │
│   Query: GET /Observation/123?_revinclude=Provenance:target        │
│   Returns: Observation + Provenance → trace back to source doc     │
└─────────────────────────────────────────────────────────────────────┘
```

**Use case:**
1. EEHRxF document received via MHD (ITI-65)
2. System extracts Observation resources from document
3. Provenance created linking Observation → DocumentReference
4. Client queries: `GET /Observation?patient=X&_revinclude=Provenance:target`
5. Response includes extracted resources + provenance showing document source

**IPA equivalent:** Not specified (IPA doesn't require provenance)

---

## Synthesis Approach Example

### Proposed Hybrid CapabilityStatement

```fsh
Instance: EURIDICE.ResourceAccessProvider
InstanceOf: CapabilityStatement
Title: "EURIDICE Resource Access Provider"
Usage: #definition

// Base structure from QEDm
* description = "Resource Access Provider supporting EEHRxF data queries"
* rest.mode = #server

// Shared resources: Use IPA profiles + QEDm search patterns
* rest.resource[0].type = #AllergyIntolerance
* rest.resource[=].profile = "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-allergyintolerance"
* rest.resource[=].searchParam[0].name = "patient"
* rest.resource[=].searchParam[=].extension.valueCode = #SHALL

* rest.resource[1].type = #Condition
* rest.resource[=].profile = "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-condition"
* rest.resource[=].supportedProfile = "http://hl7.org/fhir/eu/..." // EU Core overlay
* rest.resource[=].searchParam[0].name = "patient"
* rest.resource[=].searchParam[=].extension.valueCode = #SHALL
* rest.resource[=].searchParam[1].name = "category"
* rest.resource[=].searchParam[=].extension.valueCode = #SHALL  // IPA strictness

// QEDm-specific resources: No IPA profile available
* rest.resource[9].type = #DiagnosticReport
* rest.resource[=].profile = "http://hl7.org/fhir/eu/..." // EU Core or custom
* rest.resource[=].searchParam[0].name = "patient"
* rest.resource[=].searchParam[=].extension.valueCode = #SHALL
* rest.resource[=].searchParam[1].name = "category"
* rest.resource[=].searchParam[=].extension.valueCode = #SHALL

* rest.resource[10].type = #Provenance
* rest.resource[=].supportedProfile = "https://profiles.ihe.net/ITI/mXDE/StructureDefinition/IHE.ITI.mXDE.Provenance"
// ... QEDm provenance support
```

**Benefits:**
- IPA profile rigor for 9 core resources
- QEDm resource coverage (DiagnosticReport, Procedure, Encounter, Provenance)
- EU Core overlay where applicable
- Clearer interoperability expectations

---

## Recommendations for Decision Process

### Step 1: Resource Scope Analysis (Separate TODO)
- Map EEHRxF priority areas → FHIR resources needed
- Determine if IPA's 9 resources sufficient or QEDm's 13+ required
- Document: `/josh/resource_scope_analysis.md`

### Step 2: Stakeholder Input
- EU member state EHR capabilities (can they support strict SHALL constraints?)
- EURIDICE implementation timeline (IPA = proven, QEDm = flexible)
- Ecosystem alignment (HL7 International vs IHE Europe)

### Step 3: Technical Prototyping
- Test IPA profiles against EU Core profiles (conflicts?)
- Validate QEDm+IPA synthesis approach (is it feasible?)
- Performance testing (do strict search combinations add value?)

### Step 4: Document Decision
- Update `/input/pagecontent/actors.md` with chosen approach
- Revise `/input/fsh/resource-all.fsh` or create new CapabilityStatement
- Add IPA dependency if chosen: `hl7.fhir.uv.ipa: 1.0.0` (or current)

---

## Current Status

**Implementation:** QEDm Clinical Data Source in `resource-all.fsh` (931 lines)
- 13 resources with SHOULD constraints
- IPA profile references commented out
- No IPA dependency in sushi-config.yaml

**Documentation:** Actors.md mentions both QEDm (primary) and IPA (alternative)

**Decision:** **PENDING** - This document supports the decision process
- Resource scope analysis flagged as separate TODO
- IPA is under consideration; synthesis approach possible
- Final choice to be made after resource scope determination

---

## Appendix: At Its Core

As noted in the analysis framing: both specifications are fundamentally **collections of atomic search constraints**. The 931-line `resource-all.fsh` file is essentially:

```
DiagnosticReport.search[patient] = SHALL
DiagnosticReport.search[category] = SHALL
DiagnosticReport.search[code] = SHALL
DiagnosticReport.search[date] = SHALL
DiagnosticReport.searchCombination[patient+category] = SHALL
DiagnosticReport.searchCombination[patient+category+code] = SHALL
DiagnosticReport.searchCombination[patient+category+date] = SHALL

Observation.search[patient] = SHALL
Observation.search[category] = SHALL
Observation.search[code] = SHALL
... (repeated for 13 resources)
```

The strategic question is simply: **which collection of atomic constraints best serves EURIDICE's needs?**

- IPA's 9 resources with stricter constraints?
- QEDm's 13 resources with flexible constraints?
- A synthesis of both?

The answer depends on resource scope requirements (separate analysis pending).
