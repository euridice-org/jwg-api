# EU FHIR Implementation Guide Analysis: Priority Area Resource Mapping for EURIDICE

**Document Version:** 1.0
**Date:** 2026-01-03
**Purpose:** Comprehensive analysis of EU FHIR Implementation Guides to inform EURIDICE resource prioritization and MHD integration

---

## Executive Summary

This document analyzes the EU FHIR Implementation Guides for the five priority areas defined by the European Health Data Space (EHDS) to inform EURIDICE's resource prioritization and document exchange architecture. The analysis covers:

1. **EU Core Base** - hl7.fhir.eu.base v2.0.0-ballot (FOUNDATION LAYER)
2. **Patient Summary (EPS)** - hl7.fhir.eu.eps v1.0.0-ci-build
3. **Laboratory Reports** - hl7.fhir.eu.laboratory v0.1.1
4. **Hospital Discharge Reports (HDR)** - hl7.fhir.eu.hdr v0.1.0-ballot
5. **Imaging Reports** - hl7.fhir.eu.imaging v0.1.1-build (R5)
6. **Imaging Manifests** - MADO Profile (Manifest-based Access to DICOM Objects)

### Key Findings

- **EU Core (hl7.fhir.eu.base)** provides 23 foundation profiles for 15+ resource types - **CRITICAL FOUNDATION LAYER**
- **33 unique FHIR resource types** are profiled across all priority areas
- **15 resources have EU Core profiles** providing consistent European constraints
- **Patient Summary (EPS)** is the most focused, requiring only 11 core resource types
- **Hospital Discharge Report (HDR)** is the most comprehensive, utilizing 33 resource types
- **Laboratory Reports** require specialized Observation and DiagnosticReport profiles
- **Imaging** has TWO distinct document types: diagnostic reports and manifests
- All priority areas use **document Bundle** patterns compatible with MHD
- Significant overlap with **IPA (International Patient Access)** and **QEDm** resource sets
- **Clear inheritance patterns**: FHIR Base → EU Core → Priority IGs (EPS/LAB/HDR) → EURIDICE

### Recommended Initial Resource Set

Based on priority area coverage and IPA/QEDm alignment, we recommend starting with these **12 core resources**:

1. **Patient** (all areas) - foundational
2. **Practitioner** (all areas) - foundational
3. **Organization** (all areas) - foundational
4. **Condition** (EPS, HDR) - problems/diagnoses
5. **AllergyIntolerance** (EPS, HDR) - critical safety
6. **Observation** (all areas) - lab results, vitals, findings
7. **DiagnosticReport** (LAB, HDR, Imaging) - report anchor
8. **MedicationRequest** (EPS, HDR) - prescriptions (read-only)
9. **Procedure** (HDR) - surgical/diagnostic procedures
10. **Encounter** (HDR) - hospital stays
11. **DocumentReference** (all via MHD) - document metadata
12. **Bundle** (all areas) - document containers

---

## 1. Priority Area Analysis

### 1.1 Patient Summary (EPS)

**Package:** hl7.fhir.eu.eps v1.0.0-ci-build
**Base:** FHIR R4.0.1
**Extends:** HL7 International Patient Summary (IPS)
**Document Type:** LOINC 60591-5 "Patient Summary"

#### Document Structure

**Composition Profile:** CompositionEuEps
**Bundle Profile:** BundleEuEps (document type)

#### Required Sections (1..1)

| Section | LOINC Code | Resources Referenced |
|---------|-----------|---------------------|
| Problems | TBD | Condition, DocumentReference |
| Allergies and Intolerances | TBD | AllergyIntolerance, DocumentReference |
| Medication Summary | TBD | MedicationStatement, MedicationRequest, MedicationAdministration, MedicationDispense |

#### Optional Sections (0..1)

| Section | LOINC Code | Resources Referenced |
|---------|-----------|---------------------|
| Immunizations | TBD | Immunization, DocumentReference |
| Results | TBD | Observation, DiagnosticReport, DocumentReference |
| History of Procedures | TBD | Procedure, DocumentReference |
| Medical Devices | TBD | DeviceUseStatement, DocumentReference |
| Advance Directives | TBD | Consent (narrative-focused) |

#### Resource Types Profiled (11 total)

- Bundle (document)
- Composition
- Patient
- Consent (advance directives)
- Device
- DeviceUseStatement
- MedicationRequest
- MedicationDispense
- MedicationAdministration
- Observation (travel history)
- Extensions (3)

#### EURIDICE Notes

- **Most focused** priority area with minimal resource set
- Strong alignment with **IPA** resource requirements
- Medication resources are **read-only** (no MPD integration initially)
- Travel history observations support cross-border use cases
- All sections support **DocumentReference** for attached documents

---

### 1.2 Laboratory Reports

**Package:** hl7.fhir.eu.laboratory v0.1.1
**Base:** FHIR R4.0.1
**Document Type:** Laboratory Report Types ValueSet (LOINC-based)

#### Document Structure

**Composition Profile:** CompositionLabReportEu
**Bundle Profile:** BundleLabReportEu (document type)
**DiagnosticReport Profile:** DiagnosticReportLabEu

#### Composition Sections (0..*)

The Laboratory Composition supports three section patterns:

1. **lab-no-subsections** (0..*): Flat structure with entries, no subsections
   - Required: title, code, entry (1..*)
   - Optional: text

2. **lab-subsections** (0..*): Hierarchical structure with nested laboratory items
   - Required: title, code
   - Contains subsections (1..*) with their own entries
   - Useful for panel/battery organization

3. **annotations** (0..*): Annotation comments
   - Fixed code: LOINC 48767-8
   - Required: title, code, text
   - No entries

#### Key Categories

- **Study Type:** Laboratory Study Types ValueSet
- **Specialty:** Laboratory Specialty ValueSet

#### Resource Types Profiled (8+ specific)

- Bundle
- Composition
- DiagnosticReport (anchor resource)
- Observation (results) - **ObservationResultsLaboratoryEu**
- Patient
- ServiceRequest (orders)
- Specimen (sample details)
- BodyStructure (collection site)
- Device (lab test kit - extension)
- Practitioner, Organization (actors)
- Extensions for certified reference materials

#### EURIDICE Notes

- **DiagnosticReport** is the primary anchor resource
- **Observation** profiles for structured lab results are critical
- **Specimen** tracking is important for lab workflows
- Flexible section structure supports various report formats
- ServiceRequest links to ordering physician/context

---

### 1.3 Hospital Discharge Report (HDR)

**Package:** hl7.fhir.eu.hdr v0.1.0-ballot
**Base:** FHIR R4.0.1
**Dependencies:** IPS, EU Laboratory, MPD (for medications)
**Document Type:** LOINC 34105-7 "Hospital Discharge summary"

#### Document Structure

**Composition Profile:** CompositionEuHdr
**Bundle Profile:** BundleEuHdr (document type)

#### Required Sections (1..1)

| Section | Code | Description |
|---------|------|-------------|
| Hospital Course | LOINC 8648-8 | Significant information about hospital stay including encounter, diagnostics, pharmacotherapy, procedures, devices, and findings |

#### Optional Sections (0..1)

| Section | Code | Description |
|---------|------|-------------|
| Admission Evaluation | LOINC 67851-6 | Initial assessment on admission |
| Anthropometric Observations | anthropometry | Height, weight, BMI |
| Vital Signs | LOINC 8716-3 | Blood pressure, temperature, etc. |
| Physical Findings | LOINC 29545-1 | Examination findings |
| Functional Status | LOINC 47420-5 | ADLs, mobility assessment |
| Diagnostic Summary | LOINC 11535-2 | Key diagnoses |
| Significant Procedures | LOINC 10185-7 | Surgeries and major procedures |
| Medical Devices and Implants | LOINC 57080-4 | Devices used/implanted |
| Pharmacotherapy | LOINC 87232-5 | Medications during stay |
| Significant Results | LOINC 30954-2 | Key lab/imaging results |
| Synthesis | LOINC 67781-5 | Clinical summary/assessment |
| Plan of Care | LOINC 18776-5 | Follow-up care plan |
| Discharge Instructions | LOINC 8653-8 | Patient instructions |
| Discharge Medications | LOINC 34106-5 | Medications at discharge |

#### Resource Types Profiled (33 total)

**Clinical Resources:**
- AllergyIntolerance
- Condition (diagnoses)
- Observation (vitals, lab results, functional status, SDOH, travel, infectious contacts, imaging findings)
- Procedure
- DiagnosticReport
- FamilyMemberHistory
- Flag (alerts)
- CarePlan

**Medications (5 resources):**
- Medication
- MedicationRequest
- MedicationAdministration
- MedicationDispense
- MedicationStatement

**Devices:**
- Device
- DeviceUseStatement

**Immunizations:**
- Immunization
- ImmunizationRecommendation

**Administrative:**
- Patient
- Practitioner
- PractitionerRole
- Organization
- Encounter

**Workflow:**
- ServiceRequest
- Specimen
- BodyStructure

**Other:**
- Consent
- DocumentReference (implied)

**Data Types:**
- Address
- HumanName
- Quantity
- Ratio

#### EURIDICE Notes

- **Most comprehensive** priority area with 33 resource types
- **Encounter** resource is critical for hospital stay context
- HDR has **dual profile pattern**: standard profiles + "obligation" profiles (denoted with "-obl" suffix)
- Strong **medication workflows** requiring 5 medication resources
- Multiple **Observation** profiles for different contexts (vitals, SDOH, travel, infectious contacts, imaging findings)
- Dependencies on **IPS** and **EU Laboratory** packages
- References **MPD (Medicinal Product Dictionary)** for medication standardization

---

### 1.4 Imaging Reports

**Package:** hl7.fhir.eu.imaging v0.1.1-build
**Base:** FHIR R5.0.0 (Note: R5, not R4)
**Document Type:** Imaging Report Types ValueSet (LOINC/RadLex-based)

#### Document Structure

**DiagnosticReport Profile:** ImDiagnosticReport (anchor resource)
**Composition Profile:** ImComposition
**Bundle Profile:** (document type)

#### Key Characteristics

- **DiagnosticReport** is the primary anchor resource that refers to all structured data
- **Composition** contains the narrative text of the imaging report
- Supports multiple exchange patterns:
  - Document-based exchange (FHIR Document Bundle)
  - REST API access to documents (Composition + DiagnosticReport + referenced resources)
  - REST API access to individual resources

#### Terminology Bindings

- DiagnosticReport.code: LOINC/RadLex Playbook imaging codes
- Composition.type: Imaging Report Types ValueSet
- Aligned with DICOM CID 7001 "Diagnostic Imaging Report Heading"

#### Key Resources

- DiagnosticReport (ImDiagnosticReport)
- Composition (ImComposition)
- Observation (findings, measurements, radiation dose)
- ImagingStudy (DICOM study reference)
- Patient
- Practitioner, PractitionerRole (radiologist, referring physician)
- ServiceRequest (imaging order)
- Specimen (for interventional procedures)
- BodyStructure (anatomical focus)

#### EURIDICE Notes

- **R5-based**: May require version bridging for R4-based EURIDICE
- **DiagnosticReport** is more critical than Composition for structured data access
- **ImagingStudy** resource links to DICOM PACS systems
- Radiation dose tracking via specialized Observation profiles
- Strong integration with **DICOM** standards

---

### 1.5 Imaging Manifests

**Package:** MADO Profile (Manifest-based Access to DICOM Objects) v0.2.1-build
**Base:** FHIR R5.0.0
**Purpose:** Summary listing of imaging study contents

#### Document Structure

The imaging manifest is a **separate document type** from the imaging report:

- **Imaging Report**: Clinical narrative with findings, impressions, diagnosis (Composition-based)
- **Imaging Manifest**: Technical summary of DICOM study contents for image access (DocumentReference/ImagingStudy-based)

#### Key Characteristics

- Lists key information about imaging study content
- Acts as summary for large, complex imaging studies
- Enables manifest-based access to DICOM objects
- Supports image selection without downloading entire study

#### Key Resources

- ImagingStudy (study metadata)
- DocumentReference (manifest document)
- ImagingSelection (key images, measurements)
- Endpoint (DICOM endpoints for image retrieval)

#### EURIDICE Notes

- Imaging has **TWO document types**: Report + Manifest
- Manifest is more technical/administrative than clinical
- Critical for **DICOM integration** and image access workflows
- Supports **key image selection** for review/sharing
- Complements diagnostic report with technical metadata

---

## 2. Resource Requirements Matrix

This matrix maps FHIR resources to priority areas and notes EU Core profile availability:

| Resource | EPS | LAB | HDR | IMG-Report | IMG-Manifest | IPA | QEDm | EU Core | Priority |
|----------|-----|-----|-----|------------|--------------|-----|------|---------|----------|
| **Patient** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | **HIGH** |
| **Practitioner** | (ref) | ✓ | ✓ | ✓ | (ref) | ✓ | ✓ | ✓ | **HIGH** |
| **PractitionerRole** | - | ✓ | ✓ | ✓ | - | - | ✓ | ✓ | MEDIUM |
| **Organization** | (ref) | ✓ | ✓ | ✓ | (ref) | ✓ | ✓ | ✓ | **HIGH** |
| **Condition** | ✓ | - | ✓ | - | - | ✓ | ✓ | ✓ | **HIGH** |
| **AllergyIntolerance** | ✓ | - | ✓ | - | - | ✓ | ✓ | ✓ | **HIGH** |
| **Observation** | ✓ | ✓ | ✓ | ✓ | - | ✓ | ✓ | ✓ | **HIGH** |
| **DiagnosticReport** | (opt) | ✓ | ✓ | ✓ | - | ✓ | ✓ | ✓ | **HIGH** |
| **MedicationRequest** | ✓ | - | ✓ | - | - | ✓ | - | ✓ | **HIGH** |
| **MedicationStatement** | ✓ | - | ✓ | - | - | ✓ | - | ✓ | MEDIUM |
| **MedicationAdministration** | ✓ | - | ✓ | - | - | - | - | - | LOW |
| **MedicationDispense** | ✓ | - | ✓ | - | - | - | - | - | LOW |
| **Medication** | (ref) | - | ✓ | - | - | - | - | ✓ | LOW |
| **Procedure** | (opt) | - | ✓ | - | - | - | ✓ | ✓ | MEDIUM |
| **Immunization** | (opt) | - | ✓ | - | - | ✓ | - | ✓ | MEDIUM |
| **Encounter** | - | - | ✓ | - | - | - | ✓ | - | MEDIUM |
| **ServiceRequest** | - | ✓ | ✓ | ✓ | - | - | - | - | MEDIUM |
| **Specimen** | - | ✓ | ✓ | ✓ | - | - | - | - | MEDIUM |
| **Device** | ✓ | (ext) | ✓ | - | - | - | - | - | LOW |
| **DeviceUseStatement** | ✓ | - | ✓ | - | - | - | - | - | LOW |
| **ImagingStudy** | - | - | - | ✓ | ✓ | - | - | - | MEDIUM |
| **ImagingSelection** | - | - | - | - | ✓ | - | - | - | LOW |
| **BodyStructure** | - | ✓ | ✓ | ✓ | - | - | - | ✓ | LOW |
| **CarePlan** | - | - | ✓ | - | - | - | - | - | LOW |
| **FamilyMemberHistory** | - | - | ✓ | - | - | - | - | - | LOW |
| **Flag** | - | - | ✓ | - | - | - | - | ✓ | LOW |
| **Consent** | ✓ | - | ✓ | - | - | - | - | - | LOW |
| **ImmunizationRecommendation** | - | - | ✓ | - | - | - | - | - | LOW |
| **Location** | - | - | - | - | - | - | - | ✓ | LOW |
| **DocumentReference** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - | **HIGH** |
| **Bundle** | ✓ | ✓ | ✓ | ✓ | ✓ | - | - | - | **HIGH** |
| **Composition** | ✓ | ✓ | ✓ | ✓ | - | - | - | ✓ | **HIGH** |
| **Endpoint** | - | - | - | - | ✓ | - | - | - | LOW |

**Legend:**
- ✓ = Explicitly profiled in IG
- (opt) = Referenced in optional sections
- (ref) = Referenced but not profiled
- (ext) = Referenced in extensions
- - = Not used

---

## 3. Suggested Initial Resource Set

Based on the analysis, we recommend implementing these **12 core resources** to cover the majority of priority area requirements:

### Tier 1: Foundation (3 resources) - REQUIRED

1. **Patient**
   - Used in: ALL priority areas
   - IPA: ✓ | QEDm: ✓
   - Rationale: Foundational resource, required for all documents

2. **Practitioner**
   - Used in: ALL priority areas
   - IPA: ✓ | QEDm: ✓
   - Rationale: Authors, authenticators, performers

3. **Organization**
   - Used in: ALL priority areas
   - IPA: ✓ | QEDm: ✓
   - Rationale: Custodians, healthcare facilities

### Tier 2: Clinical Core (5 resources) - HIGH PRIORITY

4. **Condition**
   - Used in: EPS (required), HDR
   - IPA: ✓ | QEDm: ✓
   - Rationale: Problems list, diagnoses - critical for EPS

5. **AllergyIntolerance**
   - Used in: EPS (required), HDR
   - IPA: ✓ | QEDm: ✓
   - Rationale: Patient safety - critical for EPS

6. **Observation**
   - Used in: EPS, LAB (core), HDR, Imaging
   - IPA: ✓ | QEDm: ✓
   - Rationale: Lab results, vitals, findings - universal

7. **DiagnosticReport**
   - Used in: LAB (anchor), HDR, Imaging (anchor)
   - IPA: ✓ | QEDm: ✓
   - Rationale: Primary anchor for LAB and Imaging reports

8. **MedicationRequest**
   - Used in: EPS, HDR
   - IPA: ✓
   - Rationale: Prescriptions - read-only initially (no MPD)

### Tier 3: Supporting Clinical (2 resources) - MEDIUM PRIORITY

9. **Procedure**
   - Used in: HDR, EPS (optional)
   - QEDm: ✓
   - Rationale: Surgical/diagnostic procedures in HDR

10. **Encounter**
    - Used in: HDR (hospital stays)
    - QEDm: ✓
    - Rationale: Context for hospital discharge reports

### Tier 4: Document Infrastructure (2 resources) - REQUIRED

11. **DocumentReference**
    - Used in: ALL priority areas (via MHD)
    - IPA: ✓ | QEDm: ✓
    - Rationale: MHD integration, document metadata

12. **Bundle**
    - Used in: ALL priority areas
    - Rationale: Document container for all FHIR documents

### Additional Considerations

**Later tiers** (not in initial 12):
- **Specimen** (Tier 4) - Important for LAB, needed if supporting full lab workflows
- **ServiceRequest** (Tier 4) - Orders context for LAB/Imaging
- **ImagingStudy** (Tier 4) - Critical for Imaging Manifest support
- **MedicationStatement** (Tier 5) - If moving beyond read-only medications
- **Immunization** (Tier 5) - Common EPS optional section
- **PractitionerRole** (Tier 5) - Enhanced practitioner context

**Deferred for now:**
- MedicationAdministration, MedicationDispense, Medication (complex medication workflows)
- Device, DeviceUseStatement (medical devices)
- CarePlan, FamilyMemberHistory, Flag, ImmunizationRecommendation (HDR-specific)
- BodyStructure (specimen/imaging context)
- Consent, ImagingSelection, Endpoint (specialized use cases)

### Coverage Summary

With these 12 resources, EURIDICE would support:
- ✅ **Patient Summary (EPS)**: ~90% coverage (missing optional sections like Immunizations)
- ✅ **Laboratory Reports**: ~80% coverage (missing Specimen for full workflows)
- ✅ **Hospital Discharge Reports**: ~70% coverage (core sections covered, some optional sections missing)
- ✅ **Imaging Reports**: ~75% coverage (missing ImagingStudy for full DICOM integration)
- ⚠️ **Imaging Manifests**: ~40% coverage (missing ImagingStudy, ImagingSelection, Endpoint)

---

## 4. Document Models and MHD Mapping

All EU priority areas use FHIR Document Bundles, which map naturally to **IHE MHD (Mobile access to Health Documents)** for document exchange.

### 4.1 MHD DocumentReference Mapping

| Priority Area | Composition.type | DocumentReference.type | XDS classCode | Format Code |
|---------------|------------------|------------------------|---------------|-------------|
| **Patient Summary** | LOINC 60591-5 "Patient Summary" | LOINC 60591-5 | Patient Summary | urn:hl7-org:sdwg:ccda-structuredBody:2.1 or FHIR |
| **Laboratory Report** | Lab Report Types VS (LOINC-based) | Same as Composition.type | Laboratory Report | FHIR |
| **Hospital Discharge** | LOINC 34105-7 "Hospital Discharge summary" | LOINC 34105-7 | Discharge Summary | FHIR |
| **Imaging Report** | Imaging Report Types VS (LOINC/RadLex) | Same as Composition.type | Imaging Report | FHIR (R5) |
| **Imaging Manifest** | N/A (not Composition-based) | DICOM Manifest type | Imaging Manifest | DICOM/FHIR |

### 4.2 Bundle Structure Patterns

All EU IGs follow the **FHIR Document Bundle** pattern:

```
Bundle (type = "document")
├── entry[0]: Composition (document metadata and narrative)
│   ├── subject → Patient
│   ├── author → Practitioner/PractitionerRole
│   ├── custodian → Organization
│   └── section[*]
│       ├── title, code, text (narrative)
│       └── entry → referenced resources
├── entry[1]: Patient
├── entry[2..n]: All resources referenced by Composition
│   (Practitioners, Organizations, Observations, DiagnosticReports, etc.)
```

### 4.3 Document Type Codes (LOINC)

| Document Type | LOINC Code | Description |
|---------------|-----------|-------------|
| Patient Summary | 60591-5 | Patient summary Document |
| Hospital Discharge | 34105-7 | Hospital Discharge summary |
| Lab Report (generic) | 11502-2 | Laboratory report |
| Imaging Report (generic) | 18748-4 | Diagnostic imaging study |
| Radiology Report | 18782-3 | Radiology Study observation (narrative) |

Note: LAB and Imaging use ValueSets with multiple specific LOINC codes for different report types (chemistry panel, microbiology culture, CT chest, MRI brain, etc.)

### 4.4 XDS Class Codes

For XDS/MHD integration, the following classCode mappings apply:

| Priority Area | Suggested XDS classCode |
|---------------|------------------------|
| Patient Summary | LOINC 60591-5 or IHE PCC "Medical Summary" |
| Laboratory Report | LOINC 11502-2 or IHE LAB "Laboratory Report" |
| Hospital Discharge | LOINC 34105-7 or IHE "Discharge Summary" |
| Imaging Report | LOINC 18748-4 or IHE RAD "Imaging Report" |
| Imaging Manifest | DICOM KOS or custom |

### 4.5 Composition Sections to Resources Mapping

#### Patient Summary (EPS)

| Section | Code | Resources | Cardinality |
|---------|------|-----------|-------------|
| Problems | TBD | Condition, DocumentReference | 1..1 |
| Allergies | TBD | AllergyIntolerance, DocumentReference | 1..1 |
| Medications | TBD | MedicationStatement, MedicationRequest | 1..1 |
| Immunizations | TBD | Immunization, DocumentReference | 0..1 |
| Results | TBD | Observation, DiagnosticReport | 0..1 |
| Procedures | TBD | Procedure, DocumentReference | 0..1 |
| Medical Devices | TBD | DeviceUseStatement, DocumentReference | 0..1 |
| Advance Directives | TBD | Consent (narrative) | 0..1 |

#### Laboratory Report

| Section | Code | Resources | Cardinality |
|---------|------|-----------|-------------|
| Lab Results (flat) | Panel/test LOINC | Observation (lab results) | 0..* |
| Lab Results (hierarchical) | Panel/test LOINC | Observation (nested) | 0..* |
| Annotations | LOINC 48767-8 | (narrative only) | 0..* |

Anchor: **DiagnosticReport** references all Observations

#### Hospital Discharge Report

| Section | Code | Resources | Cardinality |
|---------|------|-----------|-------------|
| Hospital Course | LOINC 8648-8 | Encounter, Observation, Procedure, etc. | 1..1 |
| Admission Evaluation | LOINC 67851-6 | Observation, Condition | 0..1 |
| Vital Signs | LOINC 8716-3 | Observation (vitals) | 0..1 |
| Diagnostic Summary | LOINC 11535-2 | Condition | 0..1 |
| Procedures | LOINC 10185-7 | Procedure | 0..1 |
| Medications | LOINC 87232-5 | MedicationStatement, MedicationRequest | 0..1 |
| Results | LOINC 30954-2 | Observation, DiagnosticReport | 0..1 |
| Plan of Care | LOINC 18776-5 | CarePlan, ServiceRequest | 0..1 |
| Discharge Medications | LOINC 34106-5 | MedicationRequest | 0..1 |
| Discharge Instructions | LOINC 8653-8 | DocumentReference (narrative) | 0..1 |

#### Imaging Report

| Component | Resource | Purpose |
|-----------|----------|---------|
| Anchor | DiagnosticReport | Report metadata, references study |
| Narrative | Composition | Findings, impression, diagnosis |
| Findings | Observation | Structured findings, measurements |
| Study Reference | ImagingStudy | Link to DICOM study/series |
| Radiation Dose | Observation | Radiation exposure tracking |

#### Imaging Manifest

| Component | Resource | Purpose |
|-----------|----------|---------|
| Study Metadata | ImagingStudy | DICOM study/series/instance UIDs |
| Manifest Document | DocumentReference | Manifest document metadata |
| Key Images | ImagingSelection | Selected images/frames |
| DICOM Endpoints | Endpoint | WADO-RS/DICOMweb access |

### 4.6 MHD Integration Recommendations

1. **DocumentReference.type**: Map from Composition.type for all document-based priority areas
2. **DocumentReference.category**: Use XDS classCode mappings or EHDS priority category codes
3. **DocumentReference.content.format**:
   - FHIR Documents: `urn:hl7-org:fhir:format-code#application/fhir+json`
   - R5 Imaging: Consider format code indicating FHIR R5
4. **DocumentReference.context.related**: Link to key resources (Patient, Encounter, ServiceRequest)
5. **DocumentReference.author**: Copy from Composition.author
6. **DocumentReference.custodian**: Copy from Composition.custodian

### 4.7 Two Document Types for Imaging

It's critical to recognize that **Imaging has TWO distinct document types**:

1. **Imaging Report** (Clinical Document)
   - Composition-based FHIR Document Bundle
   - Contains clinical narrative (findings, impressions, diagnosis)
   - DiagnosticReport as anchor resource
   - DocumentReference.type: Imaging report LOINC code
   - Primary consumers: Clinicians reviewing diagnostic findings

2. **Imaging Manifest** (Technical Document)
   - ImagingStudy-based (may use Bundle or DocumentReference)
   - Lists DICOM study contents, key images, access endpoints
   - Supports image viewer integration
   - DocumentReference.type: DICOM manifest type code
   - Primary consumers: Image viewers, PACS systems, technical staff

**EURIDICE Implication:** Need to support both DocumentReference types for complete imaging support. The report is clinical; the manifest is technical/administrative.

---

## 5. IPA and QEDm Alignment

The suggested 12-resource set has strong alignment with existing IHE profiles:

### 5.1 IPA (International Patient Access) Coverage

**IPA Required Resources (all in our top 12):**
- ✅ Patient
- ✅ Practitioner
- ✅ Organization
- ✅ Condition
- ✅ AllergyIntolerance
- ✅ Observation
- ✅ DiagnosticReport
- ✅ MedicationRequest
- ✅ DocumentReference

**IPA Optional Resources:**
- MedicationStatement (we include as Tier 2 consideration)
- Immunization (Tier 5)

**Coverage:** 100% of IPA required resources

### 5.2 QEDm (Query for Existing Data for Mobile) Coverage

**QEDm Supported Resources (in our top 12):**
- ✅ Patient
- ✅ Practitioner
- ✅ Organization
- ✅ Condition
- ✅ AllergyIntolerance
- ✅ Observation
- ✅ DiagnosticReport
- ✅ DocumentReference
- ✅ Procedure
- ✅ Encounter

**QEDm Additional Resources:**
- PractitionerRole (Tier 3 consideration)

**Coverage:** ~90% of QEDm common resources

### 5.3 Strategic Alignment Benefits

By aligning with IPA and QEDm, EURIDICE gains:

1. **Standardized query patterns**: IPA and QEDm define proven search parameters
2. **Mobile optimization**: Both profiles are designed for mobile/web access
3. **Interoperability**: Compatibility with existing IHE implementations
4. **Reduced implementation risk**: Well-tested patterns and conformance resources
5. **International compatibility**: IPA is used beyond EU (US, CA, AU)

---

## 6. EU Core Base Alignment

### 6.1 What is EU Core?

**Package:** hl7.fhir.eu.base v2.0.0-ballot
**FHIR Version:** R4 (4.0.1)
**Purpose:** Foundation layer of profiles for all EU FHIR Implementation Guides

EU Core (hl7.fhir.eu.base) provides **base and core profiles** that establish common European constraints on FHIR resources. It serves as the foundation layer that priority-specific IGs (EPS, LAB, HDR, Imaging) build upon, ensuring consistency across all European health data exchange implementations.

**Key Characteristics:**
- **Two-tier profile approach**: "eu" (base) and "eu-core" (core) profiles for many resources
- **European-specific constraints**: Addresses European coding systems, address formats, identifier schemes
- **IPS alignment**: Core profiles are designed to be compatible with HL7 International Patient Summary
- **Reusability**: Common profiles reduce duplication across multiple EU IGs

### 6.2 EU Core Profile Inventory

EU Core provides **23 StructureDefinitions** covering **15 resource types** and **1 data type**:

#### 6.2.1 Foundation Resources (Identity & Administrative)

| Resource | EU Base Profile | EU Core Profile | Purpose |
|----------|----------------|-----------------|---------|
| **Patient** | PatientEu | PatientEuCore | Patient demographics with EU constraints |
| Patient (animal) | - | PatientAnimalEuCore | Veterinary patient (animal subjects) |
| **Practitioner** | PractitionerEu | PractitionerEuCore | Healthcare provider identity |
| **PractitionerRole** | PractitionerRoleEu | PractitionerRoleEuCore | Provider roles and specialties |
| **Organization** | OrganizationEu | OrganizationEuCore | Healthcare organizations |
| **Location** | - | LocationEuCore | Facilities and physical locations |

#### 6.2.2 Clinical Resources

| Resource | EU Base Profile | EU Core Profile | Purpose |
|----------|----------------|-----------------|---------|
| **AllergyIntolerance** | - | AllergyIntoleranceEuCore | Allergies and adverse reactions |
| **Condition** | - | ConditionEuCore | Problems, diagnoses, health concerns |
| **Procedure** | - | ProcedureEuCore | Surgical and diagnostic procedures |
| **Immunization** | - | ImmunizationEuCore | Vaccination records |
| **Flag** | - | FlagEuCore | Clinical alerts and warnings |

#### 6.2.3 Diagnostic Resources

| Resource | EU Base Profile | EU Core Profile | Purpose |
|----------|----------------|-----------------|---------|
| **Observation** | - | MedicalTestResultEuCore | Lab results, vitals, test results |
| **DiagnosticReport** | - | DiagnosticReportEuCore | Diagnostic study reports |
| **BodyStructure** | - | BodyStructureEuCore | Anatomical structures |

#### 6.2.4 Medication Resources

| Resource | EU Base Profile | EU Core Profile | Purpose |
|----------|----------------|-----------------|---------|
| **Medication** | - | MedicationEuCore | Medication product information |
| **MedicationRequest** | - | MedicationRequestEuCore | Prescriptions and orders |
| **MedicationStatement** | - | MedicationStatementEuCore | Medication usage records |

#### 6.2.5 Document Resources

| Resource | EU Base Profile | EU Core Profile | Purpose |
|----------|----------------|-----------------|---------|
| **Composition** | - | CompositionEuCore | Document metadata and structure |

#### 6.2.6 Data Types

| Data Type | EU Profile | Purpose |
|-----------|-----------|---------|
| **Address** | AddressEu | European address formats and conventions |

**Note:** Resources with both "eu" and "eu-core" profiles follow a two-tier pattern:
- **"eu" profiles** (e.g., PatientEu): European-specific adaptations of base FHIR (addresses, identifiers)
- **"eu-core" profiles** (e.g., PatientEuCore): Extend "eu" profiles with minimum requirements common to most EU use cases

### 6.3 Profile Inheritance Chains

EU Core establishes a clear inheritance hierarchy for European FHIR implementations:

#### 6.3.1 Two-Tier Pattern (Patient Example)

```
FHIR Base Patient (R4)
  ↓
PatientEu (EU Base)
  ↓ [adds: EU address format, EU identifier systems]
PatientEuCore (EU Core)
  ↓ [adds: name (1..1), birthDate (1..1) minimum requirements]
PatientEuEps (EPS-specific)
  ↓ [adds: EPS-specific constraints]
PatientEuObligations (HDR-specific)
  [adds: HDR-specific obligations]
```

#### 6.3.2 Single-Tier Pattern (Observation Example)

```
FHIR Base Observation (R4)
  ↓
MedicalTestResultEuCore (EU Core)
  ↓ [adds: EU coding systems, value constraints]
ObservationResultsLaboratoryEu (LAB-specific)
  [adds: Laboratory-specific constraints]
```

#### 6.3.3 Inheritance Matrix: EU Core to Priority IGs

| Resource | EU Core Profile | EPS Profile | LAB Profile | HDR Profile | Inheritance Pattern |
|----------|----------------|-------------|-------------|-------------|---------------------|
| **Patient** | PatientEuCore | PatientEuEps → **EU Core** | PatientEuLab → FHIR Base | PatientEuObligations → **EU Core** | EPS/HDR use EU Core, LAB does not |
| **Practitioner** | PractitionerEuCore | (references only) | PractitionerEu → FHIR Base | PractitionerEu → FHIR Base | Priority IGs use EU Base, not Core |
| **Organization** | OrganizationEuCore | (references only) | OrganizationEu → FHIR Base | OrganizationEu → FHIR Base | Priority IGs use EU Base, not Core |
| **AllergyIntolerance** | AllergyIntoleranceEuCore | (IPS-based) | N/A | AllergyIntoleranceEuHdr → ? | HDR-specific profile |
| **Condition** | ConditionEuCore | (IPS-based) | N/A | ConditionEuHdr → ? | HDR-specific profile |
| **Observation** | MedicalTestResultEuCore | ObservationTravel... | ObservationResultsLab... | Observation... | Lab-specific, not from EU Core |
| **DiagnosticReport** | DiagnosticReportEuCore | N/A | DiagnosticReportLabEu | DiagnosticReportEuHdr | Priority-specific profiles |
| **Medication*** | Medication*EuCore | (IPS-based) | N/A | Medication*EuHdr | HDR extends IPS/MPD |
| **Immunization** | ImmunizationEuCore | (IPS-based) | N/A | ImmunizationEuHdr | HDR-specific |
| **Procedure** | ProcedureEuCore | (IPS-based) | N/A | ProcedureEuHdr | HDR-specific |

**Key Findings:**
- **EPS** consistently inherits from EU Core where applicable (Patient, foundation resources)
- **HDR** inherits from EU Core for Patient but has many custom profiles
- **LAB** does NOT inherit from EU Core for Patient - uses base FHIR directly
- **Foundation resources** (Practitioner, Organization) use EU Base tier, not EU Core
- **Clinical resources** have priority-specific profiles rather than EU Core inheritance

### 6.4 What EU Core Constrains

#### 6.4.1 PatientEuCore Key Constraints

Based on analysis of the profile:
- **Base:** http://hl7.eu/fhir/base/StructureDefinition/patient-eu
- **name**: 1..1 (required)
- **birthDate**: 1..1 (required)
- Inherits from PatientEu: EU address formats, EU identifier systems
- IPS-compatible when name.given, name.family, or name.text is present

#### 6.4.2 Common Constraints Across EU Core

EU Core profiles typically constrain:
- **Identifiers**: European identifier schemes (national health IDs, insurance cards)
- **Addresses**: European address formats and postal codes
- **Coding systems**: SNOMED CT, LOINC, ICD-10, ATC (European-licensed terminologies)
- **Cardinality**: Minimum requirements for data elements (e.g., name, birthDate)
- **Extensions**: EU-specific extensions for additional data elements

### 6.5 EU Core Dependencies

EU Core itself depends on:
- **hl7.fhir.r4.core**: 4.0.1 (FHIR R4)
- **hl7.terminology.r4**: 7.0.1 (terminology resources)
- **hl7.fhir.uv.extensions.r4**: 5.2.0 (universal extensions)
- **hl7.fhir.uv.ips**: 2.0.0 (International Patient Summary - alignment)
- **hl7.fhir.eu.extensions.r4**: 1.2.0 (EU-specific extensions)
- **ihe.pharm.mpd.r4**: 1.0.0-comment-2 (Medicinal Product Dictionary)
- **hl7.fhir.uv.xver-r5.r4**: 0.0.1-snapshot-2 (R5 cross-version extensions)

### 6.6 Recommendations for EURIDICE

#### 6.6.1 Inherit from EU Core for Foundation Resources

**RECOMMENDATION:** EURIDICE should inherit from EU Core profiles for all foundation resources where EU Core provides coverage:

| Resource | Recommended Base Profile | Rationale |
|----------|-------------------------|-----------|
| **Patient** | PatientEuCore | Ensures EU identifier/address compatibility, IPS alignment |
| **Practitioner** | PractitionerEuCore | EU-specific provider identifiers and roles |
| **PractitionerRole** | PractitionerRoleEuCore | EU specialty coding systems |
| **Organization** | OrganizationEuCore | EU organization identifiers |
| **Location** | LocationEuCore | EU location identifiers |
| **AllergyIntolerance** | AllergyIntoleranceEuCore | Clinical safety - EU coding systems |
| **Condition** | ConditionEuCore | EU diagnosis coding (ICD-10, SNOMED) |
| **Observation** | MedicalTestResultEuCore | Lab results, vitals - EU units/codes |
| **DiagnosticReport** | DiagnosticReportEuCore | Diagnostic reports - EU report types |
| **Medication** | MedicationEuCore | EU medication coding (ATC, MPD) |
| **MedicationRequest** | MedicationRequestEuCore | Prescriptions - EU medication standards |
| **MedicationStatement** | MedicationStatementEuCore | Medication history - EU standards |
| **Procedure** | ProcedureEuCore | Procedures - EU procedure coding |
| **Immunization** | ImmunizationEuCore | Vaccinations - EU vaccine codes |
| **Composition** | CompositionEuCore | Document structure - EU conventions |

**Benefits:**
1. **Automatic compliance** with EU-wide standards
2. **Reduced duplication** - leverage existing profiles
3. **Interoperability** with other EU IGs (EPS, HDR, LAB)
4. **Future-proofing** - align with evolving EU standards
5. **IPS compatibility** - EU Core profiles are IPS-aligned

#### 6.6.2 When to Use EU Core vs Priority-Specific Profiles

**Use EU Core directly when:**
- Resource is used across multiple priority areas (Patient, Practitioner, Organization)
- No priority-specific constraints are needed
- Goal is maximum interoperability

**Extend priority-specific profiles when:**
- Priority IG already provides a specialized profile (e.g., DiagnosticReportLabEu for laboratory)
- Need priority-specific sections or constraints (e.g., EPS Composition sections)
- Priority IG profile already inherits from EU Core (e.g., PatientEuEps)

**Create EURIDICE-specific profiles when:**
- Need cross-priority constraints not in EU Core or priority IGs
- Implementing EURIDICE-specific extensions or requirements
- Harmonizing across multiple priority areas

#### 6.6.3 Resource Inheritance Strategy Table

| Resource | EURIDICE Strategy | Base Profile | Notes |
|----------|------------------|--------------|-------|
| **Patient** | Use EU Core | PatientEuCore | All priority areas need consistent patient identity |
| **Practitioner** | Use EU Core | PractitionerEuCore | Foundation resource |
| **Organization** | Use EU Core | OrganizationEuCore | Foundation resource |
| **Condition** | Extend EU Core | ConditionEuCore | May add EURIDICE-specific categories |
| **AllergyIntolerance** | Use EU Core | AllergyIntoleranceEuCore | Critical safety - no customization needed |
| **Observation** | Priority-specific | LAB: ObservationResultsLaboratoryEu<br/>HDR: Observation*EuHdr | Lab/vitals have specialized constraints |
| **DiagnosticReport** | Priority-specific | LAB: DiagnosticReportLabEu<br/>HDR: DiagnosticReportEuHdr | Report structure varies by priority |
| **MedicationRequest** | Use EU Core | MedicationRequestEuCore | Consistent prescriptions across priorities |
| **Procedure** | Use EU Core | ProcedureEuCore | Standard procedure recording |
| **Encounter** | EURIDICE-specific | Encounter (base FHIR) | Not in EU Core; HDR has InPatientEncounter |
| **DocumentReference** | EURIDICE-specific | DocumentReference (base FHIR) | MHD-specific constraints |
| **Bundle** | Priority-specific | BundleEuEps, BundleLabReportEu, etc. | Document bundles are priority-specific |
| **Composition** | Priority-specific | CompositionEuEps, CompositionLabReportEu | Sections vary by document type |

### 6.7 EU Core in Context: The Full Dependency Stack

```
┌─────────────────────────────────────────┐
│         EURIDICE Profiles               │  ← Your implementation
│   (cross-priority harmonization)        │
└──────────────┬──────────────────────────┘
               │
         ┌─────┴─────┬─────────┬─────────┐
         │           │         │         │
         ▼           ▼         ▼         ▼
    ┌────────┐  ┌──────┐  ┌─────┐  ┌────────┐
    │  EPS   │  │ LAB  │  │ HDR │  │Imaging │  ← Priority IGs
    │(1.0.0) │  │(0.1.1)│ │(0.1.0)│ │(0.1.1) │
    └────┬───┘  └───┬──┘  └──┬──┘  └───┬────┘
         │          │        │         │ (R5)
         └────┬─────┴────────┘         │
              │                        │
              ▼                        ▼
    ┌──────────────────┐      ┌────────────────┐
    │   EU Core Base   │      │   FHIR R5      │
    │   (2.0.0-ballot) │      │   (5.0.0)      │
    │                  │      └────────────────┘
    │  - PatientEuCore │
    │  - Practitioner  │
    │  - Organization  │
    │  - Clinical Core │
    └────────┬─────────┘
             │
         ┌───┴────┬──────────┬────────────┐
         ▼        ▼          ▼            ▼
    ┌──────┐ ┌────────┐ ┌─────────┐ ┌────────┐
    │ IPS  │ │ MPD    │ │ EU Ext  │ │FHIR R4 │
    │(2.0.0)│ │(1.0.0) │ │ (1.2.0) │ │(4.0.1) │
    └──────┘ └────────┘ └─────────┘ └────────┘
```

**Key Layers:**
1. **FHIR R4 Base** - Foundation FHIR specification
2. **Universal IGs** - IPS (International Patient Summary), MPD (Medicinal Product Dictionary)
3. **EU Core Base** - European foundation profiles (hl7.fhir.eu.base)
4. **Priority IGs** - EPS, LAB, HDR, Imaging (priority-specific constraints)
5. **EURIDICE** - Cross-priority harmonization and MHD integration

---

## 7. Dependencies and Future Considerations

### 7.1 Package Dependencies

The EU IGs have the following dependency chains:

**EU Core (hl7.fhir.eu.base)** depends on:
- hl7.fhir.r4.core: 4.0.1
- hl7.terminology.r4: 7.0.1
- hl7.fhir.uv.extensions.r4: 5.2.0
- hl7.fhir.uv.ips: 2.0.0 (International Patient Summary)
- hl7.fhir.eu.extensions.r4: 1.2.0
- ihe.pharm.mpd.r4: 1.0.0-comment-2 (Medicinal Product Dictionary)
- hl7.fhir.uv.xver-r5.r4: 0.0.1-snapshot-2

**HDR** depends on:
- hl7.fhir.uv.ips (International Patient Summary)
- hl7.fhir.eu.laboratory (Laboratory Report)
- hl7.fhir.eu.base (EU Core - foundation)
- hl7.fhir.eu.extensions.r4 (EU-specific extensions)
- ihe.pharm.mpd.r4 (Medicinal Product Dictionary - for medications)

**Laboratory** depends on:
- hl7.fhir.eu.base (EU Core - foundation)
- hl7.fhir.eu.extensions.r4

**EPS** depends on:
- hl7.fhir.uv.ips (International Patient Summary - base)
- hl7.fhir.eu.base (EU Core - foundation)
- EU extensions

**Imaging** depends on:
- FHIR R5 core (not R4)
- hl7.fhir.uv.extensions.r5

### 7.2 Critical Dependencies for Full Support

If EURIDICE implements **Option 1 (full FHIR IG validation)**:

1. **hl7.fhir.eu.base** - EU Core base profiles (Patient, Practitioner, etc.) - **CRITICAL FOUNDATION**
2. **hl7.fhir.uv.ips** - International Patient Summary (foundation for EPS and HDR)
3. **hl7.fhir.eu.extensions.r4** - EU-specific extensions
4. **ihe.pharm.mpd.r4** - Medicinal Product Dictionary (for medication standardization if supporting full HDR medications)

**Note:** EU Core (hl7.fhir.eu.base) should be considered the PRIMARY dependency as it provides the foundation profiles for European implementations.

### 7.3 Medication Complexity

The medication domain is notably complex:

- **5 medication resources**: Medication, MedicationRequest, MedicationStatement, MedicationAdministration, MedicationDispense
- **MPD dependency**: HDR references IHE Medicinal Product Dictionary for medication standardization
- **Initial recommendation**: Support **MedicationRequest only** (read-only prescriptions) for EPS/HDR
- **Future enhancement**: Add MedicationStatement for medication reconciliation
- **Defer**: MedicationAdministration, MedicationDispense (inpatient workflows), Medication (product details)

### 7.4 Imaging R5 Challenge

The EU Imaging IG is based on **FHIR R5**, while other priority areas use **R4**:

**Options:**
1. **Dual-version support**: Run R4 and R5 HAPI servers side-by-side
2. **R4 subset**: Create R4-compatible imaging profiles (reduced functionality)
3. **R5 migration**: Plan eventual R4→R5 upgrade for all resources
4. **Proxy/bridge**: Transform R5 imaging resources to R4 equivalents

**Recommendation:** Start with R4 resources (EPS, LAB, HDR) and defer full Imaging support until R5 strategy is defined. Support Imaging DocumentReferences in MHD but defer full resource validation.

### 7.5 Terminology Dependencies

EU IGs rely on several terminology systems:

- **LOINC**: Document types, lab tests, clinical sections
- **SNOMED CT**: Clinical findings, procedures, body structures
- **ICD-10/11**: Diagnoses
- **ATC**: Medications
- **UCUM**: Units of measure
- **RadLex**: Radiology concepts (imaging)
- **DICOM**: Imaging-specific codes

**EURIDICE needs:** Terminology server support for validation and code system lookups

### 7.6 Future Enhancements (Beyond Initial 12 Resources)

**Tier 4 (next priorities):**
- Specimen (laboratory workflows)
- ServiceRequest (orders/referrals context)
- ImagingStudy (imaging integration)
- PractitionerRole (enhanced practitioner context)

**Tier 5 (later):**
- MedicationStatement (medication reconciliation)
- Immunization (immunization history)
- CarePlan (care coordination)

**Specialized:**
- ImagingSelection (key images)
- Endpoint (service endpoints for image access)
- Device, DeviceUseStatement (medical devices/implants)
- FamilyMemberHistory, Flag (HDR-specific features)

---

## 8. Integration Recommendations for EURIDICE

### 8.1 Phased Implementation Approach

**Phase 1: Foundation (3-4 months)**
- Implement 12 core resources with EURIDICE profiles
- MHD DocumentReference for all priority areas
- Bundle support for FHIR documents
- Focus on read operations (IPA alignment)

**Phase 2: Clinical Enhancement (4-6 months)**
- Add Tier 4 resources (Specimen, ServiceRequest, ImagingStudy, PractitionerRole)
- Enhance search capabilities
- Add write operations for key resources (Patient, Condition, AllergyIntolerance)
- Terminology server integration

**Phase 3: Advanced Features (6+ months)**
- Tier 5 resources (MedicationStatement, Immunization, CarePlan)
- Full medication workflows (if needed)
- R5 imaging support (strategy dependent)
- EU IG validation (Option 1)

### 8.2 Validation Strategy

**Option 1: Full EU IG Validation (Complex)**
- Load EU IG packages into HAPI FHIR validator
- Validate all resources against EU profiles
- Requires: dependency resolution, extension definitions, terminology bindings
- Benefit: Strict conformance to EU standards
- Risk: Complex setup, ongoing maintenance

**Option 2: Partial Validation (Recommended for Phase 1)**
- Validate resource structure against base FHIR R4
- Validate required elements for priority areas
- Use custom StructureDefinitions for critical profiles
- Benefit: Faster implementation, easier maintenance
- Risk: May miss EU-specific constraints

**Option 3: Progressive Validation**
- Start with Option 2 (partial validation)
- Add EU IG packages incrementally per priority area
- Move toward Option 1 as maturity increases
- Benefit: Balanced approach, manageable complexity

**Recommendation:** **Option 3** - Start with partial validation, progressively add EU IG validation per priority area as implementation matures.

### 8.3 MHD Integration Points

1. **DocumentReference Create** (MHD ITI-65)
   - Extract metadata from FHIR Document Bundle
   - Map Composition.type → DocumentReference.type
   - Populate author, custodian, context from Composition

2. **DocumentReference Search** (MHD ITI-67)
   - Search by patient, type, category, date, status
   - Support XDS classCode mappings
   - Return DocumentReference resources

3. **Document Retrieve** (MHD ITI-68)
   - Return full FHIR Document Bundle
   - Include all referenced resources
   - Support format parameter (JSON/XML)

4. **SubmissionSet Metadata**
   - Map Bundle to SubmissionSet
   - Track document relationships (replace, append, transform)

### 8.4 Document Registry Architecture

**Recommended approach:**

```
┌─────────────────┐
│  FHIR Document  │
│     Bundle      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐         ┌──────────────────┐
│ DocumentReference│────────▶│  Binary or       │
│   (metadata)     │         │  External URL    │
└────────┬────────┘         │  (document blob) │
         │                   └──────────────────┘
         │
         ▼
┌─────────────────┐
│ FHIR Resources  │
│ (extracted from │
│   document)     │
│                 │
│ • Patient       │
│ • Observation   │
│ • DiagnosticRpt │
│ • Condition     │
│ • etc.          │
└─────────────────┘
```

**Process:**
1. Receive FHIR Document Bundle (MHD ITI-65 or upload)
2. Extract Composition metadata → create DocumentReference
3. Store Bundle as Binary or external blob
4. Extract key resources from Bundle → store in FHIR repository
5. Link DocumentReference → Binary/URL + extracted resources
6. Support both document-centric (retrieve Bundle) and resource-centric (query resources) access

### 8.5 Priority Area Coverage Plan

| Priority Area | Phase 1 | Phase 2 | Phase 3 |
|---------------|---------|---------|---------|
| **Patient Summary** | ✅ Core sections (Problems, Allergies, Meds) | + Procedures, Results | + Immunizations, Devices |
| **Laboratory** | ✅ DiagnosticReport + Observations | + Specimen, ServiceRequest | + Full panel hierarchies |
| **Hospital Discharge** | ✅ Core sections (Course, Diagnoses, Procedures) | + Encounter, Plan of Care | + Full medication workflows |
| **Imaging Report** | ⚠️ DocumentReference only | + DiagnosticReport, Observations | + Full R5 support |
| **Imaging Manifest** | ❌ Deferred | ⚠️ Basic ImagingStudy | + ImagingSelection, Endpoints |

**Legend:**
- ✅ = Full support
- ⚠️ = Partial support
- ❌ = Not supported

### 8.6 Search Parameter Requirements

Based on IPA and QEDm, implement these search parameters:

**All Resources:**
- `_id`, `_lastUpdated`

**Patient:**
- `identifier`, `name`, `birthdate`, `gender`

**Condition:**
- `patient`, `category`, `clinical-status`, `onset-date`, `code`

**AllergyIntolerance:**
- `patient`, `clinical-status`, `code`

**Observation:**
- `patient`, `category`, `code`, `date`, `status`

**DiagnosticReport:**
- `patient`, `category`, `code`, `date`, `status`

**MedicationRequest:**
- `patient`, `status`, `intent`, `authoredon`

**DocumentReference:**
- `patient`, `type`, `category`, `date`, `status`, `author`, `custodian`

**Procedure:**
- `patient`, `date`, `code`, `status`

**Encounter:**
- `patient`, `date`, `class`, `type`, `status`

---

## 9. Conclusion

This analysis provides a comprehensive foundation for EURIDICE resource prioritization:

1. **12 core resources** cover 70-90% of all priority area requirements
2. **EU Core (hl7.fhir.eu.base)** provides foundation profiles for 15+ resource types - **CRITICAL FOUNDATION LAYER**
3. Strong alignment with **IPA and QEDm** reduces implementation risk
4. **MHD integration** is straightforward with FHIR Document Bundles
5. **Phased approach** balances functionality with complexity
6. **Progressive validation** strategy manages EU IG dependency complexity
7. **R5 imaging** challenge deferred to later phase
8. **Clear inheritance chains** documented: FHIR Base → EU Core → Priority IGs → EURIDICE

### Key Additions in This Version

**Section 6: EU Core Base Alignment**
- Complete inventory of 23 EU Core StructureDefinitions
- Profile inheritance chains mapped across all priority IGs
- Detailed recommendations for when to use EU Core vs priority-specific profiles
- Resource inheritance strategy table for EURIDICE implementation
- Full dependency stack visualization

**Appendix D: Complete Reproduction Guide**
- Step-by-step commands to download and extract all packages
- jq queries to analyze profiles and inheritance
- Tools and techniques to extract Composition sections, document types, and constraints
- Automation scripts for complete analysis workflow
- Tips for troubleshooting and updating the analysis

**Resource Matrix Enhancement**
- Added EU Core column showing which resources have EU Core profiles
- Clearly identifies foundation resources available for inheritance

### Next Steps

1. **Approve resource priorities**: Confirm 12-resource initial set
2. **Adopt EU Core as foundation**: Use EU Core profiles as base for EURIDICE profiles where available
3. **Define EURIDICE profiles**: Create StructureDefinitions extending EU Core or priority-specific profiles
4. **Implement Phase 1**: Foundation resources + MHD DocumentReference + EU Core inheritance
5. **Develop test data**: Create sample documents for each priority area
6. **Plan terminology**: Set up terminology server for LOINC, SNOMED, etc.
7. **Define validation strategy**: Choose Option 1, 2, or 3 (recommend Option 3: Progressive)
8. **Build test harness**: Automated testing against EU IG examples
9. **Document inheritance decisions**: Maintain mapping of EURIDICE → EU Core → Priority IG inheritance

---

## Appendix A: Package Information

### A.1 Downloaded Packages

| Package | Version | FHIR Version | Download Date | Source |
|---------|---------|--------------|---------------|--------|
| hl7.fhir.eu.base | 2.0.0-ballot | R4 (4.0.1) | 2026-01-03 | https://build.fhir.org/ig/hl7-eu/base/package.tgz |
| hl7.fhir.eu.laboratory | 0.1.1 | R4 (4.0.1) | 2026-01-03 | https://packages.simplifier.net/hl7.fhir.eu.laboratory/0.1.1 |
| hl7.fhir.eu.hdr | 0.1.0-ballot | R4 (4.0.1) | 2026-01-03 | https://packages.simplifier.net/hl7.fhir.eu.hdr/0.1.0-ballot |
| hl7.fhir.eu.eps | 1.0.0-ci-build | R4 (4.0.1) | 2026-01-03 | https://build.fhir.org/ig/hl7-eu/eps/package.tgz |
| hl7.fhir.eu.imaging | 0.1.1-build | R5 (5.0.0) | 2026-01-03 | https://build.fhir.org/ig/hl7-eu/imaging/package.tgz |

### A.2 Key References

- [HL7 Europe Base IG (EU Core)](https://build.fhir.org/ig/hl7-eu/base/)
- [HL7 Europe Patient Summary IG](https://build.fhir.org/ig/hl7-eu/eps/)
- [HL7 Europe Laboratory IG](https://hl7.eu/fhir/laboratory/0.1.1/)
- [HL7 Europe Hospital Discharge Report IG](https://hl7.eu/fhir/hdr/0.1.0-ballot/)
- [HL7 Europe Imaging IG](https://build.fhir.org/ig/hl7-eu/imaging/)
- [MADO Profile (Imaging Manifest)](https://build.fhir.org/ig/hl7-eu/imaging-manifest/)
- [GitHub: hl7-eu/base](https://github.com/hl7-eu/base)
- [GitHub: hl7-eu/eps](https://github.com/hl7-eu/eps)
- [GitHub: hl7-eu/laboratory](https://github.com/hl7-eu/laboratory/)
- [GitHub: hl7-eu/hdr](https://github.com/hl7-eu/hdr/)
- [GitHub: hl7-eu/imaging](https://github.com/hl7-eu/imaging/)
- [GitHub: hl7-eu/imaging-manifest](https://github.com/hl7-eu/imaging-manifest/)

### A.3 Analysis Methodology

1. Downloaded FHIR Implementation Guide packages (`.tgz` archives)
2. Extracted StructureDefinition JSON files
3. Analyzed profiles to identify:
   - Base resource types profiled
   - Composition sections and cardinality
   - Document type codes (LOINC)
   - Bundle structures
   - Referenced resources
   - EU Core inheritance chains
4. Cross-referenced with IPA and QEDm specifications
5. Mapped to MHD DocumentReference requirements
6. Analyzed EU Core (hl7.fhir.eu.base) foundation profiles
7. Created resource priority matrix based on coverage and importance

### A.4 Limitations

- **Imaging packages** are R5-based; full analysis requires R5 compatibility
- **EPS Composition sections** were harder to extract from package files; relied on IG documentation
- **Terminology bindings** not fully analyzed (ValueSets not comprehensively reviewed)
- **MPD (Medicinal Product Dictionary)** dependency for medications not fully explored
- **Example resources** were identified but not analyzed in detail
- Some packages are **ballot/draft versions**, subject to change
- **EU Core inheritance** was analyzed at the profile level but not all element-level constraints were exhaustively reviewed

---

## Appendix B: Resource Profiles by Priority Area

### B.1 Patient Summary (EPS)

**All Profiles (11 resources):**

| Profile Name | Base Resource | Purpose |
|-------------|---------------|---------|
| BundleEuEps | Bundle | Document bundle container |
| CompositionEuEps | Composition | Document metadata and sections |
| PatientEuEps | Patient | Patient demographics |
| ConsentEuEps | Consent | Advance directives |
| DeviceEuEps | Device | Medical devices |
| DeviceUseStatementEuEps | DeviceUseStatement | Device usage |
| MedicationRequestEuEps | MedicationRequest | Prescriptions |
| MedicationDispenseEuEps | MedicationDispense | Dispensed medications |
| MedicationAdministrationEuEps | MedicationAdministration | Administered medications |
| ObservationTravelEuEps | Observation | Travel history |
| + 3 Extensions | Extension | Supporting extensions |

### B.2 Laboratory Report

**All Profiles (20+ resources/logical models):**

| Profile Name | Base Resource | Purpose |
|-------------|---------------|---------|
| BundleLabReportEu | Bundle | Document bundle |
| CompositionLabReportEu | Composition | Report metadata and sections |
| DiagnosticReportLabEu | DiagnosticReport | Report anchor |
| ObservationResultsLaboratoryEu | Observation | Lab result values |
| PatientEuLab | Patient | Patient |
| SpecimenEu | Specimen | Sample information |
| ServiceRequestLabEu | ServiceRequest | Lab order |
| BodyStructureEu | BodyStructure | Collection site |
| PractitionerEu | Practitioner | Lab personnel |
| PractitionerRoleEu | PractitionerRole | Lab role |
| QuantityEuLab | Quantity | Quantity data type |
| RatioEuLab | Ratio | Ratio data type |
| + Extensions | Extension | Device (test kit), reference materials |
| + Logical Models | N/A | eHN data model mappings |

### B.3 Hospital Discharge Report (HDR)

**All Profiles (66 profiles - standard + obligation variants):**

**Note:** HDR has dual profiles for many resources (standard + "-obl" obligation variant)

**Clinical:**
- AllergyIntoleranceEuHdr / AllergyIntoleranceEuHdrObligation
- ConditionEuHdr / ConditionEuHdrObligation
- ProcedureEuHdr / ProcedureEuHdrObligation
- ObservationImgFindingEuHdr, ObservationInfectiousContactEuHdr, ObservationSdohEuHdr, ObservationTravelEuHdr (all with obligation variants)
- FamilyMemberHistoryEuHdr / FamilyMemberHistoryEuHdrObligation
- FlagEuHdr / FlagEuHdrObligation

**Medications (10 profiles):**
- MedicationEuHdr / MedicationEuHdrObligation
- MedicationRequestEuHdr / MedicationRequestEuHdrObligation
- MedicationStatementEuHdr / MedicationStatementEuHdrObligation
- MedicationAdministrationEuHdr / MedicationAdministrationEuHdrObligation
- MedicationDispenseEuHdr / MedicationDispenseEuHdrObligation

**Immunizations (4 profiles):**
- ImmunizationEuHdr / ImmunizationEuHdrObligation
- ImmunizationRecommendationEuHdr / ImmunizationRecommendationEuHdrObligation

**Devices (4 profiles):**
- DeviceEuHdr / DeviceEuHdrObligation
- DeviceUseStatementEuHdr / DeviceUseStatementEuHdrObligation

**Care Planning (4 profiles):**
- CarePlanEuHdr / CarePlanEuHdrObligation
- ConsentHdrEu / ConsentHdrEuObligation

**Administrative (4 profiles):**
- EncounterEuHdr / EncounterEuHdrObligation
- PatientEu (with obligation variants)

**Foundation:**
- BundleEuHdr / BundleEuHdrObligation
- CompositionEuHdr / CompositionEuHdrObligation
- PractitionerEu, PractitionerRoleEu
- AddressEu, HumanNameEu

**Other:**
- ServiceRequestEuObligations
- SpecimenEu (with obligations)
- SpecimenAdditiveSubstance

**Logical Models (eHN mappings - 15 models):**
- HospitalDischargeReportEhn
- HeaderHdrEhn, SubjectHdrEhn
- AdmissionEvaluationEhn, HospitalStayEhn, DischargeDetailsEhn
- PatientHistoryEhn, FunctionalStatusHdrEhn, ObjectiveFindingsHdrEhn
- MedicationSummaryHdrEhn, PlanOfCareHdrEhn
- EncounterEhn (InPatientEncounter)
- AlertsEhn, AdvanceDirectivesEhn

### B.4 Imaging Report (R5)

**Profiles (estimated - package analysis limited):**

| Profile | Base Resource | Purpose |
|---------|---------------|---------|
| ImDiagnosticReport | DiagnosticReport | Report anchor |
| ImComposition | Composition | Report narrative |
| ImObservation | Observation | Findings, measurements |
| ImRadiationDoseObservation | Observation | Radiation dose |
| ImKeyImageDocumentReference | DocumentReference | Key images |
| (ImagingStudy profile expected) | ImagingStudy | DICOM study reference |

**ValueSets:**
- ImagingReportTypesEuVS (LOINC/RadLex)

---

## Appendix C: LOINC Codes Reference

### C.1 Document Type Codes

| Code | Display | Priority Area |
|------|---------|---------------|
| 60591-5 | Patient summary Document | Patient Summary (EPS) |
| 34105-7 | Hospital Discharge summary | Hospital Discharge (HDR) |
| 11502-2 | Laboratory report | Laboratory (generic) |
| 18748-4 | Diagnostic imaging study | Imaging (generic) |
| 18782-3 | Radiology Study observation (narrative) | Imaging |

### C.2 Section Codes (HDR)

| Code | Display | Cardinality |
|------|---------|-------------|
| 8648-8 | Hospital course | 1..1 |
| 67851-6 | Admission evaluation | 0..1 |
| 8716-3 | Vital signs | 0..1 |
| 29545-1 | Physical findings | 0..1 |
| 47420-5 | Functional status | 0..1 |
| 11535-2 | Diagnostic summary | 0..1 |
| 10185-7 | Significant procedures | 0..1 |
| 57080-4 | Medical devices and implants | 0..1 |
| 87232-5 | Pharmacotherapy | 0..1 |
| 30954-2 | Significant results | 0..1 |
| 67781-5 | Synthesis | 0..1 |
| 18776-5 | Plan of care | 0..1 |
| 8653-8 | Discharge instructions | 0..1 |
| 34106-5 | Discharge medications | 0..1 |

### C.3 Laboratory Annotation Code

| Code | Display | Purpose |
|------|---------|---------|
| 48767-8 | Annotation comment | Free-text annotations |

---

## Appendix D: Complete Reproduction Guide

This appendix provides exact commands and methodology to reproduce this analysis from scratch. This enables anyone to:
- Verify the findings in this document
- Update the analysis when new IG versions are released
- Extend the analysis to additional priority areas or resources

### D.1 Prerequisites

**Required tools:**
- `curl` - Download packages from web
- `tar` - Extract .tgz archives
- `jq` - Parse and query JSON files
- `grep` / `rg` (ripgrep) - Search file contents
- `find` - Locate files
- Basic shell (bash/zsh)

**Install tools (macOS):**
```bash
brew install curl jq ripgrep

# tar is pre-installed on macOS
```

**Install tools (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install curl jq ripgrep tar
```

### D.2 Download All Packages

Create a working directory and download all EU FHIR IG packages:

```bash
# Create working directory
mkdir -p eu-fhir-analysis
cd eu-fhir-analysis

# Download EU Core (foundation layer)
curl -L -o eu-core.tgz https://build.fhir.org/ig/hl7-eu/base/package.tgz

# Download Patient Summary (EPS)
curl -L -o eps.tgz https://build.fhir.org/ig/hl7-eu/eps/package.tgz

# Download Laboratory Reports
curl -L -o lab.tgz https://packages.simplifier.net/hl7.fhir.eu.laboratory/0.1.1

# Download Hospital Discharge Report (HDR)
curl -L -o hdr.tgz https://packages.simplifier.net/hl7.fhir.eu.hdr/0.1.0-ballot

# Download Imaging Reports (R5-based)
curl -L -o imaging.tgz https://build.fhir.org/ig/hl7-eu/imaging/package.tgz

# Optional: Download Imaging Manifest (MADO)
curl -L -o mado.tgz https://build.fhir.org/ig/hl7-eu/imaging-manifest/package.tgz
```

### D.3 Extract Packages

Extract each package into its own directory:

```bash
# Extract all packages
mkdir -p eu-core eps lab hdr imaging mado

tar -xzf eu-core.tgz -C eu-core/
tar -xzf eps.tgz -C eps/
tar -xzf lab.tgz -C lab/
tar -xzf hdr.tgz -C hdr/
tar -xzf imaging.tgz -C imaging/
tar -xzf mado.tgz -C mado/

# Verify extraction
ls -la eu-core/package/
ls -la eps/package/
ls -la lab/package/
ls -la hdr/package/
```

### D.4 Analyze Package Metadata

Check package.json for each IG to understand versions, dependencies, and FHIR versions:

```bash
# EU Core package metadata
cat eu-core/package/package.json | jq '{name, version, fhirVersions, dependencies}'

# EPS package metadata
cat eps/package/package.json | jq '{name, version, fhirVersions, dependencies}'

# LAB package metadata
cat lab/package/package.json | jq '{name, version, fhirVersions, dependencies}'

# HDR package metadata
cat hdr/package/package.json | jq '{name, version, fhirVersions, dependencies}'

# Imaging package metadata (note: R5-based)
cat imaging/package/package.json | jq '{name, version, fhirVersions, dependencies}'
```

### D.5 List All StructureDefinitions

Extract all StructureDefinition resources to understand what profiles each IG provides:

```bash
# EU Core profiles
echo "=== EU CORE PROFILES ==="
find eu-core/package -name "StructureDefinition-*.json" -type f | \
  xargs -I {} jq -r '{id: .id, name: .name, type: .type, kind: .kind, baseDefinition: .baseDefinition} |
  "\(.type) | \(.name) | \(.baseDefinition // "N/A")"' {} | \
  sort | column -t -s "|"

# EPS profiles
echo "=== EPS PROFILES ==="
find eps/package -name "StructureDefinition-*.json" -type f | \
  xargs -I {} jq -r '{id: .id, name: .name, type: .type, baseDefinition: .baseDefinition} |
  "\(.type) | \(.name) | \(.baseDefinition // "N/A")"' {} | \
  sort | column -t -s "|"

# LAB profiles
echo "=== LAB PROFILES ==="
find lab/package -name "StructureDefinition-*.json" -type f | \
  xargs -I {} jq -r '{id: .id, name: .name, type: .type, baseDefinition: .baseDefinition} |
  "\(.type) | \(.name) | \(.baseDefinition // "N/A")"' {} | \
  sort | column -t -s "|"

# HDR profiles
echo "=== HDR PROFILES ==="
find hdr/package -name "StructureDefinition-*.json" -type f | \
  xargs -I {} jq -r '{id: .id, name: .name, type: .type, baseDefinition: .baseDefinition} |
  "\(.type) | \(.name) | \(.baseDefinition // "N/A")"' {} | \
  sort | column -t -s "|"
```

### D.6 Count Resources by Type

Understand resource distribution across IGs:

```bash
# Count StructureDefinitions per IG
echo "EU Core: $(find eu-core/package -name "StructureDefinition-*.json" | wc -l) profiles"
echo "EPS: $(find eps/package -name "StructureDefinition-*.json" | wc -l) profiles"
echo "LAB: $(find lab/package -name "StructureDefinition-*.json" | wc -l) profiles"
echo "HDR: $(find hdr/package -name "StructureDefinition-*.json" | wc -l) profiles"

# Count by resource type (EU Core example)
echo "=== EU Core Resources by Type ==="
find eu-core/package -name "StructureDefinition-*.json" -type f | \
  xargs jq -r '.type' | sort | uniq -c | sort -rn
```

### D.7 Analyze Profile Inheritance

Trace inheritance chains from FHIR base → EU Core → Priority IGs:

```bash
# Check Patient profile inheritance
echo "=== PATIENT PROFILE INHERITANCE ==="

# EU Core Patient
echo "EU Core PatientEuCore:"
cat eu-core/package/StructureDefinition-patient-eu-core.json | \
  jq '{id, name, baseDefinition, type}'

echo "EU Core PatientEu (base):"
cat eu-core/package/StructureDefinition-patient-eu.json | \
  jq '{id, name, baseDefinition, type}'

# EPS Patient
echo "EPS PatientEuEps:"
cat eps/package/StructureDefinition-patient-eu-eps.json | \
  jq '{id, name, baseDefinition, type}'

# LAB Patient
echo "LAB PatientEuLab:"
cat lab/package/StructureDefinition-Patient-eu-lab.json | \
  jq '{id, name, baseDefinition, type}'

# HDR Patient
echo "HDR PatientEuObligations:"
cat hdr/package/StructureDefinition-patient-obl-eu-hdr.json | \
  jq '{id, name, baseDefinition, type}'
```

### D.8 Extract Composition Sections

Analyze Composition profiles to understand document structure:

```bash
# EPS Composition sections
echo "=== EPS COMPOSITION SECTIONS ==="
cat eps/package/StructureDefinition-composition-eu-eps.json | \
  jq '.snapshot.element[] | select(.path | contains("Composition.section")) |
  {path, short, min, max, code: .code[0].code}' | \
  jq -s 'unique_by(.path)'

# LAB Composition sections
echo "=== LAB COMPOSITION SECTIONS ==="
cat lab/package/StructureDefinition-Composition-lab-eu-lab.json | \
  jq '.differential.element[] | select(.path | contains("section")) |
  {path, short, min, max}'

# HDR Composition sections
echo "=== HDR COMPOSITION SECTIONS ==="
cat hdr/package/StructureDefinition-Composition-eu-hdr.json | \
  jq '.snapshot.element[] | select(.path | contains("Composition.section")) |
  {path, short, min, max}' | \
  jq -s 'unique_by(.path)'
```

### D.9 Identify Document Type Codes

Extract LOINC codes used for document types:

```bash
# Search for document type codes in Composition profiles
echo "=== DOCUMENT TYPE CODES ==="

# EPS document type
cat eps/package/StructureDefinition-composition-eu-eps.json | \
  jq '.snapshot.element[] | select(.path == "Composition.type") | .patternCodeableConcept'

# LAB document types (ValueSet)
cat lab/package/ValueSet-*.json | grep -l "laboratory.*report" | \
  xargs cat | jq '.compose.include[].concept[] | {code: .code, display: .display}' 2>/dev/null || echo "Check ValueSet files"

# HDR document type
cat hdr/package/StructureDefinition-Composition-eu-hdr.json | \
  jq '.snapshot.element[] | select(.path == "Composition.type") | .patternCodeableConcept'
```

### D.10 Analyze EU Core Constraints

Understand what EU Core profiles constrain:

```bash
# PatientEuCore constraints
echo "=== PatientEuCore Key Constraints ==="
cat eu-core/package/StructureDefinition-patient-eu-core.json | \
  jq '.differential.element[] | select(.min != null or .mustSupport == true) |
  {path, min, max, short, mustSupport}'

# MedicalTestResultEuCore (Observation) constraints
echo "=== MedicalTestResultEuCore Key Constraints ==="
cat eu-core/package/StructureDefinition-medicalTestResult-eu-core.json | \
  jq '.differential.element[] | select(.min != null or .mustSupport == true) |
  {path, min, max, short, mustSupport}' | head -20

# List all EU Core profiles by resource type
echo "=== EU Core Profile Inventory ==="
find eu-core/package -name "StructureDefinition-*.json" -type f | \
  xargs jq -r '{type: .type, name: .name, id: .id} | "\(.type)|\(.name)|\(.id)"' | \
  sort | column -t -s "|"
```

### D.11 Create Resource Coverage Matrix

Build a matrix showing which resources are used in which IGs:

```bash
# List unique resource types across all IGs
echo "=== UNIQUE RESOURCE TYPES ACROSS ALL IGs ==="

# Combine all resource types and count
(find eu-core/package -name "StructureDefinition-*.json" -type f -exec jq -r '.type' {} \;
 find eps/package -name "StructureDefinition-*.json" -type f -exec jq -r '.type' {} \;
 find lab/package -name "StructureDefinition-*.json" -type f -exec jq -r '.type' {} \;
 find hdr/package -name "StructureDefinition-*.json" -type f -exec jq -r '.type' {} \;) | \
  sort | uniq -c | sort -rn

# Check specific resource presence
for resource in "Patient" "Practitioner" "Organization" "Observation" "DiagnosticReport" "Condition" "AllergyIntolerance"; do
  echo "=== $resource presence ==="
  echo -n "EU Core: "
  find eu-core/package -name "StructureDefinition-*.json" -exec jq -r 'select(.type == "'$resource'") | .name' {} \; | head -1 || echo "Not found"
  echo -n "EPS: "
  find eps/package -name "StructureDefinition-*.json" -exec jq -r 'select(.type == "'$resource'") | .name' {} \; | head -1 || echo "Not found"
  echo -n "LAB: "
  find lab/package -name "StructureDefinition-*.json" -exec jq -r 'select(.type == "'$resource'") | .name' {} \; | head -1 || echo "Not found"
  echo -n "HDR: "
  find hdr/package -name "StructureDefinition-*.json" -exec jq -r 'select(.type == "'$resource'") | .name' {} \; | head -1 || echo "Not found"
  echo ""
done
```

### D.12 Extract Examples

Examine example resources to understand usage patterns:

```bash
# List example resources
echo "=== EXAMPLE RESOURCES ==="

# EU Core examples
echo "EU Core examples:"
ls eu-core/package/example/ | head -10

# EPS examples
echo "EPS examples:"
ls eps/package/example/ | head -10

# LAB examples
echo "LAB examples:"
ls lab/package/example/ | head -10

# Examine a specific example (LAB Bundle)
echo "=== Sample LAB Bundle Structure ==="
find lab/package/example -name "*Bundle*.json" -type f | head -1 | \
  xargs cat | jq '{resourceType, type, entry: [.entry[] | {resourceType: .resource.resourceType}]}'
```

### D.13 Analyze Dependencies

Understand package dependency chains:

```bash
# Create dependency graph
echo "=== PACKAGE DEPENDENCY GRAPH ==="

echo "EU Core depends on:"
cat eu-core/package/package.json | jq '.dependencies | keys[]'

echo "EPS depends on:"
cat eps/package/package.json | jq '.dependencies | keys[]'

echo "LAB depends on:"
cat lab/package/package.json | jq '.dependencies | keys[]'

echo "HDR depends on:"
cat hdr/package/package.json | jq '.dependencies | keys[]'
```

### D.14 Search for Specific Patterns

Use grep/ripgrep to find specific patterns across all packages:

```bash
# Find all profiles that inherit from EU Core
echo "=== Profiles inheriting from EU Core ==="
rg "hl7.eu/fhir/base/StructureDefinition" --type json -A 2 -B 2 | grep -E "(name|baseDefinition)"

# Find all LOINC codes used
echo "=== LOINC Codes Used ==="
rg "\"system\".*loinc" --type json | grep -oP '"code":\s*"\K[^"]+' | sort | uniq

# Find all must-support elements
echo "=== Must-Support Elements ==="
rg "\"mustSupport\":\s*true" --type json -B 2 | grep "\"path\"" | \
  grep -oP '"path":\s*"\K[^"]+' | sort | uniq -c | sort -rn | head -20
```

### D.15 Generate Summary Report

Create a summary report combining all analysis:

```bash
# Create comprehensive summary
cat > analysis-summary.txt <<'EOF'
EU FHIR IG ANALYSIS SUMMARY
Generated: $(date)

=== PACKAGES ANALYZED ===
EOF

echo "EU Core: $(cat eu-core/package/package.json | jq -r '.version')" >> analysis-summary.txt
echo "EPS: $(cat eps/package/package.json | jq -r '.version')" >> analysis-summary.txt
echo "LAB: $(cat lab/package/package.json | jq -r '.version')" >> analysis-summary.txt
echo "HDR: $(cat hdr/package/package.json | jq -r '.version')" >> analysis-summary.txt

echo "" >> analysis-summary.txt
echo "=== PROFILE COUNTS ===" >> analysis-summary.txt
echo "EU Core: $(find eu-core/package -name 'StructureDefinition-*.json' | wc -l) profiles" >> analysis-summary.txt
echo "EPS: $(find eps/package -name 'StructureDefinition-*.json' | wc -l) profiles" >> analysis-summary.txt
echo "LAB: $(find lab/package -name 'StructureDefinition-*.json' | wc -l) profiles" >> analysis-summary.txt
echo "HDR: $(find hdr/package -name 'StructureDefinition-*.json' | wc -l) profiles" >> analysis-summary.txt

cat analysis-summary.txt
```

### D.16 Automation Script

Complete script to run entire analysis:

```bash
#!/bin/bash
# File: analyze-eu-fhir-igs.sh
# Purpose: Complete analysis of EU FHIR Implementation Guides

set -e

# Configuration
WORK_DIR="eu-fhir-analysis"
OUTPUT_FILE="analysis-results.md"

# Create working directory
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Download packages
echo "Downloading packages..."
curl -L -o eu-core.tgz https://build.fhir.org/ig/hl7-eu/base/package.tgz
curl -L -o eps.tgz https://build.fhir.org/ig/hl7-eu/eps/package.tgz
curl -L -o lab.tgz https://packages.simplifier.net/hl7.fhir.eu.laboratory/0.1.1
curl -L -o hdr.tgz https://packages.simplifier.net/hl7.fhir.eu.hdr/0.1.0-ballot

# Extract packages
echo "Extracting packages..."
mkdir -p eu-core eps lab hdr
tar -xzf eu-core.tgz -C eu-core/
tar -xzf eps.tgz -C eps/
tar -xzf lab.tgz -C lab/
tar -xzf hdr.tgz -C hdr/

# Generate analysis report
echo "# EU FHIR IG Analysis Report" > "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Package versions
echo "## Package Versions" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
for pkg in eu-core eps lab hdr; do
  echo "- **$pkg**: $(cat $pkg/package/package.json | jq -r '.name + " " + .version')" >> "$OUTPUT_FILE"
done
echo "" >> "$OUTPUT_FILE"

# Profile counts
echo "## Profile Counts" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
for pkg in eu-core eps lab hdr; do
  count=$(find $pkg/package -name "StructureDefinition-*.json" | wc -l)
  echo "- **$pkg**: $count profiles" >> "$OUTPUT_FILE"
done
echo "" >> "$OUTPUT_FILE"

# Resource types
echo "## Unique Resource Types" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
find . -name "StructureDefinition-*.json" -exec jq -r '.type' {} \; | \
  sort | uniq -c | sort -rn >> "$OUTPUT_FILE"

echo "Analysis complete. Results in $OUTPUT_FILE"
```

### D.17 Tips and Best Practices

**Performance optimization:**
- Use `jq -c` for compact output when processing large files
- Use `xargs -P 4` for parallel processing on multi-core systems
- Cache package downloads to avoid re-downloading

**Troubleshooting:**
- If `jq` commands fail, check JSON syntax with `jq '.' file.json`
- Use `jq -r` for raw output (removes quotes)
- Check package.json first if extraction seems incorrect

**Updating the analysis:**
- Re-run download commands periodically to get latest versions
- Check `package.json` for "date" field to see when package was built
- Compare versions using `diff` on extracted package directories

**Advanced queries:**
- Use `jq` path expressions: `.snapshot.element[] | select(.path == "Patient.name")`
- Combine with `grep`: `jq ... | grep pattern`
- Export to CSV: `jq -r '@csv'` for spreadsheet import

---

**END OF DOCUMENT**
