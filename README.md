**European Interoperability Specifications for Digital Solutions in Healthcare (EURIDICE)**

An initiative by HL7 Europe and IHE Europe. 

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
1. **Define Exchange Pattern for EEHRxF Data:** Define how existing IHE profiles and other specifications can be used by to ***provide secure access to this data*** and enable the secure exchange of EEHRxF data between systems. 
2. **Satisfy the EHDS Interoperability Requirements:** Define how these technical capabilities satisfy the EHDS Interoperability requirements placed on EHR system in the EHDS Regulation

We define exchange patterns by inheriting and defining transactions, system actors, and associated capability statements. 

## Regulatory Basis

From the regulatory perspective, the initial focus is to provide technical capabilities that satisfy the EHDS Interoperability requirements placed on EHR systems, specifically the obligations described in [EHDS ANNEX II](https://www.ringholm.com/ehds/annex-ii.htm) that require EHR systems to **provide access to data** and **receive data** formatted in EEHRxF.

We focus here on technical implementation of these requirements - The requirements themselves and how they are applied are not defined in this IG. These are ultimately owned by the European Commission to be defined in the EHDS Implementing Acts. We inherit the work of the Xt-EHR Joint Action, which has created deliverables drafting these requirements - and focus here on providing a technical implementation of these requirements using the standards developed by the IHE and HL7 Community.

See [Regulatory Anchors](input/pagecontent/regulatoryAnchors.md) page for more detail on the link to the EHDS regulation requirements, and the technical interpretation of those requirements used here.

## Actors

See [Actors and Transactions](input/pagecontent/actors.md) for a detailed description of the actor model.

TODO: Summary of this page for intro.

[Diagram]

## Functional Requirements

The following pages describe the functional requirements for the API:

- **[Capability Discovery](input/pagecontent/capability-discovery.md)** - How to discover which priority categories a server supports
- **[Authorization](input/pagecontent/authorization.md)** - SMART Backend Services + IUA (required)
- **[Patient Matching](input/pagecontent/patient-matching.md)** - PDQm Patient Demographics Query
- **[Document Exchange](input/pagecontent/document-exchange.md)** - MHD transactions (ITI-65, ITI-67, ITI-68)
- **[Resource Access](input/pagecontent/resource-access.md)** - QEDm resource query (PCC-44)

## Local build

See [`docker.md`](docker.md) for the full publisher workflow: local Docker build, cache options, and CI/branch verification steps.

## CI builds

- Main branch is published continuously at [build.fhir.org/ig/euridice-org/jwg-api/en/](https://build.fhir.org/ig/euridice-org/jwg-api/en/).
- Feature branches appear under [`branches/<branch>/`](https://build.fhir.org/ig/euridice-org/jwg-api/branches/) after the CI job completes (allow for queue time).











## Authors

Josh Priebe, Epic

Bas van den Heuvel, Philips

Giorgio Cangioli, HL7 Europe

dr Kai Heitmann, HL7 Europe

Andreas Klingler, IHE Europe

Janos Vincze, IHE Europe



# Page Structure

The following is the desired page structure (not yet complete).

```ascii
├── Home (landing page)
│   └── Quick description, Goals, Link to Content Profiles, Basic Actor Definitions, Example Story & Sequence
│
├── Introduction / Background - Narrative / explanatory topics.
│   ├── Scope
│   ├── EHDS Regulatory Anchor - Link to EHDS Regulatory Text, which part we handle here, and what it means about scope
│   ├── FHIR Documents and FHIR Resources - Simple explanation of each, where each would be used, ...
│   ├── Relationship to XDS/XCA and FHIR Environments - MHD as a Bridge between XDS/XCA and FHIR environments. Perspective from each.
│   └── Relation to Member State Architectures - Different member state architectures exist across the EU (central repo / federated), the aim is to fit to most. 
│
├── Functional - Volume 1-ish. 
│   ├── Actors and Transactions - High level explainer of actors and transactions
│   ├── Capability Discovery
│   │   ├── FHIR CapabilityStatement
│   │   └── Discovering which priority categories a server supports
│   ├── Authorization
│   │   └── IUA/SMART Backend
│   ├── Patient Match
│   │   └── Demographics Search
│   ├── Document Exchange
│   │   └── Shared DocRef search params
│   └── Resource Access
│       └── FHIR Core Search (IPA/QEDm)
│
├── Implementation - Example use cases.
│   ├── Simple Example: Getting a Patient Summary for a Patient (Auth, patient match, doc lookup, doc retrieval )
│   ├── Accessing EEHRxF Data (health professional access portal)
│   ├── Accessing EEHRxF Data (health data access portal)
│   ├── Accessing EEHRxF Data (cross-border via National Contact Point)
│   └── Additional Use Cases...
│       ├── Base: EHR System IC query and retrieve
│       ├── Hospital-level Aggregation/Facade
│       ├── Export data for system replacement
│       ├── Organization to Organization Exchange (Federated)
│       ├── Organization to Organization Exchange (Central Repository)
│       └── Wellness App Accesses Data
│
├── Artifacts
│   ├── Data Profiles
│   │   ├── EU Core patient
│   │   └── DocumentReference
│   ├── operations (OperationDefinition)
│   │   └── Patient.$match (inherited from PDQm)
│   ├── actorDefinition
│   │   ├── Producer
│   │   └── Consumer
│   └── CapabilityStatements
│
└── About
    ├── Authors and Contributors
    ├── Change Log
    ├── Downloads
    └── Copyright
```




# Misc

- Diagrams are generated with excalidraw. See [Diagrams.md](diagrams/diagrams.md) for more information.


