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