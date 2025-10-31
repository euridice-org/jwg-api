
Instance: T5-EERxF-BulkDataExport
InstanceOf: CapabilityStatement
Usage: #definition
Title: "EERxF BulkDate Export Capability Statement"
Description: """
Capability Statement for EERxF Provider. It contains an overview of all resources and operations supported by the server.
In addition it SHALL indicate what other Capability Statements defined in this specification related to
the type of access (Document and/or Resource) and priority areas it supports.  
"""
* status = #active
* date = "2025-10-31"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* publisher = "EURidice Joint Working Group, IHE Europe, HL7 Europe"
* description = """
Capability Statement for EERxF Provider. It contains an overview of all resources and operations supported by the server. 
In addition it SHALL indicate what other Capability Statements defined in this specification related to the type of access 
(Document and/or Resource) and priority areas it supports.
"""
* implementationGuide[+] = "http://hl7.eu/fhir/eerxf/ImplementationGuide/EERxF-IG"
* purpose = "This Capability Statement describes the capabilities of the EERxF Provider Actor as defined in the EERxF specification."
* rest[+]
  * mode = #server
  * operation[+]
    * extension[+]
      * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
      * valueCode = #SHOULD
    * name = "export"
    * definition = "http://hl7.org/fhir/uv/bulkdata/OperationDefinition/export"
  * resource[+]
    * type = #Patient
    * profile = "http://hl7.eu/fhir/eerxf/StructureDefinition/EERxF-Patient"
    * interaction[+]
      * code = #read
    * operation[+]
      * extension[+]
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * name = "export"
      * definition = "http://hl7.org/fhir/uv/bulkdata/OperationDefinition/export"
  * resource[+]
    * type = #Group
    * interaction[+]
      * code = #read
    * operation[+]
      * extension[+]
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #MAY
      * name = "export"
      * definition = "http://hl7.org/fhir/uv/bulkdata/OperationDefinition/export"      