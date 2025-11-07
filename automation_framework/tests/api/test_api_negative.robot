*** Settings ***
Library           RequestsLibrary
Resource          ../../resources/variables.robot

*** Variables ***
${API_BASE_URL}       https://jira.example.com/rest/api/2/issue
${USERNAME}           user@example.com
${PASSWORD}           password123
${INVALID_USERNAME}   invalid_user
${INVALID_PASSWORD}   wrong_pass
${PROJECT_KEY}        DEMO
${ISSUE_TYPE}         Task

*** Test Cases ***
Missing Required Fields Should Fail
    [Documentation]    Attempt to create an issue with missing required fields
    Create Session    jira    ${API_BASE_URL}    auth=${USERNAME}:${PASSWORD}
    ${payload}=    Create Dictionary    fields=Create Dictionary    summary=Missing project and type
    ${response}=    Post Request    jira    url=${API_BASE_URL}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    400

Invalid Issue Type Should Fail
    [Documentation]    Attempt to create an issue with an invalid issue type
    Create Session    jira    ${API_BASE_URL}    auth=${USERNAME}:${PASSWORD}
    ${payload}=    Create Dictionary    fields=Create Dictionary    project=Create Dictionary    key=${PROJECT_KEY}    summary=Invalid issue type    issuetype=Create Dictionary    name=InvalidType
    ${response}=    Post Request    jira    url=${API_BASE_URL}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    400

Authentication Error With Wrong Credentials
    [Documentation]    Attempt to access API with invalid credentials
    Create Session    bad_auth    ${API_BASE_URL}    auth=${INVALID_USERNAME}:${INVALID_PASSWORD}
    ${response}=    Get Request    bad_auth    url=${API_BASE_URL}/NONEXISTENT
    Should Be Equal As Integers    ${response.status_code}    401
