{% include fsh-link-references.md %}
{% include variable-definitions.md %}

  <!-- Horizontal banner -->
<div style="border: 2px solid #003366; border-radius: 8px; padding: 1em; margin: 1.5em 0; background-color: #f9f9ff; display: flex; flex-direction: column; align-items: flex-start;">
  
  <!-- Logo -->
  <div style="margin-bottom: 1em;">
    <img src="xtehr-logo.png" alt="XTEHR Logo" style="max-width: 100%; height: 40px;" />
  </div>

  <!-- Acknowledgment text -->
  <div style="text-align: left; width: 100%;">
    <strong>Acknowledgment</strong><br/>
    The development of this Implementation Guide version has been supported by the 
    <strong>Xt-EHR Joint Action</strong>.  
    Xt-EHR provided expertise, alignment with European health policy priorities, 
    and validation of specifications to enable consistency with EHDS requirements.
  </div>
</div>

### Scope

This implementation guide provides a API specification that addresses the requirements set by {{XtEHR}} in {{XtEHR_WP5_1}}. It addresses:

* The eco-system in which the API's are deployed
* The actors and use cases
* The different deployment options that have been considered when designing these APIs
* The API to be implemented in order to support the different {{EHDS_priority_categories}} of the {{EHDS}}

The specification is to be used in a variety of deployment models, which includes the {{EHDS}} use cases: exchange data within healthcare organizations, across nations/regions and cross border information exchange. In all of these use cases it is important that it is compatible with the existing ecosystem.

<div xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <blockquote class="stu-note">  
   <p>Timeline:</p>
   <ul>
   <li>October/November 2025, initial version</li>
   </ul>
 </blockquote>
</div>

### Purpose

The goal of this Implementation Guide is to define an European standard for the Imaging Report to facilitate the harmonization among the national initiatives and prepare the ground for the European EHR eXchange Format (E-EHRxF).

The development of this implementation guide is promoted by HL7 Europe, but realized in collaboration with several other European and national organizations and projects. The aspiration of this guide is to be used as basis for European National Guides, the European EHRxF ,and - consequently - by MyHealth@EU for the EU cross-border services.

### FHIR specific Dependencies

<!-- include dependency-table-en.xhtml  -->

### Cross Version Analysis

<!-- include cross-version-analysis-en.xhtml  -->

### Global Profiles

<!-- include globals-table-en.xhtml  -->

### IP statements

<!-- include ip-statements-en.xhtml  -->
