import requests
from requests.auth import HTTPBasicAuth

# Replace these with your actual values or load from Doppler if needed
EMAIL = "hritwick.singh05@gmail.com"
API_TOKEN = "ATATT3xFfGF0K_e3awkZdixUIV8uAU5Sv4NHcjNsN6ZoTLmzVZP_pD_u_3L8GZl1SyKq_pajZOM-onkbClePSYzuTItPjOO7Qd-YBCmMz3t9aSmRPp5hRKq3Mm9hA27_jhzYRru9dya5-1Ion_sT74yx-gxL6LMxFSgPn59lpF4k3LzxrbP_w6E=CD11CE27"
BASE_URL = "https://hritwick05sas.atlassian.net"

# Make a simple GET request to verify authentication
response = requests.get(
    f"{BASE_URL}/rest/api/3/project",
    auth=HTTPBasicAuth(EMAIL, API_TOKEN)
)

print("Status Code:", response.status_code)
print("Response Text:", response.text)