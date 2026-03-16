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
      * relationship = #equivalent
  * element[+]
    * code = #female
    * target
      * code = #8532
      * display = "Female"
      * relationship = #equivalent
  * element[+]
    * code = #other
    * target
      * code = #44814653
      * display = "Other"
      * relationship = #equivalent
  * element[+]
    * code = #unknown
    * target
      * code = #8551
      * display = "Unknown"
      * relationship = #equivalent