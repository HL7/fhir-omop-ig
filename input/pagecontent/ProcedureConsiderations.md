# FHIR Procedures Considerations
## OMOP CDM Domain Assignment
Naturally, there is variability in source EHR data representation, where each EHR may represent the same clinical activity differently when exported to FHIR. For instance, some procedures in FHIR are represented in the Measurements or Observations domains in OMOP, such as lab orders and diagnostic imaging. It is a mapping challenge in deciding whether to map individual activities to the OMOP Procedure Occurrence, Measurement, or Observation domains. As alluded to previously, this is determined by domain assignment of the target OMOP concept_id(s) for any given procedure represented on FHIR.  An evaluation of each source procedure that differentiates true procedures (e.g., surgeries) from diagnostic activities is necessary to avoid FHIR procedure resource data misclassification. Activities should be mapped to the appropriate OMOP measurement or observation tables rather than procedure_occurrence through evaluation of the underlying concepts and which domain each is represented withtin the OHDSI Standardized Vocabularies.

## Temporal Context and Encounter Linkage
The performedDateTime or performedPeriod fields should map to procedure_date in OMOP, with the start date serving as the primary temporal reference. When a performedPeriod includes an end date, this may optionally map to procedure_end_date to capture procedure duration. The associated Encounter should map to visit_occurrence_id, establishing the contextual relationship between the procedure and the healthcare visit.

### Provider Attribution
When available, the Performer field should map to provider_id in the procedure_occurrence table. While not all data sources provide specific performer information, including this mapping when possible enhances analytical capabilities for provider attribution studies.

## Status and Type Considerations
### Procedure Status Handling
Only completed procedures should be mapped to the OMOP procedure_occurrence table. Transformation should filter out planned, cancelled, or incomplete procedures to ensure data integrity. This filtering criterion should be clearly documented in ETL specifications.

### Procedure Type Classification
The procedure type should be mapped to procedure_type_concept_id based on the healthcare setting context, such as inpatient surgery or outpatient diagnostic procedures. This classification helps differentiate care settings and supports research into distinctions between venues of care delivery.
