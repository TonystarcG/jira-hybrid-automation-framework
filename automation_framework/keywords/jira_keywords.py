from robot.api.deco import keyword
import requests

class JiraKeywords:

    def __init__(self):
        self.base_url = "https://jira.example.com/rest/api/2/issue"

    @keyword("Create Jira Issue")
    def create_issue(self, username, password, project_key, summary, issue_type):
        url = self.base_url
        auth = (username, password)
        payload = {
            "fields": {
                "project": {"key": project_key},
                "summary": summary,
                "issuetype": {"name": issue_type}
            }
        }
        response = requests.post(url, json=payload, auth=auth)
        response.raise_for_status()
        return response.json()["key"]

    @keyword("Read Jira Issue")
    def read_issue(self, username, password, issue_key):
        url = f"{self.base_url}/{issue_key}"
        auth = (username, password)
        response = requests.get(url, auth=auth)
        response.raise_for_status()
        return response.json()

    @keyword("Update Jira Issue Summary")
    def update_issue_summary(self, username, password, issue_key, new_summary):
        url = f"{self.base_url}/{issue_key}"
        auth = (username, password)
        payload = {
            "fields": {
                "summary": new_summary
            }
        }
        response = requests.put(url, json=payload, auth=auth)
        response.raise_for_status()
        return response.status_code

    @keyword("Delete Jira Issue")
    def delete_issue(self, username, password, issue_key):
        url = f"{self.base_url}/{issue_key}"
        auth = (username, password)
        response = requests.delete(url, auth=auth)
        response.raise_for_status()
        return response.status_code
