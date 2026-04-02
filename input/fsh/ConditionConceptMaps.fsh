Instance: ConditionConcepts
InstanceOf: ConceptMap
Description: "An example mapping of SNOMED Clinical Findings codes to OMOP concept ids"
Usage: #definition
* title = "Clinical Findings codes to OMOP"
* name = "ClinicalFindingsOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://snomed.info/sct"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #258710007
    * target
      * code = #586323
      * display = "degree Celsius"
      * relationship = #equivalent  
  * element[+]
    * code = #386661006
    * target
      * code = #437663
      * display = "Fever"
      * relationship = #equivalent
  * element[+]
    * code = #36225005
    * target
      * code = #4264681
      * display = "Acute renal failure due to procedure"
      * relationship = #equivalent
  * element[+]
    * code = #363346000
    * target
      * code = #443392
      * display = "Malignant neoplastic disease"
      * relationship = #equivalent

Instance: ConditionStatusConcepts
InstanceOf: ConceptMap
Description: "An example mapping of FHIR condition status codes to OMOP concept ids"
Usage: #definition
* title = "Condition status codes to OMOP"
* name = "ConditionStatusOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://terminology.hl7.org/CodeSystem/condition-clinical"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #resolved
    * target
      * code = #32906
      * display = "Resolved condition"
      * relationship = #equivalent 
