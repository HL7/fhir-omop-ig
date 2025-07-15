# IPA Profile-specific issues
## General Considerations
## Handling Encounters and Contextual Data
In FHIR, procedures, medications, and other clinical actions are often linked to an encounter for context. OMOP has Visit Occurrence and Visit Detail tables that provide temporal and venue-specific clinical context.  However, inconsistencies in how encounters are represented across FHIR resources and systems present challenges to consistent data transformation. Mapping encounter data to OMOP’s visit_occurrence table and populating other domains with a visit_occurence_concept_id foreign key should be done wherever possible.  However, an evaluation of how consistent the source data are in representing encounters will determine whether there may be some flexibility required in a FHIR to OMOP transformation.

## Data Absent Reason Elements 
For observations like labs or vital signs, capturing the reason for missing data can be clinically useful when the reason directly impacts care. Knowing that a lab was not completed because of a processing error clarifies whether the absence represents a true gap in care or simply a data issue. Reasons that are purely operational, such as “not applicable,” generally do not add research value and may be omitted if appropriate to the analysis.
In medication data, reasons for discontinuation or non-use—such as adverse reactions, patient nonadherence, or contraindications—can inform research on medication safety, adherence, and treatment effectiveness. These reasons can be selectively included to support such studies. Routine logistical issues and administrative gaps are less likely to contribute meaningfully to OMOP analyses and can be excluded.

For immunizations, the value of documenting vaccines that were not administered requires special consideration. Refusals or contraindications may be relevant for research on vaccine hesitancy or public health trends, while routine administrative noncompletions typically have little analytic value and can be left out. OMOP’s Measurement Value Domain may be used to store absent data reasons for labs and imaging, as these often have clinical implications. 

Data absent reasons such as “insufficient sample,” “not detected,” or “patient declined” may be included for labs and imaging to enrich analytic context. For immunizations, documentation can focus on significant refusals or contraindications, while administrative reasons are generally excluded. 

# FHIR Condition Considerations
## Condition Start Date vs. Recorded Date
When implementing FHIR-to-OMOP transformations, two temporal concepts require careful consideration due to their distinct semantic meanings and downstream analytical impact. Understanding these differences is crucial for health data professionals working on interoperability projects and clinical data warehousing initiatives.

### Understanding Condition Start Date
The condition start date represents the clinically determined onset of the condition and forms the foundation of temporal analysis in clinical research. In FHIR implementations, this information is primarily sourced from Condition.onsetDateTime or Condition.onsetPeriod fields. When these explicit onset fields are unavailable, ETL developers often need to implement fallback logic that examines Condition.assertedDate or extract temporal information from clinical notes through natural language processing or manual extraction processes.
This temporal marker maps directly to CONDITION_OCCURRENCE.condition_start_date in the OMOP Common Data Model. The clinical significance of this field cannot be overstated, as it serves as the cornerstone for temporal analyses, disease progression modeling, and epidemiological cohort studies where clinical timeline accuracy is paramount for valid research outcomes.

### The Role of Recorded Date
In contrast to the clinical onset, the recorded date captures when the condition was actually documented in the source system. This administrative timestamp reflects the healthcare workflow and documentation practices rather than the clinical reality of disease onset. In FHIR resources, this information is typically found in Condition.recordedDate, though the availability of this field varies significantly across different EHR implementations and vendor configurations.
The challenge for OMOP implementers lies in the fact that the Common Data Model lacks a native equivalent field for recorded dates. This architectural decision reflects OMOP's focus on clinical events rather than administrative metadata. However, several implementation strategies can address this gap, including the development of custom extensions within the CONDITION_OCCURRENCE table, creation of dedicated metadata tables for comprehensive provenance tracking, utilization of the NOTE table with structured content, or establishment of separate ETL audit tables that maintain this temporal information alongside the clinical data.

### Implementation Challenges and Considerations
The fundamental challenge in FHIR-to-OMOP mapping stems from a data model alignment issue where OMOP's clinical-event focus prioritizes onset information over administrative timestamps. This philosophical difference requires architects and implementers to make deliberate decisions about how to preserve recorded date information when audit requirements or analytical needs demand such provenance tracking.
Missing data scenarios present particular complexity for ETL developers. When onsetDateTime is unavailable in the source FHIR data, the temptation exists to use recordedDate as a proxy for clinical onset. While this approach may seem pragmatic, it introduces analytical bias that can significantly impact downstream research and clinical decision-making. Such substitutions must be thoroughly documented in ETL metadata and clearly communicated to end users.
Temporal discrepancies between onset and documentation dates often reveal interesting patterns in healthcare delivery and documentation practices. Significant lags between when a condition clinically manifests and when it gets recorded in the EHR can affect different use cases in distinct ways, with clinical analyses requiring accurate onset timing while operational assessments may depend more heavily on documentation patterns.

### Condition Date Implementation Strategies
The implementation of date prioritization logic typically follows a preference hierarchy that favors onset dates when available while providing documented fallback mechanisms to recorded dates when clinical onset information is absent. This logic should be configurable to accommodate different analytical requirements and source system characteristics.
A technique that may be overlooked involves leveraging the condition_type_concept_id field to indicate the source and quality of temporal information. By using concept codes that distinguish between "EHR onset date" and "EHR recorded date," downstream analysts can make informed decisions about which temporal markers are most appropriate for their specific research questions.

### Condition Date Practical Applications and Use Cases
The distinction between these temporal concepts becomes most apparent when considering their respective applications in healthcare analytics and operations. Condition start dates serve as the foundation for clinical research initiatives, outcomes analysis projects, and temporal cohort definitions where understanding the natural history of disease is essential. These applications require temporal precision that reflects biological and clinical reality rather than administrative convenience.
Conversely, recorded dates prove invaluable for data governance initiatives, ETL validation processes, documentation pattern analysis, and regulatory compliance activities. These applications focus on understanding and improving healthcare delivery processes, audit trails, and operational efficiency rather than clinical outcomes.

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

# FHIR Observation Considerations
### Observation Category Definitions and Clinical Context
FHIR Observation Categories serve as organizational tools within EHR systems, providing essential context for clinical decision support and data retrieval operations. The categories in the FHIR observation-category value set encompass a spectrum of clinical observations, including Social History, Vital Signs, Laboratory, Imaging, Procedure, Survey, Exam, Therapy, and Activity. Considering the OMOP CDM semantically-based framework, FHIR Observations with observation-categories such as Laboratory and Vital Signs may actually map to OMOP's Measurement or other tables. As such, FHIR Observations may or may not align naturally with OMOP's existing Observation domain architecture, where the data are normalized across the OMOP CDM through Standardized concepts established in each domain. 

## A Domain-Based Mapping Strategy
OMOP's domain structure inherently categorizes data elements into logical groupings, with the Measurement domain handling quantitative clinical data and the Observation domain managing qualitative findings and contextual information. This existing structure effectively represents many FHIR categories without requiring explicit category mapping. At a high-level, mapping rules can be aligned with OMOP domains as reprsented in the table below However, the nuanced distinction between clinical observations and patient-reported data, or between routine clinical measurements and lifestyle assessments, may not be adequately preserved through domain assignment alone. 

| FHIR Observation Type | Target OMOP Table | Rationale | Examples |
|---|---|---|---|
| Laboratory and Vital Signs | Measurement | Accommodates numeric values and supports standardization processes; leverages structured fields for quantitative clinical data requiring units and reference ranges | Lab test results, blood pressure readings, temperature measurements |
| Qualitative Observations | Observation | Appropriate for non-numeric components including survey responses, clinical notes, and general observations lacking strict measurement units | Patient-reported outcomes, clinical assessments, survey responses |
| Condition-Related Observations | Condition | Suitable when observations align closely with diagnoses or clinical conditions representing documented medical states | Diagnostic findings, clinical impressions, documented conditions |

Keep in mind that the domain-based guidelines outlined above serve as one of many aprroaches to consider, with recognition that specific edge cases will require detailed concept-based mapping decisions during implementation.

## Value Type Mapping Specifications
FHIR Observation resources support multiple value types (Quantity, CodeableConcept, string, Boolean), requiring careful consideration for OMOP field assignments. The following mapping strategy addresses this complexity through type-specific field assignments.

| FHIR Value Type | Target OMOP Field | Primary Table | Description | Examples |
|---|---|---|---|---|
| Quantity (Numeric) | `value_as_number` | Measurement | Preserves quantitative nature of clinical measurements while maintaining data integrity | Laboratory test results, vital sign measurements, dosage amounts |
| CodeableConcept | `value_as_concept_id` | Measurement/Observation | Ensures semantic consistency and enables standardized clinical queries using standardized terminologies | SNOMED CT codes, LOINC codes, ICD-10 codes |
| String/Text | `value_as_string` | Measurement/Observation | Maintains descriptive clinical information that cannot be effectively represented through numeric or coded values | Patient-reported descriptions, free-text observations, clinical notes |
| Boolean | `value_as_concept_id` | Measurement/Observation | Typically mapped to standardized Yes/No concepts in OMOP vocabulary | Presence/absence indicators, binary clinical assessments |

Implementation teams should note that FHIR's expressiveness often exceeds OMOP's structural capacity, requiring careful evaluation of value types that may need adaptation or exclusion if they cannot be effectively represented in the target OMOP model.

## Unit Handling and Standardization
FHIR Observation units are embedded within the Quantity type structure, typically utilizing standardized systems such as UCUM (Unified Code for Units of Measure). The mapping process must preserve unit information through OMOP's `unit_concept_id` field in the Measurement table.

While UCUM provides a robust grammar-based approach for constructing unit expressions and supports machine-to-machine communication through consistent representation (using "mg" rather than variations like "milligram" or "milligramme"), implementation teams must exercise caution when working with UCUM units in clinical data warehouses. UCUM's flexibility in allowing the creation of new units through its grammar system, while beneficial for specialized domains, can introduce analytical challenges if not properly managed. Care should be taken to normalize units of measure assigned to each result type within the datastore to support analytic consistency. For example, while UCUM may allow both "mg/dL" and "mg/100mL" as valid representations of the same conceptual unit, analytical processes require standardized unit assignment to ensure accurate cross-patient comparisons and longitudinal analysis.

**Unit Consistency** becomes essential for maintaining data quality and ensuring interoperability across mapped datasets. Implementation teams must address scenarios where units vary between source systems or are not specified in the original FHIR data, establishing normalization rules that leverage UCUM's machine-readable format while ensuring analytical uniformity.

