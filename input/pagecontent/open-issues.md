Open issues under discussion in this IG. Each has a corresponding [GitHub Issue](https://github.com/euridice-org/jwg-api/issues) where you can add input to existing issues, or create your own. 

We welcome your input via Github Issues, or by attending the weekly [HL7 Europe API Workgroup Meetings](https://confluence.hl7.org/spaces/HEU/pages/345086021/EU+Health+Data+API+Edition+1).

---

### Issue 1: Document Search and Priority Category Differentiation

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/11) | **Priority:** High

How do we differentiate documents by EHDS Priority Category? Patient Summary, Imaging Results, Medical Test Results, and Hospital Discharge Reports are all FHIR Documents exposed via DocumentReference and MHD. How do we differentiate one from the other for systems that support multiple categories?

This is particularly complex for Medical Test Results and Imaging Results, which are families of many different types (cardiology studies, radiology reports, various lab panels, etc.).

**Current Approach**

Following the [IHE XDS Metadata Coding White Paper](https://wiki.ihe.net/index.php/XDS_classCode_Metadata_Coding_System):

| Parameter | Purpose | Coding System |
|-----------|---------|---------------|
| `category` | Coarse search | XDS ClassCode (REPORTS, SUMMARIES, IMAGES) |
| `type` | Clinical precision | LOINC codes |
| `practiceSetting` | Differentiate within category | Healthcare setting codes |

**Open Questions**

1. **Value Sets**: Should we define local value sets for category/type, or inherit directly from IHE class codes and LOINC? What benefit does local definition provide?

2. **Priority Category Alignment**: Current LOINC codes may be one step too specific for some categories (e.g., labs have many sub-types). How should we handle this terminology gap?

3. **DocumentReference Profiles**: Should there be one shared DocumentReference profile for all priority categories, or separate profiles per priority area? (Recommendation: one shared profile with example instances)

**Seeking Input On**

- Does the category/type/practiceSetting approach align with implementer expectations?
- What search patterns do Member States currently use for document discovery?
- Should we create a priority-category-specific value set, or rely on existing XDS/LOINC codes?

---

### Issue 2: Patient Lookup Strategy

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/12) | **Priority:** High

How should patient lookup work in the European context? In most EU situations, we expect patient identifiers (MRN, national ID) to be available. Demographic-based matching is needed when identifiers are not available.

**Current Approach**

The IG currently references three mechanisms:
- [PDQm ITI-78](https://profiles.ihe.net/ITI/PDQm/) - Demographics-based patient search. Currently required in PDQm.
- [PDQm Patient Demographics Match ITI-119](https://profiles.ihe.net/ITI/PDQm/ITI-119.html) - FHIR $match fuzzy matching operation (currently optional in PDQm)
- [PIXm](https://profiles.ihe.net/ITI/PIXm/) - Identifier cross-reference (mentioned but not fully modeled)

**Proposed Simplification**

Reduce to two primary options:

1. **Identifier Lookup** - MRN or national ID based lookup (covers ~90% of EU use cases). Question: how do we formally model this with IHE ITI? May be a constrained profile of ITI-78.

2. **Patient $match** - For demographic-based fuzzy matching when identifier is not available. This is the existing PDQm $match operation.

**Open Questions**

- How should we model the identifier lookup transaction formally with IHE?
- Should CapabilityStatement advertise which national ID systems are supported for lookup?
- We should inherit Patient from EU Core. Does this change anything about the transaction definitions?

**Seeking Input On**

- Does the two-option approach (identifier lookup + $match) cover European use cases?
- Are there use cases requiring full PDQm demographics search that $match doesn't cover?
- Is PIXm needed, or can we achieve the same with constrained PDQm?

---

### Issue 3: MHD Publication Transaction Options

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/13) | **Priority:** High

MHD offers multiple transaction options for document publication. We want to reduce optionality and avoid introducing XDS dependencies where possible (For example: native FHIR servers don't need XDS submission set constructs).

**MHD Options**

- [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html) - Full publication with metadata (required in IHE)
- [ITI-105 Simplified Publish](https://profiles.ihe.net/ITI/MHD/ITI-105.html) - Simplified publication
- [ITI-106 Generate Metadata](https://profiles.ihe.net/ITI/MHD/ITI-106.html) - Server generates metadata from the document (needed?)

**Proposal**

Use ITI-65 Provide Document Bundle as the primary approach since it's required in IHE MHD. This provides a clear, single path for implementers.

**Seeking Input On**

- Is ITI-65 appropriate as the primary/only publication mechanism?
- Does this introduce XDS SubmissionSet dependancies that don't make sense to FHIR servers?
- Are there use cases requiring Generate Metadata or Simplified Publish?

---

### Issue 4: Resource Access and Inheritance

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/14) | **Priority:** High

Resource access (granular RESTful FHIR resource queries) could inherit from multiple specifications (IPA, QEDM). We need to clarify the inheritance.

We should inherit resource models from [EU Core](https://build.fhir.org/ig/hl7-eu/base/index.html) - and in this IG we need to define (1) Resource search parameters and (2) CapabilityStatements.

IPA and QEDm are similar, but use slightly different search parameters (analysis needs to be done). Both profiles seem to be open to alignment with each other. Group generally prefers IPA - more adoption and maintenance.

**Current Approach**

- **Data Models**: Inherit from EU Core profiles
- **Search Parameters**: Copied from IPA
- **Transactions**: Reference both IPA and QEDm, preferencing IPA

**Proposed Approach**

Start with IPA as foundation:
1. **EU Core** for data models (profile definitions)
2. **IPA** for search parameters and CapabilityStatement patterns
3. **QEDm** alignment where needed (comparison analysis required)

A separate issue ([Issue 9](#issue-9-core-resource-set-validation)) tracks validation of the core resource set.

**Seeking Input On**

- Here is the IPA foundation approach. Does it make sense for European use cases?
- A comparison analysis between IPA and QEDm is needed. How should we handle differences?

---

### Issue 5: CapabilityStatement and Priority Category Declaration

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/15) | **Priority:** Medium

Should servers declare which EHDS Priority Categories they support? How? Should this be in CapabilityStatement?

**Options**

1. **CapabilityStatement.instantiates** - Reference priority-category-specific CapabilityStatements (these would be example instances)
2. **CapabilityStatement extensions** - Custom extensions declaring supported categories
3. **Supported document type ValueSets** - Declare via supported DocumentReference.type bindings

**Seeking Input On**

- Is priority category declaration needed at the CapabilityStatement level?
- Which approach best balances expressiveness with implementation simplicity?

---

### Issue 6: Authorization Server Deployment

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/16) | **Priority:** Medium

The Document Access Provider composite actor currently groups several IHE actors, including IUA Authorization Server. The key question is whether the Authorization Server should be assumed as part of the Document Access Provider?

Consider from the perspective of the EHR system evaluating conformance of their interoperability Component.

**Current Grouping**

The Document Access Provider includes:
- IUA Resource Server
- **IUA Authorization Server** (under consideration here)
- MHD Document Responder
- MHD Document Recipient
- PDQm Patient Demographics Supplier

**Context**

For EHR systems seeking conformance: are you bundling an authorization server, or using an external one?

Authorization may be handled external to the EHR at a Member State level - with the EHR system acting as a *Document Producer* (authorization client) and the Member State infrastructure acts as the *Document Access Provider* with an authorization server.

**Seeking Input On**

- Is the assumption that Authorization Server is grouped with Document Access Provider valid for your deployment?
- Should we reconsider this as an optional grouping?

---

### Issue 7: R4/R5 Harmonization

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/17) | **Priority:** Medium

This IG targets FHIR R4, but some European specifications are R5-based. The EU Extensions package is R5, creating warnings in the R4 build. The HL7 Europe Imaging Study Manifest is also R5-based.

**Seeking Input On**

- How should we handle R5 dependencies in an R4 IG?

---

### Issue 8: Imaging Manifest Coding

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/18) | **Priority:** Medium

Imaging manifests (DICOM study references) need more detail on how they are exposed in document searches. No standard LOINC code exists for imaging manifests. How should a consumer search for Imaging Manifests, and how are they differentiated from other documents?

**Current Approach**

- Delivered via MHD transactions
- Use `category` = IMAGES (XDS ClassCode)
- Use `format` to indicate DICOM content

This is related to [Issue 1](#issue-1-document-search-and-priority-category-differentiation) but specific to imaging.

**Seeking Input On**

- Is the current coding approach (category + format) appropriate for imaging manifests?
- What coding approach should be used?

---

### Issue 9: Core Resource Set Validation

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/19) | **Priority:** Medium

The following resources are proposed as the core set for resource access (e.g. resource search entry points specifically, not all included resources). This needs validation from Priority Category owners.

Shared
- Patient
- Practitioner
- Organization

Patient Summary
- Condition
- AllergyIntolerance
- MedicationRequest
- MedicationStatement
- Immunization

ePrescription/eDispensation
- MedicationRequest
- MedicationDispense

Medical Test Results
- Observation
- DiagnosticReport

Imaging Results
- DiagnosticReport
- ImagingStudy (note: R5 resource, linked to [Issue 7](#issue-7-r4r5-harmonization)

Discharge Reports
- Encounter


**Seeking Input On**

- Is this resource set appropriate for the priority categories?
- Are any resources missing that should be included?
- Should Encounter be required?

---

### Issue 10: FHIR Documents vs Resources Guidance

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/20) | **Priority:** Low

The IG supports both document exchange (FHIR Documents via MHD) and resource access (granular FHIR resources). A documentation page explaining when to use each pattern would be helpful.

**Seeking Input On**

- What use cases require document exchange vs resource access in your context?
- Would you be interested in contributing this documentation?

---

### Issue 11: MPD Workflow vs MedicationRequest Resource Access

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/21) | **Priority:** Medium

The IG needs to clearly distinguish between medication resource access (in scope) and prescription workflow orchestration (out of scope, handled by MPD). Also this scope line should be reviewed with MPD Priority Category owners.

**In Scope (This IG)**

Resource access queries like "which medications is this patient taking?" - reading MedicationRequest, MedicationStatement, and MedicationDispense resources.

**Out of Scope (MPD)**

Prescription workflow orchestration like "transfer prescription authorization for dispense" - the workflow transactions for ePrescription and eDispensation are handled by [IHE MPD](https://profiles.ihe.net/PHARM/MPD/index.html)

**Seeking Input On**

- Is this distinction clear in the current IG?
- Are there medication-related use cases that fall between these two categories?
- Should we handle it differently?
