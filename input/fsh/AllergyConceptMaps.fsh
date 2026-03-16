Instance: AllergyType
InstanceOf: ConceptMap
Description: "An example mapping of FHIR AllergyIntolerance allergy category codes to OMOP concept ids"
Usage: #definition
* title = "AllergyIntolerance allergy category codes to OMOP"
* name = "AllergyTypeOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://hl7.org/fhir/allergy-intolerance-category"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #food
    * target
      * code = #4188027
      * display = "Allergy to food"
      * relationship = #equivalent
  * element[+]
    * code = #medication
    * target
      * code = #439224
      * display = "Allergy to drug"
      * relationship = #equivalent
  * element[+]
    * code = #environment
    * target
      * code = #4144450
      * display = "Environmental allergy"
      * relationship = #equivalent
  * element[+]
    * code = #biologic
    * target
      * code = #43530807
      * display = "Allergic disposition"
      * relationship = #source-is-narrower-than-target

Instance: IntoleranceType
InstanceOf: ConceptMap
Description: "An example mapping of FHIR AllergyIntolerance intolerance category codes to OMOP concept ids"
Usage: #definition
* title = "AllergyIntolerance intolerance category codes to OMOP"
* name = "IntoleranceTypeOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://hl7.org/fhir/allergy-intolerance-category"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #food
    * target
      * code = #4340252
      * display = "Intolerance to food"
      * relationship = #equivalent
  * element[+]
    * code = #medication
    * target
      * code = #4240582
      * display = "Intolerance to drug"
      * relationship = #equivalent
  * element[+]
    * code = #environment
    * target
      * code = #4172024
      * display = "Propensity to adverse reaction"
      * relationship = #source-is-narrower-than-target
  * element[+]
    * code = #biologic
    * target
      * code = #36684107
      * display = "Intolerance to substance"
      * relationship = #source-is-narrower-than-target

Instance: AllergySubstanceType
InstanceOf: ConceptMap
Description: "An example mapping of FHIR AllergyIntolerance substance code to OMOP concept ids"
Usage: #definition
* title = "AllergyIntolerance substance codes to OMOP"
* name = "AllergySubstanceTypeOMOPMapping"
* status = #draft
* experimental = true

* group
  * source = "http://snomed.info/sct"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #227493005
    * target
      * code = #4026477
      * display = "Cashew nut"
      * relationship = #equivalent
  * element[+]
    * code = #323389000
    * target
      * code = #1728416
      * display = "benzylpenicillin"
      * relationship = #equivalent
* group
  * source = "http://www.nlm.nih.gov/research/umls/rxnorm"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #7980
    * target
      * code = #1728416
      * display = "benzylpenicillin"
      * relationship = #equivalent
