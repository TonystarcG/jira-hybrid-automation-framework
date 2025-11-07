# doppler_config_loader.py
import sys
from dopplersdk import DopplerSDK

def load_doppler_secrets(access_token, project, config, required_keys=None):
    """
    Loads secrets from Doppler using the SDK and access token.
    Returns a dictionary of required secrets.
    """
    try:
        doppler = DopplerSDK()
        doppler.set_access_token(access_token)
        response = doppler.secrets.list(project=project, config=config)
        secrets = {}

        # ✅ Include ISSUES_FILE in default required_keys
        if required_keys is None:
            required_keys = ["API_TOKEN", "BASE_URL", "EMAIL", "PROJECT_KEY", "ISSUES_FILE"]

        for key in required_keys:
            if key in response.secrets:
                secrets[key] = response.secrets[key]["computed"]
            else:
                raise KeyError(f"Missing Doppler secret: {key}")

        return secrets

    except Exception as e:
        print("❌ Error while fetching secrets from Doppler SDK:", str(e))
        raise