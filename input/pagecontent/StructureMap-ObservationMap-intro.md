# Observation Resource Considerations
### Observation Category Definitions and Clinical Context
FHIR Observation Categories serve as organizational tools within EHR systems, providing essential context for clinical decision support and data retrieval operations. The categories in the [FHIR observation-category value set](https://www.hl7.org/fhir/R4B/codesystem-observation-category.html) encompass a spectrum of clinical observations, including Social History, Vital Signs, Laboratory, Imaging, Procedure, Survey, Exam, Therapy, and Activity. Considering the OMOP CDM semantically-based framework, FHIR Observations with observation-categories such as Laboratory and Vital Signs may actually map to OMOP's Measurement domain or other domain tables. As such, FHIR Observations may or may not align naturally with OMOP's existing Observation domain architecture, where the data are normalized across the OMOP CDM through Standardized concepts established in each domain. 

## A Domain-Based Mapping Strategy
OMOP's domain structure inherently categorizes data elements into logical groupings, with the Measurement domain handling quantitative clinical data and the Observation domain managing qualitative findings and contextual information. This existing structure effectively represents many FHIR categories without requiring explicit category mapping. At a high-level, mapping rules can be aligned with OMOP domains as reprsented in the table below However, the nuanced distinction between clinical observations and patient-reported data, or between routine clinical measurements and lifestyle assessments, may not be adequately preserved through domain assignment alone. 

<style>
    table {
        border-collapse: collapse;
        width: 100%;
        margin: 20px 0;
        border: 1px solid #d0d7de;
    }
    
    th, td {
        border: 1px solid #d0d7de;
        padding: 8px 12px;
        text-align: left;
        vertical-align: top;
    }
    
    th {
        background-color: #f6f8fa;
        font-weight: 600;
    }
    
    tr:nth-child(even) {
        background-color: #f6f8fa;
    }
    
    code {
        background-color: #f6f8fa;
        border-radius: 3px;
        padding: 2px 4px;
        font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
        font-size: 85%;
    }
</style>

<table>
    <thead>
        <tr>
            <th>FHIR Observation Type</th>
            <th>Target OMOP Table</th>
            <th>Rationale</th>
            <th>Examples</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Laboratory and Vital Signs</td>
            <td>Measurement</td>
            <td>Accommodates numeric values and supports standardization processes; leverages structured fields for quantitative clinical data requiring units and reference ranges</td>
            <td>Lab test results, blood pressure readings, temperature measurements</td>
        </tr>
        <tr>
            <td>Qualitative Observations</td>
            <td>Observation</td>
            <td>Appropriate for non-numeric components including survey responses, clinical notes, and general observations lacking strict measurement units</td>
            <td>Patient-reported outcomes, clinical assessments, survey responses</td>
        </tr>
        <tr>
            <td>Condition-Related Observations</td>
            <td>Condition</td>
            <td>Suitable when observations align closely with diagnoses or clinical conditions representing documented medical states</td>
            <td>Diagnostic findings, clinical impressions, documented conditions</td>
        </tr>
    </tbody>
</table>

Keep in mind that the domain-based guidelines outlined above serve as one of many approaches to consider, with recognition that specific edge cases will require detailed concept-based mapping decisions during implementation.

## Value Type Mapping Specifications

FHIR Observation resources support multiple value types (Quantity, CodeableConcept, string, Boolean), requiring careful consideration for OMOP field assignments. The following mapping strategy addresses this complexity through type-specific field assignments.

<table>
    <thead>
        <tr>
            <th>FHIR Value Type</th>
            <th>Target OMOP Field</th>
            <th>Primary Table</th>
            <th>Description</th>
            <th>Examples</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Quantity (Numeric)</td>
            <td><code>value_as_number</code></td>
            <td>Measurement</td>
            <td>Preserves quantitative nature of clinical measurements while maintaining data integrity</td>
            <td>Laboratory test results, vital sign measurements, dosage amounts</td>
        </tr>
        <tr>
            <td>CodeableConcept</td>
            <td><code>value_as_concept_id</code></td>
            <td>Measurement/Observation</td>
            <td>Ensures semantic consistency and enables standardized clinical queries using standardized terminologies</td>
            <td>SNOMED CT codes, LOINC codes, ICD-10 codes</td>
        </tr>
        <tr>
            <td>String/Text</td>
            <td><code>value_as_string</code></td>
            <td>Measurement/Observation</td>
            <td>Maintains descriptive clinical information that cannot be effectively represented through numeric or coded values</td>
            <td>Patient-reported descriptions, free-text observations, clinical notes</td>
        </tr>
        <tr>
            <td>Boolean</td>
            <td><code>value_as_concept_id</code></td>
            <td>Measurement/Observation</td>
            <td>Typically mapped to standardized Yes/No concepts in OMOP vocabulary</td>
            <td>Presence/absence indicators, binary clinical assessments</td>
        </tr>
    </tbody>
</table>

Implementation teams should note that FHIR's expressiveness often exceeds OMOP's structural capacity, requiring careful evaluation of value types that may need adaptation or exclusion if they cannot be effectively represented in the target OMOP model.

## Unit Handling and Standardization
FHIR Observation units are embedded within the Quantity type structure, typically utilizing standardized systems such as UCUM (Unified Code for Units of Measure). The mapping process must preserve unit information through OMOP's `unit_concept_id` field in the Measurement table.

While UCUM provides a robust grammar-based approach for constructing unit expressions and supports machine-to-machine communication through consistent representation (using "mg" rather than variations like "milligram" or "milligramme"), implementation teams must exercise caution when working with UCUM units in clinical data warehouses. UCUM's flexibility in allowing the creation of new units through its grammar system, while beneficial for specialized domains, can introduce analytical challenges if not properly managed. Care should be taken to normalize units of measure assigned to each result type within the datastore to support analytic consistency. For example, while UCUM may allow both "mg/dL" and "mg/100mL" as valid representations of the same conceptual unit, analytical processes require standardized unit assignment to ensure accurate cross-patient comparisons and longitudinal analysis.

**Standardization Processes** should include unit validation and conversion mechanisms to ensure consistent representation in the target OMOP model. This includes handling unit discrepancies, missing unit information, and ensuring alignment with OMOP's standardized vocabulary requirements while taking advantage of UCUM's ability to represent complex units like "mg/L" in a standardized format.

**Unit Consistency** becomes essential for maintaining data quality and ensuring interoperability across mapped datasets. Implementation teams must address scenarios where units vary between source systems or are not specified in the original FHIR data, establishing normalization rules that leverage UCUM's machine-readable format while ensuring analytical uniformity.
