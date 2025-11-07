import sys
import os

# Dynamically resolve and insert the project root path
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(current_dir, "../../.."))
sys.path.insert(0, project_root)

from automation_framework.keywords.playwright_helpers_modified import JiraUI

def validate_status(issue_key, expected_status):
    jira = JiraUI()
    jira.start_browser(auth_file="automation_framework/resources/auth.json", headless=True)
    jira.goto_home()
    jira.page.goto(f"{jira.base_url}/browse/{issue_key}")
    jira.page.wait_for_timeout(1000)

    status_selector = "div[data-testid='issue.views.issue-base.foundation.status.status-field']"
    try:
        jira.page.wait_for_selector(status_selector, timeout=10000)
        actual_status = jira.page.locator(status_selector).inner_text().strip()
        print(f"[VALIDATION] Expected: {expected_status}, Found: {actual_status}")
        assert actual_status.lower() == expected_status.lower(), f"Status mismatch: expected {expected_status}, got {actual_status}"
    except Exception as e:
        print(f"[ERROR] {e}")
        jira.capture_debug(f"{issue_key}_status_validation_error")
        raise
    finally:
        jira.stop_browser()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python validate_ui_status.py <ISSUE_KEY> <EXPECTED_STATUS>")
        sys.exit(1)

    issue_key = sys.argv[1]
    expected_status = sys.argv[2]
    try:
        validate_status(issue_key, expected_status)
    except Exception as e:
        print(f"[ERROR] {e}")
