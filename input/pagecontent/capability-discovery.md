# Capability Discovery

## Overview

Systems discover capabilities via FHIR CapabilityStatement (GET /metadata).

## Priority Category Support

Servers declare which EHDS ANNEX II priority categories they support:
- European Patient Summary (EPS)
- Medication Prescription & Dispense (MPD)
- Laboratory Results
- Hospital Discharge Reports (HDR)
- Imaging Reports
- Imaging Manifests

**Mechanism:** TBD (CapabilityStatement.instantiates, extension, or other approach)

## Content Registry

Priority categories link to external HL7 EU IGs:
- Category → IG canonical URL + version
- DocumentReference.type/format allowed value sets per category
- Servers enforce content registry on publication and query

## Actors

- Document Access Provider: Advertises document exchange capabilities
- Resource Access Provider: Advertises resource query capabilities

## See Also
- [FHIR CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html)
