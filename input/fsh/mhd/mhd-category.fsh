// =============================================================================
// DocumentReference Category ValueSet (Coarse Search)
// =============================================================================
// Based on IHE XDS ClassCode - used for broad document classification
// This enables "cast a wide net" searches before client-side filtering
// See: https://wiki.ihe.net/index.php/XDS_classCode_Metadata_Coding_System

ValueSet:   EEHRxFDocumentClassVS
Id:         eehrxf-document-class-vs
Title:      "EEHRxF Document Class ValueSet (Category)"
Description: """
Document class codes for coarse-grained document discovery searches.

This ValueSet is based on the IHE XDS ClassCode Metadata Coding System and is used
in DocumentReference.category for broad document filtering. It supports a two-step
search approach:

1. **Request Search**: Use category (this ValueSet) to cast a wide net
2. **Response Filtering**: Use type (LOINC codes) for clinical precision

For example, to find imaging reports:
- Search: `category=REPORTS` combined with `practiceSetting` for radiology
- Filter results client-side using DocumentReference.type

See [IHE XDS ClassCode](https://wiki.ihe.net/index.php/XDS_classCode_Metadata_Coding_System)
for complete definitions.
"""
* ^experimental = false
* $xds-class-code#REPORTS "Reports"
* $xds-class-code#SUMMARIES "Summaries"
* $xds-class-code#IMAGES "Images"
* $xds-class-code#PRESCRIPTIONS "Prescriptions"
* $xds-class-code#DISPENSATIONS "Dispensations"
* $xds-class-code#PLANS "Plans"
* $xds-class-code#HEALTH "Health Certificates"
* $xds-class-code#PATIENT "Patient Expressions"
* $xds-class-code#WORKFLOWS "Workflows"


// =============================================================================
// DocumentReference Type ValueSet (Clinical Precision)
// =============================================================================
// LOINC codes for specific document types - used for precise clinical identification
// This is NOT intended as a primary search parameter, but for client-side filtering

ValueSet:   EEHRxFDocumentTypeVS
Id:         eehrxf-document-type-vs
Title:      "EEHRxF Document Type ValueSet"
Description: """
Document type codes for clinical precision in document identification.

This ValueSet contains LOINC codes for specific document types used in
DocumentReference.type. Unlike category (coarse search), type provides
clinical precision for identifying exact document kinds.

**Usage Pattern**:
- type is primarily used for client-side filtering after a broad category search
- type MAY be used as a search parameter when the specific document type is known
- Multiple type codes may apply to a single document (e.g., a discharge summary
  that is also a patient summary)

**MVP Document Types** (Priority Categories):
- Patient Summary (IPS)
- Discharge Summary (HDR)
- Laboratory Report
- Diagnostic Imaging Report

Note: This list will expand as additional priority categories are implemented.
"""
* ^experimental = false
* insert LOINCCopyrightForVS
* $loinc#60591-5 "Patient summary Document"
* $loinc#18842-5 "Discharge summary"
* $loinc#11502-2 "Laboratory report"
* $loinc#68604-8 "Radiology Diagnostic study note"
* $loinc#18748-4 "Diagnostic imaging study"


