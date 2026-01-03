# FHIR Documents and FHIR Resources

This Implementation Guide supports two primary patterns for exchanging health data: FHIR Documents and individual FHIR Resources. Understanding when to use each approach is important for implementing the specification.

## FHIR Documents

FHIR Documents are complete, immutable snapshots of clinical information at a point in time. They are represented as FHIR Bundles with `type="document"` and contain a Composition resource that acts as a table of contents.

**Characteristics:**
- Self-contained and immutable
- Signed and attested by healthcare providers
- Represent clinical reports and summaries
- Aligned with traditional document workflows

**When to use:**
- Patient summaries, discharge reports, lab reports, imaging reports
- Information that represents a clinical event or episode
- Cross-organizational exchange requiring attestation

## FHIR Resources

Individual FHIR Resources represent discrete pieces of health information (observations, conditions, medications, etc.) that can be queried and accessed independently.

**Characteristics:**
- Granular and queryable
- Can be updated over time
- Searchable using FHIR search parameters
- Support real-time access patterns

**When to use:**
- Querying for specific types of information
- Real-time clinical decision support
- Applications needing filtered access to specific data

## Relationship

Resources can be extracted from documents, and documents can be generated from resources. This IG supports both patterns to accommodate different implementation architectures and use cases.

TODO: Add examples and diagrams showing the relationship between documents and resources.

