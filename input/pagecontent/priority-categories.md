EHDS defines priority categories of health data for interoperability. Each has a content profile defining the data model, maintained in separate Content IGs.

This API IG defines interoperability *behavior* - the transactions and exchange patterns that systems use to share data. It does not prescribe internal system architecture or design. Systems that choose to comply with EHDS interoperability requirements implement this behavior alongside one or more Content IGs.

### Priority Category Pages

| Priority Category | API Guidance |
|-------------------|--------------|
| Patient Summary | [Patient Summary](priority-area-eps.html) |
| Medical Test Results | [Laboratory](priority-area-laboratory.html) |
| Hospital Discharge Report | [Discharge Report](priority-area-hdr.html) |
| Medical Imaging | [Imaging Manifest](priority-area-imaging-manifest.html) |
| ePrescription / eDispensation | [MPD](priority-area-mpd.html) |

### Exchange Patterns

| Priority Category | Exchange Pattern |
|-------------------|------------------|
| Patient Summary | Document ([MHD](document-exchange.html)) |
| Medical Test Results | Document ([MHD](document-exchange.html)) |
| Hospital Discharge Report | Document ([MHD](document-exchange.html)) |
| Imaging Manifest | Document ([MHD](document-exchange.html)) |
| ePrescription / eDispensation | See note below |

For document search and differentiation by priority category, see [Document Exchange](document-exchange.html).

**Note on MPD:** ePrescription/eDispensation uses workflow transactions defined by IHE MPD, not document exchange. See [Open Issue #11](open-issues.html#issue-11-mpd-workflow-vs-medicationrequest-resource-access).

