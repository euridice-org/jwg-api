This Implementation Guide supports two primary patterns for exchanging health data: FHIR Documents and individual FHIR Resources.

### FHIR Documents

FHIR Documents are complete, immutable snapshots of clinical information at a point in time. They are represented as FHIR Bundles with `type="document"` and contain a Composition resource that provides structure and rendering information. The Composition acts as a table of contents and enables the document to be displayed as a cohesive clinical report.

Documents are self-contained and can be signed and attested by healthcare providers, making them suitable for traditional clinical reports like patient summaries, discharge reports, and lab reports.


### FHIR Resources

Individual FHIR Resources represent discrete pieces of health information (observations, conditions, medications, etc.) that can be queried and accessed independently. Resources provide granular, queryable access to health data and support real-time clinical decision support workflows.


### Relationship

Resources can be extracted from documents, and documents can be generated from resources. This IG supports both patterns to accommodate different implementation architectures and use cases.
