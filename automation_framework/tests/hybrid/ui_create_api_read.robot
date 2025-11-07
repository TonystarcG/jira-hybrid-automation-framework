*** Settings ***
Documentation     UI Creates Issue and API Reads It via Python Wrapper
Library           Process

*** Test Cases ***
Hybrid Flow - UI Creates and API Reads
    [Documentation]    Calls Python wrapper script to run UI to API flow

    Log To Console    Running wrapper script: run_ui_api_flow.py

    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_ui_api_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE

    Log To Console    STDOUT: ${result.stdout}
    Log To Console    STDERR: ${result.stderr}
    Log To Console    RETURN CODE: ${result.rc}

    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}