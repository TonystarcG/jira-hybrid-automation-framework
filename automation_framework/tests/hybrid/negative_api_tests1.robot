*** Settings ***
Library    NegativeIssueKeywords.py
#Library    C:/Users/hrsing/PycharmProjects/PythonProject/Jira_Hybrid_AutomationFramework/automation_framework/tests/hybrid/NegativeIssueKeywords.py

*** Test Cases ***
Negative Test - Invalid Project Key
    ${status}    ${response}=    Create Issue With Invalid Project Key
    Status Should Be    ${status}    400
    Response Should Contain    ${response}    "valid project is required"

Negative Test - Unsupported Issue Type
    ${status}    ${response}=    Create Issue With Unsupported Issue Type
    Status Should Be    ${status}    400
    Response Should Contain    ${response}    "Specify a valid issue type"

Negative Test - Malformed Payload
    ${status}    ${response}=    Create Issue With Malformed Payload
    Status Should Be    ${status}    400
    Response Should Contain    ${response}    "Specify a valid project ID or key"