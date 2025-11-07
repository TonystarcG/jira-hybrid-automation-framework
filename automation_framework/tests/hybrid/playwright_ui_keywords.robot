*** Settings ***
Library    OperatingSystem
Library    Collections
Library    BuiltIn
Library    Process
Library    ../../keywords/playwright_helpers_modified.py

*** Keywords ***
Start Browser With Auth
    [Arguments]    ${auth_file}=automation_framework/resources/auth.json    ${headless}=False
    ${ui}=    Evaluate    JiraUI()    modules=playwright_helpers_modified
    ${page}=    Call Method    ${ui}    start_browser    ${auth_file}    ${headless}
    Set Suite Variable    ${ui}
    Set Suite Variable    ${page}

Go To Jira Home
    Call Method    ${ui}    goto_home

Search Issue In UI
    [Arguments]    ${issue_id}
    ${summary}=    Call Method    ${ui}    search_issue    ${issue_id}
    RETURN    ${summary}

Create Issue In UI
    [Arguments]    ${summary}    ${work_type}=Task
    ${issue_key}=    Call Method    ${ui}    create_issue_ui    ${summary}    ${work_type}
    RETURN    ${issue_key}

Stop Browser
    Call Method    ${ui}    stop_browser