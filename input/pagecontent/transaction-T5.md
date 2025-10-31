{% include variable-definitions.md %}

This section defines transaction T5. Transaction T5 is used to export data from the EEHRxF Provider.

### Scope

This transaction allows a user (administrator) to export the EEHRxF data stored in an EEHRxF Provider.

### Actor Roles

| Actor | Role |
| EEHRxF Provider | Export data |

### Referenced Standards

* {{FHIR}}
* {{FhirBulkData}}

### Options

This transaction can be implemented in two ways:

1. As a UI element
2. By supporting FHIR bulk data export.

The EEHRxF Provider is REQUIRED to support one of these options.

### UI Element

In this case the functionality is not implemented by an API but by a REQUIRED UI element of the EEHRxF Provider. Using this UI, the administrator can export all or part of the EEHRxF formatted content made available by the EEHRxF Provider into FHIR files  (see [FHIR files](content-FHIR-file.html)). 

### Bulkdata export

In this case the export is implemented by supporting the FHIR bulk data export specification (see {{FhirBulkData}}).