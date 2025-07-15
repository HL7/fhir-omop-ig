# FHIR to OMOP Coded Data Transformation Patterns
Unlike purely schema-to-schema transformations, transforming FHIR to OMOP requires evalutaion of the concepts coded in the source data to determine and assign appropriate representation in a target OMOP database. This means that FHIR resources contained in profiles such as "IPA-Condition" or "IPA-Observation" may or may not generate records on a target OMOP domain table bearing the same or similar names, such as "condition_occurrence" and "observation."  Rather, the concepts represented in the FHIR resource determine the appropriate transformation targets, and each must be evalated on a case-by-case basis. FHIR coded source data transformation to OMOP often do follow patterns where similar data sources are processed through a common series of steps to populate an OMOP target database. This standardized approach lowers the decsiion burden for ETL developers and ensures consistent handling of coded clinical information across diverse healthcare datasets.  

## Understanding Coded Source Data
Coded source data in FHIR refers to information represented using standardized code systems such as SNOMED CT, LOINC, RxNorm, and other established terminologies. (See Using Codes in Resources for more information.) When mapping these FHIR elements to OMOP, implementers must ensure that codes are appropriately translated into the OHDSI Standardized Vocabularies and that the resulting data aligns with the correct domain classifications within the OMOP model.

## Mapping Complexity and Validation
Ensuring valid mappings from different source coding systems requires careful attention to the nature of the relationships between source and target concepts. While some mappings represent true one-to-one relationships that can be transformed directly, many cases involve one-to-many relationships between a coded source and multiple OMOP target concepts. These target concepts may reside within a single domain or span multiple domains within the OMOP structure. (See Standard concepts & Domain discussion for detailed information.)

The absence of established mappings in the OHDSI Standardized Vocabularies significantly increases the risk of incorrect or ambiguous data translation. Such gaps require careful evaluation and potentially custom mapping development to maintain data integrity during the transformation process.

## Automated Mapping Support
Leveraging a terminology server (e.g.: https://echidna.fhir.org) can facilitate automated mapping processes, particularly for free text or non-standard codes, while producing consistent mapping results across transformation instances. This approach reduces manual intervention and improves the reliability of code translation activities.

The OHDSI Athena website provides both access to request OHDSI Vocabulary downloads and a comprehensive searchable database that serves dual purposes for mapping activities. Implementers can use this resource to manually browse available vocabularies and identify codes that appropriately match source concepts to Standard OMOP concepts and also receive vocabulary updates when new versions are published.  Acess to the OHDSI Standardized Vocabularies, whether via API, downloads utilized in local systems or via manual interation with the Athena serach UI is essential for validating mappings and resolving complex terminology translation challenges that arise during FHIR to OMOP transformation projects.

### Key Elements of FHIR Coded Data
Coded data in FHIR resources minimally employ a pattern specififying a code and the coding system the code is derived from, and optional display and version attributes (see: Using Codes in Resources https://www.hl7.org/fhir/terminologies.html#4.1) 

* **Code**: The actual code from a standardized code system.
* **System**: The code system from which the code is drawn (e.g., SNOMED CT, LOINC).
* **Display**: A human-readable version of the code (optional).
* **Version**: The version of the code system (optional).

The code and system elements required in FHIR are also key search parameters when identifiying target concepts in the OHDSI Standardized Vocabularies. A FHIR Code System is represented in the OMOP CDM vocabulary table as a unique identifer (vocabulary_id) with an acompanying human-readable name (vocabulary_name).  A Code or Coding in FHIR is represented in the OMOP CDM concept table as a 'concept_code', which is linked to the vocabulary table via a vocabulary_id foreign key.  

## Mapping Process Patterns
As stated previously, mapping coded data from FHIR to OMOP requires evaluation of the concepts to be stored in tables on OMOP, and these transformations follow distinct patterns.  In this IG, we propose transformation patterns and guidance regarding: 

* A base pattern that covers most simple code to concept transformation
* A pattern applicable to many Codeable Concepts
* Value-as-concept map patterns 
* One source to many OMOP target domains 
* Multiple source reference evaluations
* OMOP non-Standard concept source coding
* Historical code and code system transformations

## FHIR to OMOP Base Mapping Pattern

{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR to OMOP Coded Data Base Mapping Pattern</b></figcaption>
<img src="../images/fhir_omop_base_pattern.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Coded Data Base Mapping Pattern"/>
</figure>
{::options parse_block_html="true" /}

1. **Extract Coded Data**:  Identify the coded elements within the FHIR resource. These elements are often of the type CodeableConcept or Coding.
2.  **Consult OMOP Vocabulary**:  Use the OMOP vocabulary tables to find the equivalent OMOP concept ID for the FHIR code. This involves looking up the code in the concept table within OMOP to find a matching standard concept.
3.  **Determine the Domain**:  Use the FHIR code to determine the appropriate OMOP domain (e.g., Condition, Drug, Observation). This could be based on the type of FHIR resource (e.g., Condition resource maps to OMOP Condition domain) or the OMOP Vocabulry may indicate the equivalent concept as modeled in the OHDSI Stanbdardize Vocabularies "lives" in a differt domain than the FHIR resource or profile it is sourced from.
4. **Handle Non-standard Concepts** see "OMOP non-Standard Concept Source Coding" section below
5. **Populate OMOP Fields**:  Fill in the relevant fields in the OMOP table, including concept_id, source_value, and other relevant attributes.

## Example: Mapping a Condition Resource

### Source FHIR Condition Resource

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

## Step-by-Step Base Pattern Transformation

### 1: Extract Coded Data
**Identify coded elements within the FHIR resource:**
- **Resource Type**: Condition
- **Coded Element Location**: `code` field
- **Element Type**: CodeableConcept containing Coding
- **Extracted Code**: 44054006
- **Coding System**: SNOMED CT (http://snomed.info/sct)
- **Display Text**: "Diabetes mellitus type 2"

The Condition resource contains a coded element in the `code` field, which is a CodeableConcept containing a single Coding with SNOMED CT code 44054006.

### 2: Consult OMOP Vocabulary
**Use OMOP vocabulary tables to find equivalent concept ID:**

```sql
SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_code, standard_concept
FROM concept
WHERE concept_code = '44054006' 
  AND vocabulary_id = 'SNOMED';
```

**Query Results:**
```
concept_id: 201826
concept_name: Type 2 diabetes mellitus
domain_id: Condition
vocabulary_id: SNOMED
concept_code: 44054006
standard_concept: S
```

**Vocabulary Lookup Analysis:**
- **OMOP Concept Found**: Yes
- **Concept ID**: 201826
- **Standard Concept Status**: S (Standard)
- **Vocabulary Match**: SNOMED CT vocabulary confirmed

### 3: Determine the Domain
**Determine appropriate OMOP domain based on FHIR code and resource type:**

**Initial Domain Assessment:**
- **FHIR Resource Type**: Condition
- **Expected OMOP Domain**: Condition

**OMOP Vocabulary Domain Verification:**
- **Vocabulary Domain**: Condition (from concept.domain_id)
- **Domain Alignment**: FHIR resource type matches OMOP domain
- **Final Domain Assignment**: Condition

The SNOMED CT code 44054006 resides in the Condition domain within OMOP vocabulary, which aligns with the FHIR Condition resource type, confirming appropriate domain assignment.

### 4: Handle Non-standard Concepts
**Evaluate standard concept status:**
- **Standard Concept Flag**: S (Standard)
- **Mapping Required**: No (already standard)
- **Direct Mapping**: Proceed with concept_id 201826

Since the SNOMED CT code maps to a standard OMOP concept, no additional concept relationship mapping is required. The concept can be used directly in OMOP tables.

### 5: Populate OMOP Fields
**Fill relevant fields in OMOP condition_occurrence table:**

```sql
INSERT INTO condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_source_value,
    condition_source_concept_id,
    condition_type_concept_id
) VALUES (
    [generated_id],                    -- condition_occurrence_id
    [mapped_person_id],                -- person_id from Patient/example
    201826,                            -- condition_concept_id (standard OMOP concept)
    '2011-05-24',                      -- condition_start_date
    '2011-05-24T00:00:00',            -- condition_start_datetime
    '44054006',                        -- condition_source_value
    201826,                            -- condition_source_concept_id
    32020                              -- condition_type_concept_id (EHR record)
);
```

## Field Mapping Details

| OMOP Field | Value | Source | Transformation Notes |
|------------|--------|---------|---------------------|
| `condition_concept_id` | 201826 | OMOP vocabulary lookup | Standard concept from Step 2 |
| `condition_source_value` | 44054006 | FHIR code.coding[0].code | Original source code preserved |
| `condition_source_concept_id` | 201826 | Same as standard concept | Source code already standard |
| `condition_start_date` | 2011-05-24 | FHIR onsetDateTime | Date extracted from FHIR |
| `person_id` | [mapped_person_id] | FHIR subject reference | Patient reference resolution |

## Base Pattern Validation
### Transformation Steps Applied
1. **Extract Coded Data**: SNOMED CT code 44054006 identified in CodeableConcept
2. **Consult OMOP Vocabulary**: Successful lookup yielding concept_id 201826
3. **Determine Domain**: Condition domain confirmed through resource type and vocabulary
4. **Handle Non-standard Concepts**: Not required (standard concept found)
5. **Populate OMOP Fields**: condition_occurrence table populated with mapped values

### Quality Verification
- **Code Extraction**: Successful identification of coded element
- **Vocabulary Mapping**: Direct match found in OMOP concept table
- **Domain Alignment**: FHIR resource type matches OMOP domain
- **Data Preservation**: Source values maintained in OMOP fields

The example above represents a straightforward transformation scenario with a direct vocabulary match and domain alignment. Real-world implementations should prepare for more complex scenarios involving non-standard vocabularies, domain mismatches, and mapping gaps, but this base pattern provides the foundational framework for handling all transformation cases systematically and consistently.

## FHIR CodeableConcept Mapping Pattern
Codeable concepts are one of the coded datatypes represented in FHIR resources. In FHIR, a CodeableConcept is "A type that represents a concept by plain text and/or one or more coding elements"  The transformation of FHIR CodeableConcept elements to OMOP format create a challenge to uniform transformation practices, but also represents a critical bridge between the flexible, interoperable world of FHIR and the structured, analytics-focused environment of the OMOP Common Data Model. This Pattern aims to partially address the tension between FHIR's allowance for both structured codes and free text versus OMOP's strict requirement for standardized vocabularies, but does not explicitly address transformation of purely free-text expressions allowed in CodeableConcepts.

{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR CodeableConcept to OMOP Pattern</b></figcaption>
<img src="../images/codeable_concept_decision_tree.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR CodeableConcept to OMOP Pattern"/>
</figure>
{::options parse_block_html="true" /}

### 1: FHIR CodeableConcept Input
In FHIR, CodeableConcept elements can contain multiple "codings," each potentially including a code, display name, and system identifier. Importantly, this FHIR to OMOP transformation Pattern assumes the presence of structured codes, deliberately scoping out free text scenarios that pose significant mapping challenges to OMOP's standardized vocabulary requirements.

### 2: Multiple Code Assessment and Prioritization
When multiple structured codes are present within the CodeableConcept, the system should apply a sophisticated prioritization logic. This step addresses the reality that clinical systems often provide multiple codes for the same concept, either from different coding systems or at different levels of specificity. The prioritization follows a clear hierarchy: **OMOP standard vocabularies** take precedence (SNOMED CT, RxNorm, LOINC), followed by **code specificity** (more specific clinical concepts over general ones), then **primary designation** (if explicitly marked as, for example a primary or admitting diagnosis), and finally **temporal precedence** (the first time a coded event or condition was encountered). Applying a systematic approach prioritizing otherwise undifferentiated multiple inputs ensures consistent, predictable mapping outcomes while preserving clinical accuracy.

### 3: Single Code Processing
For CodeableConcepts containing only one structured code, the process bypasses prioritization and proceeds directly to vocabulary lookup. This streamlined path recognizes that single codes represent the ideal scenario for FHIR-to-OMOP transformation, eliminating ambiguity while maintaining data integrity. The single code serves as a direct mapping candidate, though it still requires validation against OMOP's standardized vocabularies.

### 4: OMOP Concept Lookup
Just like the Base Transformation Pattern outlined above, this critical step is the foundation for transformation through OMOP Standard vocabulary mapping. The selected code (whether from prioritization or single code processing) undergoes lookup against the OHDSI Standardized Vocabularies to identify the corresponding OMOP concept_id. This process involves concept relationship traversal, Standard OMOP concept validation, and domain classification. The lookup mechanism addresses OMOP's critical, key alignment feature and requirement that all data be represented using a single Standard concept in each OMOP domain.  This also ensures that every clinical concept maps to a single OMOP concept_id from an included source terminology system.

### 5: OMOP Concept Mapping
When a valid OMOP mapping is identified, the system should create a complete record on the OMOP concept table, including the domain classification, concept_id, concept status, and source values. Although the source values are not required by the OMOP CDM specification, it is a strongly encouraged best practice to populate the source value fields.  This small ETL effort  makes the OMOP datastore much more “future-proof”, as the source data provides invaluable information about its context at generation and transformation lineage.

### 6: No Standard Mapping Available
When no standard OMOP mapping exists for the source code, the system stores the concept with concept_id=0 ,and as stated above should preserve the original source data. This approach acknowledges the reality that not all clinical codes have direct OMOP equivalents, particularly for newer terminologies or highly specialized clinical domains. By preserving the original data alongside the unmapped status, the system maintains data completeness and alignment with the OMOP CDM while clearly indicating the limitation of that data specifically for use in OMOP-based analytics.

### Prioritization Logic (Golden Box)
The proposed prioritization framework addresses the complex reality of multiple coding scenarios by establishing clear precedence rules. This systematic approach eliminates ambiguity in code selection while ensuring reproducible transformation outcomes.

#### 1. Standard Vocabularies First
- **SNOMED CT**: Prioritize for conditions, procedures, and clinical observations due to its comprehensive coverage and OMOP's primary reliance on SNOMED concepts
- **RxNorm**: Give precedence for medications, drug products, and pharmaceutical concepts as the standard drug vocabulary in OMOP
- **LOINC**: Prioritize for laboratory tests, measurements, and clinical observations, particularly lab results and vital signs
- **ICD-10/ICD-9**: Use only when no standard vocabulary equivalent exists, as these are considered non-standard in OMOP but may have mappings to standard concepts
- **CPT/HCPCS**: Accept for procedures when SNOMED equivalents are not available, though these require mapping to standard concepts
- **Local/Proprietary codes**: Lowest priority, should only be used when no standard vocabulary alternative exists

#### 2. Most Specific Code
- **Clinical granularity**: Choose codes that provide the highest level of clinical detail (e.g., "Type 2 diabetes with diabetic nephropathy" over "diabetes mellitus")
- **Anatomical precision**: Prefer codes that specify exact anatomical locations when available (e.g., "fracture of left femoral neck" over "femoral fracture")
- **Temporal specificity**: Select codes that include timing information when relevant (e.g., "acute myocardial infarction" over "myocardial infarction")
- **Severity indicators**: Prioritize codes that include severity or stage information when clinically relevant
- **Laterality**: Choose codes that specify left/right/bilateral when anatomically appropriate
- **Avoid parent concepts**: Reject general parent codes when more specific child concepts are available in the coding array

#### 3. Primary Designation
- **Explicit primary flags**: Honor any explicit "primary" or "preferred" designations in the FHIR coding array
- **Use flags**: Respect FHIR use codes such as "usual," "official," or "preferred" when present
- **System preferences**: Consider organizational or system-level preferences for specific vocabularies when documented
- **Clinical context**: Factor in the clinical context where primary designation may indicate diagnostic certainty or treatment focus
- **Documentation guidelines**: Follow institutional coding guidelines that may designate preferred vocabularies for specific clinical domains

#### 4. Temporal Precedence
- **First encountered rule**: When all other criteria are equal, select the first code appearing in the coding array
- **Consistent tie-breaking**: Apply this rule uniformly across all transformation instances to ensure reproducible results
- **Array order preservation**: Maintain the original order of codes as provided by the source system
- **Audit trail**: Document when temporal precedence was the deciding factor for transparency and quality assurance
- **System behavior**: Ensure predictable behavior when multiple equally valid codes exist

### CodeableConcept Key Challenges and Considerations
This transformation pattern deliberately excludes free text handling, recognizing the significant challenges it poses to OMOP's structured requirements. While FHIR's flexibility allows for free text descriptions when structured codes are unavailable, OMOP's analytics-focused design requires standardized vocabularies. The decision to scope out free text in a project may be a pragmatic approach that prioritizes data quality and consistency over comprehensive coverage.  For implementations encountering and wishing to include free text, additional processing through utilization of terminology servers or natural language processing tools may be necessary to convert textual descriptions into standardized codes before applying this transformation pattern.

## Example: Mapping No Known Allergy CodeableConcept

### Source FHIR AllergyIntolerance Resource

```json
{
  "resourceType": "AllergyIntolerance",
  "id": "no-known-allergy-example",
  "clinicalStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
        "code": "active"
      }
    ]
  },
  "verificationStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
        "code": "confirmed"
      }
    ]
  },
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

## Step-by-Step CodeableConcept Transformation

### 1: FHIR CodeableConcept Input
**Input Analysis:**
- **Resource Type**: AllergyIntolerance
- **CodeableConcept Location**: `code` element
- **Clinical Concept**: No known allergy status assertion
- **Structured Code Present**: Yes (SNOMED CT code available)
- **Free Text**: "NKA" (additional context)

The AllergyIntolerance resource contains a CodeableConcept that is a negative statement regarding the presence of allergies. This presents a challenge for OMOP transformation.

### 2: Multiple Code Assessment
**Decision Point**: Multiple codes present?
- **Coding Array Count**: 1 code (SNOMED CT only)
- **Decision**: No - Single code present
- **Next Step**: Proceed to Step 3 (Use Single Code)

The CodeableConcept contains only one structured code, eliminating the need for prioritization logic.

### 3: Use Single Code
**Single Code Processing:**
- **Selected Code**: 716186003
- **Source System**: SNOMED CT (http://snomed.info/sct)
- **Display Name**: "No known allergy (situation)"
- **Processing Status**: Direct mapping candidate identified

The SNOMED CT code represents a standardized way to express the absence of known allergies, suitable for OMOP vocabulary lookup.

### 4: OMOP Concept Lookup
**Standard Vocabulary Mapping:**

```sql
SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_code, standard_concept
FROM concept
WHERE concept_code = '716186003' 
  AND vocabulary_id = 'SNOMED';
```

**Query Results:**
```
concept_id: 4222295
concept_name: No known allergy
domain_id: Observation
vocabulary_id: SNOMED
concept_code: 716186003
standard_concept: S
```

**Lookup Analysis:**
- **OMOP Concept Found**: Yes
- **Standard Concept**: Yes (S flag)
- **Domain Assignment**: Observation (not Condition as might be expected)
- **Vocabulary Alignment**: SNOMED CT standard vocabulary confirmed

**Critical Domain Consideration:**
The OMOP vocabulary assigns this concept to the Observation domain rather than the Condition domain, despite originating from an AllergyIntolerance FHIR resource. This demonstrates the importance of vocabulary-driven domain assignment over resource type assumptions.

### 5: OMOP Concept Mapping
- **Target Concept ID**: 4222295
- **Domain Classification**: Observation
- **Concept Status**: Standard (S)
- **Target OMOP Table**: observation (not condition_occurrence)

A lookup reveals that "No known allergy" maps to the Observation domain in OMOP, requiring population of the observation table rather than condition_occurrence.

## OMOP Table Population

### Observation Table Mapping

```sql
INSERT INTO observation (
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_datetime,
    observation_type_concept_id,
    value_as_concept_id,
    observation_source_value,
    observation_source_concept_id,
    unit_source_value,
    qualifier_source_value
) VALUES (
    [generated_id],                    -- observation_id
    [mapped_person_id],                -- person_id from Patient/example
    4222295,                           -- observation_concept_id (No known allergy)
    '2023-01-15',                      -- observation_date
    '2023-01-15T00:00:00',            -- observation_datetime
    32817,                             -- observation_type_concept_id (EHR)
    NULL,                              -- value_as_concept_id (not applicable)
    '716186003',                       -- observation_source_value
    4222295,                           -- observation_source_concept_id
    NULL,                              -- unit_source_value
    'NKA'                              -- qualifier_source_value
);
```

### Field Mapping Details

| OMOP Field | Value | Source | Transformation Notes |
|------------|--------|---------|---------------------|
| `observation_concept_id` | 4222295 | SNOMED 716186003 | Standard OMOP concept for "No known allergy" |
| `observation_source_value` | 716186003 | FHIR code.coding[0].code | Original SNOMED code preserved |
| `observation_source_concept_id` | 4222295 | Same as standard | Source code already standard |
| `observation_date` | 2023-01-15 | FHIR recordedDate | Date of allergy status documentation |
| `qualifier_source_value` | NKA | FHIR code.text | Free text abbreviation preserved |
| `value_as_concept_id` | NULL | Not applicable | No additional value needed for status assertion |

In this example, the transformation successfully followed the proposed pattern, beginning with identification of the CodeableConcept input containing a negative assertion concept for "No known allergy." Since only a single SNOMED CT code was present in the coding array, the system  can bypass the prioritization logic step. An OMOP vocabulary lookup located the concept with an unexpected domain revelation - the concept mapped to the Observation domain rather than the anticipated Condition domain based on the source IPA AllergyIntolerance profile. In this onstance, there a need to complete an additional stpe was elminiated, as a standard OMOP concept was found and could be used directly.

The transformation revealed several key insights about handling negative assertion concepts in OMOP. The vocabulary domain assignment took precedence over FHIR resource type expectations, demonstrating that OMOP's semantic organization may differ from FHIR's resource categorization. This required routing the data to the observation table instead of condition_occurrence, while preserving the clinical context through the qualifier_source_value field containing the "NKA" abbreviation.

Although prioritization was not required due to the single code scenario, the transformation validated adherence to the established hierarchy. SNOMED was confirmed as the highest priority standard vocabulary, and the concept's standard status (S flag) allowed for direct usage without additional relationship mapping. As the text provided is an exact match to the preferred term in SNOMED, "No known allergy (situation)" with the SNOMED situational concept effectively capturing the clinical meaning of a negative assertion about allergy status is appropriately accepted.

Concept relationship verification using the standard query pattern validated the concept's position within the vocabulary hierarchy, while domain classification logic demonstrated how OMOP vocabulary domain assignments take precedence over FHIR resource type expectations. The AllergyIntolerance resource type initially suggested a Condition domain mapping, but the vocabulary's assignment to the Observation domain guided the final table selection decision. Standard concept validation confirmed the S flag status, eliminating the need for concept relationship mapping and approving direct usage in the observation_concept_id field. This vocabulary-driven approach ensures semantic consistency within the OMOP ecosystem while preserving the clinical intent of the original FHIR data.

## Alternative Scenario: Multiple Allergy Status Codes
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

### Scenario B: Related Allergy Concepts
Similar concepts that might appear in allergy contexts:

| SNOMED Code | Concept Name | OMOP Domain | Notes |
|-------------|--------------|-------------|-------|
| 716186003 | No known allergy | Observation | Status assertion |
| 429625007 | No known food allergy | Observation | Specific category |
| 428607008 | No known environmental allergy | Observation | Environmental focus |
| 409137002 | No known drug allergy | Observation | Medication-specific |

All these concepts map to the Observation domain, maintaining consistency in OMOP representation. A concept-based domain mapping strategy is the fundamental consideration when OMOP vocabulary domain assignments differ from FHIR resource type expectations. 

The "absence of" semantics in these examples must be maintained in the target OMOP representation, ensuring that negative assertions remain clearly identifiable for clinical and research purposes. This preservation is critical because negative assertions significantly impact analytics queries - researchers must understand when "no known allergy" represents confirmed absence versus lack of documentation. Implementing robust temporal validity tracking becomes essential, as the timing of negative assertions affects their clinical relevance and validity periods. If manual mapping or hard-coded ETL processes are employed in FHIR to OMOP concpet mapping, clinical review processes must validate that OMOP representations accurately reflect the original clinical meaning, especially for concepts as are present in these examples that challenge traditional condition-versus-observation boundaries. Completeness checking ensures that all allergy status information is captured appropriately, while consistency monitoring tracks domain assignment patterns for similar concepts to identify potential mapping inconsistencies or opportunities for standardization across the implementation.

These "No Known Allergy" example demonstrates several critical aspects of FHIR CodeableConcept to OMOP transformation:

1. **Domain Complexity**: OMOP vocabulary domain assignment may differ from FHIR resource type expectations
2. **Negative Assertions**: Absence-of-condition concepts require special consideration in clinical data mapping
3. **Table Selection**: Proper OMOP table selection depends on vocabulary domain, not source resource type
4. **Context Preservation**: Free text elements provide valuable clinical context that should be preserved

The transformation successfully maps a common clinical concept while revealing the importance of vocabulary-driven domain assignment in OMOP implementations. This pattern applies to many similar negative assertion concepts in clinical documentation, providing a template for handling absence-of-finding scenarios in FHIR to OMOP transformations.

## Free Text in CodeableConcept Mapping

Free text mapping addresses the transformation of unstructured text into Standard OMOP concepts. CodeableConcept with free-text descriptions lacking corresponding coded elements, require manual review or natural language processing to extract and standardize clinical concepts. This description provides an approach for converting text in FHIR CodeableConcept elements into OMOP-compatible structured data while preserving clinical meaning.

## Text in CodeableConcept Elements

According to FHIR specification, the `text` element represents "the concept as entered or chosen by the user, and which most closely represents the intended meaning." The text often matches the display value of associated codings but may contain user-specific terminology or local clinical language. When codings are marked with `coding.userSelected = true`, this indicates the clinician's preferred representation. When no coding is user-selected, the text element becomes the preferred source of clinical meaning for transformation.

### Free Text Only Representations

FHIR permits text-only representations when no appropriate standardized code exists:

```json
"valueCodeableConcept": {
    "text": "uncoded free text result"
}
```

These scenarios present the greatest transformation challenge, requiring manual mapping, comprehensive NLP analysis or explicit handling on OMOP as an unmapped source data.

## FHIR Free Text Sources and Context

Free text appears across FHIR resources in CodeableConcept.text elements (Condition.code.text, Procedure.code.text, MedicationRequest.medicationCodeableConcept.text) and narrative fields (DiagnosticReport.conclusion, AllergyIntolerance.note.text). These sources often contain clinician-entered terminology that differs from standardized vocabulary displays while preserving essential clinical context.

## Natural Language Processing for Clinical Text

Clinical NLP systems must handle medical abbreviations, complex terminology, temporal expressions, and implicit clinical relationships. Advanced systems employ named entity recognition, relationship extraction, negation detection, and temporal analysis specifically adapted for medical language. Terminology mapping leverages SNOMED CT, RxNorm, LOINC, and UMLS resources through fuzzy matching, synonym recognition, and hierarchical concept navigation to accommodate clinical language variability.

## OMOP Transformation and Source Value Preservation

Like other mapping patterns discussed previously, mapping free text component of a CodeableConcept requires validation that identified concepts exist as standard OMOP concepts with appropriate domain assignments. The _source_value fields preserve original free text exactly as documented, while _source_concept_id typically contains 0 for unmapped source vocabularies. The _concept_id field contains the standard OMOP concept representing the extracted clinical meaning.

## Handling Unmapped and Complex Clinical Text

Unmapped content receives concept_id=0 with complete source text preservation in _source_value fields. Complex narratives may generate multiple OMOP records from single text sources, with temporal and contextual information influencing concept selection and date assignments.

## CodeableConcept Free Text Mapping Examples

### 1. Text with User-Selected Coding
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

### 2. Ambiguous Clinical Language
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

### 3. Medical Abbreviations
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

### example CodeableConcept Free Text Field Mapping Summary 

| Scenario | OMOP Field | Value | Transformation Notes |
|----------|------------|-------|---------------------|
| **User-Selected Coding** | condition_concept_id | 201826 | Direct mapping from userSelected SNOMED code |
| | condition_source_concept_id | 201826 | Source code already standard |
| | condition_source_value | "Type 2 diabetes" | Preserves user-entered text |
| **Ambiguous Language** | condition_concept_id | 201820 | General diabetes concept due to ambiguity |
| | condition_source_concept_id | 0 | No source coding available |
| | qualifier_source_value | "LOW_SPECIFICITY" | Quality flag for clinical review |
| **Medical Abbreviations** | condition_concept_id | 4329847 | MI mapped to standard concept |
| | observation_concept_id | 4000045 | SOB mapped to dyspnea concept |
| | qualifier_source_value | "HISTORY_OF", "PATIENT_COMPLAINT" | Temporal and clinical context preserved |

## FHIR to OMOP Value-as-Concept Map Pattern
Drug allergies represent a complex transformation challenge in FHIR-to-OMOP mapping due to their composite nature. In FHIR, an AllergyIntolerance resource typically contains a coded element representing both the allergy type and the specific substance.  This is not aligned with OMOP's preference for decomposed, granular concept representation. The Value-as-Comcept Map pattern addresses the tension between FHIR's composite coding approach and OMOP's value-as-concept methodology, which separates the observation type (allergy classification) from the specific substance causing the reaction.

### FHIR to OMOP Value as Concept Pattern: Drug Allergy
{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR to OMOP Value as Concept Map Pattern</b></figcaption>
<img src="../images/Value as concept map pattern (2).svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Value as Concept Map Pattern"/>
</figure>
{::options parse_block_html="true" /}

#### 1: FHIR AllergyIntolerance Input
FHIR AllergyIntolerance resources contain coded elements in the `code` field that often represent composite concepts combining both the allergy type and the specific substance. For drug allergies, this typically appears as structured codes like "Allergy to benzylpenicillin" (SNOMED CT: 294930007), which contains both the allergic reaction classification and the specific pharmaceutical substance. This pattern assumes the presence of structured codes that can be semantically decomposed.  We are deliberately excluding free-text-only allergy descriptions in this example, as these pose an array of differnt mapping challenges.

#### 2: Decompose for Mapping Analysis
The system analyzes the composite concept to determine whether it can be meaningfully separated into constituent parts: an observation concept representing the allergy type and a value concept representing the specific substance. This decomposition process examines the semantic structure of codes like "Allergy to [substance]" to identify patterns suitable for value-as-concept transformation. The analysis considers whether both components (allergy type and substance) have equivalent representations in OMOP standard vocabularies, ensuring that the clinical meaning remains intact through the transformation process.

**Decision Point: Decomposition Available as OMOP Standard Concepts?**

If the composite concept can be successfully decomposed into standard OMOP concepts for both the observation type and the substance value, the system proceeds with the value-as-concept approach. If decomposition is not possible or would result in loss of clinical meaning, the system routes to manual mapping alternatives.

#### 3a: Apply Value as Concept
When decomposition is successful, the system or ETL script applies the value-as-concept pattern by mapping the allergy type to `observation_concept_id` and the specific substance to `value_as_concept_id`. For example, "Allergy to benzylpenicillin" decomposes to:
- **observation_concept_id**: 439224 ("Allergy to drug")
- **value_as_concept_id**: 1728416 ("Penicillin G")

This approach maintains the semantic relationship while enabling both general allergy queries and substance-specific analytics within the OMOP framework.

#### 3b: Manual Mapping
When automatic decomposition fails or results in unmappable components, manual decomposition and mapping may be required to preserve clinical meaning while adhering to OMOP principles. This may involve identifying alternative standard concepts that capture the essential clinical information or creating source concept mappings that maintain traceability to the original FHIR data.

#### 4: OMOP Vocabulary Lookup
The decomposed concepts undergo validation against OHDSI Standardized Vocabularies to confirm that both the observation concept and value concept exist as Standard OMOP concepts. This critical validation step ensures that the mapped concepts upoholds the OMOP conventions for Standard concept alignment withtin each Domian (** See disccusion of OMOP Standard Concpets here**) and will integrate properly with OMOP-based analytics tools. The lookup process verifies concept status, domain assignment, and relationship mappings.

**Decision Point: All Concepts Found in OMOP?**

If both the observation concept and value concept are confirmed as standard OMOP concepts, the system proceeds to populate the appropriate OMOP domain table(s). If either concept is missing or non-standard, the system should identify vocabulary gaps and consider alternative mapping strategies.

#### 5a: Populate Appropriate OMOP Domain
When all concepts are successfully validated, the system populates the OMOP Observation domain using the value-as-concept pattern:
- **concept_id**: 439224 (Allergy to drug) - assigned to Observation Domain
- **value_as_concept_id**: 1728416 (Penicillin G)

#### 5b: Identify Vocabulary Gap
If mapping to OMOP Standard concepts mappings is not possible, the system should document missing concepts and consider local extensions for missing source concepts. This process maintains data completeness while clearly indicating limitations for OMOP-based analytics. The system then should preserve the original source values and creates mappings to concept_id=0, following OMOP best practices for handling unmapped data.

#### 6: Optional: Handle Reactions
For comprehensive allergy documentation, the system can create linked observations for allergic reactions using `observation_event_id` to maintain the relationship between the allergen and the specific reaction manifestations. This optional step enables detailed reaction tracking while preserving the primary allergy-substance relationship established through the value-as-concept pattern.

#### 7: Map Quality Validation
The transformation process includes verification that clinical meaning is preserved and value concept alignment maintains semantic accuracy. This validation ensures that the decomposed representation accurately reflects the original clinical intent while conforming to OMOP analytical requirements.

## Example Mapping: SNOMED 294930007

**Source FHIR AllergyIntolerance Resource**
```json
{
  "resourceType": "AllergyIntolerance",
  "id": "penicillin-allergy-example",
  "clinicalStatus": {
    "coding": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
        "code": "active"
      }
    ]
  },
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "294930007",
        "display": "Allergy to benzylpenicillin"
      }
    ]
  },
  "patient": {
    "reference": "Patient/example"
  },
  "recordedDate": "2024-03-15"
}
```

### Step-by-Step Value as Concept Transformation

**1: FHIR AllergyIntolerance Input**
- **Resource Type**: AllergyIntolerance
- **Coded Element**: code.coding[0]
- **Source System**: SNOMED CT (http://snomed.info/sct)
- **Composite Concept**: 294930007 ("Allergy to benzylpenicillin")
- **Clinical Meaning**: Drug allergy with specific pharmaceutical substance

**2: Decompose for Mapping Analysis**
- **Composite Analysis**: "Allergy to benzylpenicillin" contains both allergy type and substance
- **Semantic Pattern**: "Allergy to [substance]" pattern identified
- **Decomposition Target**: Separate allergy classification from pharmaceutical substance
- **Decision**: Decomposition possible with standard OMOP concepts

**3a: Apply Value as Concept**
- **Observation Component**: "Allergy to drug" → OMOP concept lookup required
- **Value Component**: "benzylpenicillin" → OMOP concept lookup required
- **Pattern Applied**: Value-as-concept methodology
- **Semantic Preservation**: Clinical meaning maintained through decomposition

**4: OMOP Vocabulary Lookup**

*Observation Concept Query:*
```sql
SELECT concept_id, concept_name, domain_id, vocabulary_id, standard_concept
FROM concept
WHERE concept_name LIKE '%Allergy to drug%'
  AND vocabulary_id = 'SNOMED'
  AND standard_concept = 'S';
```

*Query Results - Observation Concept:*
- **concept_id**: 439224
- **concept_name**: Allergy to drug
- **domain_id**: Observation
- **vocabulary_id**: SNOMED
- **standard_concept**: S

*Value Concept Query:*
```sql
SELECT concept_id, concept_name, domain_id, vocabulary_id, standard_concept
FROM concept
WHERE concept_name LIKE '%Penicillin G%'
  AND vocabulary_id IN ('RxNorm', 'SNOMED')
  AND standard_concept = 'S';
```

*Query Results - Value Concept:*
- **concept_id**: 1728416
- **concept_name**: Penicillin G
- **domain_id**: Drug
- **vocabulary_id**: RxNorm
- **standard_concept**: S

**5a: Populate Appropriate OMOP Domain**

*Observation Table Mapping:*
```sql
INSERT INTO observation (
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_datetime,
    observation_type_concept_id,
    value_as_concept_id,
    observation_source_value,
    observation_source_concept_id,
    value_source_value
) VALUES (
    [generated_id],                    -- observation_id
    [mapped_person_id],                -- person_id
    439224,                            -- observation_concept_id (Allergy to drug)
    '2024-03-15',                      -- observation_date
    '2024-03-15T00:00:00',            -- observation_datetime
    32817,                             -- observation_type_concept_id (EHR)
    1728416,                           -- value_as_concept_id (Penicillin G)
    '294930007',                       -- observation_source_value
    4222295,                           -- observation_source_concept_id
    'benzylpenicillin'                 -- value_source_value
);
```

### Field Mapping Details

| OMOP Field | Value | Source | Transformation Notes |
|------------|-------|--------|---------------------|
| observation_concept_id | 439224 | Decomposed from SNOMED 294930007 | Standard concept for "Allergy to drug" |
| value_as_concept_id | 1728416 | Decomposed from SNOMED 294930007 | Standard concept for "Penicillin G" |
| observation_source_value | 294930007 | FHIR code.coding[0].code | Original composite SNOMED code preserved |
| value_source_value | benzylpenicillin | FHIR code.coding[0].display | Substance component preserved |
| observation_date | 2024-03-15 | FHIR recordedDate | Date of allergy documentation |


The value-as-concept pattern supports analytical capabilities that extend beyond simple direct concept mapping approaches. This Pattern applied to drug allergies demonstrates several strong points in support of FHIR-to-OMOP data transformation. The decomposition step supports alignment with the OMOP CDM and detailed analytics by separating a composite clinical concept into analytically useful atomic components while preserving source semantics. Using the target observation concept (439224 - "Allergy to drug") in a analytics database enables population-level allergy surveillance, while splitting-out the value concept (1728416 - "Penicillin G") supports medication-specific contraindication checking. 

Utilizing an OMOP datastore, this mapping approach enables comprehensive population-level allergy surveillance through queries that identify all drug allergies regardless of the specific causative substance, while simultaneously supporting granular substance-specific contraindication checking that can pinpoint allergies to particular medications or entire drug classes. The Value-as-Concept Pattern facilitates cross-domain analytics by establishing relationships between drug allergies and other clinical observations within the OMOP ecosystem creating opportunities for epidemiological studies. 

Once again, this is an example the effectiveness of vocabulary-driven mapping over resource-type assumptions: with OMOP concept relationships taking precedence in determining the final analytical structure. Employment of source value preservation best practice ensures traceability back to the original FHIR data while enabling future remapping as vocabularies evolve.



## One Source to many OMOP targets




## Multiple Reference Codings
Multiple reference codings occur when a single clinical concept in the source data is represented by multiple codes, either within the same coding system or across different coding systems. This scenario introduces complexity in the mapping process because it requires determining which code (or codes) should be used to represent the concept in the OMOP CDM.

In this case, the process becomes:

1. **Extract Coded Data**: (same as above)
2. **Identify All Source Codes**
3. **Determine Priority**
  *  Standard Over Non-Standard
  *  First Encountered
  *  Clinical Relevance
4. **Mapping to OMOP Concepts**: (follow steps 2-5 above)

### Concerns and Considerations

* **One-to-One Mapping**: Participants emphasized the importance of ensuring that mappings between different coding systems (e.g., ICD-10 to SNOMED) are valid and represent true 1:1 relationships. In cases where such mappings do not exist, the risk of incorrect or ambiguous data translation increases.
* **Challenges with Free Text**: OMOP requires that all data be represented using standardized vocabularies (e.g., SNOMED CT, RxNorm). This means that every piece of data must be associated with a specific code from an accepted terminology.  When FHIR data includes free text (e.g., a description of a condition or observation that isn’t linked to a standard code), it poses a challenge for OMOP, which does not natively support the use of free text in place of standardized codes.
* **Choosing the Right Code from Multiple Codings**: In cases where multiple codes are provided, it can be challenging to determine which code most accurately represents the clinical data. This is particularly difficult when codes have different levels of specificity or when they come from different coding systems.
* **Handling Redundancies in Multiple Codings**: If multiple codes represent the same concept, the system needs to avoid redundancies in the OMOP database. The chosen code should be the one that best aligns with the OMOP model's requirements.
* **Clinical Interpretation in Multiple Codings**: In some cases, the choice of which code to map might depend on clinical context, requiring input from healthcare professionals to ensure accurate representation.

### Example: Mapping a Condition Resource

Let’s walk through a detailed example of mapping a FHIR Condition resource to the OMOP Condition domain.
FHIR Condition Resource

    {
      "resourceType": "Condition",
      "id": "example",
      "code": {
        "coding": [
        {
          "system": "http://snomed.info/sct",
          "code": "44054006",
          "display": "Diabetes mellitus type 2"
        }]
      },
      "subject": {
        "reference": "Patient/example"
      }, 
      "onsetDateTime": "2011-05-24"
    }

#### Steps to Map to OMOP

1. **Extract Coded Data**:
  * FHIR Code: 44054006
  * System: SNOMED CT
2. **Determine the Domain**: Since this is a Condition resource, it maps to the OMOP Condition domain.
3. **Consult OMOP Vocabulary**: Query OMOP vocabulary tables to find the equivalent concept ID.

        SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_code
          FROM concept
          WHERE concept_code = '44054006' AND vocabulary_id = 'SNOMED';
4. **Handle Non-standard Concepts (if necessary)**:  If no direct standard concept is found, use concept_relationship to find the standard mapping.

		SELECT concept_id_2 AS standard_concept_id
		FROM concept_relationship
		WHERE concept_id_1 = <non-standard-concept-id>
		  AND relationship_id = 'Maps to';
5. **Populate OMOP Fields**: Assuming the query returns the following:
  * concept_id = 201826
  * concept_name = 'Type 2 diabetes mellitus'
  * domain_id = 'Condition'
  * vocabulary_id = 'SNOMED

### Example Multiple Codes from Different Systems

A patient’s record includes a diagnosis of "Type 2 Diabetes Mellitus" with both an ICD-10 code (E11.9) and a SNOMED CT code (44054006).

#### Steps to Map to OMOP
1. **Identify Codes**: The ICD-10 code E11.9 and the SNOMED CT code 44054006 both represent "Type 2 Diabetes Mellitus."
2. **Priority**: The SNOMED CT code is preferred as it is typically the standard vocabulary used for conditions in OMOP.
3. **Mapping**: The SNOMED CT code 44054006 is directly mapped to the OMOP concept ID 201826.
4. **Storage in OMOP**:
  * condition_source_value: 44054006 (or both E11.9 and 44054006 depending on implementation).
  * condition_concept_id: 201826
  * condition_source_concept_id: If applicable, the SNOMED CT code concept ID.

### Example Multiple Codes from the Same System

A patient’s record includes two SNOMED CT codes, 44054006 (Type 2 Diabetes Mellitus) and 11687002 (Diabetes Mellitus).

#### Steps to Map to OMOP
1. **Identify Codes**: Both SNOMED CT codes represent diabetes, but 44054006 is more specific.
2. **Priority**: The more specific code 44054006 is chosen.
3. **Mapping**: The SNOMED CT code 44054006 is directly mapped to the OMOP concept ID 201826.
4. **Storage in OMOP**:
  * condition_source_value: 44054006
  * condition_concept_id: 201826
  * condition_source_concept_id: If applicable, the SNOMED CT code concept ID.

### OMOP non-Standard Concept Source Coding
If the FHIR code does not have a direct standard concept in OMOP, locate the non-standard concept_id and its record in the concept table. Then find the Standard concept using the concept_relationship table. A "Non-standard to Standard" map value ( and one other ) from the records with the non-standard concept_id in the relationship table indicate availabilty of an appropriate OMOP Standard target to map to.  

## Alternative Scenarios

### Scenario A: Non-Standard Source Code
If the FHIR condition contained an ICD-10 code instead of SNOMED:

**Step 2 - Consult OMOP Vocabulary:**
```sql
SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_code, standard_concept
FROM concept
WHERE concept_code = 'E11.9' 
  AND vocabulary_id = 'ICD10CM';
```

**Step 4 - Handle Non-standard Concepts:**
```sql
SELECT cr.concept_id_2 AS standard_concept_id,
       c2.concept_name AS standard_concept_name
FROM concept c1
JOIN concept_relationship cr ON c1.concept_id = cr.concept_id_1
JOIN concept c2 ON cr.concept_id_2 = c2.concept_id
WHERE c1.concept_code = 'E11.9'
  AND c1.vocabulary_id = 'ICD10CM'
  AND cr.relationship_id = 'Maps to'
  AND c2.standard_concept = 'S';
```

This would map ICD-10 E11.9 to the same standard concept 201826, but `condition_source_concept_id` would contain the ICD-10 concept ID rather than the standard concept ID.

### Scenario B: Domain Mismatch
If vocabulary lookup reveals the concept belongs to a different domain than expected:

**Step 3 - Domain Determination:**
- FHIR Resource: Observation
- Expected Domain: Observation  
- Vocabulary Domain: Measurement (from concept.domain_id)
- **Action**: Use Measurement domain for OMOP table selection
- **Result**: Populate measurement table instead of observation table

## Implementation Considerations

### Data Extraction
- **Element Identification**: Systematically identify all coded elements in FHIR resources
- **Coding Validation**: Verify coding system URIs and code formats
- **Multi-code Handling**: Establish precedence rules for multiple codings
- **Text Preservation**: Maintain original display text for audit purposes

### Vocabulary Management
- **Version Consistency**: Ensure OMOP vocabulary version compatibility
- **Cache Strategy**: Implement efficient vocabulary lookup caching
- **Update Procedures**: Establish vocabulary refresh and validation processes
- **Coverage Assessment**: Monitor mapping success rates by vocabulary

### Domain Assignment
- **Resource Type Mapping**: Document FHIR resource to OMOP domain mappings
- **Vocabulary Override**: Handle cases where vocabulary domain differs from resource type
- **Multi-domain Concepts**: Address concepts that span multiple domains
- **Custom Domains**: Manage institution-specific domain assignments

### Quality Assurance
- **Mapping Validation**: Verify concept mappings preserve clinical meaning
- **Data Completeness**: Ensure all required OMOP fields are populated
- **Audit Trails**: Maintain transformation decision logs
- **Error Handling**: Implement robust fallback mechanisms for mapping failures

### Historical code and code system transformations
