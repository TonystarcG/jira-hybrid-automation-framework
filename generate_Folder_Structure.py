import os

def list_folder_structure(start_path, output_file="Robot_Playwright_Integration_folder_structure.txt"):
    with open(output_file, "w") as f:
        for root, dirs, files in os.walk(start_path):
            level = root.replace(start_path, '').count(os.sep)
            indent = ' ' * 4 * level
            f.write(f"{indent}{os.path.basename(root)}/\n")
            sub_indent = ' ' * 4 * (level + 1)
            for file in files:
                f.write(f"{sub_indent}{file}\n")

# Replace '.' with your framework's root folder path if needed
list_folder_structure(".")
