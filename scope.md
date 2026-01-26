# Scope

This IG defines **APIs for EHR systems to provide access to EEHRxF data**, as required by EHDS Annex II.

For detailed regulatory basis, see [Regulatory Anchors](https://build.fhir.org/ig/euridice-org/jwg-api/regulatoryAnchors.html).

## What This IG Defines

| Capability | Specification Basis |
|------------|---------------------|
| Authorization | SMART Backend Services + IUA |
| Patient Matching | PDQm (ITI-78) |
| Document Exchange | MHD (ITI-65, ITI-67, ITI-68) |
| Resource Query | IPA / QEDm (PCC-44) |

This includes:
- **Document query and retrieval** (search, read)
- **Document submission** (publish documents to access providers)
- **Resource query** (search, read)

Composite actors:
- **Document Publisher** / **Document Access Provider** / **Document Consumer**
- **Resource Access Provider** / **Resource Consumer**

## Specifications This Is Not:

| Topic | Specification |
|-------|---------------|
| EEHRxF content formats | HL7 Europe Content IGs (Patient Summary, Lab, HDR, Imaging, MPD) |
| Workflow orchestration | IHE workflow profiles (e.g., mPD for prescription/dispense) |
| National infrastructure | Member State specifications (consent services, NCPs, registries) |

## Version 1 Boundaries

This version focuses on **providing access to data**: document query/read, document submission, and resource query/read.

Deferred to future versions:
- Resource registration/push (writing individual resources to EHRs)
- Import/receive transactions (push to EHR)
- Bulk data export
- User-level authorization (EIDAS, EU Wallet)


## Out of Scope

This Implementation Guide does **not**:
- **Define all functionalities or data exchange patterns with EHRs that might or could be used by various  Member States to satisfy the requirements of EHDS:** Each Member State has the power to define its own methods of meeting the EHDS requirements, which could involve accessing data from EHRs using other specifications than those described here. The goal of this guide is not to list every data exchange pattern that might be useful in meeting those requirements, only to define a minimum sufficient and feasible set of APIs that can be used to meet the requirements for certain common architectural patterns of member states, that can be agreed upon as a minimum shared set of requirements.
- **Define data exchange patterns other than EHRs providing access to data and receiving data:** Where there are further workflow actions involved in data exchange (such as for prescribing and dispensing medications), those exchange patterns should be defined in their respective Implementation Guides. Where there are shared needs, such as for authorization and patient search, those IGs should make use of the data exchange patterns defined here.
- **Define data exchange patterns for wellness apps:** While integrations between EHRs and wellness apps can and should use some of the APIs described here (such as authorization, patient search, and resource access), writing data to EHRs can involve workflows other than access to data that have other important considerations, and therefore should be defined separately.
- **Define data exchange patterns other than for EHRs:** There are many pieces of national infrastructure outside of exchange of data with the Interoperability Component of EHRs (for instance, recording and implementing patient opt-outs and restriction of access to data from the national data access services, exchanging data across borders between NCPs, and interacting with services like provider registries and terminology servers) that Member States will need in order to meet the requirements of EHDS. Those are outside the scope of this Implementation Guide, which is focused on requirements for EHRs.
- **Define the content of the documents and resources for EEHRxF:** These are defined in separate Xt-EHR logical models and HL7 Europe Implementation Guides.
- **Create legal obligations on EHR systems:** Unless specified by the European Commission in an Implementing Act of EHDS, this Implementation Guide does not constitute any legal requirement.
- **Define APIs for the logging component of EHRs:** This IG is focused on the interoperability component requirements. The logging component in EHDS Annex II is focused on the generation of local logs for review, and not on the interoperability of those logs.
