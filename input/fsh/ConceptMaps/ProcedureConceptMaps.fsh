Instance: ProcedureType
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Procedure type codes to OMOP concept ids"
Usage: #definition
* title = "Procedure type codes to OMOP"
* name = "ProcedureTypeOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://hl7.org/fhir/ValueSet/procedure-code"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #233404000
    * target
      * code = #4051039
      * display = "Insertion of arterial stent"
      * relationship = #equivalent
  * element[+]
    * code = #233258006
    * target
      * code = #4050128
      * display = "Fluoroscopy guided angioplasty of artery with contrast"
      * relationship = #equivalent      
  * element[+]
    * code = #no-known-procedures
    * target
      * code = #37204085
      * display = "No known procedures"
      * relationship = #equivalent