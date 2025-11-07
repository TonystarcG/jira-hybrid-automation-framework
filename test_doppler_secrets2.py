import sys
sys.path.append(r"C:\Users\hrsing\python-sdk\src")

try:
    from dopplersdk import DopplerSDK
except ImportError as e:
    print(f"❌ Failed to import dopplersdk: {e}")
    sys.exit(1)

try:
    # Initialize Doppler SDK
    doppler = DopplerSDK()
    doppler.set_access_token("dp.st.dev.RkILOm6YJzr1FQv6w8ZvjCGIH3XhnmOoaSCQnjpgfdT")

    project = "jira-automation"  # Replace with your actual project name
    config = "dev"               # Replace with your actual config name

    response = doppler.secrets.list(config=config, project=project)
    secrets = response.secrets

    print("✅ Secrets fetched successfully:")
    for key, value in secrets.items():
        print(f"{key}: {value['raw']}")  # ✅ Accessing raw value correctly

except Exception as e:
    print(f"❌ Error during Doppler SDK usage: {e}")