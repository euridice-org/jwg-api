**European Interoperability Specifications for Digital Solutions in Healthcare (EURIDICE)**

An inititaive by HL7 Europe and IHE Europe. 

# EU Health Data API

In this repository a **co-branded HL7 Europe / IHE Europe Project** resides which specifies API definitions for accessing and exchanging European Electronic Health Record exchange Format (EEHRxF) (EHDS Article 15) data between systems.

We inherit the following HL7 EU Content Profiles below, which define the format of the data to be exchanged (primarily FHIR Documents constructed of FHIR resources):

* European Patient Summary (  [HL7 Europe Patient Summary](https://build.fhir.org/ig/hl7-eu/eps/) )
* Europe Medication Prescription and Dispense ([HL7 Europe Medication Prescription and Dispense](https://build.fhir.org/ig/hl7-eu/mpd/))
* Europe Laboratory Report ([HL7 Europe Laboratory Report v0.2.0-ci](https://build.fhir.org/ig/hl7-eu/laboratory/))
* Europe Hospital Discharge Report ([Europe Hospital Discharge Report](https://build.fhir.org/ig/hl7-eu/hdr/))
* Europe Imaging Study Report ([HL7 Europe Imaging Report](https://build.fhir.org/ig/hl7-eu/imaging/))
* Europe Imaging Study Manifest ([HL7 Europe Imaging Study Manifest R5](https://build.fhir.org/ig/hl7-eu/imaging-manifest/))

The goals of the **EU Health Data API** Implementation Guide are twofold:
1. **Define Exchange Pattern for EEHRxF Data:** Define how existing IHE profiles and other specifications can be used by to ***provide secure access to this data*** and enable the secure exchange of EEHRxF data between systems. 
2. **Satisfy the EHDS Interoperability Requirements:** Define how these technical capabilities satisfy the EHDS Interoperability requirements placed on EHR system in the EHDS Regulation

We define exchange patterns by include inheriting and defining transactions, system actors, and associated capability statements. 

## Regulatory Basis

From the regulatory perspective, the initial focus is to provide technical capabilities that satisfy the EHDS Interoperability requirements placed on EHR systems, specifically the obligations described in [EHDS ANNEX II](https://www.ringholm.com/ehds/annex-ii.htm) that require EHR systems to **provide access to data** and **receive data** formatted in EEHRxF.

We focus here on technical implementation of these requirements - The requirements themseleves and how they are applied are not defined in this IG. These are ultimately owned by the European Commission to be defined in the EHDS Implementing Acts. We inherit the work of the Xt-EHR Joint Action, which has created deliverables drafting these requirements - and focus here on providing a technical implementation of these requirements using the standards developed by the IHE and HL7 Community.

See [Regulatory Anchors](input/pagecontent/regulatoryAnchors.md) page for more detail on the link to the EHDS regulation requirements, and the technical interpretation of those requirements used here.

## Actors

See [actors.md](input/pagecontent/actors.md) for a detailed description of the actor model. 

TODO: Summary of this page for intro.

[Diagram]










## Authors

Josh Priebe, Epic

Bas van den Heuvel, Philips

Giorgio Cangioli, HL7 Europe

dr Kai Heitmann, HL7 Europe

Andreas Klingler, IHE Europe

Janos Vincze, IHE Europe


# Project Structure



# Page Structure


# Misc

- Diagrams are generated with excalidraw. See [Diagramd.md](diagrams/diagrams.md) for more information.


