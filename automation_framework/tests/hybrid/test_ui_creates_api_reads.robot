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
${ISSUE_TYPE}     Task
${SUMMARY}        Hybrid UI→API Test Issue

*** Test Cases ***
Create Issue Via UI And Verify In API
    [Documentation]    Create a Jira issue via UI and verify its details via API
    Login To Jira UI
    Create Jira Issue Via UI    ${PROJECT_KEY}    ${SUMMARY}    ${ISSUE_TYPE}
    ${issue_key}=    Get Created Issue Key From UI

    Create Session    jira    ${API_URL}    auth=${USERNAME}:${PASSWORD}
    ${response}=    Get Request    jira    url=${API_URL}/${issue_key}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()['fields']['summary']}    ${SUMMARY}
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
