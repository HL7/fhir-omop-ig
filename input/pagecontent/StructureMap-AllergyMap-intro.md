# AllergyIntolerance Resource Considerations
Mapping FHIR Allergy and Intolerance resources to OMOP present unique challenges that require consideration of data granularity, standardization, and preservation of clinical relationships.
**Note:** The AllergyIntolerance resource serves as a use case example in the [CodeableConcept](https://build.fhir.org/ig/HL7/fhir-omop-ig/CodeableConceptPattern.html) and [Value as Concept](https://build.fhir.org/ig/HL7/fhir-omop-ig/ValueAsConceptPattern.html) mapping patterns. The principles and patterns are described there in more detail.

## Allergy Mapping Examples
### No Known Allergies: CodeableConcept Pattern
The simplest mapping scenario involves patients with no known allergies. In this case:

- **FHIR Representation**: The AllergyIntolerance resource contains a standardized SNOMED CT code indicating "No Known Allergies"
- **OMOP Mapping**: This code maps directly to a corresponding standard concept in the OMOP vocabulary following the basic CodeableConcept pattern
- **Implementation**: Use standard vocabulary mapping tables to identify the appropriate OMOP concept_id for the "No Known Allergies" status

### Allergy to Specific Substances: Value as Concept Pattern
When patients have documented allergies to specific substances, the mapping complexity increases significantly. Consider the example of "Allergy to Penicillin G":

- **Challenge**: The allergy encompasses both the general concept of drug allergy and the specific substance involved
- **Solution**: Utilize the OMOP "value as concept" pattern to capture both dimensions of the information

The "value as concept" mapping pattern to OMOP addresses scenarios where an observation has both a general category and a specific value that must be captured separately. This pattern is employed for allergy mappings, involving two key fields:

1. **Observation Concept ID**: Represents the type of observation (e.g., "Allergy to Drug")
2. **Value as Concept ID**: Represents the specific substance or agent (e.g., "Penicillin G")

## Mapping Allergic Reactions

When allergy data FHIR resouces includes specific reactions (e.g., rash, anaphylaxis), two records should be created: 

**1: Primary Allergy Record**
- `observation_concept_id`: "Allergy to Drug"
- `value_as_concept_id`: Specific allergen (e.g., "Penicillin G")

**2: Reaction Record**
- `observation_concept_id`: "Allergic Reaction to Drug"
- `value_as_concept_id`: Specific reaction (e.g., "Rash")

### Linking Related Observations
To maintain the clinical relationship between allergies and their reactions:

1. **Use observation_event_id**: Set the `observation_event_id` in the reaction record to reference the `observation_id` of the primary allergy record
2. **Alternative Linking**: For tables without event linking fields, utilize the OMOP `fact_relationship` table to establish connections between related clinical facts
