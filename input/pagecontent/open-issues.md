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

The IG inherits directly from [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/) with two transaction options:

1. **[ITI-78] Mobile Patient Demographics Query** (Required) - Patient search with `identifier` as a required parameter. This constrains the standard PDQm transaction to require identifier-based lookup, covering the majority of EU use cases.

2. **[ITI-119] Patient Demographics Match** (Optional) - FHIR $match operation for fuzzy demographic matching when identifier is not available.

This simplification removes the middle option of full demographics-based search (family + given + birthdate), which is not suitable for safe clinical patient matching.

**Open Questions**

- Should CapabilityStatement advertise which national ID systems are supported for lookup?
- We should inherit Patient from EU Core. Does this change anything about the transaction definitions?

**Seeking Input On**

- Does the two-option approach (ITI-78 with identifier required + ITI-119 $match) cover European use cases?
- Are there scenarios where identifier-based lookup is insufficient and $match is not appropriate?

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

[GitHub Issue](https://github.com/euridice-org/jwg-api/issues/14) | **Priority:** Medium

Resource access (granular RESTful FHIR resource queries) could inherit from multiple specifications (IPA, QEDm). This issue tracks the inheritance approach.

**Current Approach**

- **Data Models**: Inherit from EU Core profiles
- **Search Parameters**: From IPA (required parameters listed in [Resource Access](resource-access.html))
- **CapabilityStatements**: Instantiate IPA Server/Client
- **QEDm**: Referenced where compatible with IPA. QEDm has a stated goal of aligning with IPA.

A separate issue ([Issue 9](#issue-9-core-resource-set-validation)) tracks validation of the core resource set.

**Seeking Input On**
- Do the implemented IPA search parameters
- What are the differences compared to QEDm, and how should those be handled?

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
