# Document Exchange

## Overview

Document exchange using IHE MHD (Mobile Health Documents) transactions. This IG inherits MHD transactions as-is, with constraints specific to EEHRxF content.

## Actors

- **Document Producer** (client): Publishes documents using MHD Document Source
- **Document Access Provider** (server): Receives and serves documents using MHD Document Recipient + Document Responder
- **Document Consumer** (client): Queries and retrieves documents using MHD Document Consumer

See [Actors and Transactions](actors.html) for detailed actor groupings.

## IHE MHD Transactions

This IG uses the following IHE MHD transactions without modification to the transaction mechanics:

### ITI-65: Provide Document Bundle (Publish)

Document Producer → Document Access Provider

Transaction bundle containing DocumentReference + Binary resources.

**Endpoint**: `POST [base]` (transaction bundle)

**Scope**: `system/DocumentReference.c`, `system/Binary.c`

**Constraints**:
- DocumentReference SHALL conform to EEHRxF DocumentReference profile for declared priority category
- Binary content SHALL be valid EEHRxF content (FHIR document Bundle)
- DocumentReference.type and .format SHALL match priority category value sets

See [IHE MHD ITI-65](https://profiles.ihe.net/ITI/MHD/ITI-65.html) for transaction details.

### ITI-67: Find Document References (Search)

Document Consumer → Document Access Provider

Query for DocumentReference resources.

**Endpoint**: `GET [base]/DocumentReference?[parameters]`

**Required Parameters**:
- `patient` (required)
- `_count` (for paging)

**Optional Parameters**:
- `type` - Document type (e.g., Patient Summary LOINC code)
- `date` - Creation date range
- `category` - Document category
- `format` - Format code
- `status` - Document status

**Scope**: `system/DocumentReference.rs`, `system/Patient.rs`

**Paging**: Response includes `link` with `relation="next"` when more results available.

See [IHE MHD ITI-67](https://profiles.ihe.net/ITI/MHD/ITI-67.html) for transaction details.

### ITI-68: Retrieve Document (Retrieve)

Document Consumer → Document Access Provider

Retrieve document content.

**Endpoint**: `GET [base]/Binary/[id]`

**Scope**: `system/Binary.r`

**Response**: Binary content with `Content-Type` matching DocumentReference.content.attachment.contentType

**Supported Formats** (per priority category):
- `application/fhir+json` (FHIR Bundle - document)
- `application/pdf` (optional, for rendering)
- `text/xml` (CDA, if supported)

See [IHE MHD ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html) for transaction details.

## EEHRxF-Specific Constraints

While the MHD transaction mechanics are unchanged, this IG adds constraints on content:

### DocumentReference Profile

Inherits from IHE MHD Comprehensive DocumentReference with additional constraints:
- Priority category-specific type/format value sets
- Required metadata elements for EEHRxF
- Content registry enforcement

> **Open Issue:** Define specific DocumentReference profiles per priority area.

### Content Validation

Document Access Providers SHALL:
- Validate DocumentReference.type/format against priority category value sets
- Verify Binary content is valid EEHRxF format
- Enforce required metadata elements

## Authorization

All MHD transactions require authorization via [SMART Backend Services](authorization.html) with appropriate scopes as listed above.

## See Also

- [IHE MHD Specification](https://profiles.ihe.net/ITI/MHD/)
- [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)
- [ITI-67 Find Document References](https://profiles.ihe.net/ITI/MHD/ITI-67.html)
- [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html)
- [Actors and Transactions](actors.html)
