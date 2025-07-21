Unlike purely schema-to-schema transformations, transforming FHIR to OMOP requires evaluation of the concepts coded in the source data to determine and assign appropriate representation in a target OMOP database. This means that FHIR resources contained in profiles such as "IPA-Condition" or "IPA-Observation" may or may not generate records on a target OMOP domain table bearing the same or similar names, such as "condition_occurrence" and "observation."  Rather, the concepts represented in the FHIR resource determine the appropriate transformation targets, and each must be evaluated on a case-by-case basis. FHIR coded source data transformation to OMOP often do follow patterns where similar data sources are processed through a common series of steps to populate an OMOP target database. This standardized approach lowers the decision burden for ETL developers and ensures consistent handling of coded clinical information across diverse healthcare datasets.  

### Understanding Coded Source Data
Coded source data in FHIR refers to information represented using standardized code systems such as SNOMED CT, LOINC, RxNorm, and other established terminologies. When mapping these FHIR elements to OMOP, implementers must ensure that codes are appropriately translated into the OHDSI Standardized Vocabularies and that the resulting data aligns with the correct domain classifications within the OMOP model.

#### Key Elements of FHIR Coded Data
Coded data in FHIR resources minimally employ a pattern specifying a code and the coding system the code is derived from, and optional display and version attributes (see: [FHIR Terminology, Using Codes in Resources](https://www.hl7.org/fhir/terminologies.html#4.1)) 

* **Code**: The actual code from a standardized code system.
* **System**: The code system from which the code is drawn (e.g., SNOMED CT, LOINC).
* **Display**: A human-readable version of the code (optional).
* **Version**: The version of the code system (optional).

The code and system elements required in FHIR are also key search parameters when identifiying target concepts in the OHDSI Standardized Vocabularies. A FHIR Code System is represented in the OMOP CDM vocabulary table as a unique identifer (vocabulary_id) with an acompanying human-readable name (vocabulary_name).  A Code or Coding in FHIR is represented in the OMOP CDM concept table as a 'concept_code', which is linked to the vocabulary table via a vocabulary_id foreign key.  

#### Mapping Complexity and Validation
Ensuring valid mappings from different source coding systems requires careful attention to the nature of the relationships between source and target concepts. While some mappings represent true one-to-one relationships that can be transformed directly, many cases involve one-to-many relationships between a coded source and multiple OMOP target concepts. These target concepts may reside within a single domain or span multiple domains within the OMOP structure. 

The absence of established mappings in the OHDSI Standardized Vocabularies significantly increases the risk of incorrect or ambiguous data translation. Such gaps require careful evaluation and potentially custom mapping and / or concept target development to maintain data integrity during the transformation process. 

### OMOP Domain Assignment Logic
Domain assignment follows a vocabulary-driven approach that prioritizes semantic accuracy over structural assumptions based on FHIR resource types. This methodology recognizes that OMOP's domain organization may differ from FHIR's resource categorization, requiring careful attention to vocabulary-based domain assignments to ensure proper analytical representation. The primary consideration in domain assignment involves using the domain_id from the OMOP concept table as the domain assignment source. This vocabulary-driven approach ensures that clinical concepts from many source systems are stored in a uniform manner within the OMOP ecosystem.

FHIR resource type considerations serve as secondary guidance when vocabulary domain assignments are ambiguous or when multiple valid domain options exist for a particular concept. This secondary role ensures that transformation logic can fall back to resource type expectations while maintaining the priority of vocabulary-driven domain assignment. Clinical context application becomes necessary when domain assignments conflict with expected clinical meaning, requiring implementer judgment to resolve semantic inconsistencies that may arise from vocabulary evolution or mapping edge cases.

#### Impact of OMOP Standard Concepts & Domains
The OMOP CDM is designed for large‑scale aggregation, whether in centralized repositories or distributed research networks. Its domain structure and Standardized Vocabularies allow data from heterogeneous sources—each with distinct schemas and code systems—to be normalized into a single analytic framework. Every concept is assigned a status of **Standard**, **Non‑Standard**, or **Classification**; only one Standard concept exists for each clinical idea within a domain, eliminating ambiguity and enabling cross‑site comparability. (See: [OMOP Vocabulary Concept Structure](https://ohdsi.github.io/CommonDataModel/dataModelConventions.html#Concepts) for additional details)

Because a single FHIR resource may contains multiple clinical ideas, each coded element must be evaluated independently. A FHIR Observation may yield Measurement, Condition Occurrence, or Procedure Occurrence records in OMOP, depending on the specific codes it carries. Terminologies commonly used in FHIR—such as LOINC, SNOMED CT, and RxNorm—frequently align with OMOP Standard concepts. In cases where no Standard mapping exists, particularly in cases such as HL7‑maintained value sets, or local codes, a extension concepts may be added to the OMOP concept table  with `concept_id` values of 2,000,000,000 (2 billion) or higher may be created. These “2-billionaires” IDs preserve information without loss and can be retired once the community adopts an official Standard concept. Regular vocabulary updates are therefore essential, both for pipelines ingesting new data and for legacy OMOP datastores. (See: [OMOP CDM: Custom Concepts](https://ohdsi.github.io/CommonDataModel/customConcepts.html) for more information) 

### Automated and Manual Concept Mapping Support
Leveraging a FHIR terminology server (e.g.: [Echidna ](https://echidna.fhir.org)) can facilitate automated mapping processes, particularly for free text or non-standard codes, while producing consistent mapping results across transformation instances. This approach reduces manual intervention (and cost) while improving the reliability of code translation activities.

The  [OHDSI Athena](https://athena.ohdsi.org/) website  provides both access to request OHDSI Vocabulary downloads and a comprehensive searchable database that serves dual purposes for mapping activities. Implementers can use this resource to manually browse available vocabularies and identify codes that appropriately match source concepts to Standard OMOP concepts and also receive vocabulary updates when new versions of the OHDSI Stabdardized Vocabularies are published.  Utilization of the OHDSI Standardized Vocabularies is essential for validating mappings and resolving complex terminology translation challenges that arise during FHIR to OMOP transformation.

#### Standard OMOP Vocabulary API Lookup Methodology
All transformation patterns utilize a consistent API lookup approach that forms the foundation for automated vocabulary validation and concept identification. The lookup process involves querying a FHIR terminology server hosting the OHDSI Stanbdardized Vocabularies, such as [Echidna](https://echidna.fhir.org) to identify matching concepts based on the source code and vocabulary system, followed by comprehensive analysis of the returned results.

1. Translate source code to concept ID: Utilise the [ConceptMap/$translate](https://github.com/HL7/fhir-omop-ig/blob/main/input/pagecontent/TerminologyServer.md#conceptmap-translate-operation) FHIR terminology server operation.
2. Lookup concept properties: Utilise the [CodeSystem/$lookup](https://github.com/HL7/fhir-omop-ig/blob/main/input/pagecontent/TerminologyServer.md#codesystem-lookup-operation) FHIR terminology server operation.
3. If the concept is non-standard: Lookup the "Maps to" concept ID using the $lookup operation.

The lookup analysis encompasses several critical components that ensure proper concept identification and validation. Implementers must verify OMOP concept existence to confirm that the source code has a corresponding representation in the OHDSI Standardized Vocabularies. The Standard concept status requires confirmation through the presence of the 'S' flag, indicating that the concept can be used directly in OMOP analytics without requiring additional concept relationship mapping. Vocabulary alignment validation ensures that the identified concept originates from the expected terminology system and maintains semantic consistency with the source data. Domain assignment determination identifies the appropriate OMOP domain table for storing the clinical information, which may differ from expectations based solely on FHIR resource type. (See: [Terminology Server API Utilization](https://build.fhir.org/ig/HL7/fhir-omop-ig/TerminologyServer.html) for detailed examples.) 

This systematic lookup methodology via an API provides a foundation for all subsequent mapping decisions and ensures consistent handling of vocabulary validation across different transformation patterns. The approach supports both automated processing and manual validation workflows, enabling implementers to maintain high data quality standards while achieving efficient transformation throughput.

### Code Prioritization Framework
When multiple codes are present for a single clinical concept, implementers must apply a systematic prioritization hierarchy across all transformation patterns to ensure consistency and clinical validity. This framework addresses the complex reality of multiple coding scenarios by establishing clear precedence rules that eliminate ambiguity in code selection while ensuring reproducible transformation outcomes.

The hierarchy begins with foundational source vocabularies utilized by OMOP, where SNOMED CT takes priority for conditions, procedures, and clinical observations due to its comprehensive coverage and OMOP's primary reliance on SNOMED concepts. RxNorm receives precedence for medications, drug products, and pharmaceutical concepts as the standard drug vocabulary in OMOP, while LOINC takes priority for laboratory tests, measurements, and clinical observations, particularly lab results and vital signs. ICD-10 and ICD-9 codes should only be used when no standard vocabulary equivalent exists, as these are largely considered to be "classification" (& non-standard) concepts in OMOP but may have mappings to OMOP Standard concepts represented in the relationship tables. CPT and HCPCS codes may be acceptable for procedures when SNOMED equivalents are not available, although these require mapping to Standard target concepts. Local or proprietary codes receive the lowest priority and should only be used when no standard vocabulary alternative exists.

{::options parse_block_html="false" /}
<figure>
<figcaption><b>Code Prioritization Framework</b></figcaption>
<img src="code_prioritization_framework.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="Code Prioritization Framework"/>
</figure>
{::options parse_block_html="true" /}

Within the framework of foundational vocabulary selection, clinical specificity serves as the secondary criterion, with codes providing the highest level of clinical detail taking precedence over more general classifications. This includes choosing codes that provide clinical granularity, anatomical precision that specifies exact locations when available, temporal specificity that includes timing information when relevant, severity indicators when clinically appropriate, and laterality specifications for anatomically relevant concepts. The system should consistently avoid parent concepts when more specific child concepts are available in the coding array.

The mapping process further considers explicit primary designations within the FHIR resource structure, where codes marked with primary indicators receive preference during selection. This includes honoring explicit "primary" or "preferred" designations in the FHIR coding array, respecting FHIR use codes such as "usual," "official," or "preferred" when present, considering organizational or system-level preferences for specific vocabularies when documented, factoring in clinical context where primary designation may indicate diagnostic certainty or treatment focus, and following institutional coding guidelines that may designate preferred vocabularies for specific clinical domains.

When all other factors remain equal, temporal precedence applies, selecting the first code encountered in the sequence. This first encountered rule provides consistent tie-breaking when multiple equally valid codes exist, maintains the original order of codes as provided by the source system, requires documentation when temporal precedence was the deciding factor for transparency and quality assurance, and ensures predictable behavior across all transformation instances.

### Type Concepts in the OMOP Common Data Model

**Type Concepts** are specialized concepts in the OMOP CDM that indicate the provenance of clinical data records. Type concepts enable researchers to filter data appropriately for specific analyses, such as excluding prescription orders when studying actual drug consumption. They help researchers understand the quality of FHIR resources transformed to OMOP data and limitations based on source system characteristics, account for potential biases inherent to different data collection methods, and perform source-specific analyses when needed.

Type concepts help distinguish between different origins of the same type of clinical information. For example, a drug exposure record could originate from a pharmacy dispensing claim, an EHR prescription record, a medication administration record, or patient self-reported medication use. When implementing type concepts, it's important to choose the most specific and accurate type concept during ETL mapping while also considering research use cases expectations for the target datastore. 

FHIR resources may contain indicators for the use of OMOP type concept target values in the semantics of a Code or CodeableConcept.  FHIR CodeableConcept elements that would need to be split to populate both a type concept and a standard concept in OMOP are as follows:

#### Example 1: FHIR MedicationRequest

**FHIR CodeableConcept:**
```json
{
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/medicationrequest-category",
          "code": "outpatient",
          "display": "Outpatient"
        }
      ]
    }
  ],
  "medicationCodeableConcept": {
    "coding": [
      {
        "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
        "code": "197696",
        "display": "Acetaminophen 325 MG Oral Tablet"
      }
    ]
  }
}
```

**OMOP Mapping:**
- **drug_type_concept_id**: Maps to "EHR prescription" (because this is a MedicationRequest from an outpatient setting)
- **drug_concept_id**: Maps to the RxNorm concept for Acetaminophen 325 MG Oral Tablet

#### Example 2: FHIR Condition

**FHIR CodeableConcept:**
```json
{
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/condition-category",
          "code": "encounter-diagnosis",
          "display": "Encounter Diagnosis"
        }
      ]
    }
  ],
  "code": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "233604007",
        "display": "Pneumonia"
      }
    ]
  }
}
```

**OMOP Mapping:**
- **condition_type_concept_id**: Maps to "EHR encounter diagnosis" (derived from the category indicating this was diagnosed during an encounter)
- **condition_concept_id**: Maps to the SNOMED-CT concept for Pneumonia

In both examples, the FHIR **category** or **context** information determines the **type concept** (provenance), while the actual clinical **code** determines the **standard concept** (what clinical entity it represents). This separation allows OMOP to maintain both the clinical meaning and the data source context, which is essential for proper analysis and interpretation of the data.

#### OMOP Domain and Type Concept Examples
Type concepts are implemented through fields that follow a specific naming convention, with tables containing fields ending in `_TYPE_CONCEPT_ID` such as `drug_type_concept_id` and `condition_type_concept_id`. These type concepts should be populated during the ETL process based on the source system, and valid type concepts belong to the "Type Concept" domain and vocabulary within OMOP.

Note the table below is only a partial list.  A complete listing of type concepts can be found in the [OHDSI Standardized Vocabularies](https://athena.ohdsi.org/search-terms/terms?domain=Type+Concept&standardConcept=Standard&page=1&pageSize=15&query=)   and a detailed explanation is available on the [ OHDSI Vocabulary wiki](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Vocab.-TYPE_CONCEPT).

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">OMOP Domain</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Field Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Type Concept Examples</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;"><a href="https://ohdsi.github.io/CommonDataModel/cdm54.html#drug_exposure">Drug Exposure</a></td>
      <td style="border: 1px solid #d0d7de;"><code>drug_type_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">EHR prescription</td>
      <td style="border: 1px solid #d0d7de;">Prescription written by physician in electronic health record</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">EHR administration record</td>
      <td style="border: 1px solid #d0d7de;">Drug administered to patient (inpatient/outpatient)</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Pharmacy claim</td>
      <td style="border: 1px solid #d0d7de;">Prescription filled at pharmacy (claims data)</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Patient self-report</td>
      <td style="border: 1px solid #d0d7de;">Medication reported by patient during encounter</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;"><a href="https://ohdsi.github.io/CommonDataModel/cdm54.html#condition_occurrence">Condition Occurrence</a></td>
      <td style="border: 1px solid #d0d7de;"><code>condition_type_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">EHR encounter diagnosis</td>
      <td style="border: 1px solid #d0d7de;">Diagnosis recorded during clinical encounter</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">EHR problem list</td>
      <td style="border: 1px solid #d0d7de;">Condition documented in patient's problem list</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Claim primary diagnosis</td>
      <td style="border: 1px solid #d0d7de;">Primary diagnosis from insurance claim</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Registry</td>
      <td style="border: 1px solid #d0d7de;">Condition recorded in disease registry</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;"><a href="https://ohdsi.github.io/CommonDataModel/cdm54.html#procedure_occurrence">Procedure Occurrence</a></td>
      <td style="border: 1px solid #d0d7de;"><code>procedure_type_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">EHR encounter record</td>
      <td style="border: 1px solid #d0d7de;">Procedure documented during clinical visit</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">EHR order</td>
      <td style="border: 1px solid #d0d7de;">Procedure ordered by physician</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Claim primary procedure</td>
      <td style="border: 1px solid #d0d7de;">Primary procedure from insurance claim</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Registry</td>
      <td style="border: 1px solid #d0d7de;">Procedure recorded in clinical registry</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;"><a href="https://ohdsi.github.io/CommonDataModel/cdm54.html#visit_occurrence">Visit Occurrence</a></td>
      <td style="border: 1px solid #d0d7de;"><code>visit_type_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">EHR encounter</td>
      <td style="border: 1px solid #d0d7de;">Visit documented in electronic health record</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Claim</td>
      <td style="border: 1px solid #d0d7de;">Visit information from insurance claim</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Registry</td>
      <td style="border: 1px solid #d0d7de;">Visit recorded in clinical registry</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de; font-weight: bold;"><a href="https://ohdsi.github.io/CommonDataModel/cdm54.html#measurement">Measurement</a></td>
      <td style="border: 1px solid #d0d7de;"><code>measurement_type_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">EHR</td>
      <td style="border: 1px solid #d0d7de;">Laboratory or vital sign measurement from EHR</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Claim</td>
      <td style="border: 1px solid #d0d7de;">Measurement information from insurance claim</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Registry</td>
      <td style="border: 1px solid #d0d7de;">Measurement from clinical registry or study</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Patient reported</td>
      <td style="border: 1px solid #d0d7de;">Measurement reported by patient</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de; font-weight: bold;"><a href="https://ohdsi.github.io/CommonDataModel/cdm54.html#observation">Observation</a></td>
      <td style="border: 1px solid #d0d7de;"><code>observation_type_concept_id</code></td>
      <td style="border: 1px solid #d0d7de;">EHR</td>
      <td style="border: 1px solid #d0d7de;">Clinical observation documented in EHR</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Claim</td>
      <td style="border: 1px solid #d0d7de;">Observation information from insurance claim</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Survey</td>
      <td style="border: 1px solid #d0d7de;">Data collected through patient survey</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;"></td>
      <td style="border: 1px solid #d0d7de;">Registry</td>
      <td style="border: 1px solid #d0d7de;">Observation from clinical registry</td>
    </tr>
  </tbody>
</table>  

### Historical Code and Code System Transformations
Healthcare data transformation frequently encounters historical coding systems that are no longer actively maintained or updated. These legacy codes present unique challenges during OMOP CDM implementation due to their deprecated status and complex mapping requirements. ICD-9 codes represent the most prominent example, having been largely replaced by ICD-10 in clinical settings. These codes commonly appear in legacy electronic health records, retrospective datasets, and clinical documentation predating modern coding system adoption.

The management of historical codes introduces several complexities that require careful consideration during OMOP transformation. Maintenance limitations present the primary obstacle, as historical coding systems no longer receive updates or support from their originating organizations. This abandonment often results in their exclusion from current OMOP Standardized Vocabularies, creating gaps in direct mapping capabilities. Crosswalk complexity further complicates the transformation process, as historical-to-modern code relationships rarely follow simple one-to-one patterns. Many historical codes require mapping to multiple modern equivalents, while others may lack direct contemporary representations. This variability requires mapping strategies that preserve clinical meaning while accommodating structural differences between coding systems. Data integrity concerns arise when historical codes cannot be adequately mapped, potentially resulting in clinical information loss or the introduction of mapping-related inaccuracies. The diminishing availability of historical code support resources compounds these challenges, as fewer tools and expert resources remain dedicated to legacy system maintenance.

#### Considerations for Legacy Vocabulary Versions
The historical code management process begins with comprehensive identification of legacy codes within source datasets. Following identification, implementers must determine the optimal mapping strategy based on available resources and clinical requirements. ICD-9-CM, ICD-9-Proc, and ICD-9-ProcCN remain listed as source vocabularies for the OHDSI Standardized Vocabularies, but as of (***need a date here ***) are no longer being updated in the OHDSI Vocabularies. When OHDSI-generated reference content is not available, authoritative crosswalk utilization represents the preferred approach, leveraging mapping tables provided by organizations such as the Centers for Medicare & Medicaid Services or the National Library of Medicine. Optimally these crosswalks facilitate translation from historical codes to modern equivalents, including ICD-10 or SNOMED CT classifications that can then be levereaged to identify approrpoate Standard OMOP concpets. When crosswalks prove insufficient or unavailable, direct, manual mapping strategies may apply if historical codes remain present than codes represented in current OMOP vocabulary versions. 

#### Historical Code Implementation Example

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

### Multiple FHIR Reference Codings to OMOP 
The transformation of FHIR resources to the OMOP CDM frequently presents scenarios where a single clinical concept on OMOP contains multiple codes within the FHIR resource structure.  This scenario introduces complexity in the mapping process because it requires determining which code (or codes) should be used to represent the concept in the OMOP CDM. The mapping workflow begins with comprehensive identification of all coding elements within the FHIR resource. Each code requires documentation of its associated coding system through the system URI, along with any explicit ranking or preference indicators present in the source data.

To ensure consistency and clinical validity implementers must apply the [Code Prioritization Framework](https://build.fhir.org/ig/HL7/fhir-omop-ig/UseCases.html) logic outlined above. Once the primary code is selected, the system should perform concept mapping to identify the corresponding Stndard OMOP concept_id. When direct mapping is unavailable, the system should map to the closest parent concept while maintaining detailed documentation of all mapping decisions for audit and quality assurance purposes.

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

 
