# Condition & Problem List Resource Considerations
## Condition Start Date vs. Recorded Date
When implementing FHIR-to-OMOP transformations, two temporal concepts require careful consideration due to their distinct semantic meanings and downstream impact to analyses. Understanding these differences is crucial for implementers working on interoperability projects and clinical data warehousing initiatives.

### Understanding Condition Start Date
The condition start date represents the clinically determined onset of the condition and forms the foundation of temporal analysis in clinical research. In FHIR implementations, this information is primarily sourced from Condition.onsetDateTime or Condition.onsetPeriod fields. When these explicit onset fields are unavailable, ETL developers often need to implement fallback logic that examines Condition.assertedDate or extract temporal information from clinical notes through natural language processing or manual extraction processes.
This temporal marker maps directly to CONDITION_OCCURRENCE.condition_start_date in the OMOP Common Data Model. The clinical significance of this field cannot be overstated, as it serves as the cornerstone for temporal analyses, disease progression modeling, and epidemiological cohort studies where clinical timeline accuracy is paramount for valid research outcomes.

### The Role of Recorded Date
In contrast to the clinical onset, the recorded date captures when the condition was actually documented in the source system. This administrative timestamp reflects the healthcare workflow and documentation practices rather than the clinical reality of disease onset. In FHIR resources, this information is typically found in Condition.recordedDate, though the availability of this field varies significantly across different EHR implementations and vendor configurations.
The challenge for implementers lies in the fact that the OMOP CDM lacks a native equivalent field for recorded dates. This architectural decision reflects OMOP's focus on clinical events rather than administrative metadata. However, several implementation strategies can address this gap, including the development of custom extensions within the CONDITION_OCCURRENCE table, creation of dedicated metadata tables for comprehensive provenance tracking, utilization of the NOTE table with structured content, or establishing separate ETL audit tables that maintain this temporal information alongside the clinical data.

### Implementation Challenges and Considerations
It is a global challenge mapping FHIR to OMOP that OMOP's clinical-event focus prioritizes onset information over administrative timestamps. This philosophical difference requires architects and implementers to make deliberate decisions about how to preserve recorded date information when audit requirements or analytical needs demand such provenance tracking.
Missing data scenarios present particular complexity for ETL developers. When onsetDateTime is unavailable in the source FHIR data, the temptation exists to use recordedDate as a proxy for clinical onset. While this approach may seem pragmatic, it introduces analytical bias that can significantly impact downstream research and clinical decision-making. Such substitutions must be thoroughly documented in ETL metadata and clearly communicated to end users.

Temporal discrepancies between onset and documentation dates might reveal interesting patterns in healthcare delivery and documentation practices. Significant lags between when a condition clinically manifests and when it gets recorded in the EHR can affect different use cases in distinct ways, with clinical analyses requiring accurate onset timing while operational assessments may depend more heavily on documentation patterns. It is important for implementers to understand the differences in source date data context, and provide documentation regarding decisions made for each individual data source feeding an OMOP instance. 

### Recommendations for Managing Condition Dates

#### 1. Implement a configurable date-prioritization hierarchy
   * Always attempt to capture the onset (start) date first.
   * Fall back to the recorded (entry) date only when onset information is missing.
   * Tune this hierarchy for each source system and analytic use-case.

#### 2. Record ETL date-configuration decisions for every data source
   * Document the exact logic, fallback rules, and rationale used to derive temporal values.
   * Store this information in a data-governance catalog or ETL specification to preserve institutional knowledge, support audits, and simplify future maintenance.

#### 3. Encode the provenance of each temporal marker in `condition_type_concept_id`
   * Use distinct concept codes for markers such as "EHR onset date" and "EHR recorded date."
   * Provide downstream analysts with clear insight into which temporal marker they are using.

#### Aligning Date Types with Their Optimal Uses

| Date type | Best suited for | Focus |
|-----------|----------------|-------|
| **Onset (condition start) date** | Clinical-research studies, outcomes analyses, temporal cohort definitions | Reflecting biological and clinical reality |
| **Recorded (entry) date** | Data-governance metrics, ETL validation, documentation-pattern reviews, regulatory-compliance audits | Understanding and optimizing operational processes |

