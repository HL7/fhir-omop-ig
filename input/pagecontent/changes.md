### Version 2.0.0-ballot

Here are all of the changes made since Version 1.0.0 for the 2.0.0 ballot. This ballot advances the guide's standards status from Informative to Trial-Use (STU 1) and raises its FHIR Maturity Model level from 2 to 4. The central addition is a formal, testable conformance framework; most other changes either support that framework directly or tighten existing guidance in ways the framework required.

#### Conformance Framework

| Summary |
|------|
| Introduced a formal conformance framework expressed as numbered, testable statements (`§f2o-NNN`) using RFC 8174 language, replacing the informal "should"/"may" prose used throughout the 1.0.0 text. |
| Added a new [Actors](actors.html) page defining five conformance actors: FHIR Source System (SRC), Transformation Engine (XFM), Target OMOP Instance (TGT), Terminology Server (TRM), and ETL Implementer (IMP), each carrying a distinct set of obligations. |
| Added a new [Conformance](conformance.html) page summarizing all conformance statements by category (scope/versioning, source data expectations, identifiers/privacy, code mapping, type concepts, status/intent filtering, temporal precision, granularity/data loss, logical models/StructureMaps, traceability/reproducibility, terminology server interaction, and testing/coverage), with a computable (XML/JSON) representation of the requirements. |
| Distributed dozens of new `§f2o-NNN` conformance statements across existing pages (Use Cases, Coded Field Mapping, Type Concepts, Status and Intent, Temporal Precision, Identifiers and Privacy, Source Data, Strategies and Best Practices, Technical Artifacts, Terminology Server) so that each topic's obligations are testable and traceable to a single identifier. |
| Raised the IG's `standards-status` from Informative to Trial-Use and FMM from 2 to 4; individual background/context pages (Introduction, OMOP CDM, Use Cases) retain an Informative designation while the normative transformation-guidance pages move to Trial-Use. |

#### Identifiers, De-identification & Privacy

| Summary |
|------|
| Moved the Identifiers, De-identification & Privacy content out of General Issues into its own dedicated page, [Identifiers, De-identification & Privacy](IdentifiersPrivacy.html). |
| Added guidance that an external identifier-mapping table (used for traceability from OMOP back to FHIR) must be governed by access controls distinct from those on the OMOP instance itself, since a party holding both can reverse the de-identification the transformation was designed to achieve. |
| Added an explicit, checkable conformance property that a Target OMOP Instance must contain no patient identifiable information (names, addresses, medical record numbers, contact details) in any field. |
| Added a new requirement that implementers document the legal instrument governing access to the source FHIR data (business associate agreement, IRB approval/waiver, data use agreement, or equivalent), since that instrument often determines whether and how long an identifier-linkage table may be retained. |

#### Source Data Acquisition & Scope

| Summary |
|------|
| Added a new [Source Data Acquisition and Expectations](SourceData.html) page describing the shapes in which FHIR content reaches a transformation (singleton resources, Bundles, and Bulk Data/NDJSON exports) and the implications of each for reference resolution and population order. |
| Defined which `Bundle.type` values a conformant transformation must accept (document, collection, message) and which are out of scope for this ballot (searchset, transaction, batch, and their responses), noting that Composition-driven section handling for document Bundles is deferred to a future version. |
| Added a requirement that implementers declare which input FHIR profiles a transformation accepts, and that a Transformation Engine rely only on the elements a declared profile guarantees rather than assuming optional elements are present. |
| Added guidance on handling non-conformant input: validation failures must be routed to a defined, documented disposition (rejection or quarantine) rather than admitted silently. |
| Clarified that the IG's scope now explicitly covers content arriving as singleton resources, Bundles, and Bulk Data exports, in addition to the previously described profile scope (IPA plus US Core Encounter and Procedure). |

#### Status and Intent Elements

| Summary |
|------|
| Substantially rewrote the Status and Intent Elements guidance in [General FHIR to OMOP Mapping Issues](F2OGeneralIssues.html), replacing general narrative with resource-specific tables enumerating which status/intent values represent realized events for MedicationRequest, MedicationStatement, Procedure, Observation, Condition, Encounter, and Immunization. |
| Clarified that MedicationRequest requires evaluating both `intent` and `status` together (only `intent = instance-order` admits a record, regardless of status), correcting the simpler single-field filtering described previously. |
| Added explicit handling for Condition `verificationStatus`, routing `provisional`, `differential`, and `refuted` values to the observation domain as qualified concepts rather than excluding them outright. |
| Added guidance that Encounter statuses `arrived`, `triaged`, and `in-progress` should produce a `visit_occurrence` record with a derived (rather than read) end date, instead of being filtered as incomplete. |
| Clarified that `entered-in-error` behaves uniformly across all resource types and must always be excluded. |
| Added a requirement that filter rules be applied consistently across incremental loads, with any change to those rules and its effective date recorded in the ETL documentation. |
| Added a new, strongly-recommended run-level exclusion report requirement, recording counts of excluded resources by resource type and exclusion reason, so that silent filtering errors become detectable. |
| Clarified the relationship between status/intent filtering and modifier extension screening as parallel, non-substitutable requirements. |

#### Temporal Precision

| Summary |
|------|
| Added a new subsection on normalizing time zones on ingestion, recommending conversion to a single, consistently applied time zone (conventionally UTC) before populating `*_datetime` fields, since the CDM cannot represent a time zone offset itself. |
| Added conformance statements requiring population of required `*_date` fields, documentation of any imputation used to derive a required date from a partial or absent source value, and recording of the time zone convention used. |

#### Terminology & Concept Mapping

| Summary |
|------|
| Added a new "Caching and Vocabulary Version Binding" section to the [Terminology Server](TerminologyServer.html) page, requiring that any cache of terminology server responses be bound to the OHDSI Vocabulary version, so cached results do not silently persist across vocabulary releases. |
| Added a new "Conformance Testing for Terminology Servers" section describing the HL7 FHIR Terminology Ecosystem IG's OMOP-specific test cases and requiring a conformant Terminology Server to expose the OHDSI Standardized Vocabularies and report its vocabulary release. |
| Clarified that the terminology server examples in this guide are illustrative (directed at `tx.fhir.org` purely as an example) and not a normative or required endpoint. |
| Corrected several example OMOP concept IDs to reflect the current state of the OHDSI Standardized Vocabularies (e.g., "No known allergy" observation concept corrected from 4222295 to 37396387; "Allergy to penicillin G" corrected from 4222295 to 4167462), and added a standing note on pages with worked examples that concept IDs shown reflect the vocabulary as it stood when the guide was written and should be re-verified against the vocabulary version in use. |
| Added a distinction between custom ("2-billionaire") concepts, which are assigned when no Standard concept exists, and `concept_id = 0`, which is populated when no Standard concept exists and no custom concept was created; clarified that custom concepts should be recorded in ETL documentation. |
| Added guidance recommending resolution of concepts through a FHIR terminology server's `ConceptMap/$translate` and `CodeSystem/$lookup` operations rather than through a crosswalk hard-coded into the transformation, and requiring that the provenance and vocabulary release of any static crosswalk be recorded where one is used instead. |
| Added a new subsection on assigning a general Type Concept when the source lacks sufficient context to identify a specific one, rather than inferring a specific type concept that the source did not support. |
| Clarified that this guide does not publish official ConceptMap artifacts for code-to-concept translation (as distinct from the example/testing ConceptMaps listed under Technical Artifacts), since such a map would be a snapshot of the OHDSI Vocabularies that begins diverging immediately upon publication. |

#### Structure Maps & Logical Models

| Summary |
|------|
| Added a new `RecordSet` logical model and associated `StructureMap-RecordSetMap` ("Bundle Mapping"), enabling a single transformation to produce a set of related OMOP records for a patient (used in FHIR Bundle transformation and in the Blood Pressure Vital Signs mapping, where one Observation produces multiple Measurement records). |
| Reorganized the FSH source tree, moving individual OMOP table logical models into an `input/fsh/OMOPModels` subdirectory. |
| Updated the Blood Pressure Vital Signs, Person, and Encounter/Visit StructureMaps and their narrative introductions to reflect corrected mappings, including id-mapping support and patient-id collection in the RecordSet mapping. |
| Added new example ConceptMaps for allergy category/substance/intolerance codes, blood pressure codes, condition concepts and status, encounter admission source/class/discharge disposition, immunization source/route/vaccine codes, and vital sign codes, explicitly noting these are intentionally sparse and used to support StructureMap testing rather than as official code-to-concept crosswalks. |
| Added guidance that a Transformation Engine may either execute the published StructureMaps or implement equivalent logic in another technology, provided any departure from the published logic and its rationale is recorded in the ETL documentation. |
| Renamed "Medication Mapping" to "Medication Statement Mapping" in the Technical Artifacts listing to reflect that MedicationRequest is treated as out of scope for drug_exposure mapping. |

#### Type Concepts

| Summary |
|------|
| Added a "When Source Context Is Insufficient" subsection to Coded Field Mapping Principles, directing implementers to select a more general Type Concept rather than guess a specific one when the source lacks sufficient context. |
| Clarified the gender/sex concept mapping guidance on the Person StructureMap page: added a discussion of concepts 8551 ("Unknown," Gender vocabulary) and 44814653 ("Unknown," PCORNet vocabulary) sharing the same display text but differing vocabulary, domain, and Standard-concept status, and the importance of recording provenance rather than display name alone. |

#### Traceability, Reproducibility & Best Practices

| Summary |
|------|
| Added a new "Incremental Loads and Re-runs" section to Transformation Strategies and Best Practices, introducing the concept of idempotent re-processing and recommending that a transformation be able to recognize previously processed source content to avoid duplicating clinical event records. |
| Added a new "Run Metadata and Reproducibility" section requiring that each ETL run record the OMOP CDM version, OHDSI Vocabulary release, IG version, transformation software version, and execution time. |
| Added a new "Capability Declaration" section to Technical Artifacts recommending publication of a machine-readable manifest declaring which input FHIR profiles a transformation supports and which OMOP tables it populates; noted that the manifest format itself is not yet defined and is a candidate for a future version of the guide. |
| Added requirements that a Transformation Engine pass the guide's reference test suite for the transformations it claims to support, and that a Target OMOP Instance disclose which OMOP tables it populates fully, partially, or not at all. |

#### Connectathon & Tooling

| Summary |
|------|
| Added a new "FHIR to OMOP 2026 Connectathon Tooling" section documenting the three participation workflows exercised at the July 2026 Vulcan Connectathon (Working-Group reference tooling with a delegated terminology server; participant tooling with embedded local terminology; and participant tooling with a delegated conformant terminology server), and describing the reference tooling stack (matchbox, enchilada/echidna terminology services, DuckDB, and the OHDSI Data Quality Dashboard). |
| Added FHIR-to-OMOP ID conversion scripts (`fhir-id-conversion.py`, `fhir-id-omop-id.py`) to the repository. |

#### Introduction & Background

| Summary |
|------|
| Reframed the scope statement on the Use Cases page to require that an implementation declare which described use cases (or others) it supports. |
| Updated the references and citations on the Introduction and OMOP CDM background pages, correcting citation numbering and adding a reference for HL7 Vulcan. |
| Rewrote portions of the Acknowledgements/Credits page. |

#### Editorial

| Summary |
|------|
| Performed a broad editorial pass replacing ambiguous modal language ("may," "should," "could" used loosely) with more precise terms ("might," "could," "ought to,") throughout nearly every narrative page, in support of introducing the formal conformance framework. |
| Corrected miscellaneous typos and clarified wording across Coded Field Mapping, CodeableConcept Pattern, Race and Ethnicity, Modifier Extensions, and other pages. |
| Added a decision-tree diagram illustrating the six-step modifier extension evaluation process to the FHIR Modifier Extensions page, and trimmed its reference list in favor of two authoritative FHIR extensibility references. |

### Version 1.0.0

Here are all of the changes made to the balloted version for Version 1.0.0.

#### Terminology & Concept Mapping

| Jira | Summary |
|------|---------|
| [FHIR-52777](https://jira.hl7.org/browse/FHIR-52777) | Added guidance on navigating concept relationships beyond parent/child (e.g., other RxNorm relationships) to locate a standard code when a direct `Maps to` relationship is unavailable; updates made to the Coding Field Mapping Principles page. |
| [FHIR-52597](https://jira.hl7.org/browse/FHIR-52597) | Added a note directing implementers to the OHDSI Vocabulary Working Group when a source code maps to multiple standard OMOP concepts, as this represents a CDM constraint issue outside the scope of this IG. |
| [FHIR-52550](https://jira.hl7.org/browse/FHIR-52550) | Added guidance for populating Race & Ethnicity in OMOP CDM, including an OHDSI Standardized Vocabularies value set (maintained by the OHDSI EHR WG) and reference to Themis guidance for multiple race records. |
| [FHIR-51585](https://jira.hl7.org/browse/FHIR-51585) | Replaced fragile display-name SQL query (`concept_name LIKE '%Penicillin G%'`) for value-as-concept resolution with a deterministic three-step pattern using the OMOP `concept_relationship` table (`Maps to` and `Maps to value` relationships); original query retained as a marked anti-pattern. |
| [FHIR-51584](https://jira.hl7.org/browse/FHIR-51584) | Corrected invalid SNOMED example code on the value-as-concept page from `294930007` to `294499007` (Allergy to benzylpenicillin). |

---

#### Structure Maps

| Jira | Summary |
|------|---------|
| [FHIR-52781](https://jira.hl7.org/browse/FHIR-52781) | Updated StructureMaps to be more complete and to include terminology mapping, addressing prior structural mapping errors and misleading content. |
| [FHIR-52774](https://jira.hl7.org/browse/FHIR-52774) | Added a clear warning banner above draft StructureMaps stating they should not be treated as authoritative guidance, particularly where they contradict the richer narrative mappings. |
| [FHIR-52549](https://jira.hl7.org/browse/FHIR-52549) | Updated StructureMaps to reflect use of FHIR terminology server operations (`CodeSystem$lookup`, `CodeSystem$validate-code`, `ConceptMap$translate`) for resolving OMOP `concept_id` targets during transformation. |
| [FHIR-52496](https://jira.hl7.org/browse/FHIR-52496) | Investigated adding section headers on the StructureMap narrative content tabs to improve readability; changes applied where supported by the HL7 IG template. |
| [FHIR-52495](https://jira.hl7.org/browse/FHIR-52495) | Updated the medication StructureMap to include dosage mapping, aligning it with the Core Field Mappings narrative. |
| [FHIR-52015](https://jira.hl7.org/browse/FHIR-52015) | Corrected source_value mappings in Observation StructureMaps; `measurement_source_value` and `observation_source_value` are now populated from `src.code` rather than `src.issued` or `src.note`. |
| [FHIR-52014](https://jira.hl7.org/browse/FHIR-52014) | Removed incorrect `*_source_concept_id` mappings from StructureMaps for procedures, immunization-to-drug-exposure, encounter-to-visit-occurrence, and allergy-to-observation. |
| [FHIR-52012](https://jira.hl7.org/browse/FHIR-52012) | Added concept mapping functions and inline comments to StructureMaps; includes guidance on handling failed lookups or null `concept_id` results. |
| [FHIR-52010](https://jira.hl7.org/browse/FHIR-52010) | Enhanced StructureMaps and narrative guidance to address required fields (`person_id`, domain primary key, type concept ID); expanded discussion of the PK/FK tracking challenge across patient records. |
| [FHIR-51995](https://jira.hl7.org/browse/FHIR-51995) | Added guidance on domain assignment logic in Observation StructureMaps, using `Observation.category` to differentiate between records destined for the Measurement vs. Observation OMOP table. |
| [FHIR-51994](https://jira.hl7.org/browse/FHIR-51994) | Added new Vital Signs StructureMaps, including a Simple Vital Signs mapping for quantity-based vitals and a dedicated Blood Pressure mapping for the composite vital sign. |
| [FHIR-51673](https://jira.hl7.org/browse/FHIR-51673) | Fixed type misuse in the ConditionEra StructureDefinition; `condition_era_end_date` corrected from `code` to `date` type. |

---

#### Mapping Language & Guidance

| Jira | Summary |
|------|---------|
| [FHIR-52596](https://jira.hl7.org/browse/FHIR-52596) | Added a new dedicated page covering FHIR modifier extensions and the considerations implementers need to be aware of to avoid misinterpreting FHIR data in OMOP. |
| [FHIR-52595](https://jira.hl7.org/browse/FHIR-52595) | Updated the temporal precision section (now §4.4) to more fully address FHIR's flexible ISO 8601-based date/datetime encodings and OMOP's optional datetime fields as a less-lossy alternative. |
| [FHIR-52592](https://jira.hl7.org/browse/FHIR-52592) | Added a brief description of "type" concepts where first mentioned in §3.3, along with a forward reference to the full explanation in §5.5. |
| [FHIR-52591](https://jira.hl7.org/browse/FHIR-52591) | Improved identifier management language in §§4.1.1, 4.1.2, and 14.27.2; introduced consistent use of "logical identifier" vs. "business identifier" with clarification that FHIR `identifier` fields are business data, not primary keys. |
| [FHIR-52202](https://jira.hl7.org/browse/FHIR-52202) | Added explicit statement that FHIR date and datetime values are based on the ISO 8601 standard. |
| [FHIR-52201](https://jira.hl7.org/browse/FHIR-52201) | Updated OMOP extension workaround language to also acknowledge the option of creating specific OMOP extensions for relevant FHIR elements, while noting the limitations of non-standard CDM implementations. |
| [FHIR-52198](https://jira.hl7.org/browse/FHIR-52198) | Reworded description of Vulcan FHIR Accelerator contributions to reference "real world data (RWD) in clinical and translational research." |
| [FHIR-52047](https://jira.hl7.org/browse/FHIR-52047) | Reorganized the introduction by splitting it into a project-focused landing page and a separate OHDSI/OMOP background page; the IG's purpose is now more prominently featured. |
| [FHIR-51838](https://jira.hl7.org/browse/FHIR-51838) | Added guidance on using `Immunization.primarySource` to inform the selection between Drug Exposure and Observation table transformation in the dual-table approach. |
| [FHIR-51809](https://jira.hl7.org/browse/FHIR-51809) | Fixed merged figure header in the FHIR to OMOP Mapping Pattern section (now §8.1); figure title and section heading are now properly separated. |
| [FHIR-51807](https://jira.hl7.org/browse/FHIR-51807) | Clarified that the FHIR to OMOP Transformation for AI use case is a forward-looking target, not a completed implementation; modal language (e.g., "can," "could") revised to explicitly signal future or conditional applicability. |
| [FHIR-51806](https://jira.hl7.org/browse/FHIR-51806) | Updated description of the Vulcan RWD IG to accurately reflect its iterative, proof-of-concept nature rather than overstating it as a comprehensive solution. |
| [FHIR-51805](https://jira.hl7.org/browse/FHIR-51805) | Revised language around ClinicalTrials.gov studies cited in §2.2.1 to clarify that they informed Vulcan RWD IG scoping decisions rather than implying they were operationally executed using the IG. |
| [FHIR-51743](https://jira.hl7.org/browse/FHIR-51743) | Updated FHIR Resource and OMOP table names in the AI transformation figure to use exact, standard terminology; added a formal "Figure #" designation to the figure caption. |
| [FHIR-51676](https://jira.hl7.org/browse/FHIR-51676) | Added an amendment to the Condition Era table description addressing conditional date constraints (start date ≤ end date) for temporal consistency. |
| [FHIR-51583](https://jira.hl7.org/browse/FHIR-51583) | Corrected misuse of `qualifier_source_value` as a generic metadata tag throughout the CodeableConcept Mapping Patterns page; `*_source_value` fields now reflect the original source code or identifier. |
| [FHIR-51582](https://jira.hl7.org/browse/FHIR-51582) | Removed invalid `qualifier_source_value` column from `condition_occurrence` SQL example; this column does not exist in the OMOP CDM `condition_occurrence` table. |
| [FHIR-51552](https://jira.hl7.org/browse/FHIR-51552) | Removed `qualifier_source_value` from all SQL examples and field mapping tables where it was used as a metadata/tag column; added a clarifying note on its CDM-defined purpose. |

---

#### Introduction & Background

| Jira | Summary |
|------|---------|
| [FHIR-52743](https://jira.hl7.org/browse/FHIR-52743) | Recreated the RWD Conceptual Application diagram in §2.2.1 without a specific reference to MedMorph, as that project may be deprecated. |
| [FHIR-52600](https://jira.hl7.org/browse/FHIR-52600) | Corrected multiple instances of "Person Resource" to "Patient Resource" on the FHIR Patient mapping page. |
| [FHIR-52048](https://jira.hl7.org/browse/FHIR-52048) | Corrected contributor affiliation in the Acknowledgements section from "National Committee for Quality Assurance" to "IPRO." |

---

#### Technical Corrections

| Jira | Summary |
|------|---------|
| [FHIR-52718](https://jira.hl7.org/browse/FHIR-52718) | Fixed typo "approrpoate" → "appropriate"; added the date of the final ICD-9 update. |
| [FHIR-52699](https://jira.hl7.org/browse/FHIR-52699) | Replaced unclear term "Missiness" with appropriate wording. |
| [FHIR-52598](https://jira.hl7.org/browse/FHIR-52598) | Corrected `Condition.assertedDate` → `Condition.recordedDate`; `assertedDate` is only available as an extension, not a core Condition field. |
| [FHIR-51993](https://jira.hl7.org/browse/FHIR-51993) | Fixed general spelling and grammar errors throughout the IG. |
| [FHIR-51837](https://jira.hl7.org/browse/FHIR-51837) | Fixed multiple typos across pages: extraneous period in `index.html`, "transofmrtaion" → "transformation" in `F2OGeneralIssues.html`, "thast" → "that" in `CodeableConceptPattern.html`, and awkward phrasing in `StructureMap-ImmunizationMap.html`. |
| [FHIR-51808](https://jira.hl7.org/browse/FHIR-51808) | Fixed section heading "Missiness" → "Missingness" in §3.3. |
| [FHIR-51674](https://jira.hl7.org/browse/FHIR-51674) | Fixed missing space in "very firstchronologically" → "very first chronologically" in the ConditionEra profile. |

