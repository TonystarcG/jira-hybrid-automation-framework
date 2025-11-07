*** Settings ***
Library    Browser

*** Test Cases ***
Open Google
    New Browser    chromium
    New Page    https://www.google.com
    Close Browser
