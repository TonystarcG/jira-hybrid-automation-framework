import requests
from requests.auth import HTTPBasicAuth

# -----------------------
# AUTHENTICATION
# -----------------------
def get_auth_header(email, api_token):
    return HTTPBasicAuth(email, api_token)

# -----------------------
# ISSUE OPERATIONS
# -----------------------
def Create_Issue(base_url, auth, project_key, summary, issue_type):
    url = f"{base_url}/rest/api/3/issue"
    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    payload = {
        "fields": {
            "project": {"key": project_key},
            "summary": summary,
            "issuetype": {"name": issue_type}
        }
    }
    response = requests.post(url, headers=headers, auth=auth, json=payload)
    return response.status_code, (response.json() if response.text else {})

def Get_Issue(base_url, auth, issue_id):
    url = f"{base_url}/rest/api/3/issue/{issue_id}"
    headers = {"Accept": "application/json"}
    response = requests.get(url, headers=headers, auth=auth)
    return response.status_code, (response.json() if response.text else {})

def read_issue_api(base_url, auth, issue_id):
    url = f"{base_url}/rest/api/3/issue/{issue_id}"
    headers = {"Accept": "application/json"}
    response = requests.get(url, headers=headers, auth=auth)
    return response.status_code, (response.json() if response.text else {})