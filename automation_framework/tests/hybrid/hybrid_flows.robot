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
