# Laboratory Report

This priority area covers the exchange of laboratory reports as documents.

## Content Specification

Laboratory reports in this IG follow the [EU Laboratory Report Implementation Guide](https://hl7.eu/fhir/laboratory/).

## Document Type

| Element | Value |
|---------|-------|
| `type` | `http://loinc.org\|11502-2` (Laboratory report) |
| `category` | `urn:oid:1.3.6.1.4.1.19376.1.2.6.1\|REPORTS` |
| `format` | As defined in EU Laboratory IG |

## How to Retrieve Laboratory Reports

Laboratory reports are retrieved using the same pattern as other documents. The retrieval workflow follows the standard sequence:

1. **Authorization** - Obtain access token with `system/DocumentReference.rs system/Binary.r` scopes
2. **Patient Lookup** - Identify the patient using ITI-78 (PDQm)
3. **Document Search** - Search for laboratory reports using ITI-67 with `type=http://loinc.org|11502-2`
4. **Document Retrieval** - Retrieve the document content using ITI-68

### Example Query

```http
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|11502-2&status=current
```

For the complete step-by-step workflow with authorization details and example responses, see [Retrieve a European Patient Summary](example-patient-summary.html). The pattern is identical - only the `type` parameter changes.

## See Also

- [EU Laboratory Report IG](https://hl7.eu/fhir/laboratory/)
- [Document Exchange](document-exchange.html) - Query patterns and search strategy
- [Example: Patient Summary Retrieval](example-patient-summary.html) - Complete workflow example
