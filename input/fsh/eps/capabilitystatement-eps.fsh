Instance: EEHRxF-EPS-Provider-CapabilityStatement
InstanceOf: CapabilityStatement
Title: "EEHRxF EPS Resource Provider Actor"
Usage: #definition
* description = """
CapabilityStatement for EEHRxF Resource Provider Actor.

The actor in this profile responds to FHIR-based queries for one or more fine-grained data elements (FHIR resources).
"""
* name = "EEHRxF_EPS_Provider"
* title = "EEHRxF Resource Provider Actor"
* status = #active
* experimental = false
* date = "2025-10-31"
* kind = #requirements
* fhirVersion = #4.0.1

* format[+] = #application/fhir+json
* format[=].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* format[=].extension.valueCode = #SHALL

* format[+] = #application/fhir+xml
* format[=].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* format[=].extension.valueCode = #SHOULD

* patchFormat = #application/json-patch+json
* patchFormat.extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
* patchFormat.extension.valueCode = #SHOULD

* rest
  * mode = #server
  * documentation = "The EEHRxF Resource Provider in this profile responds to FHIR-based queries."
  * security.description = "Recommend [ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html), encouraged [IHE-IUA](https://profiles.ihe.net/ITI/IUA/index.html) or [SMART-app-launch](http://www.hl7.org/fhir/smart-app-launch/)"
  
  * insert CapabilityStatement-AllergyIntolerance( #SHALL )
  * insert CapabilityStatement-CarePlan( #SHALL )
  * insert CapabilityStatement-ClinicalImpression( #SHALL )
  * insert CapabilityStatement-Composition( #SHALL )
  * insert CapabilityStatement-Condition( #SHALL )
  * insert CapabilityStatement-Consent( #SHALL )
  * insert CapabilityStatement-Device( #SHALL )
  * insert CapabilityStatement-DeviceUseStatement( #SHALL )
  * insert CapabilityStatement-DiagnosticReport( #SHALL )
  * insert CapabilityStatement-IncludedDocumentReference( #SHALL )
  * insert CapabilityStatement-Encounter( #SHALL )
  * insert CapabilityStatement-Flag( #SHALL )
  * insert CapabilityStatement-Immunization( #SHALL )
  * insert CapabilityStatement-ImmunizationRecommendation( #SHALL )
  * insert CapabilityStatement-MedicationRequest( #SHALL )
  * insert CapabilityStatement-MedicationRequest( #SHALL )
  * insert CapabilityStatement-Observation( #SHALL )
  * insert CapabilityStatement-Organization( #SHALL )
  // require basic query, other choices may enhance this
  * insert CapabilityStatement-Patient-BasicQuery( #SHALL )
  * insert CapabilityStatement-Practitioner( #SHALL )
  * insert CapabilityStatement-PractitionerRole( #SHALL )
  * insert CapabilityStatement-Procedure( #SHALL )
  * insert CapabilityStatement-RelatedPerson( #SHALL )
