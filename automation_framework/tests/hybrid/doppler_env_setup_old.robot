*** Settings ***
Library           OperatingSystem
Library           Process
Library           Collections
Library           BuiltIn
Library           String

*** Variables ***
${EMAIL}          hritwick.singh05@gmail.com
${ISSUES_FILE}    C:/Users/hrsing/PycharmProjects/PythonProject/JiraAPI/data/issues.json

*** Test Cases ***
Install Doppler CLI If Not Present
    ${result}=    Run Keyword And Ignore Error    Run Process    doppler --version    shell=True
    Run Keyword If    '${result}[0]' != 'PASS'    Install Doppler CLI

Install Doppler CLI
    Run Process    powershell -Command "iwr -useb https://cli.doppler.com/install.ps1 | iex"    shell=True

Setup Doppler Environment
    [Documentation]    Fetch secrets from Doppler and set them as environment variables
    ${env_result}=    Run Process    doppler run --project DPS --config dev --command "env"    shell=True
    ${lines}=    Split To Lines    ${env_result.stdout}
    :FOR    ${line}    IN    @{lines}
    \    ${parts}=    Split String    ${line}    =
    \    Run Keyword If    len(${parts}) == 2    Set Environment Variable    ${parts[0]}    ${parts[1]}

Fetch Runtime Variables
    [Documentation]    Load environment variables into Robot variables
    ${API_TOKEN}=      Get Environment Variable    API_TOKEN
    ${PROJECT_KEY}=    Get Environment Variable    PROJECT_KEY
    ${BASE_URL}=       Get Environment Variable    BASE_URL
    Log Many    ${API_TOKEN}    ${PROJECT_KEY}    ${BASE_URL}