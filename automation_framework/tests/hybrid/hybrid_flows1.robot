*** Settings ***
Documentation     Unified Hybrid Test Suite: API ↔ UI Flows (Positive + Negative)
Library           Process

*** Test Cases ***
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
