### Overview

A **Health Professional Access Service** enables healthcare professionals to access **patient** health information by querying **Provider** systems for EEHRxF data.

### Actors

- **Health Professional Access Service** acts as [Document Consumer](actors.html#document-consumer) and/or [Resource Consumer](actors.html#resource-consumer)
- **EHR systems** act as [Document Access Provider](actors.html#document-access-provider) and/or [Resource Access Provider](actors.html#resource-access-provider)

### Workflow

1. Healthcare professional authenticates to the service
2. Professional selects the patient
3. Service performs [patient matching](patient-match.html) against Provider systems
4. Service queries for available [documents](document-exchange.html) and/or [resources](resource-access.html)
5. Professional reviews retrieved health information

### Technical Flow

The service implements Consumer actors, querying Provider systems using:
- [Authorization](authorization.html) - System-to-system using SMART Backend Services
- [Patient Match](patient-match.html) - Identifying patient across systems
- [Document Exchange](document-exchange.html) and/or [Resource Access](resource-access.html) - Retrieving health data

### Deployment Options

The service may query:
- Multiple EHR systems directly
- National infrastructure that federates queries
- Regional health information exchange systems
