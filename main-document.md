# APIs for EHDS

## Introduction

This document explores the different API's that are relevant in the context of EHDS. The purpose of this document is to create a shared terminology and architecture related to those APIs, and provide initial options and background for elements related to these API's and allow linkage of EHDS requirements defined by XtEHR to the corresponding API. 
EHDS overview
The figure below shows an architectural view of the different API’s that are relevant in the context of EHDS.
 
The figure shows the flow of data within and between different member states. It identifies a of business actors and API’s relevant for EHDS. The API’s are presented in blue, the actors in black. 

<img src="./images/EHDS-overview.svg">

The different business actors (black boxes) are:

* **EHR System**, means any system whereby the software, or a combination of the hardware and the software of that system, allows personal electronic health data that belong to the priority categories of personal electronic health data established under this Regulation to be stored, intermediated, exported, imported, converted, edited or viewed, and intended by the manufacturer to be used by healthcare providers when providing patient care or by patients when accessing their electronic health data; (EHDS Article 2 (2) k).
* **Proxy Service**, implements the electronic health access service (EHDS Article 4 (2)) and allows natural persons or their legal representatives to access personal electronic health data.
* **Wellness Application**, means any software, or any combination of hardware and software, intended by the manufacturer to be used by a natural person, for the processing of electronic health data, specifically for providing information on the health of natural persons, or the delivery of care for purposes other than the provision of healthcare (EHDS Article 2 (2) ab)
* **Patient App**, an mobile App, application or webpage used by a natural person to access their personal electronic health data.
* **National Contact Point**, systems operated by member states that allow flow of electronic health data between member states utilizing MyHealth@EU.
* **Healthcare Provider** means any natural or legal person or any other entity legally providing healthcare on the territory of a Member Staten (Directive 2011/24/EU, Article 3 (g)).

These business actors are connected by networks. Access to these networks is governed by interfaces (blue boxes in the figure). The interfaces as defined in the document are:

* **Cross-border API**, the API/protocol as defined by MyHealth@EU that is used to communicate electronic health data between member states.
* **National Infrastructure API**, the API/protocol defined by member states that is used to connect the National Contact Points with Healthcare Providers and Proxy Services.
* **EHR System API**, the API that EHR systems have to implement in order to satisfy the requirements as specified in EHDS.
* Wellness API, the API used by Wellness applications to communicate with an EHR system capable of receiving data from that Wellness Application.
* **Patient Access API**, the API Patient Apps use to communicate with eh national infrastructure.

## API definitions

When defining the interface between two systems, multiple aspects play a role. One of these is represented in the figure below.

<img src="./images/api-and-data.svg">

The definition of an interface can be conceptually described as consisting of two elements:

1.	The protocols/API used to set up the communication
2.	The data format that is used to communicate the content.

For most interfaces in EHDS, this data format is the European Electronic Health Record exchange Format (EEHRxF) (EHDS Arcticle 15). These specifications are developed by HL7eu and IHEeu:

* European Patient Summary (  [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/) )
* Europe Medication Prescription and Dispense ([HL7 Europe Medication Prescription and Dispense](https://build.fhir.org/ig/hl7-eu/mpd/))
* Europe Laboratory Report ([HL7 Europe Laboratory Report v0.2.0-ci](https://build.fhir.org/ig/hl7-eu/laboratory/))
* Europe Hospital Discharge Report ([Europe Hospital Discharge Report](https://build.fhir.org/ig/hl7-eu/hdr/))
* Europe Imaging Study Report ([HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/))
* Europe Imaging Study Manifest ([HL7 Europe Imaging Study Manifest R5](https://build.fhir.org/ig/hl7-eu/imaging-manifest/))

The interface definitions introduced in this document describe in what way the information expressed in these specifications are communicated. Most of these specifications (exception is EPS) are documents that are the result of clinical practice.

## Initial specification directions for each interface
This section addresses specification directions for each interface based on the current understanding of the EHDS legislation and the initial WP5 results. Later versions of this document will include a more formal requirements flow-down to WP5 deliverables.

### Cross Border API

The Cross Border API defines the way EEHRxF content is shared between member states. This interface is implemented on the eHealth Digital Service Infrastructure (eHDSI) (see Electronic cross-border health services - European Commission) and is governed by MyHEalth@EU. The specifications are controlled by the eHealth DSI EU countries Expert Group (eHMSEG) and are beyond the scope of this document.

### National Infrastructure API

The National Infrastructure API is the interface implemented by member states to connect Healthcare Providers to each other, to National Contact Points and to Proxy Services. The EHDS legislation does not have the mandate to dictate or direct the way this is implemented, allowing each member state to implement this in the best way suiting their requirements.

The EHDS legislation does require them to provide the EEHRxF information to the national contact points and to provide one or more Proxy Services, requiring the national infrastructure to be capable to transport the data required by the EEHRxF.

This specification RECOMMENDS member states that do not have an existing infrastructure or that are considering to change the current infrastructure to consider using the [IHE-MHDS](https://profiles.ihe.net/ITI/MHDS/index.html).  Depending on community interest, IHE/HL7eu may start work on defining an EU specific implementation guide for this interface, based on [IHE-MHDS](https://profiles.ihe.net/ITI/MHDS/index.html), adoption of which is optional or RECOMMENDED under the EHDS.

### EHR system API

The EHR system API is the interface EHR system vendors need to support on their solutions and for which they will have to prove compliance. Implementing for this API will be REQUIRED for EHR systems. The following sections illustrate some key aspects/choices that are proposed related to this interface.

#### Document vs resource access

EHDS is about the exchange of documents. Within a healthcare provider limiting this exchange to only documents is too restrictive. Often data is stored and accessed in a more granular manner. In order to support this, the following layering is proposed.

| Layer | Description               |          |
|-------| ------------------------- | -------- |
|     1 | Document                  | REQUIRED |
|     2	| + Document Element Access | OPTIONAL |
|     3	|   + Harmonized            | OPTIONAL |
|     4	|      + Clinical Record    | OPTIONAL |

Layer 1 is required for compliance and requires the EHR system to allow search for documents and retrieve the located documents.

Layer 2 adds resource level access to the information in these documents. So searches can be conducted across documents. Note that this layer does not require that the information from the documents is harmonized. So when 7 documents of the same patient are present, there will be 7 different Patient resources representing the same patient.

Layer 3 adds harmonization of key resources. So all documents will refer to the same patient, practitioners, organization, … .

In Layer 4 the current status of the clinical record is provided. The documents are still provided but no duplication of content between documents will be present. Note that this requires the FHIR References in these documents to use versioned References, so the document still accurately reflects the state of each resource when the document was published.

#### Priority area support

The EHDS legislation defines a set priority categories (EHDS Article 14) not all EHR System implementations require support for each category.

<img src="./images/priority-area-support.svg">

This part of the specification will define what priority categories that are to be supported by a specific EHR system. This also includes definition of category specific extensions on the interface such as:

* Category specific search options
* Category specific capabilities (e.g. download of DICOM data)

#### EHR system deployment options

Different vendors and healthcare providers may choose to implement the EHR system API requirements in different ways. Some of the imagined deployment options are indicated in the figure below.
  
<img src="./images/deployment-options.svg">

The standard/default implementation is where the EHR system implements the EHR system API directly. An alternative approach would be that a Façade is used to provide interface. Note that from the point of the EHDS, in the case where a Façade is used, the Façade is considered to be part of the tested EHR system. Some of these Façades are more capable and will be used to provide the required EHR system API for more than one EHR system, which will likely require specific testing. Another common pattern that can be used is using a Registry. When a Registry is used, the EHR system API is implemented by a Registry system that also offers standardized interfaces for EHR systems to provide and receive information.

#### Initial technology choices

Initial technology choices for the EHR system API are:

* FHIR (initially support of [FHIR v4.0.1](https://hl7.org/fhir/R4/) as well as [FHIR v5.0.0](https://hl7.org/fhir/R5/))
* [SMART App Launch v2.2.0](https://build.fhir.org/ig/HL7/smart-app-launch/index.html)  for user authorization and authentication
* [IHE-MHD](https://profiles.ihe.net/ITI/MHD/index.html) - Mobile access to Health Documents (MHD) for document exchange
* FHIR bulk data access ([FHIR R5 async-bulk](https://hl7.org/fhir/R5/async-bulk.html) and [FHIR R4  Bulk Data IG](https://hl7.org/fhir/uv/bulkdata/)) for data export
* Manual import of FHIR bulk data export files for import
* [IHE-ATNA](https://wiki.ihe.net/index.php/Add_RESTful_Query_and_Feed_to_ATNA) for logging

### Patient Access API

The Patient Access API is the interface patient facing applications will use to access personal health information. This specification will be modelled as close to the EHR System API as possible. Support of this API by Patient Apps is REQUIRED.

### Wellness API

The requirements for the wellness API are defined in EHDS Article 48 1 and 2. 
This interface enables Wellness Applications to upload their data to EHR systems. This requires that the person gave consent for such sharing and can control what categories of data are being shared. Wellness applications may claim interoperability with the EHR system (see EHDS Annex II), when doing so, the corresponding requirements for such communication as defined in the EHR system API need to be implemented as well.

The communication is between a Wellness Application and a specific (set of) EHR systems that implement the specific interface required by that Wellness Application. The EHDS does not dictate the way this is done, this specification RECOMMENDS implementations of such interfaces to consider using the following specifications:

*  FHIR Personal Health Device Implementation Guide for definition of the content that is shared
* SMART App Launch v2.2.0, for authorization and access control

Depending on community interest, IHE/HL7eu may start work on defining a implementation guide for this interface, adoption of which is optional or RECOMMENDED under the EHDS.
