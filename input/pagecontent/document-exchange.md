### Overview

Document exchange using IHE MHD (Mobile Health Documents) transactions. This IG inherits MHD transactions as-is, with constraints specific to EEHRxF content.

### Actors and Transactions

This IG defines three document exchange actors. See [Actors](actors.html) for detailed actor groupings.

| Actor | Transaction | Optionality |
|-------|-------------|-------------|
| [Document Consumer](actors.html#document-consumer) | [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) Find Document References | R |
| [Document Consumer](actors.html#document-consumer) | [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) Retrieve Document | R |
| [Document Access Provider](actors.html#document-access-provider) | [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) Find Document References | R |
| [Document Access Provider](actors.html#document-access-provider) | [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) Retrieve Document | R |
| [Document Access Provider](actors.html#document-access-provider) | [ITI-105: Simplified Publish](https://profiles.ihe.net/ITI/MHD/ITI-105.html) | O |
| [Document Publisher](actors.html#document-publisher) | [ITI-105: Simplified Publish](https://profiles.ihe.net/ITI/MHD/ITI-105.html) | R |

---

### Document Consumption

The primary workflow is **query and retrieve**: Document Consumers find documents via ITI-67, then retrieve content via ITI-68.

#### Sequence Diagram

```mermaid
sequenceDiagram
    participant Consumer as Document Consumer
    participant Provider as Document Access Provider

    rect rgb(240, 248, 255)
    Note over Consumer,Provider: Find Document References (ITI-67)
    Consumer->>Provider: GET /DocumentReference?patient=...&type=...
    Provider-->>Consumer: Bundle of DocumentReferences
    end

    rect rgb(240, 255, 240)
    Note over Consumer,Provider: Retrieve Document (ITI-68)
    Consumer->>Provider: GET [attachment.url from DocumentReference]
    Provider-->>Consumer: Document content (FHIR Bundle or Binary)
    end
```

#### Document Content

ITI-68 retrieves the document from the URL specified in `DocumentReference.content.attachment.url`. The URL format depends on the document type:

| Document Format | attachment.url | Content-Type |
|-----------------|----------------|--------------|
| FHIR Document (Patient Summary, etc.) | `/Bundle/[id]` | `application/fhir+json` or `application/fhir+xml` |
| PDF and other non-FHIR | `/Binary/[id]` | `application/pdf`, etc. |

[ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) retrieves the document directly from the URL. FHIR Documents are returned as Bundle resources when `Accept: application/fhir+json` is specified.

> **Authorization Scope:** The required scope depends on the document format. For non-FHIR documents (PDF), use `system/Binary.read`. For FHIR Documents, use `system/Bundle.read`.

#### Document Search Strategy

This IG follows the [IHE Document Sharing](https://profiles.ihe.net/ITI/HIE-Whitepaper/index.html) approach:

1. **category** (coarse search): Broad classification based on EHDS priority categories
2. **type** (clinical precision): Specific document types, typically LOINC codes

##### Category Values (EHDS Priority Categories)

The EHDS priority categories are defined by [Article 14 of the EHDS Regulation](https://eur-lex.europa.eu/eli/reg/2025/327/oj#d1e2289-1-1). We define codes specifically for EEHRxF that map directly to these regulatory categories. The preference is that DocumentReference.category is populated with these EHDS priority categories, as this allows for consistent querying across different document types that fall under the same category. It is recognized that some documents, especially historic, may not have the EHDS priority category assigned, but may still have a well-defined category code populated. 

See [EEHRxFDocumentPriorityCategoryCS](CodeSystem-eehrxf-document-priority-category-cs.html) for the complete list. These categories are provided as informative codes to guide linkage to clinical codes that are used and would be considered within that priority category. For example, a document with a `type` of `18842-5` (LOINC Hospital Discharge Report) would be considered in the `Discharge-Reports` priority category.

We provide two methods to link between the priority category and clinical codes:

A set of ValueSet [`EEHRxFDocumentTypeVS`](ValueSet-EEHRxFDocumentTypeVS.html) includes all clinical codes (LOINC) that are relevant to EHDS priority categories, with a `useContext` indicating the corresponding priority category.
- `Patient-Summaries` codes are found in [EEHRxFDocumentTypePatientSummaryVS](ValueSet-EEHRxFDocumentTypePatientSummaryVS.html)
- `Discharge-Reports` codes are found in [EEHRxFDocumentTypeDischargeReportVS](ValueSet-EEHRxFDocumentTypeDischargeReportVS.html)
- `Laboratory-Reports` codes are found in [EEHRxFDocumentTypeLaboratoryReportVS](ValueSet-EEHRxFDocumentTypeLaboratoryReportVS.html)
- `Medical-Imaging` codes are found in [EEHRxFDocumentTypeMedicalImagingVS](ValueSet-EEHRxFDocumentTypeMedicalImagingVS.html)

A ConceptMap [EehrxfMhdDocumentReferenceCM](ConceptMap-EehrxfMhdDocumentReferenceCM.html) maps the same set of clinical codes to their corresponding priority category.

The priority category of `Electronic-Prescriptions` and `Electronic-Dispensations` are not considered appropriate use-cases for documents, and thus have no associated document types.

##### Type Values (LOINC)

The `type` element can be the same as the `category` or can be more specific. 
See [EEHRxFDocumentTypeVS](ValueSet-EEHRxFDocumentTypeVS.html) for the example list.

#### Search Examples

The examples below show queries using both `category` and `type` (LOINC document type). 

Searching by EHDS priority category is the preferred approach, as it allows for consistent retrieval of all relevant documents regardless of the specific clinical code used. However, searching by the list of codes mapped to the EHDS priority category may be more robust and productive.

Searching by `type` (LOINC) may be necessary in cases where the EHDS priority category is not populated or when a more specific document type is required.

##### Patient Summary

By type (LOINC):
```
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|60591-5&status=current
```

By category (EHDS priority):
```
GET [base]/DocumentReference?patient=Patient/123&category=http://hl7.eu/fhir/eu-health-data-api/CodeSystem/eehrxf-document-priority-category-cs|Patient-Summaries&status=current
```

By list of codes mapped to EHDS priority category:
```
GET [base]/DocumentReference?patient=Patient/123&category=http://loinc.org|18842-5&type=http://loinc.org|100719-4
```

##### Medical Test Results (Laboratory)

By type (LOINC):
```
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|11502-2&status=current
```

By category (EHDS priority):
```
GET [base]/DocumentReference?patient=Patient/123&category=http://hl7.eu/fhir/eu-health-data-api/CodeSystem/eehrxf-document-priority-category-cs|Laboratory-Reports&status=current
```

##### Imaging Reports and Manifests

By type (LOINC - imaging reports only):
```
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|68604-8&status=current
```

By category (EHDS priority - includes both reports and manifests):
```
GET [base]/DocumentReference?patient=Patient/123&category=http://hl7.eu/fhir/eu-health-data-api/CodeSystem/eehrxf-document-priority-category-cs|Medical-Imaging&status=current
```

> **Note:** The `Medical-Imaging` category includes both imaging reports and imaging manifests. To distinguish between them, use the `type` code or `formatCode`. See [Imaging Manifest](priority-area-imaging-manifest.html) for details.

##### Hospital Discharge Reports

By type (LOINC):
```
GET [base]/DocumentReference?patient=Patient/123&type=http://loinc.org|18842-5&status=current
```

By category (EHDS priority):
```
GET [base]/DocumentReference?patient=Patient/123&category=http://hl7.eu/fhir/eu-health-data-api/CodeSystem/eehrxf-document-priority-category-cs|Discharge-Reports&status=current
```

---

### Document Publication

When Document Publisher and Document Access Provider are **separate systems**, the Publisher submits documents using [ITI-105 Simplified Publish](https://profiles.ihe.net/ITI/MHD/ITI-105.html) per the [MHD Simplified Publish Option](https://profiles.ihe.net/ITI/MHD/1332_actor_options.html#13324-simplified-publish-option). When they are **grouped** (co-located), publication is internal.

#### Document Submission Option

The Document Access Provider MAY support receiving documents from external Publishers by implementing the [MHD Simplified Publish Option](https://profiles.ihe.net/ITI/MHD/1332_actor_options.html#13324-simplified-publish-option). This is the **Document Submission Option**.

Systems implementing this option declare it via [EEHRxF-DocumentAccessProvider-SubmissionOption](CapabilityStatement-EEHRxF-DocumentAccessProvider-SubmissionOption.html). See [Actors - Document Submission Option](actors.html#document-submission-option) for actor groupings.

#### ITI-105 Simplified Publish

```
POST [base]/DocumentReference
Content-Type: application/fhir+json

{
  "resourceType": "DocumentReference",
  "status": "current",
  "type": { ... },
  "subject": { "reference": "Patient/123" },
  "content": [{
    "attachment": {
      "contentType": "application/fhir+json",
      "data": "[base64-encoded document]"
    }
  }]
}
```

The server validates, extracts, and persists the document, returning the created DocumentReference with server-assigned IDs. See [IHE MHD ITI-105](https://profiles.ihe.net/ITI/MHD/ITI-105.html) for details.

> **How ITI-105 handles document content:** Per [MHD ITI-105 Expected Actions](https://profiles.ihe.net/ITI/MHD/ITI-105.html), the Document Recipient extracts the document from `attachment.data` and persists it such that it is retrievable via `attachment.url`. This means consumers querying via ITI-67 receive DocumentReferences with URLs pointing to `/Bundle/[id]` (for FHIR Documents) or `/Binary/[id]` (for PDFs, DICOM), and ITI-68 retrieval returns the native document format—not base64.

#### Other Publication Transactions

This IG specifies ITI-105 as the publication mechanism for Document Publishers submitting to external Access Providers. ITI-105 provides a single publication pattern that handles all EHDS content types (FHIR Documents, legacy PDFs, and DICOM manifests) while keeping publisher implementation simple—the Document Access Provider handles normalization on ingest, ensuring consumers always retrieve native document formats via ITI-67/ITI-68.

Member states or local deployments MAY additionally support:

- **[ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)**: For XDS-centric ecosystems requiring explicit SubmissionSet metadata or multi-document submission.
- **[ITI-106 Generate Metadata](https://profiles.ihe.net/ITI/MHD/ITI-106.html)**: For structured document publishers wanting server-generated DocumentReference.

These are not required for EEHRxF conformance.

---

### References

- [IHE MHD Specification](https://profiles.ihe.net/ITI/MHD/)
- [IHE Document Sharing](https://profiles.ihe.net/ITI/HIE-Whitepaper/index.html)
- [Actors and Transactions](actors.html)
