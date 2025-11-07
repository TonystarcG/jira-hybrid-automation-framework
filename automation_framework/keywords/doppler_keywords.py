import os
from doppler_config_loader import load_doppler_secrets
from robot.libraries.BuiltIn import BuiltIn

class DopplerKeywords:
    def __init__(self):
        self.builtin = BuiltIn()

    def load_doppler_secrets(self, access_token=None, project=None, config=None):
        """
        Robot Framework keyword to load Doppler secrets and set them as variables.
        If access_token, project, or config are not provided, they are read from environment variables.
        """
        access_token = access_token or os.getenv("DOPPLER_TOKEN")
        project = project or os.getenv("DOPPLER_PROJECT", "jira-automation")
        config = config or os.getenv("DOPPLER_CONFIG", "dev")

        if not access_token:
            raise ValueError("Doppler access token must be provided or set in DOPPLER_TOKEN environment variable.")

        secrets = load_doppler_secrets(access_token, project, config)

        for key, value in secrets.items():
            self.builtin.set_global_variable(f"${{{key}}}", value)

        print("🔍 Loading Doppler secrets...")
        print(f"Using project={project}, config={config}")
