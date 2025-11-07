*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RESTLibrary

Resource          ../../resources/variables.robot

Library           Process
*** Variables ***
@{ISSUE_IDS}

*** Test Cases ***
Create Issues
    ${file}=    Get File    ${ISSUES_FILE}
    ${issues}=  Evaluate    json.loads('''${file}''')    modules=json

    ${index}=    Set Variable    0
    FOR    ${issue}    IN    @{issues}
        ${project}=    Create Dictionary    key=${PROJECT_KEY}
        ${issuetype}=  Create Dictionary    name=${issue['type']}
        ${fields}=     Create Dictionary    project=${project}    summary=${issue['summary']}    issuetype=${issuetype}
        ${payload}=    Create Dictionary    fields=${fields}
        ${request_id}=    Set Variable    create_issue_${index}
        ${requestInfo}=    Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue
        ...    method=POST
        ...    authType=Basic
        ...    username=${EMAIL}
        ...    password=${API_TOKEN}
        ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
        ...    requestBody=${payload}
        ...    expectedStatusCode=201
        ${issue_id}=    Execute RC    <<<rc, ${request_id}, body, $.id>>>
        Log    Created Issue ID: ${issue_id}
        Append To List    ${ISSUE_IDS}    ${issue_id}
        ${index}=    Evaluate    ${index} + 1
    END

Get Issues
    FOR    ${issue_id}    IN    @{ISSUE_IDS}
        ${request_id}=    Set Variable    get_issue_${issue_id}
        ${requestInfo}=    Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}
        ...    method=GET
        ...    authType=Basic
        ...    username=${EMAIL}
        ...    password=${API_TOKEN}
        ...    requestHeaders={"Accept": "application/json"}
        ...    expectedStatusCode=200
        ${summary}=    Execute RC    <<<rc, ${request_id}, body, $.fields.summary>>>
        Log    Issue Summary: ${summary}
    END

