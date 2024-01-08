Logical: EpisodeEvent
Parent: Base
Id: EpisodeEvent
Characteristics: #can-be-target
Title: "Episode Event OMOP Table"
Description: "The EPISODE_EVENT table connects qualifying clinical events (such as CONDITION_OCCURRENCE, DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, MEASUREMENT) to the appropriate EPISODE entry. For example, linking the precise location of the metastasis (cancer modifier in MEASUREMENT) to the disease episode."

* episode_id 1..1 Reference(Episode) "Episode" "Use this field to link the EPISODE_EVENT record to its EPISODE."
* event_id 1..1 code "Event Identifier" ""
* episode_event_field_concept_id 1..1 code "Episode Event Field" "This field is the CONCEPT_ID that identifies which table the primary key of the linked record came from." 
