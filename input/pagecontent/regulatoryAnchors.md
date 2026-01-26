### EHDS Regulation

This Implementation Guide addresses technical requirements from the European Health Data Space (EHDS) regulation, specifically focusing on the interoperability requirements placed on EHR systems.

The regulatory basis is primarily found in EHDS ANNEX II - Essential Requirements for EHR Systems ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2025/327/oj/eng#anx_II), [Local Copy](ehds-annex-ii.html)), which describes an obligation for EHR systems to include an *Interoperability Component* that does the following:

- §2.1: "SHALL provide an **interface enabling access** to the personal electronic health data [formatted in EEHRxF]"
- §2.2: "SHALL **be able to receive** personal electronic health data [formatted in EEHRxF]"

Note that this IG does NOT create legal obligations on EHR Systems unless adopted by the European Commission.

### Xt-EHR Joint Action

This IG inherits and builds upon the work of the Xt-EHR Joint Action, which has created deliverables drafting the EHDS Implementing Acts. Specifically, we inherit the work done in Xt-EHR Work Package 5.1 which has mapped the EHDS text to more precise EHR requirements.

These requirements have also been adjusted based in order to harmonize against Xt-EHR work package 6 and 7, which define requirements for each priority category.

For more details on the Xt-EHR work, see [the Xt-EHR Website](https://www.xt-ehr.eu/work-packages/). Note: Xt-EHR deliverables are not yet publicly released.

### Requirements Framework

The EHDS regulation defines the interoperability component at a high level, but interoperability needs to be defined with technical precision in order for two systems to effectively achieve interoperability.

This table describes the bridge between the regulation text and precise and implementable specifications.


| **Layer** | **EHDS Regulation** | **EHR Functional Requirements** | **Technical Specifications (You Are Here)** |
|----------|---------------------|--------------------------------|---------------------------------------------|
| **Description** | Law. High-level description of interoperability goals. | EHDS Implementing acts. System roles and capabilities, requirements  on EHR systems to achieve those goals <br/><br/>| Strictly defined interoperability technical rules. Implementable Guide describing use FHIR (or other) specifications. <br/><br/>**Basis of interoperability conformance** |
| **Level of Technical Detail** | low | medium | high |
| **Example** | EHDS Annex § 2.1: The EHR system should provide access to data in the EEHRxF format | **api-access-doc**: The EHR system Interoperability Software Component SHALL offer an API that enables an external system (such as a consumer) to access and retrieve its priority category data, for categories where that data is modeled as a FHIR Document <br/> | The **api-access-doc** requirement is met by the EHR System implementing the IHE MHD ITI-67 and ITI-68 transactions as the Document Responder actor.<br/> *Example FHIR Query: GET [base]/DocumentReference?category=123*  |
| **Owner** | European Commission | European Commission<br/>(drafted by Xt-EHR), Member States | **To be decided** by the European Commission and Member States. SDO's (HL7 EU, IHE Europe) are proposing a draft with this Implementation Guide |
| **Notes** | | Member States have some freedom to define additional requirements here. | |

Legal authority flows from left to right on this diagram. Automated testing of an EHR system is best enabled by the right-most technical specificion layer.

### Scope of This IG

The Xt-EHR Work Packages, notably WP 5.1, has drafted the middle layer: EHR Functional Requirements.

We inherit that work, and this IG focuses on **technical specification layer** of these interoperability requirements, using off the shelf IHE and HL7 standards. The requirements themselves and how they are applied to EHR products are not defined in this IG. These are ultimately owned by the European Commission to be finalized in the EHDS Implementing Acts.

D5.1 defined **26 requirements** across three categories (see Xt-EHR D5.1 Annex for complete list):

- **[In Scope] 15 Interoperability Component Requirements:** This implementation guide primarily focuses on the technical implementation of these requirements.
- **[Out of Scope] 6 Logging Component Requirements:** This Implementation Guide does not specify the logging component format or the interoperability of logs from EHR systems. EHDS ANNEX II requires the generation of local audit logs for review, but does not specify the data format or require interoperability of those logs.
- **[Out of Scope] 5 General requirements:** D5.1 also defines general requirements covering software installation, documentation, performance, and safety of EHR systems. These are not testable API specifications and are therefore out of scope for this IG.

### Interoperability Requirements

Xt-EHR deliverable 5.1 interpreted the EHDS Annex II requirements for EHR systems to "provide access to data" and "receive data" as a **query-based FHIR exchange architecture between systems**. D5.1 initially defined this using a two-actor model: **Producer** (providing access) and **Consumer** (receiving data). In this model, a Provider EHR system offers FHIR API(s) that enable external actors to query and retrieve data, while a Consumer EHR system supports those same FHIR API(s) as a client to receive data.

This Implementation Guide refines the D5.1 actor model by separating the **Producer** role into a **[Document Publisher](actors.html#document-publisher)** (which creates and publishes documents) and a **[Document Access Provider](actors.html#document-access-provider)** (which hosts APIs for document query and retrieval). The Access Provider assumes the server-side responsibilities from the original Producer role.

This adjustment addresses real-world deployment scenarios:

1. **Fit to real-world system architectures**: The system that creates clinical data is not necessarily the system that typically hosts API access to that data, and not all EHR systems are well-fit to serving real-time queries 24/7. For example, an iPad clinician app may produce documents but does not make a good server. Such a system may "make its data available" by publishing documents to a hospital-level Document Access Provider that hosts an API to provide access to Consumers.

2. **Aggregation at hospital scale**: A hospital document management system (Document Access Provider) aggregates data from departmental modules (Document Publishers) to offer a single entry point for clinicians or a single access point for external consumers.

3. **Aggregation at national scale**: In many EU member states, healthcare organization EHRs (Document Publishers) submit documents to a national repository (Document Access Provider), which provides access to data across the region.

See [Actors](actors.html) for complete definitions and [Example Groupings](actors.html#example-groupings) for deployment illustrations.

### Requirements Table

The following table maps each D5.1 interoperability requirement to its implementation in this IG:

| D5.1 Req ID | D5.1 Normative Requirement | EHDS Basis | Actor | IG Section | Technical Spec |
|-------------|----------------------------|------------|-------|------------|----------------|
| `api-provider-general` | The EHR system acting as a provider SHALL provide access to its priority category data by offering an API that complies to the EHDS API specification. | Annex II §2.1 | Provider | [Document Access Provider](actors.html), [Resource Access Provider](actors.html) | This IG |
| `api-consumer-general` | The EHR system Interoperability Software Component acting as a consumer SHALL consume external priority category data via an API conforming to the EHDS API specification. | Annex II §2.2 | Consumer | [Document Consumer](actors.html), [Resource Consumer](actors.html) | This IG |
| `api-provider-authDiscovery` | The EHR system Interoperability Software Component SHALL enable discovery of its authorization server information to enable a consumer to retrieve authorization. It MAY be handled via machine-discoverable metadata or coordinated out of band. | Annex II §1.4, Art. 36(3)(e) | Provider | [Authorization - Discovery](authorization.html#authorization-server-discovery) | SMART .well-known/smart-configuration, IHE IUA |
| `api-provider-authProvideToken` | The EHR system Interoperability Software Component SHALL support issuing authorization tokens to consumer EHR systems using the consumer's registered identity credentials and scopes of access. | Annex II §1.4, Art. 36(3)(e) | Provider (with internal authz server) | [Authorization Server](authorization.html#token-issuance) | SMART Backend token endpoint, IHE IUA |
| `api-consumer-authObtainToken` | The EHR system Interoperability Software Component SHALL obtain an authorization token from the provider's designated authorization server. | Annex II §1.4, Art. 36(3)(e) | Consumer | [Authorization Client](authorization.html#obtaining-tokens) | SMART Backend client credentials grant, IHE IUA |
| `api-provider-authRequireToken` | The EHR system Interoperability Software Component SHALL require a valid authorization token from the Consumer EHR on Interoperability Component exchange. | Annex II §1.4, Art. 36(3)(e) | Provider | [Token Validation](authorization.html#requiring-tokens) | Bearer token validation, IHE IUA |
| `api-consumer-authPresentToken` | The EHR system Interoperability Software Component SHALL present a valid token to the Provider EHR on Interoperability Component Exchange. | Annex II §1.4, Art. 36(3)(e) | Consumer | [Token Usage](authorization.html#presenting-tokens) | Bearer token in Authorization header, IHE IUA |
| `api-provider-patient` | The EHR system Interoperability Software Component SHALL offer a patient lookup API sufficient for a consumer to unambiguously identify the patient electronic health record in the provider system given patient identification data (demographics or other forms of patient identity) as search parameters. | Annex II §2.1 | Provider | [Patient Demographics Supplier](patient-match.html) | PDQm ITI-78 |
| `api-consumer-patient` | The EHR system Interoperability Software Component SHALL support an external patient lookup query API to unambiguously identify the patient electronic health record in an external system (such as a provider EHR system), using the consumer system's available patient identification data (demographics or other forms of patient identity). | Annex II §2.2 | Consumer | [Patient Demographics Consumer](patient-match.html) | PDQm Consumer |
| `api-provider-doc` | The EHR system Interoperability Software Component SHALL offer an API that enables an external system (such as a consumer) to access and retrieve its priority category data modelled as FHIR Documents. | Annex II §2.1 | Provider | [Document Responder](document-exchange.html) | MHD ITI-67, ITI-68 |
| `api-consumer-doc` | The EHR system Interoperability Software Component SHALL support an external document query API that allows it to search and access priority category data modelled as FHIR Documents within an external system (such as a provider). | Annex II §2.2 | Consumer | [Document Consumer](document-exchange.html) | MHD Document Consumer |
| `api-provider-resource` | The EHR system Interoperability Software Component SHALL offer search and read access to its data via individual FHIR Resource API(s), for priority data for which EHDS technical specifications are released which define this data as individually retrievable FHIR resources instead of or in addition to FHIR bundles. | Annex II §2.1 | Provider | [Clinical Data Source](resource-access.html) | IPA Server |
| `api-consumer-resource` | The EHR system Interoperability Software Component SHALL support an external resource query API that allows it to search and access priority category data within an external system (such as a provider), for which EHDS technical specifications are released which define this data as individually retrievable FHIR resources instead of or in addition to FHIR Document bundles. | Annex II §2.2 | Consumer | [Clinical Data Consumer](resource-access.html) | IPA Client |
| `api-provider-data` | The EHR system Interoperability Software Component SHALL be capable of providing priority category data that conforms to the EEHRxF data format, as defined by each priority category. | Annex II §2.1, §2.4 | Provider | Priority Category Content Profiles | HL7 EU Content IGs |
| `api-consumer-data` | The EHR system Interoperability Software Component SHALL be able to receive and handle data for its intended use, when that data is conforming to the EEHRxF data format (as defined by each priority category). | Annex II §2.2 | Consumer | Priority Category Content Profiles | HL7 EU Content IGs |
| `api-encryption` | The EHR system Interoperability Component SHALL be capable of transport-encrypted data exchange | Annex II §1.4, Art. 36(3)(e) | Provider + Consumer | [Transport Security](authorization.html#transport-security) | TLS 1.2+ |
