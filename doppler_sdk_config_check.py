import sys

# Diagnostic: Print the Python executable being used
print("🔍 Python Executable:", sys.executable)

try:
    from dopplersdk import DopplerSDK
    print("✅ Doppler SDK module 'dopplersdk' imported successfully.")
except ImportError as e:
    print("❌ ImportError:", e)
    print("Please install the SDK using: pip install git+https://github.com/DopplerHQ/python-sdk.git")
    sys.exit(1)
except Exception as e:
    print("❌ General Exception during import:", e)
    sys.exit(1)

def fetch_doppler_secrets(access_token, project, config):
    try:
        doppler = DopplerSDK()
        doppler.set_access_token(access_token)

        # Fetch secrets using required arguments
        response = doppler.secrets.list(project=project, config=config)

        print("✅ Doppler SDK Configuration Successful")
        for key in response.secrets:
            print(f"{key}: {response.secrets[key]}")

    except Exception as e:
        print("❌ Error while fetching secrets from Doppler SDK:", str(e))

if __name__ == "__main__":
    # Replace with your actual Doppler access token, project, and config
    doppler_access_token = "dp.st.dev.RkILOm6YJzr1FQv6w8ZvjCGIH3XhnmOoaSCQnjpgfdT"
    doppler_project = "jira-automation"
    doppler_config = "dev"

    fetch_doppler_secrets(doppler_access_token, doppler_project, doppler_config)