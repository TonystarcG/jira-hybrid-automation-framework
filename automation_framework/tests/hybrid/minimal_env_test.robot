*** Settings ***
Library           OperatingSystem
Library           JSONLibrary
Resource          ../../resources/doppler_secrets.robot

*** Test Cases ***
Verify ISSUES_FILE Environment Variable
    Log    ISSUES_FILE: ${ISSUES_FILE}
    ${file}=    Get File    ${ISSUES_FILE}    encoding=UTF-8
    ${issues}=  Evaluate    json.loads('''${file}''')    modules=json
    Log    Loaded ${len(${issues})} issues from file
