*** Settings ***
Library    OperatingSystem

*** Variables ***
${API_TOKEN}           Evaluate    os.getenv("API_TOKEN")           modules=os
${PROJECT_KEY}         Evaluate    os.getenv("PROJECT_KEY")         modules=os
${BASE_URL}            Evaluate    os.getenv("BASE_URL")            modules=os
${EMAIL}               Evaluate    os.getenv("EMAIL")               modules=os
${DOPPLER_CONFIG}      Evaluate    os.getenv("DOPPLER_CONFIG")      modules=os
${DOPPLER_ENVIRONMENT} Evaluate    os.getenv("DOPPLER_ENVIRONMENT") modules=os
${DOPPLER_PROJECT}     Evaluate    os.getenv("DOPPLER_PROJECT")     modules=os
${ISSUES_FILE}         Evaluate    os.getenv("ISSUES_FILE")         modules=os

#*** Test Cases ***
#Debug Environment Variables
#    Log    API_TOKEN: ${API_TOKEN}
#    Log    PROJECT_KEY: ${PROJECT_KEY}
#    Log    BASE_URL: ${BASE_URL}
#    Log    EMAIL: ${EMAIL}
#    Log    DOPPLER_CONFIG: ${DOPPLER_CONFIG}
#    Log    DOPPLER_ENVIRONMENT: ${DOPPLER_ENVIRONMENT}
#    Log    DOPPLER_PROJECT: ${DOPPLER_PROJECT}
#    Log    ISSUES_FILE: ${ISSUES_FILE}