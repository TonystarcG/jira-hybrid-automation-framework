import os
from dopplersdk import DopplerSDK

# Initialize Doppler SDK without setting access token
secrets = {}
try:
    doppler = DopplerSDK()

    # Fetch secrets using project and config from environment
    project = os.getenv("DOPPLER_PROJECT", "jira-automation")
    config = os.getenv("DOPPLER_CONFIG", "dev")
    response = doppler.secrets.list(project=project, config=config)

    required_keys = ["API_TOKEN", "BASE_URL", "EMAIL", "PROJECT_KEY"]
    for key in required_keys:
        if key in response.secrets:
            secrets[key] = response.secrets[key].computed
        else:
            raise KeyError(f"Missing Doppler secret: {key}")
except Exception as e:
    print(f"Error loading Doppler secrets: {e}")
    raise