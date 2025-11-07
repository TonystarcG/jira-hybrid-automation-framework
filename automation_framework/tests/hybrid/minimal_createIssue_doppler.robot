*** Settings ***
Library           OperatingSystem
Library           JSONLibrary
Library           RESTLibrary
Library           BuiltIn
Library           String
Library           Collections

*** Variables ***
@{ISSUE_IDS}      Create List

*** Test Cases ***
Create Issues
    Log    [DEBUG] ISSUES_FILE path: %{ISSUES_FILE}
    ${file}=    Get File    %{ISSUES_FILE}    encoding=UTF-8
    Log    [DEBUG] Raw file content:\n${file}

    ${data}=    Evaluate    json.loads("""${file}""")    modules=json
    Log    [DEBUG] Parsed JSON keys: ${data.keys()}

    ${issues}=    Set Variable    ${data['valid_issues']}
    ${count}=     Get Length      ${issues}
    Log           [DEBUG] Number of issues to create: ${count}

    FOR    ${issue}    IN    @{issues}
        Log    [DEBUG] Processing issue: ${issue}
        ${summary}=        Set Variable    ${issue['summary']}
        ${safe_summary}=   Replace String    ${summary}    ${SPACE}    _
        ${request_id}=     Set Variable    create_${safe_summary}

        ${project}=    Create Dictionary    key=${issue['project_key']}
        ${issuetype}=  Create Dictionary    name=${issue['issue_type']}
        ${fields}=     Create Dictionary    project=${project}    summary=${summary}    issuetype=${issuetype}
        ${payload}=    Create Dictionary    fields=${fields}

        TRY
            ${response}=   Make HTTP Request    ${request_id}    %{BASE_URL}/rest/api/3/issue
            ...    method=POST
            ...    authType=Basic
            ...    username=%{EMAIL}
            ...    password=%{API_TOKEN}
            ...    requestHeaders={"Content-Type": "application/json", "Accept": "application/json"}
            ...    requestBody=${payload}
            ...    expectedStatusCode=201

            ${issue_id}=   Execute RC    <<<rc, ${request_id}, body, $.id>>>
            Log    [INFO] Created Issue ID: ${issue_id}
            Append To List    ${ISSUE_IDS}    ${issue_id}
        EXCEPT
            Log    [ERROR] Failed to create issue: ${summary}
            ${status}=    Get Response Status Code    ${request_id}
            ${body}=      Get Response Body            ${request_id}
            Log    [ERROR] Status Code: ${status}
            Log    [ERROR] Response Body:\n${body}
        END
    END

    Log    [INFO] All created issue IDs: ${ISSUE_IDS}