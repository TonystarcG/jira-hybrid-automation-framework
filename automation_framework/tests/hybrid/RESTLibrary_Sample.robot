*** Settings ***
Library    RESTLibrary
Resource   rest_keywords.py

*** Test Cases ***
Simple GET Test
    Make HTTP Request    test get    https://reqres.in/api/users?page=1

*** Test Cases ***
List All Keywords
    ${keywords}=    BuiltIn.Get Library Instance    RESTLibrary
    Log    ${keywords}


*** Test Cases ***
List RESTLibrary Keywords
    ${keywords}=    List Restlibrary Keywords
    Log Many    ${keywords}



