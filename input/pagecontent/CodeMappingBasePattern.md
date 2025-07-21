Mapping coded data from FHIR to OMOP requires evaluation of the concepts to be stored in tables on OMOP, and these transformations can follow distinct patterns.  In this Implementation Guide, we propose a non-exhaustive list of transformation patterns and guidance regarding: 

* A base pattern that covers most simple code to concept transformation
* A pattern applicable to multiple CodeableConcepts scenarios
* Value-as-concept map pattern

Future enhoncements to this guide or groups developing additional implementation guides may discover and codify additional code mapping patterns.

### 1: Base Mapping Pattern

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="fhir_omop_base_pattern.svg" style="padding-top:0;padding-bottom:30px" width="400" alt="FHIR to OMOP Coded Data Base Mapping Pattern"/>
</figure>
{::options parse_block_html="true" /}

The foundational pattern for simple code-to-concept transformations provides the essential framework that underlies all other transformation approaches. This pattern addresses the most straightforward scenarios where FHIR resources contain single, well-defined codes that can be directly mapped to OMOP standard concepts without requiring complex prioritization or decomposition logic.

The base mapping process begins with extracting coded data from FHIR resources, focusing on identifying coded elements of the type CodeableConcept or Coding within the resource structure. This extraction phase requires careful attention to the location and structure of coded elements, as they may appear in different fields depending on the FHIR resource type and profile being processed. The extraction process must capture not only the code values themselves but also the associated system identifiers and any relevant metadata that may influence the mapping process.

Following code extraction, the transformation applies the Universal Code Prioritization Framework when multiple codes exist within the source data. Even in base mapping scenarios, multiple codes may be present due to system interoperability requirements or legacy data migration processes. The prioritization framework ensures consistent selection logic that favors standard vocabularies, clinical specificity, and explicit primary designations while providing fallback mechanisms for edge cases.

The vocabulary lookup phase applies the Standard OMOP Vocabulary Lookup Methodology to identify corresponding OMOP concepts for the selected source codes. This critical step validates that source codes have appropriate representations within the OHDSI Standardized Vocabularies and determines whether direct mapping is possible or if concept relationship traversal is required for non-standard source codes.

Domain determination utilizes the Domain Assignment Logic to identify the appropriate OMOP domain table for storing the clinical information. This step recognizes that vocabulary-driven domain assignment may differ from assumptions based solely on FHIR resource types, ensuring that clinical concepts are stored in semantically appropriate locations within the OMOP analytical framework.

Non-standard concept handling addresses scenarios where source codes map to non-standard OMOP concepts, requiring traversal of the concept_relationship table to identify appropriate standard concepts for analytical use. This process maintains the connection between source codes and their standard representations while preserving the original mapping context for audit and validation purposes.

The final population phase applies the Standard OMOP Field Population Template to ensure consistent data storage across all transformation instances. This standardization supports reliable analytical processes while maintaining essential data lineage information for quality assurance and future enhancement efforts.

#### Example: Diabetes Condition Mapping

Consider a straightforward diabetes diagnosis represented in a FHIR Condition resource with a single SNOMED CT code. The source resource demonstrates the ideal scenario for base pattern transformation, containing clear coded information without ambiguity or complex relationships.

```json
{
  "resourceType": "Condition",
  "id": "example",
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "44054006",
        "display": "Diabetes mellitus type 2"
      }
    ]
  },
  "subject": {
    "reference": "Patient/example"
  },
  "onsetDateTime": "2011-05-24"
}
```

The transformation process identifies SNOMED CT code 44054006 within the CodeableConcept structure, recognizing it as a single, well-defined concept suitable for direct mapping. Vocabulary lookup confirms that this code maps to OMOP concept_id 201826 with standard concept status, eliminating the need for concept relationship traversal. Domain assignment validation confirms that the concept resides in the Condition domain, aligning with the FHIR resource type and supporting storage in the condition_occurrence table.

```sql
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_source_value,
    condition_source_concept_id,
    condition_type_concept_id
) VALUES (
    [generated_id],
    [mapped_person_id],
    201826,                -- Standard OMOP concept
    '2011-05-24',
    '44054006',           -- Source preservation
    201826,               -- Source concept (already standard)
    32020                 -- EHR record type
);
```

This example demonstrates the straightforward application of the base pattern, showcasing direct vocabulary mapping, domain alignment, and comprehensive source preservation. The transformation maintains clinical accuracy while conforming to OMOP analytical requirements, providing a foundation for understanding more complex transformation scenarios.

#### Field Mapping Details

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">OMOP Field</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Value</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Source</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Transformation Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>condition_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">201826</td>
      <td style="border: 1px solid #d0d7de;">OMOP vocabulary lookup</td>
      <td style="border: 1px solid #d0d7de;">Standard concept from Step 2</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>condition_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">44054006</td>
      <td style="border: 1px solid #d0d7de;">FHIR code.coding[0].code</td>
      <td style="border: 1px solid #d0d7de;">Original source code preserved</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>condition_source_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">201826</td>
      <td style="border: 1px solid #d0d7de;">Same as standard concept</td>
      <td style="border: 1px solid #d0d7de;">Source code already standard</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>condition_start_date</code></td>
      <td style="border: 1px solid #d0d7de;">2011-05-24</td>
      <td style="border: 1px solid #d0d7de;">FHIR onsetDateTime</td>
      <td style="border: 1px solid #d0d7de;">Date extracted from FHIR</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>person_id</code></td>
      <td style="border: 1px solid #d0d7de;">[mapped_person_id]</td>
      <td style="border: 1px solid #d0d7de;">FHIR subject reference</td>
      <td style="border: 1px solid #d0d7de;">Patient reference resolution</td>
    </tr>
  </tbody>
</table>

The example above represents a straightforward transformation scenario with a direct vocabulary match and domain alignment. Real-world implementations should prepare for more complex scenarios involving non-standard vocabularies, domain mismatches, and mapping gaps, but this base pattern provides the foundational framework for handling all transformation cases systematically and consistently.
