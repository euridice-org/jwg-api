This section specifies how to inspect implement the use cases in an EHR system. 

The central HIE infrastructure defined in this profile might be a single FHIR Server implementing all the defined central service actors or may be virtual cloud of the systems implementing the defined profile actors. These deployment models allow for modularity where each service function could be provided by different vendors, leveraging as much as possible from a reference implementation of a FHIR Server, and also leverage as much as possible of modularity enabled by defined profiles.

The content of this section builds heavily on existing IHE profiles and FHIR IG's. The core business functions provided are:

* Access published EEHRxF information, documents and resource access
* Discovery of a matching patient
* Authorization
* Audit log requirements

The specification is described in the following sections:

* Actors, Transactions, and Content Modules
* Actor Options
* Required Actor Groupings
* Overview
* Security Considerations
* Cross Profile Considerations

### Actors, Transactions and Content Modules

This specification introduces one actor that contains actors from various IHE profiles and FHIR specifications.

{% include img.html img="ehr-system-actor-diagram.drawio.png" caption="Figure: Actor Diagram" %}

The following table list these transactions and indicates the optionality for each actor.

{:.grid}
| Actor | Transaction | Optionality | Reference |
|-------|-------------|-------------|-----------|
| EEHRxF Resource Consumer | ITI-1 Maintain time | R | |
|                          | T1-Inspect | O | |
|                          | T2 Find Patient | R | |
|                          | T4 Query Existing Data | R | |
||||
| EEHRxF Resource Provider | ITI-1 Maintain time | R | |
|                          | T1-Inspect | R | |
|                          | T2 Find Patient | R | |
|                          | T4 Query Existing Data | R | |
|                          | T5 import EEHRxF data | R | |
|                          | T6 export EEHRxF data | R | |
||||
| EEHRxF Document Consumer | ITI-1 Maintain time | R | |
|                          | T1-Inspect | O | |
|                          | T2 Find Patient | R | |
|                          | ITI-67 Find Document References | R | |
|                          | ITI-66 Retrieve Documents | R | |
||||
| EEHRxF Document Provider | ITI-1 Maintain time | R | |
|                          | T1-Inspect | R | |
|                          | T2 Find Patient | R | |
|                          | T4 Find Document References | R | |
|                          | T4 Retrieve Documents | R | |
|                          | T5 import EEHRxF data | R | |
|                          | T6 export EEHRxF data | R | |
||||
| Administrator            | T5 import EEHRxF data | R | |
|                          | T6 export EEHRxF data | R | |

The conditional requirement on the authorization related transactions relates to the fact that this specification does not dictate support of OAuth. If it is supported, than those transactions are required.

### Actor Options

Options that may be selected for each actor in this profile. Dependencies between options, when applicable ar specified in notes.

{:.grid}
| Actor | Option name |
|-------|-------------|
| EEHRxF Resource Consumer | Authorization Option |
| EEHRxF Resource Provider | Authorization Option |
| EEHRxF Document Consumer | Authorization Option |
| EEHRxF Document Provider | Authorization Option |

#### Authorization option

In this option the transactions in the system are protected by OAuth2. When this option is chosen, EEHRxF Provider (Document or Resource) SHALL be grouped with an IUA Resource Server and the IUA Authorization Server Actors. The IUA Authorization Server Metadata Option shall be supported. It is RECOMMENDED to implement IUA using the SMART on FHIR.

{% include img.html img="ehr-system-actor-diagram-authorization.drawio.png" caption="Figure: Actor Diagram" %}

The IUA Resource Server enforces OAuth Authorization decisions made by the grouped IUA Authorization Server. Thus, all accesses to the Document Registry must have a token issued by the IUA Authorization Server. These IUA Authorization Server decisions protect both requests from MHD Document Source Actors for publication, and from MHD Document Consumer actors for access and disclosure. The rules used for this authorization decision are not defined in this specification.

{:.grid}
| Actor | Transaction | Optionality | Reference |
|-------|-------------|-------------|-----------|
| EEHRxF Resource Consumer | ITI-71 Get Access Token | C | |
|                          | ITI-72 Incorporate Access Token | C | |
|                          | ITI-103 Get Authorization Server Metadata | C | |
||||
| EEHRxF Resource Provider | ITI-103 Get Authorization Server Metadata | C | |
|                          | ITI-102 Introspect Token | C | |
||||
| EEHRxF Document Consumer | ITI-71 Get Access Token | C | |
|                          | ITI-72 Incorporate Access Token | C | |
|                          | ITI-103 Get Authorization Server Metadata | C | |
||||
| EEHRxF Document Provider | ITI-103 Get Authorization Server Metadata | C | |
|                          | ITI-102 Introspect Token | C | |
||||
| Authorization Server     | ITI-103 Get Authorization Server Metadata | R | |
|                          | ITI-102 Introspect Token | R | |
||||
| Administrator            | | | |

### Required Actor Groupings

TBD

### Overview

#### Use cases

TBD

#### Priority area support

The EHDS legislation defines a set priority categories (EHDS Article 14) not all EHR System implementations require support for each category.

{% include img.html img="priority-area-support.drawio.png" caption="Figure: Priority Area Support" %}

This part of the specification will define what priority categories that are to be supported by a specific EHR system. This also includes definition of category specific extensions on the interface such as:

* Category specific search options
* Category specific capabilities (e.g. download of DICOM data)

#### EHR system deployment options

Different vendors and healthcare providers may choose to implement the EHR system API requirements in different ways. Some of the imagined deployment options are indicated in the figure below.

{% include img.html img="deployment-options.drawio.png" caption="Figure: Deployment options" %}

The standard/default implementation is where the EHR system implements the EHR system API directly. An alternative approach would be that a Façade is used to provide interface. Note that from the point of the EHDS, in the case where a Façade is used, the Façade is considered to be part of the tested EHR system. Some of these Façades are more capable and will be used to provide the required EHR system API for more than one EHR system, which will likely require specific testing. Another common pattern that can be used is using a Registry. When a Registry is used, the EHR system API is implemented by a Registry system that also offers standardized interfaces for EHR systems to provide and receive information.

Additionally, a choice should be made on the requirements related to what FHIR versions that is to be supported.


