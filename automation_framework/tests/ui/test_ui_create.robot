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
${ISSUE_SUMMARY}  Test issue created via UI
${ISSUE_TYPE}     Task

*** Test Cases ***
UI Create And API Validate Jira Issue
    [Documentation]    Create a Jira issue via UI and validate it via API
    Login To Jira UI
    Create Jira Issue Via UI    ${PROJECT_KEY}    ${ISSUE_SUMMARY}    ${ISSUE_TYPE}
    ${issue_key}=    Get Created Issue Key From UI
    Validate Issue Via API    ${issue_key}    ${ISSUE_SUMMARY}    ${ISSUE_TYPE}

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

Validate Issue Via API
    [Arguments]    ${issue_key}    ${expected_summary}    ${expected_type}
    Create Session    jira    ${API_URL}    auth=${USERNAME}:${PASSWORD}
    ${response}=    Get Request    jira    /${issue_key}
    Should Be Equal As Strings    ${response.json()['fields']['summary']}    ${expected_summary}
    Should Be Equal As Strings    ${response.json()['fields']['issuetype']['name']}    ${expected_type}
