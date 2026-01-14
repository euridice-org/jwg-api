This priority area covers the exchange of hospital discharge summaries as documents.

### Content Specification

Hospital discharge reports provide clinical summaries at the end of a hospital stay, documenting diagnoses, procedures, treatments, and follow-up care instructions.

> **Note**: The EU Hospital Discharge Report specification is under development by HL7 Europe.

### Document Type

| Element | Value |
|---------|-------|
| `type` | `http://loinc.org\|18842-5` (Discharge summary) |
| `category` | `urn:oid:1.3.6.1.4.1.19376.1.2.6.1\|SUMMARIES` |
| `format` | To be defined |

### How to Retrieve Hospital Discharge Reports

Hospital discharge reports are retrieved using the same pattern as other documents. The retrieval workflow follows the standard sequence:

1. **Authorization** - Obtain access token with `system/DocumentReference.rs` and document retrieval scope (see [Document Exchange](document-exchange.html#fhir-documents-vs-binary))
2. **Patient Lookup** - Identify the patient using ITI-78 (PDQm)
3. **Document Search** - Search for discharge summaries using ITI-67 with `type=http://loinc.org|18842-5`
4. **Document Retrieval** - Retrieve the document content using ITI-68

#### Example Query

```
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|18842-5&status=current
```

For the complete step-by-step workflow with authorization details and example responses, see [Retrieve a European Patient Summary](example-patient-summary.html). The pattern is identical - only the `type` parameter changes.

### See Also

- [Document Exchange](document-exchange.html) - Query patterns and search strategy
- [Example: Patient Summary Retrieval](example-patient-summary.html) - Complete workflow example
