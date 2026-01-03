# Use Case: Cross-Border Exchange via National Contact Point

## Overview

Health information is exchanged across borders through National Contact Points (NCPs) using MyHealth@EU infrastructure.

## Scenario

A patient from Country A (home country) experiences a medical emergency while traveling in Country B. The healthcare facility in Country B needs to access the patient's health records from Country A to inform emergency treatment.

## Actor Roles

- Country B healthcare facility acts as [Document Consumer](actors.html#document-consumer)
- Country A EHR system acts as [Document Access Provider](actors.html#document-access-provider)
- National Contact Points (NCP-A and NCP-B) facilitate cross-border exchange

## Cross-Border Flow

1. Country B healthcare facility identifies the patient and obtains consent for cross-border data access
2. NCP-B sends query to NCP-A via MyHealth@EU infrastructure
3. NCP-A routes query through Country A's national infrastructure
4. Country A EHR system provides data via the API defined in this IG
5. Information flows back through NCP-A and NCP-B to the Country B healthcare facility

## Technical Architecture

```
Country B Healthcare Facility → NCP-B → MyHealth@EU → NCP-A → National Infrastructure → EHR System API
```

## Role of This Specification

This IG defines the rightmost component: the API between national infrastructure and EHR systems.

- **Cross-Border API** (MyHealth@EU): Defined by the [MyHealth@EU NCPeH API](https://build-fhir.ehdsi.eu/ncp-api/) specification, not by this IG. This is an operational service today, and implementations commonly use [OpenNCP](https://www.openncp.org/) software for NCP functionality.
- **National Infrastructure API**: Defined by Member States
- **EHR System API**: Defined by this IG ← **You are here**

All layers exchange EEHRxF-formatted data to ensure semantic interoperability.

## Authorization Context

- Patient consent for cross-border access
- Healthcare professional authentication in requesting country
- Authorization decisions at multiple levels (NCP, national infrastructure, EHR system)

TODO: Add detailed architecture diagram showing all layers and data flow.
