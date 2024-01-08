Logical: PayerPlanPeriod
Parent: Base
Id: PayerPlanPeriod
Characteristics: #can-be-target
Title: "Payer Plan Period OMOP Table"
Description: "The PAYER_PLAN_PERIOD table captures details of the period of time that a Person is continuously enrolled under a specific health Plan benefit structure from a given Payer. Each Person receiving healthcare is typically covered by a health benefit plan, which pays for (fully or partially), or directly provides, the care. These benefit plans are provided by payers, such as health insurances or state or government agencies. In each plan the details of the health benefits are defined for the Person or her family, and the health benefit Plan might change over time typically with increasing utilization (reaching certain cost thresholds such as deductibles), plan availability and purchasing choices of the Person. The unique combinations of Payer organizations, health benefit Plans and time periods in which they are valid for a Person are recorded in this table."

* payer_plan_period_id 1..1 code "Payer Plan Period Identifier" ""
* person_id 1..1 Reference(Person) "Person" "The Person covered by the Plan."
* payer_plan_period_start_date 1..1 date  "Payer Plan Period Start Date" "Start date of Plan coverage."
* payer_plan_period_end_date 1..1 date "Payer Plan Period End Date" "End date of Plan coverage."
* payer_concept_id 0..1 code "Payer" "This field represents the organization who reimburses the provider which administers care to the Person."
* payer_source_value 0..1 string "Payer Source Value" "This is the Payer as it appears in the source data."
* payer_source_concept_id 0..1 code "Payer Source" ""
* plan_concept_id 0..1 code "Plan" "This field represents the specific health benefit Plan the Person is enrolled in."
* plan_source_value 0..1 string "Plan Source Value" "This is the health benefit Plan of the Person as it appears in the source data."
* plan_source_concept_id 0..1 code "Plan Source" ""
* sponsor_concept_id 0..1 code "Sponsor" "This field represents the sponsor of the Plan who finances the Plan. This includes self-insured, small group health plan and large group health plan."
* sponsor_source_value 0..1 string "Sponsor Source Value" "The Plan sponsor as it appears in the source data."
* sponsor_source_concept_id 0..1 code "Sponsor Source" ""
* family_source_value 0..1 string "Family Source Value" "The common identifier for all people (often a family) that covered by the same policy."
* stop_reason_concept_id 0..1 code "Stop Reason" "This field represents the reason the Person left the Plan, if known."
* stop_reason_source_value 0..1 string "Stop Reason Source Value" "The Plan stop reason as it appears in the source data."
* stop_reason_source_concept_id 0..1 code "Stop Reason Source" ""
