### Overview

A healthcare professional accesses patient health information through a professional portal that queries Provider systems to retrieve EEHRxF data.

### Scenario

Dr. Martinez is treating a patient who has recently relocated from another region. The patient mentions previous hospital admissions and lab work. Dr. Martinez uses the professional portal to search for and review the patient's prior health records.

### Actor Roles

- Professional Portal acts as [Document Consumer](actors.html#document-consumer) and/or [Resource Consumer](actors.html#resource-consumer)
- EHR systems act as [Document Access Provider](actors.html#document-access-provider) and/or [Resource Access Provider](actors.html#resource-access-provider)

### Workflow

1. Healthcare professional authenticates to the portal
2. Professional selects the patient from local patient list
3. Portal performs [patient matching](patient-match.html) against available Provider systems
4. Portal queries for available [documents](document-exchange.html) and/or [resources](resource-access.html)
5. Professional reviews retrieved health information
6. Information informs clinical decisions

### Technical Flow

The portal implements Consumer actors, querying Provider systems using:
- [Authorization](authorization.html) - System-to-system using SMART Backend Services
- [Patient Match](patient-match.html) - Identifying patient across systems
- [Document Exchange](document-exchange.html) and/or [Resource Access](resource-access.html) - Retrieving health data

### Deployment Considerations

The portal may query:
- Multiple EHR systems directly
- National infrastructure that federates queries
- Regional health information exchange systems

