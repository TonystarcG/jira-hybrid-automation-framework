import os
import sys
# import sys
# import os
# sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

# Ensure helper modules are accessible
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from automation_framework.keywords.helpers_old_9October import Create_Issue, Get_Issue, get_auth_header
from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI

BASE_URL = "https://hritwick05sas.atlassian.net"
EMAIL = "hritwick.singh05@gmail.com"
API_TOKEN = "ATATT3xFfGF0joIl_FTTJsL_qcPK5O50G4n2W3eLyEXO8dt_9hmMvWTjeCQMTe0O8_nrg3kBUGMOrLj963_s7Ood_FJssrCL0RUDHSgYJyjormEWmWOuSc_8ycAzTPeM6Vvs9QF8SJrlxjRSAnEdMZnBRusF6deJZ5zJ1f6F1znxBjZZTzVaEIM=D1E3B8A3"
PROJECT_KEY = "DPS"

# def api_creates_ui_reads():
#     auth = get_auth_header(EMAIL, API_TOKEN)
#     status, resp = Create_Issue(BASE_URL, auth, PROJECT_KEY, "API to UI Test", "Task")
#     if status != 201:
#         raise Exception("API issue creation failed")
#     issue_key = resp.get("key")
#
#     jira = JiraUI()
#     jira.start_browser(auth_file="resources/auth.json", headless=False)
#     jira.goto_home()
#     summary = jira.search_issue(issue_key)
#     jira.stop_browser()
#
#     return issue_key, summary

def api_creates_ui_reads():
    print("[DEBUG] Starting API to UI flow")
    auth = get_auth_header(EMAIL, API_TOKEN)
    print("[DEBUG] Auth header created")

    status, resp = Create_Issue(BASE_URL, auth, PROJECT_KEY, "API to UI Test", "Task")
    print(f"[DEBUG] API response status: {status}")
    print(f"[DEBUG] API response body: {resp}")

    if status != 201:
        raise Exception("API issue creation failed")

    issue_key = resp.get("key")
    print(f"[DEBUG] Created issue key: {issue_key}")

    jira = JiraUI()
    jira.start_browser(auth_file="automation_framework/resources/auth.json", headless=False)
    print("[DEBUG] Browser started")

    jira.goto_home()
    summary = jira.search_issue(issue_key)
    print(f"[DEBUG] UI read summary: {summary}")

    jira.stop_browser()
    print("[DEBUG] Browser stopped")

    return issue_key, summary

# def ui_creates_api_reads():
#     jira = JiraUI()
#     jira.start_browser(auth_file="automation_framework/resources/auth.json", headless=False)
#     jira.goto_home()
#     issue_key = jira.create_issue_ui("UI to API Test", work_type="Task")
#     jira.stop_browser()
#
#     auth = get_auth_header(EMAIL, API_TOKEN)
#     status, resp = Get_Issue(BASE_URL, auth, issue_key)
#     if status != 200:
#         raise Exception("API read failed")
#     summary = resp["fields"]["summary"]
#
#     return issue_key, summary

# def ui_creates_api_reads():
#     from automation_framework.keywords.playwright_helpers_modified import JiraUI
#     from automation_framework.keywords.helpers import get_issue_summary
#
#     print("[DEBUG] Starting UI to API flow")
#     jira = JiraUI()
#     jira.start_browser()
#     issue_key = jira.create_issue_via_ui()
#     print(f"[DEBUG] Created issue key via UI: {issue_key}")
#     jira.stop_browser()
#
#     summary = get_issue_summary(issue_key)
#     print(f"[DEBUG] API read summary: {summary}")
#     return issue_key, summary

def ui_creates_api_reads():
    from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI
    from automation_framework.keywords.helpers_old_9October import Get_Issue, get_auth_header
    from automation_framework.resources.variables import BASE_URL, EMAIL, API_TOKEN

    print("[DEBUG] Starting UI to API flow")
    jira = JiraUI()
    jira.start_browser(auth_file="automation_framework/resources/auth.json", headless=False)
    jira.goto_home()
    issue_key = jira.create_issue_ui("UI to API Test", work_type="Task")
    print(f"[DEBUG] Created issue key via UI: {issue_key}")
    jira.stop_browser()

    auth = get_auth_header(EMAIL, API_TOKEN)
    status, resp = Get_Issue(BASE_URL, auth, issue_key)
    if status != 200:
        raise Exception("API read failed")
    summary = resp["fields"]["summary"]
    print(f"[DEBUG] API read summary: {summary}")

    return issue_key, summary

# import requests
#
# def create_issue_invalid_project():
#     url = f"{BASE_URL}/rest/api/2/issue"
#     auth = get_auth_header(EMAIL, API_TOKEN)
#     payload = {
#         "fields": {
#             "project": {"key": "INVALID123"},
#             "summary": "Test with invalid project key",
#             "issuetype": {"name": "Bug"}
#         }
#     }
#     response = requests.post(url, headers=auth, json=payload)
#     return response.status_code, response.text
#
# def create_issue_unsupported_type():
#     url = f"{BASE_URL}/rest/api/2/issue"
#     auth = get_auth_header(EMAIL, API_TOKEN)
#     payload = {
#         "fields": {
#             "project": {"key": PROJECT_KEY},
#             "summary": "Test with unsupported issue type",
#             "issuetype": {"name": "UnsupportedType"}
#         }
#     }
#     response = requests.post(url, headers=auth, json=payload)
#     return response.status_code, response.text
#
# def create_issue_malformed_payload():
#     url = f"{BASE_URL}/rest/api/2/issue"
#     auth = get_auth_header(EMAIL, API_TOKEN)
#     payload = {
#         "fields": {
#             "project": "JustAStringInsteadOfObject"
#         }
#     }
#     response = requests.post(url, headers=auth, json=payload)
#     return response.status_code, response.text

import requests

def create_issue_invalid_project():
    url = f"{BASE_URL}/rest/api/2/issue"
    auth = get_auth_header(EMAIL, API_TOKEN)
    headers = {
        "Content-Type": "application/json"
    }
    payload = {
        "fields": {
            "project": {"key": "INVALID123"},
            "summary": "Test with invalid project key",
            "issuetype": {"name": "Bug"}
        }
    }
    response = requests.post(url, headers=headers, auth=auth, json=payload)
    return response.status_code, response.text

def create_issue_unsupported_type():
    url = f"{BASE_URL}/rest/api/2/issue"
    auth = get_auth_header(EMAIL, API_TOKEN)
    headers = {
        "Content-Type": "application/json"
    }
    payload = {
        "fields": {
            "project": {"key": PROJECT_KEY},
            "summary": "Test with unsupported issue type",
            "issuetype": {"name": "UnsupportedType"}
        }
    }
    response = requests.post(url, headers=headers, auth=auth, json=payload)
    return response.status_code, response.text

def create_issue_malformed_payload():
    url = f"{BASE_URL}/rest/api/2/issue"
    auth = get_auth_header(EMAIL, API_TOKEN)
    headers = {
        "Content-Type": "application/json"
    }
    payload = {
        "fields": {
            "project": "JustAStringInsteadOfObject"
        }
    }
    response = requests.post(url, headers=headers, auth=auth, json=payload)
    return response.status_code, response.text