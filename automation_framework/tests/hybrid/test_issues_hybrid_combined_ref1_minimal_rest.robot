*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RESTLibrary

Resource          ../../resources/variables.robot

*** Variables ***
@{ISSUE_IDS}
${ATTACHMENT_PATH}    ../../resources/attachments/sample_attachment.txt

*** Test Cases ***
Create Issues And Upload Attachment
    ${file}=    Get File    ${ISSUES_FILE}
    ${data}=    Evaluate    json.loads(${file})    json
    ${issues}=  Set Variable    ${data['valid_issues']}

    ${index}=    Set Variable    0
    FOR    ${issue}    IN    @{issues}
        ${project}=    Create Dictionary    key=${PROJECT_KEY}
        ${issuetype}=  Create Dictionary    name=${issue['issue_type']}
        ${fields}=     Create Dictionary    project=${project}    summary=${issue['summary']}    issuetype=${issuetype}
        ${payload}=    Create Dictionary    fields=${fields}
        ${request_id}=    Set Variable    create_issue_${index}
        ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
        ${auth}=       Create List    ${EMAIL}    ${API_TOKEN}
        ${response}=   Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue
        ...    method=POST
        ...    authType=Basic
        ...    username=${auth}[0]
        ...    password=${auth}[1]
        ...    requestHeaders=${headers}
        ...    requestBody=${payload}
        ...    expectedStatusCode=201
        ${issue_id}=    Get From Dictionary    ${response['body']}    id
        Log    Created Issue ID: ${issue_id}
        Append To List    ${ISSUE_IDS}    ${issue_id}

        # Upload attachment to the created issue
        ${upload_id}=    Set Variable    upload_attachment_${index}
        ${upload_headers}=    Create Dictionary    X-Atlassian-Token=no-check
        ${upload_response}=    Make HTTP Request    ${upload_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}/attachments
        ...    method=POST
        ...    authType=Basic
        ...    username=${auth}[0]
        ...    password=${auth}[1]
        ...    requestHeaders=${upload_headers}
        ...    multipartFiles={"file": "${ATTACHMENT_PATH}"}
        ...    expectedStatusCode=200
        Log    Uploaded attachment to issue ${issue_id}
        ${index}=    Evaluate    ${index} + 1
    END
