*** Settings ***
Library           Browser
Library           RequestsLibrary
Resource          ../../resources/variables.robot

Suite Setup       Open Browser To Jira
Suite Teardown    Close Browser

*** Variables ***
${JIRA_URL}       https://jira.example.com
${API_URL}        https://jira.example.com/rest/api/2/issue
${USERNAME}       user@example.com
${PASSWORD}       password123
${PROJECT_KEY}    DEMO
${ISSUE_TYPE}     Bug
${SUMMARY_API}    Cross-validation API→UI
${SUMMARY_UI}     Cross-validation UI→API

*** Test Cases ***
Create Via API And Validate Via UI
    [Documentation]    Create issue via API and validate it in UI
    Create Session    jira    ${API_URL}    auth=${USERNAME}:${PASSWORD}
    ${payload}=    Create Dictionary    fields=Create Dictionary    project=Create Dictionary    key=${PROJECT_KEY}    summary=${SUMMARY_API}    issuetype=Create Dictionary    name=${ISSUE_TYPE}
    ${response}=    Post Request    jira    url=${API_URL}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${issue_key}=    Set Variable    ${response.json()['key']}

    Login To Jira UI
    Search Issue In UI    ${issue_key}
    Verify Issue Details In UI    ${issue_key}    ${SUMMARY_API}    ${ISSUE_TYPE}

Create Via UI And Validate Via API
    [Documentation]    Create issue via UI and validate it in API
    Login To Jira UI
    Create Jira Issue Via UI    ${PROJECT_KEY}    ${SUMMARY_UI}    ${ISSUE_TYPE}
    ${issue_key}=    Get Created Issue Key From UI

    Create Session    jira    ${API_URL}    auth=${USERNAME}:${PASSWORD}
    ${response}=    Get Request    jira    url=${API_URL}/${issue_key}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()['fields']['summary']}    ${SUMMARY_UI}
    Should Be Equal As Strings    ${response.json()['fields']['issuetype']['name']}    ${ISSUE_TYPE}

*** Keywords ***
Open Browser To Jira
    New Browser    chromium
    New Page    ${JIRA_URL}

Login To Jira UI
    Type Text    id=username    ${USERNAME}
    Type Text    id=password    ${PASSWORD}
    Click    id=login
    Wait For Elements State    id=dashboard    visible

Create Jira Issue Via UI
    [Arguments]    ${project}    ${summary}    ${type}
    Click    id=create-issue
    Type Text    id=project-field    ${project}
    Type Text    id=summary-field    ${summary}
    Select Option By Value    id=issuetype-field    ${type}
    Click    id=create-button
    Wait For Elements State    css=.issue-created-key    visible

Get Created Issue Key From UI
    ${issue_key}=    Get Text    css=.issue-created-key
    [Return]    ${issue_key}

Search Issue In UI
    [Arguments]    ${issue_key}
    Type Text    id=search-box    ${issue_key}
    Click    id=search-button
    Wait For Elements State    css=.issue-details    visible

Verify Issue Details In UI
    [Arguments]    ${issue_key}    ${expected_summary}    ${expected_type}
    Element Text Should Be    css=.issue-key    ${issue_key}
    Element Text Should Be    css=.issue-summary    ${expected_summary}
    Element Text Should Be    css=.issue-type    ${expected_type}
