Logical: Observation
Parent: Base
Id: Observation
Characteristics: #can-be-target
Title: "Observation OMOP Table"
Description: "The OBSERVATION table captures clinical facts about a Person obtained in the context of examination, questioning or a procedure. Any data that cannot be represented by any other domains, such as social and lifestyle facts, medical history, family history, etc. are recorded here."

* observation_id 1..1 code "Observation Identifier" 
* person_id 1..1 Reference(Person) "Person" "The PERSON_ID of the Person for whom the Observation is recorded. This may be a system generated code."
* observation_concept_id 1..1 code "Observation" "The OBSERVATION_CONCEPT_ID field is recommended for primary use in analyses, and must be used for network studies."
* observation_date 1..1 date "Observation Date" "The date of the Observation. Depending on what the Observation represents this could be the date of a lab test, the date of a survey, or the date a patient's family history was taken."
* observation_datetime 0..1 dateTime "Observation Datetime" ""
* observation_type_concept_id 1..1 code "Observation Type" "This field can be used to determine the provenance of the Observation record, as in whether the measurement was from an EHR system, insurance claim, registry, or other sources."
* value_as_number 0..1 integer "Value as Number" "This is the numerical value of the Result of the Observation, if applicable and available. It is not expected that all Observations will have numeric results, rather, this field is here to house values should they exist."
* value_as_string 0..1 string "Value as String" "This is the categorical value of the Result of the Observation, if applicable and available."
* value_as_concept_id 0..1 code "Value as Concept" "It is possible that some records destined for the Observation table have two clinical ideas represented in one source code. This is common with ICD10 codes that describe a family history of some Condition, for example. In OMOP the Vocabulary breaks these two clinical ideas into two codes; one becomes the OBSERVATION_CONCEPT_ID and the other becomes the VALUE_AS_CONCEPT_ID. It is important when using the Observation table to keep this possibility in mind and to examine the VALUE_AS_CONCEPT_ID field for relevant information."
* qualifier_concept_id 0..1 code "Qualifier" "This field contains all attributes specifying the clinical fact further, such as as degrees, severities, drug-drug interaction alerts etc."
* unit_concept_id 0..1 code "Unit" "There is currently no recommended unit for individual observation concepts. UNIT_SOURCE_VALUES should be mapped to a Standard Concept in the Unit domain that best represents the unit as given in the source data."
* provider_id 0..1 Reference(Provider) "Provider" "The provider associated with the observation record, e.g. the provider who ordered the test or the provider who recorded the result."
* visit_occurrence_id 0..1 Reference(VisitOccurrence) "Visit Occurence" "The visit during which the Observation occurred."
* visit_detail_id 0..1 Reference(VisitDetail) "Visit Detail" "The VISIT_DETAIL record during which the Observation occurred. For example, if the Person was in the ICU at the time the VISIT_OCCURRENCE record would reflect the overall hospital stay and the VISIT_DETAIL record would reflect the ICU stay during the hospital visit."
* observation_source_value 0..1 string "Observation Source Value" "This field houses the verbatim value from the source data representing the Observation that occurred. For example, this could be an ICD10 or Read code."
* observation_source_concept_id 0..1 code "Observation Source" "This is the concept representing the OBSERVATION_SOURCE_VALUE and may not necessarily be standard. This field is discouraged from use in analysis because it is not required to contain Standard Concepts that are used across the OHDSI community, and should only be used when Standard Concepts do not adequately represent the source detail for the Observation necessary for a given analytic use case. Consider using OBSERVATION_CONCEPT_ID instead to enable standardized analytics that can be consistent across the network."
* unit_source_value 0..1 string "Unit Source Value" "This field houses the verbatim value from the source data representing the unit of the Observation that occurred."
* qualifier_source_value 0..1 string "Qualifier Source Value" "This field houses the verbatim value from the source data representing the qualifier of the Observation that occurred."
* value_source_value 0..1 string "Value Source Value" "This field houses the verbatim result value of the Observation from the source data.  Do not get confused with the Observation_source_value which captures source value of the observation mapped to observation_concept_id. This field is the observation result value from the source."
//* observation_event_id 0..1 Reference(ObservationEvent) "Observation Event" 
* observation_event_id 0..1 string "Observation Event" "If the Observation record is related to another record in the database, this field is the primary key of the linked record."
* obs_event_field_concept_id 0..1 code "Observation Event Field Concept" "If the Observation record is related to another record in the database, this field is the CONCEPT_ID that identifies which table the primary key of the linked record came from."
