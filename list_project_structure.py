import os

# Define the output file name
output_file = "all_files_and_folders.txt"

# Get the current working directory
root_directory = os.getcwd()

# Collect all file and folder names
with open(output_file, "w") as f:
    for root, dirs, files in os.walk(root_directory):
        for name in dirs:
            f.write(f"[DIR] {os.path.join(root, name)}\n")
        for name in files:
            f.write(f"[FILE] {os.path.join(root, name)}\n")

print(f"All file and folder names saved to {output_file}")
