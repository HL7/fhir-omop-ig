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

**Standardization Processes** should include unit validation and conversion mechanisms to ensure consistent representation in the target OMOP model. This includes handling unit discrepancies, missing unit information, and ensuring alignment with OMOP's standardized vocabulary requirements while taking advantage of UCUM's ability to represent complex units like "mg/L" in a standardized format.

**Unit Consistency** becomes essential for maintaining data quality and ensuring interoperability across mapped datasets. Implementation teams must address scenarios where units vary between source systems or are not specified in the original FHIR data, establishing normalization rules that leverage UCUM's machine-readable format while ensuring analytical uniformity.

# FHIR MedicationRequest Resource Considerations
The FHIR MedicationRequest resource represents a prescription or order for medication, capturing the intent to prescribe rather than confirming actual medication administration or patient adherence. A fundamental challenge with MedicationRequest resources is appropriate reconciliation of administrative workflow data with clinical research requirements. When mapping MedicationRequest data to the OMOP Common Data Model's drug_exposure table, implementers should consider the inherent limitations of prescription data and apply appropriate transformation processes to prevent misinterpretation in downstream analyses. FHIR MedicationRequest resources represent prescriptions or orders that document clinical intent but do not guarantee patient ingestion, while OMOP's drug_exposure table is designed to capture confirmed patient interaction with therapeutic substances. As uch, Mapping FHIR MedicationRequest resources reflect prescriptive intent rather than confirmed drug exposure, requiring thoughtful handling to maintain data integrity while preserving research utility. OMOP conventions acknowledge this difference and allow utilization of prescriptions as drug exposure records. Appropriate utilization of the drug_type_concept to differenetiate prescribed medication records from administered medications (covered under FHIR MedicationStatemnt Resource section), medication histories, patient-reported exposures etc is required.

## Excluding MedicationRequest Intent Element
The FHIR MedicationRequest Intent field is deliberately excluded from OMOP mapping. This field captures medication order administrative workflow values such as "proposal," "plan," "order," and "instance-order," which serve care coordination and clinical decision-making but do not contribute meaningful clinical information for research purposes. This decision aligns with OMOP's focus on clinically significant events rather than process-oriented workflow data, maintaining a streamlined structure that prioritizes patient outcomes and treatment analysis over administrative context.

## Drug Type Concept ID Assignment
To address the fundamental discrepancy between medication intent/reporting and actual exposure while maintaining research utility, implementers should evaluate the source data context and consistently utilize the OMOP .[drug_type_concept_id](https://athena.ohdsi.org/search-terms/terms?domain=Type+Concept&standardConcept=Standard&page=1&pageSize=15&query=)  This approach not only provides data source transparency, but supports informed decisions about data inclusion based on specific use case requirements. As a required field in the OMOP CDM, each drug_exposure entry must receive an appropriate classification that explicitly indicates data source characteristics. Options include differentiating between prescriptions written, prescriptions dispensed, medication history, and patient-reported exposure. 

## AuthoredOn to Start Date
The AuthoredOn field in MedicationRequest indicates when the medication was prescribed or requested by the provider. This date represents the prescriptive event rather than the initiation of actual medication use. When mapping to OMOP's drug_exposure.start_date, implementers should exercise caution. The AuthoredOn date should only be mapped to drug_exposure.start_date when no other temporal information is available, such as administration dates or patient-reported start dates. This mapping carries the assumption that the prescription date approximates when medication exposure began, though this assumption may not hold in practice due to delays in filling prescriptions, patient adherence patterns, or other factors.

### Mapping Requester to Provider
The Requester field identifies the healthcare provider who issued the medication prescription. This field maps directly to the provider_id in OMOP's drug_exposure table, establishing a clear link between the prescribing provider and the medication record. It is important to note that this mapping specifically identifies the prescribing provider rather than the individual who may have administered the medication or confirmed patient adherence. This distinction is particularly relevant in healthcare settings where prescription, dispensing, and administration may involve different providers.

## Medication Dosage Information
The dosageInstruction field within MedicationRequest provides valuable information for populating OMOP's SIG (signatura) or dose-related fields. This information captures the prescribed dosing regimen and administration instructions, which can be crucial for understanding the intended therapeutic approach even when actual adherence cannot be confirmed.

## Implementation Documentation Requirements
Clear documentation should accompany any transformation that includes MedicationRequest mappings, specifically addressing:

- The temporal limitations of using AuthoredOn dates as exposure start dates
- The distinction between prescribing and administering providers
- The need for appropriate filtering based on drug_type_concept_id
- Recommendations for handling prescription data in various analytical contexts

# FHIR MedicationStatement Resource Considerations
The FHIR MedicationStatement resource represents documented or observed medication intake, providing evidence that is closer to actual drug exposure than prescription data or medication histories alone. When implementing MedicationStatement to OMOP drug_exposure mappings, consider MedicationStatement data as closer to confirmed exposure than MedicationRequest, but apply appropriate caution for self-reported information. The mapping should preserve temporal information through effectiveDate, maintain medication coding through mapping to Standard OMOP concepts, document status information for research context, and utilize appropriate drug_type_concept_id values to reflect the data's provenance. This approach balances the enhanced exposure evidence that MedicationStatement provides while maintaining appropriate skepticism about data quality inherent in patient-reported medication information and ensuring proper categorization for downstream analysis.

While MedicationStatement represents stronger evidence of exposure compared to MedicationRequest, implementers should recognize that this data may vary in reliability. Patient-reported data can involve recall bias, and retrospective statements may not capture exact intake dates. The implementation guide recommends treating MedicationStatement data with attention to these limitations while acknowledging its superiority over purely prescriptive data.

## Core Field Mappings
### EffectiveDate
The effectiveDate field in MedicationStatement represents the date or time period when the medication was reportedly taken or administered. This temporal information is crucial as it provides data closer to actual exposure than prescription dates alone. The effectiveDate should map to drug_exposure.start_date in OMOP, and when an end date is included in the effectiveDate period, it should map to drug_exposure.end_date. This field represents a date range that aligns with the observed or reported period of medication intake, providing researchers with temporal boundaries for exposure analysis.

### Medication (CodeableConcept)
The medication field captures the specific drug or medication name, typically coded using standard terminologies such as RxNorm or SNOMED. This field should map directly to drug_concept_id in OMOP when a recognized concept ID is available. In cases where a medication code is missing, free-text entries can be used as non-standard concepts. When MedicationStatement references a separate Medication resource, the mapping should incorporate data from that referenced resource to capture complete medication details accurately.

### Dosage Instructions
Dosage instructions within MedicationStatement provide detailed information on the amount, frequency, and route of administration. These elements should map to dose_unit_concept_id, dose_value, and route_concept_id in OMOP. Any specific administration instructions can be preserved in the SIG field within drug_exposure. This mapping is particularly valuable for research studies requiring analysis of drug exposure quantity and frequency patterns.

## Additional Implementation Considerations
### Status Variability Considerations
Given that MedicationStatement may represent retrospective statements or patient-reported intake, implementers should document that a medicationStatment status and effectiveDate may vary in reliability. Research teams should be encouraged to consider these limitations when designing studies, particularly when dealing with patient-reported data that may be subject to recall bias or incomplete documentation.

## Drug Type Concept ID Utilization
The drug_type_concept_id field in OMOP serves a critical role in differentiating the provenance and nature of drug exposure records. When mapping FHIR MedicationStatement resources to the drug_exposure table, implementers must carefully select the appropriate drug_type_concept_id to distinguish between prescribed medications, administered medications, medication histories, and patient-reported exposures. This classification enables downstream users to appropriately filter and interpret data based on their analytical needs. When mapping MedicationStatement data, implementers should choose the drug_type_concept_id that best represents the provenance of the record. The [accepted concepts](https://athena.ohdsi.org/search-terms/terms?domain=Type+Concept&standardConcept=Standard&page=1&pageSize=15&query=) provide standardized options for delineating between prescriptions written, prescriptions dispensed, medication history, and patient-reported exposure. For MedicationStatement resources, the type concept should typically reflect patient-reported exposure or medication history, depending on the source and context of the data.

The OMOP CDM focuses exclusively on events that occur to the patient, meaning actions that suggest the drug was actually administered. If a patient missed or refused a dose of medication, no record should be created in the CDM. This principle guides the selection of drug_type_concept_id values, ensuring that only meaningful exposure events are captured in the database.

### Dosage Change Considerations
When medication dosages change during a treatment period, the mapping should end the first record and create a new record with the updated quantity. This approach ensures that each drug_exposure record represents a consistent dosage regimen, providing accurate temporal and quantitative information for analysis. The drug_type_concept_id should remain consistent across these records unless the nature of the data source changes.





