{% include variable-definitions.md %}
This section defines the API requirements for EHR systems that provide laboratory reports conforming to the {{hl7EuLabs}} content profile.

### Actors

Laboratory Reports can be accessed via document exchange.

| Actor | Description | CapabilityStatement |
|-------|-------------|---------------------|
| Document Consumer | Retrieves laboratory reports | [EEHRxF Document Consumer](CapabilityStatement-EEHRxF-DocumentConsumer.html) |
| Document Access Provider | Serves laboratory reports | [EEHRxF Document Responder](CapabilityStatement-EEHRxF-DocumentAccessProvider.html) |

### Document Exchange

For document-based access, use the [Document Exchange](document-exchange.html) transactions.

The Laboratory Report is differentiated via the following DocumentReference fields:
- **type**: `11502-2` (Laboratory report)
- **category**: `REPORTS` (XDS ClassCode)

### Example Query

```
GET /DocumentReference?patient=123&type=http://loinc.org|11502-2&status=current
```

See [Example: Retrieve A European Patient Summary](example-patient-summary.html) for a complete workflow example (the pattern is identical).
