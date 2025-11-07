import sys
import os
import importlib.util

def debug_environment():
    print("=== DEBUG: Python Environment ===")
    print("Current Working Directory:", os.getcwd())
    script_dir = os.path.dirname(os.path.realpath(sys.argv[0]))
    print("Script Directory:", script_dir)

    # Add project root to sys.path
    # project_root = os.path.abspath(os.path.join(script_dir, '..', '..'))
    project_root = os.path.abspath(os.path.join(script_dir, '..', '..', '..'))
    print("Project Root:", project_root)
    sys.path.append(project_root)

    print("Python sys.path:")
    for path in sys.path:
        print(" -", path)

    # Check if automation_framework is importable
    module_name = "automation_framework"
    spec = importlib.util.find_spec(module_name)
    if spec is None:
        print(f"[ERROR] Module '{module_name}' not found in sys.path.")
    else:
        print(f"[SUCCESS] Module '{module_name}' is importable.")

def main():
    debug_environment()

    # Try importing JiraUI with error capture
    try:
        from automation_framework.keywords.playwright_helpers_modified import JiraUI
        print("[SUCCESS] Imported JiraUI successfully.")
    except ModuleNotFoundError as e:
        print("[IMPORT ERROR] ModuleNotFoundError:", e)
        sys.exit(1)
    except Exception as e:
        print("[IMPORT ERROR] Unexpected error:", e)
        sys.exit(1)

    # Validate command-line argument
    if len(sys.argv) != 2:
        print("Usage: python validate_ui_attachment.py <ISSUE_KEY>")
        sys.exit(1)

    issue_key = sys.argv[1]

    # Run validation
    jira = JiraUI()
    jira.start_browser()
    jira.validate_issue_with_attachment(issue_key)
    jira.stop_browser()

if __name__ == "__main__":
    main()