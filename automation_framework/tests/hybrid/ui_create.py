from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI

if __name__ == "__main__":
    jira = JiraUI()
    jira.start_browser(auth_file="resources/auth.json", headless=False)
    jira.goto_home()
    issue_key = jira.create_issue_ui("UI to API Test", work_type="Task")
    print(f"Created Issue Key: {issue_key}")
    jira.stop_browser()
