// Example DocumentReference for European Patient Summary
// Demonstrates use of EEHRxF category and type valuesets
// See: https://github.com/euridice-org/eu-health-data-api/issues/49

Instance: ExampleDocumentReferenceEPS
InstanceOf: EehrxfMhdDocumentReference
Title: "Example - European Patient Summary DocumentReference"
Description: """
Example DocumentReference showing an EPS document with EEHRxF category coding.

This example demonstrates the recommended search strategy:
- `category` = Patient-Summaries (EHDS priority category for coarse filtering)
- `type` = 60591-5 (LOINC code for clinical precision)

**Example query to find this document:**
```
GET [base]/DocumentReference?patient=Patient/example-patient&category=https://euridice.ec.europa.eu/fhir/eehrxf/CodeSystem/eehrxf-document-priority-category-cs|Patient-Summaries
```
"""
Usage: #example

* masterIdentifier.system = "urn:oid:1.2.3.4.5.6.7.8.9"
* masterIdentifier.value = "urn:uuid:7d5bb8ac-68ee-4926-85e7-b8aac8e1f09d"
* status = #current

// Category: EHDS Priority Category (coarse search)
* category = EEHRxFDocumentPriorityCategoryCS#Patient-Summaries "patient summaries"

// Type: LOINC code (clinical precision)
* type = $loinc#60591-5 "Patient summary Document"

// Subject: Reference to patient (required 1..1)
* subject.reference = "http://example.org/fhir/Patient/example-patient"
* subject.display = "Jan Jansen"

// Date: When the document was created (required 1..1)
* date = "2026-01-15T10:30:00+01:00"

// Author: Who created the document
* author.reference = "http://example.org/fhir/Practitioner/example-practitioner"
* author.display = "Dr. Maria Schmidt"

// Custodian: Organization responsible for the document (required 1..1)
* custodian.reference = "http://example.org/fhir/Organization/example-hospital"
* custodian.display = "Amsterdam University Medical Center"

// Description: Human-readable description
* description = "International Patient Summary for Jan Jansen"

// Content: The actual document reference
* content.attachment.contentType = #application/fhir+json
* content.attachment.language = #en
* content.attachment.url = "http://example.org/fhir/Bundle/eps-jan-jansen"
* content.attachment.title = "European Patient Summary"
* content.attachment.creation = "2026-01-15T10:30:00+01:00"
