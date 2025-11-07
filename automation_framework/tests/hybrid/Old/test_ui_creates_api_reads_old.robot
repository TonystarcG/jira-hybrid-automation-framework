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
${UI_SUMMARY}     UI Created Issue for API Validation
${ISSUE_TYPE}     Task

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
Create Issue via UI with Specific Summary
    Call Method    ${JIRA}    goto_home
    ${issue_key}=    Call Method    ${JIRA}    create_issue_ui    ${UI_SUMMARY}    work_type=${ISSUE_TYPE}
    Log    Created Issue Key: ${issue_key}
    Set Test Variable    ${ISSUE_KEY}    ${issue_key}

Validate Issue via API
    ${status}    ${resp}=    helpers.Get_Issue    ${BASE_URL}    ${AUTH}    ${ISSUE_KEY}
    Should Be Equal As Integers    ${status}    200
    ${summary}=    Set Variable    ${resp['fields']['summary']}
    Should Be Equal    ${summary}    ${UI_SUMMARY}
    Log    API Validated Summary: ${summary}

