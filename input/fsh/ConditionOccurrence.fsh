Logical: ConditionOccurrence
Parent: Base
Id: ConditionOccurrence
Characteristics: #can-be-target
Title: "Condition Occurrence OMOP Table"
Description: "This table contains records of Events of a Person suggesting the presence of a disease or medical condition stated as a diagnosis, a sign, or a symptom, which is either observed by a Provider or reported by the patient."

* condition_occurrence_id 1..1 integer "Condition Occurence Identifier" "The unique key given to a condition record for a person. Refer to the ETL for how duplicate conditions during the same visit were handled."
* person_id 1..1 Reference(Person) "Person" "The PERSON_ID of the PERSON for whom the condition is recorded."
* condition_concept_id 1..1 code "Condition" "The CONDITION_CONCEPT_ID field is recommended for primary use in analyses, and must be used for network studies. This is the standard concept mapped from the source value which represents a condition"
* condition_start_date 1..1 date "Condition Start Date" "Use this date to determine the start date of the condition"
* condition_start_datetime 0..1 dateTime "Condition Start Datetime" ""
* condition_end_date 0..1 date "Condition End Date" "Use this date to determine the end date of the condition"
* condition_end_datetime 0..1 dateTime "Condition End Datetime" ""
* condition_type_concept_id 1..1 code "Condition Type" "This field can be used to determine the provenance of the Condition record, as in whether the condition was from an EHR system, insurance claim, registry, or other sources."
* condition_status_concept_id 0..1 code "Condition Status" "This concept represents the point during the visit the diagnosis was given (admitting diagnosis, final diagnosis), whether the diagnosis was determined due to laboratory findings, if the diagnosis was exclusionary, or if it was a preliminary diagnosis, among others."
* stop_reason 0..1 string "Stop Reason" "The Stop Reason indicates why a Condition is no longer valid with respect to the purpose within the source data. Note that a Stop Reason does not necessarily imply that the condition is no longer occurring."
* provider_id 0..1 Reference(Provider) "Provider" "The provider associated with condition record, e.g. the provider who made the diagnosis or the provider who recorded the symptom."
* visit_occurrence_id 0..1 Reference(VisitOccurrence) "Visit Occurrence" "The visit during which the condition occurred."
* visit_detail_id 0..1 Reference(VisitDetail) "Visit Detail" "The VISIT_DETAIL record during which the condition occurred. For example, if the person was in the ICU at the time of the diagnosis the VISIT_OCCURRENCE record would reflect the overall hospital stay and the VISIT_DETAIL record would reflect the ICU stay during the hospital visit."
* condition_source_value 0..1 string "Condition Source Value" "This field houses the verbatim value from the source data representing the condition that occurred. For example, this could be an ICD10 or Read code."
* condition_source_concept_id 0..1 code "Condition Source Concept" "This is the concept representing the condition source value and may not necessarily be standard. This field is discouraged from use in analysis because it is not required to contain Standard Concepts that are used across the OHDSI community, and should only be used when Standard Concepts do not adequately represent the source detail for the Condition necessary for a given analytic use case. Consider using CONDITION_CONCEPT_ID instead to enable standardized analytics that can be consistent across the network."
* condition_status_source_value 0..1 string "Condition Status Source Value" "This field houses the verbatim value from the source data representing the condition status."