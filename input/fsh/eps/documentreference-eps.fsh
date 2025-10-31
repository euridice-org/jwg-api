Profile: EpsMhdDocumentReference
Parent: EehrxfMhdDocumentReference
Title: "EPS MHD DocumentReference Profile"
Description: "Profile for DocumentReference resources used in the EEHRxF EPS context, based on the IHE MHD Minimal DocumentReference profile."
* insert SetFmmAndStatusRule( 1, #draft )
* category = $xds-class-code#REPORTS
* type 1..1
  * coding 1..*
    * insert SliceElement( #value, coding )
  * coding contains documentType 1..1
  * coding[documentType] = $loinc#60591-5  "Patient summary Document"  
