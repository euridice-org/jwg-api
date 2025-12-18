RuleSet: CapabilityStatement-ClinicalImpression( high )
* resource[+]
  * type = #ClinicalImpression
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchRevInclude = "Provenance:target"
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-Composition( high )
* resource[+]
  * type = #Composition
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "date"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-date"
    * type = #date
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "category"
    * definition = "http://hl7.org/fhir/SearchParameter/Composition-category"
    * type = #token
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "type"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-type"
    * type = #reference
  * searchRevInclude = "Provenance:target"
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-CarePlan( high )
* resource[+]
  * type = #CarePlan 
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchRevInclude = "Provenance:target"
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-Consent( high )
* resource[+]
  * type = #Consent
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchRevInclude = "Provenance:target"
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-Device( high )
* resource[+]
  * type = #Device
  * insert CapabilityStatement-Expectation( {high} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( {high} )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references
  * searchRevInclude = "Provenance:target"

RuleSet: CapabilityStatement-DeviceUseStatement( high )
* resource[+]
  * type = #DeviceUseStatement
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchRevInclude = "Provenance:target"
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference


RuleSet: CapabilityStatement-Flag( high )
* resource[+]
  * type = #Flag
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-ImmunizationRecommendation( high )
* resource[+]
  * type = #ImmunizationRecommendation
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

RuleSet: CapabilityStatement-DocumentReference( high )
* resource[+]
  * type = #ImmunizationRecommendation
  * insert CapabilityStatement-Expectation( {high} )
  * insert RequireReadAndSearch
  * searchParam[+]
    * insert CapabilityStatement-Expectation( {high} )
    * name = "patient"
    * definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
    * type = #reference

// this is for resource access, not MHD search
RuleSet: CapabilityStatement-IncludedDocumentReference( high )
* resource[+]
  * type = #DocumentReference
  * documentation = "Support of DocumentReference resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {high} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( {high} )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * searchRevInclude = "Provenance:target"
  * referencePolicy = #resolves // change identifier references to logical references

RuleSet: CapabilityStatement-Organization( high )
* resource[+]
  * type = #Organization
  * documentation = "Support of Organization resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {high} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( {high} )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * searchRevInclude = "Provenance:target"
  * referencePolicy = #resolves // change identifier references to logical references

RuleSet: CapabilityStatement-Practitioner( high )
* resource[+]
  * type = #Practitioner
  * documentation = "Support of Practitioner resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {high} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( {high} )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * searchRevInclude = "Provenance:target"
  * referencePolicy = #resolves // change identifier references to logical references


RuleSet: CapabilityStatement-PractitionerRole( high )
* resource[+]
  * type = #PractitionerRole
  * documentation = "Support of Practitioner resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {high} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( {high} )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references
  * searchRevInclude = "Provenance:target"

RuleSet: CapabilityStatement-RelatedPerson( high )
* resource[+]
  * type = #RelatedPerson
  * documentation = "Support of RelatedPerson resources as part of a Composition document bundle."
  * insert CapabilityStatement-Expectation( {high} )
  * interaction[+]
    * code = #read
    * insert CapabilityStatement-Expectation( {high} )
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves // change identifier references to logical references
  * searchRevInclude = "Provenance:target"
