Logical: ConditionEra
Parent: Base
Id: ConditionEra
Characteristics: #can-be-target
Title: "Condition Era OMOP Table"
Description: "A Condition Era is defined as a span of time when the Person is assumed to have a given condition. Similar to Drug Eras, Condition Eras are chronological periods of Condition Occurrence. Combining individual Condition Occurrences into a single Condition Era serves two purposes:

- It allows aggregation of chronic conditions that require frequent ongoing care, instead of treating each Condition Occurrence as an independent event.
- It allows aggregation of multiple, closely timed doctor visits for the same Condition to avoid double-counting the Condition Occurrences.
For example, consider a Person who visits her Primary Care Physician (PCP) and who is referred to a specialist. At a later time, the Person visits the specialist, who confirms the PCP's original diagnosis and provides the appropriate treatment to resolve the condition. These two independent doctor visits should be aggregated into one Condition Era."

* condition_era_id 1..1 code "Condition Era Identifier" ""
* person_id 1..1 Reference(Person) "Person" ""
* condition_concept_id 1..1 code "Condition" "The Concept Id representing the Condition."
* condition_era_start_date 1..1 date "Condition Era Start Date" "The start date for the Condition Era constructed from the individual instances of Condition Occurrences. It is the start date of the very firstchronologically recorded instance of the condition with at least 31 days since any prior record of the same Condition."
* condition_era_end_date 1..1 code "Condition Era End Date" "The end date for the Condition Era constructed from the individual instances of Condition Occurrences. It is the end date of the final continuously recorded instance of the Condition."
* condition_occurrence_count 0..1 integer "Condition Occurence Count" "The number of individual Condition Occurrences used to construct the
condition era."
