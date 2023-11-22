Logical: ProcedureOccurrence
Parent: Base
Id: ProcedureOccurrence
Characteristics: #can-be-target
Title: "Procedure Occurrence OMOP Table"
Description: "This table contains records of activities or processes ordered by, or carried out by, a healthcare provider on the patient with a diagnostic or therapeutic purpose."

* procedure_occurrence_id 1..1 integer "Procedure Occurrence Identifier" "The unique key given to a procedure record for a person. Refer to the ETL for how duplicate procedures during the same visit were handled."
* person_id 1..1 Reference(Person) "Person" "The PERSON_ID of the PERSON for whom the procedure is recorded. This may be a system generated code."
* procedure_concept_id 1..1 code "Procedure" "The PROCEDURE_CONCEPT_ID field is recommended for primary use in analyses, and must be used for network studies. This is the standard concept mapped from the source value which represents a procedure"
* procedure_date 1..1 date "Procedure Date" "Use this date to determine the date the procedure started."
* procedure_datetime 0..1 dateTime "Procedure Datetime" ""
* procedure_end_date 0..1 date "Procedure End Date" "Use this field to house the date that the procedure ended."
* procedure_end_datetime 0..1 dateTime "procedure_end_datetime" "Use this field to house the datetime that the procedure ended."
* procedure_type_concept_id 1..1 code "Procedure Type" "This field can be used to determine the provenance of the Procedure record, as in whether the procedure was from an EHR system, insurance claim, registry, or other sources."
* modifier_concept_id 0..1 code "Modifier" "The modifiers are intended to give additional information about the procedure but as of now the vocabulary is under review."
* quantity 0..1 integer "Quantity" "If the quantity value is omitted, a single procedure is assumed."
* provider_id 0..1 Reference(Provider) "Provider" "The provider associated with the procedure record, e.g. the provider who performed the Procedure."
* visit_occurrence_id 0..1 Reference(VisitOccurrence) "VisitOccurrence" "The visit during which the procedure occurred."
* visit_detail_id 0..1 Reference(VisitDetail) "Visit Detail" "The VISIT_DETAIL record during which the Procedure occurred. For example, if the Person was in the ICU at the time of the Procedure the VISIT_OCCURRENCE record would reflect the overall hospital stay and the VISIT_DETAIL record would reflect the ICU stay during the hospital visit."
* procedure_source_value 0..1 string "Procedure Source Value" "This field houses the verbatim value from the source data representing the procedure that occurred. For example, this could be an CPT4 or OPCS4 code."
* procedure_source_concept_id 0..1 code "Procedure Source Concept" "This is the concept representing the procedure source value and may not necessarily be standard. This field is discouraged from use in analysis because it is not required to contain Standard Concepts that are used across the OHDSI community, and should only be used when Standard Concepts do not adequately represent the source detail for the Procedure necessary for a given analytic use case. Consider using PROCEDURE_CONCEPT_ID instead to enable standardized analytics that can be consistent across the network."
* modifier_source_value 0..1 string "Modifier Source Value" ""