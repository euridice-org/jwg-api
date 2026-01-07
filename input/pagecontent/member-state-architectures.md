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

