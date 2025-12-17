
Instance: T5-EERxF-UiExport
InstanceOf: CapabilityStatement
Title: "EERxF UI Export Capability Statement"
Description: """
Capability Statement for EERxF Provider related to export of data.  
"""
Usage: #definition
* status = #active
* date = "2025-10-31"
* kind = #requirements
* fhirVersion = #4.0.1
* format[+] = #json
* publisher = "EURidice Joint Working Group, IHE Europe, HL7 Europe"
* purpose = "This Capability Statement describes the capabilities of a system implementing UI export."
* description = """
System implementing this capability SHALL provide a UI interface that allows users to export data in the FHIR file format.
"""