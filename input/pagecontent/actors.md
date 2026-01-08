The actor model defined here is an orchestration of existing IHE actors and specifications, combined together into high-level composite actors. Actors and transactions are inherited from dependent IHE profiles, and those actors are stacked, constrained and potentially modified.

This is similar to the approach taken in the MHDS specification, but with a more narrow subset of specifications fit to the european situation.

### Relevant Specifications:

- Client App and User Authorization
  - [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html) - Defines authorization and access control actors and mechanisms. We use the actors and transactions model.
  - [HL7 SMART Backend Services](https://hl7.org/fhir/smart-app-launch/) - Defines authorization in FHIR. We use the SMART Backend Services profile for system-system authnz, and FHIR scopes.
- Patient Identity Matching
  - [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html) - Defines how a client can perform patient lookup given demographics against a server.
  - [IHE PIXm](https://profiles.ihe.net/ITI/PIXm/index.html) - Defines how a client can perform patient lookup given only identifiers.
- Document Exchange
  - [IHE MHD](https://profiles.ihe.net/ITI/MHD/) - Defines exchange of Documents, which we use to exchange FHIR document content. (note: no XDS dependencies)
- Resource Exchange
  - [HL7 International Patient Access](https://hl7.org/fhir/uv/ipa/) - Defines how an application can access FHIR information using SMART authorization and resource access.
  - [IHE QEDm](https://profiles.ihe.net/PCC/QEDm/index.html) - Defines how a client can query for existing FHIR resources from a FHIR server.
- Foundational
  - [IHE Consistent Time](https://profiles.ihe.net/ITI/TF/Volume1/ch-7.html) - Defines the use of Network Time Protocol (NTP) to provide consistent time across systems.
  - [IHE ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-8.html) - Defines secure communication and audit logging requirements for healthcare systems.
    - [RESTful ATNA](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf) - Defines the use of FHIR AuditEvent rather than the legacy audit log format.

### Document Exchange

Document exchange is defined with 3 actors:

<div style="text-align: center;">
{% include img.html img="docExchange_1.png" caption="Figure: Document Exchange Actors" %}
</div>

<a name="document-producer"></a>
1. **Document Producer (client)** - Produces EEHRxF FHIR Documents, publishes those documents to a Document Access Provider. Can be grouped with Access Provider, in which case the publishing transactions are internalized.

<a name="document-access-provider"></a>
2. **Document Access Provider (server)** - Provides Access to EEHRxF FHIR Documents by offering an API which Document Consumer clients can query. Receives Documents from Document Producer (If not grouped with Document Producer).

<a name="document-consumer"></a>
3. **Document Consumer (client)** - Consumes EEHRxF FHIR documents by querying a Document Access Provider.

These composite actors inherit existing actors from the IUA, PDQm, and MHD specifications:

<figure>
{%include simplified-document-actors.svg%}
<figcaption><b>Figure: Document Exchange - Actor Groupings</b></figcaption>
</figure>
<br clear="all">

**Document Producer**

- [IUA Authorization Client](https://profiles.ihe.net/ITI/IUA/index.html#34111-authorization-client)
- [PDQm Patient Demographics Consumer](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsConsumerQuery.html))
- [PIXm Patient Identifier Cross-reference Consumer](https://profiles.ihe.net/ITI/PIXm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PIXm/CapabilityStatement-IHE.PIXm.Consumer.html))
- [MHD Document Source](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentSource.html))

**Document Access Provider**

- [IUA Authorization Server](https://profiles.ihe.net/ITI/IUA/index.html#34112-authorization-server)
- [IUA Resource Server](https://profiles.ihe.net/ITI/IUA/index.html#34113-resource-server)
- [PDQm Patient Demographics Supplier](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsSupplier.html))
- [PIXm Patient Identifier Cross-reference Manager](https://profiles.ihe.net/ITI/PIXm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PIXm/CapabilityStatement-IHE.PIXm.Manager.html))
- [MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentRecipient.html))
- [MHD Document Responder](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentResponder.html))

**Document Consumer**

- [IUA Authorization Client](https://profiles.ihe.net/ITI/IUA/index.html#34111-authorization-client)
- [PDQm Patient Demographics Consumer](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsConsumerQuery.html))
- [PIXm Patient Identifier Cross-reference Consumer](https://profiles.ihe.net/ITI/PIXm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PIXm/CapabilityStatement-IHE.PIXm.Consumer.html))
- [MHD Document Consumer](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentConsumer.html))

This leads to the following required transactions between these actors:

<figure>
{%include document-transactions-sequence.svg%}
<figcaption><b>Figure: Document Exchange Transactions</b></figcaption>
</figure>
<br clear="all">


See the following functional pages for detailed transaction information:
- [Authorization](authorization.html) - Authentication and authorization flows
- [Patient Match](patient-match.html) - Patient identification transactions
- [Document Exchange](document-exchange.html) - Document query and retrieval transactions

This can be combined with content profiles define by each EHDS Priority Category, for those categories that are primarily represented as a FHIR Document. For example, a system can be a **Lab Result Document Producer**, a **Patient Summary Document Consumer**, or a **Imaging Manifest Document Access Provider**. See Content Library


### Resource Exchange

It is also useful in many cases to transact with individual FHIR resources (note: ref other page). For this purpose, two resource-based actors are defined:

<div style="text-align: center;">
{% include img.html img="resExchange_1.png" caption="Figure: Resource Exchange Actors" %}
</div>


<a name="resource-access-provider"></a>
4. **Resource Access Provider (server)** - A FHIR server providing access to FHIR resources by hosting search + read query API's.

<a name="resource-consumer"></a>
5. **Resource Consumer (client)** - A FHIR client that consumes external FHIR resources by querying a Resource Access Provider.

<details>
<summary><i>Note: What about Resource Producer?</i></summary>

Resource exchange is more complex than document publication, and in many cases has resource and use-case specific considerations. Within the scope of this version of the IG, we assume a precondition that the Resource Access Provider has access to resources and focus on defining how the Resource Access Provider enables a consumer to search and read those resources. For more details and possible approaches, see the [Resource Exchange](resourceExchange.html) page.

</details>


These composite actors inherit existing actors from the IUA, PDQm, and QEDm/IPA specifications:

<figure>
{% include simplified-resource-actors.svg%}
<figcaption><b>Figure: Resource Exchange - Actor Groupings</b></figcaption>
</figure>
<br clear="all">

**Resource Access Provider**

- [IUA Authorization Server](https://profiles.ihe.net/ITI/IUA/index.html#34112-authorization-server)
- [IUA Resource Server](https://profiles.ihe.net/ITI/IUA/index.html#34113-resource-server)
- [PDQm Patient Demographics Supplier](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsSupplier.html))
- [PIXm Patient Identifier Cross-reference Manager](https://profiles.ihe.net/ITI/PIXm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PIXm/CapabilityStatement-IHE.PIXm.Manager.html))
- Resource Access
  - [Clinical Data Source](https://profiles.ihe.net/PCC/QEDm/volume-1.html#actors-and-transactions) ([CapabilityStatement](https://profiles.ihe.net/PCC/QEDm/CapabilityStatement-IHE.QEDm.Clinical-Data-Source.html))
  - [HL7 International Patient Access Server](https://build.fhir.org/ig/HL7/fhir-ipa/index.html) ([CapabilityStatement](https://build.fhir.org/ig/HL7/fhir-ipa/CapabilityStatement-ipa-server.html)

**Resource Consumer**

- [IUA Authorization Client](https://profiles.ihe.net/ITI/IUA/index.html#34111-authorization-client)
- [PDQm Patient Demographics Consumer](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsConsumerQuery.html))
- [PIXm Patient Identifier Cross-reference Consumer](https://profiles.ihe.net/ITI/PIXm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PIXm/CapabilityStatement-IHE.PIXm.Consumer.html))
- Resource Access
  - [Clinical Data Consumer](https://profiles.ihe.net/PCC/QEDm/volume-1.html#actors-and-transactions) ([CapabilityStatement](https://profiles.ihe.net/PCC/QEDm/CapabilityStatement-IHE.QEDm.Clinical-Data-Consumer.html))
  - [HL7 International Patient Access Client](https://profiles.ihe.net/ITI/PIXm/volume-1.html) ([CapabilityStatement](https://build.fhir.org/ig/HL7/fhir-ipa/CapabilityStatement-ipa-client.html))

This leads to the following required transactions between these actors:

<figure>
{%include resource-transactions-sequence.svg%}
<figcaption><b>Figure: Resource Exchange - Actor Groupings</b></figcaption>
</figure>
<br clear="all">






### Example Groupings


<div style="text-align: center;">
{% include img.html img="ExGroup_Doc.png" caption="Figure: Example Grouping - Document" %}
</div>

<div style="text-align: center;">
{% include img.html img="ExGroup_Group.png" caption="Figure: Example Grouping - Group" %}
</div>


### Use with Other IHE Profiles

Within this implemenation guide, we focus on the generalized document and resource access transactions - but a similar layered approach can be taken with other use case-specific IHE profiles.

IUA + PDQM actors can be considered an **API Base**, since most interoperabiliy use cases have a shared need for authorization and patient identification.

We leave the details of implementation up to individual priority category area, but here are some examples of how this could be done:

### ePrescription and eDispenation with IHE MPD
For example, the [IHE MPD specification actors](https://profiles.ihe.net/PHARM/MPD/actors-transactions.html) could be stacked in a similar way to accomplish a prescription workflow:


### Image Access with IHE MADO


In the imaging priority category, IHE-RAD (MADO) transactions are used to provide access to DICOM images.

The IHE MADO Profile starts with a precondition that an Image Consumer has gained access to a manifest. This could be accomplished by the Image Consumer bundling with the Document Consumer actor specified here - and querying a Document Access Provider for an image manifest. Then, the Image Consumer uses the information in the Image Manifest to construct a WADO-RS query to the Imaging Source (note: Auth could get complicated here).

A composite actor could be created inheriting Document Consumer + MADO Image Consumer.

