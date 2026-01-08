# Open Issues for Wide Review

This document tracks open issues requiring reviewer feedback. These will be incorporated into the IG as a dedicated page before ballot.

---

## Technical Implementation Issues

### Issue 1: Dependency Pinning
**Status**: Deferred to ballot

Currently using `current` for dependency versions (hl7.fhir.uv.bulkdata, hl7.fhir.eu.base, hl7.fhir.eu.laboratory). Will need to pin specific versions before ballot. Known to cause warnings in build output - these are acceptable for draft.

### Issue 2: DocumentReference Category Coding Validation
**Status**: Seeking reviewer feedback

We have chosen XDS ClassCode (IHE method) for category and LOINC for type. Seeking validation that:
- XDS ClassCode approach aligns with implementer expectations
- LOINC codes selected are appropriate for priority categories
- `practiceSetting` as SHOULD is sufficient for lab vs imaging differentiation

### Issue 3: JWT Algorithm Strictness
**Status**: Seeking guidance

Should we require strict algorithms (RS384/ES384 only) or allow flexibility? Current SMART Backend Services allows multiple algorithms.

### Issue 4: Bundle Operations
**Status**: Following MHD

Bundle operations seem underspecified. Currently following MHD approach for document operations. Seeking implementer feedback on whether additional guidance needed.

---

## Actors and Transactions

### Issue 5: Transaction Table for Document Exchange
**Page**: actors.html

Need to add a transaction table for document exchange actors showing which transactions are required/optional per actor.

### Issue 6: IPA vs QEDm vs EU Core Inheritance
**Page**: actors.html

Analysis needed of what to inherit from IPA vs IHE QEDm vs EU Core for resource access patterns.

### Issue 7: Resource Scope for Priority Areas
**Page**: actors.html

Determine which resources from each priority area should be in scope for resource exchange (not all resources are appropriate for granular exchange).

### Issue 8: Example Grouping Narrative
**Page**: actors.html

Need to add narrative explaining the example actor groupings diagrams.

### Issue 9: MPD Actor Diagram
**Page**: actors.html

Need diagram with IUA + PDQm + MPD Actors showing Order Placer, Order Receiver groupings for ePrescription/eDispensation.

### Issue 10: Imaging Actor Groupings
**Page**: actors.html

Review imaging actor groupings with imaging experts. Need diagram showing Image Consumer as composite of Document Consumer + MADO Image Consumer.

---

## Imaging

### Issue 11: Imaging Manifest Coding
**Status**: No standard LOINC exists

Imaging manifests (DICOM references) have no clean LOINC code. Current approach:
- Delivered via MHD (following andato pattern)
- Use category=IMAGES (XDS ClassCode)
- Use format to indicate DICOM content

Seeking reviewer input on appropriate coding approach.

### Issue 12: R4/R5 Imaging Manifest Harmonization
**Page**: priority-area-imaging-manifest.html

Determine how to harmonize R4 IG with R5-based Imaging Study Manifest from HL7 Europe.

---

## Use Cases and Implementation

### Issue 13: Health Professional Portal Diagram
**Page**: usecase-health-professional-portal.html

Add deployment architecture diagram and detailed authorization flow.

### Issue 14: Health Data Portal Authorization
**Page**: usecase-health-data-portal.html

Add guidance on patient-scoped authorization and consent enforcement mechanisms.

### Issue 15: Cross-Border NCP Architecture
**Page**: usecase-cross-border-ncp.html

Add detailed architecture diagram showing all layers and data flow for cross-border exchange.

### Issue 16: Patient Rights Guidance
**Page**: regulatoryAnchors.html

How patient rights are upheld depends on the context of the member state interoperability network. Further guidance needed.

---

## Content and Profiles

### Issue 17: DocumentReference Profiles per Priority Area
**Page**: document-exchange.html

Define specific DocumentReference profiles per priority area with appropriate type/category bindings.

### Issue 18: CapabilityStatement Options for EPS
**Page**: priority-area-eps.html

How to best reflect priority area options in CapabilityStatement. All the combinations of options make this difficult to express without generating a massive amount of CapabilityStatements.

---

## Non-MVP Pages

### Issue 19: FHIR Documents vs Resources Narrative
**Status**: Non-MVP, available for implementer reference

The FHIR Documents and Resources page provides background on when to use document exchange vs resource access patterns. This content is not in the main navigation but is linked for implementers who need conceptual guidance. Seeking feedback on whether this should be promoted to the main specification. Needs expansion on when to use documents vs resources and provide examples, as well as resource query patterns and use cases.

### Issue 20: XDS/XCA Bridge Guidance
**Status**: Non-MVP, linked from Member State Architectures

The Relationship to XDS/XCA page provides guidance for Member States with existing XDS or XCA infrastructure. This content is not in the main navigation but is linked from Member State Architectures. Needs architectural diagrams showing different implementation patterns and mappings.

---

## Known Build Issues (Acceptable for Wide Review)

The following build errors are known and acceptable for the draft/wide review version. They will be addressed before ballot.

### IHE QEDm Broken Links
**Status**: External dependency issue

The IHE QEDm CapabilityStatement contains internal links to `volume-1.html#actor-options` that cannot be resolved. This is an issue with the IHE QEDm package, not this IG.

### XDS ClassCode ValueSet Expansion
**Status**: Deferred

The `EEHRxFDocumentClassVS` ValueSet uses XDS ClassCode system (`urn:oid:1.3.6.1.4.1.19376.1.2.6.1`) which is not registered on tx.fhir.org. The codes are correct per IHE specifications but the terminology server cannot expand the ValueSet. This is acceptable for wide review.

### Jurisdiction Declaration
**Status**: To be fixed before ballot

Some resources need explicit Europe jurisdiction declaration. Will be addressed by adding `jurisdiction: http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"` to sushi-config.yaml.

### Jira Specification File
**Status**: Required before ballot

A Jira specification file (`FHIR-eu-euridice-api`) must be added to the HL7 Jira-Spec-Artifacts project before ballot/publication. Not required for wide review.

### EU Extensions R5/R4 Mismatch
**Status**: Known limitation

The `hl7.fhir.eu.extensions#current` package is for FHIR R5 while this IG targets R4. The publisher ignores this mismatch and continues. Will monitor for issues.
