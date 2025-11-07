*** Settings ***
Library           Browser    headless=False
Resource          automation_framework/resources/variables.robot

Suite Setup       Open Browser To Jira
Suite Teardown    Close Browser

*** Variables ***
${JIRA_URL}       https://jira.example.com
${USERNAME}       user@example.com
${PASSWORD}       password123
${PROJECT_KEY}    DEMO
${ISSUE_TYPE}     Task
${SUMMARY}        Global UI Test Issue

*** Test Cases ***
Create And Verify Jira Issue Via UI
    [Documentation]    Open browser, login to Jira, create issue, and verify creation
    Login To Jira UI
    Create Jira Issue Via UI    ${PROJECT_KEY}    ${SUMMARY}    ${ISSUE_TYPE}
    ${issue_key}=    Get Created Issue Key From UI
    Search Issue In UI    ${issue_key}
    Verify Issue Details In UI    ${issue_key}    ${SUMMARY}    ${ISSUE_TYPE}

*** Keywords ***
Open Browser To Jira
    New Browser    chromium
    New Page    ${JIRA_URL}

Close Browser
    Close Browser

Login To Jira UI
    Fill Text    id=username    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login
    Wait For Elements State    id=dashboard    visible

Create Jira Issue Via UI
    [Arguments]    ${project}    ${summary}    ${type}
    Click    button[data-testid='atlassian-navigation--create-button']
    Fill Text    input[name='summary']    ${summary}
    Fill Text    input[id^='type-picker']    ${type}
    Click    div[data-testid='issue-field-select-base.ui.format-option-label.c-label']:has-text('Task')
    Click    button[type='submit']
    Wait For Elements State    a[data-testid='issue-created-key']    visible

Get Created Issue Key From UI
    ${issue_key}=    Get Text    a[data-testid='issue-created-key']
    [Return]    ${issue_key}

Search Issue In UI
    [Arguments]    ${issue_key}
    Fill Text    input[id='search-box']    ${issue_key}
    Click    button[id='search-button']
    Wait For Elements State    css=.issue-details    visible

Verify Issue Details In UI
    [Arguments]    ${issue_key}    ${expected_summary}    ${expected_type}
    Get Text    css=.issue-key    ==    ${issue_key}
    Get Text    h1[data-testid='issue.views.issue-base.foundation.summary.heading']    ==    ${expected_summary}
    Get Text    css=.issue-type    ==    ${expected_type}
