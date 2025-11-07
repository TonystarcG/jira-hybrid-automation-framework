import os
import requests

token = os.getenv("API_TOKEN")
project_key = os.getenv("PROJECT_KEY")

print("API_TOKEN:", token)
print("PROJECT_KEY:", project_key)

# Optional: Make a test call
headers = {"Authorization": f"Bearer {token}"}
response = requests.get(f"https://your-jira-instance/rest/api/2/project/{project_key}", headers=headers)
print("Jira Project Response:", response.status_code)