Logical: Episode
Parent: Base
Id: Episode
Characteristics: #can-be-target
Title: "Episode OMOP Table"
Description: "The EPISODE table aggregates lower-level clinical events (VISIT_OCCURRENCE, DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, DEVICE_EXPOSURE) into a higher-level abstraction representing clinically and analytically relevant disease phases,outcomes and treatments. The EPISODE_EVENT table connects qualifying clinical events (VISIT_OCCURRENCE, DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, DEVICE_EXPOSURE) to the appropriate EPISODE entry. For example cancers including their development over time, their treatment, and final resolution."

* episode_id 1..1 code "Episode Identifier" ""
* person_id 1..1 Reference(Person) "Person" "The PERSON_ID of the PERSON for whom the episode is recorded."
* episode_concept_id 1..1 code "Episode" "The EPISODE_CONCEPT_ID represents the kind abstraction related to the disease phase, outcome or treatment."
* episode_start_date 1..1 date "Episode Start Date" "The date when the Episode beings."
* episode_start_datetime 0..1 dateTime "Episode Start Datetime" "The date and time when the Episode beings."
* episode_end_date 0..1 date "Episode End Date" "The date when the instance of the Episode is considered to have ended."
* episode_end_datetime 0..1 dateTime "Epsisode End Datetime" "The date when the instance of the Episode is considered to have ended."
* episode_parent_id 0..1 Reference(Episode) "Episode Parent" "Use this field to find the Episode that subsumes the given Episode record. This is used in the case that an Episode are nested into each other."
* episode_number 0..1 integer "Episode Number" "For sequences of episodes, this is used to indicate the order the episodes occurred. For example, lines of treatment could be indicated here."
* episode_object_concept_id 1..1 code "Episode Object" "A Standard Concept representing the disease phase, outcome, or other abstraction of which the episode consists.  For example, if the EPISODE_CONCEPT_ID is [treatment regimen](https://athena.ohdsi.org/search-terms/terms/32531) then the EPISODE_OBJECT_CONCEPT_ID should contain the chemotherapy regimen concept, like [Afatinib monotherapy](https://athena.ohdsi.org/search-terms/terms/35804392)."
* episode_type_concept_id 1..1 code "Episode Type" "This field can be used to determine the provenance of the Episode record, as in whether the episode was from an EHR system, insurance claim, registry, or other sources."
* episode_source_value 0..1 string "Episode Source Value" "The source code for the Episdoe as it appears in the source data. This code is mapped to a Standard Condition Concept in the Standardized Vocabularies and the original code is stored here for reference."
* episode_source_concept_id 0..1 code "Episode Source" "A foreign key to a Episode Concept that refers to the code used in the source."
