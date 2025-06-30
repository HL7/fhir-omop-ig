# Specific Issues when Transforming FHIR to OMOP
Challenges arise aligning  FHIR resources and the OMOP Common Data Model (CDM) due to differences in data structures and the underlying scope and purpose when using each in deployed systems.   An additional layer of complexity lies in the fact that few observational data sources are generated as native FHIR, so many FHIR resources have previously undergone a transformation onto FHIR in support of data exchange scenarios. As such, there is a need for a pragmatic approach to aligning FHIR and OMOP that preserves not only key context of the source data represented in a formation that supports transactional use cases, but also attains conformance to OMOP as a target specification supporting analytics. 

Given the inherent differences in scope and purpose of the two models, this implementation guide focuses on high-confidence mappings, providing annotation in areas where assumptions are made.  Our goal is to provide rationale and clear conventions where details applicable to all cases of FHIR to OMOP transformations may be lacking. This guide is intended to be the foundation upon which refinement addressing specific use cases can be based.  Testing at Connectathons and standard HL7 user feedback processes will validate and / or enhance our proposed strategies and ensure the conventions and mappings provided are robust and practical for a variety of use cases.
FHIR by design supports real-time clinical data exchange within healthcare systems, emphasizing data interoperability and clinical workflows. OMOP is structured for research and analytics, focusing on retrospective analysis and standardized terminology. The implication of these differences includes that under-considered or incomplete mappings can misrepresent data because FHIR's real-time, workflow-oriented approach doesn’t always align with OMOP’s longitudinal approach to data.  The OMOP approach and data model requires compliance to concept standardization and assumes that data has been validated by data quality procedures ensuring its consistency. Specific aspects of patient records on FHIR that require special consider when transforming to OMOP follow.

## Identifiers, De-identitification & Privacy
As is customary for relational databases, identifiers in the OMOP Common Data Model are used to establish relationships between tables. Notably, the person_id is used as a foreign key in OMOP to link conditions, procedures, drug exposures and other clinical domain tables. However, data residing on OMOP is de-identified as a default where no fields contain data that are patient identifiable information (PII), such as Medical Record Numbers, names or addresses. In FHIR, identifiers provide a similar function in that they link discrete data occurring in separate FHIR resources to individual patients, but identifiers in FHIR also provide reference information about and / or residing in the source systems that generate data in FHIR resources to support workflows and transactions between systems.  In practice, many OMOP implementations reside within system architectures that have business requirements for re-identification supporting learning health systems scenarios, research recruitment or other use cases.   For these instances, maintaining traceability from OMOP back to the FHIR source could be crucial for continuous learning and other virtuous feedback loops leveraging the use of observational data. Simply stated, there is not a single approach that we can provide in the scope identified for this guide that can be uniformly applied to transformation of FHIR identifiers to OMOP.  Rather, implementers must evaluate FHIR identifiers in terms of 

* Research the OMOP instance is intended to support
* Purpose / role of the identifier in the FHIR resource
* Whether the FHIR identifier may, in fact, inform clinical facts in the observational data store
* Format (length) of the identifier

A primary concern when implementing FHIR to OMOP transformations that include raw identifiers directly from source systems is in doing so, there could be compromises in the de-identification process: a cornerstone of OMOP's design for use in research and analytics. OMOP is not designed to support business identity management use cases, and using fields like `visit_source_value` to store FHIR identifiers could misrepresent their intended use as generated in source EHRs. A potential solution is to ignore identifiers in the direct mapping process or stored in a separate structure outside of OMOP’s core tables to maintain traceability.  Creating a separate data source table that maps OMOP-generated IDs to the original FHIR identifiers can accommodate the complexities of handling identifiers for retaining provenance and traceability without compromising the de-identification and usability standards, disrupting the OMOP schema or violating its de-identification protocols.

Implementers of FHIR to OMOP transformations must balance how an identifier presents in the source FHIR resource(s), the technical requirements and permissible use of OMOP per the CDM specification. This involves choosing how to manage identifiers based on the specific needs and system constraints of the implementation, while maintaining compliance with data privacy and usability standards.  More specifically, differing database systems such as Google BigQuery, AWS Redshift… have varying constraints on integer sizes. This may complicate storing FHIR identifiers directly as OMOP IDs. It can also be challenging to find a suitable place for these identifiers within the OMOP Common Data Model (CDM), which does not have a direct equivalent field specifically designed for business identifiers associated with encounters.

An example of this type of challenge is apparent when evaluating the ‘encounter.identifier’ element in the FHIR Encounter resource.  This element captures a business identifier for the encounter, which in any source data may reflect a variety of identifiers such as medical record numbers, encounter IDs, or any unique values used by healthcare systems to track individual encounters. One solution would be to use `visit_occurrence_id`as a target in OMOP, as this is a unique identifier for each record in the `visit_occurrence` table aligned with the meaning of the data element in FHIR. However, in consideration for the need for traceability, data integrity, and compliance with de-identification standards, this primary key is typically generated in OMOP as a sequence to ensure anonymity and maintain referential integrity across the OMOP instance. Another solution would be to map FHIR `Encounter.identifier` to the OMOP`visit_source_value`a field that can hold the original value from the source data that describes the encounter type. However, depending on the convention used for generating this identifier in source upstream of FHIR, there are concerns regarding the appropriateness of using this field for identifiers, which are not descriptive values but unique business identifiers. Further, `visit_source_value` in OMOP often aligns more with descriptive elements in FHIR like `Encounter.period` or `Encounter.type`, which are codeable concepts in FHIR and not necessarily identifiers. 

There could be limitations to the ability of fields in an OMOP database to store some identifiers, particularly GUIDs or more complex strings that exceed, for example, the varchar(50) character limit specified in `visit_source_value.`  Identifiers in source systems may have missing context resulting in ambiguous meanings such as reflected in the following

  ```json
       "identifier": [
         {
           "system": "https://hospital.makedata.ai",
           "value": "b9d8ed9e-1b1a-4e30-9ee3-af66f4a61cff"
         }
       ]
```

Additionally, identifiers can be complex with nested elements:

       ```xml
       <identifier>
         <use value="official" />
         <system value="http://www.acmehosp.com/patients" />
         <value value="44552" />
         <period>
           <start value="2003-05-03" />
         </period>
       </identifier>
       ```
These examples highlight the complexity and variability of identifiers in FHIR, emphasizing why a one-size-fits-all mapping in OMOP is not practical. As such we recommend an evaluation on a case-by-case basis of the available FHIR identifier elements and their meaning in the source system to determine an appropriate target in OMOP, adoption of a separate facility or extension table(s) with the express purpose of storing source identifiers or ignoring them in the transformation altogether. 

## Data Completeness, Missiness &  Integrity
### Handling Incomplete or Partial Data
### Flavors of Null on OMOP
### Temporal Completeness and Missing Dates
### Contextual Gaps in Data Mapping
## Data Absent Reasons
## Temporality & Utilization of Dates 
