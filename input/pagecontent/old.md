#### Initial technology choices

Initial technology choices for the EHR system API are:

* FHIR (initially support of [FHIR v4.0.1](https://hl7.org/fhir/R4/) as well as [FHIR v5.0.0](https://hl7.org/fhir/R5/))
* [SMART App Launch v2.2.0](https://build.fhir.org/ig/HL7/smart-app-launch/index.html)  for user authorization and authentication
* [IHE-MHD](https://profiles.ihe.net/ITI/MHD/index.html) - Mobile access to Health Documents (MHD) for document exchange
* FHIR bulk data access ([FHIR R5 async-bulk](https://hl7.org/fhir/R5/async-bulk.html) and [FHIR R4  Bulk Data IG](https://hl7.org/fhir/uv/bulkdata/)) for data export
* Manual import of FHIR bulk data export files for import
* [IHE-ATNA](https://wiki.ihe.net/index.php/Add_RESTful_Query_and_Feed_to_ATNA) for logging
