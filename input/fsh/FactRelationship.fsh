Logical: FactRelationship
Parent: Base
Id: FactRelationship
Characteristics: #can-be-target
Title: "Fact Relationship OMOP Table"
Description: "The FACT_RELATIONSHIP table contains records about the relationships between facts stored as records in any table of the CDM. Relationships can be defined between facts from the same domain, or different domains. Examples of Fact Relationships include: [Person relationships](https://athena.ohdsi.org/search-terms/terms?domain=Relationship&standardConcept=Standard&page=2&pageSize=15&query=) (parent-child), care site relationships (hierarchical organizational structure of facilities within a health system), indication relationship (between drug exposures and associated conditions), usage relationships (of devices during the course of an associated procedure), or facts derived from one another (measurements derived from an associated specimen)."

* domain_concept_id_1 1..1 code "Domain 1" ""
* fact_id_1 1..1 string "Fact Identifier 1" ""
* domain_concept_id_2 1..1 code "Domain 2" ""
* fact_id_2 1..1 string "Fact Identifier 2" ""
* relationship_concept_id 1..1 code "Relationship" ""
