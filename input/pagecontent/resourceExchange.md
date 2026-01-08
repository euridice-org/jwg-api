Resource exchange, or the exchange of FHIR resources between a Resource Producer and a Resource Access provider is more complex than document publishing. One reason is that resources are not self-contained like a document is: they are a single atomic piece of data with many cross-links. So a naive POST of a resource to a FHIR server is not sufficient - additional pre-steps are required (For example, to resolve the Medication being prescribed before submitting a medicationRequest).  

Another complexity with resource exchange is that semantics and exchange patterns are likely different per resource. For an example of how complex this can get for just a Prescription workflow, see the IHE MPD specification. For another, the Clinical Order Workflow IG.

For this version of the implementation guide, instead of supporting a generic resource PUSH - we take as a precondition that a system acting as a Resource Access Provider already has access to resources. It may have gained access to these resources by:
(1) Generating it's own resource internally from user entered data, effectively grouping with an implied Resource Producer actor. 
(2) Consuming external resources by grouping with a Resource Consumer Actor and querying another Resource Access Provider
(3) Extracting resources from documents received when grouped with an MHD Document Responder (part of the Document Access Provider actor)
(4) Receiving this data via another exchange method and translating it to FHIR resources. 

This allows us to focus in this IG on specify resource query interactions, which to some degree can be more easily generalized across resources (see US core, ...).

Challenges introduced with Resource PUSH:
- Resolving References: How to deal with pointers that are not contained within the payload.
- Unsolicited Data: For a server to accepting a unsolicited PUSH resource coming from an external source in a similar way to documents, this server needs to expect this data is coming. 
- Reconciliation: The receiving server needs a way to enforce validation rules on this data to avoid accepting invalid or imcomplete data, potentialy including user checking and reconciling this data against other sources before allowing it into the patient chart.


### Possible Approaches

We acklowledge that the community would benefit from resource-based exchange methods other than queries. The following patterns or a combination therof could make progress in addressing these needs, and could be included in a future version of this implementation guide or addressed in parallel with separately developed implementation guides.

* FHIR Subscriptions, or the Notified-Pull pattern used in the Netherlands can be used. This has the benefit of sharing the same query interaction.
* Use-Case Specific Implementation Guides like IHE MPD for each set of resources.

Other ideas for potential approachecs to address these challenges are welcome.