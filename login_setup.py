from playwright.sync_api import sync_playwright
import json

def main():
    with sync_playwright() as p:
        # Launch browser in headed mode so you can complete login
        browser = p.chromium.launch(headless=False)
        context = browser.new_context()

        page = context.new_page()

        # Navigate directly to your Jira cloud instance
        page.goto("https://hritwick05sas.atlassian.net/")

        print("⚠️ Please complete login manually in the opened browser (email + password or Google SSO)...")

        # Wait up to 90 seconds for you to finish login
        page.wait_for_timeout(90000)

        # Save session state once login is complete
        storage_state = context.storage_state(path="auth.json")
        print("✅ Login state saved in auth.json")

        # Print captured cookies for verification
        cookies = storage_state["cookies"]  # already a dict
        print("\n🍪 Captured cookies:")
        for c in cookies:
            print(f"{c['name']} = {c['value']} (domain: {c['domain']})")

        browser.close()


if __name__ == "__main__":
    main()
