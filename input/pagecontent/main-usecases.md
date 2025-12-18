As is explained by {{EXtEHR_WP5_1}} , the {{EHDS}} regulation requires EHR systems support a set of basic use cases. 

The main actors and use cases are illustrated in the figure below.

{% include img.html img="main-actors-and-usecases.drawio.png" caption="Figure: Actors and use cases" %}

Two different actors are introduced:

* **Administrator:** this actor maintains the system, in the context of EHDS it must be able to export EEHRxF data from the system and import it.
* **Consumer:** this actor access the information in the system.
* **Provider:** this actor provides access to EEHRxF data
* **Wellness App:** a wellness application that may provide data to an EHR system
* **Patietn:**: a Patient managing its data in the EHDS

The definition of the different use cases is:

* **Inspect:** the Consumer accesses the system and inspects its capabilities which include what priority area's it support and the available mechanisms to access that data.
* **Access data:** the Consumer uses the information retrieved using inspect to locate and access the required information.
* **Import data:** the Administrator updates the information in the EHR system with EERHxF data
* **Export data:** the Administrator exports all or part of the EERHxF information in the EHR system
* **Upload data:** the Patient uploads new data
* **Correct data:** the Patient proposes a data correction
* **Manage authorization:** the Patient changes the authorization configuration, this includes opting out and authorizing other parties to see (part of) his/her data.
* **Provide Wellness data:** a Wellness app provides wellness data to an EHR system