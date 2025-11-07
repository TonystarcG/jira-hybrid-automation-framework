*** Settings ***
Library           OperatingSystem
Library           Collections
Library           JSONLibrary
Library           ../../keywords/helpers.py
Library           ../../keywords/playwright_helpers_modified.py
Resource          ../../resources/variables.robot

Suite Setup       Setup Auth And Browser
Suite Teardown    Teardown Browser

*** Variables ***
${API_SUMMARY}    API Created Bug for UI Check
${UI_SUMMARY}     UI Created Task for API Check
${API_TYPE}       Bug
${UI_TYPE}        Task

*** Keywords ***
Setup Auth And Browser
    ${auth}=    helpers.Get Auth Header    ${EMAIL}    ${API_TOKEN}
    Set Suite Variable    ${AUTH}    ${auth}
    ${jira}=    Create Instance    JiraUI
    ${page}=    Call Method    ${jira}    start_browser    auth_file=resources/auth.json    headless=False
    Set Suite Variable    ${JIRA}    ${jira}
    Set Suite Variable    ${PAGE}    ${page}

Teardown Browser
    Call Method    ${JIRA}    stop_browser

*** Test Cases ***
Create Bug via API and Validate via UI
    ${status}    ${resp}=    helpers.Create_Issue    ${BASE_URL}    ${AUTH}    ${PROJECT_KEY}    ${API_SUMMARY}    ${API_TYPE}
    Should Be Equal As Integers    ${status}    201
    ${api_issue_key}=    Set Variable    ${resp['key']}
    Log    API Created Issue Key: ${api_issue_key}

    Call Method    ${JIRA}    goto_home
    ${summary}=    Call Method    ${JIRA}    search_issue    ${api_issue_key}
    Should Contain    ${summary}    ${API_SUMMARY}
    Log    UI Validated API Issue Summary: ${summary}

Create Task via UI and Validate via API
    ${ui_issue_key}=    Call Method    ${JIRA}    create_issue_ui    ${UI_SUMMARY}    work_type=${UI_TYPE}
    Log    UI Created Issue Key: ${ui_issue_key}

    ${status}    ${resp}=    helpers.Get_Issue    ${BASE_URL}    ${AUTH}    ${ui_issue_key}
    Should Be Equal As Integers    ${status}    200
    ${summary}=    Set Variable    ${resp['fields']['summary']}
    Should Be Equal    ${summary}    ${UI_SUMMARY}
    Log    API Validated UI Issue Summary: ${summary}

