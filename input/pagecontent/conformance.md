The conformance verbs SHALL, SHOULD, and MAY are interpreted per [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174).

This page contains a table listing all the free-text conformance statements found in the IG.  This table is provided as a useful summary for implementers for the purpose of evaluating key features and to support testing.  However, reading this table alone is insufficient to understand or successfully implement the specification:

1. The table only includes conformance expectations expressed as free text.  It does not include the computable expectations represented in capability statements, profiles, value sets, etc.
2. The text text in the table only includes the 'formal' requirement.  It does not provide the contextual language around the statement that will be needed for successful explanation.  The 'id' of each statement is a hyperlink to the place it appears in the text to assist with gathering the needed context.

The statements are listed in a number of categories:

### Category 1. Scope, versioning, and conformance framework

This category establishes what a conformance claim against this guide means: the CDM version targeted, the FHIR versions consumed, the use cases supported, and the actor roles under which a claim is made. It also fixes the interpretation of the conformance verbs used throughout. These statements govern declaration and scope rather than the mechanics of any particular transformation, and they apply to every implementation regardless of which clinical domains it covers.

### Category 2. Source FHIR data expectations

This category covers what a transformation may assume about the FHIR data reaching it, and what it does with data that fails those assumptions. It addresses profile declaration, the treatment of optional elements, validation and the disposition of invalid input, and the source units a transformation accepts. The obligations here concern the boundary at which FHIR enters the transformation; the interpretation of the content once admitted belongs to later categories.

### Category 3. Identifier handling and privacy

This category governs the treatment of FHIR identifiers and patient identifiable information across the transformation and in the resulting OMOP instance. It distinguishes business identifiers, which carry patient-identifying content, from logical identifiers, which do not, and constrains where each may appear. It also carries the documentation obligations that accompany identifier handling: the privacy and regulatory framework applied, the strategy chosen for each identifier system, and the legal instrument authorizing access to the source data.

### Category 4. Code mapping and terminology

This category covers the translation of source codes into OMOP concepts: resolution against the OHDSI Standardized Vocabularies, the division of labor between the concept and source concept fields, preservation of the original code, and the handling of codes with no Standard concept. It also governs selection among competing codes, domain assignment, the custom concept range, and the recording of the vocabulary release under which resolution was performed. Type concepts, which describe provenance rather than clinical content, are treated separately in Category 5.

### Category 5. Type concept assignment

This category covers the OMOP type concept fields, which record how a clinical record came to exist rather than what it asserts clinically. The obligations here concern populating those fields with Standard concepts from the Type Concept domain, deriving the value from the resource together with its category and context rather than from the resource type alone, choosing a general concept where the source gives insufficient context, and preserving the distinction between patient-reported and clinician-recorded data.

### Category 6. Status, intent, and filtering

This category covers the FHIR elements that qualify whether an event actually occurred, and the consequences of ignoring them. It requires evaluation of status and intent so that unrealized events do not enter the OMOP clinical tables, requires consistent filter rules across incremental loads with any change recorded, and addresses modifier elements that alter clinical interpretation. Because filtering removes data, this category also carries the reporting obligation that makes exclusions visible to operators and downstream consumers.

### Category 7. Temporal precision

This category covers dates and times: populating the date fields the CDM requires, recording imputation where a required date is derived from a partial or absent source value, normalizing time zones where a datetime field is populated, and preserving sub-day precision the source provides. The OMOP CDM represents time less richly than FHIR does, so these obligations concern making the resulting loss explicit and consistent rather than preventing it.

### Category 8. Granularity and data loss

This category addresses the residue of the transformation: clinical content that FHIR can express and the OMOP CDM cannot. It requires that the points of loss be documented and made available to consumers of the data, that clinically meaningful content without a representable target be emitted to a general domain rather than discarded silently, and that the ETL documentation record mapping decisions, manual interventions, and known limitations. Where Category 7 concerns loss of temporal precision specifically, this category concerns loss of clinical content generally.

### Category 9. Logical models and StructureMaps

This category covers the formal transformation artifacts the guide publishes and the target structures they produce. It requires conformance to the logical model defined for each OMOP table populated, permits either execution of the published StructureMaps or equivalent logic in another technology, and requires that departures from published logic be recorded with their rationale. It also states where code-to-concept translation is resolved, since that resolution is not carried by the published artifacts themselves.

### Category 10. Traceability, lineage, reproducibility

This category covers the ability to account for how a Target OMOP Instance came to hold what it holds. It concerns the path from a clinical record back to the FHIR resource that produced it, the run metadata identifying the CDM version, vocabulary release, guide version, software version, and execution time for each load, and idempotent re-processing so that repeating a load does not duplicate records. The obligations here support audit and reproduction rather than the correctness of any individual mapping.

### Category 11. Terminology server interaction

This category applies only where a FHIR terminology server is part of the architecture, which this guide treats as optional. It requires that a transformation reach the server through standard FHIR terminology operations rather than server-specific interfaces, so that a transformation is not bound to one implementation. It governs cache invalidation against the vocabulary version, and states what a Terminology Server itself claims when it claims conformance to this guide.

### Category 12. Testing and coverage

This category covers the demonstration of conformance rather than its substance. It requires that a Transformation Engine pass the reference test suite for the transformations it claims, identifying the independently versioned suite release under which the claim was established, and encourages publication of those results with the guide version and vocabulary release under which the run was performed. It also requires a Target OMOP Instance to disclose which OMOP tables it populates fully, partially, and not at all.


A few other notes:

* While ids start as contiguous, as the specification is updated, it is possible some conformance statements will be removed, which will create a gap in the numbers.  This is not an error.
* Ids are not final until published in an official release.  At that point, ids will not be changed.
* It is possible for the text of a given rules to change somewhat from one release to another so long as the intention of the rule is the same.  If the intent has a significant change, the old rule will be removed and a new one added in its place.
* The actors identified for each statement are defined on the [Actors](actors.html) page.

The controls at the top of the table allow filtering the content to particular requirement subsets that may be of interest.  As well, a computable representation (XML and JSON) of the requirements can be found [here](Requirements-fromNarrative.html).

§§§
