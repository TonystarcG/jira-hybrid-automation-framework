*** Settings ***
Documentation     UI Creates Issue and API Reads It
Library           RequestsLibrary
Library           OperatingSystem
Resource          ../../resources/variables.robot

*** Variables ***
${SUMMARY}        UI to API Test
${ISSUE_TYPE}     Task

*** Test Cases ***
Create Issue via UI and Read via API
    ${result}=    Run Process    python    ui_create.py    shell=True    stdout=PIPE
    ${output}=    Convert To String    ${result.stdout}
    ${issue_key}=    Fetch Issue Key From Output    ${output}
    ${auth}=    Create Authorization Header    ${EMAIL}    ${API_TOKEN}
    ${response}=    Get Issue via API    ${BASE_URL}    ${auth}    ${issue_key}
    Should Be Equal As Integers    ${response.status_code}    200
    ${summary}=    Get From Dictionary    ${response.json()}    fields.summary
    Log    API Read Summary: ${summary}

*** Keywords ***
Fetch Issue Key From Output
    [Arguments]    ${output}
    ${parts}=    Split String    ${output}    :
    ${issue_key}=    Strip String    ${parts[-1]}
    [Return]    ${issue_key}

Create Authorization Header
    [Arguments]    ${email}    ${token}
    ${auth}=    Set Variable    Basic ${token}
    [Return]    ${auth}

Get Issue via API
    [Arguments]    ${url}    ${auth}    ${issue_key}
    ${headers}=    Create Dictionary    Authorization=${auth}    Content-Type=application/json
    ${response}=    Get Request    jira    ${url}/rest/api/2/issue/${issue_key}    headers=${headers}
    [Return]    ${response}
