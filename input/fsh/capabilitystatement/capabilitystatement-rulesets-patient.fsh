// Patient lookup ruleset for PDQm ITI-78 with identifier required
// This constrains the standard PDQm ITI-78 transaction to require identifier-based lookup

RuleSet: CapabilityStatement-Patient-ITI78( requirement )
* resource[+]
  * type = #Patient
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "identifier"
    * definition = "http://hl7.org/fhir/SearchParameter/Patient-identifier"
    * type = #token
    * documentation = "Patient identifier (e.g., national ID, MRN) - required for patient lookup per ITI-78"
