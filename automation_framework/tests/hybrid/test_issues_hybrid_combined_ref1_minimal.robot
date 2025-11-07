*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RESTLibrary
Library           Process

Resource          ../../resources/variables.robot

*** Variables ***
@{ISSUE_IDS}

*** Test Cases ***
Create Issues
    ${file}=    Get File    ${ISSUES_FILE}
    ${data}=    Evaluate    json.loads('''${file}''')    modules=json
    ${issues}=  Set Variable    ${data['valid_issues']}

    ${index}=    Set Variable    0
    FOR    ${issue}    IN    @{issues}
        ${project}=    Create Dictionary    key=${PROJECT_KEY}
        ${issuetype}=  Create Dictionary    name=${issue['issue_type']}
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