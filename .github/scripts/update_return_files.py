#!/usr/bin/env python3
"""
Script to automatically update Lua return files based on preset folder contents.
This script scans preset category folders and updates corresponding return files.
"""

import os
import glob
from pathlib import Path

# Configuration matching your Lua setup
PRESET_CATEGORIES = [
    {"name": "Classical", "returnFile": "classicalreturn"},
    {"name": "Modern", "returnFile": "modernreturn"},
    {"name": "Anime", "returnFile": "animereturn"},
    {"name": "Emotional", "returnFile": "emotionalreturn"},
    {"name": "Game OST", "returnFile": "gameostreturn"},
    {"name": "Others", "returnFile": "othersreturn"}
]

PRESETS_BASE_PATH = "Main/Presets"
RETURN_TABLES_PATH = "Main/returntables"

def get_files_in_category(category_name):
    """Get all files in a specific preset category folder."""
    category_path = os.path.join(PRESETS_BASE_PATH, category_name)
    
    if not os.path.exists(category_path):
        print(f"Warning: Category folder '{category_path}' does not exist")
        return []
    
    # Get all files (not directories) in the category folder
    files = []
    for file_path in glob.glob(os.path.join(category_path, "*")):
        if os.path.isfile(file_path):
            # Extract full filename with extension
            filename = os.path.basename(file_path)
            files.append(filename)
    
    return sorted(files)  # Sort for consistent ordering

def create_lua_return_content(filenames):
    """Create the Lua return table content."""
    if not filenames:
        return "return {}\n"
    
    # Format filenames as quoted strings
    formatted_files = [f'    "{filename}"' for filename in filenames]
    content = "return {\n" + ",\n".join(formatted_files) + "\n}\n"
    
    return content

def update_return_file(category_config):
    """Update a single return file for a category."""
    category_name = category_config["name"]
    return_file = category_config["returnFile"]
    
    if not return_file:  # Skip "All Songs" category
        return
    
    print(f"Processing category: {category_name}")
    
    # Get files in the category
    files = get_files_in_category(category_name)
    print(f"Found {len(files)} files in {category_name}")
    
    # Create return file content
    lua_content = create_lua_return_content(files)
    
    # Ensure return tables directory exists
    os.makedirs(RETURN_TABLES_PATH, exist_ok=True)
    
    # Write to return file
    return_file_path = os.path.join(RETURN_TABLES_PATH, f"{return_file}.lua")
    
    try:
        # Check if file exists and content is different
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
    """Main function to update all return files."""
    print("Starting return file update process...")
    
    # Check if preset base path exists
    if not os.path.exists(PRESETS_BASE_PATH):
        print(f"Error: Presets base path '{PRESETS_BASE_PATH}' does not exist")
        return
    
    # Update each category
    for category in PRESET_CATEGORIES:
        update_return_file(category)
    
    print("Return file update process completed!")

if __name__ == "__main__":
    main()
