### Background on OHDSI

Observational Health Data Sciences and Informatics, or OHDSI, is an international open-science community that aims to improve health by empowering the community to collaboratively generate the evidence that promotes better health decisions and better care.[1] OHDSI emerged as a result of the Observational Medical Outcomes Partnership (OMOP), a public-private partnership composed of members from industry, government, and academia, established to inform the appropriate use of observational healthcare databases for studying the effects of medical products, active from 2008 to 2013.[2]

{::options parse_block_html="false" /}
<figure>
<figcaption><b>OHDSI Collaborators Worldwide</b></figcaption>
<img src="OHDSI_Collaborators_July2025.png" style="padding-top:0;padding-bottom:30px" width="800" alt="OHDSI Map of Collaborators"/>
</figure>
{::options parse_block_html="true" /}

A primary driver for OHDSI today is the value proposition that data generated as a by-product of care delivery can be analyzed to produce real-world evidence, which in turn could be disseminated across healthcare systems to inform clinical practice. The OHDSI community has experienced rapid growth and adoption of its work worldwide, totaling more than 4000 collaborators by 2024. OHDSI's evidence has been used in policy decisions around the world and has potentially affected hundreds of millions of patients.

### The OMOP CDM

The OMOP Common Data Model (CDM) is the foundation of the OHDSI analytic technical infrastructure. Researchers in OHDSI actively use the OMOP Common Data Model as a means to standardize and align observational health data from a wide-variety of sources supporting evidence-generating analyses. As one of the foundational work-products of the OHDSI community, the OMOP CDM has a working group dedicated to its evolution supporting Real-World research use cases provided by OHDSI community members using Observational Data. The OMOP CDM is actively maintained, supported and available in the public domain under an Apache 2.0 license.

{::options parse_block_html="false" /}
<figure>
<figcaption><b>OMOP Common Data Model v5.4 [4]</b></figcaption>
<img src="cdm54.png" width="800" style="padding-top:0;padding-bottom:30px" alt="The OMOP v5.4 Common Data Model"/>
</figure>
{::options parse_block_html="true" /}

Observational health data transformed to the OMOP CDM utilize the alignment afforded by standardization to achieve consistent and reliable data quality and support analytics across geographically divergent communities at-scale. A recently published study that surveyed leading US research institutions (Clinical and Translational Science Awards (CTSA) Program members) regarding their use of data sharing tools and programs found that 94% of the 50 individual respondents indicated they used at least one OMOP-based system.[5]

OMOP successfully achieved its original aims to:

1. Conduct methodological research to empirically evaluate the performance of various analytical methods on their ability to identify true associations and avoid false findings
2. Develop tools and capabilities for transforming, characterizing, and analyzing disparate data sources across the health care delivery spectrum
3. Establish a shared resource so that the broader research community can collaboratively advance the science [3]

Among its activities, OHDSI supports research collaboration via utilization of:

- The OMOP Common Data Model and OHDSI Standardized Vocabularies
- An open source stack of tools supporting analytics
- Development of advanced Research and Data Science implementation Methods
- Clinical evidence generation and dissemination

#### CDM Version History

This Implementation Guide utilizes OMOP CDM v5.4. In 2022, the OHDSI community made a decision to cease development of v6.0 of the OMOP CDM because v6.0 made the *_datetime fields mandatory rather than optional. This switch radically changed the assumptions related to exposure and outcome timing. Rather than proceeding with v6.0, CDM v5.4 was designed and released with additions requested by the OHDSI community while retaining the date structure of medical events from v5.3 (the version preceding both v6.0 and v5.4). Detailed changes from CDM v5.3 to v5.4 are available in the OMOP CDM GitHub documentation. New implementations are asked to transform data to CDM v5.4 until the next series of CDM versions is ready for mainstream use.[6]

#### References

[1] G. Hripcsak et al., "Observational Health Data Sciences and Informatics (OHDSI): Opportunities for Observational Researchers," *Stud. Health Technol. Inform.*, vol. 216, pp. 574–578, 2015.

[2] "Observational Medical Outcomes Partnership (OMOP)," FNIH, May 10, 2023. https://fnih.org/observational-medical-outcomes-partnership-omop/ (accessed Dec. 08, 2023).

[3] "OMOP CDM Background." https://ohdsi.github.io/CommonDataModel/background.html (accessed Dec. 08, 2023).

[4] G. Hripcsak, "State of the Community: Where have we been? Where are we going?," in *OHDSI 2023 Global Symposium*, Newark, NJ, 2023.

[5] E. Hall, G. Melton, P. Payne, D. Dorr and D. Vawdrey, "How Are Leading Research Institutions Engaging with Data Sharing Tools and Programs?," in *AMIA 2023 Annual Symposium*, Bethesda, MD, 2023.

[6] "OMOP Common Data Model." https://ohdsi.github.io/CommonDataModel/index.html (accessed Dec. 08, 2023).
