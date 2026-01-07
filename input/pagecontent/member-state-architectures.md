# Relation to Member State Architectures

Member States across the European Union have diverse healthcare system architectures and health information exchange infrastructures. This Implementation Guide is designed to accommodate different architectural approaches while maintaining interoperability.

## Common Architectural Patterns

### Centralized Repository

Some Member States operate centralized national repositories where health data is stored and accessed:
- EHR systems publish documents/resources to a central registry
- Consumers query the central registry for patient information
- National infrastructure manages authorization and access control

### Federated Model

Other Member States use federated architectures where data remains at the source:
- EHR systems retain data locally
- Queries are federated across multiple systems
- National infrastructure routes queries to appropriate sources

## Fitting This Specification to Different Architectures

This IG supports multiple deployment models by defining actors and transactions that can be implemented:

- **At the EHR system level** - Direct implementation of the API
- **At the organizational level** - Hospital or regional aggregation layer
- **At the national level** - National infrastructure exposing the API
- **Via façade** - Adaptation layer in front of existing systems

The specification focuses on the API contract, allowing flexibility in where and how it is implemented within Member State infrastructure.

TODO: Add deployment option diagrams showing how the specification fits different MS architectures.

