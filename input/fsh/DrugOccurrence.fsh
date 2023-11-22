Logical: DrugOccurrence
Parent: Base
Id: DrugOccurrence
Characteristics: #can-be-target
Title: "Drug Occurrence OMOP Table"
Description: "This table captures records about the exposure to a Drug ingested or otherwise introduced into the body. A Drug is a biochemical substance formulated in such a way that when administered to a Person it will exert a certain biochemical effect on the metabolism. Drugs include prescription and over-the-counter medicines, vaccines, and large-molecule biologic therapies. Radiological devices ingested or applied locally do not count as Drugs."

* drug_exposure_id 1..1 integer "Drug Exposure Identifier" "The unique key given to records of drug dispensings or administrations for a person. Refer to the ETL for how duplicate drugs during the same visit were handled."
* person_id 1..1 Reference(Person) "Person" "The PERSON_ID of the PERSON for whom the drug dispensing or administration is recorded. This may be a system generated code."
* drug_concept_id 1..1 code "Drug" "The DRUG_CONCEPT_ID field is recommended for primary use in analyses, and must be used for network studies. This is the standard concept mapped from the source concept id which represents a drug product or molecule otherwise introduced to the body. The drug concepts can have a varying degree of information about drug strength and dose. This information is relevant in the context of quantity and administration information in the subsequent fields plus strength information from the DRUG_STRENGTH table, provided as part of the standard vocabulary download."
* drug_exposure_start_date 1..1 date "Drug Exposure Start Date" "Use this date to determine the start date of the drug record."
* drug_exposure_start_datetime 0..1 dateTime "Drug Exposure Start Datetime" ""
* drug_exposure_end_date 1..1 date "Drug Exposure End Date" "The DRUG_EXPOSURE_END_DATE denotes the day the drug exposure ended for the patient."
* drug_exposure_end_datetime 0..1 dateTime "Drug Exposure End Datetime" ""
* verbatim_end_date 0..1 date "Verbatim End Date" "This is the end date of the drug exposure as it appears in the source data, if it is given"
* drug_type_concept_id 1..1 code "Drug Type" "You can use the TYPE_CONCEPT_ID to delineate between prescriptions written vs. prescriptions dispensed vs. medication history vs. patient-reported exposure, etc."
* stop_reason 0..1 string "Stop Reason" "The reason a person stopped a medication as it is represented in the source. Reasons include regimen completed, changed, removed, etc. This field will be retired in v6.0."
* refills 0..1 integer "Refills" "This is only filled in when the record is coming from a prescription written this field is meant to represent intended refills at time of the prescription."
* quantity 0..1 decimal "Quantity" ""
* days_supply 0..1 integer "Days Supply" ""
* sig 0..1 string "Sig" "This is the verbatim instruction for the drug as written by the provider."
* route_concept_id 0..1 code "Route" ""
* lot_number 0..1 string "Lot Number" ""
* provider_id 0..1 Reference(Provider) "Provider" "The Provider associated with drug record, e.g. the provider who wrote the prescription or the provider who administered the drug."
* visit_occurrence_id 0..1 Reference(VisitOccurrence) "Visit Occurrence" "The Visit during which the drug was prescribed, administered or dispensed."
* visit_detail_id 0..1 Reference(VisitDetail) "Visit Detail" "The VISIT_DETAIL record during which the drug exposure occurred. For example, if the person was in the ICU at the time of the drug administration the VISIT_OCCURRENCE record would reflect the overall hospital stay and the VISIT_DETAIL record would reflect the ICU stay during the hospital visit."
* drug_source_value 0..1 string "Drug Source Value" "This field houses the verbatim value from the source data representing the drug exposure that occurred. For example, this could be an NDC or Gemscript code."
* drug_source_concept_id 0..1 code "Drug Source Concept" "This is the concept representing the drug source value and may not necessarily be standard. This field is discouraged from use in analysis because it is not required to contain Standard Concepts that are used across the OHDSI community, and should only be used when Standard Concepts do not adequately represent the source detail for the Drug necessary for a given analytic use case. Consider using DRUG_CONCEPT_ID instead to enable standardized analytics that can be consistent across the network."
* route_source_value 0..1 string "Route Source Value" "This field houses the verbatim value from the source data representing the drug route."
* dose_unit_source_value 0..1 string "Dose Unit Source Value" "This field houses the verbatim value from the source data representing the dose unit of the drug given."