# Considerations for Transforming Encounter Resources
Transforming FHIR Encounter resources to OMOP presents several unique challenges that require careful consideration of data semantics, structural differences, and compliance requirements. The mapping decisions made during this transformation process can significantly impact data integrity, traceability, and analytical capabilities in the target OMOP database.

## Identifier Handling for Visit Occurrence
This section addresses identifier mapping considerations specific to the `Encounter` → `visit_occurrence` transformation. For the general framework governing all identifier handling across resource types, see [Section 3.1.1 — Identifier Management](F2OGeneralIssues.html#identifier-management) and [Section 3.1.2 — Privacy and De-identification Considerations](F2OGeneralIssues.html#privacy-and-de-identitification-considerations).

### Background: FHIR Encounter Identifier Types

The FHIR `Encounter` resource exposes two distinct identifier mechanisms that must not be conflated when mapping to OMOP:

| FHIR Element | Identifier Type | Description |
|---|---|---|
| `Encounter.id` | **Logical identifier** | The server-assigned primary key for this resource instance. Together with the resource type, it forms the canonical FHIR address: `Encounter/[id]`. Used by FHIR systems to locate and dereference the resource via RESTful APIs. |
| `Encounter.identifier` | **Business identifier** | One or more externally-assigned identifiers carried as data on the resource — for example, a hospital encounter number, a visit account number, or an admissions ID. These identify the real-world encounter event and may be assigned by multiple systems. They are data elements, not the FHIR system's addressing mechanism. |

See the FHIR specification:
[Resource Identification — Logical vs. Business Identifiers](https://hl7.org/fhir/R4/resource.html#identification)

### Mapping to `visit_occurrence_id`

The `visit_occurrence_id` is the OMOP-generated integer primary key for each record in the `visit_occurrence` table. It is the mechanism by which other OMOP tables (e.g.,`condition_occurrence`, `procedure_occurrence`) link clinical events back to their associated visit.

**OMOP `visit_occurrence_id` should be generated as an auto-incremented integer sequence**, independent of any FHIR identifier value. FHIR logical identifiers (`Encounter.id`) are strings (often UUIDs or other non-numeric formats) and cannot be used directly as OMOP integer keys. FHIR business identifiers (`Encounter.identifier`) are externally-assigned data elements and are likewise not appropriate sources for OMOP primary key values.

If traceability from a `visit_occurrence` record back to its originating FHIR `Encounter` resource is required, this should be maintained in a **separate external mapping table** outside the core OMOP schema. This table should record the OMOP-generated `visit_occurrence_id` alongside the FHIR **logical identifier** for the source resource (i.e., `Encounter/[Encounter.id]`), which is the most stable and semantically correct FHIR reference for this purpose.

**Example mapping table entry:**
| omop_table | omop_id | fhir_resource_reference | notes |
|---|---|---|---|
| `visit_occurrence` | `10042` | `Encounter/abc-123` | Logical identifier — FHIR primary key |

If selected FHIR business identifiers (`Encounter.identifier`) must also be retained for operational traceability, they may be stored in this same external table under appropriate access controls, subject to de-identification assessment (see Section 3.1.2).

### Mapping to `visit_source_value`

`visit_source_value` is intended to hold a human-readable or coded representation of the **encounter type or classification** as it appeared in the source EHR — for example, the source system's code or description for inpatient, outpatient, emergency, etc.

**This field is not appropriate for storing FHIR identifier values.**

Mapping `Encounter.identifier` (a FHIR business identifier) to `visit_source_value` is a commonly seen but incorrect pattern for two reasons:

1. **Semantic mismatch**: `visit_source_value` represents source terminology for the encounter type, not an encounter identity value. Storing an encounter ID here misrepresents the field's
 purpose and may cause downstream analytic confusion.
2. **De-identification risk**: FHIR business identifiers (`Encounter.identifier`) may contain or be traceable to PII. `visit_source_value` is commonly retained in research-facing OMOP  databases, creating a de-identification risk.

The appropriate sources for `visit_source_value` are `Encounter.type`, `Encounter.class`, or equivalent source system classification fields, not `Encounter.identifier`.

### Mapping Summary Table

| OMOP Field | Appropriate FHIR Source | Notes |
|---|---|---|
| `visit_occurrence_id` | Auto-generated integer sequence | Do not derive from `Encounter.id` (logical identifier) or `Encounter.identifier` (business identifier) directly |
| `visit_source_value` | `Encounter.type` or `Encounter.class` (source code/display) | **Not** `Encounter.identifier`; see explanation above |
| *(external mapping table)* | `Encounter.id` (logical identifier) — referenced as `Encounter/[id]` | Preferred FHIR field for traceability back to source resource; maintain outside OMOP schema |
| *(external mapping table, conditional)* | `Encounter.identifier` (business identifier) | May be retained in external mapping table only; subject to de-identification assessment; not appropriate in core OMOP fields |


### Considerations for Multi-System Environments

In environments where FHIR data is aggregated from multiple source systems, the same real-world encounter may appear as multiple `Encounter` resources with different FHIR logical identifiers
(`Encounter.id`) on different servers. In these cases:

- FHIR **business identifiers** (`Encounter.identifier`) — particularly when carrying a consistent facility-assigned encounter number — may provide a more stable basis for matching
  and deduplicating `visit_occurrence` records across sources than the logical identifier.
- However, this use (matching and deduplication) is distinct from identifier storage in OMOP fields, and the matched record should still be assigned a single OMOP-generated `visit_occurrence_id`.
- The external mapping table should in this case record all source FHIR logical identifiers that contributed to a single `visit_occurrence` record, to preserve full provenance.

For general guidance on identifier evaluation criteria and handling strategies, refer to the Decision Framework in [Section 3.1.1](F2OGeneralIssues.html#decision-framework-for-identifier-management).

### Technical and Structural Limitations
Several technical constraints can impact identifier transformation:

**Data Type and Length Constraints**: OMOP database fields may have limitations that prevent the storage of certain identifier types. For example, the `visit_source_value` field's varchar(50) character limit may be insufficient for storing GUIDs or complex identifier strings that exceed this constraint.

**Contextual Ambiguity**: Identifiers in source systems may lack sufficient context to determine their meaning or appropriate usage. Simple identifier structures can be particularly ambiguous:

```json
"identifier": [
  {
    "system": "https://hospital.makedata.ai",
    "value": "b9d8ed9e-1b1a-4e30-9ee3-af66f4a61cff"
  }
]
```

**Complex Nested Structures**: FHIR identifiers can contain multiple nested elements that provide additional context but may not have direct equivalents in OMOP:

```xml
<identifier>
  <use value="official" />
  <system value="http://www.acmehosp.com/patients" />
  <value value="44552" />
  <period>
    <start value="2003-05-03" />
  </period>
</identifier>
```

## Transformation Strategies
Given the complexity and variability of identifier structures in FHIR, a standardized one-size-fits-all mapping approach to OMOP is not practical. Implementation teams should consider the following strategies:

**Case-by-Case Evaluation**: Conduct thorough analysis of available FHIR identifier elements and their semantic meaning within the source system context. This evaluation should inform the selection of appropriate target fields in OMOP while considering data integrity and compliance requirements.

**Extension Table Implementation**: Consider developing separate, extension tables specifically designed to store source identifiers. This approach preserves identifier information while maintaining the integrity of core OMOP tables and provides flexibility for complex identifier structures.

**Selective Transformation**: In some cases, the most appropriate approach may be to exclude certain identifiers from the transformation process altogether, particularly when they provide no analytical value or when technical constraints make their storage impractical.

The decision regarding which approach to adopt should be based on the specific requirements of the implementation, including analytical use cases, compliance requirements, and the technical capabilities of the target system. Each approach presents trade-offs between data preservation, system performance, and analytical utility that must be carefully weighed in the context of the overall transformation strategy.
