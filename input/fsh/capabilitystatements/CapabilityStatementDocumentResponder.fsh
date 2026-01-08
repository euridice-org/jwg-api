// CapabilityStatement for EEHRxF Document Responder Actor (MHD ITI-67, ITI-68 server)
// Based on IHE MHD Document Responder with SMART Backend Services security

Instance: EEHRxF-DocumentResponder
InstanceOf: CapabilityStatement
Title: "EEHRxF Document Responder CapabilityStatement"
Usage: #definition
Description: """
CapabilityStatement for the EEHRxF Document Responder actor. This actor responds to
Find Document References [ITI-67] queries and serves documents via Retrieve Document [ITI-68].

This CapabilityStatement defines the capabilities for systems acting as Document Responders
in the EU EHR Exchange Format (EEHRxF) ecosystem. It is based on the IHE MHD Document Responder
actor with additional security requirements for SMART Backend Services authorization.

### Transactions
- **ITI-67 Find Document References**: Respond to DocumentReference search queries
- **ITI-68 Retrieve Document**: Serve document content (Binary)

### Security
Systems SHALL support SMART Backend Services authorization for all transactions.
"""

* name = "EEHRxFDocumentResponder"
* title = "EEHRxF Document Responder CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-01-08"
* publisher = "HL7 Europe"
* kind = #capability
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

// Server mode for Document Responder
* rest[+].mode = #server
* rest[=].documentation = """
The Document Responder actor responds to document discovery and retrieval requests
from Document Consumers. It supports the Find Document References [ITI-67] and
Retrieve Document [ITI-68] transactions. All transactions require SMART Backend
Services authorization.
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
- system/DocumentReference.rs or system/DocumentReference.s (search DocumentReference)
- system/DocumentReference.r (read DocumentReference)
- system/Binary.r (read Binary for document retrieval)
- system/Patient.s (search Patient for patient context)
"""

// System-level search interaction
* rest[=].interaction[+].code = #search-system
* rest[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].interaction[=].extension[=].valueCode = #MAY
* rest[=].interaction[=].documentation = "System-wide search support"

// DocumentReference resource - ITI-67 Find Document References
* rest[=].resource[+].type = #DocumentReference
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
DocumentReference resources are served in response to ITI-67 Find Document References
queries. The server supports various search parameters for document discovery.
"""
* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Read DocumentReference by logical ID"

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

// Binary resource - ITI-68 Retrieve Document
* rest[=].resource[+].type = #Binary
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
Binary resources contain the actual document content and are served via the
ITI-68 Retrieve Document transaction.
"""
* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Retrieve document content (ITI-68)"
* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported

// Patient resource - for patient context support
* rest[=].resource[+].type = #Patient
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].documentation = """
Patient resources support patient context lookup. This aligns with PDQm [ITI-78]
for patient discovery operations.
"""
* rest[=].resource[=].interaction[+].code = #read
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].interaction[=].documentation = "Read Patient by logical ID"

* rest[=].resource[=].interaction[+].code = #search-type
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHOULD
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
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Patient identifier (e.g., national ID, MRN)"

* rest[=].resource[=].searchParam[+].name = "_id"
* rest[=].resource[=].searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
* rest[=].resource[=].searchParam[=].type = #token
* rest[=].resource[=].searchParam[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].searchParam[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].searchParam[=].documentation = "Patient logical ID"
