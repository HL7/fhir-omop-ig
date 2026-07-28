Instance: omop-fhir-source-system
InstanceOf: ActorDefinition
Title: "PAS Client"
Usage: #definition
* id = "src"
* name = "FHIR_Source_System"
* description = "The FHIR-conformant system that exposes the clinical data consumed by the transformation. This is typically an EHR FHIR endpoint, a clinical data repository, a FHIR facade over a legacy system, or a static FHIR Bundle or NDJSON export. The Source System is responsible only for producing FHIR resources that validate against declared profiles; it carries no OMOP-specific obligations.

This actor is almost always operated by a party other than the Transformation Engine operator: the hospital, the data holder, the national exchange. Stating its obligations explicitly allows this guide to set realistic expectations without imposing OMOP-specific requirements on systems whose primary purpose is clinical exchange."
* type = #system
* insert CommonActor

Instance: omop-transformation-engine
InstanceOf: ActorDefinition
Title: "Transformation Engine"
Usage: #definition
* id = "xfm"
* name = "Transformation_Engine"
* description = "The software component that reads FHIR resources from a Source System and produces records in an OMOP CDM v5.4 database. This is the actor that executes the ETL logic, whether through published FHIR StructureMaps, a custom ETL stack in SQL, dbt, Spark, or Python, or a hybrid of these. The Transformation Engine carries the largest number of conformance obligations in this guide, because it is where mapping decisions, code prioritization, type concept assignment, and status and intent filtering are enforced at runtime.

The Transformation Engine is distinguished from the ETL Implementer (A5) in that the Engine is the software and the Implementer is the organization that configures and runs it. A single Transformation Engine product, such as a commercial ETL tool, may be deployed by many Implementers, each producing their own Target OMOP Instances."
* type = #system
* insert CommonActor

Instance: omop-target-instance
InstanceOf: ActorDefinition
Title: "OMOP Target Instance"
Usage: #definition
* id = "tgt"
* name = "OMOP_Target_Instance"
* description = "The populated OMOP Common Data Model v5.4 database that is the output of the transformation. Conformance statements attached to this actor describe properties of the database state: what tables contain what kinds of records, what values are permitted in which fields, and what must or must not appear. These are checkable by data quality inspection independent of how the database was populated.

Separating the Target Instance from the Transformation Engine matters because OMOP instances are often reused, merged, or incrementally extended. Properties attached to the Target Instance persist across transformation runs and across Engine versions. An OMOP instance populated by a non-conformant Engine can still be made conformant by post-processing; conversely, a conformant Engine operated against an unsuitable source can produce a non-conformant Target."
* type = #system
* insert CommonActor

Instance: omop-terminology-server
InstanceOf: ActorDefinition
Title: "Terminology Server"
Usage: #definition
* id = "trm"
* name = "Terminology_Server"
* description = "A FHIR-conformant terminology server that hosts the OHDSI Standardized Vocabularies and exposes them through standard FHIR terminology operations, namely ConceptMap/$translate, CodeSystem/$lookup, and ValueSet/$expand. A Terminology Server is optional in the architecture: a Transformation Engine may instead use a locally loaded OMOP vocabulary. When a Terminology Server is used, its obligations are specified here so that Engines can rely on consistent behavior across servers."
* type = #system
* insert CommonActor

Instance: omop-etl-implementer
InstanceOf: ActorDefinition
Title: "ETL Implementer"
Usage: #definition
* id = "imp"
* name = "ETL_Implementer"
* description = "The organization or team that designs, deploys, configures, and operates a FHIR-to-OMOP transformation. The Implementer makes choices that cannot be made by software alone: which use cases the OMOP instance supports, which identifier-handling strategies apply, what filtering rules are consistent with the research purpose, and what the legal basis for data access is. Many of the most important conformance statements in this guide attach to the Implementer because they require human judgment, documentation, or governance activity rather than runtime behavior.

Distinguishing the Implementer as a formal actor is what allows this guide to carry conformance statements about ETL documentation, privacy assessment, and governance, statements that would be awkward to attach to a software component."
* type = #person
* insert CommonActor


RuleSet: CommonActor
* status = #active
* experimental = false
* date = "2026-07-31"

CodeSystem: FHIRToOMOPRequirementCodes
Title: "FHIR to OMOP Requirement Codes"
Description: "Codes defined as part of the FHIR to OMOP implementation guide used for requirement categories."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^hierarchyMeaning = #is-a
* ^content = #complete

* #_reqcat      "Requirements Categories"  "Codes that help to categorize requirements statements"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #scope      "scope"            "Requirements related to scope, versioning, and conformance framework"
  * #data       "data"             "Requirements related to source FHIR data expectations"
  * #identifier "identifier"       "Requirements related to identifier handling and privacy"
  * #codes      "codes"            "Requirements related to code mapping and terminology"
  * #concept    "concept"          "Requirements related to the OMOP type concept fields"
  * #status     "status"           "Requirements related to status, intent, and filtering"
  * #temporal   "temporal"         "Requirements related to temporal precision"
  * #dataloss   "dataloss"         "Requirements related to granularity and data loss"
  * #models     "models"           "Requirements related to logical models and StructureMaps"
  * #traceability "traceability"   "Requirements related to traceability, lineage, and reproducibility"
  * #terminology "terminology"     "Requirements related to terminology server interaction"
  * #testing     "testing"         "Requirements related to testing and coverage"

ValueSet: FHIRToOMOPConformanceStatementCategories
Id: cs-categories
Title: "FHIR to OMOP Conformance Statement Categories"
Description: "Categories for conformance statements found in the FHIR to OMOP IG"
* ^status = #active
* ^experimental = false
* include codes from system FHIRToOMOPRequirementCodes where concept descendent-of #_reqcat
