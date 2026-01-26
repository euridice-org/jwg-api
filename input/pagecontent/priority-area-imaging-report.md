{% include variable-definitions.md %}
This section defines the API requirements for EHR systems that provide diagnostic imaging reports conforming to the [EU Imaging Report IG](https://hl7.eu/fhir/imaging-r4).

### Actors

Imaging Reports can be accessed via document exchange.

| Actor | Description | CapabilityStatement |
|-------|-------------|---------------------|
| Document Consumer | Retrieves imaging reports | [EEHRxF Document Consumer](CapabilityStatement-EEHRxF-DocumentConsumer.html) |
| Document Access Provider | Serves imaging reports | [EEHRxF Document Responder](CapabilityStatement-EEHRxF-DocumentAccessProvider.html) |

### Document Exchange

For document-based access, use the [Document Exchange](document-exchange.html) transactions.

The Imaging Report is differentiated via the following DocumentReference fields:
- **type**: `68604-8` (Radiology Diagnostic study note)
- **category**: `REPORTS` (XDS ClassCode)

### Example Query

```
GET /DocumentReference?patient=123&type=http://loinc.org|68604-8&status=current
```

See [Example: Retrieve A European Patient Summary](example-patient-summary.html) for a complete workflow example (the pattern is identical).

### Related

For imaging study manifests (DICOM image references), see [Imaging Manifest](priority-area-imaging-manifest.html).
