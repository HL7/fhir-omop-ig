# FHIR to OMOP Coded Data Transformation Patterns
Transforming FHIR coded source data to OMOP follows established transformation patterns where similar data sources are processed through a common series of steps to populate an OMOP target database. This standardized approach ensures consistent handling of coded clinical information across diverse healthcare datasets.

## Understanding Coded Source Data
Coded source data in FHIR refers to information represented using standardized code systems such as SNOMED CT, LOINC, RxNorm, and other established terminologies. (See Using Codes in Resources for more information.) When mapping these FHIR elements to OMOP, implementers must ensure that codes are appropriately translated into the OHDSI Standardized Vocabularies and that the resulting data aligns with the correct domain classifications within the OMOP model.

## Mapping Complexity and Validation
Ensuring valid mappings from different source coding systems requires careful attention to the nature of the relationships between source and target concepts. While some mappings represent true one-to-one relationships that can be transformed directly, many cases involve one-to-many relationships between a coded source and multiple OMOP target concepts. These target concepts may reside within a single domain or span multiple domains within the OMOP structure. (See Standard concepts & Domain discussion for detailed information.)

The absence of established mappings in the OHDSI Standardized Vocabularies significantly increases the risk of incorrect or ambiguous data translation. Such gaps require careful evaluation and potentially custom mapping development to maintain data integrity during the transformation process.

## Automated Mapping Support
Leveraging a terminology server can facilitate automated mapping processes, particularly for free text or non-standard codes, while producing consistent mapping results across transformation instances. This approach reduces manual intervention and improves the reliability of code translation activities.

The OHDSI Athena website provides a comprehensive searchable database that serves dual purposes for mapping activities. Implementers can use this resource to manually browse available vocabularies and identify codes that appropriately match source concepts to Standard OMOP concepts. This capability proves essential for validating automated mappings and resolving complex terminology translation challenges that arise during FHIR to OMOP transformation projects.

### Key Elements of FHIR Coded Data

* **Code**: The actual code from a standardized code system.
* **System**: The code system from which the code is drawn (e.g., SNOMED CT, LOINC).
* **Display**: A human-readable version of the code (optional).
* **Version**: The version of the code system (optional).

### Mapping Process
{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR to OMOP Coded Data Mapping Process</b></figcaption>
<img src="fhir_omop_mapping_flow (4).svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Coded Data Mapping Process"/>
</figure>
{::options parse_block_html="true" /}

1. **Extract Coded Data**:  Identify the coded elements within the FHIR resource. These elements are often of the type CodeableConcept or Coding.
2. **Determine the Domain**:  Use the FHIR code to determine the appropriate OMOP domain (e.g., Condition, Drug, Observation). This is usually based on the type of FHIR resource (e.g., Condition resource maps to OMOP Condition domain).
3. **Consult OMOP Vocabulary**:  Use the OMOP vocabulary tables to find the equivalent OMOP concept ID for the FHIR code. This involves looking up the code in the concept table within OMOP to find a matching standard concept.
4. **Handle Non-standard Concepts**:  If the FHIR code does not have a direct standard concept in OMOP, map it to a non-standard concept and then find the standard equivalent using the concept_relationship table.
5. **Populate OMOP Fields**:  Fill in the relevant fields in the OMOP table, including concept_id, source_value, and other relevant attributes.

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
