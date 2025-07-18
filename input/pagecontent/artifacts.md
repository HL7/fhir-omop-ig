### Logical Models
This guide contains a set of logical models that describe the OMOP CDM.  By expressing the CDM tables as FHIR Logical models, we are able to express the mappings between the tables and FHIR resources using FHIR StructureMaps.

* [CareSite](StructureDefinition-CareSite.html)
* [Condition Era](StructureDefinition-ConditionEra.html)
* [Condition Occurrence](StructureDefinition-ConditionOccurrence.html)
* [Cost](StructureDefinition-Cost.html)
* [Death](StructureDefinition-Death.html)
* [Device Exposure](StructureDefinition-DeviceExposure.html)
* [Dose Era](StructureDefinition-DoseEra.html)
* [Drug Era](StructureDefinition-DrugEra.html)
* [Drug Exposure](StructureDefinition-DrugExposure.html)
* [Episode Event](StructureDefinition-EpisodeEvent.html)
* [Episode](StructureDefinition-Episode.html)
* [Fact Relationship](StructureDefinition-FactRelationship.html)
* [Location](StructureDefinition-Location.html)
* [Measurement](StructureDefinition-Measurement.html)
* [Note NLP](StructureDefinition-NoteNLP.html)
* [Note](StructureDefinition-Note.html)
* [Observation](StructureDefinition-Observation.html)
* [Observation Period](StructureDefinition-ObservationPeriod.html)
* [Payer Plan Period](StructureDefinition-PayerPlanPeriod.html)
* [Person](StructureDefinition-Person.html)
* [Procedure Occurrence](StructureDefinition-ProcedureOccurrence.html)
* [Provider](StructureDefinition-Provider.html)
* [Specimen](StructureDefinition-Specimen.html)
* [Visit Detail](StructureDefinition-VisitDetail.html)
* [Visit Occurrence](StructureDefinition-VisitOccurrence.html)

### Structure Maps
The mappings are represented via FHIR StructureMaps and those StructureMaps are presented using the [FHIR Mapping Language](https://hl7.org/fhir/mapping-language.html).  There do not exist mappings for all FHIR resources to all OMOP tables, but rather a select few.  The mappings were chosen from the resources that were profiled by the International Patient Access IG along with Encounter and Procedure which were deemed to be important to map.  For each mapping, there are considerations listed along with the mapping itself.

* [Allergy Mapping](StructureMap-AllergyMap.html)
* [Condition Mapping](StructureMap-ConditionMap.html)
* [Encounter/Visit Mapping](StructureMap-EncounterVisitMap.html)
* [Immunization Mapping](StructureMap-ImmunizationMap.html)
* [MedicationStatement Mapping](StructureMap-MedicationMap.html)
* [Observation to Measurement Mapping](StructureMap-MeasurementMap.html)
* [Observation to Observation Mapping](StructureMap-ObservationMap.html)
* [Procedure Mapping](StructureMap-ProcedureMap.html)

### Technical Considerations
The following tables provide some technical information about the guide.

#### Cross-Version Analysis
{% include cross-version-analysis.xhtml %}

#### Intellectual Property Statements
{% include ip-statements.xhtml %}

#### Global Profiles

{% include globals-table.xhtml %}

#### IG Dependencies

This IG Contains the following dependencies on other IGs.

{% include dependency-table.xhtml %}
