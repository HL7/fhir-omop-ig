This Implementation Guide was developed under the auspices of the [Vulcan](https://www.hl7vulcan.org/) FHIR to OMOP work group in collaboration with the [OHDSI OMOP + FHIR working group](https://teams.microsoft.com/l/channel/19%3A-Ibt97TB7nWlChokQ8nZT0AdrnFWGz84txuAWme-Idc1%40thread.tacv2/General?groupId=18ebd320-eb79-4fd2-8893-b38496d607a4&tenantId=a30f0094-9120-4aab-ba4c-e5509023b2d5).  

We extend our heartfelt gratitude to **Dr. Christopher Chute**, whose vision and leadership made this project possible. Dr. Chute not only conceived and initiated this effort by proposing it to the Vulcan Steering Committee, but also provided unwavering executive sponsorship and representation throughout the entire project lifecycle. We also want to recognize the efforts of Vulcan PMO Director, **Filippo Napoli** whose skill and dedication were invaluable in helping us achieve this critical project milestone.  

## Primary Authors

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Davera Gabriel</td>
      <td style="border: 1px solid #d0d7de;">Evidentli, Inc</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Jean Duteau</td>
      <td style="border: 1px solid #d0d7de;">Dogwood Consulting</td>
    </tr>
  </tbody>
</table>

## Primary Editors

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Adam Lee</td>
      <td style="border: 1px solid #d0d7de;">University of North Carolina</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Guy Tsafnat</td>
      <td style="border: 1px solid #d0d7de;">Evidentli, Inc</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Michael Van Treeck</td>
      <td style="border: 1px solid #d0d7de;">Evidentli, Inc</td>
    </tr>
  </tbody>
</table>

## Vulcan FHIR to OMOP Working Group Co-Leads

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Davera Gabriel</td>
      <td style="border: 1px solid #d0d7de;">Evidentli, Inc</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Catherine Diederich</td>
      <td style="border: 1px solid #d0d7de;">Duke University</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Adam Lee</td>
      <td style="border: 1px solid #d0d7de;">University of North Carolina</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Lukasz Kazmarek</td>
      <td style="border: 1px solid #d0d7de;">F. Hoffmann-La Roche AG</td>
    </tr>
  </tbody>
</table>

## Past project FHIR to OMOP transformation maps & technical implementation expertise contributed by

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Contributors</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">CareEvolution, Inc</td>
      <td style="border: 1px solid #d0d7de;">Ben Berk<br>Scott Favre</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Georgia Tech Research Institute (GTRI)</td>
      <td style="border: 1px solid #d0d7de;">Myung Choi</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Evidentli, Inc</td>
      <td style="border: 1px solid #d0d7de;">Guy Tsafnat<br>Michael Van Treeck<br>Davera Gabriel</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">FHIR-OMOP Oncology Use Case Subgroup</td>
      <td style="border: 1px solid #d0d7de;">Qi Yang (IQVIA)<br>May Terry (MITRE Corp)</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">National Association of Community Health Centers (NACHC)</td>
      <td style="border: 1px solid #d0d7de;">John Gresh (Curlew Consulting)</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Technische Universitat (TU) Dresden</td>
      <td style="border: 1px solid #d0d7de;">Elisa Henke<br>Yuan Peng</td>
    </tr>
  </tbody>
</table>


## FHIR - OMOP Collaboration Subgroup Leaders

We also recognize the exceptional contributions of the leaders from the four FHIR - OMOP subgroups that preceded the formation of the Vulcan IG project. These dedicated teams explored critical concepts and established foundational principles that were integrated into this implementation guide.

### Data Harmonization Subgroup
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Ben Smith</td>
      <td style="border: 1px solid #d0d7de;">Principia, Inc</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Guy Tsafnat</td>
      <td style="border: 1px solid #d0d7de;">Evidentli, Inc</td>
    </tr>
  </tbody>
</table>

### Terminology Subgroup
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Davera Gabriel</td>
      <td style="border: 1px solid #d0d7de;">Johns Hopkins University</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Grahame Grieve</td>
      <td style="border: 1px solid #d0d7de;">Health Intersections, Inc</td>
    </tr>
  </tbody>
</table>

### Oncology Use Case Subgroup
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">May Terry</td>
      <td style="border: 1px solid #d0d7de;">MITRE Corporation</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Qi Yang</td>
      <td style="border: 1px solid #d0d7de;">IQVIA, INC</td>
    </tr>
  </tbody>
</table>

### Digital Quality Measures Use Case
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Floyd Eisenberg</td>
      <td style="border: 1px solid #d0d7de;">iParsimony, LLC</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Ben Hamlin</td>
      <td style="border: 1px solid #d0d7de;">National Committee for Quality Assurance</td>
    </tr>
  </tbody>
</table>

## 2025 Vulcan Virtual Connectathon

We are deeply appreciative of all the participants in the July 2025 Connectathon, whose valuable testing and feedback on the technical artifacts significantly accellerated the development of this implementation guide. We especially appreciate the contributions of **Ben Berk** and **Scott Favre** of CareEvolution who conceived and created the [FHIR and OMOP Validation Package](https://build.fhir.org/ig/HL7/fhir-omop-ig/technical_artifacts.html#fhir-and-omop-2025-connectathon-validation-package) for the Connectathon, and a persisting resource for the Community at-large. 

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto;">
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Rebecca Baker</td>
      <td style="border: 1px solid #d0d7de;">Abderrazek Boufahja</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Benjamin Berk</td>
      <td style="border: 1px solid #d0d7de;">Myung Choi</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Indraneel Dasari</td>
      <td style="border: 1px solid #d0d7de;">Jean Duteau</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Scott Favre</td>
      <td style="border: 1px solid #d0d7de;">Davera Gabriel</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Youngmi Han</td>
      <td style="border: 1px solid #d0d7de;">Adam Lee</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Prasanth Nannapaneni</td>
      <td style="border: 1px solid #d0d7de;">Filippo Napoli</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Chris Roeder</td>
      <td style="border: 1px solid #d0d7de;">Will Roddy</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Guy Tsafnat</td>
      <td style="border: 1px solid #d0d7de;">Michael Van Treeck</td>
    </tr>
  </tbody>
</table>

## Working Group Calls
Throughout this project, more than 100 individuals from over 70 organizations, representing academia, government, and industry contributed their decades of experience in managing Real-World Data to support the best practices proposed. Working group participants that took active roles in discussions leading to generation of the narrative and technical artifacts presented in this IG include: 

### Academic Organizations

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Danielle Boyce</td>
      <td style="border: 1px solid #d0d7de;">Johns Hopkins University</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Alex Cheng</td>
      <td style="border: 1px solid #d0d7de;">Vanderbilt University</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Myung Choi</td>
      <td style="border: 1px solid #d0d7de;">Georgia Institute of Technology</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Shahim Essaid</td>
      <td style="border: 1px solid #d0d7de;">University of North Carolina</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Stephanie Hong</td>
      <td style="border: 1px solid #d0d7de;">Johns Hopkins University</td>
    </tr>
      <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Andrew Kanter</td>
      <td style="border: 1px solid #d0d7de;">Columbia University</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Bryan Laraway</td>
      <td style="border: 1px solid #d0d7de;">University of North Carolina</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Adam Lee</td>
      <td style="border: 1px solid #d0d7de;">University of North Carolina</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Karthik Natarajan</td>
      <td style="border: 1px solid #d0d7de;">Columbia University</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Jason Patterson</td>
      <td style="border: 1px solid #d0d7de;">Columbia University</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Andrea Pitkus</td>
      <td style="border: 1px solid #d0d7de;">University of Wisconsin - Madison</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Sridhar Ramachandran</td>
      <td style="border: 1px solid #d0d7de;">Indiana University</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Chris Roeder</td>
      <td style="border: 1px solid #d0d7de;">University of North Carolina</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Asif Syed</td>
      <td style="border: 1px solid #d0d7de;">MD Anderson Cancer Center</td>
    </tr>
      <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Xiaohan Zhang</td>
      <td style="border: 1px solid #d0d7de;">Johns Hopkins University</td>
    </tr>
  </tbody>
</table>


### Government Organizations

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Amanda Deering</td>
      <td style="border: 1px solid #d0d7de;">US Centers for Disease Control</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Matt Elrod</td>
      <td style="border: 1px solid #d0d7de;">National Coordinator for Health Information Technology (ONC)</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Brian Gugerty</td>
      <td style="border: 1px solid #d0d7de;">National Institutes of Health</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Kevin Lan</td>
      <td style="border: 1px solid #d0d7de;">US Centers for Disease Control</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Jane Pollack</td>
      <td style="border: 1px solid #d0d7de;">National Cancer Institute</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Harsh Sharma</td>
      <td style="border: 1px solid #d0d7de;">Fraser Health Authority</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Ken Wilkins</td>
      <td style="border: 1px solid #d0d7de;">National Institutes of Health</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Sonya Zhan</td>
      <td style="border: 1px solid #d0d7de;">US Centers for Disease Control</td>
    </tr>
  
  </tbody>
</table>


### Industry Organizations

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: auto%;">
  <thead>
    <tr style="background-color: #f6f8fa;">
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Name</th>
      <th style="border: 1px solid #d0d7de; text-align: left; font-weight: bold;">Organization</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border: 1px solid #d0d7de;">Adam Bouras</td>
      <td style="border: 1px solid #d0d7de;">Tritonis, Inc</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Scott Favre</td>
      <td style="border: 1px solid #d0d7de;">CareEvolution</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">John Gresh</td>
      <td style="border: 1px solid #d0d7de;">Curlew Consulting</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Mike Hamidi</td>
      <td style="border: 1px solid #d0d7de;">Walmart Healthcare Research Institute</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Ben Hamlin</td>
      <td style="border: 1px solid #d0d7de;">National Committee for Quality Assurance</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Amro Hassan</td>
      <td style="border: 1px solid #d0d7de;">Alliance Chicago</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Lukasz Kaczmarek</td>
      <td style="border: 1px solid #d0d7de;">F. Hoffmann-La Roche AG</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Sergey Krikov</td>
      <td style="border: 1px solid #d0d7de;">Parexel</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Nareesa Mohammed-Rajput, MD</td>
      <td style="border: 1px solid #d0d7de;">MITRE Corporation</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Henry Ogoe</td>
      <td style="border: 1px solid #d0d7de;">Publicis Sapient</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Ann Phillips</td>
      <td style="border: 1px solid #d0d7de;">Intelligent Medical Objects</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Christian Reich</td>
      <td style="border: 1px solid #d0d7de;">Odysseus Data Services</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Sebastian van Sandijk</td>
      <td style="border: 1px solid #d0d7de;">Odysseus Data Services</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Hayden Spence</td>
      <td style="border: 1px solid #d0d7de;">Aptive Resources</td>
    </tr>
    <tr>
      <td style="border: 1px solid #d0d7de;">Thomas Stone</td>
      <td style="border: 1px solid #d0d7de;">F. Hoffmann-La Roche AG</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">May Terry</td>
      <td style="border: 1px solid #d0d7de;">MITRE Corporation</td>
    </tr>
    <tr style="background-color: #f6f8fa;">
      <td style="border: 1px solid #d0d7de;">Thomas White</td>
      <td style="border: 1px solid #d0d7de;">MedStar Health</td>
    </tr>
  </tbody>
</table>

We recognize that this guide establishes an important foundation, and also acknowledge that many opportunities for additional data domains and use cases remain. Please eMail the [Vulcan PMO](mailto:[email@domain.com](https://www.hl7vulcan.org/contact-us)) with questions or comments falling outside the established HL7 balloting process. We welcome your feedback and encourage continued collaborations to more fully realize the transformative potential that these two complementary standards can bring to advancing human health.
