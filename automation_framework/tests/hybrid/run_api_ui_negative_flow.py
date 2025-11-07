import sys
import os

# Add project root to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from automation_framework.resources.variables import BASE_URL, EMAIL, API_TOKEN, PROJECT_KEY, ISSUE_TYPE
from automation_framework.keywords.helpers_old_9October import Create_Issue, get_auth_header
from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI

def run_negative_api_ui_flow():
    print("Starting Negative API -> UI Flow")

    auth = get_auth_header(EMAIL, API_TOKEN)

    # Try to create issue with missing summary
    status_code, response = Create_Issue(
        base_url=BASE_URL,
        auth=auth,
        project_key=PROJECT_KEY,
        summary="",  # Intentionally empty
        issue_type=ISSUE_TYPE
    )

    if status_code != 201:
        print(f"API issue creation failed as expected. Status code: {status_code}")
        return

    issue_key = response.get("key")
    if not issue_key:
        print("No issue key returned. API creation failed as expected.")
        return

    print(f"Issue created unexpectedly: {issue_key}")

    # Try to read via UI
    jira_ui = JiraUI()
    jira_ui.start_browser()
    jira_ui.goto_home()

    try:
        summary_text = jira_ui.search_issue(issue_key)
        print(f"UI read result: {summary_text}")
    except Exception as e:
        print(f"UI failed to read issue as expected: {e}")
    finally:
        jira_ui.stop_browser()

if __name__ == "__main__":
    run_negative_api_ui_flow()