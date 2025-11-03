// RuleSet: CapabilityStatement-DocumentReference( requirement )
// * resource[+]
//   * type = #DocumentReference
//   * insert CapabilityStatement-Expectation( {requirement} )
/* see MHD
* resource[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].valueCode = #SHOULD
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHALL
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "category"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHALL
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "category"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "date"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHALL
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "type"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHOULD
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "contenttype"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHOULD
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "status"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHOULD
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "type"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "date"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * extension[+].extension[0].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * extension[=].extension[=].valueCode = #SHOULD
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "patient"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "type"
  * extension[=].extension[+].url = "required"
  * extension[=].extension[=].valueString = "period"
  * extension[=].url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
  * type = #DocumentReference
//  * profile = "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-documentreference"
  * interaction[0].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * interaction[=].extension.valueCode = #SHALL
  * interaction[=].code = #read
  * interaction[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * interaction[=].extension.valueCode = #SHALL
  * interaction[=].code = #search-type
  * updateCreate = false
  * conditionalCreate = false
  * conditionalUpdate = false
  * conditionalDelete = #not-supported
  * referencePolicy = #resolves
  * searchRevInclude = "Provenance:target"
  * searchParam[0].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #SHALL
  * searchParam[=].name = "_id"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
  * searchParam[=].type = #token
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #MAY
  * searchParam[=].name = "category"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-category"
  * searchParam[=].type = #token
  * searchParam[=].documentation = "Categorization of document"
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #MAY
  * searchParam[=].name = "contenttype"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-category"
  * searchParam[=].type = #token
  * searchParam[=].documentation = "Mime type of the content, may include charset"
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #MAY
  * searchParam[=].name = "date"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-date"
  * searchParam[=].type = #date
  * searchParam[=].documentation = "When this document reference was created"
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #MAY
  * searchParam[=].name = "period"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-period"
  * searchParam[=].type = #date
  * searchParam[=].documentation = "Time of service that is being documented"
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #MAY
  * searchParam[=].name = "status"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/DocumentReference-status"
  * searchParam[=].type = #token
  * searchParam[=].documentation = "current | superseded | entered-in-error"
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #MAY
  * searchParam[=].name = "type"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-type"
  * searchParam[=].type = #token
  * searchParam[=].documentation = "Kind of document (LOINC if possible)"
  * searchParam[+].extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * searchParam[=].extension.valueCode = #SHALL
  * searchParam[=].name = "patient"
  * searchParam[=].definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
  * searchParam[=].type = #reference
  * searchParam[=].documentation = "The client **SHALL** provide at least an id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
  * operation.extension.url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
  * operation.extension.valueCode = #SHALL
  * operation.name = "docref"
  * operation.definition = "http://hl7.org/fhir/uv/ipa/OperationDefinition/docref"
  * operation.documentation = "A server **SHOULD** be capable of responding to a $docref operation and capable of returning at least a reference to a CDA document, if available. **MAY** provide references to other 'on-demand' and 'stable' documents (or 'delayed/deferred assembly') that meet the query parameters as well. If a context date range is supplied the server ** SHOULD**  provide references to any document that falls within the date range If no date range is supplied, then the server **SHALL** provide references to last or current encounter.  **SHOULD** document what resources, if any, are returned as included resources\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n`GET [base]/DocumentReference/$docref?patient=[id]`"
*/