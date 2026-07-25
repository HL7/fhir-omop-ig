This page describes how FHIR content reaches a transformation pipeline and what a Transformation Engine may assume about that content once it arrives. The shapes in which FHIR data is delivered determine what can be taken for granted about completeness, ordering, and reference resolution; the profiles a transformation declares determine which elements it may rely on. Both bear directly on how the transformation is designed and on what it does with input that does not conform.

### Source Data Acquisition

FHIR data reaches a transformation pipeline through many different mechanisms: direct queries against an EHR FHIR endpoint, scheduled exports to object storage, message brokers, integration engines, data lake landing zones, and file transfers from a data holder. The choice among these is driven by institutional architecture, network and security posture, data volume, and the governance agreements under which data are shared. Specifying or recommending particular ingestion platforms is out of scope for this Implementation Guide.

What is in scope is the shape of the FHIR content that arrives, because shape determines what a Transformation Engine can assume about completeness, ordering, and reference resolution. Three forms are common, and each carries different implications for transformation design.

#### Singleton Resources

A singleton is a single FHIR resource instance, typically retrieved by a read or search interaction against a FHIR server. Singletons are the simplest unit to reason about, but they arrive without accompanying context. A Condition resource retrieved on its own carries a subject reference to a Patient and may carry an encounter reference, but the referenced resources are not present. A Transformation Engine consuming singletons must therefore resolve references by additional retrieval, or defer resolution until the referenced records exist in the target.

This has a direct consequence for OMOP population order. OMOP's person_id is a foreign key present on nearly every clinical event table, so a Condition cannot be written to condition_occurrence until the corresponding person record exists. Transformations that consume singletons generally require either a staging layer that accumulates resources until referential dependencies are satisfiable, or a two-pass design that establishes Person and Visit records before clinical events are processed.

#### Bundles

A Bundle collects multiple resources into a single instance. For the purposes of this Implementation Guide, a Transformation Engine consumes Bundles that arise as source content from three interactions: a document Bundle, as produced by clinical document exchange such as an International Patient Summary; a collection Bundle, as returned by a Patient/$everything operation; and a message Bundle, as produced by FHIR messaging. The Bundle.type element identifies which of these applies and determines what the Bundle's contents mean and how its entries relate to one another.

A document Bundle is Composition-rooted: its first entry is a Composition resource whose section elements organize and give context to the remaining entries. A Transformation Engine reads the clinical resources carried in the Bundle's entries directly; Composition-driven section handling, in which section membership informs domain assignment or provenance, is not specified in this ballot and is recorded as a future direction. Note that accepting document-type Bundles is a constraint on the Bundle's type, not adoption of the International Patient Summary profile; IPS Bundles serve here as examples of the type, and the IG does not take on the Composition and sectioning constraints that profile conformance would import.

The practical advantage of Bundle ingestion is that references are frequently resolvable within the Bundle itself. A collection Bundle returned by Patient/$everything typically contains the Patient resource alongside the clinical resources referring to it, which allows a Transformation Engine to establish the OMOP Person record and the dependent clinical records in a single pass. Implementers should not assume this holds universally: a Bundle may contain references to resources outside it, which require resolution by additional retrieval or deferral until the referenced records exist in the target.

searchset Bundles are out of scope for this ballot. A searchset may span multiple pages linked by a next relation, and assembling a complete result across pages introduces paging behavior that this Implementation Guide does not specify. Incoming Bundle types that represent requests to a server rather than source content, specifically transaction and batch, are likewise out of scope, as are transaction-response, batch-response, history, and subscription-notification.

#### Bulk Data (NDJSON)

The FHIR Bulk Data Access specification defines an asynchronous export producing newline-delimited JSON files, conventionally one file per resource type. This form is well suited to the population-scale extracts that OMOP databases are typically built from, and it is used in production FHIR-to-OMOP pipelines. Note that Bulk Data Access remains an optional server capability and is less widely deployed than single-patient FHIR interaction, so implementers should not assume a given data holder exposes it.

NDJSON's file-per-resource-type organization aligns unusually well with OMOP's table-per-domain structure, and its streaming line-delimited format allows resources to be processed without loading an entire export into memory. Because a Bulk Data export is a point-in-time snapshot of a defined population, it also provides a natural unit of reproducibility: a given export can be re-transformed to produce the same OMOP content.

The tradeoff is that references are resolved across files rather than within a container. A Condition in Condition.ndjson refers to a Patient in Patient.ndjson, so the transformation must either index the Patient file first or process files in dependency order. Exports may also be subject to a _since parameter or a group scope that limits their contents, which means an export is not necessarily a complete picture of the population it appears to describe. Where an export is incremental, the transformation must be designed to merge with existing target content rather than to populate from empty.

#### Guidance

A Transformation Engine SHALL support ingestion of both singleton resources and Bundles, since both forms are produced by conformant FHIR servers under ordinary retrieval patterns and a transformation restricted to one form cannot consume the other without an intermediary. Where a Bundle is the source unit, its Bundle.type SHALL be one of document, collection, or message. A Transformation Engine MAY support ingestion of Bulk Data NDJSON exports; this is not required, because Bulk Data Access is itself an optional capability for FHIR servers and not all data holders expose it, but implementers building population-scale OMOP instances should expect to encounter it. (f2o-013, f2o-014)

Whichever forms are supported, the Implementer should document which ingestion shapes the transformation accepts and what assumptions it makes about reference resolution and completeness, as part of the ETL documentation described under [ETL Documentation](StrategiesBestPractices.html#etl-documentation) on the Transformation Strategies and Best Practices page.

### Source Data Expectations

The [Source Data Acquisition](#source-data-acquisition) section describes the shapes in which FHIR content arrives. This section describes what a Transformation Engine may assume about that content once it arrives: which profiles it is built to consume, what it may and may not take for granted about the elements those profiles carry, and how it should behave when the incoming data does not conform.

#### Declared Profile Scope

This guide is scoped to a common core of EHR data expressed through the International Patient Access (IPA) profiles, together with the Encounter and Procedure profiles from US Core (STU7 Sequence). That scope is a property of the guide, not of every transformation built from it. A given transformation consumes some subset of those profiles, and a consumer of the resulting OMOP data, or a data holder deciding whether to route data to a given engine, benefits from knowing that subset explicitly rather than discovering it by trial.

An Implementer therefore declares which input profiles the transformation accepts. A declaration might state that a transformation accepts IPA profiles together with US Core Encounter and Procedure; that it accepts IPA profiles only; or that it accepts base FHIR resources conforming to no profile beyond the resource definitions. The point is not which profiles are chosen but that the set is stated, so that the boundary of the transformation is explicit. 

The choice of IPA and US Core is a starting fence, not a limit on the guide's reach. Bounding the initial work to a common core of widely available EHR data on FHIR is what allowed a concrete specification to be produced at all; the transformation principles this guide establishes, code prioritization, domain assignment from the resolved concept, type concept derivation, status and intent filtering, temporal handling, and the rest, are not specific to those profiles and are intended to extend to other FHIR profiles within reason. An Implementer working from profiles beyond the curated core applies the same principles and declares the profiles used; the guide is a foundation on which more specialized content can be built, not a boundary that confines conformance to the profiles named here.

#### Reliance on Declared Minimums

This guide was produced as a foundation. It declared a deliberate scope and worked within it, and that discipline is what allowed a usable guide to ship rather than an endless attempt to cover every case at once. Content outside the declared scope is not precluded; on the contrary, its development as future add-on volumes, additional profiles, or downstream Implementation Guides is expressly anticipated and encouraged. Several sections of this guide discuss topics beyond its formal scope precisely to offer the community best-practice guidance for the ETLs it will build next.

The same discipline applies to how a Transformation Engine reads the profiles it does consume. A profile guarantees certain elements: those it marks as required, or as must-support, or with a minimum cardinality above zero. Everything else a profile permits is optional, and a conformant source may legitimately omit it. An engine that assumes an optional element is present, because it usually is, will fail when a conformant source omits it, and the failure will be silent: a record processed as though a missing element carried a value produces output that is wrong in a way nothing in the target reveals.

Relying only on what a declared profile guarantees is therefore a correctness property, not a breadth-of-coverage obligation. It does not ask an engine to handle every element a profile permits, nor to cover content outside the transformation's declared profile set. It asks the narrower thing: that the engine treat as optional what the profile treats as optional, and not build assumptions on the presence of elements a conformant source is free to leave out.

#### Handling Non-Conformant Input

A transformation cannot control what a source sends it. Even within a declared profile set, incoming resources may fail to validate: a required element may be absent, a value may fall outside a bound value set, a structure may be malformed. How a Transformation Engine responds to such input determines whether the resulting OMOP data can be trusted.

The failure mode to avoid is silent admission. An engine that passes non-conformant input through without checking it, or that partially processes an invalid resource and writes whatever it could extract, contaminates the target with records whose provenance and correctness cannot be established after the fact. Because OMOP analytics run at a remove from the source, such contamination is rarely detected at the point it occurs and can survive into analysis.

The remedy is deliberate disposition. A Transformation Engine should validate incoming resources against the profiles it has declared it accepts, and should handle validation failures by a defined route rather than by default. Two routes are ordinarily appropriate: rejection, in which the resource is not transformed and the fact of its rejection is recorded; and quarantine, in which the resource is set aside for review rather than transformed or discarded, so that a systematic source problem becomes visible and correctable. Whichever route is used, the disposition should be documented, both so that operators can see how much input failed and why, and so that a consumer of the target knows that failed input was handled deliberately rather than admitted unnoticed.

This obligation is the general case of a pattern that recurs elsewhere in this guide. When a terminology lookup cannot be resolved, an engine must not silently emit a placeholder concept without recording the failure, as described under status and intent screening and verified by the guide's reference test suite. Input validation is the same principle applied at the point of ingestion: a failure is handled and recorded, never silently absorbed.

#### Guidance

An Implementer SHALL declare which input FHIR profiles the transformation accepts. The declared set may be any FHIR profiles the transformation is built to consume, whether the International Patient Access and US Core profiles this guide curated its maps against, other published profiles, or base FHIR resources conforming to no profile beyond the resource definitions. (f2o-010)

A Transformation Engine SHALL rely only on the elements guaranteed by what it has declared it accepts, whether a profile or a base resource definition, and SHALL NOT assume the presence of an element that a conformant source is permitted to omit. This is a constraint on assumptions about optional content, not an obligation to handle content beyond the transformation's declared scope. (f2o-011)

A Transformation Engine SHOULD validate incoming resources against the profiles the transformation declares it accepts, and SHOULD handle a validation failure by a documented disposition, rejecting or quarantining the resource rather than admitting it unvalidated. The disposition of failed input SHOULD be recorded so that the volume and reasons for failure are visible to operators and to consumers of the target. (f2o-012)

