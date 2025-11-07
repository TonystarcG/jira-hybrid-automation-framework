*** Settings ***
Library    RESTLibrary
Library    OperatingSystem
Resource   playwright_ui_keywords.robot
Resource   ../../resources/variables.robot

*** Test Cases ***
Hybrid Flow - API Creates and UI Reads
    [Documentation]    Creates issue via API and validates via UI

    # API Create
    ${response}=    Make HTTP Request    create issue    ${BASE_URL}/rest/api/2/issue
    ...    method=POST
    ...    requestHeaders={'Authorization': 'Basic ${API_TOKEN}', 'Content-Type': 'application/json'}
    ...    requestBody={"fields": {"project": {"key": "${PROJECT_KEY}"}, "summary": "API to UI Test", "issuetype": {"name": "Task"}}}

    Log To Console    Status Code: ${response.responseStatusCode}
    Log To Console    Response Body: ${response.responseBody}
    Log    Status Code: ${response.responseStatusCode}
    Log    Response Body: ${response.responseBody}
    Should Be Equal As Integers    ${response.responseStatusCode}    201

    ${issue_key}=    Execute RC    <<<rc, create issue, body, $.key>>>
    Log    Created Issue Key: ${issue_key}

    # UI Read
    Start Browser With Auth    auth.json
    Go To Jira Home
    ${summary}=    Search Issue In UI    ${issue_key}
    Log    UI Summary: ${summary}
    Stop Browser