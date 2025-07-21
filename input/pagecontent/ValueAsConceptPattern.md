Certain clinical concepts such as Drug allergies, represent a complex transformation challenge in FHIR-to-OMOP mapping due to their composite nature. It demonstrates the effectiveness of vocabulary-driven mapping over resource-type assumptions: with OMOP concept relationships taking precedence in determining the final analytical structure. In FHIR, an AllergyIntolerance resource typically contains a coded element representing both the allergy type and the specific substance.  This is not aligned with OMOP's preference for decomposed, granular concept representation. The Value-as-Concept Map pattern addresses the tension between FHIR's composite coding approach and OMOP's value-as-concept methodology, which separates the observation type (allergy classification) from the specific substance causing the reaction.

Utilizing an OMOP datastore, this mapping pattern enables comprehensive population-level allergy surveillance through queries that identify all drug allergies regardless of the specific causative substance, while simultaneously supporting granular substance-specific contraindication checking that can pinpoint allergies to particular medications or entire drug classes. The Value-as-Concept Pattern facilitates cross-domain analytics by establishing relationships between drug allergies and other clinical observations within the OMOP ecosystem creating opportunities for epidemiological studies.  Employment of source value preservation best practice ensures traceability back to the original FHIR data while enabling future remapping as vocabularies evolve.

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="value_as_concept_pattern.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Value as Concept Map Pattern"/>
</figure>
{::options parse_block_html="true" /}

The transformation process begins with analyzing FHIR AllergyIntolerance resources containing composite concepts that combine allergy classification and specific substance identification. Drug allergies exemplify this through structured codes like "Allergy to benzylpenicillin" (SNOMED CT: 294930007), which inherently contains both the allergic reaction type and pharmaceutical substance. This approach assumes structured codes amenable to semantic decomposition, deliberately excluding free-text-only descriptions that present distinct mapping challenges.

##### Step 1: Composite Concept Analysis 
The system evaluates whether composite concepts can be meaningfully separated into constituent components: an observation concept representing the allergy classification and a value concept representing the specific substance. This decomposition process examines semantic structures within codes following "Allergy to [substance]" patterns to identify candidates suitable for value-as-concept transformation while preserving clinical meaning.
##### Step 2: Decomposition Feasibility 
Assessment When composite concepts can be successfully decomposed into standard OMOP concepts for both observation type and substance value, the system proceeds with the value-as-concept approach. If decomposition proves impossible or would compromise clinical meaning, the process routes to alternative mapping strategies.
##### Steps 3a & 3b: Target Concept Assignment
Mapping Implementation Successful decomposition enables the system to apply the value-as-concept pattern by mapping allergy classifications to observation_concept_id and specific substances to value_as_concept_id. For example, "Allergy to benzylpenicillin" decomposes to observation_concept_id: 439224 ("Allergy to drug") and value_as_concept_id: 1728416 ("Penicillin G"). When automatic decomposition fails, manual mapping preserves clinical meaning while maintaining traceability to original FHIR data.
##### Step 4: OMOP Vocabulary Validation 
The decomposed concepts undergo validation against OHDSI Standardized Vocabularies to confirm existence as Standard OMOP concepts. This validation ensures mapped concepts uphold OMOP conventions and integrate properly with analytics tools, verifying concept status, domain assignment, and relationship mappings.
##### Step 5: Domain Population and Gap Management 
When concepts are successfully validated, the system populates the OMOP Observation domain using the value-as-concept pattern. If mapping to OMOP Standard concepts is not possible, the system documents missing concepts, preserves original source values, and creates mappings to concept_id=0, following OMOP best practices for unmapped data.
##### Step 6: Optional Enhancement and Validation 
For comprehensive data represntation, the system can create linked observations for allergic reactions using observation_event_id to maintain relationships between allergens and reaction manifestations. The transformation process concludes with verification that clinical meaning is preserved and value concept alignment maintains semantic accuracy, ensuring decomposed representations accurately reflect original clinical intent while conforming to OMOP analytical requirements.

The value-as-concept pattern supports analytical capabilities that extend beyond simple direct concept mapping approaches. This pattern demonstrates several strong points in a FHIR-to-OMOP data transformation. The decomposition step supports alignment with the OMOP CDM and detailed analytics by separating a composite clinical concept into analytically useful atomic components while preserving source semantics. Using the target observation concept (439224 - "Allergy to drug") in a analytics database enables population-level allergy surveillance, while splitting-out the value concept (1728416 - "Penicillin G") supports medication-specific contraindication checking. 

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
      <td style="border: 1px solid #d0d7de;">439224</td>
      <td style="border: 1px solid #d0d7de;">Decomposed from SNOMED 294930007</td>
      <td style="border: 1px solid #d0d7de;">Standard concept for "Allergy to drug"</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>value_as_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">1728416</td>
      <td style="border: 1px solid #d0d7de;">Decomposed from SNOMED 294930007</td>
      <td style="border: 1px solid #d0d7de;">Standard concept for "Penicillin G"</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>observation_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">294930007</td>
      <td style="border: 1px solid #d0d7de;">FHIR code.coding[0].code</td>
      <td style="border: 1px solid #d0d7de;">Original composite SNOMED code preserved</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"><code>value_source_value</code></td>
      <td style="border: 1px solid #d0d7de;">benzylpenicillin</td>
      <td style="border: 1px solid #d0d7de;">FHIR code.coding[0].display</td>
      <td style="border: 1px solid #d0d7de;">Substance component preserved</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"><code>observation_date</code></td>
      <td style="border: 1px solid #d0d7de;">2024-03-15</td>
      <td style="border: 1px solid #d0d7de;">FHIR recordedDate</td>
      <td style="border: 1px solid #d0d7de;">Date of allergy documentation</td>
    </tr>
  </tbody>
</table>


