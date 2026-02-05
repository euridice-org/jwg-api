The actor model defined here is an orchestration of existing IHE actors and specifications, combined together into high-level composite actors. Actors and transactions are inherited from dependent IHE profiles, and those actors are stacked, constrained and potentially modified.

This is similar to the approach taken in the MHDS specification, but with a more narrow subset of specifications fit to the European situation.

### Relevant Specifications:

- Authorization
  - [HL7 SMART Backend Services](https://hl7.org/fhir/smart-app-launch/) - Defines authorization in FHIR. We use the SMART Backend Services profile for system-system authnz, and FHIR scopes.
  - [IHE IUA](https://profiles.ihe.net/ITI/IUA/index.html) - Defines authorization and access control actors and mechanisms. We use the actors and transactions model.
- Patient Identity Matching
  - [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html) - Defines how a client can perform patient lookup given demographics against a server.
- Document Exchange
  - [IHE MHD](https://profiles.ihe.net/ITI/MHD/) - Defines exchange of Documents, which we use to exchange FHIR document content.
- Resource Exchange
  - [HL7 International Patient Access (IPA)](https://hl7.org/fhir/uv/ipa/) - Defines how an application can access FHIR information using SMART authorization and resource access. IPA is the primary reference for resource access patterns.
  - [IHE QEDm](https://profiles.ihe.net/PCC/QEDm/index.html) - Defines how a client can query for existing FHIR resources from a FHIR server. Referenced where compatible with IPA.
- Foundational
  - [IHE Consistent Time](https://profiles.ihe.net/ITI/TF/Volume1/ch-7.html) - Defines the use of Network Time Protocol (NTP) to provide consistent time across systems.
  - [IHE ATNA](https://profiles.ihe.net/ITI/TF/Volume1/ch-8.html) - Referenced for secure transport requirements. See the [TLS 1.2 Floor Option](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html#9.3.1.2) for TLS requirements.

### Document Exchange

Document exchange is defined with 3 actors:

<div style="text-align: center;">
{% include img.html img="docExchange_1.png" caption="Figure: Document Exchange Actors" %}
</div>

<a name="document-publisher"></a>
1. **Document Publisher (client)** - Produces EEHRxF FHIR Documents, publishes those documents to a Document Access Provider. Can be grouped with Access Provider, in which case the publishing transactions are internalized.

<a name="document-access-provider"></a>
2. **Document Access Provider (server)** - Provides access to EEHRxF FHIR Documents by offering query APIs to Document Consumers. See **Document Submission Option** below for systems that accept document publication from external producers.

<a name="document-consumer"></a>
3. **Document Consumer (client)** - Consumes EEHRxF FHIR documents by querying a Document Access Provider.

These composite actors inherit existing actors from the IUA, PDQm, and MHD specifications:

<div style="text-align: center;">
{% include img.html img="docExchange_2.png" caption="Figure: Document Exchange - Actor Groupings" %}
</div>

**Document Publisher**

- [IUA Authorization Client](https://profiles.ihe.net/ITI/IUA/index.html#34111-authorization-client)
- [PDQm Patient Demographics Consumer](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsConsumerQuery.html))
- [MHD Document Source](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) with [Simplified Publish Option](https://profiles.ihe.net/ITI/MHD/1332_actor_options.html#13324-simplified-publish-option) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentSource.html))

**Document Access Provider**

- [IUA Resource Server](https://profiles.ihe.net/ITI/IUA/index.html#34113-resource-server) - Required
- [IUA Authorization Server](https://profiles.ihe.net/ITI/IUA/index.html#34112-authorization-server) - Required if authorization is handled internally; not required if using external authorization infrastructure. See [Authorization Server Deployment](authorization.html#authorization-server-deployment).
- [PDQm Patient Demographics Supplier](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsSupplier.html))
- [MHD Document Responder](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentResponder.html))

<a name="document-submission-option"></a>
**Document Submission Option** (when accepting external publication):
- [MHD Document Recipient](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) with [Simplified Publish Option](https://profiles.ihe.net/ITI/MHD/1332_actor_options.html#13324-simplified-publish-option) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentRecipient.html))

**Document Consumer**

- [IUA Authorization Client](https://profiles.ihe.net/ITI/IUA/index.html#34111-authorization-client)
- [PDQm Patient Demographics Consumer](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsConsumerQuery.html))
- [MHD Document Consumer](https://profiles.ihe.net/ITI/MHD/1331_actors_and_transactions.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/MHD/CapabilityStatement-IHE.MHD.DocumentConsumer.html))

This leads to the following required transactions between these actors:

```mermaid
sequenceDiagram
    participant Publisher as Document Publisher
    participant Provider as Document Access Provider
    participant Consumer as Document Consumer

    Publisher->>Provider: Get Access Token (IUA ITI-71)
    Provider-->>Publisher: access_token
    Publisher->>Provider: Patient Lookup (PDQm ITI-78)
    Provider-->>Publisher: Patient Bundle
    Publisher->>Provider: Simplified Publish (MHD ITI-105)
    Provider-->>Publisher: Response

    Consumer->>Provider: Get Access Token (IUA ITI-71)
    Provider-->>Consumer: access_token
    Consumer->>Provider: Patient Lookup (PDQm ITI-78)
    Provider-->>Consumer: Patient Bundle
    Consumer->>Provider: Find Document References (MHD ITI-67)
    Provider-->>Consumer: DocumentReference Bundle
    Consumer->>Provider: Retrieve Document (MHD ITI-68)
    Provider-->>Consumer: Document Content
```

See the following functional pages for detailed transaction information:
- [Authorization](authorization.html) - Authentication and authorization flows
- [Patient Match](patient-match.html) - Patient identification transactions
- [Document Exchange](document-exchange.html) - Document query and retrieval transactions

This can be combined with content profiles define by each EHDS Priority Category, for those categories that are primarily represented as a FHIR Document. For example, a system can be a **Lab Result Document Publisher**, a **Patient Summary Document Consumer**, or a **Imaging Manifest Document Access Provider**. 


### Resource Exchange

It is also useful in many cases to transact with individual FHIR resources. For this purpose, two resource-based actors are defined:

<div style="text-align: center;">
{% include img.html img="resExchange_1.png" caption="Figure: Resource Exchange Actors" %}
</div>


<a name="resource-access-provider"></a>
4. **Resource Access Provider (server)** - A FHIR server providing access to FHIR resources by hosting search + read query API's.

<a name="resource-consumer"></a>
5. **Resource Consumer (client)** - A FHIR client that consumes external FHIR resources by querying a Resource Access Provider.

<details>
<summary><i>Note: What about Resource Producer? Click for more</i></summary>

Resource exchange is more complex than document publication, and in many cases has resource and use-case specific considerations. Within the scope of this version of the IG, we assume a precondition that the Resource Access Provider has access to resources and focus on defining how the Resource Access Provider enables a consumer to search and read those resources. For more details and possible approaches, see the <a href="resourceExchange.html">Resource Exchange</a> page.

</details>



These composite actors inherit existing actors from the IUA, PDQm, and IPA specifications (with QEDm alignment where compatible):

<div style="text-align: center;">
{% include img.html img="resExchange_2.png" caption="Figure: Resource Access - Actor Groupings" %}
</div>

**Resource Access Provider**

- [IUA Resource Server](https://profiles.ihe.net/ITI/IUA/index.html#34113-resource-server) - Required
- [IUA Authorization Server](https://profiles.ihe.net/ITI/IUA/index.html#34112-authorization-server) - Required if authorization is handled internally; not required if using external authorization infrastructure. See [Authorization Server Deployment](authorization.html#authorization-server-deployment).
- [PDQm Patient Demographics Supplier](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsSupplier.html))
- Resource Access
  - [HL7 International Patient Access Server](https://build.fhir.org/ig/HL7/fhir-ipa/index.html) ([CapabilityStatement](https://build.fhir.org/ig/HL7/fhir-ipa/CapabilityStatement-ipa-server.html))
  - [QEDm Clinical Data Source](https://profiles.ihe.net/PCC/QEDm/volume-1.html#actors-and-transactions) ([CapabilityStatement](https://profiles.ihe.net/PCC/QEDm/CapabilityStatement-IHE.QEDm.Clinical-Data-Source.html)) - where compatible with IPA

**Resource Consumer**

- [IUA Authorization Client](https://profiles.ihe.net/ITI/IUA/index.html#34111-authorization-client)
- [PDQm Patient Demographics Consumer](https://profiles.ihe.net/ITI/PDQm/volume-1.html) ([CapabilityStatement](https://profiles.ihe.net/ITI/PDQm/CapabilityStatement-IHE.PDQm.PatientDemographicsConsumerQuery.html))
- Resource Access
  - [HL7 International Patient Access Client](https://build.fhir.org/ig/HL7/fhir-ipa/index.html) ([CapabilityStatement](https://build.fhir.org/ig/HL7/fhir-ipa/CapabilityStatement-ipa-client.html))
  - [QEDm Clinical Data Consumer](https://profiles.ihe.net/PCC/QEDm/volume-1.html#actors-and-transactions) ([CapabilityStatement](https://profiles.ihe.net/PCC/QEDm/CapabilityStatement-IHE.QEDm.Clinical-Data-Consumer.html)) - where compatible with IPA

This leads to the following required transactions between these actors:

```mermaid
sequenceDiagram
    participant Provider as Resource Access Provider
    participant Consumer as Resource Consumer

    Consumer->>Provider: Get Access Token (IUA ITI-71)
    Provider-->>Consumer: access_token
    Consumer->>Provider: Patient Lookup (PDQm ITI-78)
    Provider-->>Consumer: Patient Bundle
    Consumer->>Provider: Resource Query (IPA / QEDm PCC-44)
    Provider-->>Consumer: Resource Bundle
```

> **Note:** This diagram assumes a bundled Authorization Server. When using external authorization infrastructure (hospital, regional, or national level), the authorization flow differs. See [Authorization Server Deployment](authorization.html#authorization-server-deployment) for details.



### Example Groupings


<div style="text-align: center;">
{% include img.html img="ExGroup_Doc.png" caption="Figure: Example Grouping - Document" %}
</div>

<div style="text-align: center;">
{% include img.html img="ExGroup_Group.png" caption="Figure: Example Grouping - Group" %}
</div>



