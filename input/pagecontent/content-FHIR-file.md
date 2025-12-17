{% include variable-definitions.md %}

This section defines the FHIR file format that is used to store and share file containing EEHRxF content.

Two different FHIR files are defined:

1. `json` files
2. `ndjson` files

A FHIR file with the extension `json` SHALL contain a single resource of type {{Bundle}} that contains the FHIR resources related to an EEHRxF Priority Area. In most cases this will be document bundle.

A FHIR file with the extension `ndjson` SHALL follow the specification defined by {{FhirBulkData}} in section {{fhirBulkDataNdjson}}. Each row in these files contans a valid FHIR resource. In this case, each row consists of a FHIR `Bundle` that correponds to EEHRxF information related to one of the priority categories.