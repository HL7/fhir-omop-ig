Instance: EncounterClass
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Encounter class codes to OMOP concept ids"
Usage: #definition
* title = "Encounter Class codes to OMOP"
* name = "EncounterClassOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #IMP
    * target
      * code = #9201
      * display = "Inpatient Visit"
      * relationship = #equivalent
  * element[+]
    * code = #AMB
    * target
      * code = #9202
      * display = "Outpatient Visit"
      * relationship = #equivalent
  * element[+]
    * code = #OBSENC
    * target
      * code = #262
      * display = "Emergency Room and Inpatient Visit"
      * relationship = #source-is-broader-than-target
      * comment = "The source code does not necessarily mean that the patient has moved to an inpatient visit"
  * element[+]
    * code = #EMER
    * target
      * code = #9203
      * display = "Emergency Room Visit"
      * relationship = #equivalent
  * element[+]
    * code = #VR
    * target
      * code = #722455
      * display = "Telehealth"
      * relationship = #equivalent
  * element[+]
    * code = #HH
    * target
      * code = #581476
      * display = "Home Visit"
      * relationship = #equivalent

Instance: EncounterAdmitSource
InstanceOf: ConceptMap
Usage: #definition
Description: "An example mapping of FHIR Encounter admission source codes to OMOP concept ids"
* title = "Encounter Admission Source codes to OMOP"
* name = "EncounterAdmitSourceOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://terminology.hl7.org/CodeSystem/admit-source"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #hosp-trans
    * target
      * code = #38004515
      * display = "Hospital"
      * relationship = #equivalent
  * element[+]
    * code = #emd
    * target
      * code = #8670
      * display = "Emergency Room - Hospital"
      * relationship = #equivalent
  * element[+]
    * code = #outp
    * target
      * code = #8756
      * display = "Outpatient Hospital"
      * relationship = #source-is-broader-than-target
      * comment = "The source code implies any outpatient facility and not just a hospital"
  * element[+]
    * code = #born
    * target
      * code = #38004515
      * display = "Hospital"
      * relationship = #source-is-narrower-than-target
  * element[+]
    * code = #gp
    * target
      * code = #8940
      * display = "Office"
      * relationship = #source-is-narrower-than-target
  * element[+]
    * code = #mp
    * target
      * code = #8940
      * display = "Office"
      * relationship = #source-is-narrower-than-target
  * element[+]
    * code = #nursing
    * target
      * code = #8676
      * display = "Nursing Facility"
      * relationship = #equivalent
  * element[+]
    * code = #psych
    * target
      * code = #8971
      * display = "Inpatient Psychiatric Facility"
      * relationship = #source-is-broader-than-target
      * comment = "The source code does not imply an inpatient facility"
  * element[+]
    * code = #rehab
    * target
      * code = #38004254
      * display = "Rehabilition Clinic/Center"
      * relationship = #equivalent
  * element[+]
    * code = #other
    * noMap = true

Instance: EncounterDischargeDisposition
InstanceOf: ConceptMap
Description: "An example mapping of FHIR Encounter discharge disposition codes to OMOP concept ids"
Usage: #definition
* title = "Encounter Discharge Disposition codes to OMOP"
* name = "EncounterDischargeDispositionOMOPMapping"
* status = #active
* experimental = true

* group
  * source = "http://terminology.hl7.org/CodeSystem/discharge-disposition"
  * target = "https://fhir-terminology.ohdsi.org"
  * element[+]
    * code = #home
    * target
      * code = #8536
      * display = "Home"
      * relationship = #equivalent
  * element[+]
    * code = #alt-home
    * target
      * code = #8536
      * display = "Home"
      * relationship = #source-is-narrower-than-target
  * element[+]
    * code = #other-hcf
    * target
      * code = #33007
      * display = "Alternate care site (ACS)"
      * relationship = #equivalent
  * element[+]
    * code = #hosp
    * target
      * code = #8546
      * display = "Hospice"
      * relationship = #equivalent
  * element[+]
    * code = #long
    * target
      * code = #38004277
      * display = "Long Term Care Hospital"
      * relationship = #source-is-broader-than-target
      * comment = "The source code does not imply a hospital but any long term care facility"
  * element[+]
    * code = #aadvice
    * target
      * code = #32216
      * display = "Left against medical advice or discontinued care."
      * relationship = #equivalent
  * element[+]
    * code = #exp
    * target
      * code = #32218
      * display = "Expired"
      * relationship = #equivalent
  * element[+]
    * code = #psy
    * target
      * code = #8971
      * display = "Inpatient Psychiatric Facility"
      * relationship = #source-is-broader-than-target
      * comment = "The source code does not imply an inpatient facility"
  * element[+]
    * code = #rehab
    * target
      * code = #32266
      * display = "Clinic-Outpatient Rehab Facility (ORF)"
      * relationship = #source-is-broader-than-target
      * comment = "The source code does not imply an outpatient facility"
  * element[+]
    * code = #snf
    * target
      * code = #8863
      * display = "Skilled Nursing Facility"
      * relationship = #equivalent
  * element[+]
    * code = #oth
    * noMap = true
