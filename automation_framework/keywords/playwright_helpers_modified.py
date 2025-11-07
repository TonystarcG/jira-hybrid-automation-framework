import json
import re
from playwright.sync_api import sync_playwright

class JiraUI:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, config_path="automation_framework/resources/ui_config.json"):
        with open(config_path, "r") as f:
            self.config = json.load(f)
        self.base_url = self.config["base_url"]
        self.selectors = self.config["selectors"]

    def start_browser(self, auth_file="automation_framework/resources/auth.json", headless=False):
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(headless=headless)
        self.context = self.browser.new_context(storage_state=auth_file)
        self.page = self.context.new_page()
        return self.page

    def goto_home(self):
        print(f"[DEBUG] Navigating to: {self.base_url}")
        try:
            self.page.goto(self.base_url, timeout=60000)  # 60 seconds timeout
        except Exception as e:
            print(f"[ERROR] Navigation failed: {e}")
            self.browser.close()
            raise

    def save_snapshot(self, filename):
        with open(filename, "w", encoding="utf-8") as f:
            f.write(self.page.content())

    def capture_debug(self, label):
        self.save_snapshot(f"{label}.html")
        self.page.screenshot(path=f"{label}.png")
        print(f"[DEBUG] Captured snapshot and screenshot: {label}")

    def create_issue_ui(self, summary, work_type="Task"):
        self.page.click(self.selectors["create_button"])
        self.page.wait_for_timeout(1500)

        if work_type == "Task":
            dropdown = self.page.locator(self.selectors["work_type_dropdown"])
            dropdown.wait_for(state="visible", timeout=10000)
            dropdown.click(force=True)
            self.page.wait_for_timeout(1000)
            task_option = self.page.locator(self.selectors["work_type_option_task"]).first
            task_option.wait_for(state="visible", timeout=10000)
            task_option.click(force=True)

        self.page.wait_for_timeout(1500)
        self.page.fill(self.selectors["summary_input"], summary)
        self.page.wait_for_timeout(1000)
        self.capture_debug("create_snapshot")
        self.page.click(self.selectors["create_submit"])
        self.page.wait_for_timeout(1000)

        issue_key = None
        try:
            self.page.wait_for_selector("text=You've created", timeout=10000)
            confirmation_text = self.page.inner_text("text=You've created")
            match = re.search(r"(DPS-\d+)", confirmation_text)
            if match:
                issue_key = match.group(1)
            else:
                issue_link = self.page.locator("text=View").get_attribute("href")
                issue_key = issue_link.split("/")[-1]
        except Exception:
            self.capture_debug("create_failure")
            raise
        finally:
            self.capture_debug("create_post_submit_snapshot")

        return issue_key

    def search_issue(self, issue_id):
        self.page.goto(f"{self.base_url}/browse/{issue_id}")
        self.page.wait_for_timeout(1000)
        self.page.wait_for_selector(self.selectors["issue_summary"])
        self.page.wait_for_timeout(1000)
        self.capture_debug("read_snapshot")
        return self.page.inner_text(self.selectors["issue_summary"])

    def stop_browser(self):
        self.context.close()
        self.browser.close()
        self.playwright.stop()

    def validate_issue_with_attachment(self, issue_key):
        self.page.goto(f"{self.base_url}/browse/{issue_key}")
        self.page.wait_for_timeout(1000)

        # Validate summary
        summary_selector = self.selectors.get("issue_summary", "")
        if summary_selector:
            summary_text = self.page.locator(summary_selector).inner_text()
            print(f"[VALIDATION] Issue Summary: {summary_text}")
        else:
            print("[ERROR] Summary selector not found in ui_config.json")

        # Validate attachment
        try:
            attachment_selector = "div[data-test-id='issue.views.field.attachments']"
            self.page.wait_for_selector(attachment_selector, timeout=5000)
            print("[VALIDATION] Attachment is present.")
        except:
            print("[VALIDATION] Attachment not found.")

        self.page.screenshot(path=f"{issue_key}_validation.png")
        print(f"[DEBUG] Screenshot saved for {issue_key}")
