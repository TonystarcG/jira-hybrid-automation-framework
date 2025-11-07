*** Settings ***
Documentation     API Creates Issue and UI Reads It via Python Wrapper
Library           Process

*** Test Cases ***
Hybrid Flow - API Creates and UI Reads
    [Documentation]    Calls Python wrapper script to run API to UI flow

    Log To Console    Running wrapper script: run_api_ui_flow.py

    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_api_ui_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE

    Log To Console    STDOUT: ${result.stdout}
    Log To Console    STDERR: ${result.stderr}
    Log To Console    RETURN CODE: ${result.rc}

    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}