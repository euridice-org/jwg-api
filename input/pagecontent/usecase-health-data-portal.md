# Use Case: Health Data Portal

## Overview

A patient accesses their own health data through a health data access service (Proxy Service as defined in EHDS Article 4).

## Scenario

Maria wants to review her recent lab results and share her medication history with a new specialist. She logs into the national health data access portal, which aggregates her health information from multiple healthcare providers.

## Scope

**Note:** This use case does not define complete requirements for the portal itself; it defines how a portal could use this interoperability model to access health data.

## Actor Roles

- Health Data Access Portal acts as [Document Consumer](actors.html#document-consumer) and/or [Resource Consumer](actors.html#resource-consumer)
- EHR systems act as [Document Access Provider](actors.html#document-access-provider) and/or [Resource Access Provider](actors.html#resource-access-provider)

## Workflow

1. Patient logs into Portal (e.g., national eID)
2. Patient reviews and manages consent preferences
3. Portal queries available Provider systems for patient's data
4. Portal displays [documents](document-exchange.html) and [resources](resource-access.html) in patient-friendly format
5. Patient downloads or shares information as needed

## Technical Flow

The portal implements Consumer actors with patient-specific authorization:
- Patient authenticates directly (not system-to-system)
- [Authorization](authorization.html) may use patient-scoped tokens
- Portal queries only for data belonging to the authenticated patient
- Patient consent preferences are enforced

> **Open Issue:** Add guidance on patient-scoped authorization and consent enforcement mechanisms.
