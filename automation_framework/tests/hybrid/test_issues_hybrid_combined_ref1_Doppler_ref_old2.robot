*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           RESTLibrary
Library           Process
#Resource          ../../resources/variables_old2.robot
Resource          ../../resources/doppler_secrets.robot
#Variables         ../../resources/doppler_secrets_old2.robot

*** Variables ***
${API_TOKEN}        Evaluate    os.getenv("API_TOKEN")    modules=os
${PROJECT_KEY}      Evaluate    os.getenv("PROJECT_KEY")  modules=os
${BASE_URL}         Evaluate    os.getenv("BASE_URL")     modules=os
${EMAIL}            Evaluate    os.getenv("EMAIL")        modules=os

*** Variables ***
@{ISSUE_IDS}

*** Test Cases ***
Create Issues
    ${file}=    Get File    ${ISSUES_FILE}
    ${issues}=  Evaluate    json.loads('''${file}''')    modules=json

    ${index}=    Set Variable    0
    FOR    ${issue}    IN    @{issues}
        ${project}=    Create Dictionary    key=${PROJECT_KEY}
        ${issuetype}=  Create Dictionary    name=${issue['type']}
        ${fields}=     Create Dictionary    project=${project}    summary=${issue['summary']}    issuetype=${issuetype}
        ${payload}=    Create Dictionary    fields=${fields}
        ${request_id}=    Set Variable    create_issue_${index}
        ${requestInfo}=    Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue
        ...    method=POST
        ...    authType=Basic
        ...    username=${EMAIL}
        ...    password=${API_TOKEN}
        ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
        ...    requestBody=${payload}
        ...    expectedStatusCode=201
        ${issue_id}=    Execute RC    <<<rc, ${request_id}, body, $.id>>>
        Log    Created Issue ID: ${issue_id}
        Append To List    ${ISSUE_IDS}    ${issue_id}
        ${index}=    Evaluate    ${index} + 1
    END

Get Issues
    FOR    ${issue_id}    IN    @{ISSUE_IDS}
        ${request_id}=    Set Variable    get_issue_${issue_id}
        ${requestInfo}=    Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}
        ...    method=GET
        ...    authType=Basic
        ...    username=${EMAIL}
        ...    password=${API_TOKEN}
        ...    requestHeaders={"Accept": "application/json"}
        ...    expectedStatusCode=200
        ${summary}=    Execute RC    <<<rc, ${request_id}, body, $.fields.summary>>>
        Log    Issue Summary: ${summary}
    END

Update Issues
    FOR    ${issue_id}    IN    @{ISSUE_IDS}
        ${new_summary}=    Set Variable    Updated ${issue_id}
        ${fields}=         Create Dictionary    summary=${new_summary}
        ${payload}=        Create Dictionary    fields=${fields}
        Make HTTP Request    update_issue_${issue_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}
        ...    method=PUT
        ...    authType=Basic
        ...    username=${EMAIL}
        ...    password=${API_TOKEN}
        ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
        ...    requestBody=${payload}
        ...    expectedStatusCode=204
    END

#Delete Issues
#    FOR    ${issue_id}    IN    @{ISSUE_IDS}
#        Make HTTP Request    delete_issue_${issue_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}
#        ...    method=DELETE
#        ...    authType=Basic
#        ...    username=${EMAIL}
#        ...    password=${API_TOKEN}
#        ...    requestHeaders={"Accept": "application/json"}
#        ...    expectedStatusCode=204
#    END

#Delete Issues
#    Log    Starting Delete Issues Test
#    Log    Issue IDs to delete: ${ISSUE_IDS}
#    FOR    ${issue_id}    IN    @{ISSUE_IDS}
#        ${request_id}=    Set Variable    delete_issue_${issue_id}
#        ${response}=    Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}
#        ...    method=DELETE
#        ...    authType=Basic
#        ...    username=${EMAIL}
#        ...    password=${API_TOKEN}
#        ...    requestHeaders={"Accept": "application/json"}
#        ...    expectedStatusCode=204
#        ${status}=    Get From Dictionary    ${response}    status_code
#        ${body}=      Get From Dictionary    ${response}    body
#        Log    DELETE Response Status for ${issue_id}: ${status}
#        Log    DELETE Response Body for ${issue_id}: ${body}

#Delete Issues
#    Log    Starting Delete Issues Test
#    Log    Issue IDs to delete: ${ISSUE_IDS}
#    FOR    ${issue_id}    IN    @{ISSUE_IDS}
#        ${request_id}=    Set Variable    delete_issue_${issue_id}
#        ${response}=    Make HTTP Request    ${request_id}    ${BASE_URL}/rest/api/3/issue/${issue_id}
#        ...    method=DELETE
#        ...    authType=Basic
#        ...    username=${EMAIL}
#        ...    password=${API_TOKEN}
#        ...    requestHeaders={"Accept": "application/json"}
#        ...    expectedStatusCode=204
#        ${status}=    Get From Dictionary    ${response}    status_code
#        ${body}=      Get From Dictionary    ${response}    body
#        Log    DELETE Response Status for ${issue_id}: ${status}
#        Log    DELETE Response Body for ${issue_id}: ${body}
#    END


Create Issue Without Summary
    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=Task
    ${fields}=     Create Dictionary    project=${project}    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}
    Make HTTP Request    create_missing_summary    ${BASE_URL}/rest/api/3/issue
    ...    method=POST
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
    ...    requestBody=${payload}
    ...    expectedStatusCode=400

Create Issue With Invalid Project Key
    ${project}=    Create Dictionary    key=INVALID
    ${issuetype}=  Create Dictionary    name=Task
    ${fields}=     Create Dictionary    project=${project}    summary=Invalid Project    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}
    Make HTTP Request    create_invalid_project    ${BASE_URL}/rest/api/3/issue
    ...    method=POST
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
    ...    requestBody=${payload}
    ...    expectedStatusCode=400

Create Issue With Invalid Auth
    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=Task
    ${fields}=     Create Dictionary    project=${project}    summary=Bad Auth    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}
    Make HTTP Request    create_invalid_auth    ${BASE_URL}/rest/api/3/issue
    ...    method=POST
    ...    authType=Basic
    ...    username=wrong@example.com
    ...    password=wrongtoken123
    ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
    ...    requestBody=${payload}
    ...    expectedStatusCode=401

Get Issue With Invalid ID
    Make HTTP Request    get_invalid_issue    ${BASE_URL}/rest/api/3/issue/INVALID_ID_123
    ...    method=GET
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Accept": "application/json"}
    ...    expectedStatusCode=404

Delete Nonexistent Issue
    Make HTTP Request    delete_nonexistent_issue    ${BASE_URL}/rest/api/3/issue/FAKE_ISSUE_999
    ...    method=DELETE
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Accept": "application/json"}
    ...    expectedStatusCode=404

Create Issue With Extended Fields
    ${project}=    Create Dictionary    key=${PROJECT_KEY}
    ${issuetype}=  Create Dictionary    name=Task
    ${fields}=     Create Dictionary
    ...    project=${project}
    ...    summary=Extended Issue
    ...    issuetype=${issuetype}
    ${payload}=    Create Dictionary    fields=${fields}
    Make HTTP Request    create_extended_issue    ${BASE_URL}/rest/api/3/issue
    ...    method=POST
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
    ...    requestBody=${payload}
    ...    expectedStatusCode=201

Create Issue With Invalid Field Type
    ${issuetype}=    Create Dictionary    name=Task
    ${fields}=       Create Dictionary
    ...    project=INVALID_PROJECT_FORMAT
    ...    summary=Bad Format
    ...    issuetype=${issuetype}
    ${payload}=      Create Dictionary    fields=${fields}
    Make HTTP Request    create_bad_format    ${BASE_URL}/rest/api/3/issue
    ...    method=POST
    ...    authType=Basic
    ...    username=${EMAIL}
    ...    password=${API_TOKEN}
    ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
    ...    requestBody=${payload}
    ...    expectedStatusCode=400
Hybrid Flow - API Creates and UI Reads
    [Documentation]    Validates issue created via API and read via UI
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_api_ui_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}

Hybrid Flow - UI Creates and API Reads
    [Documentation]    Validates issue created via UI and read via API
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_ui_api_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}

Negative Flow - API Creates Invalid Issue and UI Reads
    [Documentation]    Validates UI behavior for invalid issue created via API
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_api_ui_negative_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}

Negative Flow - UI Creates Invalid Issue and API Reads
    [Documentation]    Validates API behavior for invalid issue created via UI
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_ui_api_negative_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}

#Negative Test - Invalid Project Key
#    [Documentation]    Attempts to create issue with invalid project key
#    ${result}=    Run Process
#    ...    python
#    ...    automation_framework/tests/hybrid/run_invalid_project.py
#    ...    shell=True
#    ...    stdout=PIPE
#    ...    stderr=PIPE
#    Log    STDOUT: ${result.stdout}
#    Log    STDERR: ${result.stderr}
#    Log    RETURN CODE: ${result.rc}
#    Should Match Regexp    ${result.stdout}    (?i).*Status Code: 400.*
#    Should Contain         ${result.stdout}    "valid project is required"
#
#Negative Test - Unsupported Issue Type
#    [Documentation]    Attempts to create issue with unsupported issue type
#    ${result}=    Run Process
#    ...    python
#    ...    automation_framework/tests/hybrid/run_unsupported_issue_type.py
#    ...    shell=True
#    ...    stdout=PIPE
#    ...    stderr=PIPE
#    Log    STDOUT: ${result.stdout}
#    Log    STDERR: ${result.stderr}
#    Log    RETURN CODE: ${result.rc}
#    Should Match Regexp    ${result.stdout}    (?i).*Status Code: 400.*
#    Should Contain         ${result.stdout}    "Specify a valid issue type"
#
#Negative Test - Malformed Payload
#    [Documentation]    Attempts to create issue with malformed payload
#    ${result}=    Run Process
#    ...    python
#    ...    automation_framework/tests/hybrid/run_malformed_payload.py
#    ...    shell=True
#    ...    stdout=PIPE
#    ...    stderr=PIPE
#    Log    STDOUT: ${result.stdout}
#    Log    STDERR: ${result.stderr}
#    Log    RETURN CODE: ${result.rc}
#    Should Match Regexp    ${result.stdout}    (?i).*Status Code: 400.*
#    Should Contain         ${result.stdout}    "Specify a valid project ID or key"