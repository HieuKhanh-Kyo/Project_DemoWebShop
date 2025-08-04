*** Settings ***
Library    SeleniumLibrary
Library    DateTime

Resource   ../../../Config/imports.robot


*** Keywords ***
Open Application
    [Documentation]    Open browser and navigate to application
    2_BrowserConfig.Setup Browser
    Go To                       ${URL}
    Wait For Page To Load

Wait For Page To Load
    [Documentation]    Wait for page to completely load
    Wait For Condition          return document.readyState == 'complete'    timeout=30s
    Sleep    1s    # Additional buffer time

Wait For Element And Click
    [Documentation]    Wait for element to be clickable and click
    [Arguments]    ${locator}    ${timeout}=20s
    Wait Until Element Is Enabled    ${locator}    timeout=${timeout}
    Click Element    ${locator}

Wait For Element And Input Text
    [Documentation]    Wait for element and input text
    [Arguments]    ${locator}    ${text}    ${timeout}=20s
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

Verify Page Title Contains
    [Documentation]    Verify page title contains expected text
    [Arguments]    ${expected_text}
    ${actual_title}=    Get Title
    Should Contain    ${actual_title}    ${expected_text}

Take Screenshot On Failure
    [Documentation]    Take screenshot when test fails
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    Results/Screenshots/failure_${timestamp}.png

Close Application
    [Documentation]    Close browser and cleanup
    Close All Browsers