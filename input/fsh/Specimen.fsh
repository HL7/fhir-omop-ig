Logical: Specimen
Parent: Base
Id: Specimen
Characteristics: #can-be-target
Title: "Specimen OMOP Table"
Description: "The specimen domain contains the records identifying biological samples from a person."

* specimen_id 1..1 code "Specimen Identifier" ""
* person_id 1..1 Reference(Person) "Person" "The person from whom the specimen is collected."
* specimen_concept_id 1..1  code "Specimen" ""
* specimen_type_concept_id 1..1 code "Specimen Type" ""
* specimen_date 1..1 date "Specimen Date" "The date the specimen was collected."
* specimen_datetime 0..1 dateTime "Specimen Datetime" ""
* quantity 0..1 integer "Quantity" "The amount of specimen collected from the person."
* unit_concept_id 0..1 code "Unit" "The unit for the quantity of the specimen."
* anatomic_site_concept_id 0..1 code "Anatomic Site" "This is the site on the body where the specimen is from."
* disease_status_concept_id  0..1 code "Disease Status" ""
* specimen_source_id  0..1 string "Specimen Source" "This is the identifier for the specimen from the source system."
* specimen_source_value  0..1 string "Specimen Source Value" ""
* unit_source_value  0..1 string "Unit Source Value" ""
* anatomic_site_source_value  0..1 string "Anatomic Site Source Value" ""
* disease_status_source_value  0..1 string "Disease Site Source Value" ""
