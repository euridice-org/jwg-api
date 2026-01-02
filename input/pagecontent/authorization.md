# Authorization
TODO: Verify. AI-generated.

## Overview

Authorization is required using SMART Backend Services and IUA.

## Client Registration

Out of band, the Consumer registers identity credentials with the access provider.

Future: Consider UDAP.

## SMART Backend Services

System-to-system OAuth2 using client_credentials grant + JWT client assertion.

**Discovery:** `GET /.well-known/smart-configuration`

**Token endpoint:** `POST /token`
- Grant type: `client_credentials`
- Client assertion: JWT signed by client

## Scopes

### Document Producer
- `system/DocumentReference.c` (create)
- `system/Binary.c` (create)
- Optional: `system/DocumentReference.u` (update, for replace/amend)

### Document Consumer
- `system/Patient.rs` (read/search)
- `system/DocumentReference.rs` (read/search)
- `system/Binary.r` (read)

### Resource Consumer
- `system/Patient.rs`
- Additional scopes per resource type: `system/Observation.rs`, `system/Condition.rs`, etc.


## IUA Actor Groupings

- **Document/Resource Producer:** IUA Authorization Client
- **Document/Resource Consumer:** IUA Authorization Client
- **Document/Resource Access Provider:** IUA Authorization Server + Resource Server


## Error Responses

- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - Insufficient scopes

## See Also

- [SMART Backend Services](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html)
- [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html)
- [IHE ITI-71 Get Access Token](https://profiles.ihe.net/ITI/IUA/index.html#372-get-access-token-iti-71)
