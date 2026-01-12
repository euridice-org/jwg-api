# Open Issues

This page tracks open issues requiring reviewer feedback. We encourage reviewers to provide comments via [GitHub Issues](https://github.com/euridice-org/jwg-api/issues) so that discussion can be centralized and tracked.

For each issue below, we provide context and seek input from Member States, implementers, and Priority Category experts.

---

## Issue 1: Patient Lookup Strategy

**Status:** Decision needed
**Priority:** High
**GitHub:** [Create Issue](#)

### Context

Patient lookup is fundamental to all EHR API transactions. Currently, the IG references both PDQm and PIXm for patient lookup, creating "all of the above" interoperability which reduces clarity for implementers.

### Current Approach

The IG currently supports:
- [PDQm](https://profiles.ihe.net/ITI/PDQm/) - Demographics-based patient search
- [PIXm](https://profiles.ihe.net/ITI/PIXm/) - Identifier cross-reference lookup
- Patient `$match` operation - Fuzzy matching

### Proposed Simplification

Reduce to two primary options:

1. **Identifier Lookup** (covers ~90% of use cases)
   - MRN or national ID based lookup
   - May be a profile/constraint on ITI-78
   - Simple and predictable

2. **Patient $match** (fallback when identifier unknown)
   - For fuzzy matching on demographics
   - Used when patient identifier is not available

Patient.search with name parameters should NOT be a third option—use `$match` instead when demographics-based matching is needed.

### Related Questions

- How should we formally model the identifier lookup transaction with IHE ITI?
- Should CapabilityStatement advertise which national ID systems are supported for lookup?
- Which Patient profile should be used: EU Core or FHIR base? (Recommendation: EU Core)

### Seeking Input On

- Is the two-option approach (identifier lookup + $match) appropriate for European use cases?
- What identifier systems are commonly used across Member States?
- Are there use cases requiring full PDQm demographics search that $match doesn't cover?

---

## Issue 2: Document Search and Priority Category Differentiation

**Status:** Seeking guidance
**Priority:** High (Chief Issue)
**GitHub:** [Create Issue](#)

### Context

A core challenge is how to differentiate documents by EHDS Priority Category. This is particularly complex for Laboratory and Imaging, which are families of tests with many sub-types.

### Current Approach

Following the [IHE XDS Metadata Coding White Paper](https://wiki.ihe.net/index.php/XDS_classCode_Metadata_Coding_System):

| Parameter | Purpose | Coding System |
|-----------|---------|---------------|
| `category` | Coarse search | XDS ClassCode (REPORTS, SUMMARIES, IMAGES, etc.) |
| `type` | Clinical precision | LOINC codes |
| `practiceSetting` | Differentiate within category | Healthcare setting codes |

For example, to differentiate Laboratory Reports from Imaging Reports:
- Both may have `category` = REPORTS
- `type` uses different LOINC codes
- `practiceSetting` indicates lab vs. radiology setting

### Open Questions

1. **Value Sets**: Should we define local value sets for category/type, or inherit directly from IHE class codes and LOINC? What benefit does local definition provide?

2. **Priority Category Alignment**: Current LOINC codes don't perfectly align with EEHRxF priority category names:
   - "Laboratory Report" (LOINC 11502-2) vs. "Medical Test Results" priority category
   - How should we handle this terminology gap?

3. **DocumentReference Profiles**: Should there be one shared DocumentReference profile for all priority categories, or separate profiles per priority area?
   - Recommendation: One shared profile with example instances for each priority category
   - Trade-off: Flexibility vs. explicit validation

4. **Imaging Manifest Coding**: No clean LOINC code exists for imaging manifests (DICOM references). Current approach uses `category`=IMAGES with format indicating DICOM content. Is this appropriate?

### Seeking Input On

- Does the category/type/practiceSetting approach align with implementer expectations?
- What search patterns do Member States currently use for document discovery?
- Should we create a priority-category-specific value set, or rely on existing XDS/LOINC codes?

---

## Issue 3: MHD Transaction Options

**Status:** Decision needed
**Priority:** High
**GitHub:** [Create Issue](#)

### Context

MHD offers multiple transaction options for document publication. Having multiple options creates complexity and interoperability challenges.

### Current State

MHD provides:
- **ITI-65 Provide Document Bundle** - Full publication with metadata
- **ITI-106 Generate Metadata** - Server generates metadata from document
- Other options...

### Proposal

Pick one primary approach to reduce optionality and simplify implementation guidance.

### Seeking Input On

- Which MHD transaction pattern is most appropriate for European EHR systems?
- Are there use cases requiring Generate Metadata vs. Provide Document Bundle?
- Should we mandate one and make others optional/discouraged?

---

## Issue 4: Resource Access and Inheritance

**Status:** Analysis needed
**Priority:** High
**GitHub:** [Create Issue](#)

### Context

Resource access (granular FHIR resource queries) can inherit from multiple specifications: IPA, QEDm, and EU Core. We need to clarify the inheritance hierarchy and identify any conflicts.

### Current Approach

- **Data Models**: Inherit from EU Core profiles
- **Search Parameters**: Currently borrowed from IPA
- **Transactions**: Reference both IPA and QEDm

### Proposed Approach

1. **EU Core** for data models (profile definitions)
2. **IPA** for search parameters and CapabilityStatement patterns
3. **QEDm** alignment where possible (need conflict analysis)

### Core Resources

The following resources are in scope for resource access:
- Patient, Practitioner, Organization
- Condition, AllergyIntolerance
- MedicationRequest, MedicationStatement
- Observation, DiagnosticReport
- Encounter, Immunization

### Open Questions

1. **IPA vs QEDm**: Are there conflicts between IPA and QEDm requirements? Need comparison analysis.
2. **Search Parameters**: Are IPA search parameters appropriate, or do we need European-specific additions?
3. **Encounter**: Should Encounter be required (current recommendation) or optional?

### Seeking Input On

- Is IPA the right foundation for search parameters?
- What QEDm requirements should we incorporate?
- Are there European-specific search needs not covered by IPA?

---

## Issue 5: CapabilityStatement and Priority Category Declaration

**Status:** Seeking guidance
**Priority:** Medium
**GitHub:** [Create Issue](#)

### Context

How should servers declare which EHDS Priority Categories they support? The current CapabilityStatement approach may not adequately express this.

### Options

1. **CapabilityStatement.instantiates** - Reference priority-category-specific CapabilityStatements
2. **CapabilityStatement extensions** - Custom extensions declaring supported categories
3. **Supported document type ValueSets** - Declare via supported DocumentReference.type bindings
4. **Priority category-specific CapabilityStatements** - Separate CapabilityStatement per category

### Seeking Input On

- Is priority category declaration needed at the CapabilityStatement level?
- Which approach best balances expressiveness with implementation simplicity?
- How do existing Member State systems declare document type support?

---

## Issue 6: Authorization Server Deployment

**Status:** Seeking feedback
**Priority:** Medium
**GitHub:** [Create Issue](#)

### Context

Implementation examples assume the authorization server is grouped with (part of) the Document Access Provider. This may not hold in all deployments.

### Current Assumption

The Document Access Provider composite actor includes:
- IUA Authorization Server
- IUA Resource Server
- MHD Document Responder
- PDQm Patient Demographics Supplier

### Open Questions

- Is this assumption valid for most European deployments?
- How should we handle distributed authorization server scenarios?
- Should diagrams show this as optional grouping?

### Seeking Input On

- Do your systems have separate authorization servers from EHR/document servers?
- What authorization architecture patterns are common in your Member State?

---

## Issue 7: Imaging Manifest and R4/R5 Harmonization

**Status:** Seeking guidance
**Priority:** Medium
**GitHub:** [Create Issue](#)

### Context

This IG targets FHIR R4, but some European specifications (including HL7 Europe Imaging Study Manifest) are R5-based. Additionally, imaging manifests require special handling.

### Imaging Manifest Approach (R4)

Current approach for imaging manifests (DICOM references):
- Delivered via MHD transactions
- Use `category` = IMAGES (XDS ClassCode)
- Use `format` to indicate DICOM content
- No standard LOINC code exists for imaging manifests

### R4/R5 Considerations

- EU Extensions package is R5, creating warnings in R4 build
- HL7 Europe Imaging Study Manifest is R5-based
- Need harmonization strategy

### Seeking Input On

- Is the R4-first approach appropriate, with R5 as future direction?
- How should we handle R5 dependencies in an R4 IG?
- What imaging manifest coding approach works for your systems?

---

## Issue 8: JWT Algorithm Requirements

**Status:** Seeking guidance
**Priority:** Low
**GitHub:** [Create Issue](#)

### Context

For SMART Backend Services authorization, should we require strict JWT signing algorithms or allow flexibility?

### Options

1. **Strict**: Require RS384 or ES384 only (stronger security)
2. **Flexible**: Allow multiple algorithms per SMART Backend Services spec

### Seeking Input On

- What JWT algorithms are your systems currently using?
- Are there regulatory requirements for specific algorithms in your Member State?

---

## Issue 9: FHIR Documents vs. Resources Guidance

**Status:** Content needed
**Priority:** Low
**GitHub:** [Create Issue](#)

### Context

The IG supports both document exchange (FHIR Documents via MHD) and resource access (granular FHIR resources). Guidance is needed on when to use each pattern.

### Seeking Input On

- What use cases require document exchange vs. resource access in your context?
- Would expanded guidance on choosing between patterns be helpful?

---

## How to Provide Feedback

We welcome feedback through:

1. **GitHub Issues** (preferred): [https://github.com/euridice-org/jwg-api/issues](https://github.com/euridice-org/jwg-api/issues)
2. **Email**: For those without GitHub access, contact the working group via [HL7 Europe](http://hl7.eu)

When providing feedback, please:
- Reference the issue number (e.g., "Issue 2: Document Search")
- Describe your use case or context
- Provide specific recommendations where possible
