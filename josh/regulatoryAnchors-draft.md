# Regulatory Anchors

## Purpose and Scope

This Implementation Guide addresses the **technical layer** of EHDS Annex II requirements for EHR system interoperability components.

### What This IG Covers

This IG provides **technical API specifications** for:
- System-to-system authorization, patient matching, and data exchange
- Document-based exchange (IHE MHD) and resource-based access (IHE QEDm/IPA)
- Actor definitions and transaction patterns using IHE/HL7 standards
- Transport security and access control

### What This IG Does NOT Cover

**Out of Scope:**
- Functional requirements themselves (owned by EC Implementing Acts)
- Logging component specifications (separate harmonized component)
- Member State infrastructure components (HDAS, HPAS, NCPs, discovery services)
- User-level authentication and authorization services
- National-level discovery, routing, or policy enforcement

### Relationship to Xt-EHR D5.1

This IG provides the **technical specifications** that implement the **functional requirements** defined in Xt-EHR Work Package 5.1 Deliverable (D5.1).

**Division of Responsibilities:**

| Question | Answered By | Example |
|----------|-------------|---------|
| **WHAT** must systems do? | D5.1 Functional Requirements | "Producer SHALL offer patient lookup API" |
| **HOW** technically? | This IG Technical Specifications | "Use PDQm ITI-78: `GET /Patient?identifier=X`" |
| **WHY** this approach? | D5.1 Discussion chapters | "PULL architecture chosen because..." |

---

## 1. Legal and Regulatory Framework

### 1.1 EHDS Regulation Context

This Implementation Guide addresses **technical specifications** for the interoperability requirements in **EHDS Regulation (EU) 2025/327**, specifically:

- **Article 36:** Common specifications for harmonized software components
- **Annex II §1.4:** Reliable and secure interoperability and compatibility
- **Annex II §2.1:** Providing interface enabling access to data in EEHRxF
- **Annex II §2.2:** Ability to receive data in EEHRxF
- **Annex II §2.4:** Granularity of data entry sufficient for EEHRxF provision

**EHDS Annex II Core Requirements:**

> **§2.1:** "Where an EHR system is designed to store or intermediate personal electronic health data, it **SHALL provide an interface enabling access** to the personal electronic health data processed by it in the European electronic health record exchange format"

> **§2.2:** "Where an EHR system is designed to store or intermediate personal electronic health data, it **SHALL be able to receive** personal electronic health data in the European electronic health record exchange format"

> **§1.4:** "...interoperability and compatibility are **reliable and secure**..."

**Reference:** [EHDS Regulation EUR-Lex](https://eur-lex.europa.eu/eli/reg/2025/327/oj/eng)

### 1.2 Legal Authority Flow

```
┌──────────────────────────────────────────────────────────────┐
│ EHDS Regulation (EU) 2025/327                                │
│ - Article 36: Common specifications for harmonized components│
│ - Annex II: Essential requirements                           │
│ - Status: LAW (enforceable)                                  │
└──────────────────────────────────────────────────────────────┘
                          ↓ delegates to
┌──────────────────────────────────────────────────────────────┐
│ EC Implementing Acts (via Comitology)                        │
│ - Common specifications for interoperability & logging       │
│ - Timeline: Must be published by March 26, 2027             │
│ - Status: NOT YET ADOPTED                                    │
└──────────────────────────────────────────────────────────────┘
                          ↑ informed by
┌──────────────────────────────────────────────────────────────┐
│ Xt-EHR D5.1 Functional Requirements                          │
│ - Proposes detailed requirements                             │
│ - 26 requirements (15 interoperability, 6 logging, 5 general)│
│ - Status: RECOMMENDATION (input to Comitology)               │
└──────────────────────────────────────────────────────────────┘
                          ↑ implemented by
┌──────────────────────────────────────────────────────────────┐
│ EURIDICE API IG (This IG) - Technical Specifications         │
│ - FHIR Implementation Guide                                  │
│ - Uses IHE/HL7 standards (MHD, QEDm, PDQm, IUA)             │
│ - Status: ANTICIPATORY (developed by SDOs)                   │
└──────────────────────────────────────────────────────────────┘
```

### 1.3 Three Levels of Specification

The EHDS framework operates at three levels of detail:

| Level | Description | Owner | Detail | Example |
|-------|-------------|-------|--------|---------|
| **EHDS Regulation** | High-level interoperability goals (LAW) | European Commission | Low | "EHR system SHALL provide interface enabling access to data in EEHRxF" (Annex II §2.1) |
| **Functional Requirements** | System roles and capabilities (IMPLEMENTING ACTS) | EC + Member States (informed by Xt-EHR D5.1) | Medium | "Producer SHALL offer API for consumer to search and retrieve patient summary documents" |
| **Technical Specifications** | Implementable FHIR specs (IMPLEMENTATION GUIDES) | SDOs (HL7 EU, IHE Europe) via consensus | High | `GET /DocumentReference?patient=123&type=60591-5` (MHD ITI-67) |

**Key Insight:** D5.1 defines the "WHAT" (functional requirements). This IG defines the "HOW" (technical implementation).

### 1.4 Status of This IG

**This IG is anticipatory in nature.** It is developed to inform and support the European Commission's Implementing Acts under EHDS Article 36. Final requirements and technical specifications will be adopted through the formal Comitology process.

**This IG does not create legal obligations** until formally adopted and incorporated into EC Implementing Acts.

The IG is developed through formal Standards Development Organization (SDO) consensus processes:
- **HL7 Europe:** FHIR profiles and content specifications
- **IHE Europe:** Transaction patterns and integration profiles

### 1.5 Timeline

- **2025-2026:** Xt-EHR Joint Action delivers D5.1 and other deliverables
- **Q1 2026:** This IG planned for HL7 Europe balloting process
- **By March 26, 2027:** EC must publish Implementing Acts with common specifications
- **Post-2027:** EHR systems implement adopted specifications

---

## 2. Relationship to Xt-EHR D5.1

### 2.1 What is D5.1?

**Deliverable 5.1** of the Xt-EHR Joint Action translates EHDS Annex II into detailed functional requirements for EHR system manufacturers.

**D5.1's Role:**
- Proposes 26 functional requirements (15 interoperability, 6 logging, 5 general)
- Defines WHAT EHR systems must achieve (capability-oriented)
- Developed through open consultation with Member States, manufacturers, healthcare providers
- Input to EC Implementing Acts (**non-binding** until adopted through Comitology)

**This IG's Role:**
- Defines HOW to implement D5.1 interoperability requirements using IHE/HL7 standards
- Provides testable technical specifications (FHIR APIs, transactions, profiles)
- Developed through formal SDO consensus and balloting process

### 2.2 Actor Model Alignment

D5.1 defines three core actors:

1. **Producer:** The system or component that creates data available to other systems
2. **Consumer:** The system or component that receives, displays or otherwise ingests data
3. **Exchanger:** An intermediary (e.g., HIE, NCP, integration engine) that routes between systems

**Mapping to This IG:**

| D5.1 Actor | IG Equivalent | Notes |
|------------|---------------|-------|
| **Producer** | Document Access Provider + Resource Access Provider | System that offers API access to priority category data |
| **Consumer** | Document Consumer + Resource Consumer | System that queries/retrieves priority category data |
| **Exchanger** | Can group Producer + Consumer roles | Intermediary (HIE, NCP) that routes between systems |

**Actor Segmentation by Priority Category:**
Both D5.1 and this IG segment actors by priority category:
- "Lab Result Producer" = "Lab Report Document Access Provider" in this IG
- "Patient Summary Consumer" = "Patient Summary Document Consumer" in this IG

### 2.3 Requirements Coverage

This IG implements **all 15 D5.1 interoperability component requirements:**

| D5.1 Chapter | Requirements | IG Coverage |
|--------------|--------------|-------------|
| §3.2 General API | `api-producer-general`, `api-consumer-general` | ✅ [Actors](actors.html), [Document Exchange](document-exchange.html), [Resource Access](resource-access.html) |
| §3.3 Authorization | 5 requirements (`api-*-auth*`) | ✅ [Authorization](authorization.html) |
| §3.4 Patient Match | `api-producer-patient`, `api-consumer-patient` | ✅ [Patient Matching](patient-match.html) |
| §3.5 Document Discovery | `api-producer-doc`, `api-consumer-doc` | ✅ [Document Exchange](document-exchange.html) |
| §3.6 Resource Discovery | `api-producer-resource`, `api-consumer-resource` | ✅ [Resource Access](resource-access.html) |
| §3.7 Data Production | `api-producer-data`, `api-consumer-data` | ✅ [Priority Category Content Profiles](index.html#content-profiles) |
| §3.8 Transport Security | `api-encryption` | ✅ [Authorization - Transport Security](authorization.html) |

**See [Requirements Traceability](requirements-traceability.html) for complete mapping.**

---

## 3. Scope of This IG

### 3.1 In Scope: European Interoperability Software Component

This IG specifies the **European interoperability software component** (EHDS Annex II Art. 2.1.n) - the technical API layer for:

**1. System Authorization (D5.1 §3.3)**
- Authorization server discovery
- Token issuance and validation
- System-to-system access control
- Technical Approach: SMART Backend Services + IHE IUA

**2. Patient Matching (D5.1 §3.4)**
- Patient demographics query
- Support for multiple identity forms (identifiers, demographics, eID)
- Technical Approach: IHE PDQm (ITI-78)

**3. Document Exchange (D5.1 §3.5)**
- Document publication, search, retrieval
- FHIR Documents (EEHRxF priority categories)
- Technical Approach: IHE MHD (ITI-65, ITI-67, ITI-68)

**4. Resource Access (D5.1 §3.6)**
- Fine-grained resource query (Observation, Condition, MedicationRequest, etc.)
- "EU Core" concept - reusable resource APIs
- Technical Approach: IHE QEDm (PCC-44) / HL7 IPA

**5. Data Format (D5.1 §3.7)**
- EEHRxF conformance for priority categories
- Inherits HL7 EU content profiles

**6. Transport Security (D5.1 §3.8)**
- TLS encryption requirements

**Priority Categories:**
- European Patient Summary
- ePrescription & eDispensation
- Laboratory Results
- Hospital Discharge Reports
- Medical Imaging Reports & Manifests

### 3.2 Out of Scope: Logging Component

The **European logging software component** (EHDS Annex II Art. 2.1.o) is a **separate harmonized component** independent from the interoperability component.

**Logging Requirements (D5.1 Chapter 4, 6 requirements):**
- `log-UserAccess`: Log user access via UI
- `log-APIAccess`: Log API access events
- `log-UserID`: User identification and authentication
- `log-Review`: Log review and analysis tools
- `log-Retention`: Configurable retention periods
- `log-Interoperability`: Standardized log format/exchange

**Why Out of Scope:**
EHDS Annex II explicitly defines interoperability and logging as **independent components** (Art. 2.1.n and 2.1.o). D5.1 treats them in separate chapters.

**Expected:** HL7 EU / IHE Europe may develop separate logging IG in the future.

**This IG's Relation to Logging:**
This IG enables end-to-end audit by requiring both Producer and Consumer to log API access. Logs can be correlated to trace data access across systems. Specific logging component format and exchange specifications are out of scope.

### 3.3 Out of Scope: Member State Infrastructure Components

The following are **Member State responsibilities** (not EHR system harmonized component requirements):

**1. Healthcare Organization and EHR System Discovery (D5.1 §3.1.6)**
- Locating which EHR systems contain data for a patient
- Routing consumer queries to appropriate producers
- Examples: National registries, localization services, discovery services

**2. User-Level Authorization (D5.1 §3.3.2)**
- Authentication of healthcare professionals (eIDAS, national eID)
- Authentication of patients
- User-level access policies and authorization rules
- **Note:** This IG covers **system-level** authorization only

**3. Health Data Access Services - HDAS (EHDS Art. 4)**
- Service for natural persons to access their health data
- Implement patient rights (Articles 3, 5-10)
- Member State must establish (Art. 4.1)

**4. Health Professional Access Services - HPAS (EHDS Art. 12)**
- Service for healthcare professionals to access priority category data
- Cross-organizational data aggregation
- Member State must establish (Art. 12)

**5. National Contact Points - NCP (EHDS Art. 23)**
- Gateway for cross-border exchange (MyHealth@EU)
- Member State must designate (Art. 23.2)

**6. Identity and Authentication Infrastructure**
- Identity providers for professionals (Art. 12)
- Identity providers for patients (Art. 16.1)
- eIDAS-compliant authentication services

**7. Authorization Policy Enforcement**
- National/regional authorization rules (Art. 11.3)
- Policy Decision Points (PDP) and Policy Information Points (PIP)
- Trust anchors and trust framework

**8. Other Member State Services (D5.1 §6.2.2)**
- Opt-out services
- Pseudonymization services
- Capability check services
- Translation services (multilingual Member States)
- Data conformity services
- Central logging aggregation (optional)

### 3.4 Out of Scope: General EHR System Requirements

D5.1 Chapter 5 defines general requirements that are **not API specifications:**
- `gen-Installation`: Harmonized component installation procedures
- `gen-Documentation`: Manufacturer documentation requirements
- `gen-performanceSafety`: Performance and patient safety
- `gen-noUndueBurden`: No undue burden on access (supported by open APIs)
- `gen-SystemReplacement`: Export for system replacement (supported by batch access)

These are software quality, documentation, and operational requirements covered by D5.1 and future EC Implementing Acts, not API specifications.

### 3.5 Out of Scope: Priority Category Content Specifications

**EEHRxF Data Models** (what data is exchanged) are defined in separate HL7 EU IGs:
- [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/)
- [HL7 Europe Medication Prescription and Dispense](https://build.fhir.org/ig/hl7-eu/mpd/)
- [HL7 Europe Laboratory Report](https://build.fhir.org/ig/hl7-eu/laboratory/)
- [HL7 Europe Hospital Discharge Report](https://build.fhir.org/ig/hl7-eu/hdr/)
- [HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/)

**This IG's Role:** Defines HOW to exchange EEHRxF data (API patterns, transactions).
**Content IGs' Role:** Define WHAT data is exchanged (data structure, required elements, terminology).

---

## 4. Relationship to Member State Infrastructure

### 4.1 Layered Architecture

EHR systems implementing this IG operate within a broader ecosystem that includes Member State-specific infrastructure services.

```
╔════════════════════════════════════════════════════════════════╗
║  EU Level                                                      ║
║  - MyHealth@EU Cross-Border Infrastructure                    ║
║  - eIDAS Framework                                             ║
╚════════════════════════════════════════════════════════════════╝
                              ↕
╔════════════════════════════════════════════════════════════════╗
║  Member State Infrastructure (MS Responsibility)               ║
║  ┌──────────────────────────────────────────────────────────┐ ║
║  │ Discovery    │ Authorization │ Identity    │ HDAS/HPAS   │ ║
║  │ Services     │ Services      │ Services    │ Services    │ ║
║  │──────────────┼───────────────┼─────────────┼─────────────│ ║
║  │ NCPs         │ Opt-out       │ Logging     │ Translation │ ║
║  │              │ Services      │ Aggregation │ Services    │ ║
║  └──────────────────────────────────────────────────────────┘ ║
╚════════════════════════════════════════════════════════════════╝
                              ↕
╔════════════════════════════════════════════════════════════════╗
║  EHR System (Vendor Product)                                   ║
║  ┌────────────────────────┐  ┌────────────────────────────┐  ║
║  │ Interoperability       │←→│ MS Infrastructure Hooks    │  ║
║  │ Component              │  │                            │  ║
║  │ (This IG - EHDS API)   │  │ (MS-specific requirements) │  ║
║  │                        │  │ - Registry publication     │  ║
║  │ - SMART Backend + IUA  │  │ - Notification triggers    │  ║
║  │ - PDQm patient match   │  │ - Policy checks            │  ║
║  │ - MHD document exchange│  │ - NOT standardized by EHDS │  ║
║  │ - QEDm resource access │  │                            │  ║
║  └────────────────────────┘  └────────────────────────────┘  ║
║  ┌──────────────────────────────────────────────────────────┐║
║  │ Core EHR Functionality (Priority Category Data Storage)  ││
║  └──────────────────────────────────────────────────────────┘║
║  ┌──────────────────────────────────────────────────────────┐║
║  │ Logging Component (Separate from Interoperability)       ││
║  └──────────────────────────────────────────────────────────┘║
╚════════════════════════════════════════════════════════════════╝
```

### 4.2 Key Insight from D5.1

> "Compliance with the requirements of the interoperability component is not sufficient to achieve interoperability. Because the infrastructures for data exchange differs per Member State. So, there are other requirements at Member State level that enable interoperability with this Member State infrastructures." (D5.1 §6.2)

### 4.3 Member State Architectural Diversity

Member States have diverse healthcare systems and infrastructure approaches:

| Architecture Type | Characteristics | Implications for EHR Systems |
|-------------------|-----------------|------------------------------|
| **Centralized** | National EHR or central repository; Central authorization; EHR systems may PUSH to central system; HDAS/HPAS query central system | EHR must support both PULL (this IG) and MS-specific hooks for registry publication |
| **Federated** | Data distributed across providers; Federated discovery/authorization; EHR systems queried directly; HDAS/HPAS aggregate from multiple sources | EHR primarily uses PULL (this IG); MS infrastructure handles discovery and routing |
| **Hybrid** | Mix of central and federated; Regional aggregation with national coordination; Multiple communication patterns | EHR supports PULL baseline plus MS-specific patterns as needed |

**This IG's Design Philosophy:**
The PULL-based API defined in this IG works across all three architecture types. Member States add infrastructure services to support their chosen patterns without requiring changes to the standardized EHR API.

### 4.4 Fractal Architecture

The architecture exists at three levels (D5.1 §6.2.2):

1. **EU Level:** MyHealth@EU, eIDAS framework
2. **Member State Level:** National infrastructure services
3. **Healthcare Provider Level:** Hospital/organization-scale infrastructure

> "It is like a fractal with three levels... This architectural mapping concentrates on the Member State level."

**Example:** A large hospital may have its own internal "discovery service" to route queries to departmental EHR systems, similar to how a Member State routes queries to healthcare provider EHR systems.

### 4.5 Member State vs. EHR System Responsibilities

**Member States are responsible for:**
- Establishing HDAS (Art. 4), HPAS (Art. 12), NCP (Art. 23)
- Identity and authentication services for professionals (Art. 12) and patients (Art. 16.1)
- Defining authorization rules (Art. 11.3)
- Connecting healthcare providers to NCPs (Art. 23.5)
- Discovery and routing infrastructure (as needed by their architecture)

**EHR System Vendors are responsible for:**
- Implementing interoperability component per this IG
- Implementing logging component per future logging IG
- Implementing Member State-specific infrastructure hooks
- Complying with D5.1 requirements and EC Implementing Acts when adopted

**Healthcare Providers are responsible for:**
- Deploying compliant EHR systems
- Implementing operational procedures for patient rights
- Enforcing access control policies
- Connecting to Member State infrastructure

---

## 5. Key Architectural Decisions

### 5.1 PULL vs. PUSH Architecture

**Decision:** The interoperability component is primarily defined as a **PULL architecture** (Consumer-initiated query).

#### 5.1.1 Definitions

- **PULL (Query/GET/API):** Consumer EHR System initiates data exchange by requesting data from Producer EHR system. Producer responds with data as it currently exists.

- **PUSH (Send/Publish):** Producer EHR system initiates data exchange based on a workflow event and sends message to Consumer EHR system.

#### 5.1.2 EHDS Legal Basis

EHDS Annex II §2.1: "SHALL **provide an interface enabling access** to the personal electronic health data"
EHDS Annex II §2.2: "SHALL **be able to receive** personal electronic health data"

**D5.1 Interpretation:** These requirements can be met with a PULL architecture. Producer provides interface (FHIR API) that Consumer can use to access data via query.

#### 5.1.3 Justification

**1. EHDS Goals Are Achievable with PULL**

All major EHDS use cases work with PULL:

| Use Case | How PULL Supports It |
|----------|---------------------|
| **MyHealth@EU Cross-Border** | NCP [Consumer] queries Producer EHRs in patient's home country for Patient Summary |
| **Health Data Access Service** | HDAS [Consumer] queries Producer EHRs and displays data to patient |
| **Health Professional Access Service** | HPAS [Consumer] queries Producer EHRs and displays data to professional |
| **Cross-Organization Sharing** | GP EHR [Consumer] queries Hospital EHR [Producer] at point of care |

**2. Authorization Control**

PULL provides better authorization control:
- **PULL:** Producer evaluates authorization **at request time** for specific Consumer. Producer can deny based on current policies, patient opt-out, professional role, treatment relationship.
- **PUSH:** Producer must authorize Consumer for **permission to receive data** without knowing downstream use context.

**3. Consumer-Driven**

- **PULL:** Consumer retrieves the specific data it needs
- **PUSH:** Producer must guess which Consumer wants data and which data to send

**4. No Workflow Event Needed**

For some data types (e.g., Patient Summary), there is no clear workflow event that would trigger a PUSH. With PULL, Consumer can query for Patient Summary ad-hoc when needed.

**5. Fits Diverse Member State Architectures**

PULL is architecture-agnostic:
- Works with centralized, federated, and hybrid infrastructures
- Member States can layer additional patterns on top (notified pull, indexed pull)
- Maintains flexibility for Member State architectural choices

#### 5.1.4 PUSH Use Cases (Not Excluded)

PUSH architecture may be added for specific scenarios:
- **Workflow-based notifications** (e.g., medication dispensation event in ePrescription workflows)
- **Priority category-specific workflows** defined by WP6/WP7
- **Member State options** (e.g., archiving to central repository)

**Implementation in This IG:**
- **Baseline:** PULL pattern for document and resource exchange
- **Extensible:** Priority categories may define additional PUSH transactions
- **Member State Hooks:** Can add notification triggers

**Reference:** D5.1 §3.1.4 for complete analysis.

### 5.2 Documents vs. Resources

**Decision:** Support **both** document-based and resource-based exchange patterns. They are **complementary, not mutually exclusive**.

#### 5.2.1 Two Exchange Paradigms

**Document-Based Exchange (IHE MHD):**
- Exchange complete structured documents (e.g., Patient Summary, Lab Report)
- FHIR Document = Composition + Bundle of resources
- Digital signatures for non-repudiation
- Fits Member States with document-centric workflows

**Resource-Based Exchange (IHE QEDm/IPA - "EU Core"):**
- Fine-grained access to individual FHIR resources (Observation, Condition, etc.)
- Dynamic composition by consumer
- Enables innovation beyond predefined use cases
- Essential for distributed data scenarios

#### 5.2.2 Why Both Patterns?

**Document-Based Use Cases:**
1. Clinical tradition of signed structured documents
2. MyHealth@EU currently uses document-based exchange
3. Short-term pragmatic path for existing workflows

**Resource-Based Use Cases:**
1. **Innovation:** New applications without new API specifications
   - Clinical decision support queries Observations
   - Medication reconciliation retrieves MedicationRequests
   - Patient timeline assembles Encounters/Procedures/Conditions dynamically
2. **Reusability:** Same Observation API used by Lab Reports, Hospital Discharge, Medical Imaging
3. **Distributed Data:** Essential for Member States where patient data is split across providers
4. **Long-term foundation** for internal market innovation

#### 5.2.3 EU Core Concept

**"EU Core"** refers to a standardized set of fine-grained FHIR Resource APIs that:
- Are reusable across multiple priority categories
- Enable resource-level access to clinical data
- Support innovation beyond predefined use cases
- Mirror successful approaches in other markets (US Core, IPS Library)

**Example:**

Instead of separate APIs per priority category:
- ❌ Patient Summary Document API
- ❌ Lab Report Document API
- ❌ Hospital Discharge Document API

Use reusable resource APIs:
- ✅ Observation API → used by Lab, Discharge, Imaging
- ✅ Condition API → used by Patient Summary, Discharge
- ✅ MedicationRequest API → used by Patient Summary, ePrescription

**Business Case:** Reduces implementation burden. New priority categories reuse existing resource APIs rather than requiring new APIs.

#### 5.2.4 Distributed Data Scenario

In Member States where patient data is distributed across healthcare providers:

**Document-Based Challenge:**
- Query each provider for "Patient Summary document"
- Each returns partial Patient Summary
- Consumer must merge/reconcile multiple documents (complex)

**Resource-Based Solution:**
- Query Hospital A: `/Condition?patient=X`, `/Procedure?patient=X`
- Query GP: `/AllergyIntolerance?patient=X`, `/Immunization?patient=X`
- Query Lab: `/Observation?patient=X&category=laboratory`
- Consumer assembles resources into Patient Summary view (natural fit)

#### 5.2.5 IHE QEDm as EU Core Foundation

IHE Query for Existing Data for Mobile (QEDm) provides:
- Reusable resource queries across use cases
- Mobile-friendly RESTful FHIR API
- Provenance linking resources to source documents
- XDS compatibility (bridge between document and resource paradigms)

**EU Core could be defined as:**
- IHE QEDm base specification
- + EU-specific profiles (HL7 EU Core resources)
- + Priority category search parameters
- + EEHRxF conformance requirements

**Reference:** D5.1 §6.5 for complete analysis.

### 5.3 Communication Patterns

The PULL-based interoperability component is a **building block** that Member States compose with national infrastructure to create various communication patterns.

| Pattern | Description | IG Support |
|---------|-------------|-----------|
| **Pull (1-to-1)** | Consumer queries Producer directly | ✅ Core functionality |
| **Notified Pull** | Producer notifies Consumer, Consumer pulls | ✅ Supports pull with location parameter |
| **Indexed Pull (1-to-N)** | Producer publishes to registry, Consumer searches, pulls | ✅ Supports pull with location parameter |
| **Discovery Pull (1-to-N)** | Consumer uses discovery service, then pulls | ✅ Responds to discovery queries |
| **Publish-Subscribe** | Producer publishes, notifications trigger pulls | ✅ Supports pull part |
| **Synchronize** | Batch export for system replacement | ✅ Batch queries supported |

**Key Insight:** From an implementation view, the interoperability component implements one pattern (PULL). Member State "infrastructure hooks" adapt to MS-specific patterns.

**Reference:** D5.1 §6.3 for detailed analysis of communication patterns.

---

## 6. Patient Rights Support

The interoperability component provides **technical capabilities** to support patient rights. Procedural implementation is the responsibility of Member States and healthcare providers.

**How Interoperability Component Supports Selected Rights:**

| EHDS Article | Patient Right | Technical Support via This IG |
|--------------|---------------|------------------------------|
| **Article 3** | Access to data via HDAS | HDAS [Consumer] uses PULL APIs to query Producer EHRs |
| **Article 5** | Upload data | Data inserted into EHR, accessible via PULL APIs |
| **Article 6** | Rectification | Flows from HDAS to EHR systems (MS-specific procedure) |
| **Article 7** | Data portability | Consumer EHR (new provider) pulls from Producer EHR (old provider) |
| **Article 9** | Transparency/Audit | Logging component (separate from interoperability) |
| **Article 10** | Opt-out | Enforced by denying PULL requests where patient opted out |

**Reference:** D5.1 §7.2 for detailed analysis.

---

## 7. Security and Privacy

### 7.1 System-Level vs. User-Level Authorization

**This IG Covers: System-Level Authorization**
- Producer authorizes Consumer **system** to access data
- Uses SMART Backend Services + IHE IUA
- System-to-system trust establishment

**Out of Scope: User-Level Authorization**
- Authentication of individual healthcare professionals
- Authentication of patients
- User-level access policies
- Member State responsibility (eIDAS, national eID, authorization services)

**Why System-Level is Sufficient:**
1. Producer controls data release to authorized Consumer systems at request time
2. Consumer system enforces user-level access control internally
3. Both Producer and Consumer log access for end-to-end traceability
4. Member States can add user-level attestation via national infrastructure

**Reference:** D5.1 §3.3.2 scopes interoperability component authorization to system-level.

### 7.2 Policy Enforcement Point (PEP) Architecture

The interoperability component includes a **Policy Enforcement Point (PEP)** that:
- Intercepts API requests
- Validates authorization tokens
- Calls Policy Decision Point (PDP) for authorization decisions
- Enforces allow/deny decisions

**Member State Variability:**

| Model | Description | Token Handling |
|-------|-------------|----------------|
| **Centralized** | PDP/PIP as national/regional service; PEP calls central service for requests | Token carries authorization attributes from central service |
| **Federated** | PDP/PIP embedded in Producer EHR; Distributed authorization rules | Token validated locally |
| **Hybrid** | Mix of central and local; Layered authorization checks | Multiple trust anchors |

**This IG's Approach:** Defines system-level authorization interface (token exchange, validation). PEP/PDP/PIP architecture and user-level flows are Member State-specific.

**Reference:** D5.1 §6.4 for detailed PEP architecture analysis.

### 7.3 Transport Security

All communications SHALL use TLS 1.2 or higher for transport encryption.

**Requirement:** D5.1 `api-encryption` (EHDS Annex II §1.4, Art. 36(3)(e))

---

## 8. References

### 8.1 Regulatory References

- **EHDS Regulation:** [Regulation (EU) 2025/327 on the European Health Data Space (EUR-Lex)](https://eur-lex.europa.eu/eli/reg/2025/327/oj/eng)
- **EHDS Annex II:** [Annex II - Essential Requirements (Ringholm Reference)](https://www.ringholm.com/ehds/annex-ii.htm)
- **Xt-EHR D5.1:** Deliverable 5.1 - Requirements for Harmonized Software Components of EHR Systems

### 8.2 Technical References

- **IHE MHD:** [Mobile Health Documents](https://profiles.ihe.net/ITI/MHD/)
- **IHE QEDm:** [Query for Existing Data for Mobile](https://profiles.ihe.net/PCC/QEDm/)
- **IHE PDQm:** [Patient Demographics Query for Mobile](https://profiles.ihe.net/ITI/PDQm/)
- **IHE IUA:** [Internet User Authorization](https://profiles.ihe.net/ITI/IUA/)
- **SMART Backend Services:** [HL7 SMART App Launch - Backend Services](https://hl7.org/fhir/smart-app-launch/backend-services.html)

### 8.3 Priority Category Content Profiles

- [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/)
- [HL7 Europe Medication Prescription and Dispense](https://build.fhir.org/ig/hl7-eu/mpd/)
- [HL7 Europe Laboratory Report](https://build.fhir.org/ig/hl7-eu/laboratory/)
- [HL7 Europe Hospital Discharge Report](https://build.fhir.org/ig/hl7-eu/hdr/)
- [HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/)

---

## 9. Additional Resources

### 9.1 Complete Requirements Traceability

See [Requirements Traceability](requirements-traceability.html) for detailed mapping of all 26 D5.1 requirements to this IG.

### 9.2 D5.1 Drafting Principles

D5.1 was developed following 11 key principles that shaped its scope:

1. **Regulatory Scope:** Requirements grounded in EHDS text and Annex II
2. **Separation of Concerns:** EHR obligations vs. Member State obligations
3. **EHR System Diversity:** Apply across small and large systems
4. **MS Architecture Diversity:** Support centralized, federated, hybrid
5. **Functional Requirements:** D5.1 defines WHAT, IGs define HOW
6. **Minimize Disruption:** Avoid forcing infrastructure changes
7. **Document + Resource Support:** Both paradigms supported
8. **Avoid Workflow Burden:** Don't prescribe excessive clinical tasks
9. **Logging as EHR Obligation:** Local logging required, aggregation is MS choice
10. **Explain Boundaries:** Narrative clarifies EHR vs. MS scope
11. **Common Specification Structure:** Consistent requirement format

These principles explain why certain requirements are in or out of D5.1 scope, and inform this IG's design decisions.

### 9.3 Glossary

- **Consumer:** System that queries/retrieves data from external systems
- **Producer:** System that offers API access to stored/intermediated data
- **Exchanger:** Intermediary system (HIE, NCP) routing between systems
- **HDAS:** Health Data Access Service (patient access to their data)
- **HPAS:** Health Professional Access Service (professional access for treatment)
- **NCP:** National Contact Point (cross-border gateway)
- **EEHRxF:** European Electronic Health Record Exchange Format
- **EU Core:** Reusable fine-grained resource APIs concept
- **PULL:** Consumer-initiated query pattern
- **PUSH:** Producer-initiated send pattern
- **MS Infrastructure Hooks:** EHR adapts to Member State-specific requirements

---

*This page provides regulatory context for this Implementation Guide. For technical specifications, see [Actors and Transactions](actors.html), [Authorization](authorization.html), [Patient Matching](patient-match.html), [Document Exchange](document-exchange.html), and [Resource Access](resource-access.html).*
