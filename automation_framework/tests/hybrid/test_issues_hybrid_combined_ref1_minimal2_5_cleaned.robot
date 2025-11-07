*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RequestsLibrary
Library           Process
Library           automation_framework.keywords.doppler_keywords.DopplerKeywords
Resource          ../../resources/variables.robot

*** Variables ***
@{ISSUE_IDS}
${ATTACHMENT_PATH}    ../../resources/attachments/sample_attachment.txt

*** Test Cases ***
Create Issues And Upload Attachment
    Load Doppler Secrets
    Log    ISSUES_FILE: ${ISSUES_FILE}
    Log    BASE_URL: ${BASE_URL}
    Log    EMAIL: ${EMAIL}
    Log    API_TOKEN: ${API_TOKEN}

    ${auth}=    Create List    ${EMAIL}    ${API_TOKEN}
    Create Session    jira    ${BASE_URL}    auth=${auth}

    ${data}=    Load JSON From File    ${ISSUES_FILE}
    ${issues}=  Set Variable    ${data['valid_issues']}

    FOR    ${issue}    IN    @{issues}
        ${project}=    Create Dictionary    key=${PROJECT_KEY}
        ${issuetype}=  Create Dictionary    name=${issue['issue_type']}
        ${fields}=     Create Dictionary    project=${project}    summary=${issue['summary']}    issuetype=${issuetype}
        ${payload}=    Create Dictionary    fields=${fields}
        ${headers}=    Create Dictionary    Accept=application/json

        ${response}=   POST On Session    jira    /rest/api/3/issue    json=${payload}    headers=${headers}
        Should Be Equal As Strings    ${response.status_code}    201
        ${body}=       Set Variable    ${response.json()}
        ${issue_id}=   Get From Dictionary    ${body}    id
        ${issue_key}=  Get From Dictionary    ${body}    key
        Log    Created Issue ID: ${issue_id}
        Append To List    ${ISSUE_IDS}    ${issue_id}

        ${file_tuple}=    Create List    ${ATTACHMENT_PATH}    ${ATTACHMENT_PATH}    text/plain
        ${upload_headers}=    Create Dictionary    X-Atlassian-Token=no-check
        ${files}=         Create Dictionary    file=${file_tuple}
        ${upload_response}=    POST On Session    jira    /rest/api/3/issue/${issue_id}/attachments
        ...    files=${files}
        ...    headers=${upload_headers}
        Should Be True    ${upload_response.status_code} == 200 or ${upload_response.status_code} == 201
        Log    Uploaded attachment to issue ${issue_id}

        ${result}=    Run Process
        ...    python
        ...    automation_framework/tests/hybrid/validate_ui_attachment.py
        ...    ${issue_key}
        ...    shell=True
        ...    stdout=PIPE
        ...    stderr=PIPE
        Log    STDOUT: ${result.stdout}
        Log    STDERR: ${result.stderr}
        Log    RETURN CODE: ${result.rc}
    END

Workflow Status Transition Test
    Load Doppler Secrets
    Log    BASE_URL: ${BASE_URL}
    Log    EMAIL: ${EMAIL}
    Log    API_TOKEN: ${API_TOKEN}

    ${auth}=    Create List    ${EMAIL}    ${API_TOKEN}
    Create Session    jira    ${BASE_URL}    auth=${auth}

    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=Task
    ${fields}=     Create Dictionary    project=${project}    summary=Workflow Transition Test    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}
    ${headers}=    Create Dictionary    Accept=application/json

    ${response}=   POST On Session    jira    /rest/api/3/issue    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    ${body}=       Set Variable    ${response.json()}
    ${issue_key}=  Get From Dictionary    ${body}    key
    Log    Created Issue Key: ${issue_key}

    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/helpers_updated.py
    ...    ${BASE_URL}
    ...    ${EMAIL}
    ...    ${API_TOKEN}
    ...    ${issue_key}
    ...    Done
    ...    shell=True
    Log    Transition Result: ${result.stdout}

    ${ui_result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/validate_status_api.py
    ...    ${issue_key}
    ...    Done
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    UI Validation STDOUT: ${ui_result.stdout}
    Log    UI Validation STDERR: ${ui_result.stderr}
    Log    RETURN CODE: ${ui_result.rc}
