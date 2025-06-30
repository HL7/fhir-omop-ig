# IPA Profile-specific issues
## Handling of Procedure and Observation Resources
Naturally, there is variability in source EHR data representation, where each EHR may represent the same clinical activity differently when exported to FHIR. For instance, some procedures in FHIR are represented in the Measurements or Observations domains in OMOP, such as lab orders and diagnostic imaging. It is a mapping challenge in deciding whether to map individual activities to the OMOP Procedure Occurrence, Measurement, or Observation domains. As alluded to previously, this is determined by domain assignment of the target OMOP concept_id(s) for any given procedure represented on FHIR.  An evaluation of each source procedure that differentiates true procedures (e.g., surgeries) from diagnostic activities is necessary to avoid FHIR procedure resource data misclassification.

## Handling Encounters and Contextual Data
