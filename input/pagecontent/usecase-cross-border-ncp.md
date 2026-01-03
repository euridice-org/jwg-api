# Use Case: Cross-Border Exchange via National Contact Point

## Overview

Health information is exchanged across borders through National Contact Points (NCPs) using MyHealth@EU infrastructure.

## Scenario

Stefan, a German citizen, experiences a medical emergency while on vacation in Spain. The Spanish hospital needs to access his health records from Germany to inform emergency treatment.

## Actor Roles

- Spanish hospital system acts as [Document Consumer](actors.html#document-consumer)
- German EHR system acts as [Document Access Provider](actors.html#document-access-provider)
- National Contact Points facilitate cross-border exchange

## Cross-Border Flow

1. Spanish hospital identifies Stefan and obtains consent for cross-border data access
2. Spanish NCP sends query to German NCP via MyHealth@EU
3. German NCP routes query through national infrastructure
4. German EHR system provides data via the API defined in this IG
5. Information flows back through NCPs to Spanish hospital

## Technical Architecture

```
Spanish Hospital → Spanish NCP → MyHealth@EU → German NCP → National Infrastructure → EHR System API
```

## Role of This Specification

This IG defines the rightmost component: the API between national infrastructure and EHR systems.

- **Cross-Border API** (MyHealth@EU): Defined by eHMSEG, not by this IG
- **National Infrastructure API**: Defined by Member States
- **EHR System API**: Defined by this IG ← **You are here**

All layers exchange EEHRxF-formatted data to ensure semantic interoperability.

## Authorization Context

- Patient consent for cross-border access
- Healthcare professional authentication in requesting country
- Authorization decisions at multiple levels (NCP, national infrastructure, EHR system)

TODO: Add detailed architecture diagram showing all layers and data flow.
