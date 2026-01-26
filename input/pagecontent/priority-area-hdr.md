{% include variable-definitions.md %}
This section defines the API requirements for EHR systems that provide EEHRxF data that conforms to the {{hl7EuHdr}} content profile.

### Actors

Hospital Discharge Reports can be accessed via document exchange.

| Actor | Description | CapabilityStatement |
|-------|-------------|---------------------|
| Document Consumer | Retrieves HDR documents | [EEHRxF Document Consumer](CapabilityStatement-EEHRxF-DocumentConsumer.html) |
| Document Access Provider | Serves HDR documents | [EEHRxF Document Responder](CapabilityStatement-EEHRxF-DocumentAccessProvider.html) |

### Document Exchange

For document-based access, use the [Document Exchange](document-exchange.html) transactions.

The Hospital Discharge Report is differentiated via the following DocumentReference fields:
- **type**: `18842-5` (Discharge summary)
- **category**: `SUMMARIES` (XDS ClassCode)

### Example Query

```
GET /DocumentReference?patient=123&type=http://loinc.org|18842-5&status=current
```

See [Example: Retrieve A European Patient Summary](example-patient-summary.html) for a complete workflow example (the pattern is identical).
