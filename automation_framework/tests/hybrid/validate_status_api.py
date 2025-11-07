import os
import sys
import requests
from requests.auth import HTTPBasicAuth

def get_issue_status(base_url, email, api_token, issue_key):
    url = f"{base_url}/rest/api/3/issue/{issue_key}"
    headers = {"Accept": "application/json"}
    auth = HTTPBasicAuth(email, api_token)

    response = requests.get(url, headers=headers, auth=auth)
    if response.status_code != 200:
        raise Exception(f"Failed to fetch issue. Status code: {response.status_code}, Response: {response.text}")

    data = response.json()
    status = data.get("fields", {}).get("status", {}).get("name", "")
    return status

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python validate_status_api.py <ISSUE_KEY> <EXPECTED_STATUS>")
        sys.exit(1)

    issue_key = sys.argv[1]
    expected_status = sys.argv[2]

    base_url = os.getenv("BASE_URL")
    email = os.getenv("EMAIL")
    api_token = os.getenv("API_TOKEN")

    if not all([base_url, email, api_token]):
        print("Missing required environment variables: BASE_URL, EMAIL, API_TOKEN")
        sys.exit(1)

    try:
        actual_status = get_issue_status(base_url, email, api_token, issue_key)
        print(f"[VALIDATION] Expected: {expected_status}, Found: {actual_status}")
        if actual_status.lower() != expected_status.lower():
            raise Exception(f"Status mismatch: expected '{expected_status}', got '{actual_status}'")
    except Exception as e:
        print(f"[ERROR] {e}")
        sys.exit(1)