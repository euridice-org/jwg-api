// CapabilityStatement for EEHRxF Document Recipient Actor (MHD ITI-65 receiver/server)
// Based on IHE MHD Document Recipient with SMART Backend Services security

Instance: EEHRxF-DocumentRecipient
InstanceOf: CapabilityStatement
Title: "EEHRxF Document Recipient CapabilityStatement"
Usage: #definition
Description: """
CapabilityStatement for the EEHRxF Document Recipient actor. This actor receives and
processes the Provide Document Bundle [ITI-65] transaction from Document Sources.

This CapabilityStatement defines the capabilities for systems acting as Document Recipients
in the EU EHR Exchange Format (EEHRxF) ecosystem. It is based on the IHE MHD Document Recipient
actor with additional security requirements for SMART Backend Services authorization.

### Transactions
- **ITI-65 Provide Document Bundle**: Receive and process document submissions

### Security
Systems SHALL support SMART Backend Services authorization for all transactions.
"""

* name = "EEHRxFDocumentRecipient"
* title = "EEHRxF Document Recipient CapabilityStatement"
* status = #active
* experimental = false
* date = "2026-01-08"
* publisher = "HL7 Europe"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

// Server mode for Document Recipient
* rest[+].mode = #server
* rest[=].documentation = """
The Document Recipient actor receives and processes Provide Document Bundle [ITI-65]
transactions from Document Sources. It validates incoming documents and metadata,
and may propagate content to grouped actors (e.g., XDS Document Registry/Repository).
All transactions require SMART Backend Services authorization.
"""

* rest[=].security.cors = false
* rest[=].security.service = http://hl7.org/fhir/restful-security-service#SMART-on-FHIR
* rest[=].security.description = """
SMART Backend Services authorization is REQUIRED for all transactions.
Systems SHALL:
- Validate JWT client credentials (RFC 7523)
- Verify appropriate scopes for document submission
- Use TLS 1.2 or higher for all communications

Required scopes to accept:
- system/DocumentReference.c (create DocumentReference)
- system/Binary.c (create Binary)
"""

// Transaction Bundle support for ITI-65
* rest[=].interaction[+].code = #transaction
* rest[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].interaction[=].documentation = "Accept and process ITI-65 Provide Document Bundle transaction"

// DocumentReference resource - accept document metadata
* rest[=].resource[+].type = #DocumentReference
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
DocumentReference resources are received as part of the ITI-65 Provide Document Bundle
transaction. The Document Recipient validates and stores document metadata.
"""
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Accept DocumentReference creation as part of ITI-65 transaction Bundle"
* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported

// Binary resource - accept document content
* rest[=].resource[+].type = #Binary
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
Binary resources containing document content are received as part of the ITI-65
Provide Document Bundle transaction.
"""
* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = "Accept Binary creation as part of ITI-65 transaction Bundle"
* rest[=].resource[=].updateCreate = false
* rest[=].resource[=].conditionalCreate = false
* rest[=].resource[=].conditionalUpdate = false
* rest[=].resource[=].conditionalDelete = #not-supported

// List resource - accept submission sets
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
