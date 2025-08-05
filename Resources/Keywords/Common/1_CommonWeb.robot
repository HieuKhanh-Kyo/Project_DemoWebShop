*** Settings ***
Library    SeleniumLibrary
Library    DateTime

Resource   ../../../Config/imports.robot
Resource   ./2_BrowserNavigation.robot
#Resource   ../../PageObject/Customer/2_LoginPage.robot

*** Keywords ***
Open Application
    [Documentation]    Open browser and navigate to application
    2_BrowserConfig.Setup Browser
    Go To   ${URL}
    1_CommonWeb.Wait For Page To Load

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

## Enhanced Error Handling for Login
#Wait For Login Form Load
#    [Documentation]    Wait for login form to fully load with retry
#    Wait Until Keyword Succeeds    30s    2s    Element Should Be Visible    ${LOGIN_FORM}
#    Wait Until Keyword Succeeds    30s    2s    Element Should Be Enabled    ${LOGIN_SUBMIT_BUTTON}
#
#Handle Login Error
#    [Documentation]    Handle various login error scenarios
#    ${error_present}=    Run Keyword And Return Status    Element Should Be Visible    ${ERROR_MESSAGE}
#    IF    ${error_present}
#        ${error_text}=    Get Text    ${ERROR_MESSAGE}
#        Log    Login Error: ${error_text}
#        Take Screenshot On Failure    login_error
#    END
#
#Retry Login On Failure
#    [Documentation]    Retry login if it fails due to temporary issues
#    [Arguments]    ${email}    ${password}    ${max_attempts}=3
#    FOR    ${attempt}    IN RANGE    1    ${max_attempts + 1}
#        ${status}=    Run Keyword And Return Status    Login With Valid Credentials    ${email}    ${password}
#        IF    ${status}
#            BREAK
#        ELSE
#            Log    Login attempt ${attempt} failed, retrying...
#            Sleep    2s
#            2_BrowserNavigation.Refresh Page
#        END
#    END
#    Should Be True    ${status}    Login failed after ${max_attempts} attempts