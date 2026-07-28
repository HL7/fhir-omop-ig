Instance: VitalSignsCodes
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Observation-vitalsigns codes to OMOP concept ids"
Usage: #definition
* title = "VitalSign codes to OMOP"
* name = "VitalSignsOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://loinc.org"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #85353-1
    * target
      * code = #36203184
      * display = "Vital signs, weight, height, head circumference, oxygen saturation and BMI panel"
      * relationship = #equivalent
  * element[+]
    * code = #9279-1
    * target
      * code = #3024171
      * display = "Respiratory rate"
      * relationship = #equivalent
  * element[+]
    * code = #8867-4
    * target
      * code = #3027018
      * display = "Heart rate"
      * relationship = #equivalent
  * element[+]
    * code = #2708-6
    * target
      * code = #3016502
      * display = "Oxygen saturation in Arterial blood"
      * relationship = #equivalent
  * element[+]
    * code = #8310-5
    * target
      * code = #3020891
      * display = "Body temperature"
      * relationship = #equivalent
  * element[+]
    * code = #8302-2
    * target
      * code = #3036277
      * display = "Body height"
      * relationship = #equivalent
  * element[+]
    * code = #9843-4
    * target
      * code = #3000053
      * display = "Head Occipital-frontal circumference"
      * relationship = #equivalent
  * element[+]
    * code = #29463-7
    * target
      * code = #3025315
      * display = "Body weight"
      * relationship = #equivalent
  * element[+]
    * code = #39156-5
    * target
      * code = #3038553
      * display = "Body mass index (BMI) [Ratio]"
      * relationship = #equivalent


Instance: BloodPressureCodes
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Observation-bloodpressure LOINC codes to OMOP concept ids"
Usage: #definition
* title = "Blood Pressure codes to OMOP"
* name = "BloodPressureOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://loinc.org"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #85354-9
    * target
      * code = #36203185
      * display = "Blood pressure panel with all children optional"
      * relationship = #equivalent
  * element[+]
    * code = #8480-6
    * target
      * code = #3004249
      * display = "Systolic blood pressure"
      * relationship = #equivalent
  * element[+]
    * code = #8462-4
    * target
      * code = #3012888
      * display = "Diastolic blood pressure"
      * relationship = #equivalent
  * element[+]
    * code = #8478-0
    * target
      * code = #3027598
      * display = "Mean blood pressure"
      * relationship = #equivalent