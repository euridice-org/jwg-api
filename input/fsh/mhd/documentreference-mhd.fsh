Profile: EehrxfMhdDocumentReference
Parent: https://profiles.ihe.net/ITI/MHD/StructureDefinition/IHE.MHD.Minimal.DocumentReference
Title: "EEHRxF MHD DocumentReference Profile"
Description: """
Profile for DocumentReference resources used in the EEHRxF context, based on the IHE MHD Minimal DocumentReference profile.

**Search Strategy**:
- `category`: Use EEHRxFDocumentClassVS (XDS ClassCode) for coarse document filtering (REPORTS, SUMMARIES, IMAGES, etc.)
- `type`: Use EEHRxFDocumentTypeVS (LOINC) for clinical precision (specific document types)
- `context.practiceSetting`: SHOULD be used to differentiate lab vs imaging reports when category=REPORTS

See [Document Exchange](document-exchange.html) for query examples.
"""
* insert SetFmmAndStatusRule( 1, draft )
* category from EEHRxFDocumentClassVS (preferred)
* type from EEHRxFDocumentTypeVS (preferred)
* context.practiceSetting MS
* context.practiceSetting ^short = "Clinical specialty (e.g., radiology, laboratory) - SHOULD be used for lab vs imaging differentiation"
* subject 1..1
* subject only Reference( http://hl7.eu/fhir/base/StructureDefinition/patient-eu-core )
* date 1..1
* custodian 1..1