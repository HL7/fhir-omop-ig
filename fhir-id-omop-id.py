import json
import sys

def letter_to_number(char):
    """Convert a letter to its position in the alphabet (a=1, b=2, etc)"""
    if char.isalpha():
        return str((ord(char.upper()) - ord('A')) + 1)
    return char

def convert_letters_to_numbers(text):
    """Convert all letters in text to their numeric equivalents"""
    return ''.join(letter_to_number(c) for c in text)


def find_identifier_value(data):
    """Recursively find the first 'identifier' value in JSON data.
    Returns the string value if found, otherwise None.
    """
    if isinstance(data, dict):
        for k, v in data.items():
            if k == 'identifier':
                if isinstance(v, list):
                    for item in v:
                        if isinstance(item, dict) and 'value' in item:
                            return item['value']
                elif isinstance(v, dict) and 'value' in v:
                    return v['value']
            # Recurse into value
            res = find_identifier_value(v)
            if res is not None:
                return res
    elif isinstance(data, list):
        for item in data:
            res = find_identifier_value(item)
            if res is not None:
                return res
    return None

def find_id_value(data):
    """Recursively find the first 'id' value in JSON data.
    Returns the string value if found, otherwise None.
    """
    if isinstance(data, dict):
        for k, v in data.items():
            if k == 'id' and isinstance(v, str):
                return v
            # Recurse into value
            res = find_id_value(v)
            if res is not None:
                return res
    elif isinstance(data, list):
        for item in data:
            res = find_id_value(item)
            if res is not None:
                return res
    return None

def find_all_id_values(data):
    """Recursively find all 'id' values in JSON data.
    Returns a list of unique id strings found.
    """
    ids = []
    
    def collect_ids(obj):
        if isinstance(obj, dict):
            for k, v in obj.items():
                if k == 'id' and isinstance(v, str):
                    if v not in ids:
                        ids.append(v)
                collect_ids(v)
        elif isinstance(obj, list):
            for item in obj:
                collect_ids(item)
    
    collect_ids(data)
    return ids

def process_data(data, search_string, replacement):
    """Process JSON data in-memory, searching and replacing values.
    
    Returns the modified data object.
    """
    def process_value(value):
        if isinstance(value, str):
            result = value
            if search_string not in result:
                return result
            
            import re
            
            # First, replace ResourceType/<search_string> patterns (in References, URLs, etc.)
            # Match patterns like 'Patient/infant', 'Condition/uuid-style-id', or in URLs
            pattern_ref = r"([A-Za-z][A-Za-z0-9_]*)/" + re.escape(search_string) + r"(?=[\"'\s,}\]/]|$)"
            if re.search(pattern_ref, result):
                result = re.sub(r"([A-Za-z][A-Za-z0-9_]*/)" + re.escape(search_string) + r"(?=[\"'\s,}\]/]|$)",
                                lambda m: m.group(1) + replacement,
                                result)
            
            # Then, replace any remaining bare search_string occurrences (e.g., in valueString/valueUri fields)
            if search_string in result:
                # If the identifier appears as part of a URN (e.g. 'urn:uuid:...'),
                # replace the whole string with the cleaned replacement (no prefix).
                if 'uuid:' in result.lower():
                    result = replacement
                else:
                    result = result.replace(search_string, replacement)
            
            return result
        elif isinstance(value, dict):
            return {k: process_value(v) for k, v in value.items()}
        elif isinstance(value, list):
            return [process_value(item) for item in value]
        return value

    return process_value(data)


def search_and_convert(json_file, search_string, replacement):
    """Search JSON file for `search_string` and replace with `replacement`"""
    with open(json_file, 'r') as f:
        data = json.load(f)
    return process_data(data, search_string, replacement)


def prepare_search_and_replacement(identifier_value):
    """Given an identifier string, return (search_string, replacement).

    - `search_string` is the full token to locate in JSON (the part after 'uuid:' if present,
      otherwise the full value with all characters preserved).
    - `replacement` is the alphanumeric part with letters converted to numbers.
    """
    if not identifier_value:
        return None, None

    low = identifier_value.lower()
    if 'uuid:' in low:
        idx = low.rfind('uuid:')
        token_raw = identifier_value[idx+5:]
    else:
        # Use the full value as-is, preserving hyphens and other characters
        token_raw = identifier_value

    # Extract only alphanumeric characters for the replacement conversion
    cleaned = ''.join(ch for ch in token_raw if ch.isalnum())
    replacement = convert_letters_to_numbers(cleaned)
    return token_raw, replacement

if __name__ == "__main__":
    json_file = input("Enter JSON file path: ")
    try:
        with open(json_file, 'r') as f:
            data = json.load(f)
    except Exception:
        data = None

    if data is None:
        print(f"Failed to load JSON file: {json_file}")
        sys.exit()

    # Try to find identifier.value first, then also collect all resource ids
    identifier_value = find_identifier_value(data)
    all_ids = find_all_id_values(data)
    
    # If identifier.value found and not already in all_ids, add it
    if identifier_value and identifier_value not in all_ids:
        all_ids.insert(0, identifier_value)
    
    if not all_ids:
        print(f"No identifiers found in file {json_file}")
        sys.exit()

    result = data
    
    # Process each unique identifier/id
    for identifier_value in all_ids:
        token, replacement = prepare_search_and_replacement(identifier_value)
        if token is None:
            search_string = identifier_value
            replacement = convert_letters_to_numbers(''.join(ch for ch in identifier_value if ch.isalnum()))
        else:
            search_string = token
        
        # Check if the search_string is already the same as replacement (no conversion needed)
        if search_string == replacement:
            print(f"Already valid (skipping): {identifier_value}")
            continue
        
        print(f"Converting identifier token: {search_string} -> {replacement}")
        
        # Repeat until no more changes are found for this identifier
        while True:
            new_result = process_data(result, search_string, replacement)
            if new_result == result:
                break
            result = new_result

    # Overwrite the original JSON file with the updated content
    try:
        with open(json_file, 'w', encoding='utf-8') as out:
            json.dump(result, out, indent=2, ensure_ascii=False)
        print(f"Updated file saved: {json_file}")
    except Exception as e:
        print(f"Error saving updated file: {e}")
    # Also print the JSON to stdout for immediate inspection
    print(json.dumps(result, indent=2))