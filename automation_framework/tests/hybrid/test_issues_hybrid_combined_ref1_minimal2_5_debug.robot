
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
    [Documentation]    Debug version to verify Doppler secrets and session creation
    Load Doppler Secrets

    # Debug: Log all secrets
    Log    EMAIL: ${EMAIL}
    Log    API_TOKEN: ${API_TOKEN}
    Log    BASE_URL: ${BASE_URL}
    Log    PROJECT_KEY: ${PROJECT_KEY}
    Log    ISSUES_FILE: ${ISSUES_FILE}

    # Validate secrets are not empty
    Should Not Be Empty    ${EMAIL}
    Should Not Be Empty    ${API_TOKEN}
    Should Not Be Empty    ${BASE_URL}
    Should Not Be Empty    ${PROJECT_KEY}
    Should Not Be Empty    ${ISSUES_FILE}

    # Create session with correct auth format
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
        Log    Response Status: ${response.status_code}
        Log    Response Body: ${response.content}
        Should Be Equal As Strings    ${response.status_code}    201

        ${body}=       Set Variable    ${response.json()}
        ${issue_id}=   Get From Dictionary    ${body}    id
        ${issue_key}=  Get From Dictionary    ${body}    key
        Log    Created Issue ID: ${issue_id}
        Append To List    ${ISSUE_IDS}    ${issue_id}

        # Upload attachment to the created issue
        ${file_tuple}=    Create List    ${ATTACHMENT_PATH}    ${ATTACHMENT_PATH}    text/plain
        ${upload_headers}=    Create Dictionary    X-Atlassian-Token=no-check
        ${files}=         Create Dictionary    file=${file_tuple}
        ${upload_response}=    POST On Session    jira    /rest/api/3/issue/${issue_id}/attachments
        ...    files=${files}
        ...    headers=${upload_headers}
        Log    Upload Status: ${upload_response.status_code}
        Log    Upload Response: ${upload_response.content}
        Should Be True    ${upload_response.status_code} == 200 or ${upload_response.status_code} == 201
        Log    Uploaded attachment to issue ${issue_id}
    END
