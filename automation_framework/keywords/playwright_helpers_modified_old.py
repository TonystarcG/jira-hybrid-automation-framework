from robot.api.deco import keyword
from Browser import Browser

class PlaywrightHelpers:

    def __init__(self):
        self.browser = Browser()
        self.page = None

    @keyword("Open Jira Page")
    def open_jira_page(self, url):
        self.browser.new_browser("chromium")
        self.page = self.browser.new_page(url)

    @keyword("Login To Jira")
    def login_to_jira(self, username, password):
        self.page.fill("id=username", username)
        self.page.fill("id=password", password)
        self.page.click("id=login")
        self.page.wait_for_elements_state("id=dashboard", "visible")

    @keyword("Create Issue Via UI")
    def create_issue_ui(self, project, summary, issue_type):
        self.page.click("button[data-testid='atlassian-navigation--create-button']")
        self.page.fill("input[name='summary']", summary)
        self.page.fill("input[id^='type-picker']", issue_type)
        self.page.click("div[data-testid='issue-field-select-base.ui.format-option-label.c-label']:has-text('Task')")
        self.page.click("button[type='submit']")
        self.page.wait_for_elements_state("a[data-testid='issue-created-key']", "visible")

    @keyword("Get Created Issue Key")
    def get_created_issue_key(self):
        return self.page.get_text("a[data-testid='issue-created-key']")

    @keyword("Search Issue In UI")
    def search_issue_ui(self, issue_key):
        self.page.fill("input[id='search-box']", issue_key)
        self.page.click("button[id='search-button']")
        self.page.wait_for_elements_state("css=.issue-details", "visible")

    @keyword("Verify Issue Details In UI")
    def verify_issue_details_ui(self, issue_key, expected_summary, expected_type):
        assert self.page.get_text("css=.issue-key") == issue_key
        assert self.page.get_text("h1[data-testid='issue.views.issue-base.foundation.summary.heading']") == expected_summary
        assert self.page.get_text("css=.issue-type") == expected_type
