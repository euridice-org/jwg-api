// CapabilityStatement for EEHRxF Document Source Actor (MHD ITI-65 sender/client)
// Based on IHE MHD Document Source with SMART Backend Services security

Instance: EEHRxF-DocumentSource
InstanceOf: CapabilityStatement
Title: "EEHRxF Document Source CapabilityStatement"
Usage: #definition
Description: """
CapabilityStatement for the EEHRxF Document Source actor. This actor initiates the
Provide Document Bundle [ITI-65] transaction to publish documents to a Document Recipient.

This CapabilityStatement defines the requirements for systems acting as Document Sources
in the EU EHR Exchange Format (EEHRxF) ecosystem. It is based on the IHE MHD Document Source
actor with additional security requirements for SMART Backend Services authorization.

### Transactions
- **ITI-65 Provide Document Bundle**: Submit documents and metadata to a Document Recipient

### Security
Systems SHALL support SMART Backend Services authorization for all transactions.
"""

* name = "EEHRxFDocumentSource"
* title = "EEHRxF Document Source CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-01-08"
* publisher = "HL7 Europe"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

// Security requirements - SMART Backend Services
* rest[+].mode = #client
* rest[=].documentation = """
The Document Source actor initiates the Provide Document Bundle [ITI-65] transaction
to submit documents to a Document Recipient. All transactions require SMART Backend
Services authorization.
"""

* rest[=].security.cors = false
* rest[=].security.service = http://hl7.org/fhir/restful-security-service#SMART-on-FHIR
* rest[=].security.description = """
SMART Backend Services authorization is REQUIRED for all transactions.
Systems SHALL:
- Authenticate using JWT client credentials (RFC 7523)
- Request appropriate scopes for document submission
- Use TLS 1.2 or higher for all communications

Required scopes for document submission:
- system/DocumentReference.c (create DocumentReference)
- system/Binary.c (create Binary)
"""

// Transaction Bundle support for ITI-65
* rest[=].interaction[+].code = #transaction
* rest[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].interaction[=].documentation = "ITI-65 Provide Document Bundle transaction"

// DocumentReference resource - for creating document metadata
* rest[=].resource[+].type = #DocumentReference
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
DocumentReference resources are submitted as part of the ITI-65 Provide Document Bundle
transaction to register document metadata with the Document Recipient.
"""
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Create DocumentReference as part of ITI-65 transaction Bundle"

// Binary resource - for document content
* rest[=].resource[+].type = #Binary
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
Binary resources contain the actual document content and are submitted as part of
the ITI-65 Provide Document Bundle transaction.
"""
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Create Binary as part of ITI-65 transaction Bundle"

// List resource - for submission sets (optional but commonly used)
* rest[=].resource[+].type = #List
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].documentation = """
List resources may be used to represent SubmissionSets as part of the ITI-65
Provide Document Bundle transaction.
"""
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHOULD
* rest[=].resource[=].interaction[=].documentation = "Create List (SubmissionSet) as part of ITI-65 transaction Bundle"
