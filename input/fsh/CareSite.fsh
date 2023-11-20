Logical: CareSite
Parent: Base
Id: CareSite
Characteristics: #can-be-target
Title: "CareSite OMOP Table"
Description: "The CARE_SITE table contains a list of uniquely identified institutional (physical or organizational) units where healthcare delivery is practiced (offices, wards, hospitals, clinics, etc.)."

* care_site_id	1..1	integer	"Care Site Identifier" ""
* care_site_name	0..1	string	"Care Site Name" "The name of the care_site as it appears in the source data"
* place_of_service_concept_id	0..1	code	"Place of Service" "This is a high-level way of characterizing a Care Site. Typically, however, Care Sites can provide care in multiple settings (inpatient, outpatient, etc.) and this granularity should be reflected in the visit."
* location_id	0..1	Reference(Location) "Location" "The location_id from the LOCATION table representing the physical location of the care_site."
* care_site_source_value	0..1	string	"Care Site Identifier Source Value" "The identifier of the care_site as it appears in the source data. This could be an identifier separate from the name of the care_site."
* place_of_service_source_value	0..1	string	"Place of Service Source Value" ""