import sys
import os

# Add the project root (parent of automation_framework) to sys.path
project_root = os.path.abspath(os.path.dirname(__file__))
sys.path.insert(0, project_root)

# Try importing using full package path
try:
    from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import create_issue_ui
    from automation_framework.keywords.helpers_old_9October import read_issue_api
    print("✅ Imports successful.")
except Exception as e:
    print("❌ Import failed:", e)