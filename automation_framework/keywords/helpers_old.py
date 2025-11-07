# helpers_old.py - API helper functions for Jira

import requests

def build_issue_payload(project_key, summary, issue_type):
    return {
        "fields": {
            "project": {"key": project_key},
            "summary": summary,
            "issuetype": {"name": issue_type}
        }
    }

def get_auth(username, password):
    return (username, password)

def parse_issue_key(response):
    return response.json().get("key")

def parse_issue_summary(response):
    return response.json().get("fields", {}).get("summary")

def parse_issue_type(response):
    return response.json().get("fields", {}).get("issuetype", {}).get("name")

def is_success(response):
    return response.status_code in [200, 201, 204]

def get_status_code(response):
    return response.status_code
