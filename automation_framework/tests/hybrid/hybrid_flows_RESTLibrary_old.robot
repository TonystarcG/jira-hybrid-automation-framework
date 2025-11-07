*** Settings ***
Library    RESTLibrary
Library    OperatingSystem
Resource   playwright_ui_keywords.robot
#Resource   ../../resources/variables_old2.robot
Resource   C:/Users/hrsing/PycharmProjects/PythonProject/Jira_Hybrid_AutomationFramework1/automation_framework/resources/variables.robot

#*** Variables ***
#${BASE_URL}       https://hritwick05sas.atlassian.net
#${API_TOKEN}      ATATT3xFfGF0joIl_FTTJsL_qcPK5O50G4n2W3eLyEXO8dt_...
#${PROJECT_KEY}    DPS
#${EMAIL}          hritwick.singh05@gmail.com

*** Test Cases ***
Hybrid Flow - API Creates and UI Reads
    [Documentation]    Creates issue via API and validates via UI
    Make HTTP Request    create issue    ${BASE_URL}/rest/api/2/issue
    ...    method=POST
    ...    requestHeaders={'Authorization': 'Basic ${API_TOKEN}', 'Content-Type': 'application/json'}
    ...    requestBody={"fields": {"project": {"key": "${PROJECT_KEY}"}, "summary": "API to UI Test", "issuetype": {"name": "Task"}}}
    ...    expectedStatusCode=201
    ${issue_key}=    Execute RC    <<<rc, create issue, body, $.key>>>
    Log    Created Issue Key: ${issue_key}

    # UI validation using Playwright
    Start Browser With Auth    auth.json
    Go To Jira Home
    ${summary}=    Search Issue In UI    ${issue_key}
    Log    UI Summary: ${summary}
    Stop Browser

    ${response}=    Make HTTP Request    create issue    ${BASE_URL}/rest/api/2/issue
    ...    method=POST
    ...    requestHeaders={'Authorization': 'Basic ${API_TOKEN}', 'Content-Type': 'application/json'}
    ...    requestBody={"fields": {"project": {"key": "${PROJECT_KEY}"}, "summary": "API to UI Test", "issuetype": {"name": "Task"}}}
    Log    ${response.responseStatusCode}
    Log    ${response.responseBody}
