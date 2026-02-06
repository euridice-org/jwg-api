# EU Health Data API

**European Interoperability Specifications for Digital Solutions in Healthcare (EURIDICE)**

An initiative by HL7 Europe and IHE Europe.

This specification is discussed weekly. We welcome your collaboration via [issues](https://github.com/euridice-org/eu-health-data-api/issues) and pull requests, or by joining our [weekly meetings](https://confluence.hl7.org/spaces/HEU/pages/345086021/EU+Health+Data+API+Edition+1).

## Build

| Branch | URL |
|--------|-----|
| **Main** | https://build.fhir.org/ig/euridice-org/eu-health-data-api/ |
| **Feature branches** | https://build.fhir.org/ig/euridice-org/eu-health-data-api/branches/ |

---

## Overview

This **co-branded HL7 Europe / IHE Europe Project** specifies API definitions for accessing and exchanging European Electronic Health Record exchange Format (EEHRxF) data between systems, as required by EHDS Article 15.

### Goals

1. **Define Exchange Patterns for EEHRxF Data:** How existing IHE profiles and other specifications can be used to provide secure access and enable secure exchange of EEHRxF data between systems.
2. **Satisfy EHDS Interoperability Requirements:** How these technical capabilities satisfy the EHDS requirements placed on EHR systems.

### Content Profiles (EEHRxF Data Formats)

We inherit the following HL7 EU Content Profiles which define the format of the data to be exchanged:

| Priority Category | Content Profile |
|-------------------|-----------------|
| European Patient Summary | [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/) |
| Medication Prescription & Dispense | [HL7 Europe MPD](https://build.fhir.org/ig/hl7-eu/mpd/) |
| Laboratory Report | [HL7 Europe Laboratory Report](https://build.fhir.org/ig/hl7-eu/laboratory/) |
| Hospital Discharge Report | [HL7 Europe HDR](https://build.fhir.org/ig/hl7-eu/hdr/) |
| Imaging Study Report | [HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/) |
| Imaging Study Manifest | [HL7 Europe Imaging Manifest](https://build.fhir.org/ig/hl7-eu/imaging-manifest/) |

### Regulatory Basis

From the regulatory perspective, the initial focus is to provide technical capabilities that satisfy the EHDS Interoperability requirements placed on EHR systems, specifically the obligations described in [EHDS ANNEX II](https://www.ringholm.com/ehds/annex-ii.htm) that require EHR systems to **provide access to data** and **receive data** formatted in EEHRxF.

See [Regulatory Anchors](https://build.fhir.org/ig/euridice-org/eu-health-data-api/regulatoryAnchors.html) for detail on the link to EHDS requirements.

---

## Approach

| Decision | Approach |
|----------|----------|
| **Actor model** | 5 actors (Document Publisher, Document Access Provider, Document Consumer, Resource Access Provider, Resource Consumer) with 3 composite groupings |
| **Authorization** | SMART Backend Services for system-to-system auth, with IHE IUA actor definitions |
| **Resource access** | IPA (International Patient Access) as primary reference; QEDm referenced where compatible |
| **Exchange Only** | This IG defines transport and exchange patterns only; clinical data models are maintained in separate Content IGs from HL7 EU|

## Page Structure

```
├── Home
│
├── Background
│   ├── Regulatory Anchors
│   │   └── EHDS Annex II - Essential Requirements
│   ├── Actors and Transactions
│   ├── Priority Categories
│   ├── Member State Architectures
│   ├── Change Log
│   └── Open Issues
│
├── Functional Requirements
│   ├── Capability Discovery
│   ├── Authorization
│   ├── Patient Matching
│   ├── Document Exchange
│   └── Resource Access
│
├── Implementation
│   ├── Retrieve a European Patient Summary
│   ├── Health Professional Access Service
│   ├── Health Data Access Service
│   └── Cross-Border via NCP
│
├── Artifacts
│
└── About
    ├── Authors and Contributors
    ├── Copyright
    └── References
```

### Additional Pages (linked but not in navigation)

- **Resource Exchange Patterns** - Discussion of resource production approaches
- **FHIR Documents vs Resources** - When to use document vs resource exchange
- **XDS/XCA Bridge** - Guidance for Member States with existing XDS/XCA infrastructure

---

## Local Build

See [`build-notes.md`](build-notes.md) for the full publisher workflow, including platform-specific setup for Mac and Windows.

Quick start:
```bash
./startDockerPublisher.sh
```

---

## Authors

- Josh Priebe, Epic
- Bas van den Heuvel, Philips
- Giorgio Cangioli, HL7 Europe
- dr Kai Heitmann, HL7 Europe
- Andreas Klingler, IHE Europe
- Katie Reynolds, Epic
- Janos Vincze, IHE Europe

---

## Misc

- Diagrams are generated with excalidraw. See [Diagrams.md](diagrams/diagrams.md) for more information.
