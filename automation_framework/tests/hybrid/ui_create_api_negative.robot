*** Settings ***
Documentation     Negative Test: UI Creates Invalid Issue, API Reads It
Library           Process

*** Test Cases ***
Negative Flow - UI Creates Invalid Issue and API Reads
    Log To Console    Running negative wrapper script: run_ui_api_negative_flow.py

    ${result}=    Run Process
    ...    python
    ...    automation_framework/tests/hybrid/run_ui_api_negative_flow.py
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE

    Log To Console    STDOUT: ${result.stdout}
    Log To Console    STDERR: ${result.stderr}
    Log To Console    RETURN CODE: ${result.rc}

    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Log    RETURN CODE: ${result.rc}