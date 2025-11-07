*** Settings ***
Library           Browser
Resource          ../../resources/variables.robot

Suite Setup       Open Browser To Jira
Suite Teardown    Close Browser

*** Variables ***
${JIRA_URL}       https://jira.example.com
${USERNAME}       user@example.com
${PASSWORD}       password123

*** Test Cases ***
Missing Summary Field Should Show Error
    [Documentation]    Try to create an issue without a summary
    Login To Jira UI
    Click    id=create-issue
    Type Text    id=project-field    DEMO
    Select Option By Value    id=issuetype-field    Task
    Click    id=create-button
    Wait For Elements State    css=.error-summary    visible
    Element Text Should Be    css=.error-summary    Summary is required

Invalid Issue Type Should Show Error
    [Documentation]    Try to select an invalid issue type
    Click    id=create-issue
    Type Text    id=project-field    DEMO
    Type Text    id=summary-field    Invalid type test
    Type Text    id=issuetype-field    InvalidType
    Click    id=create-button
    Wait For Elements State    css=.error-issuetype    visible
    Element Text Should Be    css=.error-issuetype    Issue type is invalid

Empty Project Field Should Show Error
    [Documentation]    Try to create an issue without selecting a project
    Click    id=create-issue
    Type Text    id=summary-field    No project test
    Select Option By Value    id=issuetype-field    Task
    Click    id=create-button
    Wait For Elements State    css=.error-project    visible
    Element Text Should Be    css=.error-project    Project is required

*** Keywords ***
Open Browser To Jira
    New Browser    chromium
    New Page    ${JIRA_URL}

Login To Jira UI
    Type Text    id=username    ${USERNAME}
    Type Text    id=password    ${PASSWORD}
    Click    id=login
    Wait For Elements State    id=dashboard    visible
