RuleSet: RequireReadAndSearch
* interaction[+]
  * code = #read
  * insert CapabilityStatement-Expectation( #SHALL )
* interaction[+]
  * code = #search-type
  * insert CapabilityStatement-Expectation( #SHALL )
* updateCreate = false
* conditionalCreate = false
* conditionalUpdate = false
* conditionalDelete = #not-supported
* referencePolicy = #resolves // change identifier references to logical references
* searchRevInclude = "Provenance:target"


RuleSet: CapabilityStatement-ClinicalImpression( requirement )
* resource[+]
  * type = #ClinicalImpression
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-Composition( requirement )
* resource[+]
  * type = #Composition
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "date"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-date"
    * type = #date
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "category"
    * definition = "http://hl7.org/fhir/SearchParameter/Composition-category"
    * type = #token
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "type"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-type"
    * type = #reference
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-CarePlan( requirement )
* resource[+]
  * type = #CarePlan 
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-Consent( requirement )
* resource[+]
  * type = #Consent
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-Device( requirement )
* resource[+]
  * type = #Device
  * insert CapabilityStatement-Expectation( {requirement} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( #SHALL )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references

RuleSet: CapabilityStatement-DeviceUseStatement( requirement )
* resource[+]
  * type = #DeviceUseStatement
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference


RuleSet: CapabilityStatement-Flag( requirement )
* resource[+]
  * type = #Flag
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-ImmunizationRecommendation( requirement )
* resource[+]
  * type = #ImmunizationRecommendation
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-DocumentReference( requirement )
* resource[+]
  * type = #ImmunizationRecommendation
  * insert CapabilityStatement-Expectation( {requirement} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( #SHALL )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

// this is for resource access, not MHD search
RuleSet: CapabilityStatement-IncludedDocumentReference( requirement )
* resource[+]
  * type = #DocumentReference
  * documentation = "Support of DocumentReference resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {requirement} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( #SHALL )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references

RuleSet: CapabilityStatement-Organization( requirement )
* resource[+]
  * type = #Organization
  * documentation = "Support of Organization resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {requirement} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( #SHALL )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references

RuleSet: CapabilityStatement-Practitioner( requirement )
* resource[+]
  * type = #Practitioner
  * documentation = "Support of Practitioner resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {requirement} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( #SHALL )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references


RuleSet: CapabilityStatement-PractitionerRole( requirement )
* resource[+]
  * type = #PractitionerRole
  * documentation = "Support of Practitioner resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {requirement} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( #SHALL )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references

RuleSet: CapabilityStatement-RelatedPerson( requirement )
* resource[+]
  * type = #RelatedPerson
  * documentation = "Support of RelatedPerson resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {requirement} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( #SHALL )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references

