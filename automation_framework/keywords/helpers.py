import requests
from requests.auth import HTTPBasicAuth

def get_auth_header(email, api_token):
    return HTTPBasicAuth(email, api_token)

def get_transition_id(base_url, auth, issue_key, target_status):
    url = f"{base_url}/rest/api/3/issue/{issue_key}/transitions"
    headers = {"Accept": "application/json"}
    response = requests.get(url, headers=headers, auth=auth)
    response.raise_for_status()
    transitions = response.json().get("transitions", [])
    for t in transitions:
        if t["name"].lower() == target_status.lower():
            return t["id"]
    raise Exception(f"Transition to status '{target_status}' not found for issue {issue_key}")

def transition_issue(base_url, auth, issue_key, target_status):
    transition_id = get_transition_id(base_url, auth, issue_key, target_status)
    url = f"{base_url}/rest/api/3/issue/{issue_key}/transitions"
    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    payload = {"transition": {"id": transition_id}}
    response = requests.post(url, headers=headers, auth=auth, json=payload)
    response.raise_for_status()
    return response.status_code

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