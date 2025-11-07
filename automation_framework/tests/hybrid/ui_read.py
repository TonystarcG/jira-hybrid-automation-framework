import sys
from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI

if __name__ == "__main__":
    issue_key = sys.argv[1]
    jira = JiraUI()
    jira.start_browser(auth_file="resources/auth.json", headless=False)
    jira.goto_home()
    summary = jira.search_issue(issue_key)
    print(f"UI Read Summary: {summary}")
    jira.stop_browser()
