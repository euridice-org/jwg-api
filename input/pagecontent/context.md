This document explores the different APIs that are relevant in the context of EHDS.

### Context diagram

The figure below shows an architectural view of the different APIs that are relevant in the context of {{EHDS}}.

The figure shows the flow of data within and between different member states. It identifies a of business actors and APIs relevant for EHDS. The APIs are presented in blue, the actors in black.

{% include img.html img="EHDS-overview.drawio.png" caption="Figure: EHDS overview" %}

The different business actors are:

* **EHR System**, means any system whereby the software, or a combination of the hardware and the software of that system, allows personal electronic health data that belong to the priority categories of personal electronic health data established under this Regulation to be stored, intermediated, exported, imported, converted, edited or viewed, and intended by the manufacturer to be used by healthcare providers when providing patient care or by patients when accessing their electronic health data; (EHDS Article 2 (2) k).
* **Proxy Service**, implements the electronic health access service (EHDS Article 4 (2)) and allows natural persons or their legal representatives to access personal electronic health data.
* **Wellness Application**, means any software, or any combination of hardware and software, intended by the manufacturer to be used by a natural person, for the processing of electronic health data, specifically for providing information on the health of natural persons, or the delivery of care for purposes other than the provision of healthcare (EHDS Article 2 (2) ab)
* **Patient App**, an mobile App, application or webpage used by a natural person to access their personal electronic health data.
* **National Contact Point**, systems operated by member states that allow flow of electronic health data between member states utilizing MyHealth@EU.
* **Healthcare Provider** means any natural or legal person or any other entity legally providing healthcare on the territory of a Member Staten (Directive 2011/24/EU, Article 3 (g)).

These business actors are connected by networks. Access to these networks is governed by interfaces. This document defines these interfaces as:

* **Cross-border API**, the API/protocol as defined by MyHealth@EU that is used to communicate electronic health data between member states.
* **National Infrastructure API**, the API/protocol defined by member states that is used to connect the National Contact Points with Healthcare Providers and Proxy Services.
* **EHR System API**, the API that EHR systems have to implement in order to satisfy the requirements as specified in EHDS.
* Wellness API, the API used by Wellness applications to communicate with an EHR system capable of receiving data from that Wellness Application.
* **Patient Access API**, the API Patient Apps use to communicate with the national infrastructure.

### API definitions

When defining the interface between two systems, multiple aspects play a role. One of these is represented in the figure below.

{% include img.html img="api-and-data.drawio.png" caption="Figure: APIs and data" %}

The definition of an interface can be conceptually described as consisting of two elements:

1. The protocols/API used to set up the communication
2. The data format that is used to communicate the content.

For most interfaces in EHDS, this data format is the European Electronic Health Record exchange Format (EEHRxF) (EHDS Article 15). These specifications are developed by HL7eu and IHEeu:

* European Patient Summary (  [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/) )
* Europe Medication Prescription and Dispense ([HL7 Europe Medication Prescription and Dispense](https://build.fhir.org/ig/hl7-eu/mpd/))
* Europe Laboratory Report ([HL7 Europe Laboratory Report v0.2.0-ci](https://build.fhir.org/ig/hl7-eu/laboratory/))
* Europe Hospital Discharge Report ([Europe Hospital Discharge Report](https://build.fhir.org/ig/hl7-eu/hdr/))
* Europe Imaging Study Report ([HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/))
* Europe Imaging Study Manifest ([HL7 Europe Imaging Study Manifest R5](https://build.fhir.org/ig/hl7-eu/imaging-manifest/))

The interface definitions introduced in this document describe in what way the information expressed in these specifications are communicated. Most of these specifications (exception is EPS) are documents that are the result of clinical practice.

The specification defines a general pattern for the exchange of documents. For the document based EEHRxF data, this will be further refined into priority area specific specification that extend this base pattern with priority area specific elements such as search queries.

### Priority area support

The EHDS legislation defines a set priority categories (EHDS Article 14) not all EHR System implementations require support for each category.

{% include img.html img="priority-area-support.drawio.png" caption="Figure: Priority Areas" %}

This part of the specification will define what priority categories that are to be supported by a specific EHR system. This also includes definition of category specific extensions on the interface such as:

* Category specific search options
* Category specific capabilities (e.g. download of DICOM data)
* 
For the non-document based priority areas, the specification will define the interactions that are specific for this priority area.

### Specification directions for each interface

This section addresses specification directions for each interface based on the current understanding of the EHDS legislation and the initial WP5 results. Later versions of this document will include a more formal requirements flow-down to WP5 deliverables.

### Cross Border API

The Cross Border API defines the way EEHRxF content is shared between member states. This interface is implemented on the eHealth Digital Service Infrastructure (eHDSI) (see Electronic cross-border health services - European Commission) and is governed by MyHEalth@EU. The specifications are controlled by the eHealth DSI EU countries Expert Group (eHMSEG) and are beyond the scope of this document.

### National Infrastructure API

The National Infrastructure API is the interface implemented by member states to connect Healthcare Providers to each other, to National Contact Points and to Proxy Services. The EHDS legislation does not have the mandate to dictate or direct the way this is implemented, allowing each member state to implement this in the best way suiting their requirements.

The EHDS legislation does require them to provide the EEHRxF information to the national contact points and to provide one or more Proxy Services, requiring the national infrastructure to be capable to transport the data required by the EEHRxF.

This specification RECOMMENDS member states that do not have an existing infrastructure or that are considering to change the current infrastructure to consider using the [IHE-MHDS](https://profiles.ihe.net/ITI/MHDS/index.html).  Depending on community interest, IHE/HL7eu may start work on defining an EU specific implementation guide for this interface, based on [IHE-MHDS](https://profiles.ihe.net/ITI/MHDS/index.html), adoption of which is optional or RECOMMENDED under the EHDS.

### EHR system API

The EHR system API is the interface EHR system vendors need to support on their solutions and for which they will have to prove compliance. Implementing for this API will be REQUIRED for EHR systems. The following sections illustrate some key aspects/choices that are proposed related to this interface.

### Patient Access API

The Patient Access API is the interface patient facing applications will use to access personal health information. This specification will be modelled as close to the EHR System API as possible. Support of this API by Patient Apps is REQUIRED.

### Wellness API

The requirements for the wellness API are defined in EHDS Article 48 1 and 2. 
This interface enables Wellness Applications to upload their data to EHR systems. This requires that the person gave consent for such sharing and can control what categories of data are being shared. Wellness applications may claim interoperability with the EHR system (see EHDS Annex II), when doing so, the corresponding requirements for such communication as defined in the EHR system API need to be implemented as well.

The communication is between a Wellness Application and a specific (set of) EHR systems that implement the specific interface required by that Wellness Application. The EHDS does not dictate the way this is done, this specification RECOMMENDS implementations of such interfaces to consider using the following specifications:

* FHIR Personal Health Device Implementation Guide for definition of the content that is shared
* SMART App Launch v2.2.0, for authorization and access control

Depending on community interest, IHE/HL7eu may start work on defining a implementation guide for this interface, adoption of which is optional or RECOMMENDED under the EHDS.
