{% include variable-definitions.md %}
This section defines the API requirements for EHR systems that provide imaging study manifests (references to DICOM imaging studies).

For detailed content profiles, see the [EU Imaging Study Manifest IG](https://hl7.eu/fhir/imaging-manifest-r4/).

### Actors

Imaging Manifests can be accessed via document exchange.

| Actor | Description | CapabilityStatement |
|-------|-------------|---------------------|
| Document Consumer | Retrieves imaging manifests | [EEHRxF Document Consumer](CapabilityStatement-EEHRxF-DocumentConsumer.html) |
| Document Access Provider | Serves imaging manifests | [EEHRxF Document Responder](CapabilityStatement-EEHRxF-DocumentAccessProvider.html) |

### Document Exchange

For document-based access, use the [Document Exchange](document-exchange.html) transactions.

The Imaging Manifest is differentiated via the following DocumentReference fields:
- **category**: `Medical-Imaging` ([EHDS Priority Category](CodeSystem-eehrxf-document-priority-category-cs.html))
- **type**: 19005-8

### Example Query

```
GET /DocumentReference?patient=123&category=http://hl7.eu/fhir/eu-health-data-api/CodeSystem/eehrxf-document-priority-category-cs|Medical-Imaging&status=current
```

> **Note:** Both imaging reports and imaging manifests use the `Medical-Imaging` category. To retrieve only manifests, filter by `type` or `formatCode`.

See [Example: Retrieve A European Patient Summary](example-patient-summary.html) for a complete workflow example (the pattern is similar, with different documentReference parameters).


### IHE MADO

DICOM Image access is in scope for EHDS and is covered by the EURIDICE MADO profile. It is supported by MHD-defined delivery of the imaging manifest, but the image access methods are handled within the MADO profile and not in this IG.
