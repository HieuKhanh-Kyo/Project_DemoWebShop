*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource   ../../../Config/imports.robot

*** Variables ***
${TIMEOUT}    10s

*** Keywords ***
Open Browser To URL
    [Arguments]    ${url}    ${browser}=chrome
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Wait And Click Element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Click Element    ${locator}

Wait And Input Text
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    ${TIMEOUT}
    Input Text    ${locator}    ${text}

Verify Page Title
    [Arguments]    ${expected_title}
    ${actual_title}=    Get Title
    Should Be Equal    ${actual_title}    ${expected_title}