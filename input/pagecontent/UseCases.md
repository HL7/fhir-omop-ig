The canonical use case employed is querying a FHIR-enabled data repository to retrieve records and load them into an OMOP data store.  This guide defines a set of logical models that represent the OMOP Common Data Model, v5.4.  It also provides mappings, defined as FHIR StructureMaps and ConceptMaps (hosted on a FHIR terminology server), between the International Patient Access FHIR and US Core Encounter and Procedure profiles and the OMOP data tables. 

An implementation of this guide declares which of the use cases described on this page it supports, so that the scope of any given FHIR-to-OMOP transformation is stated explicitly rather than inferred. See the conformance requirement referenced in the [Conformance](conformance.html) artifacts.

### NIH All of Us Research Program 

The NIH's [All of Us Research Program](https://allofus.nih.gov/) is a historic initiative aiming to collect and analyze data from one million or more individuals residing in the United States. Currently, the Program has enrolled over 849,000 participants. The primary goal of the initiative is to promote better health outcomes by empowering thousands of researchers with diverse, longitudinal data gathered from participants, 80% of whom are traditionally underrepresented in biomedical research.

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

These selected studies offer practical, real-world examples of codes, data elements, and concept IDs. It is important to note that the examples might also incorporate additional codes and OMOP concept IDs as required.

#### Selected Studies

- **Renedo, D., Acosta, J. N., Sujijantarat, N., Antonios, J. P., et al. (2022)**. *Carotid Artery Disease Among Broadly Defined Underrepresented Groups: The All of Us Research Program.* Stroke, 53. [https://doi.org/10.1161/STROKEAHA.121.037554](https://doi.org/10.1161/STROKEAHA.121.037554)

- **Khan, M. S., Carroll, R. J. (2022)**. *Inference-based correction of multi-site height and weight measurement data in the All of Us Research Program.* Journal of the American Medical Informatics Association, 29(4), 626–630. [https://doi.org/10.1093/jamia/ocab251](https://doi.org/10.1093/jamia/ocab251) Additional OMOP concept IDs are included in the article text.

- **Berman, L., Ostchega, Y., Giannini, J., Anandan, L. P., et al. (2024)**. *Application of a Data Quality Framework to Ductal Carcinoma In Situ Using Electronic Health Record Data From the All of Us Research Program.* JCO Clinical Cancer Informatics. [https://doi.org/10.1200/CCI.24.00052](https://doi.org/10.1200/CCI.24.00052)

### Vulcan Real-World Data Implementation Guide
The Vulcan Retrieval of Real World Data (RWD) for Clinical Research Implementation Guide (IG) aims to facilitate the transmission of clinical data generated during routine patient care (Electronic Health Record data, EHR) for use as Real World Data (RWD) supporting clinical research. Traditionally, clinical trials rely on prospective data collection tailored to specific research questions and analytics. In contrast, data generated through routine healthcare operations are rarely aligned with secondary research requirements. The Vulcan RWD IG defines FHIR profiles suitable for use within EHR systems, facilitating the retrieval and alignment of relevant clinical data from RWD sources for clinical research and regulatory submissions.

The Vulcan Real-World Data IG leverages the FHIR International Patient Access (IPA) IG to provide a foundational dataset and profiles necessary to address RWD use case requirements.

### Vulcan RWD IG Studies from ClinicalTrials.gov

During the development of the Vulcan RWD IG, the following real-world clinical research studies from ClinicalTrials.gov were used as representative use cases to identify and scope the data elements most commonly required for clinical research. These studies are referenced here as illustrative background context; they informed the scoping decisions of the Vulcan RWD IG and, by extension, the prioritization of FHIR data elements relevant to this FHIR to OMOP IG. They are not presented as studies that were operationally conducted using the Vulcan RWD IG.

1. Acute Coronary Syndrome Study, ClinicalTrials.gov ID: NCT02190123
2. Anti-TNFa Treatment Study, ClinicalTrials.gov ID: NCT03890445
3. Diabetes Study, ClinicalTrials.gov ID: NCT05088265
4. COVID-19 Vaccine Effectiveness Study, ClinicalTrials.gov ID: NCT04848584

These studies specify the data elements required to identify, request, and retrieve relevant EHR data aligned with each study's cohort definition and research parameters. Most data elements are derived from the IPA profiles, providing a standardized minimal dataset. The Vulcan RWD IG further supports flexibility to accommodate local, regional, or study-specific needs through extensions, as illustrated in the RWD Conceptual Application Model pictured below:

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="rwd_conceptual_application_updt.jpg" style="padding-top:0;padding-bottom:30px" width="800" alt="Vulcan RWD Conceptual Application"/>
</figure>
{::options parse_block_html="true" /}

### FHIR to OMOP Transformation for AI Training and Classification

**Note:** This document describes a target use case and conceptual framework. The AI classification capability outlined below represents the intended outcome of this work and is contingent on successfully implementing the FHIR-to-OMOP ETL transformation described herein. It has not yet been fully implemented.

The healthcare industry is increasingly leveraging Artificial Intelligence (AI) to extract actionable insights from clinical data. The OMOP Common Data Model is widely used for AI model training due to its robust, standardized structure designed to support large-scale data analysis, including clinical outcomes, drug safety, and efficacy research. However, FHIR (Fast Healthcare Interoperability Resources) is a newer, more flexible standard for health information exchange and is widely adopted for its ability to support real-time clinical workflows, such as through electronic health records (EHRs).

While OMOP provides a reliable foundation for building AI models, FHIR's versatility and growing adoption make it a popular choice for applying AI, which presents challenges when it comes to directly applying OMOP-trained AI models to FHIR data. The key issue is that AI models typically require data in a highly structured format (such as OMOP), but FHIR resources are more granular and often transmitted in a fragmented or single-message form. This misalignment makes it difficult to directly use FHIR for training AI models, which is why a transformation from FHIR to OMOP is necessary.

#### Goal: FHIR to OMOP Transformation

**The goal of this work is to** bridge this gap through the use of Extract, Transform, Load (ETL) processes to convert FHIR data into OMOP format. By transforming FHIR resources, whether from a single message (such as a single patient encounter or medication prescription) or aggregated messages, into the standardized OMOP format, healthcare organizations would be positioned to train AI models on OMOP data while leveraging real-time clinical data in FHIR for classification tasks.

Once implemented, this transformation would enable AI models trained on the OMOP CDM to be applied to clinical data captured in FHIR, ensuring that AI predictions are made based on consistent, normalized data. This would make it possible for even single-message FHIR resources (like a patient's admission record or a medication order) to be compatible with pre-existing, trained models, which are often designed to analyze more comprehensive patient data typically found in OMOP.

#### Target Use Case: Classification of Medication Adherence

The following is an illustrative example of the type of AI application this work is intended to support. **This use case has not yet been implemented; it represents the envisioned end state once the FHIR-to-OMOP transformation is in place.**

A healthcare provider could use an AI model to predict medication adherence for patients. The AI model would be trained on historical clinical data stored in the OMOP format, which contains detailed, structured information about patient visits, medications, diagnoses, and more. The healthcare provider would collect patient data in real-time via FHIR resources, such as prescriptions and medication refills, stored in their EHR system.

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="fhir-omop-ig-ai-downstream.jpg" style="padding-top:0;padding-bottom:30px" width="800" alt="FHIR to OMOP Transformation for AI Training and Classification"/>
</figure>
{::options parse_block_html="true" /}

Through the ETL process, the FHIR resources (prescription orders, medication administration records, etc.) would be transformed into the OMOP CDM format, ensuring compatibility with the trained model. Once transformed, the model would be applied to real-time data to predict whether a patient is likely to adhere to their prescribed medication regimen. The output of the model would then be classified based on this prediction and used to guide healthcare interventions.

What the transformation has to do when it runs for one patient at the point of care is described in [Single-Patient FHIR to OMOP Transformation for Clinical Decision Support](#single-patient-fhir-to-omop-transformation-for-clinical-decision-support) below.

#### Intended Benefits

The following benefits are expected to be realized upon successful implementation of the FHIR-to-OMOP transformation:

- **Interoperability:** The ETL process would ensure that data from different sources (FHIR-based real-time clinical workflows and OMOP-based AI model training) are seamlessly integrated, overcoming the limitations of both standards.
- **AI Model Training on OMOP:** By training AI models on the comprehensive OMOP CDM, healthcare organizations would be able to leverage a rich, structured dataset that supports large-scale, high-quality analysis.
- **Real-Time Decision Making:** Once implemented, FHIR data would be continuously ingested, transformed, and classified in real-time, enabling timely healthcare interventions even though the underlying model is trained on OMOP data.
- **Flexibility:** Single-message FHIR resources, which are often captured in fragmented clinical settings (e.g., one patient visit), would be made compatible with complex models designed for aggregated datasets, extending the utility of FHIR for AI applications.

#### Summary

The FHIR-to-OMOP transformation is the **foundational objective** of this work. Achieving this transformation is what would enable healthcare organizations to apply real-time FHIR-based clinical data to pre-trained AI models that rely on the OMOP CDM. Through ETL processes, even fragmented or single-message FHIR resources would be made compatible with AI models trained on more comprehensive datasets, fostering more effective AI-driven healthcare decisions and interventions. **This capability remains a target state; progress toward implementation is ongoing.**

### Single-Patient FHIR to OMOP Transformation for Clinical Decision Support

Organizations that train predictive models on OMOP data need the same OMOP representation at the point of care to run those models. The training data comes from a warehouse, loaded in bulk. The patient in front of the clinician arrives as FHIR resources from the EHR, one person at a time. This use case covers the transformation between the two: FHIR resources for a single patient, converted to OMOP on request, in time for a decision support application to act on the result.

An implementer raised the use case during the Informative ballot of this guide. It extends the classification half of the [AI Training and Classification](#fhir-to-omop-transformation-for-ai-training-and-classification) use case above. That section treats the model and its deployment as downstream of this guide. This section describes what the transformation has to do when the downstream consumer is a model running inside a clinical workflow.

#### How the Use Case Works

A clinical event triggers the request: an admission, a medication order, a chart opening. The decision support application retrieves the patient's FHIR resources from the EHR's FHIR API. A transformation engine converts them to OMOP rows for that patient alone: one PERSON record plus the visits, conditions, drug exposures, measurements and observations the model reads. The model computes its features from those rows and returns a prediction to the workflow. The OMOP rows may be discarded once the prediction is returned.

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="fhir-omop-ig-single-patient-sequence.png" style="padding-top:0;padding-bottom:30px" width="800" alt="Single-patient FHIR to OMOP transformation for clinical decision support: one request end to end"/>
</figure>
{::options parse_block_html="true" /}

Bulk conversion is outside this use case. An initial warehouse load from an EHR vendor's reporting database continues to use extract tooling built for that volume.

#### What Carries Over from the Canonical Use Case

The logical models, StructureMaps, ConceptMaps and code mapping patterns in this guide operate on individual FHIR resources. They apply to one patient's resources in the same way they apply to a repository extract.

A model's validity depends on that sameness. A model trained on OMOP data expects point-of-care data to follow the conventions of its training data: the same domain assignments, the same standard concepts, the same handling of status elements and unmapped codes. Many training warehouses were loaded by a different pipeline than the one that will serve the model. The two pipelines can disagree about the same patient, and when they do the model receives inputs unlike its training data with no error raised. Comparing the output of both pipelines for a sample of patients before deployment exposes these disagreements.

{::options parse_block_html="false" /}
<figure>
<figcaption><b></b></figcaption>
<img src="fhir-omop-ig-two-routes.png" style="padding-top:0;padding-bottom:30px" width="800" alt="Two routes to OMOP, one set of mappings: the training route and the point-of-care route must agree"/>
</figure>
{::options parse_block_html="true" /}

#### Where It Differs

| | Repository to OMOP data store (canonical) | Single patient for decision support |
|---|---|---|
| **Unit of work** | A population extract or an incremental batch | One patient's resources per request |
| **Trigger** | A schedule | A clinical event |
| **Time available** | Set by the load window | Set by the clinical workflow |
| **Terminology mapping** | Lookups can be slow; unmapped codes can be reviewed and remediated after the load | Lookups complete within the request; no reviewer is available |
| **Keys** | Assigned and tracked across loads | Needed only within one patient's rows, unless results are stored |
| **Derived tables** (eras, observation periods) | Computed over the full history after the load | Computed per request if the model reads them, from the history the FHIR API returned |
| **Target** | A persistent OMOP database | Possibly a transient representation held in memory |

#### Open Questions

This version of the guide defines no conformance requirements specific to this use case. Four questions need answers from implementers with point-of-care deployments before it can.

1. **Identifier resolution.** A warehouse load assigns OMOP integer keys and tracks them across loads, as described in [Identifiers and Privacy](IdentifiersPrivacy.html). Whether a per-request transformation needs keys that are stable across requests, or only consistent within one request, depends on whether the results are stored.
2. **Terminology lookups under a latency bound.** Concept mapping against a remote terminology server may not fit inside a decision support response time. Caching ConceptMaps and vocabulary content locally raises a versioning question: the vocabulary release used at the point of care has to match, or be reconciled with, the release used to build the training data.
3. **Gaps without a reviewer.** In a warehouse load, a source code with no standard concept is recorded with concept_id 0 and can be reviewed later. At the point of care the model receives that row immediately. The transformation and the model need an agreed behavior for unmapped codes, missing elements and incomplete history.
4. **Conformance for a transient OMOP representation.** The [actors](actors.html) and conformance statements in this guide assume a Target OMOP Instance that persists. Which statements apply to a representation that exists for the length of one request is undecided.

An implementation that supports this use case declares it under the [Guidance](#guidance) below. The Biomedical Research and Regulation Work Group invites implementers with point-of-care deployments to bring their experience to the [discussion forum](https://chat.fhir.org/#narrow/stream/286658-omop-.2B-fhir).

### Guidance

§f2o-004^imp^scope:An Implementer **SHALL** declare which use cases the transformation supports. The declared set **MAY** include any of the use cases described on this page, other use cases not described here, or a stated combination, so that the scope of a given FHIR-to-OMOP transformation is stated explicitly rather than inferred.§
