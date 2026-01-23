Member States across the European Union have diverse healthcare system architectures and health information exchange infrastructures. This Implementation Guide is designed to accommodate different architectural approaches while maintaining interoperability.

### Common Architectural Patterns

#### Centralized Repository

Some Member States operate centralized national repositories where health data is stored and accessed:
- EHR systems publish documents/resources to a central registry
- Consumers query the central registry for patient information
- National infrastructure manages authorization and access control

#### Federated Model

Other Member States use federated architectures where data remains at the source:
- EHR systems retain data locally
- Queries are federated across multiple systems
- National infrastructure routes queries to appropriate sources
- Some national infrastructures mimic a virtual national EHR by broadcasting the inbound request to all systems that have records to share for the patient and requested resource (using a record locator service) and aggregates a concatenated response on the fly

### Fitting This Specification to Different Architectures

This IG supports multiple deployment models by defining actors and transactions that can be implemented:

- **At the EHR system level** - Direct implementation of the API
- **At the organizational level** - Hospital or regional aggregation layer
- **At the national level** - National infrastructure exposing the API
- **Via façade** - Adaptation layer in front of existing systems

The specification focuses on the API contract, allowing flexibility in where and how it is implemented within Member State infrastructure.

### Relationship to XDS/XCA

For Member States with existing XDS or XCA infrastructure, see [Relationship to XDS/XCA](xds-xca-bridge.html) for guidance on bridging between document sharing architectures.

> **Note:** Deployment diagrams showing how this specification fits different Member State architectures are planned for a future version.
