Instance: pas-client-actor
InstanceOf: ActorDefinition
Title: "PAS Client"
Usage: #definition
* id = "client"
* url = "http://hl7.org/fhir/us/davinci-pas/ActorDefinition/client"
* name = "PASClientActor"
* description = "Any system (or collection of systems) that is responsible for requesting prior authorizations."
* type = #system
* insert CommonActor

Instance: pas-payer-actor
InstanceOf: ActorDefinition
Title: "PAS Payer"
Usage: #definition
* id = "payer"
* url = "http://hl7.org/fhir/us/davinci-pas/ActorDefinition/payer"
* name = "PASPayerActor"
* description = "Any system (or collection of systems) that is responsible for responding to prior authorization requests."
* type = #system
* insert CommonActor

RuleSet: CommonActor
* status = #active
* experimental = false
* date = "2026-01-28"