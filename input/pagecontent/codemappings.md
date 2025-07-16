# FHIR to OMOP Coded Data Transformations
Unlike purely schema-to-schema transformations, transforming FHIR to OMOP requires evaluation of the concepts coded in the source data to determine and assign appropriate representation in a target OMOP database. This means that FHIR resources contained in profiles such as "IPA-Condition" or "IPA-Observation" may or may not generate records on a target OMOP domain table bearing the same or similar names, such as "condition_occurrence" and "observation."  Rather, the concepts represented in the FHIR resource determine the appropriate transformation targets, and each must be evaluated on a case-by-case basis. FHIR coded source data transformation to OMOP often do follow patterns where similar data sources are processed through a common series of steps to populate an OMOP target database. This standardized approach lowers the decision burden for ETL developers and ensures consistent handling of coded clinical information across diverse healthcare datasets.  

## Understanding Coded Source Data
Coded source data in FHIR refers to information represented using standardized code systems such as SNOMED CT, LOINC, RxNorm, and other established terminologies. (**add link See Using Codes in Resources for more information.**) When mapping these FHIR elements to OMOP, implementers must ensure that codes are appropriately translated into the OHDSI Standardized Vocabularies and that the resulting data aligns with the correct domain classifications within the OMOP model.

## Mapping Complexity and Validation
Ensuring valid mappings from different source coding systems requires careful attention to the nature of the relationships between source and target concepts. While some mappings represent true one-to-one relationships that can be transformed directly, many cases involve one-to-many relationships between a coded source and multiple OMOP target concepts. These target concepts may reside within a single domain or span multiple domains within the OMOP structure. (**add link See Standard concepts & Domain discussion for detailed information.**)

The absence of established mappings in the OHDSI Standardized Vocabularies significantly increases the risk of incorrect or ambiguous data translation. Such gaps require careful evaluation and potentially custom mapping and / or concept target development to maintain data integrity during the transformation process.

## Automated and Manual Concept Mapping Support
Leveraging a FHIR terminology server (e.g.: https://echidna.fhir.org) can facilitate automated mapping processes, particularly for free text or non-standard codes, while producing consistent mapping results across transformation instances. This approach reduces manual intervention (and cost) while improving the reliability of code translation activities.

The  [OHDSI Athena](https://athena.ohdsi.org/) website  provides both access to request OHDSI Vocabulary downloads and a comprehensive searchable database that serves dual purposes for mapping activities. Implementers can use this resource to manually browse available vocabularies and identify codes that appropriately match source concepts to Standard OMOP concepts and also receive vocabulary updates when new versions of the OHDSI Stabdardized Vocabularies are published.  Utilization of the OHDSI Standardized Vocabularies, whether via a FHIR API, downloads utilized in local systems or via manual interation with the Athena search UI is essential for validating mappings and resolving complex terminology translation challenges that arise during FHIR to OMOP transformation projects.

### Key Elements of FHIR Coded Data
Coded data in FHIR resources minimally employ a pattern specifying a code and the coding system the code is derived from, and optional display and version attributes (see:   [Using Codes in Resources](https://www.hl7.org/fhir/terminologies.html#4.1)) 

* **Code**: The actual code from a standardized code system.
* **System**: The code system from which the code is drawn (e.g., SNOMED CT, LOINC).
* **Display**: A human-readable version of the code (optional).
* **Version**: The version of the code system (optional).

The code and system elements required in FHIR are also key search parameters when identifiying target concepts in the OHDSI Standardized Vocabularies. A FHIR Code System is represented in the OMOP CDM vocabulary table as a unique identifer (vocabulary_id) with an acompanying human-readable name (vocabulary_name).  A Code or Coding in FHIR is represented in the OMOP CDM concept table as a 'concept_code', which is linked to the vocabulary table via a vocabulary_id foreign key.  

## Core Transformation Components

### Code Prioritization Framework

When multiple codes are present for a single clinical concept, implementers must apply a systematic prioritization hierarchy across all transformation patterns to ensure consistency and clinical validity. This framework addresses the complex reality of multiple coding scenarios by establishing clear precedence rules that eliminate ambiguity in code selection while ensuring reproducible transformation outcomes.

The hierarchy begins with foundational source vocabularies utilized by OMOP, where SNOMED CT takes priority for conditions, procedures, and clinical observations due to its comprehensive coverage and OMOP's primary reliance on SNOMED concepts. RxNorm receives precedence for medications, drug products, and pharmaceutical concepts as the standard drug vocabulary in OMOP, while LOINC takes priority for laboratory tests, measurements, and clinical observations, particularly lab results and vital signs. ICD-10 and ICD-9 codes should only be used when no standard vocabulary equivalent exists, as these are largely considered to be "classification" (& non-standard) concepts in OMOP but may have mappings to OMOP Standard concepts represented in the relationship tables. CPT and HCPCS codes may be acceptable for procedures when SNOMED equivalents are not available, although these require mapping to Standard target concepts. Local or proprietary codes receive the lowest priority and should only be used when no standard vocabulary alternative exists.

{::options parse_block_html="false" /}
<figure>
<figcaption><b>Code Prioritization Framework</b></figcaption>
<img src="../images/code_prioritization_framework_restored.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="Code Prioritization Framework"/>
</figure>
{::options parse_block_html="true" /}

Within the framework of foundational vocabulary selection, clinical specificity serves as the secondary criterion, with codes providing the highest level of clinical detail taking precedence over more general classifications. This includes choosing codes that provide clinical granularity, anatomical precision that specifies exact locations when available, temporal specificity that includes timing information when relevant, severity indicators when clinically appropriate, and laterality specifications for anatomically relevant concepts. The system should consistently avoid parent concepts when more specific child concepts are available in the coding array.

The mapping process further considers explicit primary designations within the FHIR resource structure, where codes marked with primary indicators receive preference during selection. This includes honoring explicit "primary" or "preferred" designations in the FHIR coding array, respecting FHIR use codes such as "usual," "official," or "preferred" when present, considering organizational or system-level preferences for specific vocabularies when documented, factoring in clinical context where primary designation may indicate diagnostic certainty or treatment focus, and following institutional coding guidelines that may designate preferred vocabularies for specific clinical domains.

When all other factors remain equal, temporal precedence applies, selecting the first code encountered in the sequence. This first encountered rule provides consistent tie-breaking when multiple equally valid codes exist, maintains the original order of codes as provided by the source system, requires documentation when temporal precedence was the deciding factor for transparency and quality assurance, and ensures predictable behavior across all transformation instances.

### Standard OMOP Vocabulary API Lookup Methodology

All transformation patterns utilize a consistent API lookup approach that forms the foundation for automated vocabulary validation and concept identification. The lookup process involves querying a FHIR terminology server hosting the OHDSI Stanbdardized Vocabularies, such as [Echidna](https://echidna.fhir.org) to identify matching concepts based on the source code and vocabulary system, followed by comprehensive analysis of the returned results.

1. Translate source code to concept ID: Utilise the [ConceptMap/$translate](TerminologyServer.md#conceptmap--translate) FHIR terminology server operation.
2. Lookup concept properties: Utilise the [CodeSystem/$lookup](TerminologyServer.md#codesystem--lookup) FHIR terminology server operation.
3. [If the concept is non-standard] Lookup the "Maps to" concept ID using the $lookup operation.

The lookup analysis encompasses several critical components that ensure proper concept identification and validation. Implementers must verify OMOP concept existence to confirm that the source code has a corresponding representation in the OHDSI Standardized Vocabularies. The Standard concept status requires confirmation through the presence of the 'S' flag, indicating that the concept can be used directly in OMOP analytics without requiring additional concept relationship mapping. Vocabulary alignment validation ensures that the identified concept originates from the expected terminology system and maintains semantic consistency with the source data. Domain assignment determination identifies the appropriate OMOP domain table for storing the clinical information, which may differ from expectations based solely on FHIR resource type.

This systematic lookup methodology via an API provides a foundation for all subsequent mapping decisions and ensures consistent handling of vocabulary validation across different transformation patterns. The approach supports both automated processing and manual validation workflows, enabling implementers to maintain high data quality standards while achieving efficient transformation throughput.

### Domain Assignment Logic

Domain assignment follows a vocabulary-driven approach that prioritizes semantic accuracy over any structural assumptions a developer may make based on FHIR resource types. This methodology recognizes that OMOP's domain organization may differ from FHIR's resource categorization, requiring careful attention to vocabulary-based OMOP target domain assignments to ensure proper data normalization supporting analytics.

The primary consideration in domain assignment involves using the domain_id from the OMOP concept table as the authoritative domain assignment source. This vocabulary-driven approach ensures that clinical concepts are stored in domains that align with their semantic meaning within the OMOP ecosystem, rather than being forced into domains based solely on their originating source vocabulary or FHIR resource type. 

FHIR resource type considerations serve as secondary guidance when vocabulary domain assessments are ambiguous or when multiple valid domain options exist for a particular concept. This secondary role ensures that transformation logic can fall back to resource type expectations while maintaining the priority of vocabulary-driven domain assignment. Clinical context application becomes necessary when domain assignments conflict with expected clinical meaning, requiring implementer judgment to resolve semantic inconsistencies that may arise from vocabulary evolution or mapping edge cases.

Domain assignment logic ensures that transformed data maintains accurate semantic consistency within the OMOP CDM while accomodating the structural differences between FHIR's resource-based organization and OMOP's domain-based analytical model. This supports both automated transformation workflows and manual review processes for complex or ambiguous domain assignment scenarios.

## Historical Code and Code System Transformations

Healthcare data transformation frequently encounters historical coding systems that are no longer actively maintained or updated. These legacy codes present unique challenges during OMOP CDM implementation due to their deprecated status and complex mapping requirements. ICD-9 codes represent the most prominent example, having been largely replaced by ICD-10 in clinical settings. These codes commonly appear in legacy electronic health records, retrospective datasets, and clinical documentation predating modern coding system adoption.

The management of historical codes introduces several complexities that require careful consideration during OMOP transformation. Maintenance limitations present the primary obstacle, as historical coding systems no longer receive updates or support from their originating organizations. This abandonment often results in their exclusion from current OMOP Standardized Vocabularies, creating gaps in direct mapping capabilities. Crosswalk complexity further complicates the transformation process, as historical-to-modern code relationships rarely follow simple one-to-one patterns. Many historical codes require mapping to multiple modern equivalents, while others may lack direct contemporary representations. This variability requires mapping strategies that preserve clinical meaning while accommodating structural differences between coding systems. Data integrity concerns arise when historical codes cannot be adequately mapped, potentially resulting in clinical information loss or the introduction of mapping-related inaccuracies. The diminishing availability of historical code support resources compounds these challenges, as fewer tools and expert resources remain dedicated to legacy system maintenance.

### Considerations for Legacy Vocabulary Versions

The historical code management process begins with comprehensive identification of legacy codes within source datasets. Following identification, implementers must determine the optimal mapping strategy based on available resources and clinical requirements. ICD-9-CM, ICD-9-Proc, and ICD-9-ProcCN remain listed as source vocabularies for the OHDSI Standardized Vocabularies, but as of (***need a date here ***) are no longer being updated in the OHDSI Vocabularies. When OHDSI-generated reference content is not available, authoritative crosswalk utilization represents the preferred approach, leveraging mapping tables provided by organizations such as the Centers for Medicare & Medicaid Services or the National Library of Medicine. Optimally these crosswalks facilitate translation from historical codes to modern equivalents, including ICD-10 or SNOMED CT classifications that can then be levereaged to identify approrpoate Standard OMOP concpets. When crosswalks prove insufficient or unavailable, direct, manual mapping strategies may apply if historical codes remain present than codes represented in current OMOP vocabulary versions. 

### Historical Code Implementation Example

Consider a patient record from 2005 containing a COPD diagnosis with historical ICD-9 coding. The original FHIR resource structure demonstrates the challenge of managing legacy codes within modern healthcare data standards:

```json
{
  "resourceType": "Condition",
  "id": "historical-copd-example",
  "subject": {
    "reference": "Patient/patient-2005"
  },
  "code": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/sid/icd-9-cm",
        "code": "496",
        "display": "Chronic airway obstruction, not elsewhere classified"
      }
    ]
  },
  "recordedDate": "2005-03-15"
}
```

The transformation process begins with historical code identification, recognizing 496 as an ICD-9 classification requiring mapping to contemporary standards. Crosswalk consultation reveals multiple modern equivalents that result in an enhanced FHIR structure incorporating both historical and contemporary codes:

```json
{
  "resourceType": "Condition",
  "id": "mapped-copd-example",
  "subject": {
    "reference": "Patient/patient-2005"
  },
  "code": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/sid/icd-9-cm",
        "code": "496",
        "display": "Chronic airway obstruction, not elsewhere classified"
      },
      {
        "system": "http://hl7.org/fhir/sid/icd-10-cm",
        "code": "J44.9",
        "display": "Chronic obstructive pulmonary disease, unspecified"
      },
      {
        "system": "http://snomed.info/sct",
        "code": "13645005",
        "display": "Chronic obstructive lung disease"
      }
    ]
  },
  "recordedDate": "2005-03-15"
}
```

The preferred SNOMED CT mapping leads to OMOP concept ID 255573, establishing the final transformation target. Storage implementation places the original ICD-9 code 496 in the condition_source_value field, while condition_concept_id receives the OMOP concept ID 255573. The condition_source_concept_id field remains null if no historical ICD-9 concept exists in OMOP vocabularies, with complete mapping documentation preserved in associated metadata structures.

Organizations utilizing data coded in historical coding systems should establish governance frameworks that include clinical terminology specialists and domain experts in historical code mapping decisions. Fallback strategies must address scenarios where historical codes cannot be mapped to modern equivalents, potentially utilizing generalized concepts when specific mappings are unavailable while clearly documenting these compromises. Regular review of available crosswalk resources, mapping tools and utilization of terminology servers ensures that transformation processes benefit from the most current and authoritative mapping information. Organizations should maintain flexibility in their mapping approaches, allowing for updates when improved crosswalks or mapping methodologies become available.

## Source Value Preservation: A Best Practice

Consistently preserving source values is a critical component of FHIR to OMOP transformation, ensuring data lineage, maintenance of incremental data stores, supports future remapping efforts, and enabling quality assurance validation procedures. This strategy accomodates vocabulary evolution and improved mapping algorithms which may require reprocessing of source data, making original value retention essential for long-term data management. 

Source value fields must always preserve original codes exactly as provided in FHIR resources, maintaining character-for-character accuracy to ensure complete traceability back to the source system. This includes maintaining any formatting, spacing, or special characters present in the original codes, as these may carry semantic meaning or system-specific significance that could be relevant for future processing or validation efforts. Source identifier fields require population with OMOP concept_id values when source codes exist within the OHDSI Standardized Vocabularies, while unmapped codes are populated with a 0 to indicate their non-Standard OMOP concept status. The use of "0" for unmapped codes follows OMOP conventions and enables analytical queries to distinguish between successfully mapped and unmapped source data. This approach provides clear indication of OMOP CDM mapping conformance for each map implemented while maintaining the a record source codes and their OMOP representations when available. 

Future-proofing an OMOP datastore includes designing storage and documentation strategies that accommodate vocabulary evolution, improved mapping methodologies, and changing clinical terminology standards. A corollary best practice to source data preservation is completion of transformation lineage documentation, including mapping decisions, prioritization choices, and any manual interventions performed during the transformation process. These steps enable future data validation efforts, supports quality improvement initiatives, and provides the foundation for remapping activities when vocabulary updates or improved algorithms become available. 
