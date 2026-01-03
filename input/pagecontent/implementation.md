# Implementation

This section provides concrete examples and use cases showing how the functional requirements defined in this IG are applied in practice.

## Deployment Context

The EU Health Data API can be implemented in various deployment models to fit different Member State architectures and organizational structures.

### Common Deployment Models

**Direct EHR Implementation**: The EHR system directly implements the API specifications.

**Organizational Façade**: A hospital or healthcare organization deploys an aggregation layer implementing the API in front of one or more EHR systems.

**Regional/National Hub**: Regional or national infrastructure implements the API, federating queries to underlying EHR systems or serving from a centralized repository.

**Registry Pattern**: A registry system implements the API and provides standardized interfaces for EHR systems to publish and retrieve information.

See [Member State Architectures](member-state-architectures.html) for more details on how this specification accommodates different architectural patterns.

## Use Case Examples

The following pages provide examples of common use cases:

### [Retrieve a European Patient Summary](example-patient-summary.html)

A step-by-step walkthrough showing the complete flow: authorization → patient identification → document query → document retrieval. Demonstrates the most common pattern using the [Document Consumer](actors.html#document-consumer) and [Document Access Provider](actors.html#document-access-provider) actors.

### [Health Professional Portal](usecase-health-professional-portal.html)

Healthcare providers accessing EEHRxF data through a professional portal. Shows how clinicians can query and retrieve patient information from other organizations.

### [Health Data Portal](usecase-health-data-portal.html)

Patients accessing their own health data through a health data access service. Demonstrates patient-facing access patterns.

### [Cross-Border Exchange via NCP](usecase-cross-border-ncp.html)

Health information exchange across borders through National Contact Points and MyHealth@EU infrastructure. Shows how this API specification fits within the broader EHDS ecosystem.

## Actor Usage

All use cases leverage the composite actors defined in [Actors and Transactions](actors.html):
- [Document Producer](actors.html#document-producer)
- [Document Access Provider](actors.html#document-access-provider)
- [Document Consumer](actors.html#document-consumer)
- [Resource Access Provider](actors.html#resource-access-provider)
- [Resource Consumer](actors.html#resource-consumer)
