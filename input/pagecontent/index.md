{% include fsh-link-references.md %}

### Regulatory Basis and Scope

The European Health Data Space (EHDS) regulation describes an obligation for EHR systems to include an Interoperability Component that does the following:
- §2.1: "SHALL provide an **interface enabling access** to the personal electronic health data [formatted in EEHRxF]"
- §2.2: "SHALL **be able to receive** personal electronic health data [formatted in EEHRxF]"

This Implementation Guide:
1. **Defines a set of EHR functionalities that meet the Interoperability Component requirements:** describes how existing IHE profiles and other specifications can be used to provide secure access and enable secure exchange of EEHRxF data between systems.
2. **Shows how these EHR functionalities can be used in real-world data exchange for EHDS use cases:** outlines how these EHR functionalities can be used to provide patients access to their own data, to allow providers access to patient data, and to support the cross-border data exchange in the myHealth@EU network.

See [Regulatory Anchors](regulatoryAnchors.html) page for more detail on the link to the EHDS regulation requirements, and the technical interpretation of those requirements used here.

### Audience

The intended audiences of this Implementation Guide are:

- **Manufacturers of EHR systems:** EHR vendors looking to develop support for APIs that meet the needs of EHDS should refer to the [Functional Requirements](functional.html) for a list of functional specifications EHRs should support.

- **Architects of national infrastructures:** National eHealth agencies looking to understand how to use the capabilities of EHRs required by EHDS to meet the goals of EHDS in their Member States should refer to the [Implementation](implementation.html) for examples of how the EHR APIs can be used for the EHDS use cases.

### Approach

We define exchange patterns by inheriting and defining transactions, system actors, and associated capability statements from existing IHE and HL7 specifications:

- [IHE MHD](https://profiles.ihe.net/ITI/MHD/) - Defines exchange of Documents, which we use to exchange FHIR document content.
- [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html) - Defines authorization and access control actors and mechanisms. We use the actors and transactions model.
- [HL7 SMART Backend Services](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html) - Defines authorization in FHIR. We use the SMART Backend Services profile for system-system authnz, and FHIR scopes.
- [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html) - Defines how a client can perform patient lookup against a server.
- [HL7 International Patient Access](https://build.fhir.org/ig/HL7/fhir-ipa/) - Defines how an application can access FHIR information using SMART authorization and resource access.
- [IHE QEDm](https://profiles.ihe.net/PCC/QEDm/index.html) - Defines how a client can query for existing FHIR resources from a FHIR server.

We define composite actors that inherit and combine actors defined in these existing specifications. See [Actors and Transactions](actors.html) for detailed actor definitions, transactions, and actor grouping.

At a high level, the following actors are specified:

<div style="text-align: center;">
{% include img.html img="actors_overall.png" caption="Figure: Actor Overview" %}
</div>

## Document Exchange Actors

- **Document Producer** - Produces EEHRxF FHIR Documents and publishes to Document Access Providers
- **Document Access Provider** - Provides secure access to EEHRxF FHIR Documents via query API
- **Document Consumer** - Queries and retrieves EEHRxF documents from Document Access Providers

## Resource Exchange Actors

- **Resource Access Provider** - Provides query access to individual FHIR resources
- **Resource Consumer** - Queries FHIR resources from Resource Access Providers

These resource actors are initially scoped for search + read. See [Resource Access](resource-access.html) for detailed discussion and possible approaches for resource exchange patterns.

## Summary of Functional Requirements ("the API")

- **[Capability Discovery](capability-discovery.html)** - Discover which priority categories a server supports
- **[Authorization](authorization.html)** - SMART Backend Services + IUA (required)
- **[Patient Matching](patient-match.html)** - PDQm Patient Demographics Query
- **[Document Exchange](document-exchange.html)** - MHD transactions (ITI-65, ITI-67, ITI-68)
- **[Resource Access](resource-access.html)** - QEDm resource query (PCC-44)

## 6. Authors

Josh Priebe, Epic

Bas van den Heuvel, Philips

Giorgio Cangioli, HL7 Europe

dr Kai Heitmann, HL7 Europe

Andreas Klingler, IHE Europe

Katie Reynolds, Epic

Janos Vincze, IHE Europe
