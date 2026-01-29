Aligning FHIR resources with the OMOP Common Data Model presents challenges due to differences in their data structures, scope, and intended purposes. The complexity increases because most observational data sources aren't natively generated as FHIR, meaning many FHIR resources have already undergone transformation before any OMOP conversion begins. This creates a need for pragmatic alignment approaches that preserve essential source data context for transactional use cases while achieving OMOP conformance for analytics. 

The tension between the the two standards stems from FHIR's design for real-time clinical data exchange and workflow support versus OMOP's structure for research analytics and retrospective analysis with standardized terminology. This divergence means that poorly considered mappings can misrepresent data, particularly given OMOP's requirements for concept standardization and validated data quality procedures that must be carefully addressed when transforming patient records from FHIR format.

### Identifiers, De-identitification & Privacy
Transforming FHIR resources to OMOP presents challenges in identifier management. FHIR resources utilize complex, non-integer identifiers that link discrete data across systems and support clinical workflows, while the OMOP CDM employs integer-based keys designed for de-identified research data with `person_id` serving as the primary linking mechanism across clinical domains. The core challenge is balancing OMOP's de-identification requirements with business needs for traceability and audit capabilities.

#### Identifier Management
FHIR and OMOP CDM represent different approaches to data identification due the underlying buiness requirements for each. In FHIR, identifiers provide reference information about source systems and support workflows and transactions between systems. In OMOP, identifiers establish relationships between tables using integer-based keys, with no fields containing patient identifiable information (PII) such as Medical Record Numbers, names, or addresses. Transformation between the two creates tension between competing requirements: maintaining data provenance for operational needs while preserving OMOP's de-identification principles. Many OMOP implementations reside within system architectures that have business requirements for re-identification supporting business and / or research scenarios, or other use cases where maintaining traceability from OMOP back to the FHIR source is needed.

#### Privacy and De-identification Considerations
However, a primary concern when implementing FHIR to OMOP transformations that include raw identifiers directly from source systems is the potential compromise of de-identification processes. This is a cornerstone of OMOP's design for use in research and analytics. OMOP is not designed to support business identity management use cases.

Using fields like `visit_source_value` to store FHIR identifiers could misrepresent their intended use as generated in source EHRs and compromise de-identification processes. A reccomended implementation aproach is to create a separate data source table that maps OMOP-generated IDs to the original FHIR identifiers. This accommodates the complexities of handling identifiers for retaining provenance and traceability without:
- Compromising de-identification and usability standards
- Disrupting the OMOP schema
- Violating de-identification protocols

#### Decision Framework for Identifier Management
There is no single approach that can be uniformly applied to transformation of FHIR identifiers to OMOP. Rather, implementers must evaluate FHIR identifiers systematically using criteria relevant to the use case(s) an OMOP database must support:
1. **Research Purpose**: What research the OMOP instance is intended to support
2. **Identifier Role**: Purpose and role of the identifier in the FHIR resource
3. **Clinical Significance**: Whether the FHIR identifier may inform clinical facts in the observational data store
4. **Format Constraints**: Length and format of the identifier
5. **Privacy Assessment**: Whether the identifier contains or enables derivation of PII
6. **Technical Feasibility**: Whether the identifier can be safely stored within OMOP constraints
7. **Compliance Impact**: What regulatory obligations identifier retention creates

Based on this evaluation, implementers should categorize FHIR identifiers into one of three handling approaches:


<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Strategy</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Use Case</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Implementation Approach</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Key Considerations</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Direct Mapping</td>
      <td style="border: 1px solid #d0d7de;">Identifiers that can be safely transformed to OMOP integer keys without privacy concerns</td>
      <td style="border: 1px solid #d0d7de;">Transform directly to OMOP integer-based keys</td>
      <td style="border: 1px solid #d0d7de;">• Database system constraints on integer sizes<br>• Identifier format compatibility<br>• No PII risk<br>• Suitable for system-generated sequence numbers</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de; font-weight: bold;">External Storage</td>
      <td style="border: 1px solid #d0d7de;">Identifiers needed for traceability but inappropriate for direct OMOP inclusion</td>
      <td style="border: 1px solid #d0d7de;">Create separate mapping tables linking OMOP-generated IDs to original FHIR identifiers</td>
      <td style="border: 1px solid #d0d7de;">• Maintains de-identification principles<br>• Requires access controls and audit trails<br>• Supports bidirectional mapping verification<br>• Preserves data provenance</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Exclusion</td>
      <td style="border: 1px solid #d0d7de;">Identifiers containing PII or serving no research purpose</td>
      <td style="border: 1px solid #d0d7de;">Exclude from transformation entirely</td>
      <td style="border: 1px solid #d0d7de;">• Medical record numbers<br>• Patient names<br>• Other PII-containing identifiers<br>• No research value</td>
    </tr>
  </tbody>
</table>

### Status and Intent Elements in FHIR Resources
Many FHIR resources, like MedicationRequest or Procedure, have status fields indicating administrative or health care delivery process stages (e.g., planned, completed, in progress) or indicate the type of order represented (active, on-hold, cancelled...).  OMOP, on the other hand, represents concepts that are clinical facts, which implies that only completed activities should be mapped for accurate data analysis. This creates an expectation of specific context for the data being mapped. Careful consideration must be made when FHIR data resources also contain populated status and intent fields indicating a measurement, dispensing activity or care delivery service is planned, cancelled or in process.  Specifically, attention to and disposition of data based on these FHIR elements in a transformation should be consistent within a project or OMOP implementation.  There is a need to filter out incomplete or planned activities when transforming data to OMOP, especially for procedures and medications. Including such "yet-to-be-realized" data would misrepresent actual patient exposure, leading to inaccuracies in research.  This kind of filtering is documented in the FHIR to OMOP Unit test specifications, and should be applied to transformation pipelines so that the rules are applied consistently to incremental data ingress for as long as the OMOP instance is in use. 

### Data Completeness, Missingness & Integrity
Handling incomplete or partial data presents an additional challenge in transforming FHIR resources to OMOP. FHIR records are often incomplete for several reasons: the source electronic health record (EHR) itself may contain partial entries, or the FHIR resources may only include a subset of available data tailored to the specific purpose of the resource. In contrast, the OMOP data model assumes that critical fields such as dates, person references, and coded concepts are consistently populated to support standardized analysis.

When transforming FHIR to OMOP, these gaps require careful consideration to avoid introducing ambiguity or bias. For example, a FHIR MedicationStatement may be missing start or end dates, which makes it unclear whether the medication should be interpreted as active, historical, or intended. Similarly, a procedure or encounter record may lack information about the performer or the location, undermining the ability to analyze provider performance, regional variation, or care delivery patterns.

One approach to address these challenges is to consider fallback strategies that preserve as much context as possible. Implementers can use the OMOP observation domain or the note table to retain essential but incomplete data when no direct mapping is feasible. In cases where fields such as dates are missing, records can be flagged as incomplete by selecting appropriate ‘type’ concept IDs to indicate that the data is estimated or partial. This practice ensures that analysts reviewing the transformed data are aware of the uncertainty inherent in these records.

It is equally important for implementers to reflect on the implications of partial data for downstream analyses. Records with incomplete information may introduce misinterpretation or bias if not carefully accounted for in study design and statistical modeling. Therefore, teams should exercise caution when drawing inferences from datasets containing records transformed from incomplete FHIR sources.

#### Contextual Gaps in Data Mapping
A challenge faced in transforming FHIR to OMOP is that FHIR resources often contain contextual elements such as `reasonCode`, `performer`, `location`, or `supportingInfo` that help clarify the conditions or context surrounding a clinical event. OMOP tables do not have a direct way to represent these contexts fully in the same way that FHIR has structured this information. While core information may be mapped to OMOP fields in most instances, key context might be lost if certain contextual elements cannot be directly represented, impacting downstream analytics. For example, `reasonCode` in FHIR can specify the purpose of a procedure, such as preventive care vs. diagnostic intervention. This nuance can be critical to outcomes analyses but may not be directly captured in OMOP.  Also of issue is that lacking context, such as missing details on “why” a procedure was performed or medication prescribed could lead to misinterpretations in analysis, particularly for longitudinal studies tracking disease progression or treatment efficacy. 
   
One workaround could be to capture the context in an OMOP extension, such as "note," but this would have limitations.  Further, any extension suggested as universally applicable for FHIR source data would suggest implementation of OMOP CDM non-conformant as a routine. Rather, for the scope of this implementation guide, we want to call attention to the limitation and suggest review of the source data for potential proxies in the choices made for target Standard concepts, special attention to selection of record ‘type’ concepts that confer metadata about the source records or ensuring linkage in the transformed data to specific `visit_occurrence` records to approximate some context potentially lost. As suggested with identifiers, if the contextual information potentially lost in transformation cannot be accommodated and is critical to the research intended, then accommodation with concept or table extensions may be considered. 

#### HL7 Flavors of Null and OMOP
When implementing an HL7 FHIR to OMOP transformation using a FHIR Implementation Guide (IG), handling null values or *flavors of null* is a critical concern. In HL7 FHIR, data absence can be explicitly communicated using extensions like data-absent-reason, which distinguishes between *unknown*, *asked-but-unknown*, or *not-applicable* values. OMOP CDM, however, represents nulls more implicitly: fields may be left empty, or encoded using specific concepts like 0 (for “No matching concept”) or NULL in SQL. Mapping between these two paradigms requires careful alignment to avoid misinterpretation of data. For instance, a FHIR Observation with a data-absent-reason \= unknown must be mapped meaningfully to the OMOP measurement table, potentially setting the value\_as\_number and value\_as\_concept\_id to NULL, while assigning an appropriate observation\_concept\_id to indicate that the test was performed but the result was unavailable.

**Comparison Table: FHIR vs OMOP Flavors of Null**


<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Aspect</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">HL7 FHIR</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">OMOP CDM</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Representation of null</td>
      <td style="border: 1px solid #d0d7de;">data-absent-reason extension</td>
      <td style="border: 1px solid #d0d7de;">NULL in SQL or concept ID = 0</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Granularity of nulls</td>
      <td style="border: 1px solid #d0d7de;">Fine-grained (unknown, not-applicable, masked, etc.)</td>
      <td style="border: 1px solid #d0d7de;">Implicit; often lacks detailed flavor semantics</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Standard terminology</td>
      <td style="border: 1px solid #d0d7de;">Uses codes like unknown, not-asked, etc.</td>
      <td style="border: 1px solid #d0d7de;">No standard codes; often relies on documentation or conventions</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de; font-weight: bold;">Handling missing values</td>
      <td style="border: 1px solid #d0d7de;">Structured via extensions or empty elements with context</td>
      <td style="border: 1px solid #d0d7de;">Fields left NULL or set to 0 (no matching concept)</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de; font-weight: bold;">ETL challenge</td>
      <td style="border: 1px solid #d0d7de;">Requires preserving semantic meaning during mapping</td>
      <td style="border: 1px solid #d0d7de;">Requires selecting appropriate mapping logic per use case</td>
    </tr>
  </tbody>
</table>

In short, FHIR provides a more expressive mechanism to convey the *reason* for missing data, while OMOP assumes nulls are more operational or structural. Mapping between them in a FHIR-to-OMOP ETL process requires deliberate rules to preserve clinical meaning without overfitting to the destination model.

OMOP provides \*\_source\_value fields that can be leveraged to carry forward original FHIR null semantics (e.g., “refused” or “masked”) when they do not map cleanly to a standard concept. For instance, a FHIR Observation with data-absent-reason \= not-permitted may result in a NULL value\_as\_number and value\_as\_concept\_id, but the string "not-permitted" could be preserved in the value\_source\_value field. This approach ensures that valuable context about the data's absence is not lost in the transformation, preserving semantic integrity across models.

#### Data Absent Reasons Elements
The Data Absent Reason element in FHIR allows implementers to record why information is missing or incomplete in observations, medication statements, and immunizations. When using FHIR resources that document reasons for absent data, it is important to assess carefully which of these reasons should be included in OMOP. This consideration applies to common scenarios such as missing lab results, medications that were not administered, or declined immunizations.

Because Data Absent Reasons cover a spectrum ranging from clinically meaningful refusals to routine administrative gaps, a selective approach is recommended. Implementers are encouraged to map only those reasons with clear clinical or research value for the intended use case—which may include or exclude information such as patient refusals, or  adverse reactions —while excluding operational or ambiguous reasons like “unknown” or “unsupported.” 

In FHIR, Data Absent Reasons use codes such as “unknown,” “not asked,” “asked but unknown,” and “not applicable,” reflecting nuances in why data were not captured. For example, a lab result ordered but not performed could be marked “patient declined,” while a medication not taken might be recorded as due to side effects.

Determining how to represent FHIR’s Data Absent Reasons in OMOP requires both technical and clinical considerations. Because FHIR reasons encompass both clinical and operational rationale, it is recommended to retain only clinically significant reasons that can be mapped to standard vocabularies such as SNOMED or OMOP concepts. This approach helps implementers balance the completeness of data capture with the need for clarity and analytic utility, preserving the clinical relevance and analytic focus of the OMOP model to support the intended research use cases.

### Temporal Precision in OMOP and FHIR

The way a data model records time shapes ETL design, permissible analyses, and the scientific questions a dataset can answer. Fast Healthcare Interoperability Resources (FHIR) provides flexible temporal datatypes with precision ranging from year-only to millisecond timestamps, designed to support real-time clinical workflows and system interoperability [1]. By contrast, the Observational Medical Outcomes Partnership (OMOP) Common Data Model requires date-level fields (YYYY-MM-DD) while providing optional datetime fields that can preserve sub-day precision when populated [2]. This design reflects a deliberate trade-off: it simplifies data sharing, removes variability introduced by differing timestamp conventions, and aligns with OMOP's chief aim—large-scale, retrospective, observational research where day-level granularity is generally sufficient for most analytical use cases.

#### FHIR Temporal Datatypes

FHIR defines multiple temporal primitive types with distinct precision and constraint requirements [1]:

| FHIR Type | Precision | Timezone Requirement | Example |
| --- | --- | --- | --- |
| `instant` | Milliseconds (required to second minimum) | **Mandatory** | `2015-02-07T13:28:17.239+02:00` |
| `dateTime` | Variable (year to millisecond) | **Mandatory when time specified** | `2024`, `2024-03`, `2024-03-15T14:30:00Z` |
| `date` | Day, month, or year | **Prohibited** | `2024-03-15`, `2024-03`, `2024` |
| `time` | Time of day only | **Prohibited** | `14:30:00` |

This flexibility allows FHIR to represent clinical events at the precision appropriate to the source system. The `instant` type is explicitly designated for "precisely observed times" such as system logs, while `dateTime` accommodates human-reported times where precision may vary [1]. Critically, FHIR mandates timezone specification whenever time components are present in `instant` or `dateTime` values.

#### Core Implementation Pattern in OMOP

Because OMOP treats the calendar day as the atomic temporal unit for required fields, every *\_date* column is stored as a SQL `DATE`. For example, `condition_start_date` captures when a diagnosis was first recorded, whereas `visit_start_date` and `visit_end_date` bracket an encounter. End-date fields may be **NULL**—for chronic conditions, long-term drug exposures, or any scenario where the source system never records cessation. Avoiding imputed end dates prevents false precision but requires ETL architects to document any necessary imputations for downstream transparency.

#### Optional Datetime Fields in OMOP

OMOP CDM v5.4 provides optional `*_datetime` fields alongside required `*_date` fields in most clinical event tables [2,3]. These datetime fields can preserve sub-day temporal information when source data contains timestamps:

| Field Type | Required | Data Type | Precision Capability |
| --- | --- | --- | --- |
| `*_date` fields | Yes | DATE | Day (YYYY-MM-DD) |
| `*_datetime` fields | No | DATETIME | Platform-dependent (typically seconds to microseconds) |

The OMOP CDM specification states: "If a source does not specify datetime the convention is to set the time to midnight (00:00:0000)" [3]. This convention introduces ambiguity between events that actually occurred at midnight and events for which time was unknown.

The optional status of datetime fields reflects a deliberate community decision. OMOP CDM v6.0 proposed making datetime fields mandatory, but this version was not adopted. The official documentation explains: "The major difference in CDM v5.3 and CDM v6.0 involves switching the *_datetime fields to mandatory rather than optional. This switch radically changes the assumptions related to exposure and outcome timing. Rather than move forward with v6.0, CDM v5.4 was designed with additions to the model that have been requested by the community while retaining the date structure of medical events in v5.3" [4]. Organizations are advised to transform data to CDM v5.4 "until such time that the v6 series of the CDM is ready for mainstream use" [4].

> **Implementer Recommendation**: When FHIR source data contains precise timestamps, ETL pipelines should populate the optional OMOP datetime fields to preserve this information. However, implementers should document which datetime values represent actual recorded times versus imputed midnight defaults, as this distinction affects analytical validity.

#### OMOP Domain Requirements

Some domains demand particular temporal fields. The following table summarises the expectations in core OMOP tables.

**Domain-specific temporal fields in OMOP**

| Domain | Required Temporal Fields | Optional Datetime Fields | Notes |
| --- | --- | --- | --- |
| Condition | `condition_start_date` (required) / `condition_end_date` (optional) | `condition_start_datetime` / `condition_end_datetime` | Diagnosis date mandatory; end date often NULL for chronic illnesses. |
| Drug Exposure | `drug_exposure_start_date` (required) / `drug_exposure_end_date` (optional) | `drug_exposure_start_datetime` / `drug_exposure_end_datetime` | Records prescription fill and, where known, supply duration. |
| Procedure | `procedure_date` (required) | `procedure_datetime` | Exact date for surgical or diagnostic procedures. |
| Visit Occurrence | `visit_start_date`, `visit_end_date` (both required) | `visit_start_datetime`, `visit_end_datetime` | Defines the encounter window. |
| Measurement / Observation | `measurement_date` / `observation_date` (required) | `measurement_datetime` / `observation_datetime` | Sub-day precision preserved only if datetime fields populated. |

#### Information That Cannot Be Fully Preserved

When transforming FHIR data to OMOP, certain temporal information cannot be fully represented even when optional datetime fields are populated:

##### Timezone Information

FHIR's `instant` datatype mandates timezone specification (e.g., `+02:00` or `Z` for UTC) [1]. Standard ANSI SQL `DATETIME` types—which the OMOP CDM specifies generically [2]—do not include timezone offset. The SQL standard specifies that `timestamp` without qualification is "equivalent to timestamp without time zone" [5]. Preserving timezone requires database-specific extensions such as `DATETIMEOFFSET` (SQL Server) or `TIMESTAMP WITH TIME ZONE` (PostgreSQL), which are not mandated by the OMOP CDM specification. For multi-site studies spanning time zones or analyses sensitive to absolute time (e.g., circadian rhythm research), this loss may be significant.

##### Precision Metadata

FHIR's variable-precision `dateTime` type distinguishes between values known only to the year (`2024`), year-month (`2024-03`), day (`2024-03-15`), or full timestamp (`2024-03-15T14:30:00Z`) [1]. OMOP provides no standard mechanism to capture this precision metadata. When a year-only FHIR date is transformed to OMOP, the ETL must impute a complete date (typically `YYYY-01-01`), but the original precision level is not preserved in a queryable field. The `*_source_value` columns can document the original representation, but this requires manual inspection rather than programmatic filtering.

##### Sub-second Precision Variability

The OMOP CDM documentation acknowledges platform-dependent datetime handling: "The CDM does not prescribe the date and datetime format. Standard queries against CDM may vary for local instantiations and date/datetime configurations" [2]. Database implementations vary in datetime precision—traditional SQL Server `DATETIME` rounds to 3.33 milliseconds, while `DATETIME2` supports 100-nanosecond precision [6]. Without specification of minimum precision requirements, OMOP implementations may truncate FHIR's millisecond-precision timestamps.

##### Summary of Temporal Information Preservation

| Information Type | FHIR Capability | OMOP Preservation | Notes |
| --- | --- | --- | --- |
| Date (day precision) | Full support | Required fields | Fully preserved |
| Time of day | Full support | Optional datetime fields | Preserved if datetime fields populated |
| Timezone offset | Mandatory for `instant` | No standard field | Typically lost |
| Sub-second precision | Milliseconds | Platform-dependent | Variable |
| Precision metadata | Implicit in format | No standard field | Lost; requires `*_source_value` documentation |

#### Limitations and Intra-Day Challenges

When optional datetime fields are not populated—which remains common practice given their optional status and the historical prevalence of date-only source data [7]—sub-day precision is lost entirely. Even when datetime fields are populated, the absence of timezone creates challenges. Intensive-care interventions, rapid laboratory results, and overlapping medication administrations can occur within minutes; without consistent datetime population and timezone handling, such events may collapse onto the same calendar day or be ambiguously ordered across time zones. Analysts must therefore supplement with auxiliary timestamp stores or infer ordering through other means. Likewise, **temporal ties**—multiple events stamped with the same date—demand caution in sequence analyses lest spurious causal relationships be inferred.

#### Handling Partial or Approximate Dates When Mapping from FHIR

Mapping FHIR resources into OMOP often surfaces partial or approximate temporal metadata. Historical records, patient-reported information, or legacy migrations may capture only a year (`2024`) or a year-month (`2024-05`). FHIR explicitly supports these partial representations through the `date` and `dateTime` datatypes' variable precision [1]. If an exact date is indispensable for OMOP, implementers can adopt controlled imputations—for example, defaulting year-only data to `YYYY-01-01` or year-month data to the first of that month. Every rule must be logged in ETL metadata, preserved in \*\_source\_value columns, and communicated to analysts so sensitivity analyses can account for uncertainty.

Implementers should consider creating a supplementary precision indicator when partial dates are common in source data. While not part of the standard OMOP CDM, a local extension table documenting the original temporal precision for each record can enable analysts to filter or weight observations based on date certainty.

#### Analytical Implications

Despite its limitations, the OMOP temporal model underpins a wide array of research tasks. Cohort definitions hinge on date fields for inclusion windows; comparative-effectiveness studies rely on day-level ordering of diagnoses, procedures, and prescriptions; and longitudinal trend analyses benefit from the removal of artefactual timestamp variability. Studies demanding minute-by-minute sequencing—such as antimicrobial stewardship audits in intensive-care units—may require either OMOP extensions or alternative data models altogether.

#### Recommendations for FHIR-to-OMOP Temporal Mapping

Based on the considerations above, implementers should:

1. **Populate optional datetime fields** when FHIR source data contains time components, rather than discarding this information by mapping only to required date fields.

2. **Document datetime provenance** by distinguishing between datetime values derived from actual FHIR timestamps versus those defaulted to midnight due to missing time components. Consider using type concept IDs or supplementary metadata to flag imputed values.

3. **Preserve original temporal representations** in `*_source_value` fields, particularly for partial dates (year-only, year-month) where imputation rules have been applied.

4. **Consider timezone requirements** for multi-site or time-sensitive studies. If timezone preservation is critical, evaluate database-specific datetime types or auxiliary storage mechanisms outside the standard OMOP schema.

5. **Communicate limitations to analysts** through data documentation that specifies which datetime fields are reliably populated, what imputation rules were applied, and what temporal precision can be assumed for analytical purposes.

Successful implementations embrace OMOP's date-level precision as the guaranteed minimum while remaining transparent about its constraints and leveraging optional datetime fields where source data supports them. ETL developers should codify and publish rules for handling partial dates, analysts should incorporate uncertainty into models, and institutions may elect to store high-resolution timestamps in parallel schemas where local research imperatives demand them. By balancing standardisation with explicit provenance, the OMOP community can continue enabling reproducible observational research without obscuring clinically relevant temporal nuance.

---

#### Temporal Precision References

[1] Health Level Seven International. FHIR R4 Specification: Data Types. HL7 FHIR Release 4. Available from: http://hl7.org/fhir/R4/datatypes.html

[2] Observational Health Data Sciences and Informatics. OMOP Common Data Model Conventions. Available from: https://ohdsi.github.io/CommonDataModel/dataModelConventions.html

[3] Observational Health Data Sciences and Informatics. OMOP CDM v5.4 Specification. Available from: https://ohdsi.github.io/CommonDataModel/cdm54.html

[4] Observational Health Data Sciences and Informatics. OMOP CDM v6.0 Specification. Available from: https://ohdsi.github.io/CommonDataModel/cdm60.html

[5] PostgreSQL Global Development Group. PostgreSQL Documentation: Date/Time Types. Available from: https://www.postgresql.org/docs/current/datatype-datetime.html

[6] Microsoft Corporation. datetime2 (Transact-SQL) - SQL Server. Microsoft Learn. Available from: https://learn.microsoft.com/en-us/sql/t-sql/data-types/datetime2-transact-sql

[7] Ryan P. Comment on "Timing of time" discussion. OHDSI Forums. 2016 Oct 1. Available from: https://forums.ohdsi.org/t/timing-of-time/1730
