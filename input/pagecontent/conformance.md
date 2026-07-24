This page is the normative home for every conformance statement in this Implementation Guide. Each statement appears here once, in full, with a stable anchor. The narrative sections throughout the guide discuss the reasoning behind these statements and link back to the entries here; where a statement is discussed in the narrative, the discussion is listed under Discussed in. Statements are attributed to one or more [actors](actors.html) using the markings ● (primary actor, carries the obligation) and ○ (secondary actor, contributes to or is affected by the obligation).

The conformance verbs SHALL, SHOULD, and MAY are interpreted per [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174).

### Category 1. Scope, versioning, and conformance framework

<div id="f2o-001" markdown="1">

#### F2O-001

A Transformation Engine SHALL produce output conforming to the OMOP Common Data Model version 5.4, and a Target OMOP Instance SHALL conform to the OMOP CDM v5.4 schema.

**Actors:** ● XFM, ● TGT, ○ IMP

**Discussed in:** [OMOP CDM: CDM Version History](the-omop-cdm.html#cdm-version-history)

</div>

<div id="f2o-002" markdown="1">

#### F2O-002

An Implementer SHALL declare the FHIR version or versions of the source data that the transformation is configured to consume.

**Actors:** ● XFM, ● IMP

**Discussed in:** [Introduction: FHIR Versions](index.html#fhir-versions)

</div>

<div id="f2o-003" markdown="1">

#### F2O-003

A Transformation Engine and Implementer SHOULD publish a machine-readable manifest declaring which input FHIR profiles the transformation supports and which OMOP tables it populates from them. The format of the manifest is not defined in this version of the guide.

**Actors:** ● XFM, ● IMP

**Discussed in:** [Capability Declaration](technical_artifacts.html#capability-declaration)

</div>

<div id="f2o-004" markdown="1">

#### F2O-004

An Implementer SHALL declare which of the use cases described on the Use Cases page the transformation supports, so that the scope of a given FHIR-to-OMOP transformation is stated explicitly rather than inferred.

**Actors:** ● IMP

**Discussed in:** [Use Cases](UseCases.html)

</div>

<div id="f2o-005" markdown="1">

#### F2O-005

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, NOT RECOMMENDED, MAY, and OPTIONAL in this guide are to be interpreted as described in BCP 14 (RFC 2119, RFC 8174) when, and only when, they appear in all capitals, as shown here.

**Actors:** applies to every actor reading this guide

**Discussed in:** [How to Read the Conformance Language in This Guide](index.html#how-to-read-the-conformance-language-in-this-guide)

</div>

<div id="f2o-006" markdown="1">

#### F2O-006

A system or organization claiming conformance to this guide SHALL do so as one or more of the actors defined on the [Actors](actors.html) page, and SHALL meet every obligation attributed to each actor it claims. This guide defines a single level of conformance; there is no separate profile-validation-only conformance level.

**Actors:** ● IMP

**Discussed in:** [Actors](actors.html)

</div>

### Category 2. Source FHIR data expectations

<div id="f2o-010" markdown="1">

#### F2O-010

An Implementer SHALL declare which input FHIR profiles the transformation accepts, whether International Patient Access, US Core Encounter and Procedure, base FHIR resources, or a stated combination.

**Actors:** ○ SRC, ● XFM, ● IMP

**Discussed in:** [Source Data Expectations](F2OGeneralIssues.html#source-data-expectations)

</div>

<div id="f2o-011" markdown="1">

#### F2O-011

A Transformation Engine SHALL rely only on the elements a declared profile guarantees, and SHALL NOT assume the presence of an element that the profile permits a conformant source to omit. This is a constraint on assumptions about optional content, not an obligation to handle content beyond the transformation's declared profile scope.

**Actors:** ● XFM

**Discussed in:** [Source Data Expectations](F2OGeneralIssues.html#source-data-expectations)

</div>

<div id="f2o-012" markdown="1">

#### F2O-012

A Transformation Engine SHOULD validate incoming resources against the profiles the transformation declares it accepts, and SHOULD handle a validation failure by a documented disposition, rejecting or quarantining the resource rather than admitting it unvalidated. The disposition of failed input SHOULD be recorded so that the volume and reasons for failure are visible to operators and to consumers of the target.

**Actors:** ● XFM, ● IMP

**Discussed in:** [Source Data Expectations](F2OGeneralIssues.html#source-data-expectations)

</div>

<div id="f2o-013" markdown="1">

#### F2O-013

A Transformation Engine SHALL support ingestion of both singleton resources and Bundles. Where a Bundle is the source unit, its Bundle.type SHALL be one of document, collection, or message.

**Actors:** ● XFM

**Discussed in:** [Source Data Acquisition](F2OGeneralIssues.html#source-data-acquisition)

</div>

<div id="f2o-014" markdown="1">

#### F2O-014

A Transformation Engine MAY support ingestion of Bulk Data NDJSON exports.

**Actors:** ○ SRC, ● XFM

**Discussed in:** [Source Data Acquisition](F2OGeneralIssues.html#source-data-acquisition)

</div>

### Category 3. Identifier handling and privacy

<div id="f2o-020" markdown="1">

#### F2O-020

A Transformation Engine SHALL NOT store FHIR business identifier values (`Resource.identifier`) in OMOP `_source_value` fields, and a Target OMOP Instance SHALL NOT contain business identifier values in those fields.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Why `_source_value` Fields Are Not Appropriate for FHIR Identifier Storage](F2OGeneralIssues.html#why-_source_value-fields-are-not-appropriate-for-fhir-identifier-storage)

</div>

<div id="f2o-021" markdown="1">

#### F2O-021

A Transformation Engine SHALL NOT derive OMOP integer primary keys from FHIR business identifiers (`Resource.identifier`). Where primary keys are derived from FHIR source data rather than generated independently, the FHIR logical identifier (`Resource.id` combined with the resource type) is the appropriate source.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Deriving OMOP Primary Keys from FHIR Source Data](F2OGeneralIssues.html#deriving-omop-primary-keys-from-fhir-source-data)

</div>

<div id="f2o-022" markdown="1">

#### F2O-022

A Target OMOP Instance SHALL NOT contain patient identifiable information, including names, addresses, medical record numbers, and contact details, in any field.

**Actors:** ○ XFM, ● TGT, ○ IMP

**Discussed in:** [Compliance Considerations](F2OGeneralIssues.html#compliance-considerations)

</div>

<div id="f2o-023" markdown="1">

#### F2O-023

An Implementer SHOULD maintain an external mapping table linking OMOP-generated identifiers to the originating FHIR logical identifier (`[ResourceType]/[Resource.id]`) where traceability from OMOP records back to source resources is required.

**Actors:** ○ XFM, ● IMP

**Discussed in:** [Recommended Approach: External Mapping Table](F2OGeneralIssues.html#recommended-approach-external-mapping-table)

</div>

<div id="f2o-024" markdown="1">

#### F2O-024

Where an external mapping table is maintained, it SHALL reside outside the OMOP schema and SHALL be governed by access controls distinct from those governing the OMOP instance itself.

**Actors:** ● TGT, ● IMP

**Discussed in:** [Recommended Approach: External Mapping Table](F2OGeneralIssues.html#recommended-approach-external-mapping-table)

</div>

<div id="f2o-025" markdown="1">

#### F2O-025

An Implementer SHALL document a privacy and regulatory assessment for each identifier system encountered in the source data, identifying the framework applied, whether HIPAA Safe Harbor, Expert Determination, GDPR, or an equivalent, and the determination reached.

**Actors:** ● IMP

**Discussed in:** [Compliance Considerations](F2OGeneralIssues.html#compliance-considerations)

</div>

<div id="f2o-026" markdown="1">

#### F2O-026

An Implementer SHALL document, for each identifier system encountered, which handling strategy was applied, whether surrogate key mapping, external storage, or exclusion, and record that determination in the ETL documentation.

**Actors:** ○ XFM, ● IMP

**Discussed in:** [Decision Framework for Identifier Management](F2OGeneralIssues.html#decision-framework-for-identifier-management)

</div>

<div id="f2o-132" markdown="1">

#### F2O-132

An Implementer SHALL document the legal instrument governing access to the source FHIR data, whether a business associate agreement, an IRB approval or waiver, a data use agreement, or an equivalent, together with any constraint it places on identifier retention, linkage, or re-identification.

**Actors:** ● IMP

**Discussed in:** [Legal Basis for Data Access](F2OGeneralIssues.html#legal-basis-for-data-access)

</div>

### Category 4. Code mapping and terminology

<div id="f2o-030" markdown="1">

#### F2O-030

A Transformation Engine SHALL resolve concept assignments against the OHDSI Standardized Vocabularies, verifying concept existence, Standard concept status, and domain assignment for each source code it maps.

**Actors:** ● XFM, ○ TGT, ● TRM, ○ IMP

**Discussed in:** [Standard OMOP Vocabulary API Lookup Methodology](codemappings.html#standard-omop-vocabulary-api-lookup-methodology)

</div>

<div id="f2o-031" markdown="1">

#### F2O-031

A Transformation Engine SHALL populate OMOP `*_concept_id` fields only with Standard concepts, and SHALL record a non-Standard source concept in the companion `*_source_concept_id` field rather than in the `*_concept_id` field.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Impact of OMOP Standard Concepts & Domains](codemappings.html#impact-of-omop-standard-concepts--domains)

</div>

<div id="f2o-032" markdown="1">

#### F2O-032

Where a source code has no Standard OMOP concept and no custom concept is created for it, a Transformation Engine SHALL populate the corresponding `*_concept_id` field with 0.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Impact of OMOP Standard Concepts & Domains](codemappings.html#impact-of-omop-standard-concepts--domains)

</div>

<div id="f2o-033" markdown="1">

#### F2O-033

A Transformation Engine SHALL preserve the original source code verbatim in the companion `*_source_value` field.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Impact of OMOP Standard Concepts & Domains](codemappings.html#impact-of-omop-standard-concepts--domains)

</div>

<div id="f2o-034" markdown="1">

#### F2O-034

Where multiple codes are present for a single clinical idea, a Transformation Engine SHALL apply the Code Prioritization Framework described in this guide, and an Implementer SHALL document any departure from it.

**Actors:** ● XFM, ○ IMP

**Discussed in:** [Code Prioritization Framework](codemappings.html#code-prioritization-framework)

</div>

<div id="f2o-035" markdown="1">

#### F2O-035

Where a FHIR coding array carries explicit primary or preferred designations, a Transformation Engine SHALL honor them as tiebreakers within the prioritization hierarchy.

**Actors:** ● XFM

**Discussed in:** [Code Prioritization Framework](codemappings.html#code-prioritization-framework)

</div>

<div id="f2o-036" markdown="1">

#### F2O-036

Where a coding array carries both a parent concept and a more specific child concept from the same code system, a Transformation Engine SHALL select the more specific concept.

**Actors:** ● XFM

**Discussed in:** [Code Prioritization Framework](codemappings.html#code-prioritization-framework)

</div>

<div id="f2o-037" markdown="1">

#### F2O-037

A Transformation Engine SHALL assign the OMOP domain from the `domain_id` of the resolved concept rather than from the FHIR resource type, and a Target OMOP Instance SHALL store each clinical record in the domain table its concept's `domain_id` indicates.

**Actors:** ● XFM, ● TGT, ○ TRM

**Discussed in:** [OMOP Domain Assignment Logic](codemappings.html#omop-domain-assignment-logic)

</div>

<div id="f2o-038" markdown="1">

#### F2O-038

A Transformation Engine SHOULD resolve concepts through the `ConceptMap/$translate` and `CodeSystem/$lookup` operations of a FHIR terminology server rather than through a crosswalk hard-coded into the transformation. Where a static crosswalk is used instead, an Implementer SHALL record its provenance and the vocabulary release from which it was derived.

**Actors:** ● XFM, ● TRM

**Discussed in:** [Standard OMOP Vocabulary API Lookup Methodology](codemappings.html#standard-omop-vocabulary-api-lookup-methodology)

</div>

<div id="f2o-039" markdown="1">

#### F2O-039

Custom concepts added to a local OMOP instance SHALL use concept_id values at or above 2,000,000,000.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Coded Field Mapping Principles](codemappings.html#impact-of-omop-standard-concepts-domains)

</div>

<div id="f2o-040" markdown="1">

#### F2O-040

A Transformation Engine SHALL record the OHDSI Vocabulary release used to resolve concepts for each ETL run, as part of the run metadata described under Run Metadata and Reproducibility.

**Actors:** ● XFM, ● TGT, ○ TRM, ● IMP

**Discussed in:** [Run Metadata and Reproducibility](StrategiesBestPractices.html#run-metadata-and-reproducibility)

</div>

### Category 5. Type concept assignment

<div id="f2o-050" markdown="1">

#### F2O-050

A Transformation Engine SHALL populate every OMOP `*_type_concept_id` field with a Standard concept from the Type Concept domain, and a Target OMOP Instance SHALL NOT contain a clinical record with an unpopulated or non-Standard type concept.

**Actors:** ● XFM, ● TGT

**Discussed in:** [OMOP Domain and Type Concept Examples](codemappings.html#omop-domain-and-type-concept-examples)

</div>

<div id="f2o-051" markdown="1">

#### F2O-051

A Transformation Engine SHALL derive the type concept from the FHIR resource type together with the category and context elements the resource carries, rather than from the resource type alone.

**Actors:** ● XFM

**Discussed in:** [Type Concepts in the OMOP Common Data Model](codemappings.html#type-concepts-in-the-omop-common-data-model)

</div>

<div id="f2o-052" markdown="1">

#### F2O-052

Where the source does not carry sufficient context to identify a specific type concept, a Transformation Engine SHALL select the most general applicable Type Concept rather than assigning a specific one by inference.

**Actors:** ● XFM

**Discussed in:** [When Source Context Is Insufficient](codemappings.html#when-source-context-is-insufficient)

</div>

<div id="f2o-053" markdown="1">

#### F2O-053

Where a source record is patient-reported, a Transformation Engine SHALL assign a type concept distinguishing it from clinician-recorded data, and a Target OMOP Instance SHALL preserve that distinction.

**Actors:** ● XFM, ● TGT, ○ IMP

**Discussed in:** [Type Concepts in the OMOP Common Data Model](codemappings.html#type-concepts-in-the-omop-common-data-model)

</div>

### Category 6. Status, intent, and filtering

<div id="f2o-060" markdown="1">

#### F2O-060

A Transformation Engine SHALL evaluate status and intent elements and SHALL NOT transform resources describing events that were not realized, including those cancelled, proposed, planned, not done, stopped, or entered in error, into OMOP clinical event tables.

**Actors:** ● XFM, ○ IMP

**Discussed in:** [Status and Intent Elements](F2OGeneralIssues.html#status-and-intent-elements-in-fhir-resources)

</div>

<div id="f2o-061" markdown="1">

#### F2O-061

A Transformation Engine and Implementer SHALL apply consistent filter rules across all incremental loads into a given OMOP instance, and SHALL record any change to those rules, with its effective date, in the ETL documentation.

**Actors:** ● XFM, ● IMP

**Discussed in:** [Status and Intent Elements](F2OGeneralIssues.html#status-and-intent-elements-in-fhir-resources)

</div>

<div id="f2o-062" markdown="1">

#### F2O-062

A Transformation Engine SHOULD emit a run-level report of resources excluded by filter, recording counts by resource type and exclusion reason.

**Actors:** ● XFM, ○ IMP

**Discussed in:** [Status and Intent Elements](F2OGeneralIssues.html#status-and-intent-elements-in-fhir-resources)

</div>

<div id="f2o-063" markdown="1">

#### F2O-063

A Transformation Engine SHALL evaluate FHIR modifier elements and SHALL NOT silently transform a resource whose modifier elements alter its clinical interpretation, nor silently emit a concept_id of zero when a terminology lookup fails without recording the failure.

**Actors:** ● XFM

**Discussed in:** [Status and Intent Elements](F2OGeneralIssues.html#status-and-intent-elements-in-fhir-resources); [Understanding FHIR Modifier Extensions](FHIRModifierExtensions.html)

</div>

### Category 7. Temporal precision

<div id="f2o-070" markdown="1">

#### F2O-070

A Transformation Engine SHALL populate the required OMOP `*_date` field for every clinical event record it writes, and a Target OMOP Instance SHALL NOT contain a clinical event record with an unpopulated required date field. This applies to the date fields the CDM marks as required; end-date fields that the CDM permits to be NULL are not within its scope.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Core Implementation Pattern in OMOP](F2OGeneralIssues.html#core-implementation-pattern-in-omop)

</div>

<div id="f2o-071" markdown="1">

#### F2O-071

Where a required date is derived by imputation from a partial or absent source value, a Transformation Engine SHALL record the imputation by means of an appropriate type concept, and an Implementer SHALL document the imputation rules applied and their effective scope in the ETL documentation.

**Actors:** ● XFM, ● IMP

**Discussed in:** [Handling Partial or Approximate Dates When Mapping from FHIR](F2OGeneralIssues.html#handling-partial-or-approximate-dates-when-mapping-from-fhir)

</div>

<div id="f2o-072" markdown="1">

#### F2O-072

Where a FHIR source value carries a time zone offset and the corresponding OMOP `*_datetime` field is populated, a Transformation Engine SHALL convert the value to a single time zone applied consistently across the instance, and an Implementer SHALL state that time zone in the ETL documentation. The OMOP CDM provides no standard field for a time zone offset, so this guide does not require the original offset to be preserved.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Normalizing Time Zones on Ingestion](F2OGeneralIssues.html#normalizing-time-zones-on-ingestion)

</div>

<div id="f2o-073" markdown="1">

#### F2O-073

A Transformation Engine SHOULD populate the optional OMOP `*_datetime` fields where the FHIR source provides sub-day precision, rather than discarding that precision by populating only the required date field.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Optional Datetime Fields in OMOP](F2OGeneralIssues.html#optional-datetime-fields-in-omop)

</div>

### Category 8. Granularity and data loss

<div id="f2o-080" markdown="1">

#### F2O-080

An Implementer SHALL document the points at which the transformation loses information because FHIR granularity exceeds what the OMOP CDM can represent, and SHALL make that documentation available to consumers of the resulting OMOP data.

**Actors:** ○ XFM, ● IMP

**Discussed in:** [Granularity of FHIR Data vs. OMOP Standardization](StrategiesBestPractices.html#granularity-of-fhir-data-vs-omop-standardization)

</div>

<div id="f2o-081" markdown="1">

#### F2O-081

Where a FHIR element carries clinically meaningful content that has no representable target in the OMOP domain tables, a Transformation Engine SHOULD emit the residual content to the observation or note domain with a type concept identifying its origin, rather than discarding it silently.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Contextual Gaps in Data Mapping](F2OGeneralIssues.html#contextual-gaps-in-data-mapping)

</div>

<div id="f2o-082" markdown="1">

#### F2O-082

An Implementer SHALL produce and maintain ETL documentation recording mapping decisions, prioritization choices, pre-processing and manual interventions performed, and the known limitations of the transformation.

**Actors:** ○ XFM, ● IMP

**Discussed in:** [ETL Documentation](StrategiesBestPractices.html#etl-documentation)

</div>

### Category 9. Logical models and StructureMaps

<div id="f2o-090" markdown="1">

#### F2O-090

*Output for each populated OMOP table SHALL conform to the IG's logical model for that table.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-091" markdown="1">

#### F2O-091

*MAY execute published StructureMaps OR implement equivalent logic in another technology.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● IMP

</div>

<div id="f2o-092" markdown="1">

#### F2O-092

*Deviations from published StructureMaps SHALL be documented in ETL documentation.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● IMP

</div>

<div id="f2o-093" markdown="1">

#### F2O-093

*SHALL use published ConceptMaps (or a documented equivalent snapshot).*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TRM, ● IMP

</div>

### Category 10. Traceability, lineage, reproducibility

<div id="f2o-100" markdown="1">

#### F2O-100

An Implementer SHOULD maintain a traceability path from each clinical record in the Target OMOP Instance back to the FHIR resource that produced it.

**Actors:** ○ XFM, ● TGT, ● IMP

**Discussed in:** [Source Value Preservation](StrategiesBestPractices.html#source-value-preservation)

</div>

<div id="f2o-102" markdown="1">

#### F2O-102

A Transformation Engine SHALL record, for each ETL run, the OMOP CDM version targeted, the OHDSI Vocabulary release used, the version of this Implementation Guide followed, the version of the transformation software, and the time of execution.

**Actors:** ● XFM, ● TGT, ● IMP

**Discussed in:** [Run Metadata and Reproducibility](StrategiesBestPractices.html#run-metadata-and-reproducibility)

</div>

<div id="f2o-103" markdown="1">

#### F2O-103

A Transformation Engine SHOULD support idempotent re-processing of a given source snapshot, such that re-running a load does not duplicate clinical event records in the target.

**Actors:** ● XFM, ○ TGT

**Discussed in:** [Incremental Loads and Re-runs](StrategiesBestPractices.html#incremental-loads-and-re-runs)

</div>

### Category 11. Terminology server interaction

<div id="f2o-110" markdown="1">

#### F2O-110

Where a Transformation Engine resolves concepts through a FHIR terminology server, it SHALL do so through the standard `ConceptMap/$translate` and `CodeSystem/$lookup` operations rather than through server-specific interfaces, so that a transformation is not bound to a particular server implementation.

**Actors:** ● XFM, ● TRM

**Discussed in:** [Terminology Server API Utilization](TerminologyServer.html)

</div>

<div id="f2o-111" markdown="1">

#### F2O-111

A Transformation Engine SHOULD cache terminology server responses, and where it does so SHALL bind the cache invalidation policy to the OHDSI Vocabulary version, such that entries computed under one vocabulary version are not read under another.

**Actors:** ● XFM, ○ TRM

**Discussed in:** [Caching and Vocabulary Version Binding](TerminologyServer.html#caching-and-vocabulary-version-binding)

</div>

<div id="f2o-112" markdown="1">

#### F2O-112

A Terminology Server claiming conformance to this guide SHALL expose the OHDSI Standardized Vocabularies as FHIR CodeSystem and ConceptMap resources, and SHALL report the vocabulary release it is serving in the `version` element of its responses.

**Actors:** ● TRM, ○ IMP

**Discussed in:** [Terminology Server API Utilization](TerminologyServer.html)

</div>

### Category 12. Testing and coverage

<div id="f2o-120" markdown="1">

#### F2O-120

*Pass the IG's reference test suite (Connectathon Validation Package and successors).*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ○ TGT, ● IMP

</div>

<div id="f2o-121" markdown="1">

#### F2O-121

*SHOULD publish test results with IG version + vocabulary version.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● IMP

</div>

<div id="f2o-122" markdown="1">

#### F2O-122

*Disclose which OMOP tables are populated / partially populated / unpopulated.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● TGT, ● IMP

</div>
