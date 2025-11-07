import os

base_path = "automation_framework"

folders = [
    "tests/api",
    "tests/ui",
    "tests/hybrid",
    "resources",
    "keywords",
    "results",
    "venv"
]

files = {
    "tests/api/test_api_crud.robot": "*** Settings ***\n*** Test Cases ***\n",
    "tests/api/test_api_negative_old.robot": "*** Settings ***\n*** Test Cases ***\n",
    "tests/ui/test_ui_create.robot": "*** Settings ***\n*** Test Cases ***\n",
    "tests/ui/test_ui_negative.robot": "*** Settings ***\n*** Test Cases ***\n",
    "tests/hybrid/test_api_creates_ui_reads_old.robot": "*** Settings ***\n*** Test Cases ***\n",
    "tests/hybrid/test_ui_creates_api_reads_old.robot": "*** Settings ***\n*** Test Cases ***\n",
    "tests/hybrid/test_cross_validation_old.robot": "*** Settings ***\n*** Test Cases ***\n",
    "resources/variables_old.robot": "*** Variables ***\n",
    "resources/auth.json": "{}",
    "resources/ui_config_old.json": "{}",
    "resources/issues.json": "[]",
    "keywords/helpers_old.py": "# API helper functions",
    "keywords/jira_keywords_old.py": "# Robot keywords for Jira",
    "keywords/playwright_helpers_modified_old.py": "# Playwright UI helpers"
}

# Create folders
for folder in folders:
    os.makedirs(os.path.join(base_path, folder), exist_ok=True)

# Create files
for path, content in files.items():
    full_path = os.path.join(base_path, path)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content)

print("✅ Unified folder structure created successfully.")
