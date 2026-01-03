# Relationship to XDS/XCA and FHIR Environments

Many European healthcare systems currently use IHE XDS (Cross-Enterprise Document Sharing) and XCA (Cross-Community Access) infrastructures for document exchange. This Implementation Guide uses IHE MHD (Mobile Health Documents) which serves as a bridge between traditional XDS/XCA environments and modern FHIR-based systems.

## IHE MHD as a Bridge

MHD provides a FHIR-based interface for document sharing that can be implemented:

1. **Natively** - As a direct FHIR-based document sharing system
2. **As a Façade** - As a FHIR interface in front of existing XDS/XCA infrastructure

This allows Member States with existing XDS/XCA infrastructure to expose FHIR-based APIs without replacing their underlying systems.

## Perspective from XDS/XCA Environments

From the perspective of XDS/XCA infrastructure:
- MHD DocumentReference maps to XDS DocumentEntry
- MHD transactions can be translated to XDS transactions
- Existing national infrastructure investments are preserved

## Perspective from FHIR Environments

From the perspective of FHIR-native systems:
- Clean, RESTful FHIR API with no XDS dependencies
- Uses standard FHIR resources (DocumentReference, Binary)
- Integrates naturally with other FHIR resources

## Implementation Options

Member States can choose the approach that best fits their current infrastructure:
- Pure FHIR implementation
- MHD façade over XDS/XCA
- Hybrid approaches

TODO: Add architectural diagrams showing different implementation patterns and mappings.

