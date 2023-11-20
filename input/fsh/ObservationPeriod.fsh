Logical: ObservationPeriod
Parent: Base
Id: ObservationPeriod
Characteristics: #can-be-target
Title: "Observation Period OMOP Table"
Description: "This table contains records which define spans of time during which two conditions are expected to hold: (i) Clinical Events that happened to the Person are recorded in the Event tables, and (ii) absense of records indicate such Events did not occur during this span of time."

* observation_period_id	1..1	integer	"Observation Period Identifier" "A Person can have multiple discrete Observation Periods which are identified by the Observation_Period_Id."
* person_id	1..1	Reference(Person) "Person" "The Person ID of the PERSON record for which the Observation Period is recorded."
* observation_period_start_date	1..1	date	"Start Date" "Use this date to determine the start date of the Observation Period."
* observation_period_end_date	1..1	date	"End Date" "Use this date to determine the end date of the period for which we can assume that all events for a Person are recorded."
* period_type_concept_id	1..1	code	"Period Type" "This field can be used to determine the provenance of the Observation Period as in whether the period was determined from an insurance enrollment file, EHR healthcare encounters, or other sources."
