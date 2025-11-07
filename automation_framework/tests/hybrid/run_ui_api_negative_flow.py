import sys
import os
import sys
sys.stdout.reconfigure(encoding='utf-8')
# Add project root to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI
from automation_framework.keywords.helpers_old_9October import read_issue_api

def run_negative_ui_api_flow():
    print("Starting Negative UI → API Flow")

    # Initialize JiraUI and start browser
    jira_ui = JiraUI()
    jira_ui.start_browser()
    jira_ui.goto_home()

    try:
        # Try to create issue with missing summary
        issue_key = jira_ui.create_issue_ui(summary="", work_type="Task")

        if not issue_key:
            print("✅ UI issue creation failed as expected.")
        else:
            print(f"❌ Issue created unexpectedly: {issue_key}")
            # Try to read via API
            issue_data = read_issue_api(issue_key)
            print(f"API read result: {issue_data}")
    except Exception as e:
        print(f"✅ Exception occurred during issue creation as expected: {e}")
    finally:
        # Stop browser
        jira_ui.stop_browser()

if __name__ == "__main__":
    run_negative_ui_api_flow()