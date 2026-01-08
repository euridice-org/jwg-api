# Diagnostic Imaging Report

This priority area covers the exchange of diagnostic imaging reports as documents.

## Content Specification

Diagnostic imaging reports in this IG follow the [EU Imaging Report Implementation Guide](https://hl7.eu/fhir/imaging-r4).

## Document Type

| Element | Value |
|---------|-------|
| `type` | `http://loinc.org\|68604-8` (Radiology Diagnostic study note) |
| `category` | `urn:oid:1.3.6.1.4.1.19376.1.2.6.1\|REPORTS` |
| `practiceSetting` | Radiology specialty codes (e.g., SNOMED `394914008`) |
| `format` | As defined in EU Imaging IG |

## How to Retrieve Imaging Reports

Imaging reports are retrieved using the same pattern as other documents. The retrieval workflow follows the standard sequence:

1. **Authorization** - Obtain access token with `system/DocumentReference.rs system/Binary.r` scopes
2. **Patient Lookup** - Identify the patient using ITI-78 (PDQm)
3. **Document Search** - Search for imaging reports using ITI-67 with `type=http://loinc.org|68604-8`
4. **Document Retrieval** - Retrieve the document content using ITI-68

### Example Query

```http
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|68604-8&status=current
```

Alternatively, you can search by category and practiceSetting to find all radiology reports:

```http
GET [base]/DocumentReference?patient=Patient/123&category=urn:oid:1.3.6.1.4.1.19376.1.2.6.1|REPORTS&context.practiceSetting=http://snomed.info/sct|394914008&status=current
```

For the complete step-by-step workflow with authorization details and example responses, see [Retrieve a European Patient Summary](example-patient-summary.html). The pattern is identical - only the search parameters change.

## Imaging Manifests

For retrieval of imaging studies (DICOM images) as opposed to textual reports, see [Document Exchange - Example 5: Find Imaging Manifests](document-exchange.html#example-5-find-imaging-manifests).

> **Open Issue**: The coding approach for imaging manifests is an open issue. See [Open Issues](open-issues.html) for details.

## See Also

- [EU Imaging Report IG](https://hl7.eu/fhir/imaging-r4)
- [Document Exchange](document-exchange.html) - Query patterns and search strategy
- [Example: Patient Summary Retrieval](example-patient-summary.html) - Complete workflow example
