Logical: DrugEra
Parent: Base
Id: DrugEra
Characteristics: #can-be-target
Title: "Drug Era OMOP Table"
Description: "A Drug Era is defined as a span of time when the Person is assumed to be exposed to a particular active ingredient. A Drug Era is not the same as a Drug Exposure: Exposures are individual records corresponding to the source when Drug was delivered to the Person, while successive periods of Drug Exposures are combined under certain rules to produce continuous Drug Eras."

* drug_era_id 1..1 code "Drug Era Identifier" ""
* person_id 1..1 Reference(Person) "Person" ""
* drug_concept_id 1..1 code "Drug" "The Concept Id representing the specific drug ingredient."
* drug_era_start_date 1..1 date "Drug Era Start Date" ""
* drug_era_end_date 1..1 date "Drug Era End Date" ""
* drug_exposure_count 0..1 integer "Drug Exposure Count" ""
* gap_days 0..1 integer "Gap Days" ""
