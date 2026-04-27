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

