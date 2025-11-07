*** Settings ***
Library    RESTLibrary
Library    OperatingSystem
Resource   ../../resources/variables.robot

*** Test Cases ***
API Create → UI Read
    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=Task
    ${fields}=     Create Dictionary    project=${project}    summary=Hybrid Issue    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}
    Make HTTP Request    hybrid_create    ${BASE_URL}/rest/api/3/issue
    ...    method=POST
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
    ...    requestBody=${payload}
    ...    expectedStatusCode=201
    ${issue_id}=    Execute RC    <<<rc, hybrid_create, body, $.id>>>
    Set Environment Variable    ISSUE_ID    ${issue_id}
    Run Process    python    ../../playwright_flows/read_issue_ui.py