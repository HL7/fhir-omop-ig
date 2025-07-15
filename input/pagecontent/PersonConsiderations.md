# FHIR Person Resource Considerations

## Mapping Sex and Gender 
FHIR to OMOP gender mapping requires attention to both technical precision and the evolving OHDSI conventions around gender and sex data representation. The key to successful implementation lies in establishing clear protocols that respect the OHDSI community's ratified conventions, maintaining comprehensive validation across both person and observation tables, and preparing for future standard evolution while ensuring current system reliability and accuracy. 

## Understanding Both Standards
### FHIR Gender Implementation
FHIR implements gender as a CodeableConcept within the Person resource, providing flexibility in representation while maintaining standardization. The gender field accepts four primary values:

- **male**: Represents male gender identity
- **female**: Represents female gender identity  
- **other**: Encompasses non-binary, third gender, or other gender identities
- **unknown**: Indicates gender information is unavailable or undetermined

The CodeableConcept structure allows implementers to include additional context through display text and system URIs, enabling reference to established terminologies such as SNOMED CT or HL7 value sets.

### OMOP Gender Structure
OMOP takes a more rigid approach through the `gender_concept_id` field in the person table. This field requires a mandatory reference to standardized vocabulary concepts:

- **Male**: Concept ID 8507
- **Female**: Concept ID 8532
- **Unknown**: Concept ID 8551
- **Other**: Concept ID 44814653

The mandatory nature of this field ensures every person record contains gender information, requiring careful handling of missing or null values during transformation.

**Important OHDSI Convention Update**: The OHDSI community has recognized that the term "gender_concept_id" is outdated and should more accurately be "sex_concept_id" to reflect biological sex rather than gender identity. However, due to the significant development effort required to change this field name across all OMOP implementations and package dependencies, this update will be implemented in the next major release of the OMOP Common Data Model.

## OHDSI Gender Identity Convention
### Current State and Future Plans
The OHDSI community has established important conventions regarding gender-related data storage in the OMOP Common Data Model that directly impact FHIR to OMOP mapping strategies.

### Gender vs. Sex Terminology
The current `gender_concept_id` field in the OMOP person table represents a legacy naming convention that causes conceptual confusion. The OHDSI community acknowledges that this field more accurately represents biological sex rather than gender identity. The preferred term should be `sex_concept_id` to reflect this distinction properly.

**Implementation Timeline**: Due to the substantial development effort required to rename this field across all OMOP implementations, packages, and dependent systems, this change will be implemented in the next major release of the OMOP Common Data Model. Until then, implementers should understand that `gender_concept_id` conceptually represents biological sex.

### Ratified Convention for Gender Identity Storage
**Scope**: This convention applies to any database that captures gender identity information, regardless of data provenance or source system.
**Core Principle**: Any gender-related information that can change over time, particularly gender identity, should be stored in the OBSERVATION table rather than the person table.
**Rationale**: The person table is designed for relatively static demographic information, while the OBSERVATION table accommodates time-varying clinical and social observations, making it the appropriate location for gender identity data that may evolve over time.

The key distinctions implementers must understand are:

1. **Current State**: The `gender_concept_id` field in the person table should be treated as biological sex information
2. **Gender Identity**: Use the observation table for any gender-related information that can change over time
3. **Future Planning**: Prepare for the transition to `sex_concept_id` in the next major OMOP release

By following these implementation guidelines and adhering to OHDSI conventions, healthcare organizations can achieve reliable, compliant, and inclusive gender data transformation that supports both clinical care and research objectives while properly distinguishing between biological sex and gender identity.

### Implementation Approach for Gender Identity
When mapping FHIR resources that contain gender identity information (as distinguished from biological sex), implementers should:

1. **Person Table**: Use `gender_concept_id` for biological sex information only
2. **Observation Table**: Store gender identity data using appropriate observation concepts
3. **Temporal Handling**: Leverage the observation table's date/time capabilities to track changes in gender identity over time

### Revised Mapping Approach
Given the OHDSI conventions, the mapping strategy must differentiate between biological sex and gender identity:

**For Biological Sex (Person Table)**:
- Map FHIR sex-related information to `gender_concept_id` using the established concept IDs
- Treat this as relatively static demographic information
- Use standard validation and transformation rules

**For Gender Identity (Observation Table)**:
- Create observation records for gender identity information
- Use appropriate observation concepts from the OMOP vocabulary
- Include observation dates to track temporal changes
- Link to the person record through `person_id`

### Direct Value Mapping
The core mapping process follows these direct transformations:

**FHIR "male" → OMOP Concept ID 8507**
This represents the most straightforward mapping case, where explicit male identification in FHIR translates directly to the OMOP male concept.

**FHIR "female" → OMOP Concept ID 8532**
Female gender identification follows the same direct mapping approach, ensuring consistency across both standards.

**FHIR "other" → OMOP Concept ID 44814653**
This mapping accommodates diverse gender identities that fall outside traditional binary classifications, providing inclusive representation in OMOP.

**FHIR "unknown" → OMOP Concept ID 8551**
When gender information is explicitly marked as unknown in FHIR, this maps to the corresponding unknown concept in OMOP.

### Handling Null and Missing Values
The most complex aspect of FHIR to OMOP gender mapping involves managing absent gender information. Since OMOP requires a gender_concept_id for every person record, implementers must establish clear protocols for null value handling.

**Recommended Approach**: When gender information is completely absent from the FHIR resource, assign OMOP concept ID 0, indicating no appropriate concept could be determined. This approach maintains data integrity while acknowledging information gaps.

**Alternative Consideration**: Some implementations may prefer mapping null values to concept ID 8551 (Unknown), treating missing information as equivalent to unknown gender. Organizations should establish consistent policies based on their specific requirements and regulatory environment.

## Advanced Considerations
### HL7 Gender Harmony Project Integration
The HL7 Gender Harmony Project introduces sophisticated gender and sex categorization that extends beyond traditional binary representations. Implementation teams should prepare for enhanced gender concepts including:

- **Recorded Sex or Gender (RSG)**: The sex or gender recorded in official documents
- **Sex for Clinical Use (SFCU)**: Clinically relevant sex information for treatment decisions
- **Gender Identity**: Personal gender identification separate from biological sex

These concepts will require vocabulary extensions and updated mapping protocols as standards evolve.

### Jurisdictional Compliance
Different healthcare jurisdictions may have specific requirements for gender data representation. Implementation teams must consider:

- Regional terminology preferences and legal requirements
- Cultural sensitivity in gender categorization
- Privacy and security regulations governing gender information
- Coordination between pre-existing local standards and international specifications

## Future Considerations
### Preparing for OMOP CDM Updates

As the OMOP Common Data Model evolves, implementation teams should:
- **Field Renaming**: Prepare for the transition from `gender_concept_id` to `sex_concept_id` in the next major OMOP release
- **Migration Planning**: Develop strategies for updating existing implementations when the field name changes
- **Documentation Updates**: Ensure all internal documentation reflects the conceptual distinction between biological sex and gender identity
- **Training Programs**: Educate development teams on the proper use of person table vs. observation table for different types of gender-related information

### Gender Harmony Project Integration
Monitor Gender Harmony Project developments for vocabulary updates, particularly:
- Enhanced observation concepts for gender identity
- Standardized approaches to temporal gender identity tracking
- Integration with FHIR R5 and future versions

### Standards Evolution
- Monitor FHIR and OMOP standard revisions for gender and sex representation
- Maintain flexibility in mapping logic to accommodate new concepts
- Engage with OHDSI community discussions on gender identity best practices
- Prepare for potential additional gender identity observation concepts
