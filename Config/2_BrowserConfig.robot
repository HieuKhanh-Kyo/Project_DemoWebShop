*** Settings ***
Library                 SeleniumLibrary
Library                 Collections

Resource                1_Environments.robot

*** Variables ***
# Browser Settings
${BROWSER}              chrome
${HEADLESS}             False           # run with display UI (no headless)
${WINDOW_SIZE}          1920x1080

# Browser Options
#@{CHROME_OPTIONS}       --disable-extensions
#...                     --disable-popup-blocking
#...                     --disable-notifications
#...                     --start-maximized
#
#@{FIREFOX_OPTIONS}      --width=1920
#...                     --height=1080

*** Keywords ***
Setup Browser
    [Documentation]    Setup browser with configurations
    [Arguments]    ${browser}=${BROWSER}

    IF    '${browser}' == 'chrome'
        ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

        # Định nghĩa options trực tiếp
        @{chrome_args}=    Create List    --disable-extensions    --disable-popup-blocking    --disable-notifications    --start-maximized

        FOR    ${option}    IN    @{chrome_args}
            Call Method    ${chrome_options}    add_argument    ${option}
        END
        Create Webdriver    Chrome    options=${chrome_options}
    END

    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}