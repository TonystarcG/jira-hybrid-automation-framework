# hybrid_flows.py
import os
import sys

# Add parent directory to path to import helpers
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from automation_framework.keywords.helpers_old_9October import Create_Issue, Get_Issue, get_auth_header
from automation_framework.keywords.playwright_helpers_modified_old_30Sept2025 import JiraUI

BASE_URL = "https://hritwick05sas.atlassian.net"
EMAIL = "hritwick.singh05@gmail.com"
API_TOKEN = "ATATT3xFfGF0joIl_FTTJsL_qcPK5O50G4n2W3eLyEXO8dt_9hmMvWTjeCQMTe0O8_nrg3kBUGMOrLj963_s7Ood_FJssrCL0RUDHSgYJyjormEWmWOuSc_8ycAzTPeM6Vvs9QF8SJrlxjRSAnEdMZnBRusF6deJZ5zJ1f6F1znxBjZZTzVaEIM=D1E3B8A3"
PROJECT_KEY = "DPS"

def api_creates_ui_reads():
    auth = get_auth_header(EMAIL, API_TOKEN)
    status, resp = Create_Issue(BASE_URL, auth, PROJECT_KEY, "API to UI Test", "Task")
    if status != 201:
        raise Exception("API issue creation failed")
    issue_key = resp.get("key")

    jira = JiraUI()
    jira.start_browser(auth_file="resources/auth.json", headless=False)
    jira.goto_home()
    summary = jira.search_issue(issue_key)
    jira.stop_browser()

    return issue_key, summary

def ui_creates_api_reads():
    jira = JiraUI()
    jira.start_browser(auth_file="resources/auth.json", headless=False)
    jira.goto_home()
    issue_key = jira.create_issue_ui("UI to API Test", work_type="Task")
    jira.stop_browser()

    auth = get_auth_header(EMAIL, API_TOKEN)
    status, resp = Get_Issue(BASE_URL, auth, issue_key)
    if status != 200:
        raise Exception("API read failed")
    summary = resp["fields"]["summary"]

    return issue_key, summary