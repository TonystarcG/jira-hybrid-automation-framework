*** Settings ***
Documentation     API Creates Issue and UI Reads It via Python Wrapper
Library           Process

*** Test Cases ***
Hybrid Flow - API Creates and UI Reads
    [Documentation]    Calls Python function to create Jira issue via API and read it via UI
    ${result}=    Run Process    python    -c    "from hybrid_flows import api_creates_ui_reads; print(api_creates_ui_reads())"    shell=True    stdout=PIPE
    Log    ${result.stdout}
