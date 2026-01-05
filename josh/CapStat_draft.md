# CapabilityStatement Draft Specifications

Date: 2025-12-30
Purpose: Define what needs to be in each of the 5 CapabilityStatements for the restructured IG

Based on: plan.md, claudediff.md, todo.md

---

## Overview: 5 Actors / 5 CapabilityStatements

**Document Exchange:**
1. Document Producer (client) - based on [IHE MHD Document Source](https://profiles.ihe.net/ITI/MHD/). Grouped with
2. Document Access Provider (server) - based on [IHE MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/) + [Document Responder](https://profiles.ihe.net/ITI/MHD/)
3. Document Consumer (client) - based on [IHE MHD Document Consumer](https://profiles.ihe.net/ITI/MHD/)

**Resource Exchange:**
4. Resource Access Provider (server) - based on [IHE QEDm Clinical Data Source](https://profiles.ihe.net/PCC/QEDm/)
5. Resource Consumer (client) - based on [IHE QEDm Clinical Data Consumer](https://profiles.ihe.net/PCC/QEDm/)
Note: The Resource Producer actor, and it's interactions with the Resource Access Provider are not in scope here. These interactions are complex. It is assumed the system acting as a Resource Access Provider has access to resources, either by (1) generating it's own resource internally, effectively grouped with an implied Resource Producer actor (2) Extracting resources from documents received when acting as a MHD Document Responder (part of the Document Access Provider actor) or (3) Receiving this data via another data transfer method and translating it to FHIR resources. 

### Key IHE Transactions Referenced
- **[ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)** - Document publication (Producer → Access Provider)
- **[ITI-67 Find Document References](https://profiles.ihe.net/ITI/MHD/ITI-67.html)** - Document search (Consumer → Access Provider)
- **[ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html)** - Document content retrieval (Consumer → Access Provider)
- **[ITI-78 Mobile Patient Demographics Query](https://profiles.ihe.net/ITI/PDQm/ITI-78.html)** - Patient identity resolution (PDQm)
- **[PCC-44 Mobile Query Existing Data](https://profiles.ihe.net/PCC/QEDm/PCC-44.html)** - Fine-grained resource queries (QEDm)
- **IUA** - Internet User Authorization. Inherit actors.
  https://profiles.ihe.net/ITI/IUA/index.html#371-get-access-token-iti-71
  https://profiles.ihe.net/ITI/IUA/index.html#372-incorporate-access-token-iti-72
- SMART Backend - 
---

## 1. Document Producer (cs-document-producer.fsh)

**Actor Type**: Client
**Role**: Publishes documents to an Access Provider using [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)
**Based on**: [IHE MHD Document Source Actor](https://profiles.ihe.net/ITI/MHD/1332_actors_and_transactions.html#133211-document-source)

### CapabilityStatement Properties
```
* name = "DocumentProducer"
* title = "Document Producer"
* status = #active
* date = "2025-12-30"
* kind = #requirements
* fhirVersion = #4.0.1
* format = #json (SHALL), #xml (SHOULD)
* rest.mode = #client
```

### Security (REQUIRED)
```
* rest.security.extension (SMART Backend Services)
  * description: "SHALL support SMART Backend Services authorization"
  * oauth uris:
    - discovery: /.well-known/smart-configuration
    - token endpoint: POST /token
  * auth flow: client_credentials grant with JWT assertion

* Requested Scopes (token-level gate):
  - system/DocumentReference.c (SHALL)
  - system/Binary.c (SHALL)
  - system/DocumentReference.u (SHOULD - only if replace/amend supported)

* Explicitly NO wildcards:
  - NO system/*.*
  - NO system/*.cruds
```

### Expected Interactions (API surface-area gate)

**DocumentReference**
```
* rest.resource[0]
  * type = #DocumentReference
  * profile = "http://hl7.eu/fhir/euridice-api/StructureDefinition/exchange-documentreference"
  * interaction[0].code = #create
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #update (OPTIONAL - only for replace/amend)
    * extension (capabilitystatement-expectation) = #MAY

  * documentation: "Producer creates DocumentReference resources that conform to exchange envelope requirements"

  * Envelope Invariants (enforced by profile):
    - subject references valid Patient id on Access Provider
    - attachment.contentType in allowlist
    - type bound to allowed ValueSet (content registry)
    - format bound to allowed ValueSet (content registry)
    - author present (or Provenance required)
    - custodian present (define model: producer org vs AP org)
```

**Binary**
```
* rest.resource[1]
  * type = #Binary
  * interaction[0].code = #create
    * extension (capabilitystatement-expectation) = #SHALL

  * documentation: "Producer creates Binary resources containing document content"
```

**Bundle (OPTIONAL - for [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html))**
```
* rest.resource[2]
  * type = #Bundle
  * profile = "http://hl7.eu/fhir/euridice-api/StructureDefinition/exchange-provide-bundle"
    * (derived from IHE MHD Comprehensive Provide Document Bundle)
  * interaction[0].code = #transaction
    * extension (capabilitystatement-expectation) = #MAY

  * documentation: "Producer MAY use transaction bundle for atomic publication per [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)"
```

### Required Groupings
```
* implementationGuide references:
  - IHE.ITI.MHD (for DocumentReference profile parent)
  - SMART Backend Services (for auth)

* Grouped with:
  - Patient Identity Consumer (PDQm) - if producer needs to resolve patient IDs
  - OAuth2 Client (SMART Backend Services)
```

### Explicitly OUT OF SCOPE (Note: reconsider even stating these)
- NO Patient read/search (cannot query patients)
- NO DocumentReference search (cannot search documents)
- NO other resource creates (no Observation, Condition, etc.)
- Producer is PUBLISH-ONLY

---

## 2. Document Access Provider (cs-document-access-provider.fsh)

**Actor Type**: Server
**Role**: Receives documents via [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html), serves document queries via [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) and [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html), provides patient identity and authorization
**Based on**: [IHE MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/1332_actors_and_transactions.html#133212-document-recipient) + [Document Responder](https://profiles.ihe.net/ITI/MHD/1332_actors_and_transactions.html#133213-document-responder)

### CapabilityStatement Properties
```
* name = "DocumentAccessProvider"
* title = "Document Access Provider"
* status = #active
* date = "2025-12-30"
* kind = #requirements
* fhirVersion = #4.0.1
* format = #json (SHALL), #xml (SHOULD)
* rest.mode = #server
```

### Security (REQUIRED)
```
* rest.security
  * description: "SHALL enforce authorization. SHALL support SMART Backend Services. SHALL advertise discovery endpoint."

  * bearer token: REQUIRED
  * smart well-known: /.well-known/smart-configuration (SHALL advertise)

  * Error handling:
    - 401 Unauthorized: no token or invalid token
    - 403 Forbidden: valid token but insufficient scope
    - Pick one normatively and document consistently

  * Supported authorization:
    - SMART Backend Services (client_credentials + JWT) - SHALL
    - IHE IUA - MAY
```

### Resources and Interactions

**Patient (Identity Source - [ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html))**
```
* rest.resource[0]
  * type = #Patient
  * interaction[0].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #read
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "identifier"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Search by patient identifier per [ITI-78 Mobile Patient Demographics Query](https://profiles.ihe.net/ITI/PDQm/ITI-78.html)"

  * operation (OPTIONAL)
    * name = "$match"
    * definition = "http://hl7.org/fhir/OperationDefinition/Patient-match"
    * extension (capabilitystatement-expectation) = #MAY
    * documentation: "PDQm $match operation for demographics-based patient matching (ITI-78)"
```

**DocumentReference (MHD Document Responder - [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) + [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html))**
```
* rest.resource[1]
  * type = #DocumentReference
  * profile = "http://hl7.eu/fhir/euridice-api/StructureDefinition/exchange-documentreference"

  * interaction[0].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Per [ITI-67 Find Document References](https://profiles.ihe.net/ITI/MHD/ITI-67.html)"
  * interaction[1].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[2].code = #create (for receiving publications)
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Per [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)"

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Patient reference - REQUIRED for all searches"

  * searchParam[1]
    * name = "_count"
    * type = #number
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Paging support - server SHALL support _count parameter"

  * searchParam[2]
    * name = "type"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD
    * documentation: "Document type (LOINC code)"

  * searchParam[3]
    * name = "category"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD
    * documentation: "Priority category classification"

  * searchParam[4]
    * name = "date"
    * type = #date
    * extension (capabilitystatement-expectation) = #SHOULD
    * documentation: "Date of document creation"

  * searchParam[5]
    * name = "status"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD
    * documentation: "current | superseded | entered-in-error"

  * Paging Requirements:
    - SHALL support paging via _count
    - SHALL include 'next' link when more results available
    - SHALL NOT return duplicate entries across pages
    - SHOULD support _page_token (or similar continuation mechanism)

  * Content Registry Validation (payload gate):
    - SHALL reject documents with disallowed type/format/mime for declared priority category
    - SHALL validate subject references valid patient on this server
    - SHALL enforce envelope invariants
    - Rejection HTTP status: 400/422 (pick one and document)
```

**Binary (Document Content - [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html))**
```
* rest.resource[2]
  * type = #Binary
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Per [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html)"
  * interaction[1].code = #create (for receiving publications)
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "Per [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)"

  * documentation: "Server SHALL return Binary with Content-Type header matching DocumentReference.content.attachment.contentType per ITI-68"

  * Invariant: Binary Content-Type MUST match DocumentReference declared contentType
```

**Bundle (OPTIONAL - for [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html) reception)**
```
* rest.resource[3]
  * type = #Bundle
  * profile = "http://hl7.eu/fhir/euridice-api/StructureDefinition/exchange-provide-bundle"
  * interaction[0].code = #transaction
    * extension (capabilitystatement-expectation) = #MAY

  * documentation: "Server MAY accept MHD Provide Document Bundle per [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html) for atomic publication"
```

### Transactions Supported
- T1: Inspect (CapabilityStatement GET)
- T2: Find Patient ([ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html) - Patient search, optional $match)
- T3: Publish Documents ([ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html) - create DocumentReference + Binary, or transaction bundle)
- T4: Search Documents ([ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) - DocumentReference search with paging)
- T5: Retrieve Document ([ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) - Binary read)

### Required Groupings
```
* Grouped with:
  - MHD Document Recipient (for publish reception)
  - MHD Document Responder (for query/retrieve)
  - Patient Identity Source (PDQm)
  - OAuth2 Authorization Server (SMART Backend Services)
```

### Content Registry Reference
```
* instantiates: "http://hl7.eu/fhir/euridice-api/ImplementationGuide/content-registry"
* documentation: "Server SHALL enforce content registry allowlists. See content-registry.md for priority category specifications."
```

---

## 3. Document Consumer (cs-document-consumer.fsh)

**Actor Type**: Client
**Role**: Queries and retrieves documents from an Access Provider using [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) and [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html)
**Based on**: [IHE MHD Document Consumer Actor](https://profiles.ihe.net/ITI/MHD/1332_actors_and_transactions.html#133214-document-consumer)

### CapabilityStatement Properties
```
* name = "DocumentConsumer"
* title = "Document Consumer"
* status = #active
* date = "2025-12-30"
* kind = #requirements
* fhirVersion = #4.0.1
* format = #json (SHALL), #xml (SHOULD)
* rest.mode = #client
```

### Security (REQUIRED)
```
* rest.security
  * description: "SHALL support SMART Backend Services authorization"

  * oauth flow: client_credentials grant with JWT assertion
  * discovery: /.well-known/smart-configuration

* Requested Scopes:
  - system/Patient.rs (read + search)
  - system/DocumentReference.rs (read + search)
  - system/Binary.r (read)
```

### Expected Interactions

**Patient Search**
```
* rest.resource[0]
  * type = #Patient
  * interaction[0].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #read
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[0]
    * name = "identifier"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHALL

  * operation (OPTIONAL)
    * name = "$match"
    * extension (capabilitystatement-expectation) = #MAY
```

**DocumentReference Search**
```
* rest.resource[1]
  * type = #DocumentReference
  * profile = "http://hl7.eu/fhir/euridice-api/StructureDefinition/exchange-documentreference"

  * interaction[0].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #read
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam expectations: SAME as Document Access Provider

  * Paging handling:
    - Consumer SHALL follow 'next' links
    - Consumer SHALL handle paginated results correctly
```

**Binary Read**
```
* rest.resource[2]
  * type = #Binary
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL

  * documentation: "Consumer reads Binary content and processes based on Content-Type header"
```

### Required Groupings
```
* Grouped with:
  - MHD Document Consumer (for query/retrieve)
  - Patient Identity Consumer (PDQm)
  - OAuth2 Client (SMART Backend Services)
```

---

## 4. Resource Access Provider (cs-resource-access-provider.fsh)

**Actor Type**: Server
**Role**: OPTIONAL add-on that provides read/search access to fine-grained FHIR resources using [PCC-44 Mobile Query Existing Data](https://profiles.ihe.net/PCC/QEDm/PCC-44.html)
**Based on**: [IHE QEDm Clinical Data Source Actor](https://profiles.ihe.net/PCC/QEDm/volume-1.html#152111-clinical-data-source)

### CapabilityStatement Properties
```
* name = "ResourceAccessProvider"
* title = "Resource Access Provider"
* status = #active
* date = "2025-12-30"
* kind = #requirements
* fhirVersion = #4.0.1
* format = #json (SHALL), #xml (SHOULD)
* rest.mode = #server
```

### Key Principles
1. **Read/Search ONLY** - NO create/update/delete
2. **Patient parameter REQUIRED** on all searches (unless bulk option explicitly enabled)
3. **Curated minimal resource set** - keep list short
4. **Traceability** - if resources derived from documents, link via Provenance

### Security (REQUIRED)
```
* rest.security
  * description: "SHALL enforce authorization. SAME oauth2 configuration as Document Access Provider, with additive scopes for resources."

  * Additional scopes beyond document scopes:
    - system/AllergyIntolerance.rs
    - system/Condition.rs
    - system/Observation.rs
    - system/DiagnosticReport.rs
    - system/MedicationRequest.rs (or MedicationStatement)
    - system/Immunization.rs
    - (optional) system/Encounter.rs
```

### Resources and Interactions (Curated Set)

**AllergyIntolerance**
```
* rest.resource[0]
  * type = #AllergyIntolerance
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL
    * documentation: "REQUIRED - all searches MUST include patient parameter"

  * searchParam[1]
    * name = "clinical-status"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

**Condition**
```
* rest.resource[1]
  * type = #Condition
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[1]
    * name = "clinical-status"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[2]
    * name = "category"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

**Observation**
```
* rest.resource[2]
  * type = #Observation
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[1]
    * name = "category"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[2]
    * name = "date"
    * type = #date
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[3]
    * name = "code"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

**DiagnosticReport**
```
* rest.resource[3]
  * type = #DiagnosticReport
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[1]
    * name = "category"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[2]
    * name = "date"
    * type = #date
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

**MedicationRequest (or MedicationStatement)**
```
* rest.resource[4]
  * type = #MedicationRequest
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[1]
    * name = "status"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[2]
    * name = "authoredon"
    * type = #date
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

**Immunization**
```
* rest.resource[5]
  * type = #Immunization
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[1]
    * name = "date"
    * type = #date
    * extension (capabilitystatement-expectation) = #SHOULD

  * searchParam[2]
    * name = "status"
    * type = #token
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

**Encounter (OPTIONAL)**
```
* rest.resource[6]
  * type = #Encounter
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #MAY
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #MAY

  * searchParam[0]
    * name = "patient"
    * type = #reference
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam[1]
    * name = "date"
    * type = #date
    * extension (capabilitystatement-expectation) = #SHOULD

  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
```

### Derived Resource Traceability (if applicable)
```
If resources are derived from documents (e.g., XDS doc repo "breaking apart" docs):

* rest.resource[+]
  * type = #Provenance
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHOULD
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHOULD

  * documentation: "Provenance links derived resources to source DocumentReference"
  * pattern:
    - Provenance.entity.what = DocumentReference/{id} (source document)
    - Provenance.target = derived resource(s)

  * searchRevInclude = "Provenance:target" on all resource types
```

### Global Invariants
```
* documentation: """
  INVARIANT: All resource searches without 'patient' parameter SHALL be rejected (unless bulk export option explicitly enabled)
  INVARIANT: NO create/update/delete operations allowed on clinical resources
  INVARIANT: This is read/search ONLY access
  """
```

### Required Groupings
```
* Grouped with (or MAY be separate conformance claim):
  - [QEDm Clinical Data Source](https://profiles.ihe.net/PCC/QEDm/volume-1.html#152111-clinical-data-source) - provides [PCC-44](https://profiles.ihe.net/PCC/QEDm/PCC-44.html)
  - [Patient Identity Source](https://profiles.ihe.net/ITI/PDQm/volume-1.html#1381-pdqm-actors-transactions-and-content-modules) (for patient parameter validation)
  - OAuth2 Authorization Server
```

---

## 5. Resource Consumer (cs-resource-consumer.fsh)

**Actor Type**: Client
**Role**: Queries fine-grained FHIR resources from a Resource Access Provider using [PCC-44 Mobile Query Existing Data](https://profiles.ihe.net/PCC/QEDm/PCC-44.html)
**Based on**: [IHE QEDm Clinical Data Consumer Actor](https://profiles.ihe.net/PCC/QEDm/volume-1.html#152112-clinical-data-consumer)

### CapabilityStatement Properties
```
* name = "ResourceConsumer"
* title = "Resource Consumer"
* status = #active
* date = "2025-12-30"
* kind = #requirements
* fhirVersion = #4.0.1
* format = #json (SHALL), #xml (SHOULD)
* rest.mode = #client
```

### Security (REQUIRED)
```
* rest.security
  * description: "SHALL support SMART Backend Services authorization"

  * oauth flow: client_credentials grant with JWT assertion
  * discovery: /.well-known/smart-configuration

* Requested Scopes:
  - system/Patient.rs (for patient resolution if needed)
  - system/AllergyIntolerance.rs
  - system/Condition.rs
  - system/Observation.rs
  - system/DiagnosticReport.rs
  - system/MedicationRequest.rs
  - system/Immunization.rs
  - (optional) system/Encounter.rs
```

### Expected Interactions

Consumer expectations mirror the Resource Access Provider capabilities:

**Each Resource Type**
```
* rest.resource[N]
  * type = #[ResourceType]
  * interaction[0].code = #read
    * extension (capabilitystatement-expectation) = #SHALL
  * interaction[1].code = #search-type
    * extension (capabilitystatement-expectation) = #SHALL

  * searchParam expectations: SAME as Resource Access Provider

  * documentation: "Consumer SHALL include patient parameter in all searches"
```

### Required Groupings
```
* Grouped with:
  - [QEDm Clinical Data Consumer](https://profiles.ihe.net/PCC/QEDm/volume-1.html#152112-clinical-data-consumer) - consumes [PCC-44](https://profiles.ihe.net/PCC/QEDm/PCC-44.html)
  - [Patient Identity Consumer (PDQm)](https://profiles.ihe.net/ITI/PDQm/volume-1.html#1381-pdqm-actors-transactions-and-content-modules)
  - OAuth2 Client (SMART Backend Services)
```

---

## Implementation Notes

### Decision Points to Finalize

1. **Publication Shape** (affects Producer + Access Provider)
   - [ ] Require ITI-65 provide-bundle?
   - [ ] Allow simple create (DocumentReference + Binary)?
   - [ ] Support both?

2. **Patient Resolution** (affects Consumer + Producer)
   - [ ] Patient search only?
   - [ ] PDQm $match operation?
   - [ ] Both?
   - [ ] Ambiguity behavior: return candidates vs error?

3. **Custodian Model** (affects DocumentReference profile)
   - [ ] Custodian = Producer organization
   - [ ] Custodian = Access Provider organization

4. **Provenance Requirements**
   - [ ] Metadata-only attribution (via DocumentReference.author)
   - [ ] Require Provenance resource

5. **Resource Query Option**
   - [ ] Which resources make the final cut (current list is starter pack)
   - [ ] Is Resource Responder separate conformance claim or baked into Access Provider?
   - [ ] Recommend: SEPARATE (cleaner, avoids scope creep)

6. **Error Status Codes** (standardize across IG)
   - [ ] Auth failure: 401 vs 403 (pick one)
   - [ ] Validation failure: 400 vs 422 (pick one)

### FSH File Names (per todo.md)

Create these files in `input/fsh/`:
- `cs-document-producer.fsh`
- `cs-document-access-provider.fsh`
- `cs-document-consumer.fsh`
- `cs-resource-access-provider.fsh`
- `cs-resource-consumer.fsh`

### Cross-References Needed

Each CapabilityStatement should reference:
- `ImplementationGuide`: Main IG canonical
- `dependsOn`:
  - [IHE.ITI.MHD](https://profiles.ihe.net/ITI/MHD/) (for ITI-65, ITI-67, ITI-68)
  - [IHE.ITI.PDQm](https://profiles.ihe.net/ITI/PDQm/) (for ITI-78)
  - [IHE.PCC.QEDm](https://profiles.ihe.net/PCC/QEDm/) (for PCC-44)
  - [SMART Backend Services](http://hl7.org/fhir/smart-app-launch/backend-services.html)
- `StructureDefinition`: exchange-documentreference profile
- `StructureDefinition`: exchange-provide-bundle profile (if using ITI-65)
- `ValueSet`: content registry value sets (allowed-document-type, allowed-format-code, allowed-mime-type)

### Testing Considerations

Minimal TestScripts to validate CapabilityStatements:
1. Auth required rejection (401/403)
2. Patient match success + ambiguity handling
3. Document query pagination (next links, no duplicates)
4. Binary retrieve content-type match
5. Producer publish reject (disallowed type/format) - 400/422
6. Producer forbidden action (trying to create Patient) - 403

---

## Summary Table

| Actor | Mode | Auth | Key Resources | Key IHE Transactions |
|-------|------|------|---------------|---------------------|
| Document Producer | client | SMART (required) | DocumentReference (c), Binary (c) | [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html) |
| Document Access Provider | server | SMART (required) | Patient (rs), DocumentReference (crs), Binary (cr) | [ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html), [ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html), [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html), [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) |
| Document Consumer | client | SMART (required) | Patient (rs), DocumentReference (rs), Binary (r) | [ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html), [ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html), [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) |
| Resource Access Provider | server | SMART (required) | Patient + 6-7 clinical resources (rs only) | [PCC-44](https://profiles.ihe.net/PCC/QEDm/PCC-44.html) |
| Resource Consumer | client | SMART (required) | Patient + 6-7 clinical resources (rs) | [PCC-44](https://profiles.ihe.net/PCC/QEDm/PCC-44.html) |

**Legend**: c=create, r=read, s=search, u=update

---

## Next Steps

1. Create 5 FSH files using this specification
2. Reference existing rulesets from `input/fsh/capabilitystatement/` where applicable
3. Validate against IHE dependencies:
   - [MHD](https://profiles.ihe.net/ITI/MHD/) (ITI-65, ITI-67, ITI-68)
   - [PDQm](https://profiles.ihe.net/ITI/PDQm/) (ITI-78)
   - [QEDm](https://profiles.ihe.net/PCC/QEDm/) (PCC-44)
4. Test build with SUSHI
5. Review generated CapabilityStatement JSON for completeness
6. Write corresponding transaction pages (T1-T6) that reference these CS artifacts and IHE transactions
