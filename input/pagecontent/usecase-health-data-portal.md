### Overview

A **Health Data Access Service** enables a **patient** to access their own health data from **Provider** systems (Proxy Service as defined in EHDS Article 4).

### Actors

- **Health Data Access Service** acts as [Document Consumer](actors.html#document-consumer) and/or [Resource Consumer](actors.html#resource-consumer)
- **EHR systems** act as [Document Access Provider](actors.html#document-access-provider) and/or [Resource Access Provider](actors.html#resource-access-provider)

### Scope

This use case does not define complete requirements for the service itself; it defines how a service could use this interoperability model to access health data.

### Workflow

1. Patient logs into the service (e.g., national eID)
2. Patient reviews and manages consent preferences
3. Service queries Provider systems for patient's data
4. Service displays [documents](document-exchange.html) and [resources](resource-access.html) in patient-friendly format
5. Patient downloads or shares information as needed

### Technical Flow

The service implements Consumer actors with patient-specific authorization:
- Patient authenticates directly (not system-to-system)
- [Authorization](authorization.html) may use patient-scoped tokens
- Service queries only for data belonging to the authenticated patient
- Patient consent preferences are enforced
