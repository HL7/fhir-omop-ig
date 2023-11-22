Logical: VisitDetail
Parent: Base
Id: VisitDetail
Characteristics: #can-be-target
Title: "Visit Detail OMOP Table"
Description: "The VISIT_DETAIL table is an optional table used to represents details of each record in the parent VISIT_OCCURRENCE table. A good example of this would be the movement between units in a hospital during an inpatient stay or claim lines associated with a one insurance claim. For every record in the VISIT_OCCURRENCE table there may be 0 or more records in the VISIT_DETAIL table with a 1:n relationship where n may be 0. The VISIT_DETAIL table is structurally very similar to VISIT_OCCURRENCE table and belongs to the visit domain."

* visit_detail_id	1..1	integer "Visit Detail Identifier" "Use this to identify unique interactions between a person and the health care system. This identifier links across the other CDM event tables to associate events with a visit detail."
* person_id	1..1	Reference(Person) "Person" ""
* visit_detail_concept_id 1..1	code	"Visit Detail" "This field contains a concept id representing the kind of visit detail, like inpatient or outpatient. All concepts in this field should be standard and belong to the Visit domain."
* visit_detail_start_date	1..1	date	"Visit Detail Start Date" "This is the date of the start of the encounter. This may or may not be equal to the date of the Visit the Visit Detail is associated with."
* visit_detail_start_datetime	0..1	dateTime "Visit Detail Start Datetime" ""
* visit_detail_end_date	1..1	date	"Visit Detail End Date" "This the end date of the patient-provider interaction.  If a Person is still an inpatient in the hospital at the time of the data extract and does not have a visit_end_date, then set the visit_end_date to the date of the data pull."
* visit_detail_end_datetime	0..1	dateTime	"Visit Detail End Datetime" "If a Person is still an inpatient in the hospital at the time of the data extract and does not have a visit_end_datetime, then set the visit_end_datetime to the datetime of the data pull."
* visit_detail_type_concept_id	1..1	code	"Visit Detail Type" "Use this field to understand the provenance of the visit detail record, or where the record comes from."
* provider_id	0..1	Reference(Provider)	"Provider" "There will only be one provider per  **visit** record and the ETL document should clearly state how they were chosen (attending, admitting, etc.). This is a typical reason for leveraging the VISIT_DETAIL table as even though each VISIT_DETAIL record can only have one provider, there is no limit to the number of VISIT_DETAIL records that can be associated to a VISIT_OCCURRENCE record."
* care_site_id	0..1	Reference(CareSite) "Care Site" "This field provides information about the Care Site where the Visit Detail took place."
* visit_detail_source_value	0..1	string	"Visit Detail Source Value" "This field houses the verbatim value from the source data representing the kind of visit detail that took place (inpatient, outpatient, emergency, etc.)"
* visit_detail_source_concept_id	0..1	code	"Visit Detail Source Concept" ""
* admitted_from_concept_id	0..1	code	"Admitted From" "Use this field to determine where the patient was admitted from. This concept is part of the visit domain and can indicate if a patient was admitted to the hospital from a long-term care facility, for example."
* admitted_from_source_value	0..1	string	"Admitted From Source Value" ""
* discharged_to_source_value	0..1	string	"Discharged To Source Value" ""
* discharged_to_concept_id	0..1	code	"Discharged To" "Use this field to determine where the patient was discharged to after a visit. This concept is part of the visit domain and can indicate if a patient was transferred to another hospital or sent to a long-term care facility, for example.  It is assumed that a person is discharged to home therefore there is not a standard concept id for \"home\".  Use concept id = 0 when a person is discharged to home."
* preceding_visit_detail_id	0..1	Reference(VisitDetail) "Preceding Visit" "Use this field to find the visit detail that occurred for the person prior to the given visit detail record. There could be a few days or a few years in between."
* parent_visit_detail_id	0..1	Reference(VisitDetail) "Parent Visit" "Use this field to find the visit detail that subsumes the given visit detail record. This is used in the case that a visit detail record needs to be nested beyond the VISIT_OCCURRENCE/VISIT_DETAIL relationship."
* visit_occurrence_id	1..1	Reference(VisitOccurrence) "Visit Occurrence" "Use this field to link the VISIT_DETAIL record to its VISIT_OCCURRENCE."
