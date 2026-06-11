Logical: RecordSet
Parent: Base
Id: RecordSet
Characteristics: #can-be-target
Title: "Patient Record Setting"
Description: "Collection of records belonging to a single patient."

* record_id	1..1 integer "Patient Record Identifier" ""
* record_set_timestamp 1..1 dateTime "Record date" ""
* patient_id 1..1 integer "Patient Identifier" ""

* measurement 0..* Measurement "" ""
* medication 0..* Medication "" ""
