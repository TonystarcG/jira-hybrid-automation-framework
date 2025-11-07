*** Settings ***
Library           RequestsLibrary
Library           Browser
Library           SeleniumLibrary
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
${SUMMARY}        Hybrid API→UI Test Issue

*** Test Cases ***
Create Issue Via API And Verify In UI
    [Documentation]    Create a Jira issue via API and verify its presence and details via UI
    Create Session    jira    ${API_URL}    auth=${USERNAME}:${PASSWORD}
    ${payload}=    Create Dictionary    fields=Create Dictionary    project=Create Dictionary    key=${PROJECT_KEY}    summary=${SUMMARY}    issuetype=Create Dictionary    name=${ISSUE_TYPE}
    ${response}=    Post Request    jira    url=${API_URL}    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    ${issue_key}=    Set Variable    ${response.json()['key']}

    Login To Jira UI
    Search Issue In UI    ${issue_key}
    Verify Issue Details In UI    ${issue_key}    ${SUMMARY}    ${ISSUE_TYPE}

#*** Keywords ***
#Open Browser To Jira
#    New Browser    chromium
#    New Page    ${JIRA_URL}
#
#Close Browser
#    Close Browser
#
#Login To Jira UI
#    Type Text    id=username    ${USERNAME}
#    Type Text    id=password    ${PASSWORD}
#    Click    id=login
#    Wait For Elements State    id=dashboard    visible
#
#Search Issue In UI
#    [Arguments]    ${issue_key}
#    Type Text    id=search-box    ${issue_key}
#    Click    id=search-button
#    Wait For Elements State    css=.issue-details    visible

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

Search Issue In UI
    [Arguments]    ${issue_key}
    Fill Text    id=search-box    ${issue_key}
    Click    id=search-button
    Wait For Elements State    css=.issue-details    visible

Verify Issue Details In UI
    [Arguments]    ${issue_key}    ${expected_summary}    ${expected_type}
    Get Text    css=.issue-key    ==    ${issue_key}
    Get Text    css=.issue-summary    ==    ${expected_summary}
    Get Text    css=.issue-type    ==    ${expected_type}


Verify Issue Details In UI
    [Arguments]    ${issue_key}    ${expected_summary}    ${expected_type}
    Element Text Should Be    css=.issue-key    ${issue_key}
    Element Text Should Be    css=.issue-summary    ${expected_summary}
    Element Text Should Be    css=.issue-type    ${expected_type}
