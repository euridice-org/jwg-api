
### Overview

Authorization is required for all API transactions. This IG inherits [SMART Backend Services](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html) from [FHIR SMART App Launch](https://build.fhir.org/ig/HL7/smart-app-launch/app-launch.html) for system-to-system authorization, grouped with IHE IUA actors.

We adopt SMART Backend Services as specified—including token formats, JWT requirements, and authentication methods—to align with globally recognized specifications and reduce implementation burden. As a profile on SMART, all underlying SMART requirements still apply; omitting a detail from this IG does not exempt implementations from SMART requirements.

### Scope: System-to-System Authorization

This specification defines **system-to-system** authorization only:
- Client systems authenticate with client credentials
- No user-level authentication is required at the API level

User-level authorization requirements are not initial scope for this Implementation Guide.

### Sequence Diagram

```mermaid
sequenceDiagram
    participant Client as IUA Authorization Client
    participant AuthZ as IUA Authorization Server
    participant Resource as IUA Resource Server

    Client->>AuthZ: POST /token (client_credentials, signed JWT)
    AuthZ-->>Client: Access Token

    opt Introspect Token
        Resource ->> AuthZ: introspect( JWT )
        AuthZ -->> Resource: JWT contents
    end

    Client->>Resource: GET /Patient?identifier=... (Bearer token)
    Resource-->>Client: Bundle (search results)
```

### IHE IUA Actor Groupings

- **Document/Resource Publisher:** IUA Authorization Client
- **Document/Resource Consumer:** IUA Authorization Client
- **Document/Resource Access Provider:** IUA Authorization Server + Resource Server

### Client Registration

Out of band, the Consumer registers identity credentials (public key, client identifier) with the Access Provider. See [SMART App Launch: Registering a Client](https://hl7.org/fhir/smart-app-launch/client-confidential-asymmetric.html#registering-a-client-communicating-public-keys) for guidance on client registration and public key communication.

### Discovery {#authorization-server-discovery}

Servers SHALL advertise their authorization configuration at `[base]/.well-known/smart-configuration`.

Required fields include:
- `token_endpoint` - URL for token requests
- `token_endpoint_auth_methods_supported` - Must include `private_key_jwt`
- `scopes_supported` - Recommended to list supported scopes

See [SMART Backend Services Discovery](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html#discovery) for the full specification.

### Token Issuance {#token-issuance}

The Authorization Server issues access tokens to registered clients using the `client_credentials` grant.

Servers SHALL:
- Validate the client assertion JWT signature against registered public keys
- Verify the JWT claims (`iss`, `sub`, `aud`, `exp`, `jti`)
- Issue tokens holding scopes based on the requested scopes (if authorized for the client)
- Return tokens with appropriate expiration

### Obtaining Tokens {#obtaining-tokens}

Clients obtain tokens by POSTing to the token endpoint discovered via `.well-known/smart-configuration`.

**Token Request**:
- Grant type: `client_credentials`
- Client assertion: JWT signed by client private key
- Client authentication: Asymmetric (public key registered out-of-band)

### Token Validation {#requiring-tokens}

Servers SHALL validate tokens on every API request:
- Verify token signature
- Check token expiration (`exp` claim)
- Validate audience (`aud` matches server)
- Confirm the requested API operation is within granted scopes

For comprehensive token validation guidance including `jti` tracking and signature verification details, see [SMART App Launch: Signature Verification](https://hl7.org/fhir/smart-app-launch/client-confidential-asymmetric.html#signature-verification).

### Presenting Tokens {#presenting-tokens}

Clients present tokens using the `Authorization` header:

```
Authorization: Bearer <access_token>
```

Tokens must be presented on all API requests to protected resources.

### Scopes

Scopes follow [SMART v2 conventions](https://build.fhir.org/ig/HL7/smart-app-launch/scopes-and-launch-context.html#scopes-for-requesting-fhir-resources) and align with required MHD and IPA transactions:

#### Document Publisher (MHD ITI-105)
- `system/DocumentReference.create` - Create DocumentReference
- `system/Patient.read` - Read Patient (for patient context)
- `system/Patient.search` - Search Patient (for patient matching)

#### Document Consumer (MHD ITI-67, ITI-68)
- `system/Patient.read` - Read Patient
- `system/Patient.search` - Search Patient
- `system/DocumentReference.read` - Read DocumentReference
- `system/DocumentReference.search` - Search DocumentReference
- `system/Binary.read` - Read Binary
- `system/Bundle.read` - Read Bundle (for FHIR Documents)

#### Resource Consumer (IPA)
- `system/Patient.read` - Read Patient
- `system/Patient.search` - Search Patient
- Additional scopes per resource type: `system/Observation.read`, `system/Observation.search`, `system/Condition.read`, `system/Condition.search`, `system/DiagnosticReport.read`, `system/DiagnosticReport.search`, etc.

#### Scope Conventions
- `.read` = read a single resource by ID
- `.search` = search for resources by criteria
- `.create` = create a new resource

### Transport Security {#transport-security}

All API communications SHALL use secure transport as defined by [IHE ATNA Secure Node](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html) with the [TLS 1.2 Floor Option](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html#9.3.1.2).

### Potential Future Work: User-Level Authorization

User-level authorization (including patient-mediated access) is out of scope for this version of the implementation Guide. For patient-mediated access patterns, readers are encouraged to consider [SMART on FHIR App Launch](https://build.fhir.org/ig/HL7/smart-app-launch/) and [International Patient Access](https://build.fhir.org/ig/HL7/fhir-ipa/). Implementors might consider UDAP for dynamic client registration (see [FHIR UDAP Security IG](https://build.fhir.org/ig/HL7/fhir-udap-security-ig/)).

Integration with the EU Digital Identity Wallet and eIDAS framework may be addressed in future editions.

Member States MAY layer user-level authorization on top of system-to-system authorization as appropriate for their national infrastructure.

### References

- [SMART Application Launch](https://build.fhir.org/ig/HL7/smart-app-launch/index.html)
- [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html)
- [IHE ITI-71 Get Access Token](https://profiles.ihe.net/ITI/IUA/index.html#372-get-access-token-iti-71)
