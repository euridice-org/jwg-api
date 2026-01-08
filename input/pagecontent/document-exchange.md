# Document Exchange

## Overview

Document exchange using IHE MHD (Mobile Health Documents) transactions. This IG inherits MHD transactions as-is, with constraints specific to EEHRxF content.

## Actors

- **Document Producer** (client): Publishes documents using MHD Document Source
- **Document Access Provider** (server): Receives and serves documents using MHD Document Recipient + Document Responder
- **Document Consumer** (client): Queries and retrieves documents using MHD Document Consumer

See [Actors and Transactions](actors.html) for detailed actor groupings.

## Document Search Strategy: Category vs Type

This IG follows the IHE approach for document discovery, using a **two-step search pattern**:

1. **Request Search (Coarse)**: Use `category` to cast a wide net
2. **Response Filtering (Precise)**: Filter results client-side using `type`

### Category (Coarse Search)

`DocumentReference.category` uses **XDS ClassCode** values for broad document classification:

| Code | Display | Use For |
|------|---------|---------|
| `REPORTS` | Reports | Laboratory reports, imaging reports, clinical reports |
| `SUMMARIES` | Summaries | Patient summaries, discharge summaries |
| `IMAGES` | Images | Imaging manifests, DICOM references |
| `PRESCRIPTIONS` | Prescriptions | Medication prescriptions |
| `DISPENSATIONS` | Dispensations | Medication dispensation records |

See [EEHRxFDocumentClassVS](ValueSet-eehrxf-document-class-vs.html) for the complete list.

### Type (Clinical Precision)

`DocumentReference.type` uses **LOINC codes** for specific document identification:

| LOINC Code | Display | Priority Category |
|------------|---------|-------------------|
| `60591-5` | Patient summary Document | Patient Summary (IPS) |
| `18842-5` | Discharge summary | Hospital Discharge Report (HDR) |
| `11502-2` | Laboratory report | Laboratory Report |
| `68604-8` | Radiology Diagnostic study note | Diagnostic Imaging Report |

See [EEHRxFDocumentTypeVS](ValueSet-eehrxf-document-type-vs.html) for the complete list.

### practiceSetting for Lab vs Imaging Differentiation

When searching for reports (`category=REPORTS`), the `context.practiceSetting` element SHOULD be used to differentiate between laboratory and imaging reports:

- **Laboratory**: `practiceSetting` = General pathology, Clinical pathology, etc.
- **Imaging**: `practiceSetting` = Radiology, Cardiology, Nuclear medicine, etc.

See [HL7 Practice Setting Codes](http://hl7.org/fhir/ValueSet/c80-practice-codes) for available values.

## Canonical Query Examples

The following examples demonstrate the recommended search patterns for document discovery.

### Example 1: Find Patient Summary by Type

When you know you want a specific document type, search directly by type:

```http
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|60591-5&status=current
```

**Parameters**:
- `patient`: Patient reference (required)
- `type`: LOINC code for Patient Summary
- `status`: Only current documents

**Use case**: Retrieve the patient's International Patient Summary for unplanned care encounter.

### Example 2: Find Laboratory Reports by Type

```http
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|11502-2&status=current
```

**Parameters**:
- `patient`: Patient reference (required)
- `type`: LOINC code for Laboratory Report
- `status`: Only current documents

**Use case**: Retrieve all laboratory reports for a patient.

### Example 3: Find All Reports by Category (Coarse Search)

When you want to discover all reports regardless of type:

```http
GET [base]/DocumentReference?patient=Patient/123&category=urn:oid:1.3.6.1.4.1.19376.1.2.6.1|REPORTS&status=current
```

**Parameters**:
- `patient`: Patient reference (required)
- `category`: XDS ClassCode for REPORTS
- `status`: Only current documents

**Use case**: Discover all reports (lab, imaging, clinical) for a patient, then filter client-side by type.

### Example 4: Find Imaging Reports (Category + practiceSetting)

To find specifically imaging reports, combine category with practiceSetting:

```http
GET [base]/DocumentReference?patient=Patient/123&category=urn:oid:1.3.6.1.4.1.19376.1.2.6.1|REPORTS&context.practiceSetting=http://snomed.info/sct|394914008&status=current
```

**Parameters**:
- `patient`: Patient reference (required)
- `category`: XDS ClassCode for REPORTS
- `context.practiceSetting`: SNOMED code for Radiology (394914008)
- `status`: Only current documents

**Use case**: Retrieve radiology reports specifically.

### Example 5: Find Imaging Manifests

To find imaging manifests (DICOM references):

```http
GET [base]/DocumentReference?patient=Patient/123&category=urn:oid:1.3.6.1.4.1.19376.1.2.6.1|IMAGES&status=current
```

**Parameters**:
- `patient`: Patient reference (required)
- `category`: XDS ClassCode for IMAGES
- `status`: Only current documents

**Use case**: Retrieve imaging study manifests for WADO retrieval.

### Example 6: Find Discharge Summaries

```http
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|18842-5&status=current
```

**Parameters**:
- `patient`: Patient reference (required)
- `type`: LOINC code for Discharge Summary
- `status`: Only current documents

**Use case**: Retrieve hospital discharge reports for continuity of care.

## IHE MHD Transactions

This IG uses the following IHE MHD transactions without modification to the transaction mechanics:

### ITI-65: Provide Document Bundle (Publish)

Document Producer → Document Access Provider

Transaction bundle containing DocumentReference + Binary resources.

**Endpoint**: `POST [base]` (transaction bundle)

**Scope**: `system/DocumentReference.c`, `system/Binary.c`

**Constraints**:
- DocumentReference SHALL conform to EEHRxF DocumentReference profile for declared priority category
- Binary content SHALL be valid EEHRxF content (FHIR document Bundle)
- DocumentReference.type and .format SHALL match priority category value sets

See [IHE MHD ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html) for transaction details.

### ITI-67: Find Document References (Search)

Document Consumer → Document Access Provider

Query for DocumentReference resources.

**Endpoint**: `GET [base]/DocumentReference?[parameters]`

**Required Parameters**:
- `patient` (required)
- `_count` (for paging)

**Recommended Parameters** (see [Document Search Strategy](#document-search-strategy-category-vs-type)):
- `category` - Document class (XDS ClassCode) for coarse filtering
- `type` - Document type (LOINC) for clinical precision
- `context.practiceSetting` - Clinical specialty for lab vs imaging differentiation

**Additional Parameters**:
- `date` - Creation date range
- `format` - Format code
- `status` - Document status

**Scope**: `system/DocumentReference.rs`, `system/Patient.rs`

**Paging**: Response includes `link` with `relation="next"` when more results available.

See [IHE MHD ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) for transaction details.

### ITI-68: Retrieve Document (Retrieve)

Document Consumer → Document Access Provider

Retrieve document content.

**Endpoint**: `GET [base]/Binary/[id]`

**Scope**: `system/Binary.r`

**Response**: Binary content with `Content-Type` matching DocumentReference.content.attachment.contentType

**Supported Formats** (per priority category):
- `application/fhir+json` (FHIR Bundle - document)
- `application/pdf` (optional, for rendering)
- `text/xml` (CDA, if supported)

See [IHE MHD ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) for transaction details.

## EEHRxF-Specific Constraints

While the MHD transaction mechanics are unchanged, this IG adds constraints on content:

### DocumentReference Profile

Inherits from IHE MHD Comprehensive DocumentReference with additional constraints:
- Priority category-specific type/format value sets
- Required metadata elements for EEHRxF
- Content registry enforcement


### Content Validation

Document Access Providers SHALL:
- Validate DocumentReference.type/format against priority category value sets
- Verify Binary content is valid EEHRxF format
- Enforce required metadata elements

## Authorization

All MHD transactions require authorization via [SMART Backend Services](authorization.html) with appropriate scopes as listed above.

## See Also

- [IHE MHD Specification](https://profiles.ihe.net/ITI/MHD/)
- [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)
- [ITI-67 Find Document References](https://profiles.ihe.net/ITI/MHD/ITI-67.html)
- [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html)
- [Actors and Transactions](actors.html)
