# Immunization Resource Considerations
## Terminology and Code Systems: CVX (Vaccines Administered)
Aligned with the IPA Immunization profile recommendations, CVX is the reccomended terminology to use for vaccine administration records.  CVX provides a standardized coding system specifically designed for vaccines in healthcare data and is regularly updated to include new vaccines, including COVID-19 vaccines in recent versions.

### Terminology Flexibility
While CVX serves as the preferred terminology, we reccomend maintaining flexibility to accommodate alternative coding systems commonly found in real-world data sources. This flexibility ensures that the mapping can effectively handle variations in source data coding practices across different healthcare organizations and systems. The IPA profile's "example binding" for immunization terminology allows for the inclusion of other code systems such as:
- CPT (Common Procedural Terminology) codes
- Other locally used immunization coding systems
- Legacy coding systems from source data

## OMOP Domain Mapping Selection
### Dual-Table Approach Based on Data Completeness
To determine the appropriate OMOP domain for immunization records, employ a data-driven approach 

| **Mapping Criteria** | **Drug Exposure Table** | **Observation Table** |
|:---------------------|:------------------------|:---------------------|
| **Primary Use Case** | Well-documented immunizations with complete administration details | Incomplete or patient-reported immunizations |
| **Data Requirements** | • Specific administration dates<br>• Vaccine details and specifications<br>• Confirmed administration documentation | • Missing administration dates<br>• Patient-reported vaccines<br>• Minimal or incomplete documentation |
| **Data Quality Level** | High-quality, verifiable immunization records | Preserved data with documented limitations |
| **OMOP Compliance** | Meets completeness requirements for drug exposure records | Maintains OMOP guidance for incomplete/self-reported data |
| **Clinical Utility** | Suitable for clinical analysis and quality measures | Reference data with clear quality indicators |
| **Traceability** | Full documentation trail available | Limited documentation with quality flags |

This dual-table approach addresses data quality concerns by:
- Maintaining clear distinctions between documented and self-reported immunizations
- Enabling OMOP users to differentiate data quality levels for analysis purposes
- Supporting quality measures that rely on documented drug exposures while preserving incomplete data for reference

## Evaluating Resource Immunization Status Element
Healthcare organizations implementing FHIR to OMOP transformations face a critical decision when handling immunization data: how to appropriately manage the mandatory status field required by the FHIR IPA Implementation Guide. The recommended approach focuses on **including only immunizations with "completed" or "in progress" status** in the OMOP database. This strategy addresses the challenge arising when attempting to map FHIR's "not done" status to OMOP's existing field structures. Early attempts to preserve "not done" statuses by mapping them to fields like "stop reason" created significant risks for data misinterpretation, as these fields serve different clinical purposes than indicating an immunization was never administered.

The filtering approach during transformation ensures that only clinically meaningful immunization records enter the OMOP database. Each included immunization must contain the mandatory FHIR elements: status, vaccine code, patient reference, and administration date. By excluding "not done" records, organizations maintain the clinical accuracy of their OMOP data while supporting reliable analytics and research outcomes.

Implementation teams discovered that forcing "not done" statuses into inappropriate OMOP fields could lead to false positives in clinical research and quality measurement activities. The stop reason field, originally designed to capture why ongoing treatments were discontinued, carries different semantic meaning than a planned immunization that was never initiated. This misalignment posed risks for downstream analytics, clinical decision support systems, and population health management activities that rely on accurate immunization status information.

For use cases requiring data reflecting all statuses, excluded records can be preserved by mapping to a targets typically in the Observation Domain such as: "Measles mumps and rubella vaccination not done" (concept_id: 36713255). This approach balances the need for data integrity with transparency requirements, allowing for future analysis while preventing contamination of the primary analytical dataset.
