*** Settings ***
Documentation     API Creates Issue and UI Reads It
Library           RequestsLibrary
Library           OperatingSystem
Resource          resources/variables.robot

*** Variables ***
${SUMMARY}        API to UI Test
${ISSUE_TYPE}     Task

*** Test Cases ***
Create Issue via API and Read via UI
    ${auth}=    Create Authorization Header    ${EMAIL}    ${API_TOKEN}
    ${response}=    Create Issue via API    ${BASE_URL}    ${auth}    ${PROJECT_KEY}    ${SUMMARY}    ${ISSUE_TYPE}
    Should Be Equal As Integers    ${response.status_code}    201
    ${issue_key}=    Get From Dictionary    ${response.json()}    key
    Log    Created Issue Key: ${issue_key}
    Run Process    python    ui_read.py    ${issue_key}

*** Keywords ***
Create Authorization Header
    [Arguments]    ${email}    ${token}
    ${auth}=    Set Variable    Basic ${token}
    [Return]    ${auth}

Create Issue via API
    [Arguments]    ${url}    ${auth}    ${project}    ${summary}    ${type}
    ${headers}=    Create Dictionary    Authorization=${auth}    Content-Type=application/json
    ${data}=    Create Dictionary    fields=${{"project": {{"key": "${project}"}}, "summary": "${summary}", "issuetype": {{"name": "${type}"}}}}
    ${response}=    Post Request    jira    ${url}/rest/api/2/issue    headers=${headers}    json=${data}
    [Return]    ${response}
