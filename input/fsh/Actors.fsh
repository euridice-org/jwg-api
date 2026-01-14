// ===========================================================================
// Document Exchange Actors
// ===========================================================================

Instance: EEHRxF-DocumentProducer-Actor
InstanceOf: ActorDefinition
Title: "EEHRxF Document Producer"
Usage: #definition
Description: """
The Document Producer actor produces EEHRxF FHIR Documents and publishes them to a
Document Access Provider. This composite actor groups MHD Document Source, PDQm
Patient Demographics Consumer, and IUA Authorization Client.

See [Document Producer CapabilityStatement](CapabilityStatement-EEHRxF-DocumentProducer.html)
for technical requirements.
"""
* name = "EEHRxF-DocumentProducer"
* title = "EEHRxF Document Producer"
* status = #active
* experimental = false
* type = #system
* capabilities = Canonical(EEHRxF-DocumentProducer)

Instance: EEHRxF-DocumentAccessProvider-Actor
InstanceOf: ActorDefinition
Title: "EEHRxF Document Access Provider"
Usage: #definition
Description: """
The Document Access Provider actor provides access to EEHRxF FHIR Documents by receiving
documents from Document Producers and serving them to Document Consumers. This composite
actor groups MHD Document Recipient, MHD Document Responder, PDQm Patient Demographics
Supplier, and IUA Authorization Server/Resource Server.

See [Document Access Provider CapabilityStatement](CapabilityStatement-EEHRxF-DocumentAccessProvider.html)
for technical requirements.
"""
* name = "EEHRxF-DocumentAccessProvider"
* title = "EEHRxF Document Access Provider"
* status = #active
* experimental = false
* type = #system
* capabilities = Canonical(EEHRxF-DocumentAccessProvider)

Instance: EEHRxF-DocumentConsumer-Actor
InstanceOf: ActorDefinition
Title: "EEHRxF Document Consumer"
Usage: #definition
Description: """
The Document Consumer actor consumes EEHRxF FHIR Documents by querying a Document Access
Provider. This composite actor groups MHD Document Consumer, PDQm Patient Demographics
Consumer, and IUA Authorization Client.

See [Document Consumer CapabilityStatement](CapabilityStatement-EEHRxF-DocumentConsumer.html)
for technical requirements.
"""
* name = "EEHRxF-DocumentConsumer"
* title = "EEHRxF Document Consumer"
* status = #active
* experimental = false
* type = #system
* capabilities = Canonical(EEHRxF-DocumentConsumer)

Instance: EEHRxF-DocumentProducerAccessProvider-Actor
InstanceOf: ActorDefinition
Title: "EEHRxF Grouped Document Producer/Access Provider"
Usage: #definition
Description: """
The grouped Document Producer/Access Provider actor represents a deployment where document
production and access provision are co-located in the same system. In this configuration,
document submission (ITI-65) is internal and only document query/retrieval (ITI-67, ITI-68)
is exposed externally.

This is common for hospital EHR systems that produce and serve their own documents.

See [Grouped Document Producer/Access Provider CapabilityStatement](CapabilityStatement-EEHRxF-DocumentProducerAccessProvider.html)
for technical requirements.
"""
* name = "EEHRxF-DocumentProducerAccessProvider"
* title = "EEHRxF Grouped Document Producer/Access Provider"
* status = #active
* experimental = false
* type = #system
* capabilities = Canonical(EEHRxF-DocumentProducerAccessProvider)

// ===========================================================================
// Resource Exchange Actors
// ===========================================================================

Instance: EEHRxF-ResourceAccessProvider-Actor
InstanceOf: ActorDefinition
Title: "EEHRxF Resource Access Provider"
Usage: #definition
Description: """
The Resource Access Provider actor provides access to FHIR resources following IPA and
QEDm patterns. This enables direct resource access complementing document-based exchange.
This composite actor groups QEDm Clinical Data Source, IPA Server, PDQm Patient Demographics
Supplier, and IUA Authorization Server/Resource Server.

See [Resource Access Provider CapabilityStatement](CapabilityStatement-EEHRxF-ResourceAccessProvider.html)
for technical requirements.
"""
* name = "EEHRxF-ResourceAccessProvider"
* title = "EEHRxF Resource Access Provider"
* status = #active
* experimental = false
* type = #system
* capabilities = Canonical(EEHRxF-ResourceAccessProvider)

Instance: EEHRxF-ResourceConsumer-Actor
InstanceOf: ActorDefinition
Title: "EEHRxF Resource Consumer"
Usage: #definition
Description: """
The Resource Consumer actor queries for clinical data resources from a Resource Access
Provider following IPA and QEDm patterns. This composite actor groups QEDm Clinical Data
Consumer, IPA Client, PDQm Patient Demographics Consumer, and IUA Authorization Client.

See [Resource Consumer CapabilityStatement](CapabilityStatement-EEHRxF-ResourceConsumer.html)
for technical requirements.
"""
* name = "EEHRxF-ResourceConsumer"
* title = "EEHRxF Resource Consumer"
* status = #active
* experimental = false
* type = #system
* capabilities = Canonical(EEHRxF-ResourceConsumer)
