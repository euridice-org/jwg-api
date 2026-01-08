# Open Issues for Wide Review

This document tracks open issues requiring reviewer feedback. These will be incorporated into the IG as a dedicated page before ballot.

---

## Open Issue 1: Dependency Pinning
**Status**: Deferred to ballot

Currently using `current` for dependency versions (hl7.fhir.uv.bulkdata, hl7.fhir.eu.base, hl7.fhir.eu.laboratory). Will need to pin specific versions before ballot. Known to cause warnings in build output - these are acceptable for draft.

---

## Open Issue 2: DocumentReference Category Coding Validation
**Status**: Seeking reviewer feedback

We have chosen XDS ClassCode (IHE method) for category and LOINC for type. Seeking validation that:
- XDS ClassCode approach aligns with implementer expectations
- LOINC codes selected are appropriate for priority categories
- `practiceSetting` as SHOULD is sufficient for lab vs imaging differentiation

---

## Open Issue 3: Imaging Manifest Coding
**Status**: No standard LOINC exists

Imaging manifests (DICOM references) have no clean LOINC code. Current approach:
- Delivered via MHD (following andato pattern)
- Use category=IMAGES (XDS ClassCode)
- Use format to indicate DICOM content

Seeking reviewer input on appropriate coding approach.

---

## Open Issue 4: Resource Scope - IPA vs QEDm
**Status**: Using IPA baseline

Using IPA as baseline with EU Core profile inheritance. Is this sufficient or do we need QEDm-specific requirements for certain use cases?

---

## Open Issue 5: JWT Algorithm Strictness
**Status**: Seeking guidance

Should we require strict algorithms (RS384/ES384 only) or allow flexibility? Current SMART Backend Services allows multiple algorithms.

---

## Open Issue 6: Bundle Operations
**Status**: Following MHD

Bundle operations seem underspecified. Currently following MHD approach for document operations. Seeking implementer feedback on whether additional guidance needed.

---

## Open Issue 7: FHIR Documents vs Resources Narrative
**Status**: Non-MVP, available for implementer reference

The [FHIR Documents and Resources](input/pagecontent/fhir-documents-vs-resources.md) page provides background on when to use document exchange vs resource access patterns. This content is not in the main navigation but is linked for implementers who need conceptual guidance. Seeking feedback on whether this should be promoted to the main specification.

---

## Open Issue 8: XDS/XCA Bridge Guidance
**Status**: Non-MVP, linked from Member State Architectures

The [Relationship to XDS/XCA](input/pagecontent/xds-xca-bridge.md) page provides guidance for Member States with existing XDS or XCA infrastructure. This content is not in the main navigation but is linked from Member State Architectures. Seeking feedback on whether additional bridging guidance is needed.

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
