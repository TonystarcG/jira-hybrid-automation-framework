*** Settings ***
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
Library           ../../keywords/helpers.py
Resource          ../../resources/variables.robot

Suite Setup       Setup Auth

*** Variables ***
${INVALID_TYPE}       InvalidType
${EMPTY_SUMMARY}      ${EMPTY}
${INVALID_TOKEN}      invalid_token_123

*** Keywords ***
Setup Auth
    ${auth}=    helpers.Get Auth Header    ${EMAIL}    ${API_TOKEN}
    Set Suite Variable    ${AUTH}    ${auth}

*** Test Cases ***
Create Issue with Invalid Type
    ${status}    ${resp}=    helpers.Create_Issue    ${BASE_URL}    ${AUTH}    ${PROJECT_KEY}    Invalid Type Test    ${INVALID_TYPE}
    Log    ${resp}
    Should Be Equal As Integers    ${status}    400
Create Issue with Empty Summary
    ${status}    ${resp}=    helpers.Create_Issue    ${BASE_URL}    ${AUTH}    ${PROJECT_KEY}    ${EMPTY_SUMMARY}    Task
    Log    ${resp}
    Should Be Equal As Integers    ${status}    400

Create Issue with Invalid Auth
    ${invalid_auth}=    helpers.Get Auth Header    ${EMAIL}    ${INVALID_TOKEN}
    ${status}    ${resp}=    helpers.Create_Issue    ${BASE_URL}    ${invalid_auth}    ${PROJECT_KEY}    Unauthorized Test    Task
    Log    ${resp}
    Should Be Equal As Integers    ${status}    401

Get Issue with Invalid ID
    ${status}    ${resp}=    helpers.Get_Issue    ${BASE_URL}    ${AUTH}    INVALID-123
    Log    ${resp}
    Should Be Equal As Integers    ${status}    404

