Logical: NoteNLP
Parent: Base
Id: NoteNLP
Characteristics: #can-be-target
Title: "Note NLP OMOP Table"
Description: "The NOTE_NLP table encodes all output of NLP on clinical notes. Each row represents a single extracted term from a note."

* note_nlp_id 1..1 code "Note NLP Identifier" ""
* note_id 1..1 Reference(Note) "Note" "This is the NOTE_ID for the NOTE record the NLP record is associated to."
* section_concept_id 0..1 code "Section" ""
* snippet 0..1 string "Snippet" "A small window of text surrounding the term"
* offset 0..1 string "Offset" "Character offset of the extracted term in the input note"
* lexical_variant 1..1 string "Lexical Variant" "Raw text extracted from the NLP tool."
* note_nlp_concept_id 0..1 code "Note NLP" ""
* note_nlp_source_concept_id 0..1 code  "Note NLP Source" ""
* nlp_system 0..1 string "NLP System" ""
* nlp_date 1..1 date "NLP Date" "The date of the note processing."
* nlp_datetime 0..1 dateTime "NLP Datetime" "The date and time of the note processing."
* term_exists 0..1 string "Term Exists" ""
* term_temporal 0..1 string "Term Temporal" ""
* term_modifiers 0..1 string "Term Modifiers" ""
