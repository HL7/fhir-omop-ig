This page is the normative home for every conformance statement in this Implementation Guide. Each statement appears here once, in full, with a stable anchor. The narrative sections throughout the guide discuss the reasoning behind these statements and link back to the entries here; where a statement is discussed in the narrative, the discussion is listed under Discussed in. Statements are attributed to one or more [actors](actors.html) using the markings ● (primary actor, carries the obligation) and ○ (secondary actor, contributes to or is affected by the obligation).

The conformance verbs SHALL, SHOULD, and MAY are interpreted per [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174).

### Category 1. Scope, versioning, and conformance framework

<div id="f2o-001" markdown="1">

#### F2O-001

*Target OMOP CDM v5.4.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT, ○ IMP

</div>

<div id="f2o-002" markdown="1">

#### F2O-002

*Declare supported FHIR version(s) of source.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● IMP

</div>

<div id="f2o-003" markdown="1">

#### F2O-003

A Transformation Engine and Implementer SHOULD publish a machine-readable manifest declaring which input FHIR profiles the transformation supports and which OMOP tables it populates from them. The format of the manifest is not defined in this version of the guide.

**Actors:** ● XFM, ● IMP

**Discussed in:** [Capability Declaration](technical_artifacts.html#capability-declaration)

</div>

<div id="f2o-004" markdown="1">

#### F2O-004

*Declare supported use case(s).*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● IMP

</div>

<div id="f2o-005" markdown="1">

#### F2O-005

*RFC 8174 verb semantics apply (applies to every actor reading this IG).*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** applies to every actor reading this guide

</div>

<div id="f2o-006" markdown="1">

#### F2O-006

*Declare Profile-Only vs. Transformation conformance level.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ○ TRM, ● IMP

</div>

### Category 2. Source FHIR data expectations

<div id="f2o-010" markdown="1">

#### F2O-010

*Accept IPA, US Core, or base FHIR resources; declare which.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ SRC, ● XFM, ● IMP

</div>

<div id="f2o-011" markdown="1">

#### F2O-011

*Do not assume elements beyond declared profile minimums.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM

</div>

<div id="f2o-012" markdown="1">

#### F2O-012

*Validate input; reject or quarantine failures with documented disposition.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● IMP

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

*SHALL NOT store Resource.identifier values in OMOP _source_value fields.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-021" markdown="1">

#### F2O-021

*SHALL NOT derive OMOP integer PKs from Resource.identifier.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-022" markdown="1">

#### F2O-022

*TGT SHALL NOT contain PII (names, addresses, MRNs, contacts).*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● TGT, ○ IMP

</div>

<div id="f2o-023" markdown="1">

#### F2O-023

*SHOULD maintain external mapping table to [ResourceType]/[Resource.id].*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● IMP

</div>

<div id="f2o-024" markdown="1">

#### F2O-024

*External mapping table SHALL live outside OMOP schema, with distinct access controls.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● TGT, ● IMP

</div>

<div id="f2o-025" markdown="1">

#### F2O-025

*Document privacy assessment (HIPAA / Expert Det. / GDPR) per identifier system.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● IMP

</div>

<div id="f2o-026" markdown="1">

#### F2O-026

*Document Surrogate-Key / External-Storage / Exclusion strategy per identifier.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ○ XFM, ● IMP

</div>

<div id="f2o-132" markdown="1">

#### F2O-132

*Document legal basis (BAA / IRB / DUA / equivalent) for data access.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● IMP

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

*Populate OMOP *_date (mandatory in v5.4) for every clinical event.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-071" markdown="1">

#### F2O-071

*Document imputation strategy paired with estimation type concept when dates are missing.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● IMP

</div>

<div id="f2o-072" markdown="1">

#### F2O-072

*Preserve timezone from FHIR instants, normalize to UTC in *_datetime.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

</div>

<div id="f2o-073" markdown="1">

#### F2O-073

*SHOULD populate optional *_datetime when source provides sub-day precision.*

> Full normative wording to be finalized. The text above is the abbreviated statement; the complete SHALL/SHOULD/MAY wording will be inserted here before ballot.

**Actors:** ● XFM, ● TGT

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
