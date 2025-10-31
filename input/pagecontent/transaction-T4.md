{% include variable-definitions.md %}

This section defines transaction T4. Transaction T4 is used to import data into the EEHRxF Provider.

### Scope

This transaction allows a user (administrator) to import data into the EEHRxF Provider.

### Actor Roles

| Actor | Role |
| EEHRxF Provider | Import data |

### Referenced Standards

* {{FHIR}}

### Messages

This transaction is not implemented by an API but by a required UI element of the EEHRxF Provider. Using this UI, the administrator can import EEHRxF formatted content into the EEHRxF Provider. The EEHRxF Provider is only REQUIRED to support import of content formatted in EEHRxF formats that it claims compliance to in its CapabilityStatement.

The EEHRxF Provider is REQUIRED to accept content provider as FHIR files (see [FHIR files](content-FHIR-file.html)). It MAY support content provided by another EEHRxF Provider by passing the URL of the FHIR endpoint of this EEHRxF Provider.
