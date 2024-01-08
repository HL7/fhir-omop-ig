Logical: Note
Parent: Base
Id: Note
Characteristics: #can-be-target
Title: "Note OMOP Table"
Description: "The NOTE table captures unstructured information that was recorded by a provider about a patient in free text (in ASCII, or preferably in UTF8 format) notes on a given date. The type of note_text is CLOB or varchar(MAX) depending on RDBMS."

* note_id 1..1 code "Note Identifier" ""
* person_id 1..1 Reference(Person) "Person" ""
* note_date 1..1 date "Note Date" "The date the note was recorded."
* note_datetime 0..1 dateTime "Note Datetime" ""
* note_type_concept_id 1..1 code "Note Type" "The provenance of the note. Most likely this will be EHR."
* note_class_concept_id 1..1 code "Note Class" "A Standard Concept Id representing the HL7 LOINC
Document Type Vocabulary classification of the note."
* note_title 0..1 string "Title" "The title of the note."
* note_text 1..1 string "Text" "The content of the note."
* encoding_concept_id 1..1 code "Encoding" "This is the Concept representing the character encoding type."
* language_concept_id 1..1 code "Language" "The language of the note."
* provider_id 0..1 Reference(Provider) "Provider" "The Provider who wrote the note."
* visit_occurrence_id 0..1 Reference(VisitOccurrence) "Visit Occurence" "The Visit during which the note was written."
* visit_detail_id 0..1 Reference(VisitDetail) "Visit Detail" "The Visit Detail during which the note was written."
* note_source_value 0..1 string "Note Source Value" ""
//* note_event_id 0..1 Reference(NoteEvent) "Note Event"
* note_event_id 0..1 integer "Note Event" "If the Note record is related to another record in the database, this field is the primary key of the linked record."
* note_event_field_concept_id 0..1 code "Note Event Field" "If the Note record is related to another record in the database, this field is the CONCEPT_ID that identifies which table the primary key of the linked record came from."
