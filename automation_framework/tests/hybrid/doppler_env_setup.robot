*** Settings ***
Library           OperatingSystem
Library           Process
Library           Collections
Library           BuiltIn
Library           String

Suite Setup       Initialize Doppler Environment

*** Variables ***
${EMAIL}          hritwick.singh05@gmail.com
${ISSUES_FILE}    C:/Users/hrsing/PycharmProjects/PythonProject/JiraAPI/data/issues.json

*** Keywords ***
Initialize Doppler Environment
    Install Doppler CLI If Not Present
    Setup Doppler Environment

Install Doppler CLI If Not Present
    [Documentation]    Check if Doppler CLI is installed, and install it if not present
    ${result}=    Run Keyword And Ignore Error    Run Process    doppler --version    shell=True
    Run Keyword If    '${result}[0]' != 'PASS'    Install Doppler CLI

Install Doppler CLI
    [Documentation]    Install Doppler CLI using PowerShell command
    Run Process    powershell -Command "iwr -useb https://cli.doppler.com/install.ps1 | iex"    shell=True

Setup Doppler Environment
    [Documentation]    Fetch secrets from Doppler and set them as environment variables
    ${env_result}=    Run Process    doppler run --command "powershell -Command Get-ChildItem Env:"    shell=True
    ${lines}=    Split To Lines    ${env_result.stdout}
    ${filtered}=    Get Slice From List    ${lines}    start=2
    FOR    ${line}    IN    @{filtered}
        ${parts}=    Split String    ${line}    ${SPACE}
        ${key}=      Set Variable    ${parts[0]}
        ${value}=    Evaluate    ' '.join(${parts}[1:])
        Run Keyword If    '${key}' != '' and '${key}'[0].isalpha()    Set Environment Variable    ${key}    ${value}
    END

*** Test Cases ***
Fetch Runtime Variables
    [Documentation]    Load environment variables into Robot variables
    ${API_TOKEN}=      Get Environment Variable    API_TOKEN
    ${PROJECT_KEY}=    Get Environment Variable    PROJECT_KEY
    ${BASE_URL}=       Get Environment Variable    BASE_URL
    Log Many    ${API_TOKEN}    ${PROJECT_KEY}    ${BASE_URL}