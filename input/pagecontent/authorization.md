# Authorization

## Overview

Authorization is required for all API transactions. This IG uses SMART Backend Services for system-to-system authorization, grouped with IHE IUA actors.

## Client Registration

Out of band, the Consumer registers identity credentials (public key, client identifier) with the Access Provider.

Future: Consider UDAP for dynamic client registration.

## SMART Backend Services

System-to-system OAuth2 using `client_credentials` grant with JWT client assertion.

**Discovery**: Servers advertise authorization endpoints via `.well-known/smart-configuration` (see [SMART Backend Services Discovery](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html#discovery))

**Token Request**: Client requests token from authorization server's token endpoint (discovered via smart-configuration)
- Grant type: `client_credentials`
- Client assertion: JWT signed by client private key
- Client authentication: Asymmetric (public key registered out-of-band)

## Scopes

Scopes follow SMART v2 conventions and align with required MHD and QEDm transactions:

### Document Producer (MHD ITI-65)
- `system/DocumentReference.c` - Create DocumentReference
- `system/Binary.c` - Create Binary  
- `system/Patient.rs` - Read/search Patient (for patient matching)

### Document Consumer (MHD ITI-67, ITI-68)
- `system/Patient.rs` - Read/search Patient
- `system/DocumentReference.rs` - Read/search DocumentReference
- `system/Binary.r` - Read Binary

### Resource Consumer (QEDm PCC-44)
- `system/Patient.rs` - Read/search Patient
- Additional scopes per resource type: `system/Observation.rs`, `system/Condition.rs`, `system/DiagnosticReport.rs`, etc.

**Note**: Scopes are examples aligned with typical MHD/QEDm interactions. Actual scope enforcement depends on deployment context and authorization server policy.

TODO: Define normative scope requirements per actor and transaction.

## IHE IUA Actor Groupings

- **Document/Resource Producer:** IUA Authorization Client
- **Document/Resource Consumer:** IUA Authorization Client
- **Document/Resource Access Provider:** IUA Authorization Server + Resource Server

## Error Responses

- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - Insufficient scopes

## References

- [SMART Backend Services](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html)
- [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html)
- [IHE ITI-71 Get Access Token](https://profiles.ihe.net/ITI/IUA/index.html#372-get-access-token-iti-71)
