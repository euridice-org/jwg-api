# Document Exchange
TODO: AI generated, seems mostly right but verify
## Overview

Document exchange using IHE MHD (Mobile Health Documents).

## Actors

- **Document Source** (Producer): Publishes documents
- **Document Recipient** (Access Provider): Receives documents
- **Document Responder** (Access Provider): Serves document queries
- **Document Consumer:** Queries and retrieves documents

## Transactions

**ITI-65:** Provide Document Bundle (Publish)
- Document Source → Document Recipient

**ITI-67:** Find Document References (Search)
- Document Consumer → Document Responder

**ITI-68:** Retrieve Document (Retrieve)
- Document Consumer → Document Responder

## Publish Documents (ITI-65)

Document Source submits DocumentReference + Binary to Document Recipient.

Publication pattern: MHD Provide Document Bundle (transaction bundle)

### Scope Enforcement
- `system/DocumentReference.c`
- `system/Binary.c`

### Envelope Validation
- `subject` references valid Patient
- `attachment.contentType` in allowlist
- `type`/`format` bound to allowed value sets per priority category
- `author` present
- `custodian` present

### Content Registry Enforcement
Server rejects publications where DocumentReference.type/format/mime not allowed for declared priority category.

## Search Documents (ITI-67)

### Required Parameters
- `patient` (required)
- `_count` (for paging)

### Optional Parameters
- `type`, `date`, `category`, `format`, `status`

### Paging
Response includes `link` with `relation="next"` when more results available.

## Retrieve Document (ITI-68)

```
GET /Binary/{id}
```

Response `Content-Type` must match DocumentReference.content.attachment.contentType.

### Supported Formats
Per priority category:
- `application/fhir+json` (FHIR Bundle)
- `application/pdf`
- `text/xml` (CDA)

## DocumentReference Profile

Inherits from IHE MHD Comprehensive DocumentReference.

Additional constraints:
- Priority category binding
- Content registry value sets
- Required metadata elements

## See Also

- [IHE MHD](https://profiles.ihe.net/ITI/MHD/)
- [ITI-65 Provide Document Bundle](https://profiles.ihe.net/ITI/MHD/ITI-65.html)
- [ITI-67 Find Document References](https://profiles.ihe.net/ITI/MHD/ITI-67.html)
- [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html)
