# API IG Todo - MVP

- [x] Diff with Bas Copy
- [x] Overall Initial Outline, shape of the IG.
- [x] Understand IG Basics

## 1. Update Actor Model, Functional Basics (MVP)

- [x] README/Intro draft, outline and basic Actors model.
- [x] Actors & Transactions Narrative markdown.
- [ ] Rewrite input/fsh/Actors.fsh with 5 new actors
- [x] Shell Outline & Functional Pages


## Functional Pages
- [x] Capability Discovery (shell created)
- [x] Authorization (shell created)
- [x] Patient Matching (shell created)
- [x] Document Exchange (shell created)
- [x] Resource Access (shell created)


## Create CapabilityStatements
- [ ] cs-document-producer.fsh
- [ ] cs-document-access-provider.fsh
- [ ] cs-document-consumer.fsh
- [ ] cs-resource-access-provider.fsh
- [ ] cs-resource-consumer.fsh


## Cleanup Prev Content Content
- [ ] Refactor content from api-specification.md
- [ ] Refactor content from main-document.md
- [ ] Delete transaction-T4.md (Import)
- [ ] Delete transaction-T5.md (Export)
- [ ] Remove Administrator actor
- [ ] Delete T5-UiExport.fsh
- [ ] Delete T5-BulkdataExport.fsh
- [ ] Remove T4/T5 from sushi-config.yaml pages
- [ ] Remove all ITI-1 references in api-specification.md


## Get IG to Build
- [ ] Basic IG Publisher Setup (lvm)
- [ ] Build Prior Version to test
- [ ] Run _genonce.bat
- [ ] Fix errors in qa.html
- [ ] Verify all 5 actors compile
- [ ] Verify Pages Look OK


## Implementation Narrative
- [ ] Simple Use Case
- [ ] Reframe Use Cases. Update context.md - use cases as deployment patterns, not different APIs
- [ ] Review main-usecases.md for alignment. 
- [ ] Pages for EHDS Target Use Cases

## Other Narrative (Background/Intro)

---

# Detailed Refactoring Plan (from markdown-refactoring-plan.md)

## Status
- ✅ 5 functional shell pages created
- ✅ README updated with links to functional pages
- **Note:** Using IHE transaction numbers (ITI-65, ITI-67, ITI-68, ITI-78, PCC-44) instead of T1/T2/T3

## Pages to Update (User Tasks)

### High Priority Updates
- [ ] `index.md` - Rewrite home page with 5-actor model, goals, links to content IGs
- [ ] `api-specification.md` - Update to 5-actor model, remove ITI-1, add MHD transactions
- [ ] `regulatoryAnchors.md` - Expand with Xt-EHR 5.1 content, ANNEX II interpretation

### Medium Priority Updates
- [ ] `context.md` - Reframe from "different APIs" to "one API, multiple deployment patterns"
- [ ] `main-usecases.md` - Remove Administrator actor, update to 5-actor model
- [ ] `use-cases.md` - Reframe as deployment patterns (federated, central repo, NCP, HPAS, HDAS, wellness, system replacement)
- [ ] `transaction-T1.md` - Minor updates for alignment
- [ ] `transaction-T2.md` - Minor updates for alignment

### Low Priority Updates
- [ ] Priority area pages - Minor updates to emphasize API-level requirements only
- [ ] `design-considerations.md` - Update for MHD push, new actor model
- [ ] `adapting.md` - Update guidance for new model
- [ ] `xtehr-mapping.md` - Verify links current
- [ ] `content-FHIR-file.md` - Review/update if keeping
- [ ] `eps-specification.md` - Review for consolidation
- [ ] `dependencies.md` - Verify package versions
- [ ] `references.md` - Verify IHE/HL7 EU links
- [ ] `changes.md` - Add change log entry

## Configuration
- [ ] Update `sushi-config.yaml` menu structure:
  - Add new functional pages (capability-discovery, authorization, patient-matching, document-exchange, resource-access)
  - Organize into sections: Home, Introduction, Functional, Transactions, Implementation, Priority Areas, About

## Build & Validation
- [ ] Run `_genonce.bat` to build IG
- [ ] Fix errors in qa.html
- [ ] Verify all pages render correctly
- [ ] Check for broken links

## Later (After Confident)
- [ ] Delete/archive old `transaction-T4.md` (Import via UI)
- [ ] Delete/archive old `transaction-T5.md` (Export via UI/Bulk)
- [ ] Delete `T5-UiExport.fsh`, `T5-BulkdataExport.fsh` from input/fsh

## Key Principles
1. **5 actors, not 6** - No Administrator actor
2. **Authorization required** - SMART Backend Services, not optional
3. **Use IHE transaction numbers** - ITI-65, ITI-67, ITI-68, ITI-78, PCC-44 (not T1/T2/T3)
4. **One API, multiple deployments** - Not different APIs for different use cases
5. **API here, content in external IGs** - Separation of concerns
6. **Content registry** - Priority categories link to external HL7 EU IGs

## Target State
- **5 actors**: Document Producer, Document Access Provider, Document Consumer, Resource Access Provider, Resource Consumer
- **MHD document exchange**: ITI-65 (Publish), ITI-67 (Search), ITI-68 (Retrieve)
- **PDQm patient matching**: ITI-78
- **QEDm resource query**: PCC-44 (optional)
- **Authorization**: IUA + SMART Backend Services (required)
- **Content registry**: Priority categories → external IG canonical URLs
