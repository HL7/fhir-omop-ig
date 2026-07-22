This page defines the actors involved in a FHIR-to-OMOP transformation and is the reference for the actor attributions shown on the [Conformance Statements](conformance.html) page. The conformance verbs SHALL, SHOULD, and MAY used throughout this guide are interpreted per [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174).

A system or organization claims conformance to this Implementation Guide as one or more actors. Claiming conformance as one actor does not require, or imply, conformance as any other. Most end-to-end deployments involve several actors, frequently operated by the same organization but separable in principle. That separation is what allows, for example, a terminology service vendor to claim conformance without running an ETL pipeline, or a research network to accept OMOP instances built by different transformation engines.

This guide defines a single level of conformance. A system claims conformance by meeting the obligations of the actor role or roles it takes on; there is no separate profile-validation-only conformance level distinct from transformation conformance.

### A1 FHIR Source System (SRC)

The FHIR-conformant system that exposes the clinical data consumed by the transformation. This is typically an EHR FHIR endpoint, a clinical data repository, a FHIR facade over a legacy system, or a static FHIR Bundle or NDJSON export. The Source System is responsible only for producing FHIR resources that validate against declared profiles; it carries no OMOP-specific obligations.

This actor is almost always operated by a party other than the Transformation Engine operator: the hospital, the data holder, the national exchange. Stating its obligations explicitly allows this guide to set realistic expectations without imposing OMOP-specific requirements on systems whose primary purpose is clinical exchange.

### A2 Transformation Engine (XFM)

The software component that reads FHIR resources from a Source System and produces records in an OMOP CDM v5.4 database. This is the actor that executes the ETL logic, whether through published FHIR StructureMaps, a custom ETL stack in SQL, dbt, Spark, or Python, or a hybrid of these. The Transformation Engine carries the largest number of conformance obligations in this guide, because it is where mapping decisions, code prioritization, type concept assignment, and status and intent filtering are enforced at runtime.

The Transformation Engine is distinguished from the ETL Implementer (A5) in that the Engine is the software and the Implementer is the organization that configures and runs it. A single Transformation Engine product, such as a commercial ETL tool, may be deployed by many Implementers, each producing their own Target OMOP Instances.

### A3 Target OMOP Instance (TGT)

The populated OMOP Common Data Model v5.4 database that is the output of the transformation. Conformance statements attached to this actor describe properties of the database state: what tables contain what kinds of records, what values are permitted in which fields, and what must or must not appear. These are checkable by data quality inspection independent of how the database was populated.

Separating the Target Instance from the Transformation Engine matters because OMOP instances are often reused, merged, or incrementally extended. Properties attached to the Target Instance persist across transformation runs and across Engine versions. An OMOP instance populated by a non-conformant Engine can still be made conformant by post-processing; conversely, a conformant Engine operated against an unsuitable source can produce a non-conformant Target.

### A4 Terminology Server (TRM)

A FHIR-conformant terminology server that hosts the OHDSI Standardized Vocabularies and exposes them through standard FHIR terminology operations, namely ConceptMap/$translate, CodeSystem/$lookup, and ValueSet/$expand. A Terminology Server is optional in the architecture: a Transformation Engine may instead use a locally loaded OMOP vocabulary. When a Terminology Server is used, its obligations are specified here so that Engines can rely on consistent behavior across servers.

### A5 ETL Implementer (IMP)

The organization or team that designs, deploys, configures, and operates a FHIR-to-OMOP transformation. The Implementer makes choices that cannot be made by software alone: which use cases the OMOP instance supports, which identifier-handling strategies apply, what filtering rules are consistent with the research purpose, and what the legal basis for data access is. Many of the most important conformance statements in this guide attach to the Implementer because they require human judgment, documentation, or governance activity rather than runtime behavior.

Distinguishing the Implementer as a formal actor is what allows this guide to carry conformance statements about ETL documentation, privacy assessment, and governance, statements that would be awkward to attach to a software component.

### Summary of obligations per actor

A quick reference for implementers deciding which actor role or roles they are claiming.

<table class="grid">
  <thead>
    <tr><th>Actor</th><th>Character of its obligations</th></tr>
  </thead>
  <tbody>
    <tr><td><strong>SRC</strong> FHIR Source System</td><td>Carries only secondary obligations. The bar is essentially to be a conformant FHIR server exposing declared profiles. Source Systems need know nothing OMOP-specific to support a conformant transformation.</td></tr>
    <tr><td><strong>XFM</strong> Transformation Engine</td><td>Carries the plurality of runtime obligations: code prioritization, domain assignment, type concept derivation, status and intent filtering, modifier handling, terminology lookups, vocabulary versioning, and idempotency. If a single actor in this guide were to be certified by a test harness, it would be the Transformation Engine.</td></tr>
    <tr><td><strong>TGT</strong> Target OMOP Instance</td><td>Carries database-state properties: v5.4 schema, no PII, no business identifiers in source-value fields, proper use of concept_id = 0 for unmapped codes, the 2-billion range for custom concepts, populated type concepts, populated dates. These are checkable by inspection and stable across re-runs.</td></tr>
    <tr><td><strong>TRM</strong> Terminology Server</td><td>Carries a small, focused set of obligations that apply only when a server is part of the architecture: FHIR-standard operation support, exposure of the OHDSI Vocabularies, and version transparency.</td></tr>
    <tr><td><strong>IMP</strong> ETL Implementer</td><td>Carries the governance and documentation obligations that cannot be automated: use-case declaration, privacy assessment, ETL documentation, legal basis, filter-consistency governance, conformance-claim publication, and test-result publication.</td></tr>
  </tbody>
</table>
