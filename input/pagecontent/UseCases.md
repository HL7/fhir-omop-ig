The canonical use case employed is querying a FHIR-enabled data repository to retrieve records and load them into an OMOP data store.  This guide defines a set of logical models that represent the OMOP Common Data Model, v5.4.  It also provides mappings, defined as FHIR StructureMaps and ConceptMaps (hosted on a FHIR terminology server), between the International Patient Access FHIR and US Core Encounter and Procedure profiles and the OMOP data tables. 

### NIH All of Us Research Program 

The NIH's [All of Us Research Program](https://allofus.nih.gov/) is a historic initiative aiming to collect and analyze data from one million or more individuals residing in the United States. Currently, the Program has enrolled over 849,000 participants. The primary goal of the initiative is to promote better health outcomes by empowering thousands of researchers with diverse, longitudinal data gathered from participants—80% of whom are traditionally underrepresented in biomedical research.

#### Types of Data Collected

The Program collects various data types from consented participants, including:

- Electronic Health Record (EHR)
- Bioassay
- Demographic
- Survey
- Physical Measure
- Physical Activity

Additional data currently being linked to participant records include:

- Mortality
- Healthcare Claims
- Residential History

All collected data are maintained and curated by the [All of Us Data and Research Center (DRC)](https://allofus.nih.gov/funding-and-program-partners/data-and-research-center) and are accessible to researchers through the [All of Us Researcher Workbench](https://www.researchallofus.org/data-tools/workbench/). The primary data standard and clinical data model utilized by the All of Us Research Program is OMOP.

#### EHR Data Focus

The All of Us Program collaborates with approximately 50 Health Provider Organizations (HPOs) across the United States to recruit participants. The All of Us Research Program leverages OMOP to standardize and structure its collected data, ensuring feasibility and facilitating researchers' ability to access and integrate data from diverse sources. These HPO partners extract participant EHR data, convert it into OMOP format, and submit 22 OMOP tables to the DRC on a quarterly basis. Given that EHR data represent the greatest demand for FHIR to OMOP mapping among the various All of Us data types, the All of Us program exemplifies real-world use cases for the utilization of EHR-sourced FHIR data transformed onto the OMOP CDM to generate evidence. 

#### Published Studies Using All of Us Data
Studies were selected as examples based on the following criteria:

1. Predominant use of All of Us EHR data.
2. Alignment of data with many FHIR resources outlined in the Implementation Guide (IG).
3. Availability of supplementary materials in published articles, including:
    - Code systems and value sets or specific codes from these systems.
    - Demographic variables/data elements detailed either in supplements or articles.
    - OMOP concept IDs.

These selected studies offer practical, real-world examples of codes, data elements, and concept IDs. It is important to note that the examples may also incorporate additional codes and OMOP concept IDs as required.

#### Selected Studies and Data Supplements:

- **Renedo, D., Acosta, J. N., Sujijantarat, N., Antonios, J. P., et al. (2022)**. *Carotid Artery Disease Among Broadly Defined Underrepresented Groups: The All of Us Research Program.* Stroke, 53. [https://doi.org/10.1161/STROKEAHA.121.037554](https://doi.org/10.1161/STROKEAHA.121.037554)
  - [Data Supplement](https://www.ahajournals.org/action/downloadSupplement?doi=10.1161%2FSTROKEAHA.121.037554&file=stroka121037554_suppl1.pdf)

- **Khan, M. S., Carroll, R. J. (2022)**. *Inference-based correction of multi-site height and weight measurement data in the All of Us Research Program.* Journal of the American Medical Informatics Association, 29(4), 626–630. [https://doi.org/10.1093/jamia/ocab251](https://doi.org/10.1093/jamia/ocab251)
  - [Data Supplement](https://academic.oup.com/jamia/article/29/4/626/6437121#supplementary-data) (additional OMOP concept IDs included in article text)

- **Berman, L., Ostchega, Y., Giannini, J., Anandan, L. P., et al. (2024)**. *Application of a Data Quality Framework to Ductal Carcinoma In Situ Using Electronic Health Record Data From the All of Us Research Program.* JCO Clinical Cancer Informatics. [https://doi.org/10.1200/CCI.24.00052](https://doi.org/10.1200/CCI.24.00052)
  - [Data Supplement](https://ascopubs.org/doi/suppl/10.1200/CCI.24.00052)

### Vulcan Real-World Data Implementation Guide  
The [Vulcan Retrieval of Real World Data (RWD) for Clinical Research Implementation Guide (IG)](https://hl7.org/fhir/uv/vulcan-rwd/) aims to facilitate the transmission of clinical data generated during routine patient care (Electronic Health Record data, EHR) for use as Real World Data (RWD) supporting clinical research. Traditionally, clinical trials rely on prospective data collection tailored to specific research questions and analytics. In contrast, data generated through routine healthcare operations are rarely aligned with secondary research requirements. The Vulcan RWD IG defines FHIR profiles suitable for use within EHR systems, facilitating the retrieval and alignment of relevant clinical data from RWD sources for clinical research and regulatory submissions.

The Vulcan Real-World Data IG leverages the [FHIR International Patient Access (IPA)](https://hl7.org/fhir/uv/ipa/) IG to provide a foundational dataset and profiles necessary to address RWD use case requirements.

#### Vulcan RWD IG Studies from ClinicalTrials.gov

1. [Acute Coronary Syndrome Study](https://build.fhir.org/ig/HL7/vulcan-rwd/acs.html#acute-coronary-syndrome-study), ClinicalTrials.gov ID: [NCT02190123](https://clinicaltrials.gov/ct2/show/NCT02190123)  
2. [Anti-TNFa Treatment Study](https://build.fhir.org/ig/HL7/vulcan-rwd/anti-tnfa.html#anti-tnfa-treatment-study), ClinicalTrials.gov ID: [NCT03890445](https://clinicaltrials.gov/ct2/show/NCT03890445)  
3. [Diabetes Study](https://build.fhir.org/ig/HL7/vulcan-rwd/diabetes.html#diabetes-study), ClinicalTrials.gov ID: [NCT05088265](https://clinicaltrials.gov/ct2/show/NCT05088265)  
4. [COVID-19 Vaccine Effectiveness Study](https://build.fhir.org/ig/HL7/vulcan-rwd/covid.html#covid-19-vaccine-effectiveness-study), ClinicalTrials.gov ID: [NCT04848584](https://clinicaltrials.gov/ct2/show/NCT04848584)  

These studies referenced in the Vulcan RWD IG specify the data elements required to identify, request, and retrieve relevant EHR data aligned with each study’s cohort definition and research parameters. Most data elements are derived from the IPA profiles, providing a standardized minimal dataset. The Vulcan RWD IG further supports flexibility to accommodate local, regional, or study-specific needs through extensions, as illustrated in the RWD Conceptual Application Model pictured below:

{::options parse_block_html="false" /}
<figure>
<figcaption><b>Vulcan RWD Conceptual Application</b></figcaption>
<img src="rwd_conceptual_application.png" style="padding-top:0;padding-bottom:30px" width="800" alt="Vulcan RWD Conceptual Application"/>
</figure>
{::options parse_block_html="true" /}

### FHIR to OMOP Transformation for AI Training and Classification 
The healthcare industry is increasingly leveraging Artificial Intelligence (AI) to extract actionable insights from clinical data. The OMOP Common Data Model is widely used for AI model training due to its robust, standardized structure designed to support large-scale data analysis, including clinical outcomes, drug safety, and efficacy research. However, FHIR (Fast Healthcare Interoperability Resources) is a newer, more flexible standard for health information exchange and is widely adopted for its ability to support real-time clinical workflows, such as through electronic health records (EHRs).

While OMOP provides a reliable foundation for building AI models, FHIR's versatility and growing adoption make it a popular choice for applying AI, which presents challenges when it comes to directly applying OMOP-trained AI models trained to FHIR data.  The key issue is that AI models typically require data in a highly structured format (such as OMOP), but FHIR resources are more granular and often transmitted in a fragmented or single-message form. This misalignment makes it difficult to directly use FHIR for training AI models, which is why a transformation from FHIR to OMOP is necessary.

#### Solution: FHIR to OMOP Transformation 
To bridge this gap, the use of Extract, Transform, Load (ETL) processes to convert FHIR data into OMOP format has emerged as a critical solution. By transforming FHIR resources—whether from a single message (such as a single patient encounter or medication prescription) or aggregated messages—into the standardized OMOP format, healthcare organizations can train AI models on OMOP data while leveraging real-time clinical data in FHIR for classification tasks.

The transformation enables AI models trained on the OMOP CDM to be applied to clinical data captured in FHIR, ensuring that AI predictions are made based on consistent, normalized data. This makes it possible for even single-message FHIR resources (like a patient’s admission record or a medication order) to be compatible with pre-existing, trained models, which are often designed to analyze more comprehensive patient data typically found in OMOP.

#### FHIR to OMOP Transformation for AI: Classification of Medication Adherence  
An example of this use case could involve a healthcare provider using an AI model to predict medication adherence for patients. The AI model is trained on historical clinical data stored in the OMOP format, which contains detailed, structured information about patient visits, medications, diagnoses, and more. The healthcare provider collects patient data in real-time via FHIR resources, such as prescriptions and medication refills, which are stored in their EHR system.

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="fhir_omop_ai_diagram.svg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Transformation for AI Training and Classification"/>
</figure>
{::options parse_block_html="true" /}

Through the ETL process, the FHIR resources (prescription orders, medication administration records, etc.) are transformed into the OMOP CDM format, ensuring compatibility with the trained model. Once transformed, the model can be applied to real-time data to predict whether a patient is likely to adhere to their prescribed medication regimen. The output of the model can be classified based on this prediction and used to guide healthcare interventions.

1. **Interoperability**: The ETL process ensures that data from different sources (FHIR-based real-time clinical workflows and OMOP-based AI model training) are seamlessly integrated, overcoming the limitations of both standards.  
2. **AI Model Training on OMOP**: By training AI models on the comprehensive OMOP CDM, healthcare organizations can leverage a rich, structured dataset that supports large-scale, high-quality analysis.  
3. **Real-Time Decision Making**: Even though the model is trained on OMOP data, FHIR data can be continuously ingested, transformed, and classified in real-time, enabling timely healthcare interventions.  
4. **Flexibility**: Single-message FHIR resources, which are often captured in fragmented clinical settings (e.g., one patient visit), can be made compatible with the complex models designed for aggregated datasets, extending the utility of FHIR for AI applications.

The FHIR to OMOP transformation enables healthcare organizations to leverage real-time clinical data in FHIR format with pre-trained AI models that rely on the OMOP CDM. Through ETL processes, even fragmented or single-message FHIR resources can be made compatible with AI models trained on more comprehensive datasets, fostering more effective AI-driven healthcare decisions and interventions.
