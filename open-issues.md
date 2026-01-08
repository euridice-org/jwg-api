# Open Issues

This document tracks open issues possibly requiring reviewer feedback. These will be incorporated into the IG as a dedicated page before ballot.

---

## Technical Implementation Issues

### Issue 1: Priority Category Declaration
**Status**: Seeking guidance

How should servers declare which EEHRxF priority categories they support? Current CapabilityStatement approach may not adequately express this. Options include:
- CapabilityStatement extensions
- Supported document type/category ValueSets
- Priority category-specific CapabilityStatements

### Issue 2: Identifier Lookup Transaction
**Status**: Seeking guidance

The patient-match page defines a "Basic Patient Demographics Query" transaction for identifier-based lookup. This is simpler than full PDQm ITI-78 demographics search but we need to determine:
- How to formally model this with IHE ITI
- Whether this should be a constraint on ITI-78 or a separate transaction
- 90% of use cases are MRN lookup; patient $match is fallback when identifier unknown

### Issue 3: Category/Type Alignment with Priority Categories
**Status**: Seeking validation

Current DocumentReference type codes (LOINC) don't perfectly align with EEHRxF priority categories:
- "Laboratory Report" (11502-2) vs "Medical Test Results" priority category
- "Radiology Diagnostic study note" (68604-8) vs "Diagnostic Imaging Report" priority category

We use practiceSetting to differentiate lab vs imaging reports. Seeking validation that this approach is sufficient.

### Issue 4: Supported Identifier Extension
**Status**: Seeking guidance

The SupportedIdentifier extension allows servers to declare which patient identifier systems they support (MRN lookup, national ID lookup). Need feedback on:
- Is this the right approach for declaring supported identifiers?
- Should this be mandatory in CapabilityStatements?

### Issue 5: Core Resource Validation
**Status**: Seeking feedback

The Resource Access page defines a core set of clinical resources. Need validation that:
- The resource set is appropriate for the priority categories
- Search parameters are sufficient
- Encounter should be required (currently listed)

### Issue 6: Dependency Pinning
**Status**: Deferred to ballot

Currently using `current` for dependency versions (hl7.fhir.uv.bulkdata, hl7.fhir.eu.base, hl7.fhir.eu.laboratory). Will need to pin specific versions before ballot. Known to cause warnings in build output - these are acceptable for draft.

### Issue 7: DocumentReference Category Coding Validation
**Status**: Seeking reviewer feedback

We have chosen XDS ClassCode (IHE method) for category and LOINC for type. Seeking validation that:
- XDS ClassCode approach aligns with implementer expectations
- LOINC codes selected are appropriate for priority categories
- `practiceSetting` as SHOULD is sufficient for lab vs imaging differentiation

### Issue 8: JWT Algorithm Strictness
**Status**: Seeking guidance

Should we require strict algorithms (RS384/ES384 only) or allow flexibility? Current SMART Backend Services allows multiple algorithms.

### Issue 9: Bundle Operations
**Status**: Following MHD

Bundle operations seem underspecified. Currently following MHD approach for document operations. Seeking implementer feedback on whether additional guidance needed.

---

## Actors and Transactions

### Issue 10: Transaction Table for Document Exchange
**Page**: actors.html

Need to add a transaction table for document exchange actors showing which transactions are required/optional per actor.

### Issue 11: IPA vs QEDm vs EU Core Inheritance
**Page**: actors.html

Analysis needed of what to inherit from IPA vs IHE QEDm vs EU Core for resource access patterns.

### Issue 12: Resource Scope for Priority Areas
**Page**: actors.html

Determine which resources from each priority area should be in scope for resource exchange (not all resources are appropriate for granular exchange).

### Issue 13: Example Grouping Narrative
**Page**: actors.html

Need to add narrative explaining the example actor groupings diagrams.

### Issue 14: MPD Actor Diagram
**Page**: actors.html

Need diagram with IUA + PDQm + MPD Actors showing Order Placer, Order Receiver groupings for ePrescription/eDispensation.

### Issue 15: Imaging Actor Groupings
**Page**: actors.html

Review imaging actor groupings with imaging experts. Need diagram showing Image Consumer as composite of Document Consumer + MADO Image Consumer.

---

## Imaging

### Issue 16: Imaging Manifest Coding
**Status**: No standard LOINC exists

Imaging manifests (DICOM references) have no clean LOINC code. Current approach:
- Delivered via MHD (following andato pattern)
- Use category=IMAGES (XDS ClassCode)
- Use format to indicate DICOM content

Seeking reviewer input on appropriate coding approach.

### Issue 17: R4/R5 Imaging Manifest Harmonization
**Page**: priority-area-imaging-manifest.html

Determine how to harmonize R4 IG with R5-based Imaging Study Manifest from HL7 Europe.

---

## Use Cases and Implementation

### Issue 18: Health Professional Access Service Diagram
**Page**: usecase-health-professional-portal.html

Add deployment architecture diagram and detailed authorization flow.

### Issue 19: Health Data Access Service Authorization
**Page**: usecase-health-data-portal.html

Add guidance on patient-scoped authorization and consent enforcement mechanisms.

### Issue 20: Cross-Border NCP Architecture
**Page**: usecase-cross-border-ncp.html

Add detailed architecture diagram showing all layers and data flow for cross-border exchange.

### Issue 21: Patient Rights Guidance
**Status**: Deferred

Patient rights under EHDS (such as the right to access data, right to restriction, and right to opt-out) are exercised through national infrastructure, not through the EHR API directly. How patient rights are upheld depends on the context of the member state interoperability network.

This topic requires further guidance on:
- How consent and opt-out are enforced at the API level
- Member state variations in patient rights implementation
- Relationship to GDPR data subject rights

---

## Content and Profiles

### Issue 22: DocumentReference Profiles per Priority Area
**Page**: document-exchange.html

Define specific DocumentReference profiles per priority area with appropriate type/category bindings.

### Issue 23: CapabilityStatement Options for Priority Areas
**Page**: priority-area-eps.html

How to best reflect priority area options in CapabilityStatement. All the combinations of options make this difficult to express without generating a massive amount of CapabilityStatements.

---

## Non-MVP Pages

### Issue 24: FHIR Documents vs Resources Narrative
**Status**: Non-MVP, available for implementer reference

The FHIR Documents and Resources page provides background on when to use document exchange vs resource access patterns. This content is not in the main navigation but is linked for implementers who need conceptual guidance. Seeking feedback on whether this should be promoted to the main specification. Needs expansion on when to use documents vs resources and provide examples, as well as resource query patterns and use cases.

### Issue 25: XDS/XCA Bridge Guidance
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
