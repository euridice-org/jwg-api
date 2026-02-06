### Overview

Patient lookup using IHE PDQm (Patient Demographics Query for Mobile). This transaction allows consumers to locate the correct Patient resource on a provider before querying for health information.

This specification inherits directly from [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html) with one constraint: the `identifier` search parameter is required for patient search. 

Patient.Search should be used when a patient identifier (e.g. National ID) is available and trusted. If an identifier is not available, Patient.$match should be used to perform a demographics search operation.

### Actor Roles

| Actor | Role |
|-------|------|
| Consumer | Find a patient record in the Access Provider system based on identifier or demographics information |
| Document/Resource Access Provider | Return its patient record information based on identifier or demographics queries from a consumer. |

### Transaction Options

Providers support one or both of the following patient identification mechanisms:

#### 1. Mobile Patient Demographics Query [ITI-78] (Required)

Patient search using the [IHE PDQm ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html) transaction. This specification constrains ITI-78 to require the `identifier` parameter.

```
GET [base]/Patient?identifier=[system]|[value]
```

This approach covers the majority of European use cases where patient identifiers (MRN, national ID) are available.

**Required Search Parameters:**

| Parameter | Type | Expectation | Description |
|-----------|------|-------------|-------------|
| identifier | token | SHALL | Patient identifier (e.g., national ID, MRN) |

**Optional Search Parameters:**

Providers MAY support additional PDQm search parameters per [ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html):

| Parameter | Type | Expectation | Description |
|-----------|------|-------------|-------------|
| family | string | SHOULD | Patient family name |
| given | string | SHOULD | Patient given name |
| birthdate | date | SHOULD | Patient date of birth |
| _id | token | SHOULD | Patient logical ID |


#### 2. Patient Demographics Match [ITI-119] (Optional)

Patient $match operation for fuzzy demographic matching using [IHE PDQm ITI-119](https://profiles.ihe.net/ITI/PDQm/ITI-119.html):

```
POST [base]/Patient/$match
```

The request body contains a Parameters resource with demographic information. The server responds with candidate matches and confidence scores.

This option is used when identifier-based lookup is not possible (e.g., cross-border scenarios where the consumer does not have the patient's local identifier).

### Provider Requirements

| Actor | Transaction | Optionality |
|-------|-------------|-------------|
| Consumer | Mobile Patient Demographics Query [ITI-78] | O |
|  | Patient Demographics Match [ITI-119] | O |
| Provider | Mobile Patient Demographics Query [ITI-78] | R |
|  | Patient Demographics Match [ITI-119] | O |

Providers are RECOMMENDED to implement the $match operation in addition to the patient search for scenarios where identifier is not available.

> **Open Issue #2**: We are seeking input on this patient lookup approach. See [Patient Lookup Strategy](open-issues.html#issue-2-patient-lookup-strategy) for discussion.

### Authorization

When grouped with IUA actors:
- Consumer uses Get Access Token [ITI-71] with appropriate scope
- Provider enforces authorization via Incorporate Access Token [ITI-72]

### Example

```mermaid
sequenceDiagram
    participant Consumer
    participant Provider as Access Provider

    Consumer->>Provider: GET /Patient?identifier=urn:oid:...|12345
    Provider-->>Consumer: Bundle with Patient resource(s)

    Note over Consumer: Consumer uses Patient.id<br/>for subsequent queries
```

*Patient lookup applies to both [Document Exchange](document-exchange.html) and [Resource Access](resource-access.html) patterns.*

### References

- [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html)
    - [ITI-78 Mobile Patient Demographics Query](https://profiles.ihe.net/ITI/PDQm/ITI-78.html)
    - [ITI-119 Patient Demographics Match](https://profiles.ihe.net/ITI/PDQm/ITI-119.html)
- [FHIR Patient.$match](https://hl7.org/fhir/R4/patient-operation-match.html)
