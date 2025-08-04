*** Settings ***
Library    SeleniumLibrary
Library    DateTime

Resource    ../../../Config/imports.robot
Resource    ./1_CommonWeb.robot


*** Keywords ***
# Browser Navigation Keywords
Refresh Page
    [Documentation]    Refresh current page
    Reload Page
    Wait For Page To Load

Go Back
    [Documentation]    Navigate back to previous page
    Go Back
    Wait For Page To Load

Go Forward
    [Documentation]    Navigate forward to next page
    Execute Javascript    window.history.forward()
    Wait For Page To Load

Switch To New Window
    [Documentation]    Switch to the newest opened window
    ${handles}=    Get Window Handles
    ${new_window}=    Get From List    ${handles}    -1
    Switch Window    ${new_window}

Close Current Window And Switch Back
    [Documentation]    Close current window and switch to main window
    Close Window
    ${handles}=    Get Window Handles
    Switch Window    ${handles}[0]

# Scrolling Keywords
Scroll To Element
    [Documentation]    Scroll to make element visible
    [Arguments]    ${locator}
    Scroll Element Into View    ${locator}

Scroll To Top
    [Documentation]    Scroll to top of page
    Execute Javascript    window.scrollTo(0, 0)

Scroll To Bottom
    [Documentation]    Scroll to bottom of page
    Execute Javascript    window.scrollTo(0, document.body.scrollHeight)

# Enhanced Wait Keywords
Wait For Element To Disappear
    [Documentation]    Wait for element to become invisible
    [Arguments]    ${locator}    ${timeout}=20s
    Wait Until Element Is Not Visible    ${locator}    timeout=${timeout}

Wait For Text To Appear
    [Documentation]    Wait for specific text to appear on page
    [Arguments]    ${text}    ${timeout}=20s
    Wait Until Page Contains    ${text}    timeout=${timeout}

Wait For Element Count
    [Documentation]    Wait for specific number of elements matching locator
    [Arguments]    ${locator}    ${expected_count}    ${timeout}=20s
    Wait Until Keyword Succeeds    ${timeout}    1s
    ...    Should Be Equal As Numbers    ${expected_count}
    ...    Get Element Count    ${locator}