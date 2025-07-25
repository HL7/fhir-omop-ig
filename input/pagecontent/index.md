### Background on OHDSI
Observational Health Data Sciences and Informatics, or OHDSI is an international open-science community that aims to improve health by empowering the community to collaboratively generate the evidence that promotes better health decisions and better care. [1] OHDSI emerged as a result of the Observational Medical Outcomes Partnership (OMOP),a public-private partnership composed of members from industry, government, and academia,established to inform the appropriate use of observational healthcare databases for studying the effects of medical products, active from 2008 to 2013.[2] OMOP successfully achieved its aims to:

1. Conduct methodological research to empirically evaluate the performance of various analytical methods on their ability to identify true associations and avoid false findings
2. Develop tools and capabilities for transforming, characterizing, and analyzing disparate data sources across the health care delivery spectrum
3. Establish a shared resource so that the broader research community can collaboratively advance the science [3]

A primary driver for OHDSI today is the value proposition that data generated as a by-product of care delivery can be analyzed to produce real-world evidence, which in turn could be disseminated across healthcare systems to inform clinical practice. 

{::options parse_block_html="false" /}
<figure>
<figcaption><b>OHDSI Collaborators Worldwide</b></figcaption>
<img src="OHDSI_Collaborators_July2025.png" style="padding-top:0;padding-bottom:30px" width="800" alt="OHDSI Map of Collaborators"/>
</figure>
{::options parse_block_html="true" /}
	
The OHDSI community has experienced rapid growth and adoption of its work worldwide, totaling more than 4000 collaborators by 2024. Among its activities, OHDSI supports research collaboration via utilization of  

- The OMOP Common Data Model and OHDSI Standardized Vocabularies
- An open source stack of tools supporting analytics
- Development of advanced Research and Data Science implementation Methods 
- Clinical evidence generation and dissemination

OHDSI’s evidence has been used in policy decisions around the world and has potentially affected hundreds of millions of patients.

### The OMOP CDM
The OMOP Common Data Model (CDM) is the foundation of the OHDSI analytic technical infrastructure. Researchers in OHDSI actively use the OMOP Common Data Model as a means to standardize and align observational health data from a wide-variety of sources supporting evidence-generating analyses. As one of the foundational work-products of the OHDSI community, the OMOP CDM has a working group dedicated to its evolution supporting Real-World research use cases provided by OHDSI community members using Observational Data.  The OMOP CDM is actively maintained, supported and available in the public domain under an Apache 2.0 license. 

{::options parse_block_html="false" /}
<figure>
<figcaption><b>OMOP Common Data Model v5.4 [4]</b></figcaption>
<img src="cdm54.png" width="800" style="padding-top:0;padding-bottom:30px" alt="The OMOP v5.4 Common Data Model"/>
</figure>
{::options parse_block_html="true" /}

Observational health data transformed to the OMOP CDM  utilize the alignment afforded by standardization  to achieve consistent and reliable data quality and support analytics across geographically divergent communities at-scale. A recently published study that surveyed leading US research institutions (Clinical and Translational Science Awards (CTSA) Program members, regarding their use of data sharing tools and programs, 94% of the 50 individual respondents indicated they used at least one OMOP-based system. [5]

### OMOP + FHIR Interoperability
As stated above, OMOP has widespread deployment internationally, utilized by a research community with a track record for generating high-value evidence based on observational data and is synergistic with FHIR..  HL7 has been the world’s preeminent health data standards developer for decades. The FHIR product family’s 14+ year history of rapid adoption clearly indicates it’s the world’s most important interoperability platform for health data in our time. 

FHIR benefits from ongoing enhancements through the efforts of the HL7 [Biomedical Research and Regulation (BR&R) Working Group](https://confluence.hl7.org/spaces/BRR/pages/7012437/Biomedical+Research+and+Regulation) and the [Vulcan FHIR Accelerator](https://www.hl7vulcan.org/) supporting data exchange for real world data in observational and translational research. Whereas the FHIR accelerators and its user-community at-large are achieving enormous strides developing focused utilization of the standard in many key areas, FHIR developers do not aim to develop analytic methods that generate evidence at-scale as do members of the OHDSI community.  Rather, FHIR’s role in a research data ecosystem is provision of a platform capable of supporting lossless exchange of data, knowledge and other health artifacts via its numerous FHIR resources and compliant APIs. In contrast, the OMOP Common Data Model was designed to store observational data optimized for research analytics and for utilization by the OHDSI community using OMOP-compliant tools to generate novel research methods and discoveries improving health. FHIR and OMOP serve complementary but distinct purposes making harmonization between them essential for effective data interoperability. Implementation guides for transforming between these standards address the core interoperability paradox where "more standards lead to less interoperability," by providing standardized pathways that minimize information loss during transformation processes.[6]

Establishing a standard set of OMOP + FHIR transformations for data originating on either model will provide organizations worldwide the ability to leverage both the contemporary interoperability approaches enabled by FHIR’s API in addition to OHDSI’s advanced analytic methods, tooling *and additional commercial tools.* A stable set of transformations between FHIR and OMOP permit broader utilization of observational data in research systems, enabling FHIR API access to OMOP databases and data on FHIR servers to populate OMOP instances. This in-turn supports generation of transformed data that are comparable and consistent, increases the reliability of data, generation of knowledge artifacts, and reproducible research results. The transformation guidance in this Implementation Guide will a) reduce implementation costs, b) increase the speed of ETL in projects and c) increase the quality of transformed data for a core set of patient data.  This creates the foundation for consistent automation of OMOP + FHIR data transformations. 

Research implementations using the OMOP CDM working in tandem with the data transport strengths that FHIR brings to the table will support accelerated adoption of research methods generated by the OHDSI community to organizations also using FHIR.  This will also advance interoperable utilization of clinical research data science methods using real world data that in turn, will support advanced data science methods in translational research and data model and workflows which can improve FHIR IGs. Without consistent utilization of OMOP + FHIR in research implementations, this kind of iterative and reflexive improvement in interoperability as well as evidence-generation would be difficult to achieve.

### Role of the Vulcan FHIR Accelerator
The unique strategic strength the Vulcan community brings to this effort is through its diverse membership with representation from international academic, commercial, payor and government organizations. Projects of interest to Vulcan must meet certain criteria, particularly of interest are projects that link clinical care to clinical research. Vulcan projects should be:

1. Unique, bridging existing gaps
2. Strategically connecting stakeholders, 
3. Creating high-value collaborations
4. Maximizing available resources
5. Delivering integrated tools and solutions [7]

All of these criteria pertain to the OMOP + FHIR collaboration, but specifically, the Vulcan project as originally scoped is focused on a unique high-value work product: a canonical set of mapping from FHIR to OMOP for core EMR data, most commonly used by Vulcan members. In the Vulcan project, identification of, comparing and enhancing prior work as a means to develop standard OMOP transformations scoped to highly available EHR data on FHIR was the approach taken.  In this way, the process maximizes the effectiveness of the Vulcan resource investment and is of strategic importance to the international research community.  In the FHIR to OMOP project, Vulcan serves as

- A coordinating body and 
- a strategic consolidator of effort 
- and is a use-case mediator, maximizing value to the broadest possible research constituency

### This Implementation Guide
Substantial previous work transforming between FHIR and OMOP has been completed by many groups. However, a majority of this prior work has focused on the OMOP to FHIR direction. These OMOP to FHIR transformations enable FHIR API access to OMOP repositories, which many HL7 international realms are currently defining. This IG focuses exclusively on the reverse: FHIR to OMOP transformations, using prior FHIR to OMOP implementations as its primary reference source. The project team generated new guidance only when existing resources were unavailable from the breadth of community sample maps contributed—maps developed in real-world scenarios. Of critical importance and the aim of this publication is establishing a foundation that supports the generation of stable, reliable FHIR-to-OMOP transformation artifacts for a core set of patient data. The process of curating this prior work has additionally generated comprehensive FHIR to OMOP guidance, including considerations, best practices, and transformation principles, creating a robust foundation upon which any subsequent FHIR to OMOP specifications can build. 

This IG is limited to a common core of EHR data as expressed in the International Patient Access IG Profile(s). Beyond these core EHR elements, the project team identified a community need to include Encounter and Procedure information to achieve the goal of creating a foundational resource supporting observational research. Therefore, this IG also incorporates the Encounter and Procedures profiles from the US Core FHIR IG (STU7 Sequence) within its scope.

This IG utilizes the OMOP Common Data Model, v5.4. At the time this document was developed, v5.4 was the latest version of the OMOP CDM. In 2022, the OHDSI community made a decision to cease development of v6.0 of the OMOP CDM because v6.0 made the *_datetime fields mandatory rather than optional. This switch radically changed the assumptions related to exposure and outcome timing. Rather than proceeding with v6.0, CDM v5.4 was designed and released with additions requested by the OHDSI community while retaining the date structure of medical events from v5.3 (the version preceding both v6.0 and v5.4). Detailed changes from CDM v5.3 to v5.4 are available in the OMOP CDM GitHub documentation. New implementations are asked to transform data to CDM v5.4 until the next series of CDM versions is ready for mainstream use.[8] As such, this Implementation Guide seeks to provide transformation specifications for the most commonly used version of the OMOP CDM at present and in the near-term future.


#### References

[1] G. Hripcsak et al., "Observational Health Data Sciences and Informatics (OHDSI): Opportunities for Observational Researchers," *Stud. Health Technol. Inform.*, vol. 216, pp. 574–578, 2015.

[2] "Observational Medical Outcomes Partnership (OMOP)," FNIH, May 10, 2023. https://fnih.org/observational-medical-outcomes-partnership-omop/ (accessed Dec. 08, 2023).

[3] "OMOP CDM Background." https://ohdsi.github.io/CommonDataModel/background.html (accessed Dec. 08, 2023).

[4] G. Hripcsak, "State of the Community: Where have we been? Where are we going?," in *OHDSI 2023 Global Symposium*, Newark, NJ, 2023.

[5] E. Hall, G. Melton, P. Payne, D. Dorr and D. Vawdrey, "How Are Leading Research Institutions Engaging with Data Sharing Tools and Programs?," in *AMIA 2023 Annual Symposium*, Bethesda, MD, 2023.

[6] Tsafnat G, Dunscombe R, Gabriel D, Grieve G, Reich C. Converge or Collide? Making Sense of a Plethora of Open Data Standards in Health Care. J Med Internet Res. 2024 Apr 9;26:e55779. https://www.jmir.org/2024/1/e55779

[7] Health Level Seven, "Vulcan accelerator home." https://confluence.hl7.org/display/VA (accessed Dec. 08, 2023).

[8] "OMOP Common Data Model." https://ohdsi.github.io/CommonDataModel/index.html (accessed Dec. 08, 2023).

