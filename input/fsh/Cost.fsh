Logical: Cost
Parent: Base
Id: Cost
Characteristics: #can-be-target
Title: "Cost OMOP Table"
Description: "The COST table captures records containing the cost of any medical event recorded in one of the OMOP clinical event tables such as DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, VISIT_OCCURRENCE, VISIT_DETAIL, DEVICE_OCCURRENCE, OBSERVATION or MEASUREMENT.

Each record in the cost table account for the amount of money transacted for the clinical event. So, the COST table may be used to represent both receivables (charges) and payments (paid), each transaction type represented by its COST_CONCEPT_ID. The COST_TYPE_CONCEPT_ID field will use concepts in the Standardized Vocabularies to designate the source (provenance) of the cost data. A reference to the health plan information in the PAYER_PLAN_PERIOD table is stored in the record for information used for the adjudication system to determine the persons benefit for the clinical event."

* cost_id 1..1 code "Cost Identifier" ""
//* cost_event_id 1..1 Reference(CostEvent)
* cost_event_id 1..1 integer "Cost Event Identifier" ""
//* cost_domain_id 1..1 Reference(CostDomain)
* cost_domain_id 1..1 string "Cost Domain Identifier" ""
* cost_type_concept_id 1..1 code "Cost Type" ""
* currency_concept_id 0..1 code "Currency" ""
* total_charge 0..1 integer "Total Charge" ""
* total_cost 0..1 integer "Total Cost" ""
* total_paid 0..1 integer "Total Paid" ""
* paid_by_payer 0..1 integer "Paid by Payer" ""
* paid_by_patient 0..1 integer "Paid by Patient" ""
* paid_patient_copay 0..1 integer "Paid Patient Copay" ""
* paid_patient_coinsurance 0..1 integer "Paid Patient Coinsurance" ""
* paid_patient_deductible 0..1 integer "Paid Patient Deductible" ""
* paid_by_primary 0..1 integer "Paid by Primary" ""
* paid_ingredient_cost 0..1 integer "Paid Ingredent Cost" ""
* paid_dispensing_fee 0..1 integer "Paid Dispensing Fee" ""
* payer_plan_period_id 0..1 Reference(PayerPlanPeriod) "Payer Plan Period" ""
* amount_allowed 0..1 integer "Amount Allowed" ""
* revenue_code_concept_id 0..1 code "Revenue Code" ""
* revenue_code_source_value 0..1 string "Revenue Code Source Value" "Revenue codes are a method to charge for a class of procedures and conditions in the U.S. hospital system."
* drg_concept_id 0..1 integer "Diagnosis Related Groups" ""
* drg_source_value 0..1 string "Diagnosis Related Groups Source Value" "Diagnosis Related Groups are US codes used to classify hospital cases into one of approximately 500 groups."
