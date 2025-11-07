*** Settings ***
Documentation     Negative Test: API Creates Invalid Issue, UI Reads It
Library           Process

*** Test Cases ***
Negative Flow - API Creates Invalid Issue and UI Reads
    Log To Console    Running negative wrapper script: run_api_ui_negative_flow.py

    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_api_ui_negative_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE

    Log To Console    STDOUT: ${result.stdout}
    Log To Console    STDERR: ${result.stderr}
    Log To Console    RETURN CODE: ${result.rc}

    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}