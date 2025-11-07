import sys
import os

# Add Doppler SDK path
sdk_path = r"C:\Users\hrsing\python-sdk\src"
if sdk_path not in sys.path:
    sys.path.append(sdk_path)

# Try importing DopplerSDK
try:
    from dopplersdk import DopplerSDK
except ImportError as e:
    print(f"❌ Failed to import dopplersdk: {e}")
    sys.exit(1)

# Patch for missing http_exceptions
try:
    from http_exceptions import HTTPException, client_exceptions, server_exceptions
except ImportError:
    class HTTPException(Exception):
        @staticmethod
        def from_status_code(status_code):
            return HTTPException(f"HTTP error with status code {status_code}")
    client_exceptions = {}
    server_exceptions = {}

# Fetch and set secrets
try:
    doppler = DopplerSDK()
    doppler.set_access_token("dp.st.dev.RkILOm6YJzr1FQv6w8ZvjCGIH3XhnmOoaSCQnjpgfdT")

    project = "jira-automation"
    config = "dev"

    response = doppler.secrets.list(config=config, project=project)
    secrets = response.secrets

    print("✅ Setting environment variables from Doppler secrets:")
    for key, value in secrets.items():
        os.environ[key] = value.get("raw", "")
        print(f"  - {key} = {os.environ[key]}")

    # Manually set ISSUES_FILE path
    issues_file_path = r"C:/Users/hrsing/PycharmProjects/PythonProject/JiraAPI/data/issues.json"
    os.environ["ISSUES_FILE"] = issues_file_path
    print(f"✅ ISSUES_FILE manually set to: {issues_file_path}")

    # Explicitly check expected keys
    expected_keys = [
        "API_TOKEN", "PROJECT_KEY", "BASE_URL", "EMAIL",
        "DOPPLER_CONFIG", "DOPPLER_ENVIRONMENT", "DOPPLER_PROJECT", "ISSUES_FILE"
    ]
    print("\n🔍 Debugging expected environment variables:")
    for key in expected_keys:
        val = os.environ.get(key)
        if val:
            print(f"✅ {key} = {val}")
        else:
            print(f"⚠️ {key} is NOT SET")

except Exception as e:
    print(f"❌ Error loading secrets from Doppler: {e}")