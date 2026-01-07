
Note : Matching existing HL7 EU IG tab format to avoid rocking the boat. Home / Introduction / Functional / About / Artifacts. 
Formatting Note:
Heading 1 > Menus
Heading 2 > Menu Items (Pages)
Heading 3 > Page Sections





Home
Goals

HL7 Europe, IHE-Europe, and the Xt-EHR project have developed FHIR data models for the EHDS priority data categories, which can be adopted by the European Commission as the European Health Record Exchange Format (EEHRxF) in the context of the EHDS regulation. 
For the EHDS to achieve its interoperability goals, defining a data model alone is not sufficient. Specific transactions need to be defined for EHR systems to securely exchange data and prove their ability to exchange data in EHDS Conformance.
The goals of the EHDS API Implementation guide are as follows:

Define exchange patterns for EHDS priority category data: HL7 EU has defined FHIR data models corresponding to the EHDS priority categories. This IG should describe how two system can transact with those data models to safely and securely exchange EHDS data between systems. At a technical level, this means defining capability discovery, patient lookup, document discovery, and resource discovery.
Implement the EHDS EHR Interoperability Component Requirements: The EHDS regulation (specifically, ANNEX II) defines requirements for EHR systems to include an interoperability component to allow access to the EHR system's data and enable the EHR system to consume external data. This specification should satisfy those requirements using the FHIR specification and provide a basis that EHR systems can use to claim compliance to these requirements. 
Describe use for EHDS Data Exchange Use Cases: Show informative examples of how this specification could be used to support certain interoperability needs of the EHDS. Including deployment scenarios of EHR systems, how this could work in different member state architectures, and how the interoperability component could be used within different healthcare domains. The specification, along with others from HL7 EU, should be recommended to the European Commission as the FHIR implementation of the EHDS interoperability component to be referenced in the official Implementing Acts of the EHDS.
Audience

European Commission: Reference for Interop Components Technical Specifics
EHR System Developers: FHIR Implementation guide for EHDS Conformance.
Member States: Support EHDS implementation 
What do we mean by API?

When defining the interface between two systems, multiple aspects play a role. Consider the figure below.

The definition of an interface can be described as consisting of two elements:

The data format that is used to communicate the content. For most interfaces in EHDS, this data format is the European Electronic Health Record exchange Format (EEHRxF) (EHDS Article 15). These specifications are developed by HL7eu and IHEeu:European Patient Summary ( HL7 Europe Patient Summary )
Europe Medication Prescription and Dispense (HL7 Europe Medication Prescription and Dispense)
Europe Laboratory Report (HL7 Europe Laboratory Report v0.2.0-ci)
Europe Hospital Discharge Report (Europe Hospital Discharge Report)
Europe Imaging Study Report (HL7 Europe Imaging Report)
Europe Imaging Study Manifest (HL7 Europe Imaging Study Manifest R5)
The API, composed of transactions that are used for securely exchanging this data between systems. This is the focus of this implementation guide. This is implemented as System-System PULL of both resources and documents, and the transactions in scope are system Oauth2 authorization and authentication, patient lookup, document discovery and retrieval, and resource discovery and retrieval.

Example Story & Sequence Diagram

Patient Story: You arrive for care (at consumer EHR), but your data is in another system (producer EHR). How does the consumer EHR retrieve data from that other EHR system to inform care?
Sequence Diagram (between Consumer and Producer)(out of scope, record location)
Capability DiscoveryGET CapabilityStatement. Link to AS.
Authorization(out of band, client registration)
Provide Token / Get Token
Patient LookupPatient.$match
Document DiscoveryMHD Get Document List (GET DocumentReference), MHD Get Document (GET DocRef/url)
Process Patient Summary Document
Resource DiscoveryGET MedicationRequest
References/DependenciesPrio Category IG's
MHD
...

Introduction
Scope

The EHDS Interoperability component has a diverse set of data exchange needs. To meet EHDS interoperability goals, the interoperability component needs to support different deployments (EHR system API, cross-border API, patient/provider portals access services, wellness API, etc.) and fit within wide diverse member state architectures (XDS/XCA Repositories, Federated FHIR Infrastructures, ...). This implementation guide starts with the shared requirements of the EHR interoperability component (as defined in EHDS ANNEX II). 
The Interoperability component is implemented as a system-system PULL of both documents and individual resources. 
In Scope

Shared EHR Interoperability Component Requirements, clear link to EHDS Regulatory scope (largely ANNEX II). 
System-system PULL of both documents and/or resources.
Generic IHE-style actors of Producer/Consumer.
Technical Components:Capability Discovery (capability statement).
Authorization and Authentication (system-system client credentials minimum)
Patient Match
Document Discovery (Search + Retrieval)
Resource Discovery (Search + Retrieval)
Link to existing priority category data models. From priority category IG's, we expect to inherit:Resource Data models
Document data models
Search params for resource/document discovery
Resource support requirements (which resources are important for each priority category?)
Use of these components within EHDS-defined use casesGeneric Consumer gets data from Producer.
Make Health Data available to NCP for MyHealth@EU Cross-Border Query
Cross-Org Query (Hospital > GP Transition of care)
... (see above)
Out of ScopeEHDS Regulatory Requirements scoped to actors other than EHR: health professional access services, health data access services, organizations, national contact points, or member states.Note: Many of these requirements and services are supported by systems classed as EHR systems by the regulation, and therefore systems that will contain an interoperability component.  
Example: We envision HPAS as a provider portal, that system is likely also be classified an EHR system, and will use the interoperability component to meet a subset of its requirements (act as EHR consumer to access EHR Producer's data and show to provider)
Thus, the EHR Interop Component (and this API implementation guide) supports these deployments, but does not inherit all of their requirements. They will likely require their own sets of additional requirements.
Network-level exchange. Deployment environments vary drastically across the EU. The aim is to fit into different possible member state architectures as much as we can.Note: We expect national infrastructure to handle record location (e.g. consumer and a producer) E.g. national record location.
An infrastructure to exchange data between EU member states; The API which is used to communicate electronic health data under the EHDS between EU member states is in the responsibility of MyHealth@EU and not in the scope of this project.
Priority Category specific components (Data models, transaction patterns, search parameters, etc) are not in the scope of this IG, but are within the scope of the HL7 EU priority category Implementation Guides. 
Decisions about which EHR systems should support which pieces. Xt-EHR/regulatory scope. I see our role as providing a "menu" of IC capabilities that fit into FHIR. 
Generic PUSH TransactionsWorkflow push: Priority category specific workflow/event push (ex: send dispense). Not in scope at the API level, but priority categories MAY add these to meet workflow goals.
Document Archive Push (MHD 109) > Not in base EHDS EHR scope, but some member states will want it. Worth standardizing.
Log interoperability (EHDS doesn't require interoperability of logs, but potentially worth standardizing)
Log Aggregation/correlation via ATNA. Not clearly in regulatory scope for all EHR systems.
Resource versioning
Document versioning
Potentially in scope:

Standardize Logging Component Format - standardize format of local logs, or how they interact with data release via API. EHDS requires local logs, but not the log format. Worth standardizing, if time.
User level / patient level authorization. Some deployments will want this, and it's worth standardizing.
EHDS Regulatory Basis 

For in-scope items, anchoring to regulatory text.Ref 5.1 Functional requirements draft. 
For out of scope, mention here. 
The EHDS EHR System

EHR System is broadly defined in the regulation. These EHR systems are deployed in a wide variety of interoperability domains - exchange within a healthcare organization, exchange between healthcare organizations, cross-border exchange, national infrastructure
This implementation guide focuses on the shared interoperability needs of all 
Individual deployments such as the HPAS will have their own separate deployment needs. The focus here is the shared foundation of the IC.
EHR systems may only implement a subset of these capabilities. 
Relation to other specifications (include?)MHD
$match
QEDm


Functional

Actors - ActorDefinitionProducer: Holder of priority category data; offers EHDS API endpoints as a server to enable access to this data.  
Consumer: Consumer of priority category data. Supports EHDS API as a client to consume this data.
(Bonus: Priority Category. E.g. I am a LAB RESULT PRODUCER)
Authorization: System-system Oauth2 client credentials. SMART backend (alternatively, IHE IUA - though this has legacy baggage)Note: The auth server could be external to the EHR (hospital scale auth server like Okla, or national scale).
There's a requirement for the EHR (resource server) to identify it's authorization server. SMART makes this machine discoverable via .well-known, but I've gotten feedback it should probably be out of band like producer discovery (overkill, resource server isn't really the canonical source, could be multiples). I'm not yet sure about this.
I'm not yet convinced that we need any EHDS adjustments to SMART scopes. Maybe Purpose of Use, but even that - break the glass thing is scoped to access services not EHR's
Capability Discovery: (FHIR CapabilityStatement)Links to different options (Prio categories, specific API's, etc)
Patient Lookup: Patient.$match (alternatively, IHE PDQm ITI-119 is the IHE version) Patient.$match is the safest way to get a high confidence match, but some simpler implementations will want naive Patient.search. We generally argue patient.search is not safe for clinical use cases.
There will probably be a lot of questions about national specific search parameters, Lots of divergence today in national+ scale integrations. I tend to think the API level should be a generic superset, and national profiles will pick the parameters that they want.
I hear your point about demographics lookup not being required for all EHR's. Still working through how to accomplish that without lowering the safety bar for everyone.
Document Discovery/Retrieval: IHE MHD ITI-67/ITI-68.We'll need to do some harmonization of search parameters across the IG's, but my confluence on doc/resource discovery from earlier gets most of the way there for the important pieces I believe. 
I think we should keep this thin, and free from too many priority category-specific search parameters. The instinct will be to overload the DocumentReference profile with all the possible search parameters useful for any priority category.In my opinion, we should meet the prio category specific search params need via (1) client-side filtering and (2) pushing the complex searches to resource discovery. There are much better semantics for e.g. "give me this specific blood glucose result" in DiagnosticReport compared to DocumentReference.
Resource Discovery/Retrieval: core FHIR search + EU Core / Priority Category IG Resource specific search params.I'm not yet sure how this fits in with the other IG's, or how you could specify the generic resource lookup without getting resource-specific. IHE QEDm is an option, I think it has most of the resource coverage we need and adds IHE actors. I don't like how it seems to assume your resources are coming from documents and not from a native FHIR server, but that's just a subset.
You could also just specify some search expectations in EU core, or within each priority category IG. FHIR Core search is the main thing that's shared beyond just the resource concept. I could see all this fitting within EU core.
This is roughly the core resources I think we need, but I am sure all the owners will have thoughts. Patient SummaryCondition
AllergyIntolerance
Immunization
ePrescriptions/eDispensationsMedicationRequest
MedicationDispense
Medication
Test ResultsDiagnosticReport
Medical ImagingDiagnosticReport
ImagingStudy
Observation?
Hospital Discharge ReportEncounter
I see these as two levels of resource lookupPrimary Resources - using resource lookup to discover core priority category dataDiagnosticReport>$document
Encounter>HDR (somehow, probably need adjusted $document on Encounter, though not sure of multiple-HDR-one-encounter breaks this)
Secondary Resources - component resources contained within priority categories that would be useful to transact with individually.Thinking of IPS, how can you just get Immunizations or allergies? Location, Medication. 
At the limit this is just all contained resources, but usefulness varies greatly and people are scope-sensitive.


Implementation

Resources vs FHIR Documents Simple visual explanation of each. FHIR Docs contain FHIR resources. 
Use Cases for Each (Cross-Border doc exchange, modern resource exchange)
Differentiate Doc Discovery from Doc Data Model (resource discovery > Doc data model)
MHD as a Bridge between XDS/XCA and FHIR environments
Document PersistenceFHIR Documents can be generated on-demand, or earlier in workflow. They represent a snapshot of data
Resources are current 
Example Use CasesBase: An EHR System uses the interoperability component to query and retrieve data from another EHR system 
Organization to Organization Exchange (Hospital > GP Continuity of Care) - Federated National Infrastructure
Organization to Organization (Hospital > GP Continuity of Care) - Central Repository National Infrastructure
National Contact Point: Member state national infrastructure responds to a cross-border MyHealth@EU query (through National Contact Points)
Patient Access (Health Data Access Service): Member states enable natural persons to access and their data via a health data access service. 
Health Professional Access Service (HPAS): Member states enable health professionals to access patient data via a health professional access service
EHR Facade: An EHR system uses a facade system to make its data available via the facade's interoperability component. 
Wellness App: Wellness application accesses data from an EHR-System
System Replacement: Transfer data for the purposes of EHR system replacement (Bulk Export/Bulk Import)
Relation to Member State Architectures
Member State ArchitecturesDifferent member state architectures exist today (central repo / redereated). Here's how the IC defined here could be useful in those architectures.
Modeled after this IHE MPD page: Actor grouping examples - Medication Prescription and Dispense (MPD) v1.0.0-comment-2
Note: Should say something about greenfield sites


Artifacts:

Data Profiles EU Core patient > Ref EU Core
DocumentReference > Define shared DoRef (or define in EU Core and inherit)
operations (OperationDefinintion)Patient.$match > Import $match from FHIR core (derived profile if needed)
actorDefinition (Note: actorDefinition is r5, just narrative for r4)Producer
Consumer
capabilitystatements (producer/consumer per package)


About

Authors and Contributors
Change Log
Downloads
Copyright

Open Questions

Do we need to require DocRef, and the FHIR Documents are persistent? I don't think so



