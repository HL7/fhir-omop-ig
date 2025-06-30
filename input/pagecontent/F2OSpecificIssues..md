# Specific Issues when Transforming FHIR to OMOP
Challenges arise aligning  FHIR resources and the OMOP Common Data Model (CDM) due to differences in data structures and the underlying scope and purpose when using each in deployed systems.   An additional layer of complexity lies in the fact that few observational data sources are generated as native FHIR, so many FHIR resources have previously undergone a transformation onto FHIR in support of data exchange scenarios. As such, there is a need for a pragmatic approach to aligning FHIR and OMOP that preserves not only key context of the source data represented in a formation that supports transactional use cases, but also attains conformance to OMOP as a target specification supporting analytics. 

Given the inherent differences in scope and purpose of the two models, this implementation guide focuses on high-confidence mappings, providing annotation in areas where assumptions are made.  Our goal is to provide rationale and clear conventions where details applicable to all cases of FHIR to OMOP transformations may be lacking. This guide is intended to be the foundation upon which refinement addressing specific use cases can be based.  Testing at Connectathons and standard HL7 user feedback processes will validate and / or enhance our proposed strategies and ensure the conventions and mappings provided are robust and practical for a variety of use cases.
FHIR by design supports real-time clinical data exchange within healthcare systems, emphasizing data interoperability and clinical workflows. OMOP is structured for research and analytics, focusing on retrospective analysis and standardized terminology. The implication of these differences includes that under-considered or incomplete mappings can misrepresent data because FHIR's real-time, workflow-oriented approach doesn’t always align with OMOP’s longitudinal approach to data.  The OMOP approach and data model requires compliance to concept standardization and assumes that data has been validated by data quality procedures ensuring its consistency. Specific aspects of patient records on FHIR that require special consider when transforming to OMOP follow.

## Identifiers, De-identitification & Privacy
## Data Completeness, Missiness &  Integrity
### Handling Incomplete or Partial Data
### Flavors of Null on OMOP
### Temporal Completeness and Missing Dates
### Contextual Gaps in Data Mapping
## Data Absent Reasons
## Temporality & Utilization of Dates 
