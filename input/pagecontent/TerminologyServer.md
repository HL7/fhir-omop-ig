# Terminology Server

## [ConceptMap/$translate](https://www.hl7.org/fhir/R5/conceptmap-operation-translate.html)

Given a source code and system, e.g.:

```json
{
  "system": "http://hl7.org/fhir/sid/icd-10-cm",
  "code": "E11"
}
```

we can translate to the corresponding OMOP concept ID by using the "translate" operation:

**Request:**

```shell
curl 'https://echidna.fhir.org/r5/ConceptMap/$translate' \
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


## [CodeSystem/$lookup](https://www.hl7.org/fhir/R5/codesystem-operation-lookup.html)

Given a concept ID, e.g. `1567956` we can lookup its properties:

**Request:**

```shell
curl 'https://echidna.fhir.org/r5/CodeSystem/$lookup' \
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

Note: this concept is non-standard (i.e. `standard-concept` is not "S"). 
To find standard concept(s) it maps to, refer to the "Maps to" property in the above response.
The value for this property is the concept ID which can be looked up separately:

**Request:**

```shell
curl 'https://echidna.fhir.org/r5/CodeSystem/$lookup' \
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
