# Patient Match

## Overview

Patient identification using PDQm Patient Demographics Query.

## Transactions

Patient Search is fine if only using regocnized national ID. Match is clinically safer for demopgrahics matching without solid identifiers (rarer in EU)

### Patient Search [ITI-78 Mobile Patient Demographics Query]
```
GET /Patient?identifier=urn:oid:2.16.840.1.113883.2.4.6.3|123456789
```

Required search parameter: `identifier`

TODO: Constrain this. 

### Patient.$match Operation [ITI-119 Patient Demographics Match]
```
POST /Patient/$match
```

Body contains Patient resource with demographic parameters. 

TODO: Check

## References

- [IHE PDQm](https://profiles.ihe.net/ITI/PDQm/index.html)
- [ITI-78 Mobile Patient Demographics Query](https://profiles.ihe.net/ITI/PDQm/ITI-78.html)
- [ITI-119 Patient Demographics Match](https://profiles.ihe.net/ITI/PDQm/ITI-119.html#2-3-119-patient-demographics-match-iti-119)
- [FHIR Patient.$match](https://hl7.org/fhir/R4/patient-operation-match.html)
