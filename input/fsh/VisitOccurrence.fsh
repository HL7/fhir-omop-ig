Logical: VisitOccurrence
Parent: Base
Id: VisitOccurrence
Characteristics: #can-be-target
Title: "Visit Occurrence OMOP Table"
Description: "This table contains Events where Persons engage with the healthcare system for a duration of time. They are often also called \"Encounters\". Visits are defined by a configuration of circumstances under which they occur, such as (i) whether the patient comes to a healthcare institution, the other way around, or the interaction is remote, (ii) whether and what kind of trained medical staff is delivering the service during the Visit, and (iii) whether the Visit is transient or for a longer period involving a stay in bed."

* visit_occurrence_id	1..1	integer	"Visit Occurrence Identifier" "Use this to identify unique interactions between a person and the health care system. This identifier links across the other CDM event tables to associate events with a visit."
* person_id	1..1	Reference(Person) "Person" ""
* visit_concept_id	1..1	code	"Visit" "This field contains a concept id representing the kind of visit, like inpatient or outpatient. All concepts in this field should be standard and belong to the Visit domain."
* visit_start_date	1..1	date	"Start Date" "For inpatient visits, the start date is typically the admission date. For outpatient visits the start date and end date will be the same."
* visit_start_datetime	0..1	dateTime	"Start Datetime" ""
* visit_end_date	1..1	date	"End Date" "For inpatient visits the end date is typically the discharge date.  If a Person is still an inpatient in the hospital at the time of the data extract and does not have a visit_end_date, then set the visit_end_date to the date of the data pull."
* visit_end_datetime	0..1	dateTime	"End Datetime" ""
* visit_type_concept_id	1..1	code	"Visit Type" "Use this field to understand the provenance of the visit record, or where the record comes from."
* provider_id	0..1	Reference(Provider) "Provider" "There will only be one provider per visit record and the ETL document should clearly state how they were chosen (attending, admitting, etc.). If there are multiple providers associated with a visit in the source, this can be reflected in the event tables (CONDITION_OCCURRENCE, PROCEDURE_OCCURRENCE, etc.) or in the VISIT_DETAIL table."
* care_site_id	0..1	Reference(CareSite) "Care Site" "This field provides information about the Care Site where the Visit took place."
* visit_source_value	0..1	string	"Visit Source Value" "This field houses the verbatim value from the source data representing the kind of visit that took place (inpatient, outpatient, emergency, etc.)"
* visit_source_concept_id	0..1	code	"Visit Source Concept" ""
* admitted_from_concept_id	0..1	code	"Admitted From Concept" "Use this field to determine where the patient was admitted from. This concept is part of the visit domain and can indicate if a patient was admitted to the hospital from a long-term care facility, for example."
* admitted_from_source_value	0..1	string	"Admitted From Source Value" ""
* discharged_to_concept_id	0..1	code	"Discharged To Concept" ""
* discharged_to_source_value	0..1	string	"Discharged To Source Value" ""
* preceding_visit_occurrence_id	0..1	Reference(VisitOccurrence) "Preceding Visit Occurrence"	"Use this field to find the visit that occurred for the person prior to the given visit. There could be a few days or a few years in between."
