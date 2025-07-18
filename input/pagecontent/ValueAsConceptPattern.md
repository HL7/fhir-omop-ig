### Value-as-Concept Map Pattern
Drug allergies represent a complex transformation challenge in FHIR-to-OMOP mapping due to their composite nature. In FHIR, an AllergyIntolerance resource typically contains a coded element representing both the allergy type and the specific substance.  This is not aligned with OMOP's preference for decomposed, granular concept representation. The Value-as-Comcept Map pattern addresses the tension between FHIR's composite coding approach and OMOP's value-as-concept methodology, which separates the observation type (allergy classification) from the specific substance causing the reaction.

#### Value as Concept Pattern Example: Drug Allergy
{::options parse_block_html="false" /}
<figure>
<figcaption><b>FHIR to OMOP Value as Concept Map Pattern</b></figcaption>
<img src="value_as_concept_pattern.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Value as Concept Map Pattern"/>
</figure>
{::options parse_block_html="true" /}

##### 1: FHIR AllergyIntolerance Input
FHIR AllergyIntolerance resources contain coded elements in the `code` field that often represent composite concepts combining both the allergy type and the specific substance. For drug allergies, this typically appears as structured codes like "Allergy to benzylpenicillin" (SNOMED CT: 294930007), which contains both the allergic reaction classification and the specific pharmaceutical substance. This pattern assumes the presence of structured codes that can be semantically decomposed.  We are deliberately excluding free-text-only allergy descriptions in this example, as these pose an array of differnt mapping challenges.

##### 2: Decompose for Mapping Analysis
The system analyzes the composite concept to determine whether it can be meaningfully separated into constituent parts: an observation concept representing the allergy type and a value concept representing the specific substance. This decomposition process examines the semantic structure of codes like "Allergy to [substance]" to identify patterns suitable for value-as-concept transformation. The analysis considers whether both components (allergy type and substance) have equivalent representations in OMOP standard vocabularies, ensuring that the clinical meaning remains intact through the transformation process.

**Decision Point: Decomposition Available as OMOP Standard Concepts?**
If the composite concept can be successfully decomposed into standard OMOP concepts for both the observation type and the substance value, the system proceeds with the value-as-concept approach. If decomposition is not possible or would result in loss of clinical meaning, the system routes to manual mapping alternatives.

##### 3a: Apply Value as Concept
When decomposition is successful, the system or ETL script applies the value-as-concept pattern by mapping the allergy type to `observation_concept_id` and the specific substance to `value_as_concept_id`. For example, "Allergy to benzylpenicillin" decomposes to:
- **observation_concept_id**: 439224 ("Allergy to drug")
- **value_as_concept_id**: 1728416 ("Penicillin G")

This approach maintains the semantic relationship while enabling both general allergy queries and substance-specific analytics within the OMOP framework.

##### 3b: Manual Mapping
When automatic decomposition fails or results in unmappable components, manual decomposition and mapping may be required to preserve clinical meaning while adhering to OMOP principles. This may involve identifying alternative standard concepts that capture the essential clinical information or creating source concept mappings that maintain traceability to the original FHIR data.

##### 4: OMOP Vocabulary Lookup
The decomposed concepts undergo validation against OHDSI Standardized Vocabularies to confirm that both the observation concept and value concept exist as Standard OMOP concepts. This critical validation step ensures that the mapped concepts upoholds the OMOP conventions for Standard concept alignment withtin each Domian (** See disccusion of OMOP Standard Concpets here**) and will integrate properly with OMOP-based analytics tools. The lookup process verifies concept status, domain assignment, and relationship mappings.

**Decision Point: All Concepts Found in OMOP?**
If both the observation concept and value concept are confirmed as standard OMOP concepts, the system proceeds to populate the appropriate OMOP domain table(s). If either concept is missing or non-standard, the system should identify vocabulary gaps and consider alternative mapping strategies.

##### 5a: Populate Appropriate OMOP Domain
When all concepts are successfully validated, the system populates the OMOP Observation domain using the value-as-concept pattern:
- **concept_id**: 439224 (Allergy to drug) - assigned to Observation Domain
- **value_as_concept_id**: 1728416 (Penicillin G)

##### 5b: Identify Vocabulary Gap
If mapping to OMOP Standard concepts mappings is not possible, the system should document missing concepts and consider local extensions for missing source concepts. This process maintains data completeness while clearly indicating limitations for OMOP-based analytics. The system then should preserve the original source values and creates mappings to concept_id=0, following OMOP best practices for handling unmapped data.

##### 6: Optional: Handle Reactions
For comprehensive allergy documentation, the system can create linked observations for allergic reactions using `observation_event_id` to maintain the relationship between the allergen and the specific reaction manifestations. This optional step enables detailed reaction tracking while preserving the primary allergy-substance relationship established through the value-as-concept pattern.

##### 7: Map Quality Validation
The transformation process includes verification that clinical meaning is preserved and value concept alignment maintains semantic accuracy. This validation ensures that the decomposed representation accurately reflects the original clinical intent while conforming to OMOP analytical requirements.

### Example Mapping: Allergy to Benzylpenicillin

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

#### Step-by-Step Value as Concept Transformation

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

#### Field Mapping Details

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
