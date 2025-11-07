*** Settings ***
Library    Collections
Library    OperatingSystem
Library    JSONLibrary
Library    ../../keywords/helpers.py

#Resource   ../../resources/variables_old2.robot

*** Variables ***
@{ISSUE_IDS}

*** Test Cases ***
Verify Doppler Secrets
    Log    BASE_URL: ${BASE_URL}
    Log    EMAIL: ${EMAIL}
    Log    API_TOKEN: ${API_TOKEN}
    Log    PROJECT_KEY: ${PROJECT_KEY}
    Log    ISSUES_FILE: ${ISSUES_FILE}
Create Issues
    Log    [DEBUG] ISSUES_FILE path: ${ISSUES_FILE}
    ${auth}=    Evaluate    helpers.get_auth_header("${EMAIL}", "${API_TOKEN}")    modules=helpers
    ${file}=    Get File    ${ISSUES_FILE}    encoding=UTF-8
    ${data}=    Evaluate    json.loads("""${file}""")    modules=json
    ${issues}=  Set Variable    ${data['valid_issues']}

    FOR    ${issue}    IN    @{issues}
        Log    [DEBUG] Creating issue: ${issue['summary']} of type ${issue['type']}
        ${status_code}    ${resp}=    Evaluate    helpers.Create_Issue("${BASE_URL}", ${auth}, "${PROJECT_KEY}", "${issue['summary']}", "${issue['type']}")    modules=helpers
        Log    ${resp}
        Should Be Equal As Integers    ${status_code}    201
        Log    Created Issue ID: ${resp['id']}
        Append To List    ${ISSUE_IDS}    ${resp['id']}
    END

    Log    [INFO] All created issue IDs: ${ISSUE_IDS}