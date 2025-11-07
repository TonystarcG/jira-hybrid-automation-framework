import sys
import os
import json
from automation_framework.keywords.helpers_old_9October import Create_Issue, get_auth_header
from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI

# Add project root to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

def run_negative_api_ui_flow():
    print("Starting Negative API -> UI Flow")

    config_path = os.path.join(os.path.dirname(__file__), '../../resources/variables.py')
    config_path = os.path.abspath(config_path)

    with open(config_path, "r") as f:
        config = json.load(f)

    # # Load API config
    # config_path = "automation_framework/resources/api_config.json"
    # with open(config_path, "r") as f:
    #     config = json.load(f)

    base_url = config["base_url"]
    email = config["email"]
    api_token = config["api_token"]
    project_key = config["project_key"]
    issue_type = config["issue_type"]

    auth = get_auth_header(email, api_token)

    # Try to create issue with missing summary
    status_code, response = Create_Issue(
        base_url=base_url,
        auth=auth,
        project_key=project_key,
        summary="",  # Intentionally empty
        issue_type=issue_type
    )

    if status_code != 201:
        print(f"✅ API issue creation failed as expected. Status code: {status_code}")
        return

    issue_key = response.get("key")
    if not issue_key:
        print("✅ No issue key returned. API creation failed as expected.")
        return

    print(f"❌ Issue created unexpectedly: {issue_key}")

    # Try to read via UI
    jira_ui = JiraUI()
    jira_ui.start_browser()
    jira_ui.goto_home()

    try:
        summary_text = jira_ui.search_issue(issue_key)
        print(f"UI read result: {summary_text}")
    except Exception as e:
        print(f"✅ UI failed to read issue as expected: {e}")
    finally:
        jira_ui.stop_browser()

if __name__ == "__main__":
    run_negative_api_ui_flow()