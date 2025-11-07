*** Settings ***
Library           RequestsLibrary
Resource          ../../resources/variables.robot

*** Variables ***
${API_BASE_URL}       https://jira.example.com/rest/api/2/issue
${USERNAME}           user@example.com
${PASSWORD}           password123
${PROJECT_KEY}        DEMO
${ISSUE_TYPE}         Task
${SUMMARY}            API CRUD Test Issue
${UPDATED_SUMMARY}    Updated via API

*** Test Cases ***
Create Read Update Delete Jira Issue Via API
    [Documentation]    Perform full CRUD operations on a Jira issue using API
    Create Session    jira    ${API_BASE_URL}    auth=${USERNAME}:${PASSWORD}

    ${create_payload}=    Create Dictionary    fields=Create Dictionary    project=Create Dictionary    key=${PROJECT_KEY}    summary=${SUMMARY}    issuetype=Create Dictionary    name=${ISSUE_TYPE}
    ${create_response}=    Post Request    jira    url=${API_BASE_URL}    json=${create_payload}
    Should Be Equal As Integers    ${create_response.status_code}    201
    ${issue_key}=    Set Variable    ${create_response.json()['key']}

    ${read_response}=    Get Request    jira    url=${API_BASE_URL}/${issue_key}
    Should Be Equal As Integers    ${read_response.status_code}    200
    Should Be Equal As Strings    ${read_response.json()['fields']['summary']}    ${SUMMARY}

    ${update_payload}=    Create Dictionary    fields=Create Dictionary    summary=${UPDATED_SUMMARY}
    ${update_response}=    Put Request    jira    url=${API_BASE_URL}/${issue_key}    json=${update_payload}
    Should Be Equal As Integers    ${update_response.status_code}    204

    ${verify_update}=    Get Request    jira    url=${API_BASE_URL}/${issue_key}
    Should Be Equal As Strings    ${verify_update.json()['fields']['summary']}    ${UPDATED_SUMMARY}

    ${delete_response}=    Delete Request    jira    url=${API_BASE_URL}/${issue_key}
    Should Be Equal As Integers    ${delete_response.status_code}    204

    ${verify_delete}=    Get Request    jira    url=${API_BASE_URL}/${issue_key}
    Should Be Equal As Integers    ${verify_delete.status_code}    404
