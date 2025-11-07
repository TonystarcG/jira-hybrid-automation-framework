*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RequestsLibrary
Library           Process
Resource          ../../resources/variables.robot
Library           automation_framework.keywords.doppler_keywords.DopplerKeywords

*** Variables ***
@{ISSUE_IDS}
${ATTACHMENT_PATH}    ../../resources/attachments/sample_attachment.txt

*** Test Cases ***
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