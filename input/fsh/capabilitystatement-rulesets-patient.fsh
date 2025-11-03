RuleSet: CapabilityStatement-Patient-BasicQuery( requirement )
* resource[+]
  * type = #Patient
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "identifier"
    * definition = "http://hl7.org/fhir/SearchParameter/Patient.​identifier"
    * type = #token