The CodeableConcept patterns addresses the challenge of transforming FHIR CodeableConcept elements that may contain multiple codes, free text, or combinations of both. This pattern recognizes the tension between FHIR's flexibility in representing clinical concepts and OMOP's requirement for standardized, unambiguous concept identification. It provides systematic methodology for handling the complexity thast may arise in CodeableConcept structures while preserving clinical meaning and maintaining data quality standards.

CodeableConcept elements in FHIR can contain multiple coding entries, each potentially representing the same clinical concept through different terminology systems or at different levels of granularity. This variety of input provides opportunities for enhanced semantic representation but can also create complexity when determining which code should serve as the primary mapping target for OMOP transformation. The pattern addresses this complexity through assessment and prioritization logic.

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="codeable_concept_decision_tree.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR CodeableConcept to OMOP Pattern"/>
</figure>
{::options parse_block_html="true" /}

The transformation process begins with assessing code multiplicity within the CodeableConcept structure, determining whether multiple structured codes exist and evaluating their relationships to each other. When multiple codes are present, the system applies the [Code Prioritization Framework](https://build.fhir.org/ig/HL7/fhir-omop-ig/codemappings.html#code-prioritization-framework) to select the most appropriate code for OMOP mapping, considering vocabulary precedence, clinical specificity, primary designations, and temporal factors.

For CodeableConcepts containing only single structured codes, the process bypasses complex prioritization logic and proceeds directly to vocabulary lookup and domain assignment. This streamlined approach recognizes that single codes represent the ideal scenario for FHIR-to-OMOP transformation, eliminating ambiguity while maintaining data integrity and processing efficiency.

The vocabulary lookup step applies standard methodology to identify corresponding OMOP concepts, focusing on domain assignment that may differ from FHIR resource type expectations. A consistent vocabulary-driven approach ensures that clinical concepts are stored in appropriate OMOP domains, even when this conflicts with structural assumptions based on FHIR resource categorization.

Context preservation becomes particularly important in CodeableConcept transformation, as free text elements may contain valuable clinical information that supplements or clarifies the coded representations. The pattern suggests preserving this contextual information in appropriate OMOP *source_value fields, (a best practice [discussed here](https://build.fhir.org/ig/HL7/fhir-omop-ig/StrategiesBestPractices.html#source-value-preservation)) ensuring that any clinical nuance is not lost during the transformation process.

#### Example: Mapping No Known Allergy CodeableConcept

The transformation of negative assertion concepts demonstrates the importance of vocabulary-driven domain assignment in CodeableConcept processing. Consider an AllergyIntolerance resource that documents the absence of known allergies, representing a clinical concept that challenges traditional resource-to-domain mapping assumptions.

```json
{
  "resourceType": "AllergyIntolerance",
  "id": "no-known-allergy-example",
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "716186003",
        "display": "No known allergy (situation)"
      }
    ],
    "text": "NKA"
  },
  "patient": {
    "reference": "Patient/example"
  },
  "recordedDate": "2023-01-15"
}
```
The CodeableConcept contains a single SNOMED CT code representing a standardized approach to expressing the absence of known allergies, supplemented by free text that provides additional clinical context. Vocabulary lookup reveals that SNOMED CT code 716186003 maps to OMOP concept_id 4222295, but critically, this concept resides in the Observation domain rather than the Condition domain that might be expected based on the AllergyIntolerance resource type.

This domain assignment reflects OMOP's semantic organization, where negative assertions about clinical conditions are typically modeled as observations rather than conditions themselves. The vocabulary-driven domain assignment takes precedence over resource type expectations, demonstrating the importance of semantic accuracy in OMOP transformation processes.

```sql
INSERT INTO observation (
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_source_value,
    qualifier_source_value
) VALUES (
    [generated_id],
    [mapped_person_id],
    4222295,              -- No known allergy concept
    '2023-01-15',
    '716186003',         -- Source preservation
    'NKA'                -- Free text context preserved
);
```

The transformation successfully preserves both the structured coded information and the free text context while ensuring appropriate domain assignment based on vocabulary semantics. This example illustrates the critical importance of vocabulary-driven transformation logic and the value of preserving contextual information that supplements coded clinical data.

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
      <td style="border: 1px solid #d0d7de;"><code>observation_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">4222295</td>
      <td style="border: 1px solid #d0d7de;">SNOMED 716186003</td>
      <td style="border: 1px solid #d0d7de;">Standard OMOP concept for "No known allergy"</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>observation_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">716186003</td>
      <td style="border: 1px solid #d0d7de;">FHIR code.coding[0].code</td>
      <td style="border: 1px solid #d0d7de;">Original SNOMED code preserved</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>observation_source_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">4222295</td>
      <td style="border: 1px solid #d0d7de;">Same as standard</td>
      <td style="border: 1px solid #d0d7de;">Source code already standard</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>observation_date</code></td>
      <td style="border: 1px solid #d0d7de;">2023-01-15</td>
      <td style="border: 1px solid #d0d7de;">FHIR recordedDate</td>
      <td style="border: 1px solid #d0d7de;">Date of allergy status documentation</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>qualifier_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">NKA</td>
      <td style="border: 1px solid #d0d7de;">FHIR code.text</td>
      <td style="border: 1px solid #d0d7de;">Free text abbreviation preserved</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>value_as_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">NULL</td>
      <td style="border: 1px solid #d0d7de;">Not applicable</td>
      <td style="border: 1px solid #d0d7de;">No additional value needed for status assertion</td>
    </tr>
  </tbody>
</table>

In this example, the transformation successfully followed the proposed pattern, beginning with identification of the CodeableConcept input containing a negative assertion concept for "No known allergy." Since only a single SNOMED CT code was present in the coding array, the system  can bypass the prioritization logic step. An OMOP vocabulary lookup located the concept with an unexpected domain revelation - the concept mapped to the Observation domain rather than the anticipated Condition domain based on the source IPA AllergyIntolerance profile. In this onstance, there a need to complete an additional stpe was elminiated, as a standard OMOP concept was found and could be used directly.

The transformation revealed several key insights about handling negative assertion concepts in OMOP. The vocabulary domain assignment took precedence over FHIR resource type expectations, demonstrating that OMOP's semantic organization may differ from FHIR's resource categorization. This required routing the data to the observation table instead of condition_occurrence, while preserving the clinical context through the qualifier_source_value field containing the "NKA" abbreviation.

Although prioritization was not required due to the single code scenario, the transformation validated adherence to the established hierarchy. SNOMED was confirmed as the highest priority standard vocabulary, and the concept's standard status (S flag) allowed for direct usage without additional relationship mapping. As the text provided is an exact match to the preferred term in SNOMED, "No known allergy (situation)" with the SNOMED situational concept effectively capturing the clinical meaning of a negative assertion about allergy status is appropriately accepted.

Concept relationship verification using the standard query pattern validated the concept's position within the vocabulary hierarchy, while domain classification logic demonstrated how OMOP vocabulary domain assignments take precedence over FHIR resource type expectations. The AllergyIntolerance resource type initially suggested a Condition domain mapping, but the vocabulary's assignment to the Observation domain guided the final table selection decision. Standard concept validation confirmed the S flag status, eliminating the need for concept relationship mapping and approving direct usage in the observation_concept_id field. This vocabulary-driven approach ensures semantic consistency within the OMOP ecosystem while preserving the clinical intent of the original FHIR data.

### Alternative Scenario: Multiple Allergy Status Codes
If the CodeableConcept contained both SNOMED and a local code:

```json
"coding": [
  {
    "system": "http://snomed.info/sct",
    "code": "716186003",
    "display": "No known allergy (situation)"
  },
  {
    "system": "http://hospital.org/allergy-codes",
    "code": "NKA-001",
    "display": "No Known Allergies"
  }
]
```

**Prioritization Application:**
- **Standard Vocabulary First**: SNOMED CT selected over local code
- **Result**: Same mapping to concept_id 4222295
- **Local Code**: Preserved in observation_source_value as secondary

#### Related Allergy Concepts
Similar concepts that might appear in allergy contexts:


<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">SNOMED Code</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Concept Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">OMOP Domain</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>716186003</code></td>
      <td style="border: 1px solid #d0d7de;">No known allergy</td>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Observation</td>
      <td style="border: 1px solid #d0d7de;">Status assertion</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>429625007</code></td>
      <td style="border: 1px solid #d0d7de;">No known food allergy</td>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Observation</td>
      <td style="border: 1px solid #d0d7de;">Specific category</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>428607008</code></td>
      <td style="border: 1px solid #d0d7de;">No known environmental allergy</td>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Observation</td>
      <td style="border: 1px solid #d0d7de;">Environmental focus</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>409137002</code></td>
      <td style="border: 1px solid #d0d7de;">No known drug allergy</td>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Observation</td>
      <td style="border: 1px solid #d0d7de;">Medication-specific</td>
    </tr>
  </tbody>
</table>

All these concepts map to the Observation domain, maintaining consistency in OMOP representation. A concept-based domain mapping strategy is the fundamental consideration when OMOP vocabulary domain assignments differ from FHIR resource type expectations. 

The "absence of" semantics in these examples must be maintained in the target OMOP representation, ensuring that negative assertions remain clearly identifiable for clinical and research purposes. This preservation is critical because negative assertions significantly impact analytics queries - researchers must understand when "no known allergy" represents confirmed absence versus lack of documentation. Implementing robust temporal validity tracking becomes essential, as the timing of negative assertions affects their clinical relevance and validity periods. If manual mapping or hard-coded ETL processes are employed in FHIR to OMOP concpet mapping, clinical review processes must validate that OMOP representations accurately reflect the original clinical meaning, especially for concepts as are present in these examples that challenge traditional condition-versus-observation boundaries. Completeness checking ensures that all allergy status information is captured appropriately, while consistency monitoring tracks domain assignment patterns for similar concepts to identify potential mapping inconsistencies or opportunities for standardization across the implementation.

These "No Known Allergy" example demonstrates several critical aspects of FHIR CodeableConcept to OMOP transformation:

1. **Domain Complexity**: OMOP vocabulary domain assignment may differ from FHIR resource type expectations
2. **Negative Assertions**: Absence-of-condition concepts require special consideration in clinical data mapping
3. **Table Selection**: Proper OMOP table selection depends on vocabulary domain, not source resource type
4. **Context Preservation**: Free text elements provide valuable clinical context that should be preserved

The transformation successfully maps a common clinical concept while revealing the importance of vocabulary-driven domain assignment in OMOP implementations. This pattern applies to many similar negative assertion concepts in clinical documentation, providing a template for handling absence-of-finding scenarios in FHIR to OMOP transformations.

### Free Text in CodeableConcepts
CodeableConcept with free-text descriptions lacking corresponding coded elements, require manual review or natural language processing to extract and standardize clinical concepts. Free text mapping in this context addresses the transformation of unstructured text within a CodeableConcept element into Standard OMOP concepts. According to FHIR specification, the `text` element represents "the concept as entered or chosen by the user, and which most closely represents the intended meaning." The text often matches the display value of associated codings but may contain user-specific terminology or local clinical language. When codings are marked with `coding.userSelected = true`, this indicates the clinician's preferred representation. When no coding is user-selected, the text element becomes the preferred source of clinical meaning for transformation.

FHIR permits text-only representations when no appropriate standardized code exists:

```json
"valueCodeableConcept": {
    "text": "uncoded free text result"
}
```

These scenarios present the greatest transformation challenge, requiring manual mapping, comprehensive NLP analysis or explicit handling on OMOP as an unmapped source data. Unmapped content receives concept_id=0 with complete source text preservation in _source_value fields. Complex narratives may generate multiple OMOP records from single text sources, with temporal and contextual information influencing concept selection and date assignments.

#### CodeableConcept Free Text Mapping Examples

##### 1. Text with User-Selected Coding
**Source Text**: "Type 2 diabetes"
**Associated Coding**: SNOMED 44054006 with userSelected=true
**Transformation**: Use coded concept (201826) while preserving text in source_value

*OMOP Condition Record:*
```sql
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_type_concept_id,
    condition_source_value,
    condition_source_concept_id
) VALUES (
    12345,                                     -- condition_occurrence_id
    67890,                                     -- person_id
    201826,                                    -- condition_concept_id (Type 2 diabetes mellitus)
    '2024-03-15',                             -- condition_start_date
    '2024-03-15T10:30:00',                    -- condition_start_datetime
    32817,                                     -- condition_type_concept_id (EHR)
    'Type 2 diabetes',                         -- condition_source_value (original text)
    201826                                     -- condition_source_concept_id (same as standard)
);
```

##### 2. Ambiguous Clinical Language
**Source Text**: "Patient has diabetes"
**Challenge**: Unspecified diabetes type
**Mapping Strategy**: Map to general diabetes concept with quality flag for specificity limitation

*OMOP Condition Record:*
```sql
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_type_concept_id,
    condition_source_value,
    condition_source_concept_id,
    qualifier_source_value
) VALUES (
    12346,                                     -- condition_occurrence_id
    67890,                                     -- person_id
    201820,                                    -- condition_concept_id (Diabetes mellitus)
    '2024-03-15',                             -- condition_start_date
    '2024-03-15T10:30:00',                    -- condition_start_datetime
    32817,                                     -- condition_type_concept_id (EHR)
    'Patient has diabetes',                    -- condition_source_value (original text)
    0,                                         -- condition_source_concept_id (unmapped source)
    'LOW_SPECIFICITY'                          -- qualifier_source_value (quality flag)
);
```

##### 3. Medical Abbreviations
**Source Text**: "Pt w/ h/o MI, now c/o SOB"
**NLP Processing**: 
- "h/o MI" → "history of myocardial infarction"
- "c/o SOB" → "complains of shortness of breath"
**Result**: Two distinct condition records

*OMOP Condition Record 1 - History of MI:*
```sql
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_type_concept_id,
    condition_source_value,
    condition_source_concept_id,
    qualifier_source_value
) VALUES (
    12347,                                     -- condition_occurrence_id
    67890,                                     -- person_id
    4329847,                                   -- condition_concept_id (Myocardial infarction)
    '2024-03-15',                             -- condition_start_date
    '2024-03-15T10:30:00',                    -- condition_start_datetime
    32817,                                     -- condition_type_concept_id (EHR)
    'h/o MI',                                  -- condition_source_value (original abbreviation)
    0,                                         -- condition_source_concept_id (unmapped source)
    'HISTORY_OF'                               -- qualifier_source_value (temporal qualifier)
);
```

*OMOP Observation Record - Current SOB Complaint:*
```sql
INSERT INTO observation (
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_datetime,
    observation_type_concept_id,
    observation_source_value,
    observation_source_concept_id,
    qualifier_source_value
) VALUES (
    54321,                                     -- observation_id
    67890,                                     -- person_id
    4000045,                                   -- observation_concept_id (Dyspnea)
    '2024-03-15',                             -- observation_date
    '2024-03-15T10:30:00',                    -- observation_datetime
    32817,                                     -- observation_type_concept_id (EHR)
    'c/o SOB',                                -- observation_source_value (original abbreviation)
    0,                                         -- observation_source_concept_id (unmapped source)
    'PATIENT_COMPLAINT'                        -- qualifier_source_value (clinical context)
);
```

#### Example CodeableConcept Free Text Field Mapping Summary 


<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Scenario</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">OMOP Field</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Value</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Transformation Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">User-Selected Coding</td>
      <td style="border: 1px solid #d0d7de;"><code>condition_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">201826</td>
      <td style="border: 1px solid #d0d7de;">Direct mapping from userSelected SNOMED code</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"><code>condition_source_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">201826</td>
      <td style="border: 1px solid #d0d7de;">Source code already standard</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"><code>condition_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">"Type 2 diabetes"</td>
      <td style="border: 1px solid #d0d7de;">Preserves user-entered text</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Ambiguous Language</td>
      <td style="border: 1px solid #d0d7de;"><code>condition_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">201820</td>
      <td style="border: 1px solid #d0d7de;">General diabetes concept due to ambiguity</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"><code>condition_source_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">0</td>
      <td style="border: 1px solid #d0d7de;">No source coding available</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"><code>qualifier_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">"LOW_SPECIFICITY"</td>
      <td style="border: 1px solid #d0d7de;">Quality flag for clinical review</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Medical Abbreviations</td>
      <td style="border: 1px solid #d0d7de;"><code>condition_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">4329847</td>
      <td style="border: 1px solid #d0d7de;">MI mapped to standard concept</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"><code>observation_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">4000045</td>
      <td style="border: 1px solid #d0d7de;">SOB mapped to dyspnea concept</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"><code>qualifier_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">"HISTORY_OF", "PATIENT_COMPLAINT"</td>
      <td style="border: 1px solid #d0d7de;">Temporal and clinical context preserved</td>
    </tr>
  </tbody>
</table>
