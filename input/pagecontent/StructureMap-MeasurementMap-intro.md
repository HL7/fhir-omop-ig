# Observation Resource Considerations
### Observation Category Definitions and Clinical Context
FHIR Observation Categories serve as organizational tools within EHR systems, providing essential context for clinical decision support and data retrieval operations. The categories in the [FHIR observation-category value set](https://www.hl7.org/fhir/R4B/codesystem-observation-category.html) encompass a spectrum of clinical observations, including Social History, Vital Signs, Laboratory, Imaging, Procedure, Survey, Exam, Therapy, and Activity. Considering the OMOP CDM semantically-based framework, FHIR Observations with observation-categories such as Laboratory and Vital Signs may actually map to OMOP's Measurement domain or other domain tables. As such, FHIR Observations may or may not align naturally with OMOP's existing Observation domain architecture, where the data are normalized across the OMOP CDM through Standardized concepts established in each domain. (See: [OMOP Domain Assignment Logic](https://build.fhir.org/ig/HL7/fhir-omop-ig/codemappings.html#omop-domain-assignment-logic) for more information.) 

## A Domain-Based Mapping Strategy
OMOP's domain structure inherently categorizes data elements into logical groupings, with the Measurement domain handling quantitative clinical data and the Observation domain managing qualitative findings and contextual information. This existing structure effectively represents many FHIR categories without requiring explicit category mapping. At a high-level, mapping rules can be aligned with OMOP domains as reprsented in the table below However, the nuanced distinction between clinical observations and patient-reported data, or between routine clinical measurements and lifestyle assessments, may not be adequately preserved through domain assignment alone. 

### FHIR to OMOP Mapping Documentation

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">FHIR Observation Type</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Target OMOP Table</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Rationale</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Examples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Laboratory and Vital Signs</td>
      <td style="border: 1px solid #d0d7de;">Measurement</td>
      <td style="border: 1px solid #d0d7de;">Accommodates numeric values and supports standardization processes; leverages structured fields for quantitative clinical data requiring units and reference ranges</td>
      <td style="border: 1px solid #d0d7de;">Lab test results, blood pressure readings, temperature measurements</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Qualitative Observations</td>
      <td style="border: 1px solid #d0d7de;">Observation</td>
      <td style="border: 1px solid #d0d7de;">Appropriate for non-numeric components including survey responses, clinical notes, and general observations lacking strict measurement units</td>
      <td style="border: 1px solid #d0d7de;">Patient-reported outcomes, clinical assessments, survey responses</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Condition-Related Observations</td>
      <td style="border: 1px solid #d0d7de;">Condition</td>
      <td style="border: 1px solid #d0d7de;">Suitable when observations align closely with diagnoses or clinical conditions representing documented medical states</td>
      <td style="border: 1px solid #d0d7de;">Diagnostic findings, clinical impressions, documented conditions</td>
    </tr>
  </tbody>
</table>

Keep in mind that the domain-based guidelines outlined above serve as one of many approaches to consider, with recognition that specific edge cases will require detailed concept-based mapping decisions during implementation.

## Value Type Mapping Specifications

FHIR Observation resources support multiple value types (Quantity, CodeableConcept, string, Boolean), requiring careful consideration for OMOP field assignments. The following mapping strategy addresses this complexity through type-specific field assignments.

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">FHIR Value Type</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Target OMOP Field</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Primary Table</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Description</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Examples</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Quantity (Numeric)</td>
      <td style="border: 1px solid #d0d7de; background-color: #f6f8fa; border-radius: 3px; padding: 2px 4px; font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace; font-size: 85%;"><code>value_as_number</code></td>
      <td style="border: 1px solid #d0d7de;">Measurement</td>
      <td style="border: 1px solid #d0d7de;">Preserves quantitative nature of clinical measurements while maintaining data integrity</td>
      <td style="border: 1px solid #d0d7de;">Laboratory test results, vital sign measurements, dosage amounts</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">CodeableConcept</td>
      <td style="border: 1px solid #d0d7de;"><code>value_as_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">Measurement/Observation</td>
      <td style="border: 1px solid #d0d7de;">Ensures semantic consistency and enables standardized clinical queries using standardized terminologies</td>
      <td style="border: 1px solid #d0d7de;">SNOMED CT codes, LOINC codes, ICD-10 codes</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">String/Text</td>
      <td style="border: 1px solid #d0d7de;"><code>value_as_string</code></td>
      <td style="border: 1px solid #d0d7de;">Measurement/Observation</td>
      <td style="border: 1px solid #d0d7de;">Maintains descriptive clinical information that cannot be effectively represented through numeric or coded values</td>
      <td style="border: 1px solid #d0d7de;">Patient-reported descriptions, free-text observations, clinical notes</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Boolean</td>
      <td style="border: 1px solid #d0d7de;"><code>value_as_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">Measurement/Observation</td>
      <td style="border: 1px solid #d0d7de;">Typically mapped to standardized Yes/No concepts in OMOP vocabulary</td>
      <td style="border: 1px solid #d0d7de;">Presence/absence indicators, binary clinical assessments</td>
    </tr>
  </tbody>
</table>

Implementation teams should note that FHIR's expressiveness often exceeds OMOP's structural capacity, requiring careful evaluation of value types that may need adaptation or exclusion if they cannot be effectively represented in the target OMOP model.

## Unit Handling and Standardization
FHIR Observation units are embedded within the Quantity type structure, typically utilizing standardized systems such as [UCUM (Unified Code for Units of Measure)](https://ucum.org/). The mapping process must preserve unit information through OMOP's `unit_concept_id` field in the Measurement table.

While UCUM provides a robust grammar-based approach for constructing unit expressions and supports machine-to-machine communication through consistent representation (using "mg" rather than variations like "milligram" or "milligramme"), implementation teams must exercise caution when working with UCUM units in clinical data warehouses. UCUM's flexibility in allowing the creation of new units through its grammar system, while beneficial for specialized domains, can introduce analytical challenges by generating separate groups of records with nuanced units if not properly managed. Care should be taken to normalize units of measure assigned to each result type within the datastore to support analytic consistency. For example, while UCUM may allow both "mg/dL" and "mg/100mL" as valid representations of the same conceptual unit, data normalization processes should require standardized unit assignment to ensure accurate cross-patient comparisons and longitudinal analysis.
