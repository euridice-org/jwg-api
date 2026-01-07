The international patient accesss spec has capabiltiy statements already. Lets understand those first to inform our choices. 

https://build.fhir.org/ig/HL7/fhir-ipa/CapabilityStatement-ipa-server.html

# Server
```json
{
  "resourceType" : "CapabilityStatement",
  "id" : "ipa-server",
  "text" : {
    "status" : "extensions",
    "div" : "narrative...."
  },
  "extension" : [
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "pc"
    },
    {
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
      "valueCode" : "trial-use"
    }
  ],
  "url" : "http://hl7.org/fhir/uv/ipa/CapabilityStatement/ipa-server",
  "version" : "1.1.0",
  "name" : "InternationalPatientAccessAPI",
  "title" : "International Patient Access Server CapabilityStatement",
  "status" : "active",
  "experimental" : false,
  "date" : "2023-11-14",
  "publisher" : "HL7 International / Patient Care",
  "contact" : [
    {
      "name" : "HL7 International / Patient Care",
      "telecom" : [
        {
          "system" : "url",
          "value" : "http://www.hl7.org/Special/committees/patientcare"
        },
        {
          "system" : "email",
          "value" : "patientcare@lists.HL7.org"
        }
      ]
    }
  ],
  "description" : "This CapabilityStatement describes the basic rules for the International Patient Access server actor that is responsible for providing responses to queries submitted by International Patient Access requestors. The complete list of FHIR profiles, RESTful operations, and search parameters supported by International Patient Access servers are defined in this CapabilityStatement.",
  "jurisdiction" : [
    {
      "coding" : [
        {
          "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
          "code" : "001",
          "display" : "World"
        }
      ]
    }
  ],
  "copyright" : "Used by permission of HL7 International, all rights reserved Creative Commons License",
  "kind" : "requirements",
  "fhirVersion" : "4.0.1",
  "format" : [
    "json",
    "xml"
  ],
  "_format" : [
    {
      "extension" : [
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
          "valueCode" : "SHALL"
        }
      ]
    },
    {
      "extension" : [
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
          "valueCode" : "SHOULD"
        }
      ]
    }
  ],
  "patchFormat" : [
    "application/json-patch+json"
  ],
  "_patchFormat" : [
    {
      "extension" : [
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
          "valueCode" : "SHOULD"
        }
      ]
    }
  ],
  "implementationGuide" : [
    🔗 "http://hl7.org/fhir/smart-app-launch/ImplementationGuide/hl7.fhir.uv.smart-app-launch"
  ],
  "_implementationGuide" : [
    {
      🔗 "extension" : [
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
          "valueCode" : "SHALL"
        }
      ]
    }
  ],
  "rest" : [
    {
      "mode" : "server",
      "documentation" : "The IPA Server **SHALL**:\n1. Support the IPA Patient resource profile.\n1. Support at least one additional resource profile from the list of IPA Profiles.\n1. Implement the RESTful behavior according to the FHIR specification.\n1. Return the following response classes:\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n   - (Status 400): invalid parameter\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n   - (Status 401/4xx): unauthorized request\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n   - (Status 403): insufficient scope\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n   - (Status 404): unknown resource\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n1. Support JSON source formats for all IPA interactions.\n1. Declare a CapabilityStatement identifying the list of profiles, operations, and search parameters supported.\n\n\n\n\n\n\n\n\nThe IPA Server **SHOULD**:\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n1. Support XML source formats for all IPA interactions.",
      "security" : {
        "description" : "1. See the [General Security Considerations](security.html) section for requirements and recommendations.\n1. A server **SHALL** reject any unauthorized requests by returning an HTTP `401 Unauthorized`, `403 Forbidden`, or `404 Not Found` response code."
      },
      "resource" : [
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "clinical-status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "AllergyIntolerance",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-allergyintolerance",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "clinical-status",
              "definition" : "http://hl7.org/fhir/SearchParameter/AllergyIntolerance-clinical-status",
              "type" : "token",
              "documentation" : "active | inactive | resolved"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least a id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "clinical-status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                },
                {
                  "url" : "required",
                  "valueString" : "clinical-status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "code"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "onset-date"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "Condition",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-condition",
          "supportedProfile" : [
            🔗 "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-problem-list-item"
          ],
          "_supportedProfile" : [
            {
              🔗 "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ]
            }
          ],
          "documentation" : "Client applications should be prepared to encounter codes they do not recognize and handle the records \naccordingly. Servers SHOULD populate Condition.code.coding.display and/or Condition.code.text so that \nclients can always at least display the condition even if they do not know the codes that are used. Clients should be careful making use of the ```code``` search parameter given that the codes used\nvary so much.\n\nSafety Issues:\n\n* Clients SHALL not treat all conditions as if they are part of the patient's current problem list\n    * Note that some Condition resources may not have these status codes - this is usually due to poor record keeping reflected in legacy data\n    * Servers SHOULD avoid leaving these status codes missing\n* Clients SHALL pay attention to the ```clinicalStatus``` and ```verificationStatus``` and display and process them correctly\n* Clients SHALL still work safely when the server does not support all the search parameters listed here.",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "category",
              "definition" : "http://hl7.org/fhir/SearchParameter/Condition-category",
              "type" : "token",
              "documentation" : "The category of the condition"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "clinical-status",
              "definition" : "http://hl7.org/fhir/SearchParameter/Condition-clinical-status",
              "type" : "token",
              "documentation" : "The clinical status of the condition"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "verification-status",
              "definition" : "http://hl7.org/fhir/SearchParameter/Condition-verification-status",
              "type" : "token",
              "documentation" : "The verification status of the condition"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "code",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-code",
              "type" : "token",
              "documentation" : "Code for the condition"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "onset-date",
              "definition" : "http://hl7.org/fhir/SearchParameter/Condition-onset-date",
              "type" : "date",
              "documentation" : "Date of onset for the condition"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least a id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                },
                {
                  "url" : "required",
                  "valueString" : "date"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "type"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "contenttype"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "type"
                },
                {
                  "url" : "required",
                  "valueString" : "date"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "type"
                },
                {
                  "url" : "required",
                  "valueString" : "period"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "DocumentReference",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-documentreference",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "_id",
              "definition" : "http://hl7.org/fhir/SearchParameter/Resource-id",
              "type" : "token"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "category",
              "definition" : "http://hl7.org/fhir/SearchParameter/DocumentReference-category",
              "type" : "token",
              "documentation" : "Categorization of document"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "contenttype",
              "definition" : "http://hl7.org/fhir/SearchParameter/DocumentReference-category",
              "type" : "token",
              "documentation" : "Mime type of the content, may include charset"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "date",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-date",
              "type" : "date",
              "documentation" : "When this document reference was created"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "period",
              "definition" : "http://hl7.org/fhir/SearchParameter/DocumentReference-period",
              "type" : "date",
              "documentation" : "Time of service that is being documented"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "status",
              "definition" : "http://hl7.org/fhir/SearchParameter/DocumentReference-status",
              "type" : "token",
              "documentation" : "current | superseded | entered-in-error"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "type",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-type",
              "type" : "token",
              "documentation" : "Kind of document (LOINC if possible)"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least an id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            }
          ],
          "operation" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "docref",
              "definition" : "http://hl7.org/fhir/uv/ipa/OperationDefinition/docref",
              "documentation" : "A server **SHOULD** be capable of responding to a $docref operation and capable of returning at least a reference to a CDA document, if available. **MAY** provide references to other 'on-demand' and 'stable' documents (or 'delayed/deferred assembly') that meet the query parameters as well. If a context date range is supplied the server ** SHOULD**  provide references to any document that falls within the date range If no date range is supplied, then the server **SHALL** provide references to last or current encounter.  **SHOULD** document what resources, if any, are returned as included resources\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n`GET [base]/DocumentReference/$docref?patient=[id]`"
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "date"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "Immunization",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-immunization",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "date",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-date",
              "type" : "date",
              "documentation" : "Vaccination  (non)-Administration Date"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "status",
              "definition" : "http://hl7.org/fhir/SearchParameter/Immunization-status",
              "type" : "token",
              "documentation" : "Immunization event status"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least an id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            }
          ],
          "type" : "Medication",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-medication",
          "documentation" : "The MedicationStatement and MedicationRequest resources can represent a medication, using an external reference to a Medication resource. If an external Medication Resource is used in a MedicationStatement or a MedicationRequest, then the READ and SEARCH Criteria  **SHALL**  be supported.",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "intent"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "intent"
                },
                {
                  "url" : "required",
                  "valueString" : "authoredon"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "intent"
                },
                {
                  "url" : "required",
                  "valueString" : "status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "MedicationRequest",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-medicationrequest",
          "documentation" : "Clients SHALL query for both MedicationStatement and MedicationRequest when fetching patient Medication information.\n\nThe MedicationRequest resources can represent a medication using either a code or refer to the Medication resource. When referencing Medication, the resource may be [contained](http://hl7.org/fhir/R4/references.html#contained) or an external resource. The server application **MAY** choose any one way or more than one method, but if an external reference to Medication is used, the server **SHALL** support the `_include` parameter for searching this element. The client application **SHALL** support all methods. For example, A server **SHALL** be capable of returning all medications for a patient using one of or both:\n\n `GET /MedicationStatement?patient=[id]`\n\n `GET /MedicationStatement?patient=[id]&_include=MedicationStatement:medication`\n\nWhen representing a prescribed medication, servers SHOULD use codings at the level of a clinical drug rather than ingredient or dose form (e.g. \"loratadine 10mg oral tablet\", rather than a bare ingredient like \"loratadine\" or a dose form like \"loratadine oral tablet\").",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchInclude" : [
            "MedicationRequest:medication"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "category",
              "definition" : "http://hl7.org/fhir/SearchParameter/MedicationRequest-category",
              "type" : "token",
              "documentation" : "Returns prescriptions with different categories"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "code",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-code",
              "type" : "token",
              "documentation" : "Return prescriptions of this medication code"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "authoredon",
              "definition" : "http://hl7.org/fhir/SearchParameter/MedicationRequest-authoredon",
              "type" : "date",
              "documentation" : "Returns prescriptions written on this date"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "intent",
              "definition" : "http://hl7.org/fhir/SearchParameter/MedicationRequest-intent",
              "type" : "token",
              "documentation" : "Return prescriptions with this encounter identifier"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "status",
              "definition" : "http://hl7.org/fhir/SearchParameter/medications-status",
              "type" : "token",
              "documentation" : "Status of the prescription"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least an id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "MedicationStatement",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-medicationstatement",
          "documentation" : "Clients SHALL query for both MedicationStatement and MedicationRequest when fetching patient Medication information.\n\nThe MedicationRequest resources can represent a medication using either a code or refer to the Medication resource. When referencing Medication, the resource may be [contained](http://hl7.org/fhir/R4/references.html#contained) or an external resource. The server application **MAY** choose any one way or more than one method, but if an external reference to Medication is used, the server **SHALL** support the `_include` parameter for searching this element. The client application **SHALL** support all methods.",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchInclude" : [
            "MedicationStatement:medication"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "status",
              "definition" : "http://hl7.org/fhir/SearchParameter/medications-status",
              "type" : "token",
              "documentation" : "Return statements that match the given status"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least an id value and **MAY** provide both the Type and id values."
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "code"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                },
                {
                  "url" : "required",
                  "valueString" : "date"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "category"
                },
                {
                  "url" : "required",
                  "valueString" : "status"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "patient"
                },
                {
                  "url" : "required",
                  "valueString" : "code"
                },
                {
                  "url" : "required",
                  "valueString" : "date"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "Observation",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-observation",
          "supportedProfile" : [
            🔗 "http://hl7.org/fhir/StructureDefinition/vitalsigns"
          ],
          "_supportedProfile" : [
            {
              🔗 "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ]
            }
          ],
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "category",
              "definition" : "http://hl7.org/fhir/SearchParameter/Observation-category",
              "type" : "token",
              "documentation" : "The classification of the type of observation"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "code",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-code",
              "type" : "token",
              "documentation" : "The code of the observation type"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "date",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-date",
              "type" : "date",
              "documentation" : "Obtained date/time. If the obtained element is a period, a date that falls in the period"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "status",
              "definition" : "http://hl7.org/fhir/SearchParameter/Observation-status",
              "type" : "token",
              "documentation" : "The status of the observation"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "MAY"
                }
              ],
              "name" : "patient",
              "definition" : "http://hl7.org/fhir/SearchParameter/clinical-patient",
              "type" : "reference",
              "documentation" : "The client **SHALL** provide at least an id value and **MAY** provide both the Type and id values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHALL"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "family"
                },
                {
                  "url" : "required",
                  "valueString" : "gender"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "birthdate"
                },
                {
                  "url" : "required",
                  "valueString" : "family"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "birthdate"
                },
                {
                  "url" : "required",
                  "valueString" : "name"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                },
                {
                  "url" : "required",
                  "valueString" : "gender"
                },
                {
                  "url" : "required",
                  "valueString" : "name"
                }
              ],
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination"
            }
          ],
          "type" : "Patient",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-patient",
          "documentation" : "Servers SHALL support the capability for a client application to access the patient record using any of the following API calls:\n\n```GET [url]/Patient/[id]```\n\n```GET [url]/Patient?_id=[id]```\n\n```GET [url]/Patient?identifier=[identifier]```\n\nServers are not required to support any additional search parameters, and clients SHOULD not expect servers to do so.\n\nAdditional rules and guidance for supporting `Patient.link`: \n- The server:\n    - SHALL have no more than one Patient with a status of active = \"true\" *from the server being queried* \n    - MAY include inactive patients on the *same server*\n    - MAY include inactive or active patients from a *different server*\n    - When returning a [search Bundle](http://hl7.org/fhir/bundle.html) that contains more than one Patient record for the same patient, the Patient record(s) SHALL use the `Patient.link` attribute to cross-link the Patient resources.\n- The client:\n    - SHALL be able to follow the link(s) to the other Patient resource(s) and understand the direction of the link (in other words, which Patient is linked to which other Patient)\n    - SHALL understand the `Patient.link.type` code which defines the type of link between this Patient resource and another Patient resource\n    - SHALL be aware of the linked Patient `active` flag and that inactive patients may have relevant information",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "search-type"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ],
          "searchParam" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "_id",
              "definition" : "http://hl7.org/fhir/SearchParameter/Resource-id",
              "type" : "token"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "birthdate",
              "definition" : "http://hl7.org/fhir/SearchParameter/individual-birthdate",
              "type" : "date",
              "documentation" : "A client **SHALL** provide a value precise to the *day*.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nA server **SHALL** support a value a value precise to the *day*."
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "family",
              "definition" : "http://hl7.org/fhir/SearchParameter/individual-family",
              "type" : "string"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "gender",
              "definition" : "http://hl7.org/fhir/SearchParameter/individual-gender",
              "type" : "token",
              "documentation" : "The client **SHALL** provide at least a code value and **MAY** provide both the system and code values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL** support both."
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "given",
              "definition" : "http://hl7.org/fhir/SearchParameter/individual-given",
              "type" : "string"
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "name" : "identifier",
              "definition" : "http://hl7.org/fhir/SearchParameter/Patient-identifier",
              "type" : "token",
              "documentation" : "The client **SHALL** provide both the system and code values.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe server **SHALL NOT** support only code values."
            },
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHOULD"
                }
              ],
              "name" : "name",
              "definition" : "http://hl7.org/fhir/SearchParameter/Patient-name",
              "type" : "string"
            }
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            }
          ],
          "type" : "Practitioner",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-practitioner",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ]
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "SHOULD"
            }
          ],
          "type" : "PractitionerRole",
          "profile" : "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-practitionerrole",
          "interaction" : [
            {
              "extension" : [
                {
                  "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
                  "valueCode" : "SHALL"
                }
              ],
              "code" : "read"
            }
          ],
          "updateCreate" : false,
          "conditionalCreate" : false,
          "conditionalUpdate" : false,
          "conditionalDelete" : "not-supported",
          "referencePolicy" : [
            "resolves"
          ],
          "searchInclude" : [
            "PractitionerRole:endpoint",
            "PractitionerRole:practitioner"
          ],
          "searchRevInclude" : [
            "Provenance:target"
          ]
        }
      ],
      "interaction" : [
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "MAY"
            }
          ],
          "code" : "transaction"
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "MAY"
            }
          ],
          "code" : "batch"
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "MAY"
            }
          ],
          "code" : "search-system"
        },
        {
          "extension" : [
            {
              "url" : "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation",
              "valueCode" : "MAY"
            }
          ],
          "code" : "history-system"
        }
      ]
    }
  ]
}


```