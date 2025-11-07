*** Settings ***
Documentation     UI test to login to Jira and create an issue
Library           SeleniumLibrary
Resource          automation_framework/resources/variables.robot

*** Variables ***
${JIRA_URL}       https://hritwick05sas.atlassian.net/login
${BROWSER}        chrome
${USERNAME}       hritwick.singh05@gmail.com
${PASSWORD}       password123
${PROJECT_KEY}    DP
${ISSUE_TYPE}     Task
${SUMMARY}        Global UI Test Issue

*** Test Cases ***
Login and Create Issue with ${USERNAME}
    Open the Browser
    Login To Jira UI    ${USERNAME}    ${PASSWORD}
    Create Jira Issue Via UI    ${PROJECT_KEY}    ${SUMMARY}    ${ISSUE_TYPE}
    Close Browser

*** Keywords ***
Open the Browser
    Open Browser    ${JIRA_URL}    ${BROWSER}
    Maximize Browser Window

Login To Jira UI
    [Arguments]    ${username}    ${password}
    Input Text    id=username    ${username}
    Input Text    id=password    ${password}
    Click Button    id=login
    Wait Until Element Is Visible    id=dashboard

Create Jira Issue Via UI
    [Arguments]    ${project}    ${summary}    ${type}
    Click Element    css=button[data-testid='atlassian-navigation--create-button']
    Input Text       css=input[name='summary']    ${summary}
    Input Text       css=input[id^='type-picker']    ${type}
    Click Element    css=div[data-testid='issue-field-select-base.ui.format-option-label.c-label']:contains("Task")
    Click Button     css=button[type='submit']
    Wait Until Element Is Visible    css=a[data-testid='issue-created-key']
