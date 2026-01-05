# IG Restructuring Plan

## Target Architecture

### 5 Actors

**Document Exchange:**
- **Document Producer** - auth client, mhd push, patient identity consumer
- **Document Access Provider** - auth server, mhd receive/serve, patient identity source
- **Document Consumer** - auth client, patient identity consumer, mhd query/retrieve

**Resource Exchange:**
- **Resource Access Provider** - auth server, patient identity source, QEDM/IPA server
- **Resource Consumer** - auth client, patient identity consumer, FHIR search client

### Transactions

- T1: Inspect (metadata) - keep
- T2: Find Patient - keep
- **T3: Publish Documents (MHD push/ITI-65)** - ADD
- T4: Search Documents (MHD ITI-67)
- T5: Retrieve Document (MHD ITI-66)
- T6: Search Resources (QEDM) - optional

## Changes from Existing IG

### Add
- MHD push (T3) - critical missing piece
- Document Producer actor
- Make auth **required** (not optional)

### Remove
- T4 Import (admin UI)
- T5 Export (admin UI/bulk)
- Administrator actor
- ITI-1 (Maintain Time) - overkill
- "Authorization Option" section

### Reframe
- Context page use cases → deployment patterns of same API
- 6 actors → 5 actors (cleaner grouping)

## Key Principles

1. **Simplest thing that works**
2. **Required auth** (SMART Backend Services)
3. **Programmatic document push** (not just pull + admin UI)
4. **One API, multiple deployment patterns** (not different APIs)
5. **Clinical content lives in external IGs** (priority area IGs)
