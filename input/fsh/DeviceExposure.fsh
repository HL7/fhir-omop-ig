Logical: DeviceExposure
Parent: Base
Id: DeviceExposure
Characteristics: #can-be-target
Title: "Device Exposure OMOP Table"
Description: "The Device domain captures information about a person's exposure to a foreign physical object or instrument which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).)."

* device_exposure_id 1..1 integer "Device Exposure Identifier" ""
* person_id 1..1 Reference(Person) "Person" "The PERSON_ID of the PERSON for whom the condition is recorded."
* device_concept_id 1..1 code "Device" "The DEVICE_CONCEPT_ID field is recommended for primary use in analyses, and must be used for network studies. This is the standard concept mapped from the source concept id which represents a foreign object or instrument the person was exposed to."
* device_exposure_start_date 1..1 date "Device Exposure Start Date" "Use this date to determine the start date of the device record."
* device_exposure_start_datetime 0..1 dateTime "Device Exposure Start Datetime" ""
* device_exposure_end_date 0..1 date "Device Exposure End Date" "The DEVICE_EXPOSURE_END_DATE denotes the day the device exposure ended for the patient, if given."
* device_exposure_end_datetime 0..1 dateTime "Device Exposure End Datetime" ""
* device_type_concept_id 1..1 integer "Device Type Concept Identifier" "You can use the TYPE_CONCEPT_ID to denote the provenance of the record, as in whether the record is from administrative claims or EHR."
* unique_device_id 0..1 string "Unique Device Identifier" "This is the Unique Device Identification (UDI-DI) number for devices regulated by the FDA, if given."
// * production_id 0..1 Reference(Production) "Production" "This is the Production Identifier (UDI-PI) portion of the Unique Device Identification."
* production_id 0..1 integer "Production Identifier" "This is the Production Identifier (UDI-PI) portion of the Unique Device Identification."
* quantity 0..1 integer "Quantity" ""
* provider_id 0..1 Reference(Provider) "Provider" "The Provider associated with device record, e.g. the provider who wrote the prescription or the provider who implanted the device."
* visit_occurrence_id 0..1 Reference(VisitOccurrence) "Visit Occurence Identifier" "The Visit during which the device was prescribed or given."
* visit_detail_id 0..1 Reference(VisitDetail) "Visit Detail Identifier" "The Visit Detail during which the device was prescribed or given."
* device_source_value 0..1 string "Device Source Value" "This field houses the verbatim value from the source data representing the device exposure that occurred. For example, this could be an NDC or Gemscript code."
* device_source_concept_id 0..1 code "Device Source" "This is the concept representing the device source value and may not necessarily be standard. This field is discouraged from use in analysis because it is not required to contain Standard Concepts that are used across the OHDSI community, and should only be used when Standard Concepts do not adequately represent the source detail for the Device necessary for a given analytic use case. Consider using DEVICE_CONCEPT_ID instead to enable standardized analytics that can be consistent across the network."
* unit_concept_id 0..1 code "Unit" "UNIT_SOURCE_VALUES should be mapped to a Standard Concept in the Unit domain that best represents the unit as given in the source data."
* unit_source_value 0..1 string "Unit Source Value" "This field houses the verbatim value from the source data representing the unit of the Device. For example, blood transfusions are considered devices and can be given in mL quantities."
* unit_source_concept_id 0..1 code "Unit Source" "This is the concept representing the UNIT_SOURCE_VALUE and may not necessarily be standard. This field is discouraged from use in analysis because it is not required to contain Standard Concepts that are used across the OHDSI community, and should only be used when Standard Concepts do not adequately represent the source detail for the Unit necessary for a given analytic use case. Consider using UNIT_CONCEPT_ID instead to enable standardized analytics that can be consistent across the network."

