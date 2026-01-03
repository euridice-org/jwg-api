TODO: Ref Xt-EHR 5.1, caveat text.
# Regulatory Anchors

## EHDS Regulation

TODO 5.1 Diagram with ANNEX II sections.

This Implementation Guide addresses technical requirements from the European Health Data Space (EHDS) regulation, specifically focusing on interoperability requirements placed on EHR systems.

The regulatory basis is found in EHDS ANNEX II ([EUR-Lex](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:52022PC0197) | [Ringholm reference](https://www.ringholm.com/ehds/annex-ii.htm)), which describes obligations for EHR systems to:
- **Provide access to data** formatted in EEHRxF
- **Receive data** formatted in EEHRxF

# Requirements
TODO: Table from 5.1 listing requirements.

## Xt-EHR Joint Action

This IG inherits and builds upon the work of the Xt-EHR Joint Action, which has created deliverables drafting the EHDS requirements. We focus here on providing a technical implementation of these requirements using standards developed by the IHE and HL7 Community.

For more details on the Xt-EHR work, see [Xt-EHR WP5 Deliverables](https://build.fhir.org/ig/Xt-EHR/xt-ehr-common/).
# Patient Rights
TODO: Finish section. How rights are upheld depends on the context, and 
only some rights need interoperability specifications. Others are 
underspecified, like the patient right to insert information into their 
own EHR. 
## Scope of This IG

This IG focuses on **technical implementation** of interoperability requirements. The requirements themselves and how they are applied are not defined in this IG. These are ultimately owned by the European Commission to be defined in the EHDS Implementing Acts.

## Interpretation

The technical interpretation of EHDS requirements used in this IG includes:
- API-based access to EEHRxF data
- Support for multiple priority categories
- Authorization and security mechanisms
- Patient identification capabilities
- Both document-based and resource-based exchange patterns
