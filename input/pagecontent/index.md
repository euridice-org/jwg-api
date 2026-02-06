{% include fsh-link-references.md %}
{% include variable-definitions.md %}

<div markdown="1" class="stu-note">

**This IG is under active development.** Feedback and issues are tracked on [GitHub Issues](https://github.com/euridice-org/eu-health-data-api/issues). Please join our [weekly meetings](https://confluence.hl7.org/spaces/HEU/pages/345086021/EU+Health+Data+API+Edition+1) to participate in this development.

</div>

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

### Summary of Functional Requirements ("the API")

- **[Capability Discovery](capability-discovery.html)** - Discover which priority categories a server supports
- **[Authorization](authorization.html)** - SMART Backend Services (IUA actor model)
- **[Patient Matching](patient-match.html)** - PDQm Patient Demographics Query
- **[Document Exchange](document-exchange.html)** - MHD transactions (ITI-67, ITI-68, ITI-105)
- **[Resource Access](resource-access.html)** - IPA resource query patterns

### Approach

We define exchange patterns by inheriting and defining transactions, system actors, and associated capability statements from existing IHE and HL7 specifications:

- [IHE MHD](https://profiles.ihe.net/ITI/MHD/) - Defines exchange of Documents, which we use to exchange FHIR document content.
- [HL7 SMART App Launch - Backend Services](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html) - Defines authorization in FHIR. We use the SMART Backend Services profile for system-system authorization, including the FHIR scopes defined in this specification.
- [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html) - Defines authorization and access control actors and mechanisms. Aligned with SMART. We use the actors and transactions model from this specification.
- [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html) - Defines how a client can perform patient lookup against a server.
- [HL7 International Patient Access (IPA)](https://build.fhir.org/ig/HL7/fhir-ipa/) - Defines how an application can access FHIR information using SMART authorization and resource access. IPA is the primary reference for resource access.
- [IHE QEDm](https://profiles.ihe.net/PCC/QEDm/index.html) - Defines how a client can query for existing FHIR resources from a FHIR server. Referenced where compatible with IPA.

We define composite actors that inherit and combine actors defined in these existing specifications. See [Actors and Transactions](actors.html) for detailed actor definitions, transactions, and actor grouping.

At a high level, the following actors are specified:

<div style="text-align: center;">
{% include img.html img="actors_overall.png" caption="Figure: Actor Overview" %}
</div>

## Document Exchange Actors

- **Document Publisher** - Produces EEHRxF FHIR Documents and publishes to Document Access Providers
- **Document Access Provider** - Serves EEHRxF FHIR Documents via query API. Optionally accepts documents from Document Publisher (Document Submission Option).
- **Document Consumer** - Queries and retrieves EEHRxF documents from Document Access Providers

## Resource Exchange Actors

- **Resource Access Provider** - Provides query access to individual FHIR resources
- **Resource Consumer** - Queries FHIR resources from Resource Access Providers

These resource actors are initially scoped for search + read. See [Resource Access](resource-access.html) for detailed discussion and possible approaches for resource exchange patterns.

## Priority Categories

EHDS defines priority categories of health data for interoperability. Each has a content profile defining the data model, maintained in separate Content IGs.

This API IG defines interoperability *behavior* - the transactions and exchange patterns that systems use to share data. It does not prescribe internal system architecture or design. Systems that choose to comply with EHDS interoperability requirements implement this behavior alongside one or more Content IGs.

| Priority Category | Content IG | Exchange Pattern |
|-------------------|------------|------------------|
| Patient Summary | [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/) | [Document Exchange (MHD)](document-exchange.html) |
| Medical Test Results | [HL7 Europe Laboratory Report](https://hl7.eu/fhir/laboratory) | [Document Exchange (MHD)](document-exchange.html) |
| Hospital Discharge Report | [HL7 Europe Hospital Discharge Report](https://hl7.eu/fhir/hdr/) | [Document Exchange (MHD)](document-exchange.html) |
| Medical Imaging | [HL7 Europe Imaging Study/Report](https://build.fhir.org/ig/hl7-eu/imaging-r5/) / [Imaging Manifest](https://build.fhir.org/ig/hl7-eu/imaging-manifest-r5/) | [Document Exchange (MHD)](document-exchange.html) |
| ePrescription / eDispensation | [HL7 Europe MPD](https://hl7.eu/fhir/mpd) | [IHE MPD](https://profiles.ihe.net/PHARM/MPD/) |

## Authors

{% include contributors.md %}