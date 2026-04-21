### Populating Race and Ethnicity in the OMOP CDM

Race and ethnicity are among the most consistently requested demographic attributes in observational research, and they are also among the most structurally constrained fields in the OMOP CDM. The `PERSON` table provides exactly one `race_concept_id` and one `ethnicity_concept_id` slot per person, whereas FHIR source systems commonly carry multiple race or ethnicity codings — either because a patient self-identifies with more than one category, because the source system captures values from multiple encounters, or because the source system uses a coding system with finer granularity than the OMOP target vocabulary. Transforming FHIR race and ethnicity data to OMOP therefore requires both a vocabulary decision (which target concepts to use) and a structural decision (where to place values that do not fit into the single-slot `PERSON` fields). This page describes the patterns the IG recommends for both.

### Overview

The OMOP CDM treats race and ethnicity as single-valued demographic attributes on the `PERSON` table, populated from a controlled set of Standard concepts in the OHDSI Standardized Vocabularies. When a FHIR source carries a single race value and a single ethnicity value per person, transformation is a direct lookup into the OHDSI Standardized Vocabularies. When a FHIR source carries more than one race value per person, the CDM's single-slot structure is preserved by populating `PERSON.race_concept_id` with a designated "more than one race" concept and by capturing each individual race value as a record in the `OBSERVATION` table using the [Value-as-Concept Pattern](ValueAsConceptPattern.html). When a FHIR source carries more than one ethnicity value per person, a structurally parallel pattern applies. Both patterns follow the ratified OHDSI Themis convention for [handling multiple races or ethnicities per person](https://ohdsi.github.io/Themis/multiple_races_per_person.html) and preserve full downstream analytic access to the individual values while keeping `PERSON` compliant with CDM structural rules.

### OMOP Target Fields and Standard Concepts

The primary target fields for demographic race and ethnicity in the CDM are `PERSON.race_concept_id` and `PERSON.ethnicity_concept_id`. Source values are retained for lineage in `PERSON.race_source_value` and `PERSON.race_source_concept_id` (and the corresponding `ethnicity_source_*` fields), following the source-preservation guidance in [Transformation Strategies & Best Practices](StrategiesBestPractices.html#source-value-preservation).

The Standard concepts most commonly encountered when populating these fields are:

| Purpose | `concept_id` | Concept Name | Vocabulary / Domain |
| --- | --- | --- | --- |
| Individual race value | 8515 | Asian | Race |
| Individual race value | 8516 | Black or African American | Race |
| Individual race value | 8527 | White | Race |
| Individual race value | 8657 | American Indian or Alaska Native | Race |
| Individual race value | 8557 | Native Hawaiian or Other Pacific Islander | Race |
| "More than one race" sentinel | 1546847 | More than one race | Race |
| Individual ethnicity value | 38003563 | Hispanic or Latino | Ethnicity |
| Individual ethnicity value | 38003564 | Not Hispanic or Latino | Ethnicity |
| Observation concept used in `OBSERVATION.observation_concept_id` when splitting multiple races or ethnicities | 4013886 | Race | SNOMED |
| Unmapped / absent | 0 | No matching concept | — |

The authoritative, balloted binding for this IG is the OHDSI Race and Ethnicity Value Set described in the next section; the table above identifies the most commonly populated Standard concepts within that value set but is not a substitute for the value set itself. A complete, current listing of Standard race and ethnicity concepts is available through [Athena](https://athena.ohdsi.org/) by filtering on `domain_id = 'Race'` or `domain_id = 'Ethnicity'` with `standard_concept = 'S'`.

### Value Set Binding

This IG binds race and ethnicity transformation to the OHDSI Race and Ethnicity Value Set, developed and maintained by the OHDSI EHR Working Group and included in this IG as the example value set suitable for International Realm use. The value set draws its content from the `Race` and `Ethnicity` domains of the OHDSI Standardized Vocabularies and is intended to support implementations that must represent race and ethnicity across jurisdictions without being tied to a single country's regulatory categories. Implementations whose sources use a narrower or jurisdiction-specific code system — for example, US Core's CDC Race & Ethnicity codings — should translate into the bound value set via the OHDSI Standardized Vocabularies and document the chosen translation in their ETL documentation, per the [Source Value Preservation](StrategiesBestPractices.html#source-value-preservation) and [ETL Documentation](StrategiesBestPractices.html#etl-documentation) guidance.

The binding strength for `PERSON.race_concept_id` and `PERSON.ethnicity_concept_id` transformation targets is *extensible*: implementations should use a concept from this value set whenever the source value maps to one, and may use other Standard concepts from the OHDSI `Race` or `Ethnicity` domains when no concept in the value set fits. Where no suitable Standard concept exists at all, follow the [Unmapped Source Values](#unmapped-source-values) guidance.

### FHIR Source Patterns

Race and ethnicity in FHIR are most commonly carried as extensions on the `Patient` resource rather than as first-class elements, because the base FHIR `Patient` resource does not define race or ethnicity fields directly. Implementers will encounter several source patterns:

* **US Core `us-core-race` and `us-core-ethnicity` extensions** — structured extensions that carry one or more `ombCategory` codings and an optional `text` value, using the CDC Race & Ethnicity code system. Each `ombCategory` occurrence represents one self-identified race or ethnicity.
* **IPS and other International Patient profiles** — may carry race and ethnicity through locally defined extensions or not at all, depending on jurisdiction.
* **Jurisdictional profiles** — national or regional Patient profiles (for example, AU Core, CA Core+) typically define their own race/ethnicity extensions bound to locally appropriate code systems.
* **Patient-provided or survey-sourced values** — may arrive as `Observation` resources rather than `Patient` extensions, particularly when captured outside the EHR registration workflow.

Regardless of the source pattern, the transformation logic is driven by *how many* race values and *how many* ethnicity values resolve to Standard OMOP concepts for a given person, not by the FHIR element through which they were carried.

### Single-Value Transformation

When a FHIR source contributes exactly one Standard-resolving race value for a person, populate `PERSON.race_concept_id` directly with that concept. Apply the same rule independently to ethnicity via `PERSON.ethnicity_concept_id`. In both cases, preserve the original source code in `PERSON.race_source_value` / `PERSON.ethnicity_source_value` and, where a non-Standard OMOP concept exists for the source code, populate `PERSON.race_source_concept_id` / `PERSON.ethnicity_source_concept_id`; otherwise, set the source_concept_id to `0`.

For example, a FHIR `Patient` carrying a single `us-core-race` extension with `ombCategory` code `2054-5` ("Black or African American") yields `PERSON.race_concept_id = 8516`. A FHIR `Patient` carrying a single `us-core-ethnicity` extension with `ombCategory` code `2135-2` ("Hispanic or Latino") yields `PERSON.ethnicity_concept_id = 38003563`.

### Multiple-Value Transformation — Race

When a FHIR source contributes more than one Standard-resolving race value for a person — whether because the source carries multiple `ombCategory` occurrences in a single extension, because multiple encounters recorded different values, or because the source system expresses a multi-racial identity through separate codings — the transformation follows the Themis convention:

1. Populate `PERSON.race_concept_id` with concept `1546847` ("More than one race"). This preserves the CDM's single-slot structure while signalling to downstream consumers that granular values are available elsewhere.
2. For each distinct Standard race concept contributed by the source, create one record in the `OBSERVATION` table with:
   * `observation_concept_id = 4013886` ("Race")
   * `value_as_concept_id` = the Standard concept for the individual race (for example, `8515` for Asian, `8527` for White)
   * `person_id` = the `PERSON.person_id` of the subject
   * `observation_date` populated according to [Observation Date Selection](#observation-date-selection) below
   * `observation_type_concept_id` populated with the appropriate type concept for the provenance of the record (see [Type Concepts in the OMOP Common Data Model](codemappings.html#type-concepts-in-the-omop-common-data-model))

Create as many `OBSERVATION` rows as there are distinct Standard race concepts for the person. This is a direct application of the [Value-as-Concept Pattern](ValueAsConceptPattern.html) and is the same structural pattern used elsewhere in the CDM for multi-valued categorical attributes.

### Multiple-Value Transformation — Ethnicity

The OHDSI Standardized Vocabularies currently populate the `Ethnicity` domain with two Standard concepts — `38003563` ("Hispanic or Latino") and `38003564` ("Not Hispanic or Latino") — reflecting the binary ethnicity model inherited from US regulatory categories. In that binary model, a person cannot meaningfully carry more than one Standard-resolving ethnicity value, and multi-ethnicity situations therefore arise primarily from source systems that use a richer ethnicity code system than the CDM's target domain.

When a FHIR source carries more than one Standard-resolving ethnicity value for a person, apply the structural parallel to the race pattern:

1. Populate `PERSON.ethnicity_concept_id` with `0` ("No matching concept"), because no "more than one ethnicity" sentinel currently exists in the `Ethnicity` domain. This is the correct value to use until such a sentinel is introduced; do not select one of the valid ethnicity values arbitrarily, as this would silently discard the remaining values.
2. For each distinct Standard-resolving source value, create one record in the `OBSERVATION` table with:
   * `observation_concept_id = 4013886` ("Race") — note that Themis uses this single observation concept to split both race and ethnicity records, reflecting the CDM's current vocabulary structure.
   * `value_as_concept_id` = the Standard concept for the individual ethnicity value
   * `person_id` = the `PERSON.person_id` of the subject
   * `observation_date` populated according to [Observation Date Selection](#observation-date-selection) below
   * `observation_type_concept_id` populated with the appropriate type concept for the provenance of the record

Preserve the full set of source ethnicity values in `PERSON.ethnicity_source_value` for lineage, per the [Source Value Preservation](StrategiesBestPractices.html#source-value-preservation) guidance, regardless of how the Standard values are ultimately distributed across `PERSON` and `OBSERVATION`.

### Handling Flavors of Null

Source values that are semantic equivalents of null — such as "unknown," "unspecified," "declined to answer," "patient refused," "not recorded," or "asked but unknown" — must not be carried into the CDM as if they were valid race or ethnicity values. This prevents flavors of null from polluting analytic denominators and aligns with the OHDSI Vocabulary principle that Standard concepts do not represent flavors of null. Apply the following rules:

* If a person has **only** flavor-of-null source values for race, set `PERSON.race_concept_id = 0`. Apply the same rule independently to ethnicity.
* If a person has **one valid** Standard-resolving source value **and one or more flavor-of-null** source values for race, ignore the flavor-of-null values and populate `PERSON.race_concept_id` with the single valid concept. Do not treat this as a multiple-value case. Apply the same rule independently to ethnicity.
* If a person has **more than one valid** Standard-resolving source value **and one or more flavor-of-null** source values, ignore the flavor-of-null values and apply the multiple-value transformation appropriate to the attribute to the valid values only.

In all three cases, the original source values — including the flavor-of-null values — should still be preserved verbatim in `PERSON.race_source_value` / `PERSON.ethnicity_source_value` for lineage, per the [Source Value Preservation](StrategiesBestPractices.html#source-value-preservation) guidance.

### Observation Date Selection

When multiple-value transformation creates records in the `OBSERVATION` table, `OBSERVATION.observation_date` must be populated — the CDM does not permit null dates, and default dates far in the past or future are not acceptable because they distort observation periods. Select the date using the following precedence:

1. If the FHIR source provides a date on which the race or ethnicity value was recorded (for example, a `Patient.extension` with an embedded `period`, or a dated `Observation` resource carrying the value), use that date.
2. Otherwise, if the FHIR source provides a date for the encounter or visit during which the value was captured, use that date.
3. Otherwise, use the date of the person's most recent visit in the source data. This is the Themis-recommended fallback when no other date is available; it is not perfect, but it avoids the analytic harm caused by sentinel or default dates.

Document the date-selection rule actually used in each transformation in the ETL documentation, so that downstream consumers can interpret the `observation_date` values correctly.

### Unmapped Source Values

If a FHIR race or ethnicity source value does not resolve to a Standard concept in the OHDSI `Race` or `Ethnicity` domain, the transformation should:

1. Preserve the source code and system in `PERSON.race_source_value` / `PERSON.ethnicity_source_value`.
2. Set `PERSON.race_source_concept_id` / `PERSON.ethnicity_source_concept_id` to the non-Standard OMOP concept for the source code if one exists, or to `0` if it does not.
3. Set `PERSON.race_concept_id` / `PERSON.ethnicity_concept_id` to `0`.
4. Open a submission with the OHDSI Themis project at [https://github.com/OHDSI/Themis/issues](https://github.com/OHDSI/Themis/issues) describing the unmapped source value, so that the mapping gap can be resolved at the vocabulary level rather than worked around in local ETL. This parallels the vocabulary-anomaly reporting pathway described in [Reporting Vocabulary Anomalies to the OHDSI Vocabulary Working Group](codemappings.html#automated-and-manual-concept-mapping-support).

### Worked Example

A FHIR `Patient` carries two `us-core-race` `ombCategory` codings — `2028-9` ("Asian") and `2106-3` ("White") — and one flavor-of-null coding with `text = "Declined to answer"`. The person's most recent FHIR `Encounter` has a period starting `2024-11-03`, and no date is associated with the race extension itself.

Applying the rules above:

* Two Standard-resolving source values are present (`8515` Asian, `8527` White), so the multiple-value race transformation applies. The flavor-of-null value is ignored for concept-selection purposes but preserved in `race_source_value`.
* `PERSON.race_concept_id = 1546847` ("More than one race").
* Two `OBSERVATION` rows are created:
  * Row 1: `observation_concept_id = 4013886`, `value_as_concept_id = 8515`, `observation_date = 2024-11-03`.
  * Row 2: `observation_concept_id = 4013886`, `value_as_concept_id = 8527`, `observation_date = 2024-11-03`.
* Both `OBSERVATION` rows carry an appropriate `observation_type_concept_id` reflecting the provenance of the FHIR source (for example, an EHR-sourced value versus a patient-reported value), per [Type Concepts in the OMOP Common Data Model](codemappings.html#type-concepts-in-the-omop-common-data-model).
* `PERSON.race_source_value` preserves the concatenated original source values, including the declined-to-answer text, per the lineage guidance.
