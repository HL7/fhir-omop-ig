Logical: Person
Parent: Base
Id: Person
Characteristics: #can-be-target
Title: "Person OMOP Table"
Description: "This table serves as the central identity management for all Persons in the database. It contains records that uniquely identify each person or patient, and some demographic information."

* person_id 1..1 integer "Person Identifier" "It is assumed that every person with a different unique identifier is in fact a different person and should be treated independently."
* gender_concept_id 1..1 code "Gender" "This field is meant to capture the biological sex at birth of the Person. This field should not be used to study gender identity issues."
* year_of_birth 1..1 integer "Year of Birth" "Compute age using year_of_birth."
* month_of_birth 0..1 integer "Month of Birth"
* day_of_birth 0..1 integer "Day of Birth"
* birth_datetime 0..1 dateTime "Birth Datetime"
* race_concept_id 1..1 code "Race" "This field captures race or ethnic background of the person."
* ethnicity_concept_id 1..1 code "Ethnicity" "This field captures Ethnicity as defined by the Office of Management and Budget (OMB) of the US Government: it distinguishes only between “Hispanic” and “Not Hispanic”. Races and ethnic backgrounds are not stored here."
* location_id 0..1 Reference(Location) "Location" "The location refers to the physical address of the person. This field should capture the last known location of the person."
* provider_id 0..1 Reference(Provider) "Provider" "The Provider refers to the last known primary care provider (General Practitioner)."
* care_site_id 0..1 Reference(CareSite) "Care Site" "The Care Site refers to where the Provider typically provides the primary care."
* person_source_value 0..1 string "Person Identifier Source Value" "Use this field to link back to persons in the source data. This is typically used for error checking of ETL logic."
* gender_source_value 0..1 string "Gender Source Value" "This field is used to store the biological sex of the person from the source data. It is not intended for use in standard analytics but for reference only."
* gender_source_concept_id 0..1 code "Gender Source Concept" "If the source data codes biological sex in a non-standard vocabulary, store the concept_id here."
* race_source_value 0..1 string "Race Source Value" "This field is used to store the race of the person from the source data. It is not intended for use in standard analytics but for reference only."
* race_source_concept_id 0..1 code "Race Source Concept" "If the source data codes race in an OMOP supported vocabulary store the concept_id here."
* ethnicity_source_value 0..1 string "Ethnicity Source Value" "This field is used to store the ethnicity of the person from the source data. It is not intended for use in standard analytics but for reference only."
* ethnicity_source_concept_id 0..1 code "Ethnicity Source Concept" "If the source data codes ethnicity in an OMOP supported vocabulary, store the concept_id here."