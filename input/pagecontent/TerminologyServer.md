A FHIR terminology server operates as a specialized collection of functions built upon FHIR CodeSystem, ValueSet, and ConceptMap resources, specifically designed to support the complex terminology requirements inherent in transforming FHIR resources into OMOP-compliant data. (See: [FHIR Terminology Service, Basic Concepts](https://hl7.org/fhir/R5/terminology-service.html#concepts)) This greatly reduces the need for implementation teams and ETL developers to be experts in source terminologies and cross-terminology relationships to OMOP concept targets essential for compliant OMOP data normalization. Further, utilization of a terminology server greatly reduces the need for manual mapping labor and provides more consistent and uniform mapping results. 

FHIR terminology servers serve as bridge infrastructure that enable automated transformation between FHIR data sources and the OMOP CDM. The operations described below are standard FHIR terminology service operations and are supported by any conformant server; the specific endpoint used in the examples is incidental. Core functionality for FHIR to OMOP transformation centers on concept lookup and translation operations. The examples below enable systems to resolve FHIR-encoded clinical concepts to their corresponding OMOP standard concepts, retrieve concept relationships necessary for accurate domain assignment, and access the hierarchical mappings required for proper OMOP vocabulary integration. 

**A note on the examples below:** The requests in this guide are directed at `tx.fhir.org`, which is used here purely as an illustrative example. It is not a normative or required endpoint. Any conformant FHIR terminology server that hosts the relevant OMOP CodeSystem, ValueSet, and ConceptMap resources can serve this purpose equally well; implementers should substitute the base URL of whichever server they operate or subscribe to.

Note also that the responses shown here, and in particular the terminology `version` values (for example, `20250227`), reflect the state of the underlying vocabularies at the time this guide was written. These answers may change over time as the OMOP vocabularies and source terminologies are updated. Concept mappings, standard-concept designations, and display names can all shift between releases, so implementers should not treat specific returned values or versions as fixed.


### CodeSystem $Lookup Operation
The FHIR [CodeSystem/$lookup](https://hl7.org/fhir/codesystem-operation-lookup.html) provides additional information about a concept.  Given a concept ID, e.g. `1567956` we can lookup its properties:

**Request:**

```shell
curl 'https://tx.fhir.org/r5/CodeSystem/$lookup' \
  --request POST \
  --header 'Content-Type: application/json' \
  --data '{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "code",
      "valueCode": "1576196"
    },
    {
      "name": "system",
      "valueUri": "https://fhir-terminology.ohdsi.org"
    },
    {
      "name": "property",
      "valueString": "domain-id"
    },
    {
      "name": "property",
      "valueString": "standard-concept"
    },
    {
      "name": "property",
      "valueString": "Maps to"
    }
  ]
}'
```

**Response:**

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "system",
      "valueUri": "https://fhir-terminology.ohdsi.org"
    },
    {
      "name": "name",
      "valueString": "OMOP Concepts"
    },
    {
      "name": "version",
      "valueString": "20250227"
    },
    {
      "name": "code",
      "valueCode": "1576196"
    },
    {
      "name": "display",
      "valueString": "Family history of ischemic heart disease and other diseases of the circulatory system"
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "en"
        },
        {
          "name": "value",
          "valueString": "Family hx of ischem heart dis and oth dis of the circ sys"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "domain-id"
        },
        {
          "name": "value",
          "valueCode": "Observation"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "standard-concept"
        },
        {
          "name": "value",
          "valueCode": ""
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "Maps to"
        },
        {
          "name": "value",
          "valueCoding": {
            "code": "4148407"
          }
        }
      ]
    }
  ]
}
```

Note: the `version` field (here, `20250227`) identifies the vocabulary release the server was using at the time of the request. A different server, or the same server at a later date, may return a different version and correspondingly different values.

Note: this concept is non-standard (i.e. `standard-concept` is not "S"). 
To find standard concept(s) it maps to, refer to the "Maps to" property in the above response.
The value for this property is the concept ID which can be looked up separately:

**Request:**

```shell
curl 'https://tx.fhir.org/r5/CodeSystem/$lookup' \
  --request POST \
  --header 'Content-Type: application/json' \
  --data '{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "code",
      "valueCode": "4148407"
    },
    {
      "name": "system",
      "valueUri": "https://fhir-terminology.ohdsi.org"
    }
  ]
}'
```

**Response:**

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "system",
      "valueUri": "https://fhir-terminology.ohdsi.org"
    },
    {
      "name": "name",
      "valueString": "OMOP Concepts"
    },
    {
      "name": "version",
      "valueString": "20250227"
    },
    {
      "name": "code",
      "valueCode": "4148407"
    },
    {
      "name": "display",
      "valueString": "FH: Cardiovascular disease"
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "en"
        },
        {
          "name": "value",
          "valueString": "FH: CVS disorder"
        }
      ]
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "en"
        },
        {
          "name": "value",
          "valueString": "Family history of cardiovascular disease"
        }
      ]
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "en"
        },
        {
          "name": "value",
          "valueString": "Family history: Cardiovascular disease"
        }
      ]
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "en"
        },
        {
          "name": "value",
          "valueString": "Family history: Cardiovascular disease (situation)"
        }
      ]
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "es"
        },
        {
          "name": "value",
          "valueString": "antecedente familiar de cardiovasculopatía"
        }
      ]
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "es"
        },
        {
          "name": "value",
          "valueString": "antecedente familiar de enfermedad cardiovascular"
        }
      ]
    },
    {
      "name": "designation",
      "part": [
        {
          "name": "language",
          "valueCode": "es"
        },
        {
          "name": "value",
          "valueString": "antecedente familiar de enfermedad cardiovascular (situación)"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "concept-id"
        },
        {
          "name": "value",
          "valueInteger": 4148407
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "source-concept-code"
        },
        {
          "name": "value",
          "valueCoding": {
            "code": "266894000",
            "system": "http://snomed.info/sct"
          }
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "domain-id"
        },
        {
          "name": "value",
          "valueCode": "Observation"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "vocabulary-id"
        },
        {
          "name": "value",
          "valueCode": "SNOMED"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "concept-class-id"
        },
        {
          "name": "value",
          "valueCode": "Context-dependent"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "standard-concept"
        },
        {
          "name": "value",
          "valueCode": "S"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "inactive"
        },
        {
          "name": "value",
          "valueBoolean": false
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "valid-start-date"
        },
        {
          "name": "value",
          "valueDate": "2002-01-31"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "valid-end-date"
        },
        {
          "name": "value",
          "valueDate": "2099-12-31"
        }
      ]
    },
    {
      "name": "property",
      "part": [
        {
          "name": "code",
          "valueCode": "invalid-reason"
        },
        {
          "name": "value",
          "valueCode": ""
        }
      ]
    }
  ]
}
```

### ConceptMap $translate Operation 
The FHIR [ConceptMap/$translate](https://hl7.org/fhir/conceptmap-operation-translate.html) operation will provide the cross-walk from a source system to OMOP that's stored in a ConceptMap Resource.  Given a source code and system, e.g.:

```json
{
  "system": "http://hl7.org/fhir/sid/icd-10-cm",
  "code": "E11"
}
```

we can translate to the corresponding OMOP concept ID by using the "translate" operation:

**Request:**

```shell
curl 'https://tx.fhir.org/r5/ConceptMap/$translate' \
  --request POST \
  --header 'Content-Type: application/json' \
  --data '{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "sourceCoding",
      "valueCoding": {
        "system": "http://hl7.org/fhir/sid/icd-10-cm",
        "code": "E11"
      }
    },
    {
      "name": "targetSystem",
      "valueUri": "https://fhir-terminology.ohdsi.org"
    }
  ]
}'
```

**Response:**

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "result",
      "valueBoolean": true
    },
    {
      "name": "match",
      "part": [
        {
          "name": "relationship",
          "valueCode": "equivalent"
        },
        {
          "name": "concept",
          "valueCoding": {
            "code": "1567956",
            "system": "https://fhir-terminology.ohdsi.org",
            "version": "20250227"
          }
        }
      ]
    }
  ]
}
```

The resulting concept ID is `1567956`.

### Caching and Vocabulary Version Binding

A transformation of any scale will resolve the same source codes repeatedly. A single load may contain many thousands of Condition resources carrying a small number of distinct diagnosis codes, and resolving each occurrence through a separate terminology server call is wasteful in time and in load on a shared service. Caching resolved results is therefore ordinary practice, and at population scale it is effectively required for the transformation to complete in reasonable time.

Caching terminology results introduces a correctness hazard that caching in most other contexts does not. The OHDSI Standardized Vocabularies are versioned and change between releases: a concept that is Standard in one release may be deprecated in the next, a Maps to relationship may be retargeted, and a domain assignment may be corrected. A cache populated under one vocabulary version and read under another will return results that were correct when computed and are wrong when used, and the transformation has no way to detect this from the cached value alone.

The cache key must therefore incorporate the vocabulary version, not only the source system and code. A cache entry computed under one vocabulary release should be unreachable after the release changes, whether by including the version in the key, by partitioning the cache per version, or by invalidating the cache wholesale on vocabulary update. Which mechanism is used matters less than that the binding exists: an implementation whose cache outlives its vocabulary version will silently produce mappings inconsistent with the vocabulary it claims to be using.

The vocabulary version recorded for the run, as described in [Considerations for Legacy Vocabulary Versions](codemappings.html#considerations-for-legacy-vocabulary-versions), should be the same version the cache is bound to. Where these diverge, the run's documentation asserts a vocabulary version that its concept assignments do not reflect.

#### Guidance

A Transformation Engine SHOULD cache terminology server responses, and where it does so SHALL bind the cache invalidation policy to the OHDSI Vocabulary version, such that entries computed under one vocabulary version are not read under another. (f2o-111)

