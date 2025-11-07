import sys
import importlib.util
import os

# Print Python version and environment
print(f"Python executable: {sys.executable}")
print(f"Python version: {sys.version}")
print(f"sys.path:\n{sys.path}\n")

# Check if http_exceptions is installed and where it's located
spec = importlib.util.find_spec("http_exceptions")
if spec is None:
    print("❌ http_exceptions module NOT found.")
else:
    print(f"✅ http_exceptions module found at: {spec.origin}")

# Check if dopplersdk is importable
spec_sdk = importlib.util.find_spec("dopplersdk")
if spec_sdk is None:
    print("❌ dopplersdk module NOT found.")
else:
    print(f"✅ dopplersdk module found at: {spec_sdk.origin}")

# Optional: list installed packages
try:
    import pkg_resources
    installed = sorted(["%s==%s" % (i.key, i.version) for i in pkg_resources.working_set])
    print("\nInstalled packages:")
    for pkg in installed:
        print(pkg)
except Exception as e:
    print(f"Error listing packages: {e}")
