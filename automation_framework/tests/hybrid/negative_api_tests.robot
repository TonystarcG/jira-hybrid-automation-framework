*** Settings ***
Documentation     Negative API Test Suite: Invalid Project Key, Unsupported Issue Type, Malformed Payload
Library           Process

*** Test Cases ***
Negative Test - Invalid Project Key
    [Documentation]    Attempts to create issue with invalid project key
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_invalid_project.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}
    Should Match Regexp    ${result.stdout}    (?i).*Status Code: 400.*
    Should Contain         ${result.stdout}    "valid project is required"

Negative Test - Unsupported Issue Type
    [Documentation]    Attempts to create issue with unsupported issue type
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_unsupported_issue_type.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}
    Should Match Regexp    ${result.stdout}    (?i).*Status Code: 400.*
    Should Contain         ${result.stdout}    "Specify a valid issue type"

Negative Test - Malformed Payload
    [Documentation]    Attempts to create issue with malformed payload
    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_malformed_payload.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}
    Should Match Regexp    ${result.stdout}    (?i).*Status Code: 400.*
    Should Contain         ${result.stdout}    "Specify a valid project ID or key"