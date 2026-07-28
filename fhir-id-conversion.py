import json
import re
from pathlib import Path

def replace_ids_sequentially(json_file):
    """
    Replace all IDs in a JSON document with sequential numbers.
    Searches for IDs in: id, identifier.value, reference.value, valueString, valueUri fields.
    """
    
    # Read the JSON file
    with open(json_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    data = json.loads(content)
    
    # Track replacements: original_id -> sequential_number
    id_mapping = {}
    counter = 1
    
    # Find all IDs in order of appearance
    def extract_ids(obj, in_extension=False):
        nonlocal counter
        
        def add_id(candidate):
            nonlocal counter
            if candidate and candidate not in id_mapping:
                id_mapping[candidate] = str(counter)
                counter += 1

        def extract_reference_value(ref):
            if isinstance(ref, dict):
                return extract_reference_value(ref.get("value"))
            if isinstance(ref, str):
                if "/" in ref:
                    return ref.rsplit("/", 1)[-1]
                return ref
            return None
        
        if isinstance(obj, dict):
            if "id" in obj and obj["id"]:
                add_id(obj["id"])
            
            for id_field in ("identifier", "targetIdentifier"):
                if id_field in obj:
                    if isinstance(obj[id_field], list):
                        for item in obj[id_field]:
                            if isinstance(item, dict) and "value" in item:
                                add_id(item["value"])
                    elif isinstance(obj[id_field], dict) and "value" in obj[id_field]:
                        add_id(obj[id_field]["value"])
            
            if "reference" in obj:
                add_id(extract_reference_value(obj["reference"]))
            
            if in_extension and "valueString" in obj and obj["valueString"]:
                add_id(extract_reference_value(obj["valueString"]))
            if "valueUri" in obj and obj["valueUri"]:
                add_id(extract_reference_value(obj["valueUri"]))
            
            for key, value in obj.items():
                child_extension = in_extension or key == "extension"
                extract_ids(value, child_extension)
        
        elif isinstance(obj, list):
            for item in obj:
                extract_ids(item, in_extension)
    
    def replace_ids(obj, in_extension=False):
        if isinstance(obj, dict):
            replaced = {}
            for key, value in obj.items():
                if key == "id" and isinstance(value, str):
                    replaced[key] = id_mapping.get(value, value)
                elif key == "identifier" and isinstance(value, list):
                    replaced[key] = [
                        {**item, "value": id_mapping.get(item["value"], item["value"])}
                        if isinstance(item, dict) and "value" in item else item
                        for item in value
                    ]
                elif key in ("identifier", "targetIdentifier") and isinstance(value, list):
                    replaced[key] = [
                        {**item, "value": id_mapping.get(item["value"], item["value"])}
                        if isinstance(item, dict) and "value" in item else item
                        for item in value
                    ]
                elif key in ("identifier", "targetIdentifier") and isinstance(value, dict):
                    new_value = value.copy()
                    if "value" in new_value:
                        new_value["value"] = id_mapping.get(new_value["value"], new_value["value"])
                    replaced[key] = new_value
                elif key == "reference":
                    replaced[key] = replace_reference(value)
                elif key == "fullUrl" and isinstance(value, str):
                    replaced[key] = replace_url_ids(value)
                elif key == "url" and isinstance(value, str):
                    replaced[key] = replace_url_ids(value)
                elif key == "valueString" and isinstance(value, str):
                    replaced[key] = replace_reference(value) if in_extension else value
                elif key == "valueUri" and isinstance(value, str):
                    replaced[key] = replace_reference(value)
                else:
                    child_extension = in_extension or key == "extension"
                    replaced[key] = replace_ids(value, child_extension)
            return replaced
        elif isinstance(obj, list):
            return [replace_ids(item, in_extension) for item in obj]
        return obj

    def replace_reference(value):
        if isinstance(value, dict):
            new_ref = value.copy()
            if "value" in new_ref:
                new_ref["value"] = replace_reference(new_ref["value"])
            return new_ref
        if isinstance(value, str):
            if value in id_mapping:
                return id_mapping[value]
            for original_id, new_id in id_mapping.items():
                if value.endswith(f"/{original_id}"):
                    return value[: -len(original_id)] + new_id
            return value
        return value

    def replace_url_ids(value):
        """Replace IDs found anywhere in a URL string."""
        if isinstance(value, str):
            result = value
            for original_id, new_id in id_mapping.items():
                result = result.replace(f"/{original_id}/", f"/{new_id}/")
                result = result.replace(f"/{original_id}", f"/{new_id}")
            return result
        return value

    extract_ids(data)
    data = replace_ids(data)
    
    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"Replaced {len(id_mapping)} unique IDs")
    print("Mapping:", id_mapping)


if __name__ == "__main__":
    json_file = input("Enter path to JSON file: ")
    replace_ids_sequentially(json_file)