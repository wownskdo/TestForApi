import os
import glob
from pathlib import Path

PRESET_CATEGORIES = [
    {"name": "Classical", "returnFile": "classicalreturn"},
    {"name": "Modern", "returnFile": "modernreturn"},
    {"name": "Anime", "returnFile": "animereturn"},
    {"name": "Emotional", "returnFile": "emotionalreturn"},
    {"name": "Game OST", "returnFile": "gameostreturn"},
    {"name": "Others", "returnFile": "othersreturn"},
    {"name": "Movie", "returnFile": "moviereturn"}
]

PRESETS_BASE_PATH = "Main/Presets"
RETURN_TABLES_PATH = "Main/returntables"

def get_files_in_category(category_name):
    category_path = os.path.join(PRESETS_BASE_PATH, category_name)
    
    if not os.path.exists(category_path):
        print(f"Warning: Category folder '{category_path}' does not exist")
        return []
    
    files = []
    for file_path in glob.glob(os.path.join(category_path, "*")):
        if os.path.isfile(file_path):
            filename = os.path.basename(file_path)
            files.append(filename)
    
    return sorted(files)

def create_lua_return_content(filenames):
    if not filenames:
        return "return {}\n"
    
    formatted_files = [f'    "{filename}"' for filename in filenames]
    content = "return {\n" + ",\n".join(formatted_files) + "\n}\n"
    
    return content

def update_return_file(category_config):
    category_name = category_config["name"]
    return_file = category_config["returnFile"]
    
    if not return_file:
        return
    
    print(f"Processing category: {category_name}")
    
    files = get_files_in_category(category_name)
    print(f"Found {len(files)} files in {category_name}")
    
    lua_content = create_lua_return_content(files)
    
    os.makedirs(RETURN_TABLES_PATH, exist_ok=True)
    
    return_file_path = os.path.join(RETURN_TABLES_PATH, f"{return_file}.lua")
    
    try:
        write_file = True
        if os.path.exists(return_file_path):
            with open(return_file_path, 'r', encoding='utf-8') as f:
                existing_content = f.read()
            if existing_content == lua_content:
                print(f"No changes needed for {return_file}.lua")
                write_file = False
        
        if write_file:
            with open(return_file_path, 'w', encoding='utf-8') as f:
                f.write(lua_content)
            print(f"Updated {return_file}.lua with {len(files)} files")
            
    except Exception as e:
        print(f"Error updating {return_file}.lua: {e}")

def main():
    print("Starting return file update process...")
    
    if not os.path.exists(PRESETS_BASE_PATH):
        print(f"Error: Presets base path '{PRESETS_BASE_PATH}' does not exist")
        return
    
    for category in PRESET_CATEGORIES:
        update_return_file(category)
    
    print("Return file update process completed!")

if __name__ == "__main__":
    main()
