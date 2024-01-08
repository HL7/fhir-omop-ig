Logical: Death
Parent: Base
Id: Death
Characteristics: #can-be-target
Title: "Death OMOP Table"
Description: "The death domain contains the clinical event for how and when a Person dies. A person can have up to one record if the source system contains evidence about the Death, such as: Condition in an administrative claim, status of enrollment into a health plan, or explicit record in EHR data."

* person_id 1..1 Reference(Person) "Person" ""
* death_date 1..1 date "Death Date" "The date the person was deceased."
* death_datetime 0..1 dateTime "Death Datetime" ""
* death_type_concept_id 0..1 code "Death Type" "This is the provenance of the death record, i.e., where it came from. It is possible that an administrative claims database would source death information from a government file so do not assume the Death Type is the same as the Visit Type, etc."
* cause_concept_id 0..1 code "Cause" "This is the Standard Concept representing the Person's cause of death, if available."
* cause_source_value 0..1 string "Cause Source Value" ""
* cause_source_concept_id 0..1 code "Cause Source"
