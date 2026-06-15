Instance: RaceClass
InstanceOf: ConceptMap
Description: "Mapping of US Core OMB race codes (urn:oid:2.16.840.1.113883.6.238) to OMOP concept ids"
Usage: #definition
* title = "US Core Race codes to OMOP"
* name = "USCoreRaceOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "urn:oid:2.16.840.1.113883.6.238"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #2106-3
    * target
      * code = #8527
      * display = "White"
      * equivalence = #equivalent
  * element[+]
    * code = #2054-5
    * target
      * code = #8516
      * display = "Black or African American"
      * equivalence = #equivalent
  * element[+]
    * code = #2028-9
    * target
      * code = #8515
      * display = "Asian"
      * equivalence = #equivalent
  * element[+]
    * code = #1002-5
    * target
      * code = #8657
      * display = "American Indian or Alaska Native"
      * equivalence = #equivalent
  * element[+]
    * code = #2076-8
    * target
      * code = #8557
      * display = "Native Hawaiian or Other Pacific Islander"
      * equivalence = #equivalent
  * element[+]
    * code = #2131-1
    * target
      * code = #8522
      * display = "Other Race"
      * equivalence = #equivalent

Instance: EthnicityClass
InstanceOf: ConceptMap
Description: "Mapping of US Core OMB ethnicity codes (urn:oid:2.16.840.1.113883.6.238) to OMOP concept ids"
Usage: #definition
* title = "US Core Ethnicity codes to OMOP"
* name = "USCoreEthnicityOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "urn:oid:2.16.840.1.113883.6.238"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #2135-2
    * target
      * code = #38003563
      * display = "Hispanic or Latino"
      * equivalence = #equivalent
  * element[+]
    * code = #2186-5
    * target
      * code = #38003564
      * display = "Not Hispanic or Latino"
      * equivalence = #equivalent

Instance: GenderClass
InstanceOf: ConceptMap
Description: "An example mapping of FHIR AdministrativeGender codes to OMOP concept ids"
Usage: #definition
* title = "AdministrativeGender codes to OMOP"
* name = "AdministrativeGenderOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://hl7.org/fhir/administrative-gender"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #male
    * target
      * code = #8507
      * display = "Male"
      * equivalence = #equivalent
  * element[+]
    * code = #female
    * target
      * code = #8532
      * display = "Female"
      * equivalence = #equivalent
  * element[+]
    * code = #other
    * target
      * code = #44814653
      * display = "Other"
      * equivalence = #equivalent
  * element[+]
    * code = #unknown
    * target
      * code = #8551
      * display = "Unknown"
      * equivalence = #equivalent