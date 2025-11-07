*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem

*** Variables ***
${EMAIL}          Evaluate    os.getenv("EMAIL")          os
${API_TOKEN}      Evaluate    os.getenv("API_TOKEN")      os
${BASE_URL}       Evaluate    os.getenv("BASE_URL")       os
${PROJECT_KEY}    Evaluate    os.getenv("PROJECT_KEY")    os
${SUMMARY}        Minimal Test Issue
${ISSUE_TYPE}     Task
${HEADERS}        {"Accept": "application/json"}

*** Test Cases ***
Create Simple Jira Issue
    [Documentation]    Validates API authentication and issue creation using manually injected secrets

    ${auth}=    Create List    ${EMAIL}    ${API_TOKEN}
    Create Session    jira    ${BASE_URL}    auth=${auth}

    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=${ISSUE_TYPE}
    ${fields}=     Create Dictionary    project=${project}    summary=${SUMMARY}    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}

    ${response}=   POST On Session    jira    /rest/api/3/issue    json=${payload}    headers=${HEADERS}
    Log    Status Code: ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    201

    ${body}=       Set Variable    ${response.json()}
    ${issue_key}=  Get From Dictionary    ${body}    key
    Log    Created Issue Key: ${issue_key}