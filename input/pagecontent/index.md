{% include fsh-link-references.md %}

# EU Health Data API

In this repository a **co-branded HL7 Europe / IHE Europe Project** resides which specifies API definitions for accessing and exchanging European Electronic Health Record exchange Format (EEHRxF) (EHDS Article 15) data between systems.

We inherit the following HL7 EU Content Profiles below, which define the format of the data to be exchanged (primarily FHIR Documents constructed of FHIR resources):

* European Patient Summary (  [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/) )
* Europe Medication Prescription and Dispense ([HL7 Europe Medication Prescription and Dispense](https://build.fhir.org/ig/hl7-eu/mpd/))
* Europe Laboratory Report ([HL7 Europe Laboratory Report v0.2.0-ci](https://build.fhir.org/ig/hl7-eu/laboratory/))
* Europe Hospital Discharge Report ([Europe Hospital Discharge Report](https://build.fhir.org/ig/hl7-eu/hdr/))
* Europe Imaging Study Report ([HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/))
* Europe Imaging Study Manifest ([HL7 Europe Imaging Study Manifest R5](https://build.fhir.org/ig/hl7-eu/imaging-manifest/))

The goals of the **EU Health Data API** Implementation Guide are twofold:
1. **Define Exchange Patterns for EEHRxF Data:** Define how existing IHE profiles and other specifications can be used to ***provide secure access to this data*** and enable the secure exchange of EEHRxF data between systems. 
2. **Satisfy the EHDS Interoperability Requirements:** Define how these technical capabilities satisfy the EHDS Interoperability requirements placed on EHR systems in the EHDS Regulation

## Exchange Patterns

We define exchange patterns by inheriting and defining transactions, system actors, and associated capability statements from existing IHE and HL7 specifications. This includes document-based exchange (using IHE MHD) and resource-based query patterns (using IHE QEDm/HL7 IPA). 

## Regulatory Basis

From the regulatory perspective, the initial focus is to provide technical capabilities that satisfy the EHDS Interoperability requirements placed on EHR systems, specifically the obligations described in [EHDS ANNEX II](https://www.ringholm.com/ehds/annex-ii.htm) that require EHR systems to **provide access to data** and **receive data** formatted in EEHRxF.

We focus here on technical implementation of these requirements - The requirements themselves and how they are applied are not defined in this IG. These are ultimately owned by the European Commission to be defined in the EHDS Implementing Acts. We inherit the work of the Xt-EHR Joint Action, which has created deliverables drafting these requirements - and focus here on providing a technical implementation of these requirements using the standards developed by the IHE and HL7 Community.

See [Regulatory Anchors](regulatoryAnchors.html) page for more detail on the link to the EHDS regulation requirements, and the technical interpretation of those requirements used here.

## Actors

This Implementation Guide defines composite actors that inherit from existing IHE and HL7 specifications:

### Document Exchange Actors

- **Document Producer** - Produces EEHRxF FHIR Documents and publishes to Document Access Providers
- **Document Access Provider** - Provides secure access to EEHRxF FHIR Documents via query API
- **Document Consumer** - Queries and retrieves EEHRxF documents from Document Access Providers

### Resource Exchange Actors

- **Resource Access Provider** - Provides query access to individual FHIR resources
- **Resource Consumer** - Queries FHIR resources from Resource Access Providers

### Actor Groupings

These actors can be grouped in various ways to support different deployment models, including:
- Direct EHR system implementation
- Hospital or regional aggregation layers
- National infrastructure façades
- Federated query systems

See [Actors and Transactions](actors.html) for detailed actor definitions, transactions, and grouping requirements.

## Functional Requirements

The following pages describe the functional requirements for the API:

- **[Capability Discovery](capability-discovery.html)** - How to discover which priority categories a server supports
- **[Authorization](authorization.html)** - SMART Backend Services + IUA (required)
- **[Patient Matching](patient-match.html)** - PDQm Patient Demographics Query
- **[Document Exchange](document-exchange.html)** - MHD transactions (ITI-65, ITI-67, ITI-68)
- **[Resource Access](resource-access.html)** - QEDm resource query (PCC-44)

## Authors

Josh Priebe, Epic

Bas van den Heuvel, Philips

Giorgio Cangioli, HL7 Europe

dr Kai Heitmann, HL7 Europe

Andreas Klingler, IHE Europe

Janos Vincze, IHE Europe
