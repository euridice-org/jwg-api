// CapabilityStatement for EEHRxF Document Access Provider Actor
// Composite actor grouping MHD Document Recipient + Document Responder + PDQm Supplier + IUA

Instance: EEHRxF-DocumentAccessProvider
InstanceOf: CapabilityStatement
Title: "EEHRxF Document Access Provider CapabilityStatement"
Usage: #definition
Description: """
CapabilityStatement for the EEHRxF Document Access Provider actor. This composite actor
provides access to EEHRxF FHIR Documents by receiving documents from Document Producers
and serving them to Document Consumers.

### Actor Grouping

This composite actor groups the following IHE actors:
- [IUA Authorization Server](https://profiles.ihe.net/ITI/IUA/index.html#34112-authorization-server)
- [IUA Resource Server](https://profiles.ihe.net/ITI/IUA/index.html#34113-resource-server)
- [PDQm Patient Demographics Supplier](https://profiles.ihe.net/ITI/PDQm/volume-1.html)
- [MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html)
- [MHD Document Responder](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html)

### Transactions

| Transaction | Description | Optionality |
|-------------|-------------|-------------|
| ITI-65 Provide Document Bundle | Receive document submissions from Document Producers | R |
| ITI-67 Find Document References | Respond to document metadata queries from Document Consumers | R |
| ITI-68 Retrieve Document | Serve document content to Document Consumers | R |
| ITI-78 Patient Demographics Query | Respond to patient demographics queries | R |
| Get Access Token | Issue authorization tokens to clients | R |

### Security
Systems SHALL support SMART Backend Services authorization for all transactions.

### Deployment
The Document Access Provider may be grouped with Document Producer, in which case the
ITI-65 transaction becomes internal. See the
[grouped Document Producer/Access Provider CapabilityStatement](CapabilityStatement-EEHRxF-DocumentProducerAccessProvider.html)
for this deployment pattern.
"""

* name = "EEHRxFDocumentAccessProvider"
* title = "EEHRxF Document Access Provider CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-01-14"
* publisher = "HL7 Europe"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

// Server mode for Document Access Provider
* rest[+].mode = #server
* rest[=].documentation = """
The Document Access Provider actor receives document submissions from Document Producers
(ITI-65) and responds to document queries from Document Consumers (ITI-67, ITI-68).
It also provides patient lookup services (PDQm ITI-78).

All transactions require SMART Backend Services authorization.
"""

* rest[=].security.cors = false
* rest[=].security.service = http://hl7.org/fhir/restful-security-service#SMART-on-FHIR
* rest[=].security.description = """
SMART Backend Services authorization is REQUIRED for all transactions.
Systems SHALL:
- Validate JWT client credentials (RFC 7523)
- Verify appropriate scopes for document operations
- Use TLS 1.2 or higher for all communications

Required scopes to accept:
- system/DocumentReference.c (create DocumentReference - ITI-65)
- system/DocumentReference.rs (search and read DocumentReference - ITI-67)
- system/Binary.c (create Binary - ITI-65)
- system/Binary.r (read Binary - ITI-68)
- system/Patient.rs (search and read Patient - ITI-78)
"""

// ============================================================================
// Transaction Bundle support for ITI-65
// ============================================================================
* rest[=].interaction[+].code = #transaction
* rest[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].interaction[=].documentation = "Accept and process ITI-65 Provide Document Bundle transaction"

// System-level search interaction
* rest[=].interaction[+].code = #search-system
* rest[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].interaction[=].extension[=].valueCode = #MAY
* rest[=].interaction[=].documentation = "System-wide search support"

// ============================================================================
// DocumentReference resource - ITI-65 receive and ITI-67 query
// ============================================================================
* rest[=].resource[+].type = #DocumentReference
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
DocumentReference resources are received via ITI-65 Provide Document Bundle and served
via ITI-67 Find Document References. The server validates, stores, and indexes document
metadata for subsequent queries.
"""

// ITI-65: Accept document metadata creation
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Accept DocumentReference creation as part of ITI-65 transaction Bundle"

// ITI-67: Read DocumentReference by ID
* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Read DocumentReference by logical ID"

// ITI-67: Search DocumentReference
* rest[=].resource[=].interaction[+].code = #search-type
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Search for DocumentReference resources (ITI-67)"

* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported
* rest[=].resource[=].referencePolicy = #resolves
* rest[=].resource[=].searchRevInclude = "Provenance:target"

// Search parameters for DocumentReference - SHALL support
* rest[=].resource[=].searchParam[+].name = "patient"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
* rest[=].resource[=].searchParam[=].type = #reference
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].searchParam[=].documentation = "The patient the document is about. The server SHALL support at least id value and MAY support both Type and id values."

* rest[=].resource[=].searchParam[+].name = "type"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-type"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].searchParam[=].documentation = "Kind of document (LOINC code) - SHALL support for clinical precision filtering"

* rest[=].resource[=].searchParam[+].name = "_id"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].searchParam[=].documentation = "Logical id of this artifact"

// Search parameters for DocumentReference - SHOULD support
* rest[=].resource[=].searchParam[+].name = "category"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-category"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Categorization of document (XDS ClassCode) - SHOULD support for coarse filtering"

* rest[=].resource[=].searchParam[+].name = "date"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-date"
* rest[=].resource[=].searchParam[=].type = #date
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "When this document reference was created. The date modifiers ge, le, gt, lt SHOULD be supported."

* rest[=].resource[=].searchParam[+].name = "status"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-status"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "current | superseded | entered-in-error"

* rest[=].resource[=].searchParam[+].name = "identifier"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-identifier"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Master Version Specific Identifier"

// Search parameters for DocumentReference - MAY support
* rest[=].resource[=].searchParam[+].name = "period"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-period"
* rest[=].resource[=].searchParam[=].type = #date
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Time of service that is being documented"

* rest[=].resource[=].searchParam[+].name = "format"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-format"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Format/content rules for the document"

// Additional MHD-aligned search parameters
* rest[=].resource[=].searchParam[+].name = "_lastupdated"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"
* rest[=].resource[=].searchParam[=].type = #date
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "When the resource version last changed"

* rest[=].resource[=].searchParam[+].name = "creation"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-creation"
* rest[=].resource[=].searchParam[=].type = #date
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Document creation time"

* rest[=].resource[=].searchParam[+].name = "setting"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-setting"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Additional details about where the content was created (e.g. clinical specialty)"

* rest[=].resource[=].searchParam[+].name = "facility"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-facility"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Kind of facility where patient was seen"

* rest[=].resource[=].searchParam[+].name = "event"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-event"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Main clinical acts documented"

* rest[=].resource[=].searchParam[+].name = "security-label"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-security-label"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Document security-tags"

* rest[=].resource[=].searchParam[+].name = "related"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-related"
* rest[=].resource[=].searchParam[=].type = #reference
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Related identifiers or resources"

* rest[=].resource[=].searchParam[+].name = "author.given"
* rest[=].resource[=].searchParam[=].type = #string
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Given name of document author"

* rest[=].resource[=].searchParam[+].name = "author.family"
* rest[=].resource[=].searchParam[=].type = #string
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Family name of document author"

* rest[=].resource[=].searchParam[+].name = "patient.identifier"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #MAY
* rest[=].resource[=].searchParam[=].documentation = "Patient identifier (chained search)"

// ============================================================================
// Binary resource - ITI-65 receive and ITI-68 retrieve
// ============================================================================
* rest[=].resource[+].type = #Binary
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
Binary resources contain the actual document content. They are received via ITI-65
Provide Document Bundle and served via ITI-68 Retrieve Document.
"""

// ITI-65: Accept document content
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Accept Binary creation as part of ITI-65 transaction Bundle"

// ITI-68: Retrieve document content
* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Retrieve document content (ITI-68)"

* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported

// ============================================================================
// List resource - ITI-65 submission sets
// ============================================================================
* rest[=].resource[+].type = #List
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].documentation = """
List resources representing SubmissionSets may be received as part of the ITI-65
Provide Document Bundle transaction.
"""

* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].interaction[=].documentation = "Accept List (SubmissionSet) creation as part of ITI-65 transaction Bundle"

* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported

// ============================================================================
// Patient resource - PDQm ITI-78 patient lookup
// ============================================================================
* rest[=].resource[+].type = #Patient
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
Patient resources support patient context lookup per PDQm [ITI-78]. The identifier
search parameter is required; additional demographics parameters are optional.
"""

* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Read Patient by logical ID"

* rest[=].resource[=].interaction[+].code = #search-type
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Search for patients (PDQm ITI-78)"

* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported
* rest[=].resource[=].referencePolicy = #resolves

* rest[=].resource[=].searchParam[+].name = "identifier"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Patient-identifier"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].searchParam[=].documentation = "Patient identifier (e.g., national ID, MRN) - required for patient lookup"

* rest[=].resource[=].searchParam[+].name = "_id"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].searchParam[=].documentation = "Patient logical ID"

* rest[=].resource[=].searchParam[+].name = "family"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/individual-family"
* rest[=].resource[=].searchParam[=].type = #string
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Patient family name"

* rest[=].resource[=].searchParam[+].name = "given"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/individual-given"
* rest[=].resource[=].searchParam[=].type = #string
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Patient given name"

* rest[=].resource[=].searchParam[+].name = "birthdate"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/individual-birthdate"
* rest[=].resource[=].searchParam[=].type = #date
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Patient date of birth"
