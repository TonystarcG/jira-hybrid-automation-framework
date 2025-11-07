*** Settings ***
Documentation     API Creates Issue and UI Reads It
Library           RequestsLibrary
Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           Process
Resource          ../../resources/variables.robot

*** Variables ***
${SUMMARY}        API to UI Test
${ISSUE_TYPE}     Task

*** Test Cases ***
Create Issue via API and Read via UI
    ${auth}=    Create Authorization Header    ${EMAIL}    ${API_TOKEN}
    ${headers}=    Create Dictionary    Authorization=${auth}    Content-Type=application/json
    Create Session    jira    ${BASE_URL}    headers=${headers}
    ${response}=    Create Issue via API    ${PROJECT_KEY}    ${SUMMARY}    ${ISSUE_TYPE}
    Should Be Equal As Integers    ${response.status_code}    201
    ${issue_key}=    Get Value From Json    ${response.content}    key
    Log    Created Issue Key: ${issue_key}
    Run Process    python    ui_read.py    ${issue_key}    shell=True    stdout=PIPE

*** Keywords ***
Create Authorization Header
    [Arguments]    ${EMAIL}    ${API_TOKEN}
    ${auth}=    Set Variable    Basic ${API_TOKEN}
    RETURN    ${auth}

Create Issue via API
    [Arguments]    ${PROJECT_KEY}    ${SUMMARY}    ${ISSUE_TYPE}
    ${project_dict}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype_dict}=    Create Dictionary    name=${ISSUE_TYPE}
    ${fields}=    Create Dictionary    project=${project_dict}    summary=${SUMMARY}    issuetype=${issuetype_dict}
    ${data}=    Create Dictionary    fields=${fields}
    ${response}=    Post Request    jira    ${BASE_URL}/rest/api/2/issue    json=${data}
    RETURN    ${response}
