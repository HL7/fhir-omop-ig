Instance: ImmunizationSource
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Immunization information source codes to OMOP concept ids"
Usage: #definition
* title = "Immunization information source codes to OMOP"
* name = "ImmunizationSourceOMOPMapping"
* status = #draft
* experimental = true

* group
  * source = "http://terminology.hl7.org/CodeSystem/immunization-origin"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #recall
    * target
      * code = #32865
      * display = "Patient self-report"
      * equivalence = #equivalent
  * element[+]
    * code = #record
    * target
      * code = #32848
      * display = "Government report"
      * equivalence = #narrower
  * element[+]
    * code = #school
    * target
      * code = #32848
      * display = "Government report"
      * equivalence = #narrower
  * element[+]
    * code = #provider
    * target
      * code = #32818
      * display = "EHR administration record"
      * equivalence = #narrower

Instance: ImmunizationRoute
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Immunization route codes to OMOP concept ids"
Usage: #definition
* title = "Immunization route codes to OMOP"
* name = "ImmunizationRouteOMOPMapping"
* status = #draft
* experimental = true

* group
  * source = "http://terminology.hl7.org/CodeSystem/v3-RouteOfAdministration"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #IDINJ
    * target
      * code = #4156706
      * display = "Intradermal"
      * equivalence = #equivalent
  * element[+]
    * code = #IM
    * target
      * code = #4302612
      * display = "Intramuscular"
      * equivalence = #equivalent
  * element[+]
    * code = #IVINJ
    * target
      * code = #4171047
      * display = "Intravenous"
      * equivalence = #equivalent
  * element[+]
    * code = #PO
    * target
      * code = #4132161
      * display = "Oral"
      * equivalence = #equivalent
  * element[+]
    * code = #SQ
    * target
      * code = #4142048
      * display = "Subcutaneous"
      * equivalence = #equivalent
  * element[+]
    * code = #TRNSDERM
    * target
      * code = #4262099
      * display = "Transdermal"
      * equivalence = #equivalent

Instance: ImmunizationVaccine
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Immunization vaccine codes to OMOP concept ids"
Usage: #definition
* title = "Immunization vaccine codes to OMOP"
* name = "ImmunizationVaccineOMOPMapping"
* status = #draft
* experimental = true

* group
  * source = "http://hl7.org/fhir/sid/cvx"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #140
    * target
      * code = #40213154
      * display = "Influenza, split virus, trivalent, injectable, preservative free"
      * equivalence = #equivalent
  * element[+]
    * code = #141
    * target
      * code = #40213153
      * display = "Influenza, split virus, trivalent, injectable, contains preservative"
      * equivalence = #equivalent
  * element[+]
    * code = #171
    * target
      * code = #40213143
      * display = "Influenza, Madin Darby Canine Kidney, subunit, quadrivalent, injectable, preservative free"
      * equivalence = #equivalent
