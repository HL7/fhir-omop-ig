### Identifiers, De-identification & Privacy

Transforming FHIR resources to OMOP presents challenges in identifier management. FHIR resources utilize complex, non-integer identifiers that link discrete data across systems and support clinical workflows, while the OMOP CDM employs integer-based keys designed for de-identified research data with `person_id` serving as the primary linking mechanism across clinical domains. The core challenge is balancing OMOP's de-identification requirements with business needs for traceability and audit capabilities.

#### Identifier Management

##### Understanding FHIR Identifier Types

FHIR resources carry two fundamentally different types of identifiers that serve distinct purposes and must be handled separately when transforming to OMOP. Conflating them is a common source of implementation errors.

| FHIR Element | Term Used in This IG | Role |
|---|---|---|
| `Resource.id` | **Logical identifier** | Server-assigned primary key for the resource instance. Combined with the resource type, it forms the canonical FHIR address (e.g., `Encounter/abc-123`). Used by FHIR to locate and dereference the resource via RESTful APIs. Logical identifiers may change if a resource is migrated to a different server. |
| `Resource.identifier` | **Business identifier** | One or more data elements of type `Identifier` carried *on* the resource. Represent externally-assigned identifiers such as medical record numbers, encounter numbers, or accession numbers. These identify the real-world entity the resource describes, persist across systems, and may come from multiple different assigning authorities. FHIR itself does not use business identifiers to locate or resolve resources; they are data, not addresses. |

See the FHIR specification's authoritative reference:
[Resource Identification: Logical vs. Business Identifiers](https://hl7.org/fhir/R4/resource.html#identification)

Throughout this IG, the terms **"logical identifier"** and **"business identifier"** are used explicitly to indicate which FHIR field is being discussed. The unqualified term "identifier" is avoided where it would be ambiguous.

---

FHIR and OMOP CDM represent different approaches to data identification due to the underlying
business requirements for each.

In FHIR, **logical identifiers** (`Resource.id`) function as the RESTful primary key for each
resource instance on a given server. **Business identifiers** (`Resource.identifier`) carry
externally-assigned identification data, such as facility-assigned encounter numbers or
medical record numbers, and are simply data elements on the resource. A single resource may
carry multiple business identifiers from different assigning systems.

In OMOP, identifiers establish relationships between tables using integer-based keys, with no
fields intended to contain patient identifiable information (PII) such as medical record numbers,
names, or addresses. Transformation between FHIR and OMOP creates tension between competing
requirements: maintaining data provenance for operational needs while preserving OMOP's
de-identification principles.

Many OMOP implementations reside within system architectures that have business requirements
for re-identification, audit capabilities, or other use cases where maintaining traceability
from OMOP back to the FHIR source is needed.

---

##### Deriving OMOP Primary Keys from FHIR Source Data

When implementers need to derive OMOP integer primary keys (e.g., `visit_occurrence_id`,
`condition_occurrence_id`) from FHIR source data, the FHIR **logical identifier** (`Resource.id`
combined with the resource type) is the more semantically appropriate FHIR field to consider.
The FHIR logical identifier is the server-assigned primary key for that resource instance and
most closely parallels the role of an OMOP `_id` field.

**Important caveats for this approach:**

- FHIR logical identifiers are strings (up to 64 characters; often UUIDs or other non-numeric
  formats) and cannot be stored directly as OMOP integers. A transformation step is required,
  such as consistent hashing or surrogate key generation.
- FHIR logical identifiers are server-scoped and **may change** if a resource is migrated to a
  different FHIR server, which can create instability in ETL pipelines that ingest data from
  multiple sources or over time.
- OMOP implementations most commonly use auto-generated integer sequences for `_id` fields,
  independent of any FHIR identifier.

For these reasons, maintaining a **separate external mapping table** (linking OMOP-generated IDs
to originating FHIR logical identifiers, `[ResourceType]/[Resource.id]`) remains the recommended
general approach for traceability. See the Decision Framework below.

**FHIR business identifiers** (`Resource.identifier`) are **not** appropriate sources for OMOP
primary key derivation. They are externally-assigned data elements, not the FHIR system's primary
key. In addition, they frequently contain PII and have variable format and length that may not
be compatible with OMOP integer key fields.

---

##### Decision Framework for Identifier Management

There is no single approach that can be uniformly applied to transformation of FHIR identifiers
to OMOP. Rather, implementers must evaluate FHIR identifiers systematically using criteria
relevant to the use case(s) an OMOP database must support. The first step is always to determine
**which type of FHIR identifier** is being considered.

**Evaluation criteria:**

1. **Identifier type**: Is this a FHIR logical identifier (`Resource.id`) or a business
   identifier (`Resource.identifier`)? These require different handling strategies.
2. **Research purpose**: What research the OMOP instance is intended to support.
3. **Identifier role**: Purpose and role of the identifier in the source system.
4. **Clinical significance**: Whether the identifier may inform clinical facts in the
   observational data store.
5. **Format constraints**: Length and format of the identifier.
6. **Privacy assessment**: Whether the identifier contains or enables derivation of PII.
7. **Technical feasibility**: Whether the identifier can be safely stored within OMOP constraints.
8. **Compliance impact**: What regulatory obligations identifier retention creates.

Based on this evaluation, implementers should categorize FHIR identifiers into one of three
handling approaches:

| Strategy | Applicable Identifier Type | Use Case | Implementation Approach | Key Considerations |
|---|---|---|---|---|
| **Surrogate Key Mapping** | Logical identifier (`Resource.id`) | When traceability from OMOP records back to specific FHIR resource instances is required | Generate OMOP integer primary keys using auto-increment or sequences; maintain a separate external mapping table linking `[ResourceType]/[Resource.id]` to the OMOP-generated ID | • FHIR logical IDs are strings and must be transformed; direct integer mapping is not possible for UUID-format IDs • Logical IDs may change on server migration, so design the mapping table accordingly • No PII risk for server-generated logical IDs, but verify for any implementation that uses business IDs as logical IDs |
| **External Storage** | Business identifier (`Resource.identifier`) | Business identifiers needed for traceability but inappropriate for direct OMOP inclusion | Create separate mapping tables linking OMOP-generated IDs to original FHIR business identifiers | • Maintains de-identification principles • Requires access controls and audit trails • Supports bidirectional mapping verification • Preserves data provenance • Business identifiers frequently contain PII (MRNs, etc.) and must be handled accordingly |
| **Exclusion** | Business identifier (`Resource.identifier`) | Identifiers containing PII or serving no research purpose | Exclude from transformation entirely | • Medical record numbers • Patient names or contact information embedded in identifier values • Other PII-containing identifiers • Identifiers with no research value |

> **Note:** Using OMOP `_source_value` fields (e.g., `visit_source_value`) to store FHIR
> business identifiers is **not recommended**. These fields are intended to hold source system
> descriptions or coded values for the clinical concept, not business identifier strings.
> Repurposing them for identifier storage misrepresents their intended function and may
> compromise de-identification. See [Why `_source_value` Fields Are Not Appropriate for FHIR Identifier Storage](#why-_source_value-fields-are-not-appropriate-for-fhir-identifier-storage) for further discussion.

#### Privacy and De-identification Considerations
A primary concern when implementing FHIR to OMOP transformations is the potential compromise of de-identification when identifier data from source FHIR resources is carried forward into OMOP. This concern applies primarily, but not exclusively, to FHIR **business identifiers** (`Resource.identifier`), as these commonly carry externally-assigned values that may constitute or enable derivation of PII (e.g., medical record numbers, facility encounter IDs, insurance member numbers). OMOP is not designed to support business identity management use cases, and its de-identification model is a cornerstone of its design for research and analytics.

FHIR **logical identifiers** (`Resource.id`) are server-generated and are generally less directly PII-bearing. However, depending on the implementation, logical IDs may be set to values that mirror business identifiers (e.g., some FHIR servers expose a patient MRN as the `Patient.id`). Implementers should verify the nature of logical ID values in their specific source environment before assuming they are safe to carry forward in any form.

##### Why `_source_value` Fields Are Not Appropriate for FHIR Identifier Storage

A pattern sometimes seen in FHIR-to-OMOP implementations is mapping FHIR business identifiers directly to OMOP `_source_value` fields (e.g., mapping `Encounter.identifier` to `visit_source_value`). This approach is **not recommended** for several reasons:

1. **Semantic mismatch**: OMOP `_source_value` fields are designed to hold a human-readable or
   coded representation of the clinical concept from the source system: for example, the
   encounter type code or description as it appeared in the source EHR. They are not designed
   to hold business identifier strings such as encounter IDs or UUIDs.

2. **De-identification risk**: FHIR business identifiers (`Resource.identifier`) frequently
   contain or are directly traceable to PII. Storing them in `_source_value` fields, which are
   commonly retained in OMOP databases used for research, may compromise the de-identification
   of the dataset.

3. **Format constraints**: OMOP `_source_value` fields are typically `VARCHAR(50)`. FHIR
   business identifiers may exceed this length, particularly when they contain GUIDs, fully
   qualified system URIs, or composite identifier values.

4. **Multiple values**: A single FHIR resource may carry multiple business identifiers from
   different assigning systems. OMOP's single `_source_value` field cannot represent this
   multiplicity without lossy concatenation.

##### Recommended Approach: External Mapping Table

The recommended approach for preserving traceability from OMOP records back to their FHIR source is to maintain a **separate external mapping table** outside the core OMOP schema. This table links OMOP-generated integer IDs to the originating FHIR resource information without introducing identifier data into the OMOP tables themselves.

A minimal mapping table structure might record:

- The OMOP table and generated ID (e.g., `visit_occurrence_id = 10042`)
- The FHIR resource type and logical identifier (e.g., `Encounter/abc-123`): this is the
  **logical identifier** (`ResourceType/Resource.id`), which is the FHIR primary key
- Optionally, selected FHIR **business identifiers** (`Encounter.identifier`) where retention
  is justified and compliant with de-identification requirements, held under appropriate
  access controls

This approach accommodates the complexities of identifier handling for provenance and
traceability without:

- Compromising OMOP de-identification and usability standards
- Disrupting the OMOP schema
- Violating de-identification protocols
- Misrepresenting the semantics of OMOP fields

The access controls on that table warrant specific attention, because the table is the
re-identification key. A party holding both the mapping table and the OMOP instance can reverse the
de-identification that the transformation was designed to achieve, which means the two must not sit
behind the same control boundary. Access to the mapping table should therefore be governed
separately from access to the research database: a different grant, a different approval path, and
an audit trail recording who resolved which records and when. Where the same team administers both,
the separation is procedural rather than technical, and the ETL documentation should say so plainly
rather than implying a stronger control than exists.

##### De-identification Assessment by Identifier Type

The following table summarizes the de-identification risk profile and recommended handling for
each FHIR identifier type:

| FHIR Identifier Type | FHIR Element | De-identification Risk | Recommended Handling |
|---|---|---|---|
| **Logical identifier** | `Resource.id` | Generally lower: server-generated; typically not PII, but verify against source implementation | Use as the traceability key in an external mapping table; do not store directly in OMOP primary key or `_source_value` fields |
| **Business identifier** | `Resource.identifier` | Higher: frequently contains MRNs, encounter numbers, insurance IDs, or other externally-assigned values that may constitute PII | Evaluate each identifier system individually using the [Decision Framework for Identifier Management](#decision-framework-for-identifier-management); store in external mapping table under access controls, or exclude entirely if PII risk cannot be managed |

##### Compliance Considerations

Implementers should conduct a formal privacy and regulatory assessment before deciding how to handle any FHIR identifier data in an OMOP implementation. Relevant frameworks include:

- **HIPAA Safe Harbor and Expert Determination methods** (where applicable), which define which
  types of identifiers must be removed to achieve de-identification
- **Institutional data governance policies** regarding linkage tables and re-identification risk
- **GDPR or other applicable privacy regulations** in non-US contexts

The key principle is that OMOP databases intended for research should not contain data elements that enable re-identification of individuals, whether through direct PII or through linkage to
external datasets. FHIR business identifiers pose a higher risk on this dimension and require careful evaluation.

Stated as a property of the result rather than as a principle for implementers, this means a
conformant Target OMOP Instance contains no patient identifiable information: no names, no
addresses, no medical record numbers, no contact details, in any field. The property is checkable
by inspection of the database, independently of the pipeline that populated it, and it holds
whether the PII would have arrived through a business identifier carried into a `_source_value`
field, through a logical identifier that mirrors an MRN, or through any other route. An instance
that fails this check is non-conformant regardless of how carefully the transformation that built
it was designed.

##### Legal Basis for Data Access

Distinct from the privacy assessment above is the question of the instrument under which the data
were obtained in the first place. This is not an identifier question, and it governs the whole
transformation rather than the handling of any particular field. It appears here because identifier
retention is the point at which the legal basis most often becomes operationally consequential: the
terms of a data use agreement or an IRB protocol frequently determine whether a linkage table may
be maintained at all, how long it may persist, and who may resolve it.

An Implementer should therefore record the legal instrument governing access to the source FHIR
data alongside the ETL documentation. Depending on jurisdiction and relationship, this may be a
business associate agreement, an IRB approval or waiver, a data use agreement, an institutional
data governance approval, or an equivalent instrument outside the US frameworks named above. What
matters is that the instrument is identified rather than assumed, and that any constraint it places
on identifier retention, linkage, or re-identification is recorded where the people operating the
transformation will encounter it.

#### Guidance

A Transformation Engine SHALL NOT store FHIR business identifier values (`Resource.identifier`) in
OMOP `_source_value` fields, and a Target OMOP Instance SHALL NOT contain business identifier
values in those fields. (f2o-020)

A Transformation Engine SHALL NOT derive OMOP integer primary keys from FHIR business identifiers
(`Resource.identifier`). Where primary keys are derived from FHIR source data rather than generated
independently, the FHIR logical identifier (`Resource.id` combined with the resource type) is the
appropriate source. (f2o-021)

A Target OMOP Instance SHALL NOT contain patient identifiable information, including names,
addresses, medical record numbers, and contact details, in any field. (f2o-022)

An Implementer SHOULD maintain an external mapping table linking OMOP-generated identifiers to the
originating FHIR logical identifier (`[ResourceType]/[Resource.id]`) where traceability from OMOP
records back to source resources is required. (f2o-023)

Where an external mapping table is maintained, it SHALL reside outside the OMOP schema and SHALL be
governed by access controls distinct from those governing the OMOP instance itself. (f2o-024)

An Implementer SHALL document a privacy and regulatory assessment for each identifier system
encountered in the source data, identifying the framework applied, whether HIPAA Safe Harbor,
Expert Determination, GDPR, or an equivalent, and the determination reached. (f2o-025)

An Implementer SHALL document, for each identifier system encountered, which handling strategy was
applied, whether surrogate key mapping, external storage, or exclusion, and record that
determination in the ETL documentation. (f2o-026)

An Implementer SHALL document the legal instrument governing access to the source FHIR data,
whether a business associate agreement, an IRB approval or waiver, a data use agreement, or an
equivalent, together with any constraint it places on identifier retention, linkage, or
re-identification. (f2o-132)

