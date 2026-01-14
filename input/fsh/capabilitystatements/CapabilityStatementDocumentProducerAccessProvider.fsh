// CapabilityStatement for Grouped EEHRxF Document Producer + Document Access Provider
// For deployments where document production and access are co-located (ITI-65 is internal)

Instance: EEHRxF-DocumentProducerAccessProvider
InstanceOf: CapabilityStatement
Title: "EEHRxF Grouped Document Producer/Access Provider CapabilityStatement"
Usage: #definition
Description: """
CapabilityStatement for the grouped EEHRxF Document Producer and Document Access Provider
actors. This represents a deployment where document production and access provision are
co-located in the same system.

### Deployment Pattern

This CapabilityStatement applies when:
- An EHR system both produces documents AND provides access to them
- Document submission (ITI-65) is handled internally
- External clients only need to query and retrieve documents

In this grouped deployment, the ITI-65 Provide Document Bundle transaction is internal
to the system and not exposed externally. The external API provides only document
discovery (ITI-67) and retrieval (ITI-68) capabilities.

### Actor Grouping

This grouped actor combines:
- **Document Producer** (internal) - Produces and stores documents internally
- **Document Access Provider** (external-facing) - Serves documents to Document Consumers

The underlying IHE actors are:
- [IUA Authorization Server](https://profiles.ihe.net/ITI/IUA/index.html#34112-authorization-server)
- [IUA Resource Server](https://profiles.ihe.net/ITI/IUA/index.html#34113-resource-server)
- [PDQm Patient Demographics Supplier](https://profiles.ihe.net/ITI/PDQm/volume-1.html)
- [MHD Document Responder](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html)

Note: MHD Document Recipient is not listed because ITI-65 is internal.

### External Transactions

| Transaction | Description | Optionality |
|-------------|-------------|-------------|
| ITI-67 Find Document References | Respond to document metadata queries from Document Consumers | R |
| ITI-68 Retrieve Document | Serve document content to Document Consumers | R |
| ITI-78 Patient Demographics Query | Respond to patient demographics queries | R |
| Get Access Token | Issue authorization tokens to clients | R |

### Security
Systems SHALL support SMART Backend Services authorization for all transactions.

### When to Use This CapabilityStatement

Use this CapabilityStatement when implementing:
- Hospital EHR systems that produce and serve their own documents
- Regional health information exchanges with integrated document repositories
- Any system where document creation and access are tightly coupled

For systems that need to receive documents from external sources, use the separate
[Document Access Provider CapabilityStatement](CapabilityStatement-EEHRxF-DocumentAccessProvider.html)
which includes ITI-65 support.
"""

* name = "EEHRxFDocumentProducerAccessProvider"
* title = "EEHRxF Grouped Document Producer/Access Provider CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-01-14"
* publisher = "HL7 Europe"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

// Server mode - external-facing API
* rest[+].mode = #server
* rest[=].documentation = """
This grouped actor provides document access to external Document Consumers.
Document production (ITI-65) is internal and not exposed. The external API
supports document discovery (ITI-67), retrieval (ITI-68), and patient lookup (ITI-78).

All transactions require SMART Backend Services authorization.
"""

* rest[=].security.cors = false
* rest[=].security.service = http://hl7.org/fhir/restful-security-service#SMART-on-FHIR
* rest[=].security.description = """
SMART Backend Services authorization is REQUIRED for all transactions.
Systems SHALL:
- Validate JWT client credentials (RFC 7523)
- Verify appropriate scopes for document access
- Use TLS 1.2 or higher for all communications

Required scopes to accept:
- system/DocumentReference.rs (search and read DocumentReference - ITI-67)
- system/Binary.r (read Binary - ITI-68)
- system/Patient.rs (search and read Patient - ITI-78)
"""

// System-level search interaction
* rest[=].interaction[+].code = #search-system
* rest[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].interaction[=].extension[=].valueCode = #MAY
* rest[=].interaction[=].documentation = "System-wide search support"

// ============================================================================
// DocumentReference resource - ITI-67 Find Document References (query only)
// ============================================================================
* rest[=].resource[+].type = #DocumentReference
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
DocumentReference resources are served via ITI-67 Find Document References.
Document creation is internal; no external create operation is supported.
"""

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

// ============================================================================
// Binary resource - ITI-68 Retrieve Document (read only)
// ============================================================================
* rest[=].resource[+].type = #Binary
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
Binary resources contain the actual document content and are served via ITI-68
Retrieve Document. Document content is created internally; no external create
operation is supported.
"""

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
