{% include variable-definitions.md %}
This section defines the API requirements for EHR systems that provide EEHRxF data that follows the {{hl7EuEps}}.

### Actors

European Patient Summary data can be accessed using either document or resource exchange patterns:

| Actor | Description | CapabilityStatement |
|-------|-------------|---------------------|
| Document Consumer | Retrieves EPS documents | [EEHRxF Document Consumer](CapabilityStatement-EEHRxF-DocumentConsumer.html) |
| Document Access Provider | Serves EPS documents | [EEHRxF Document Responder](CapabilityStatement-EEHRxF-DocumentResponder.html) |
| Resource Consumer | Queries EPS resources | [EEHRxF Resource Consumer](CapabilityStatement-EEHRxF-ResourceConsumer.html) |
| Resource Access Provider | Serves EPS resources | [EEHRxF Resource Access Provider](CapabilityStatement-EEHRxF-ResourceAccessProvider.html) |

### Document Exchange

For document-based access, use the [Document Exchange](document-exchange.html) transactions:

```
GET /DocumentReference?patient=123&type=http://loinc.org|60591-5&status=current
```

DocumentReference resources use:
- **type**: `60591-5` (Patient summary Document)
- **category**: `SUMMARIES` (XDS ClassCode)

### Resource Exchange

For resource-based access, use the [Resource Access](resource-access.html) transactions to query individual clinical resources from the Patient Summary.

### Content Profile

EPS documents and resources SHALL conform to the {{hl7EuEps}} content profiles.
