*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RequestsLibrary
Library           Process
Resource          ../../keywords/doppler_keywords.py
#Library           ../../keywords/doppler_keywords.py

Resource          ../../resources/variables.robot
Library           automation_framework.keywords.doppler_keywords.DopplerKeywords
#Library           automation_framework.keywords.doppler_keywords.DopplerKeywords

*** Variables ***
@{ISSUE_IDS}
${ATTACHMENT_PATH}    ../../resources/attachments/sample_attachment.txt

*** Test Cases ***
Create Issues And Upload Attachment
    Load Doppler Secrets
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

        # Upload attachment to the created issue
        ${file_tuple}=    Create List    ${ATTACHMENT_PATH}    ${ATTACHMENT_PATH}    text/plain
        ${upload_headers}=    Create Dictionary    X-Atlassian-Token=no-check
        ${files}=         Create Dictionary    file=${file_tuple}
        ${upload_response}=    POST On Session    jira    /rest/api/3/issue/${issue_id}/attachments
        ...    files=${files}
        ...    headers=${upload_headers}
        Should Be True    ${upload_response.status_code} == 200 or ${upload_response.status_code} == 201
        Log    Uploaded attachment to issue ${issue_id}

        # Call Python script to validate issue in UI
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
    [Documentation]    Create issue via API, transition status to Done, validate via UI

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

#Rate Limiting / Throttling Test
#    Load Doppler Secrets
#    [Documentation]    Send multiple rapid API requests to check Jira's rate limiting behavior
#
#    ${auth}=    Create List    ${EMAIL}    ${API_TOKEN}
#    Create Session    jira    ${BASE_URL}    auth=${auth}
#
#    ${project}=    Create Dictionary    key=${PROJECT_KEY}
#    ${issuetype}=  Create Dictionary    name=Task
#    ${fields}=     Create Dictionary    project=${project}    summary=Rate Limit Test Issue    issuetype=${issuetype}
#    ${payload}=    Create Dictionary    fields=${fields}
#    ${headers}=    Create Dictionary    Accept=application/json
#
#    FOR    ${i}    IN RANGE    0    50
#        ${response}=   POST On Session    jira    /rest/api/3/issue    json=${payload}    headers=${headers}
#        Log    [${i}] Status Code: ${response.status_code}
#        Run Keyword If    ${response.status_code} == 429    Log    Rate limit hit at request ${i}
#        Run Keyword If    ${response.status_code} != 201    Log    Unexpected response at request ${i}: ${response.content}
#        Sleep    0.2s
#    END

Issue Linking Test
    [Documentation]    Create two issues and link them using 'Blocks' relationship. Validate link via API.
    Load Doppler Secrets

    ${auth}=    Create List    ${EMAIL}    ${API_TOKEN}
    Create Session    jira    ${BASE_URL}    auth=${auth}    verify=False

    ${headers}=    Create Dictionary    Accept=application/json

    # Create Issue A
    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=Task
    ${fields_a}=   Create Dictionary    project=${project}    summary=Linked Issue A    issuetype=${issuetype}
    ${payload_a}=  Create Dictionary    fields=${fields_a}
    ${response_a}=    POST On Session    jira    /rest/api/3/issue    json=${payload_a}    headers=${headers}
    Should Be Equal As Strings    ${response_a.status_code}    201
    ${issue_a}=    Set Variable    ${response_a.json()}
    ${issue_key_a}=    Get From Dictionary    ${issue_a}    key
    Log    Created Issue A: ${issue_key_a}

    # Create Issue B
    ${fields_b}=   Create Dictionary    project=${project}    summary=Linked Issue B    issuetype=${issuetype}
    ${payload_b}=  Create Dictionary    fields=${fields_b}
    ${response_b}=    POST On Session    jira    /rest/api/3/issue    json=${payload_b}    headers=${headers}
    Should Be Equal As Strings    ${response_b.status_code}    201
    ${issue_b}=    Set Variable    ${response_b.json()}
    ${issue_key_b}=    Get From Dictionary    ${issue_b}    key
    Log    Created Issue B: ${issue_key_b}

    # Link Issue B blocks Issue A
    ${link_type}=    Create Dictionary    name=Blocks
    ${inward}=       Create Dictionary    key=${issue_key_a}
    ${outward}=      Create Dictionary    key=${issue_key_b}
    ${link_payload}=    Create Dictionary    type=${link_type}    inwardIssue=${inward}    outwardIssue=${outward}
    ${link_headers}=    Create Dictionary    Content-Type=application/json
    ${link_response}=    POST On Session    jira    /rest/api/3/issueLink    json=${link_payload}    headers=${link_headers}
    Should Be True    ${link_response.status_code} == 201 or ${link_response.status_code} == 200
    Log    Linked ${issue_key_b} blocks ${issue_key_a}
    Log    Link Response Content: ${link_response.content}

    # Validate link via GET
    ${get_response}=    GET On Session    jira    /rest/api/3/issue/${issue_key_a}    headers=${headers}
    Should Be Equal As Strings    ${get_response.status_code}    200
    ${issue_data}=      Set Variable    ${get_response.json()}
    ${issue_links}=     Get From Dictionary    ${issue_data['fields']}    issuelinks
    Log    Issue Links for ${issue_key_a}: ${issue_links}

    ${found}=    Set Variable    False
    FOR    ${link}    IN    @{issue_links}
        ${link_type_name}=    Get From Dictionary    ${link['type']}    name
        IF    '${link_type_name}' == 'Blocks' and 'outwardIssue' in ${link}
            ${outward_issue}=    Get From Dictionary    ${link}    outwardIssue
            ${outward_key}=      Get From Dictionary    ${outward_issue}    key
            Log    Found outward link to: ${outward_key}
            IF    '${outward_key}' == '${issue_key_b}'
                ${found}=    Set Variable    True
            END
        END
    END
    Should Be True    ${found}