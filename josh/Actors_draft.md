Note: Moved to /input/pagecontent/actors.md

# Actors and Transations

This is an orchestration profile, meaning  actors and transactions are inhereted from dependent IHE profiles, and those actors are stacked, constrained and potentially modified. 

This is similar to the approach taken in the MHDS specification, but with a more narrow subset of specifications fit to the european situation.

Relevant Specifications:
- MHD - Defines exchange of Documents, which we use to exchange FHIR document content. (note: no XDS dependancies)
- IUA - Defines authorization and access control actors and mechanisms. We use the actor model.
- SMART - Defines authorization in FHIR. We use the SMART backend profile for system authnz. 
- PDQm - Defines how a client can perform patient lookup against a server. 
(resource access tbd. Candidates: IHE QEDm for actors, IPA for resource search behaviour)

## Actors

**Document Exchange:**
1. **Document Producer (client)** - Producer of EEHRxF FHIR Documents, publishes those documents to a Document Access Provider. Can be grouped with Access Provider, in which case the publishing transactions are internalized.
    - [IHE MHD Document Source](https://profiles.ihe.net/ITI/MHD/).
2. **Document Access Provider (server)** - Provides Access to EEHRxF FHIR Documents by offering an API which Document Consumer clients can query. Receives Documents from Document Producer (If not grouped with Document Producer) 
    - [IHE MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/) - 
    - [IHE MHD Document Responder](https://profiles.ihe.net/ITI/MHD/)
3. **Document Consumer (client)** - based on [IHE MHD Document Consumer](https://profiles.ihe.net/ITI/MHD/)

**Resource Exchange:**
4. Resource Access Provider (server) - based on [IHE QEDm Clinical Data Source](https://profiles.ihe.net/PCC/QEDm/)
5. Resource Consumer (client) - based on [IHE QEDm Clinical Data Consumer](https://profiles.ihe.net/PCC/QEDm/)




### Resource Production

Resource PUSH is much more complex than document push. For a server to accepting a unsolicited PUSH resource coming from an external source in a similar way to documents, this server needs to expect this data is coming, have a way to enforce validation rules on this data to avoid accepting invalid or imcomplete data, and potentialy have a user check and reconcile this data against other sources. These considerations are likely different per resource. For an example of how complex this can get for just a Prescription workflow, see the IHE MPD specification.

Instead of supporting a generic resource push, system acting as a Resource Access Provider may get resources by:
(1) Generating it's own resource internally from user entered data, effectively grouping with an implied Resource Producer actor. 
(2) Consuming external resources by grouping with a Resource Consumer Actor and querying another Resource Access Provider
(3) Extracting resources from documents received when grouped with an MHD Document Responder (part of the Document Access Provider actor)
(4) Receiving this data via another exchange method and translating it to FHIR resources. 


Resource Production
Note: The implied Resource Producer actor, and it's interactions with the Resource Access Provider are not in scope here. These interactions are complex. It is assumed the system acting as a Resource Access Provider has access to resources, either by (1) generating it's own resource internally, effectively grouped with an implied Resource Producer actor (2) Extracting resources from documents received when acting as a MHD Document Responder (part of the Document Access Provider actor) or (3) Receiving this data via another exchange method and translating it to FHIR resources. 


## Example Groupings

[diagrams]


