This Implementation Guide was developed under the auspices of the [Vulcan](https://www.hl7vulcan.org/) FHIR to OMOP work group in collaboration with the OHDSI OMOP + FHIR working group.

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
      <td style="border: 1px solid #d0d7de;">Michael Van Treek</td>
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
      <td style="border: 1px solid #d0d7de;">Guy Tsafnat<br>Michael Van Treek<br>Davera Gabriel</td>
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

Throughout this project, more than 100 individuals from over 70 organizations—representing academia, government, industry, and data standards development—contributed their decades of experience in managing Real-World Data to support the best practices proposed. We recognize that this guide establishes an important foundation, and also acknowledge that many opportunities for additional data domains and use cases remain. Please eMail https://www.hl7vulcan.org/contact-us with questions or comments falling outside the established HL7 balloting process. We welcome your feedback and encourage continued collaborations to more fully realize the transformative potential that these two complementary standards can bring to advancing human health.

## Academic

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
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
      <td style="border: 1px solid #d0d7de;">Dr. Asif Syed</td>
      <td style="border: 1px solid #d0d7de;">MD Anderson Cancer Center</td>
    </tr>
  </tbody>
</table>


## Government

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
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


## Industry

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
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
  </tbody>
</table>


