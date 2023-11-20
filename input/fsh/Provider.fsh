Logical: Provider
Parent: Base
Id: Provider
Characteristics: #can-be-target
Title: "Provider OMOP Table"
Description: "The PROVIDER table contains a list of uniquely identified healthcare providers. These are individuals providing hands-on healthcare to patients, such as physicians, nurses, midwives, physical therapists etc."

* provider_id	1..1	integer	"Provider Identifier" "It is assumed that every provider with a different unique identifier is in fact a different person and should be treated independently."
* provider_name 0..1	string	"Provider Name" ""
* npi	0..1	string "National Provider Identifier" "This is the National Provider Number issued to health care providers in the US by the Centers for Medicare and Medicaid Services (CMS)."
* dea	0..1	string	"Drug Enforcement Administration Identifer" "This is the identifier issued by the DEA, a US federal agency, that allows a provider to write prescriptions for controlled substances."
* specialty_concept_id	0..1 code	"Specialty" "This field either represents the most common specialty that occurs in the data or the most specific concept that represents all specialties listed, should the provider have more than one. This includes physician specialties such as internal medicine, emergency medicine, etc. and allied health professionals such as nurses, midwives, and pharmacists."
* care_site_id 0..1	Reference(CareSite) "Care Site" "This is the location that the provider primarily practices in."
* year_of_birth 0..1	integer	"Year of Birth" ""
* gender_concept_id	0..1	code	"Gender" "This field represents the recorded gender of the provider in the source data."
* provider_source_value	0..1	string	"Provider Identifier Source Value" "Use this field to link back to providers in the source data. This is typically used for error checking of ETL logic."
* specialty_source_value	0..1	string	"Specialty Source Value" "This is the kind of provider or specialty as it appears in the source data. This includes physician specialties such as internal medicine, emergency medicine, etc. and allied health professionals such as nurses, midwives, and pharmacists."
* specialty_source_concept_id	0..1	code	"Specialty Source Concept" "This is often zero as many sites use proprietary codes to store physician speciality."
* gender_source_value	0..1	string	"Gender Source Value" "This is provider's gender as it appears in the source data."
* gender_source_concept_id	0..1	code	"Gender Source Concept" "This is often zero as many sites use proprietary codes to store provider gender."
