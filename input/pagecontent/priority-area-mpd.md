{% include variable-definitions.md %}
This section defines the API consideration for ePrescription and eDispensation exchange.

The content is defined by the {{hl7EuMpd}} profile.

### Exchange Pattern

ePrescription/eDispensation uses workflow transactions defined by {{iheMPD}}, not document exchange. This differs from other priority categories.

### Resource Access

This IG covers resource-based access to medication data via [Resource Access](resource-access.html):
- MedicationRequest
- MedicationDispense
- MedicationStatement

> **Open Issue #11**: This IG covers medication resource access (reading MedicationRequest, etc.), while prescription workflow orchestration is handled by IHE MPD. See [MPD Workflow vs MedicationRequest Resource Access](open-issues.html#issue-11-mpd-workflow-vs-medicationrequest-resource-access) for discussion on this scope boundary.
