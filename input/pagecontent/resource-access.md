# Resource Access

## Overview

FHIR resource query using QEDm/IPA patterns.

**Optional:** Not all implementations support resource access.

## Constraints

- **Read/search only** (no create/update/delete)
- **Patient-scoped queries** (patient parameter required)
- **Curated resource set** (not a generic FHIR server)

## Actors

- **Resource Access Provider** (server): Provides resource query capabilities
- **Resource Consumer** (client): Queries resources

## Transaction

**PCC-44:** Mobile Query Existing Data (QEDm)

## Resource Set

Minimal curated set:
- AllergyIntolerance
- Condition
- Observation
- DiagnosticReport
- MedicationRequest / MedicationStatement
- Immunization
- (Optional) Encounter

## Search Patterns

All searches require `patient` parameter:

```
GET /AllergyIntolerance?patient={id}
GET /Condition?patient={id}&clinical-status=active
GET /Observation?patient={id}&category=vital-signs&date=ge2024-01-01
GET /DiagnosticReport?patient={id}&category=LAB
GET /MedicationRequest?patient={id}&status=active
GET /Immunization?patient={id}&date=ge2024-01-01
```

Searches without `patient` parameter are rejected (unless bulk option explicitly enabled).

## Scopes

```
system/AllergyIntolerance.rs
system/Condition.rs
system/Observation.rs
system/DiagnosticReport.rs
system/MedicationRequest.rs
system/Immunization.rs
```

## Derived Resources

If resources are derived from documents (extracted from Bundles), Provenance SHOULD link to source DocumentReference:

```json
{
  "resourceType": "Provenance",
  "target": [{"reference": "Observation/123"}],
  "entity": [{
    "role": "source",
    "what": {"reference": "DocumentReference/abc"}
  }]
}
```

## How Resource Access Provider Gets Resources

See [Resource Exchange](resourceExchange.html) for details.

## References

- [IHE QEDm](https://profiles.ihe.net/PCC/QEDm/)
- [PCC-44 Mobile Query Existing Data](https://profiles.ihe.net/PCC/QEDm/PCC-44.html)
- [IPA (International Patient Access)](https://build.fhir.org/ig/HL7/fhir-ipa/)
