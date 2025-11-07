# from doppler_sdk import Doppler
from dopplersdk import DopplerSDK

# Replace with your actual service token
doppler = Doppler(service_token="dp.st.dev.RkILOm6YJzr1FQv6w8ZvjCGIH3XhnmOoaSCQnjpgfdT")

secrets = doppler.secrets()

print("API_TOKEN:", secrets["API_TOKEN"])
print("EMAIL:", secrets["EMAIL"])
print("PROJECT_KEY:", secrets["PROJECT_KEY"])
print("BASE_URL:", secrets["BASE_URL"])