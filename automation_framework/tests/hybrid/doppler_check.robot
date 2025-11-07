*** Settings ***
Library    OperatingSystem

*** Test Cases ***
Check Environment Variables
    Log    API Token: %{API_TOKEN}
    Log    Project Key: %{PROJECT_KEY}
    Log    Base URL: %{BASE_URL}