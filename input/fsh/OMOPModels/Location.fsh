Logical: Location
Parent: Base
Id: Location
Characteristics: #can-be-target
Title: "Location OMOP Table"
Description: "The LOCATION table represents a generic way to capture physical location or address information of Persons and Care Sites."

* location_id	1..1	integer	"Location Identifier" "The unique key given to a unique Location."
* address_1	0..1	string	"Address Line 1" "This is the first line of the address."
* address_2	0..1	string	"Address Line 2" "This is the second line of the address"
* city	0..1	string	"City"	""
* state	0..1	string	"State" ""
* zip	0..1	string	"Zip Code" ""
* county	0..1	string	"County" ""
* location_source_value	0..1	string	"Location Identifier Source Value" ""
* country_concept_id	0..1	code	"Country" "The Concept Id representing the country. Values should conform to the [Geography](https://athena.ohdsi.org/search-terms/terms?domain=Geography&standardConcept=Standard&page=1&pageSize=15&query=&boosts) domain."
* country_source_value	0..1	string	"Country Source Value" "The name of the country."
* latitude	0..1	decimal	"Latitude" ""
* longitude	0..1	decimal	"Longitude" ""