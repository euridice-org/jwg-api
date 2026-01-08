### Overview

Health information is exchanged across borders through National Contact Points (NCPs) using the MyHealth@EU network.

### How Cross-Border Exchange Works

NCPs communicate with each other via the **MyHealth@EU network**. When a **patient** from Country A needs care in Country B:

1. Country B's healthcare facility requests data through their NCP
2. NCPs exchange data over MyHealth@EU
3. Country A's NCP queries national infrastructure to retrieve the patient's data

**This IG enables the final step**: Country A's national infrastructure (or the NCP itself) acts as a **Consumer** to query EHR systems that are **Providers** of patient data.

### Actors

- **NCP or National Infrastructure** acts as [Document Consumer](actors.html#document-consumer)
- **EHR systems** act as [Document Access Provider](actors.html#document-access-provider)

### Architecture

```
Country B Facility → NCP-B → MyHealth@EU → NCP-A → National Infrastructure → EHR System API
                                                                              ↑
                                                                    This IG defines this API
```

### Role of This Specification

| Layer | Defined By |
|-------|-----------|
| Cross-Border API (MyHealth@EU) | [MyHealth@EU NCPeH API](https://build-fhir.ehdsi.eu/ncp-api/) |
| National Infrastructure API | Member States |
| **EHR System API** | **This IG** |

All layers exchange EEHRxF-formatted data to ensure semantic interoperability.

### Authorization Context

- Patient consent for cross-border access
- Healthcare professional authentication in requesting country
- Authorization decisions at NCP, national infrastructure, and EHR system levels
