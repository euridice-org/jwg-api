# Change Log

## Version 0.1.0 (January 2026)

### Initial Draft for Wide Review

This is the first draft of the EU Health Data API Implementation Guide prepared for wide review.

### Content Structure

- Established composite actor model built on IHE MHD, PDQm, QEDm, IUA and HL7 SMART Backend Services
- Defined five composite actors: Document Producer, Document Access Provider, Document Consumer, Resource Access Provider, Resource Consumer
- Created functional requirements for: Authorization, Patient Matching, Document Exchange, Resource Access, Capability Discovery
- Documented three implementation use cases: Health Professional Portal, Health Data Portal (Patient), Cross-Border NCP
- Mapped to EHDS regulatory requirements via Xt-EHR D5.1 inheritance

### Technical Artifacts

- EPS (European Patient Summary) priority area fully specified with CapabilityStatements and profiles
- DocumentReference profile for MHD-based document exchange
- SupportedIdentifier extension for patient identifier discovery

### Scope

This version focuses on EHR API access to EEHRxF data. Other priority categories (Lab, HDR, MPD, Imaging) are stubbed pending completion of HL7 Europe content IGs.

### Known Limitations

- Dependency versions use `current` for some packages (CI build only)
- Some IHE package links resolve to external IHE volumes
- Conformance testing approach TBD with European Commission
