Matching existing HL7 EU IG tab format to avoid rocking the boat. Home / Introduction / Functional / About / Artifacts. 

Page Structure
```
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


Detail:

## Home (landing page)

Content:
- Quick description
- Goals
- Link to Priority Category Content Profiles
- Basic Actor Definitions
- Example Story & Sequence Diagram, base use case
- Audience
- References/Dependencies
  - Prio Category IG's
  - MHD
  - ...

## Introduction / Background 
(discussion/narrative content)

- Scope, in Detail
- EHDS Regulatory Anchors
    - For in-scope items, anchoring to regulatory text
    - Ref 5.1 Functional requirements draft
    - Connect functional requirements
    - For out of scope, mention here
- Resources vs FHIR Documents
    - Simple visual explanation of each
    - Use Cases for Each
    - Differentiate Doc Discovery from Doc Data Model (resource discovery > Doc data model)
- Relationship to XDS/XCA and FHIR Environments
    - MHD as a Bridge between XDS/XCA and FHIR environments
    - To a FHIR server, MHD is an ad-hoc index of that server's FHIR documents. To an XDS Environment, MHD is a FHIR facade to a document registry.
- Relation to Member State Architectures
    - Different member state architectures exist today (central repo / federeated). Here's how the IC defined here could be useful in those architectures
    - Modeled after this IHE MPD page: Actor grouping examples - Medication Prescription and Dispense (MPD) v1.0.0-comment-2
    - Note: Should say something about greenfield sites
- Persistence
    - FHIR Documents can be generated on-demand or as a snapshot
    - Resources are current.



## Functional

Volume1-ish

- Actors and Transactions 
    Define actor model, inherited IHE profiles,  claim required transactions
    Document Exchange
    - Document Producer – auth client, MHD push, patient identity consumer
    - Document Access Provider – auth server, MHD receive/serve, patient identity source
    - Document Consumer – auth client, patient identity consumer, MHD query/retrieve

    Resource Exchange:
    - Resource Access Provider – auth server, patient identity source, QEDm/IPA server  
        (Note: Contrary to the Document Approach, the Resource Access Provider is assumed to itself have access to resources, either through producing that data itself, getting resources from a pushed document, or getting the data via another format. Resource Producer to Resource Access Provider exchange is complex (see IHE MPD) and out of scope here.)
    - Resource Consumer – auth client, patient identity consumer, FHIR search client

    Note: Actor grouping. Doc Producer can be bundled with Doc Access Provider, internalizing its transactions (see IHE Wiki: [IHE Profile Design Principles and Conventions](https://wiki.ihe.net/index.php?title=IHE_Profile_Design_Principles_and_Conventions))


- Capability Discovery
    - FHIR CapabilityStatement
    - Somehow discovering which priority categories a server supports
- Authorization
    - IUA/SMART Backend
- Patient Match
    - Demographics Search
- Document Exchange
  - Shared DocRef search params (across profiles)
- Resource Access
  - FHIR Core Search (IPA/QEDm)

## Implementation

Implementation 
(How-to/ Use Cases)

- Getting a Patient Summary for a Patient (Doc Consumer > Doc AP) 
- Accessing EEHRxF Data to give access to a provider in health professional access portal 
- Accessing EEHRxF Data to give access to a patient in health data access portal
- Accessing EEHRxF Data to give access to a cross-border consumer via National Contact Point /myHealth@EU (others)
- Export data from AP for the purpose of system replacement


- Example Use Cases (Merge with above)
  - Base: An EHR System uses the interoperability component to query and retrieve data from another EHR system
  - Organization to Organization Exchange (Hospital > GP Continuity of Care) - Federated National Infrastructure
  - Organization to Organization (Hospital > GP Continuity of Care) - Central Repository National Infrastructure
  - National Contact Point: Member state national infrastructure responds to a cross-border MyHealth@EU query (through National Contact Points)
  - Patient Access (Health Data Access Service): Member states enable natural persons to access and their data via a health data access service
  - Health Professional Access Service (HPAS): Member states enable health professionals to access patient data via a health professional access service
  - EHR Facade: An EHR system uses a facade system to make its data available via the facade's interoperability component
  - Wellness App: Wellness application accesses data from an EHR-System
  - System Replacement: Transfer data for the purposes of EHR system replacement (Bulk Export/Bulk Import)



## Artifacts

- Data Profiles
  - EU Core patient > Import EU Core
  - DocumentReference > Define shared DocRef (or define in EU Core and inherit)
- operations (OperationDefinintion)
  - Patient.$match > Import $match from FHIR core (derived profile if needed, start)
- actorDefinition (Note: actorDefinition is r5, just narrative for r4)
  - Producer
  - Consumer
- capabilitystatements (producer/consumer per priority category)

## About

- Authors and Contributors
- Change Log
- Downloads
- Copyright













## _________________Old / Homeless

- EHDS EHR System
  - EHR System is broadly defined in the regulation
  - This IG matches this broad definition
  - Individual deployments such as the HPAS will have their own separate deployment needs. The focus here is the shared foundation of the IC
  - EHR systems may only implement a subset of these capabilities

│   └── Persistence
│       ├── FHIR Documents can be generated on-demand or as a snapshot
│       └── Resources are current

  
- Relation to other specifications
    - MHD
    - $match
    - QEDm