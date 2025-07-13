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

### Mapping Process Patterns
As stated previously, mapping coded data from FHIR to OMOP requires evaluation of the concepts to be stored in tables on OMOP, and these transformations follow distinct patterns.  In this IG, we propose transformation patterns and guidance regarding: 

* A base pattern that covers most simple code to concept transformation
* A pattern applicable to many Codeable Concepts
* Value-as-concept map patterns 
* One source to many OMOP target domains 
* Multiple source reference evaluations
* OMOP non-Standard concept source coding
* Historical code and code system transformations

### Base Mapping Pattern

{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR to OMOP Coded Data Base Mapping Pattern</b></figcaption>
<img src="input/images/fhir_omop_base_pattern.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Coded Data Base Mapping Pattern"/>
</figure>
{::options parse_block_html="true" /}

1. **Extract Coded Data**:  Identify the coded elements within the FHIR resource. These elements are often of the type CodeableConcept or Coding.
2.  **Consult OMOP Vocabulary**:  Use the OMOP vocabulary tables to find the equivalent OMOP concept ID for the FHIR code. This involves looking up the code in the concept table within OMOP to find a matching standard concept.
3.  **Determine the Domain**:  Use the FHIR code to determine the appropriate OMOP domain (e.g., Condition, Drug, Observation). This could be based on the type of FHIR resource (e.g., Condition resource maps to OMOP Condition domain) or the OMOP Vocabulry may indicate the equivalent concept as modeled in the OHDSI Stanbdardize Vocabularies "lives" in a differt domain than the FHIR resource or profile it is sourced from.
4. **Handle Non-standard Concepts** see "OMOP non-Standard Concept Source Coding" section below
5. **Populate OMOP Fields**:  Fill in the relevant fields in the OMOP table, including concept_id, source_value, and other relevant attributes.

### Codeable Concept Pattern
Codeable concepts are one of the coded datatypes represented in FHIR resources. In FHIR, a CodeableConcept is "A type that represents a concept by plain text and/or one or more coding elements"  The transformation of FHIR CodeableConcept elements to OMOP format create a challenge to uniform transformation practices, but also represents a critical bridge between the flexible, interoperable world of FHIR and the structured, analytics-focused environment of the OMOP Common Data Model. This Pattern aims to partially address the tension between FHIR's allowance for both structured codes and free text versus OMOP's strict requirement for standardized vocabularies, but does not explicitly address transformation of purely free-text expressions allowed in CodeableConcepts.

## FHIR CodeableConcept to OMOP Pattern

{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR CodeableConcept to OMOP Pattern</b></figcaption>
<img src="input/images/codeable_concept_decision_tree.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR CodeableConcept to OMOP Pattern"/>
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

## Key Challenges and Considerations
This transformation pattern deliberately excludes free text handling, recognizing the significant challenges it poses to OMOP's structured requirements. While FHIR's flexibility allows for free text descriptions when structured codes are unavailable, OMOP's analytics-focused design requires standardized vocabularies. The decision to scope out free text in a project may be a pragmatic approach that prioritizes data quality and consistency over comprehensive coverage.  For implementations encountering and wishing to include free text, additional processing through utilization of terminology servers or natural language processing tools may be necessary to convert textual descriptions into standardized codes before applying this transformation pattern.


### Value-as-concept map patterns
accommodating concepts split into more than one field in the OMOP target and source name / value pairs

### One Source to many OMOP targets




### Multiple Reference Codings
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

### Historical code and code system transformations
