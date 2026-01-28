// CapabilityStatement for EEHRxF Document Access Provider - Document Submission Option
// Extends base Document Access Provider with ITI-105 Simplified Publish capability

Instance: EEHRxF-DocumentAccessProvider-SubmissionOption
InstanceOf: CapabilityStatement
Title: "EEHRxF Document Access Provider - Document Submission Option"
Usage: #definition
Description: """
CapabilityStatement for the Document Submission Option on the EEHRxF Document Access Provider.

This option enables the Access Provider to receive documents from external Document
Publishers via [ITI-105 Simplified Publish](https://profiles.ihe.net/ITI/MHD/ITI-105.html).

Systems implementing this option:
- SHALL also implement the base [Document Access Provider](CapabilityStatement-EEHRxF-DocumentAccessProvider.html) capabilities
- SHALL accept ITI-105 transactions from authorized Document Publishers
- SHALL make received documents available via ITI-67 and ITI-68
- SHALL validate documents against EEHRxF content profiles

This option is REQUIRED when acting as a delegated access provider for external
Document Publishers (e.g., integration engines, national infrastructure).

### Actor Grouping

Adds to base Document Access Provider:
- [MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) - Simplified Publish Option ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentRecipient.html))

### Transaction

| Transaction | Description | Optionality |
|-------------|-------------|-------------|
| ITI-105 Simplified Publish | Accept document publication from Document Publishers | R |

### Security
Systems SHALL support SMART Backend Services authorization for document submission.
"""

* name = "EEHRxFDocumentAccessProviderSubmissionOption"
* title = "EEHRxF Document Access Provider - Document Submission Option"
* status = #active
* experimental = false
* date = "2026-01-26"
* publisher = "HL7 Europe"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* format[+] = #xml

// Reference to base capability
* imports = Canonical(EEHRxF-DocumentAccessProvider)

* rest[+].mode = #server
* rest[=].documentation = """
The Document Submission Option adds ITI-105 Simplified Publish capability.
Document Publishers POST a DocumentReference with embedded document content.
The server extracts and persists both the DocumentReference metadata and the
embedded document, making them available via ITI-67 and ITI-68.
"""

* rest[=].security.service = http://hl7.org/fhir/restful-security-service#SMART-on-FHIR
* rest[=].security.description = """
Additional scope required for document submission:
- system/DocumentReference.create (create DocumentReference via ITI-105)

The Document Publisher must be authorized to submit documents on behalf of the
patient's care team.
"""

// ============================================================================
// DocumentReference resource - ITI-105 Simplified Publish (create)
// ============================================================================
* rest[=].resource[+].type = #DocumentReference
* rest[=].resource[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].documentation = """
DocumentReference resources with embedded document content are accepted via
ITI-105 Simplified Publish. The server:
1. Validates the DocumentReference against EEHRxF profiles
2. Extracts the embedded document from content.attachment.data
3. Persists both the DocumentReference and the document
4. Returns the created DocumentReference with server-assigned IDs
"""

* rest[=].resource[=].interaction[+].code = #create
* rest[=].resource[=].interaction[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].interaction[=].extension[=].valueCode = #SHALL
* rest[=].resource[=].interaction[=].documentation = """
Accept DocumentReference with embedded document (ITI-105 Simplified Publish).

The DocumentReference SHALL include:
- status (required)
- type (required - LOINC document type)
- subject (required - Patient reference)
- content.attachment.contentType (required)
- content.attachment.data (required - base64-encoded document content)

The server SHALL:
- Validate against EEHRxF DocumentReference profile
- Extract and persist the document
- Assign server-generated IDs
- Return 201 Created with the persisted DocumentReference
"""

// Supported profiles - MHD Minimal DocumentReference
* rest[=].resource[=].supportedProfile = "https://profiles.ihe.net/ITI/MHD/StructureDefinition/IHE.MHD.Minimal.DocumentReference"

// Operation outcome for validation errors
* rest[=].resource[=].operation[+].name = "validate"
* rest[=].resource[=].operation[=].definition = "http://hl7.org/fhir/OperationDefinition/Resource-validate"
* rest[=].resource[=].operation[=].extension[+].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* rest[=].resource[=].operation[=].extension[=].valueCode = #MAY
* rest[=].resource[=].operation[=].documentation = "Pre-validation of DocumentReference before submission"
