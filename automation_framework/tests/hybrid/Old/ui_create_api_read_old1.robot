*** Settings ***
Documentation     Hybrid test: UI creates issue, API reads it
Library           Process

*** Test Cases ***
Hybrid Flow - UI Creates and API Reads
    [Documentation]    Calls Python wrapper script for hybrid flow
    Run Process    python    automation_framework/tests/hybrid/run_ui_api_flow.py
    ...    stdout=STDOUT    stderr=STDERR