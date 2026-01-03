# Functional Requirements

This section describes the functional capabilities and technical requirements for implementing the EU Health Data API.

## Actor Model

The specification defines composite actors that inherit from existing IHE and HL7 specifications. See [Actors and Transactions](actors.html) for detailed actor definitions, groupings, and transaction requirements.

## Core Functional Areas

### Capability Discovery

Systems use FHIR CapabilityStatement to discover what priority categories and exchange patterns a provider supports. See [Capability Discovery](capability-discovery.html).

### Authorization

System-to-system authorization using SMART Backend Services and IHE IUA. Required for all transactions. See [Authorization](authorization.html).

### Patient Identification

Patient demographics query using IHE PDQm to locate the correct patient before accessing health information. See [Patient Matching](patient-match.html).

### Document Exchange

Exchange of FHIR Documents (Patient Summaries, Lab Reports, Discharge Reports, etc.) using IHE MHD transactions. See [Document Exchange](document-exchange.html).

### Resource Access

Query individual FHIR resources (Observations, Conditions, Medications, etc.) using QEDm/IPA patterns. See [Resource Access](resource-access.html).

## Relationship Between Functional Areas

All exchange patterns follow a common flow:

1. **Discover** capabilities via CapabilityStatement
2. **Authorize** using SMART Backend Services
3. **Identify** the patient using PDQm
4. **Access** data via Document Exchange or Resource Access

The specification allows implementations to support document exchange only, resource access only, or both patterns depending on their use case and architecture.

