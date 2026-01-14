Resource exchange between a Resource Producer and a Resource Access Provider is more complex than document publishing.

Resources are not self-contained like documents. They are atomic pieces of data with cross-references to other resources. A naive POST of a resource to a FHIR server is not sufficient—additional steps are required (for example, resolving the Medication being prescribed before submitting a MedicationRequest).

Semantics also vary by resource type and workflow. Exchange patterns are often different per resource. For examples of this complexity, see [IHE MPD](https://profiles.ihe.net/PHARM/MPD/index.html) for a prescription workflow.

### Current Scope

For this version of the implementation guide, instead of supporting a generic resource PUSH, we take as a precondition that a system acting as a Resource Access Provider already has access to resources. It may have gained access to these resources by:

1. Creating resources from user-entered data, effectively grouping with an implied *Resource Producer* actor
2. Consuming external resources by grouping with a *Resource Consumer* actor and querying another Resource Access Provider
3. Extracting resources from documents received when grouped with an MHD Document Responder (part of the *Document Access Provider* actor)
4. Receiving data via another exchange method and translating it to FHIR resources

This allows us to focus on specifying resource query interactions, which can be more easily generalized across resource types.

### Challenges with Resource PUSH

- **Resolving References** - How to handle pointers that are not contained within the payload
- **Unsolicited Data** - For a server to accept an unsolicited PUSH resource from an external source, it needs to expect this data
- **Reconciliation** - The receiving server needs validation rules to avoid accepting invalid or incomplete data, potentially including user review before allowing it into the patient chart

### Possible Future Approaches

We acknowledge that the community would benefit from resource-based exchange methods other than queries. The following patterns could address these needs in future versions:

- **FHIR Subscriptions / Notified-Pull** - Used in the Netherlands; shares the same query interaction pattern
- **Use-Case Specific IGs** - Like IHE MPD, developed for specific resource sets

Other ideas for potential approaches are welcome.
