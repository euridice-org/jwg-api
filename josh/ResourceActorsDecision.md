# Resource Exchange Decisions

Resource PUSH is much more complex than document push. For a server to accepting a unsolicited PUSH resource coming from an external source in a similar way to documents, this server needs to expect this data is coming, have a way to enforce validation rules on this data to avoid accepting invalid or imcomplete data, and potentialy have a user check and reconcile this data against other sources. These considerations are likely different per resource. For an example of how complex this can get for just a Prescription workflow, see the IHE MPD specification.

Instead of supporting a generic resource push, system acting as a Resource Access Provider may get resources by:
(1) Generating it's own resource internally from user entered data, effectively grouping with an implied Resource Producer actor. 
(2) Consuming external resources by grouping with a Resource Consumer Actor and querying another Resource Access Provider
(3) Extracting resources from documents received when grouped with an MHD Document Responder (part of the Document Access Provider actor)
(4) Receiving this data via another exchange method and translating it to FHIR resources. 



### Option A: Resource access as optional extra

**Producer:** Actor Producing EEHRxF data. May be grouped with access provider, in which case all these transactions are internalized.

MHD Document Source (R) - Create Documents and push to Access Providers
    Provide Document Bundle [ITI-65]
IUA Authorization Client - Request Authorization from Access Provider(or Provider's Auth server) for permission to push a document, use this authorization.
    Get Access Token [ITI-71]
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Consumer - Match to AP's patient record (in order to push a document to that record)
    Mobile Patient Demographics Query [ITI-78]


**Access Provider:** Actor serving queries, Providing Access to EEHRxF Data.

MHD Document Responder - Offer access to Documents 
    Find Document References [ITI-67]
    Retrieve Document [ITI-68]
MHD Document Recipient - Accept Documents pushed from producers
    Provide Document Bundle [ITI-65]
IUA Authorization Server - Provides authorization for access resource server (note: may be external, in which case it's useful to add metadata)
    Get Access Token [ITI-71]
IUA Resource Server - Enforces access tokens on all REST endpoints.
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Supplier - Support resolution to patient AP's patient record (ex: Via National Identifier)
    Mobile Patient Demographics Query [ITI-78]
**Optional: QEDm Clinical Data Source (note: QEDm assumes source = system serving FHIR resource queries).**
    Mobile Query Existing Data [PCC-44]
    Alt: International Patient Access Server


**Consumer:** Actor Consuming, or Receiving EEHRxF Data

MHD Document Consumer - Consumes documents from an 
    Find Document References [ITI-67]
    Retrieve Document [ITI-68]
IUA Authorization Client - Request Authorization from Access Provider (or AP's Auth server) for permission to access data, use this authorization.
    Get Access Token [ITI-71]
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Consumer - Match to AP's patient record (in order to retrieve data)
    Mobile Patient Demographics Query [ITI-78]
**Optional: QEDM Clinical Data Consumer**
    Mobile Query Existing Data [PCC-44]
    Alt: International Patient Access Client



### Option B: Separate Document and Resource Actors 



Document Exchange:

**Document Producer:** Actor Producing EEHRxF data. May be grouped with access provider, in which case all these transactions are internalized.

MHD Document Source (R) - Create Documents and push to Access Providers
    Provide Document Bundle [ITI-65]
IUA Authorization Client - Request Authorization from Access Provider(or Provider's Auth server) for permission to push a document, use this authorization.
    Get Access Token [ITI-71]
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Consumer - Match to AP's patient record (in order to push a document to that record)
    Mobile Patient Demographics Query [ITI-78]


**Document Access Provider:** Actor serving queries, Providing Access to EEHRxF Data.

MHD Document Responder - Offer access to Documents 
    Find Document References [ITI-67]
    Retrieve Document [ITI-68]
MHD Document Recipient - Accept Documents pushed from producers
    Provide Document Bundle [ITI-65]
IUA Authorization Server - Provides authorization for access resource server (note: may be external, in which case it's useful to add metadata)
    Get Access Token [ITI-71]
IUA Resource Server - Enforces access tokens on all REST endpoints.
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Supplier - Support resolution to patient AP's patient record (ex: Via National Identifier)
    Mobile Patient Demographics Query [ITI-78]

**Document Consumer:** Actor Consuming, or Receiving EEHRxF Data

MHD Document Consumer - Consumes documents from an 
    Find Document References [ITI-67]
    Retrieve Document [ITI-68]
IUA Authorization Client - Request Authorization from Access Provider (or AP's Auth server) for permission to access data, use this authorization.
    Get Access Token [ITI-71]
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Consumer - Match to AP's patient record (in order to retrieve data)
    Mobile Patient Demographics Query [ITI-78]


**Resource Access Provider:** Actor serving queries, Providing Access to EEHRxF Data. Similar to IPA Server / QEDM Data Source

Note: Where is Resource Producer?  The implied Resource Producer actor and it's interactions with the Resource Access Provider are not in scope here. These interactions are complex for reasons discussed above. It is assumed the system acting as a Resource Access Provider has access to resources, either by (1) generating it's own resource internally, effectively grouped with an implied Resource Producer actor (2) Extracting resources from documents received when acting as a MHD Document Responder (part of the Document Access Provider actor) or (3) Receiving this data via another exchange method and translating it to FHIR resources. 


IUA Authorization Server - Provides authorization for access resource server (note: may be external, in which case it's useful to add metadata)
    Get Access Token [ITI-71]
IUA Resource Server - Enforces access tokens on all REST endpoints.
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Supplier - Support resolution to patient AP's patient record (ex: Via National Identifier)
    Mobile Patient Demographics Query [ITI-78]
**QEDm Clinical Data Source** (note: QEDm assumes source = system serving FHIR resource queries).
    Mobile Query Existing Data [PCC-44]
    Alt: International Patient Access Server


**Resource Consumer:** Actor Consuming, or Receiving EEHRxF Data. Similar to IPA Client / QEDM Clinical Data Consumer

IUA Authorization Client - Request Authorization from Access Provider (or AP's Auth server) for permission to access data, use this authorization.
    Get Access Token [ITI-71]
    Incorporate Access Token [ITI-72]
PDQm Patient Demographics Consumer - Match to AP's patient record (in order to retrieve data)
    Mobile Patient Demographics Query [ITI-78]
**QEDM Clinical Data Consumer**
    Mobile Query Existing Data [PCC-44]
    Alt: International Patient Access Client


## Conclusion

Option B, with an example grouping with Document actors, is probably the best. Systems may just do resource exchange, and the conformance turns into a mess if resource access is always part of document exchange.