*** Settings ***
Library    OperatingSystem

*** Test Cases ***
Validate Environment Secrets
    Log    EMAIL: ${EMAIL}
    Log    API_TOKEN: ${API_TOKEN}
    Log    BASE_URL: ${BASE_URL}
    Log    PROJECT_KEY: ${PROJECT_KEY}
    Log    ISSUES_FILE: ${ISSUES_FILE}

    Should Not Be Empty    ${EMAIL}
    Should Not Be Empty    ${API_TOKEN}
    Should Not Be Empty    ${BASE_URL}
    Should Not Be Empty    ${PROJECT_KEY}
    Should Not Be Empty    ${ISSUES_FILE}