# Multiple FHIR Reference Codings to OMOP 
The transformation of FHIR resources to the OMOP CDM frequently presents scenarios where a single clinical concept on OMOP contains multiple codes within the FHIR resource structure.  This scenario introduces complexity in the mapping process because it requires determining which code (or codes) should be used to represent the concept in the OMOP CDM. The mapping workflow begins with comprehensive identification of all coding elements within the FHIR resource, specifically extracting codes from the CodeableConcept.coding array structure. Each code requires documentation of its associated coding system through the system URI, along with any explicit ranking or preference indicators present in the source data.

To ensure consistency and clinical validity implementers must apply selection logic identical to guidance provided for for CodeableConcepts. The hierarchy begins with standard vocabularies, where SNOMED CT, LOINC, and other OMOP-recognized terminologies take precedence over proprietary or legacy coding systems. Within this framework, clinical specificity serves as the secondary criterion, with more detailed diagnostic or procedural codes preferred over general classifications. The mapping process further considers explicit primary designations within the FHIR resource structure, where codes marked with primary indicators receive preference during selection. When all other factors remain equal, temporal precedence applies, selecting the first code encountered in the sequence. This systematic approach ensures reproducible results while maintaining the clinical intent of the original data.

Once the primary code is selected, the system should performs concept mapping to identify the corresponding Stndard OMOP concept_id. When direct mapping is unavailable, the system should map to the closest parent concept while maintaining detailed documentation of all mapping decisions for audit and quality assurance purposes.

Consider the following scenario where FHIR data contains multiple coding systems representing the same clinical concept. When encountering a diagnosis with both ICD-10 and SNOMED CT codes in the coding array, the selection process prioritizes the SNOMED CT code as the preferred standard vocabulary:

```json
{
  "code": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/sid/icd-10-cm",
        "code": "E11.9",
        "display": "Type 2 diabetes mellitus without complications"
      },
      {
        "system": "http://snomed.info/sct",
        "code": "44054006",
        "display": "Type 2 diabetes mellitus"
      }
    ]
  }
}
```

In this case, the system selects SNOMED CT code 44054006 for mapping to OMOP concept ID 201826, ensuring consistency with OMOP CDM preferences while maintaining the clinical accuracy of the original diagnosis.

Another frequent situation involves multiple codes from the same coding system with varying specificity levels. When FHIR data includes both specific and general diagnostic codes, the system selects the more specific code to preserve detailed clinical information:

```json
{
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "44054006",
        "display": "Type 2 diabetes mellitus"
      },
      {
        "system": "http://snomed.info/sct",
        "code": "11687002",
        "display": "Diabetes mellitus"
      }
    ]
  }
}
```

This selection preserves the detailed clinical information while avoiding the loss of diagnostic precision during the mapping process, with the more specific code 44054006 taking precedence over the general term.

The implementation also addresses scenarios where FHIR resources explicitly designate primary codes through metadata indicators. When the coding array contains multiple codes with one marked as primary, the selection process honors this designation:

```json
{
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "44054006",
        "display": "Type 2 diabetes mellitus",
        "primary": true
      },
      {
        "system": "http://snomed.info/sct",
        "code": "11687002",
        "display": "Diabetes mellitus"
      }
    ]
  }
}
```

This approach respects the clinical decision-making embedded in the source system while maintaining consistency with OMOP requirements, regardless of other prioritization factors.
