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
      * equivalence = #equivalent  
  * element[+]
    * code = #386661006
    * target
      * code = #437663
      * display = "Fever"
      * equivalence = #equivalent
  * element[+]
    * code = #36225005
    * target
      * code = #4264681
      * display = "Acute renal failure due to procedure"
      * equivalence = #equivalent
  * element[+]
    * code = #363346000
    * target
      * code = #443392
      * display = "Malignant neoplastic disease"
      * equivalence = #equivalent
  * element[+]
    * code = #87628006
    * target
      * code = #432545
      * display = "Bacterial infectious disease"
      * equivalence = #equivalent
  * element[+]
    * code = #368009
    * target
      * code = #4281749
      * display = "Heart valve disorder"
      * equivalence = #equivalent
  * element[+]
    * code = #254637007
    * target
      * code = #4115276
      * display = "Non-small cell lung cancer"
      * equivalence = #equivalent
  * element[+]
    * code = #18099001
    * target
      * code = #437580
      * display = "Retropharyngeal abscess"
      * equivalence = #equivalent
  * element[+]
    * code = #422504002
    * target
      * code = #4310996
      * display = "Ischemic stroke"
      * equivalence = #equivalent
  * element[+]
    * code = #312824007
    * target
      * code = #4195970
      * display = "Family history of cancer of colon"
      * equivalence = #equivalent

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
    * code = #active
    * target
      * code = #32902
      * display = "Primary diagnosis"
      * equivalence = #relatedto
  * element[+]
    * code = #inactive
    * target
      * code = #32907
      * display = "Secondary admission diagnosis"
      * equivalence = #relatedto
  * element[+]
    * code = #resolved
    * target
      * code = #32906
      * display = "Resolved condition"
      * equivalence = #equivalent 
