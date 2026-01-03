# Retrieve a European Patient Summary

This example walks through a complete workflow for accessing a Patient Summary document for a known patient.

## Scenario

A Document Consumer needs to access the European Patient Summary for a patient who is being seen in their facility. The patient has received care in another organization that operates a Document Access Provider system with the patient's health data.

## Actors

- **[Document Consumer](actors.html#document-consumer)** - The healthcare provider's system requesting the Patient Summary
- **[Document Access Provider](actors.html#document-access-provider)** - The system holding the patient's health data

## Prerequisites

- Document Consumer has registered with Document Access Provider and obtained authorization credentials
- Patient has a known identifier in the Document Access Provider system
- Document Access Provider supports European Patient Summary priority category

## Step-by-Step Flow

### Step 1: Discover Capabilities

Document Consumer inspects the Document Access Provider's capabilities via [Capability Discovery](capability-discovery.html).

```
GET https://provider.example.org/fhir/metadata
```

The CapabilityStatement confirms support for IHE MHD document exchange, PDQm patient search, and European Patient Summary priority category.

### Step 2: Obtain Authorization Token

Document Consumer requests an access token using SMART Backend Services ([Authorization](authorization.html)).

```
POST https://provider.example.org/auth/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&scope=system/Patient.rs system/DocumentReference.rs system/Binary.r
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=[signed JWT]
```

### Step 3: Identify the Patient

Document Consumer searches for the patient using a known identifier ([Patient Match](patient-match.html)).

```
GET https://provider.example.org/fhir/Patient?identifier=urn:oid:2.16.840.1.113883.2.4.6.3|123456789
Authorization: Bearer [access_token]
```

Response includes the Patient resource with `id=patient-123`.

### Step 4: Search for Patient Summary Document

Document Consumer queries for Patient Summary documents using **IHE MHD ITI-67** (Find Document References) transaction ([Document Exchange](document-exchange.html)).

```
GET https://provider.example.org/fhir/DocumentReference?patient=patient-123&type=http://loinc.org|60591-5
Authorization: Bearer [access_token]
```

Response Bundle contains DocumentReference resources for available Patient Summaries.

### Step 5: Retrieve Document Content

Document Consumer retrieves the document content using **IHE MHD ITI-68** (Retrieve Document) transaction.

```
GET https://provider.example.org/fhir/Binary/binary-456
Authorization: Bearer [access_token]
```

Response is the Patient Summary as a FHIR Bundle (document) in JSON format.

## Sequence Diagram

```mermaid
sequenceDiagram
    participant Consumer as Document Consumer
    participant Provider as Document Access Provider

    Consumer->>Provider: GET /metadata
    Provider-->>Consumer: CapabilityStatement

    Consumer->>Provider: POST /auth/token
    Provider-->>Consumer: access_token

    Consumer->>Provider: GET /Patient?identifier=...
    Provider-->>Consumer: Patient resource

    Consumer->>Provider: GET /DocumentReference?patient=...&type=...
    Provider-->>Consumer: DocumentReference Bundle

    Consumer->>Provider: GET /Binary/[id]
    Provider-->>Consumer: Patient Summary Document
```

## Key Points

- All resource access requires [authorization](authorization.html)
- Patient identification precedes health data queries
- DocumentReference contains metadata about documents
- Binary resource contains the actual document content
- All transactions use standard FHIR RESTful interactions

## Variations

- If patient identifier is not known, use [Patient $match operation](patient-match.html)
- If Document Access Provider supports [Resource Access](resource-access.html), Consumer could query for individual resources instead of documents
- Multiple documents may be returned if patient has been seen multiple times
