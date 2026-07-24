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

*Resolve concept assignments using the current OHDSI Vocabularies.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ○ TGT, ● TRM, ○ IMP

</div>

<div id="f2o-031" markdown="1">

#### F2O-031

*Populate *_concept_id only with Standard (S) concepts; non-Standard to *_source_concept_id.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-032" markdown="1">

#### F2O-032

*Populate *_concept_id = 0 when no Standard mapping exists.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-033" markdown="1">

#### F2O-033

*Preserve source codes verbatim in *_source_value.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-034" markdown="1">

#### F2O-034

*Apply Code Prioritization Framework (SNOMED, RxNorm, LOINC, ICD, CPT/HCPCS, local).*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ○ IMP

</div>

<div id="f2o-035" markdown="1">

#### F2O-035

*Honor FHIR coding rank/preference indicators as tiebreakers.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM

</div>

<div id="f2o-036" markdown="1">

#### F2O-036

*Prefer more-specific concept over parent within a code system.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM

</div>

<div id="f2o-037" markdown="1">

#### F2O-037

*Assign OMOP domain from concept table domain_id, not FHIR resource type.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT, ○ TRM

</div>

<div id="f2o-038" markdown="1">

#### F2O-038

*SHOULD use ConceptMap/$translate and CodeSystem/$lookup rather than hard-coded crosswalks.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TRM

</div>

<div id="f2o-039" markdown="1">

#### F2O-039

Custom concepts added to a local OMOP instance SHALL use concept_id values at or above 2,000,000,000.

**Actors:** ● XFM, ● TGT

**Discussed in:** [Coded Field Mapping Principles](codemappings.html#impact-of-omop-standard-concepts-domains)

</div>

<div id="f2o-040" markdown="1">

#### F2O-040

*Record OHDSI Vocabulary version used per ETL run.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT, ○ TRM, ● IMP

</div>

### Category 5. Type concept assignment

<div id="f2o-050" markdown="1">

#### F2O-050

*Populate every *_type_concept_id with a valid Type Concept domain Standard concept.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-051" markdown="1">

#### F2O-051

*Derive type concept from resource type + category + context.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM

</div>

<div id="f2o-052" markdown="1">

#### F2O-052

*Default to most general applicable type concept when context is insufficient.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM

</div>

<div id="f2o-053" markdown="1">

#### F2O-053

*Distinguish patient-reported from clinician-verified provenance via distinct type concepts.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT, ○ IMP

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

*Document known data-loss points where FHIR granularity exceeds OMOP.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● IMP

</div>

<div id="f2o-081" markdown="1">

#### F2O-081

*Emit unrepresentable residual elements to note or observation with appropriate type concept.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-082" markdown="1">

#### F2O-082

*Produce and maintain ETL documentation: mapping decisions, prioritization, pre-processing, manual interventions, limitations.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● IMP

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

*Traceability path from every clinical record back to originating FHIR resource.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● TGT, ● IMP

</div>

<div id="f2o-101" markdown="1">

#### F2O-101

*SHOULD capture FHIR Provenance and represent in OMOP via type concepts / note / extension.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-102" markdown="1">

#### F2O-102

*Each ETL run labeled with: CDM version, vocabulary version, IG version, engine version, timestamp.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT, ● IMP

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

*When TRM is used, SHALL invoke via $translate and $lookup.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TRM

</div>

<div id="f2o-111" markdown="1">

#### F2O-111

A Transformation Engine SHOULD cache terminology server responses, and where it does so SHALL bind the cache invalidation policy to the OHDSI Vocabulary version, such that entries computed under one vocabulary version are not read under another.

**Actors:** ● XFM, ○ TRM

**Discussed in:** [Caching and Vocabulary Version Binding](TerminologyServer.html#caching-and-vocabulary-version-binding)

</div>

<div id="f2o-112" markdown="1">

#### F2O-112

*A conformant TRM SHALL expose OHDSI Vocabularies as FHIR CodeSystem + ConceptMap.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● TRM, ○ IMP

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
