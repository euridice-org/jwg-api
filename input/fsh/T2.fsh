Extension: SupportedIdentifier
Title: "Extension: SupportedIdentifier"
Description: """
  This extension indicates that a specific identifier system is supported by the server for a given resource type and parties querying for 
  corresponding resources (i.e. Patients,...) are recommended searching for this identifier.
"""
Context: CapabilityStatement.rest.resource
* value[x] only uri

