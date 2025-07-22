#!/usr/bin/env python3
import re

# Read the old beast.cairo file
with open('/workspace/beasts_old/beasts/src/beast.cairo', 'r') as f:
    content = f.read()

# Find all SVG functions
pattern = r'fn (get_(\w+)_svg\(\) -> LongString \{.*?\n\})'
matches = re.findall(pattern, content, re.DOTALL)

# Extract and convert each function
converted_functions = []

for match in matches:
    full_func = match[0]
    beast_name = match[1].upper()
    
    # Extract the base64 content
    append_pattern = r"content\.append\('([^']+)'\);"
    appends = re.findall(append_pattern, full_func)
    
    # Combine all the base64 chunks
    base64_data = ''.join(appends)
    
    # Create the new function using ByteArray
    new_func = f'''fn get_{match[1]}_svg() -> ByteArray {{
    let mut svg: ByteArray = "";
    svg.append(@"data:image/png;base64,{base64_data}");
    svg
}}'''
    
    converted_functions.append((beast_name, new_func))

# Sort by beast name
converted_functions.sort(key=lambda x: x[0])

# Write to a new file
with open('/workspace/beasts/beast_svgs_converted.cairo', 'w') as f:
    f.write("// Auto-generated beast SVG functions\n\n")
    for _, func in converted_functions:
        f.write(func + "\n\n")

print(f"Converted {len(converted_functions)} SVG functions")