*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    String
Library    Collections

*** Keywords ***
# Text and Data Utilities
Generate Random Email
    [Documentation]    Generate random email for testing
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_number}=    Evaluate    random.randint(100, 999)    random
    ${email}=    Set Variable    test${timestamp}${random_number}@gmail.com
    RETURN    ${email}

Generate Random String
    [Documentation]    Generate random string with specified length
    [Arguments]    ${length}=8
    ${random_string}=    Generate Random String    ${length}    [LETTERS][NUMBERS]
    RETURN    ${random_string}

Generate Random Phone Number
    [Documentation]    Generate random phone number
    ${area_code}=    Evaluate    random.randint(100, 999)    random
    ${first_part}=    Evaluate    random.randint(100, 999)    random
    ${second_part}=    Evaluate    random.randint(1000, 9999)    random
    ${phone}=    Set Variable    ${area_code}-${first_part}-${second_part}
    RETURN    ${phone}

# Element Verification Utilities
Assert Element Contains Text
    [Documentation]    Verify element contains expected text
    [Arguments]    ${locator}    ${expected_text}
    ${actual_text}=    Get Text    ${locator}
    Should Contain    ${actual_text}    ${expected_text}

Assert Element Text Equals
    [Documentation]    Verify element text exactly matches expected text
    [Arguments]    ${locator}    ${expected_text}
    ${actual_text}=    Get Text    ${locator}
    Should Be Equal    ${actual_text}    ${expected_text}

Verify Element Attribute
    [Documentation]    Verify element has expected attribute value
    [Arguments]    ${locator}    ${attribute}    ${expected_value}
    ${actual_value}=    Get Element Attribute    ${locator}    ${attribute}
    Should Be Equal    ${actual_value}    ${expected_value}

# File and Data Utilities
Create Test Data Dictionary
    [Documentation]    Create dictionary with common test data
    ${test_data}=    Create Dictionary
    ...    email=${EMPTY}
    ...    password=Test123!
    ...    first_name=Test
    ...    last_name=User
    ...    phone=${EMPTY}

    ${email}=    Generate Random Email
    ${phone}=    Generate Random Phone Number
    Set To Dictionary    ${test_data}    email    ${email}
    Set To Dictionary    ${test_data}    phone    ${phone}

    RETURN    ${test_data}

# Wait Assertion Utilities
Wait And Assert Element Visible
    [Documentation]    Wait for element and assert it's visible
    [Arguments]    ${locator}    ${timeout}=20s
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Element Should Be Visible    ${locator}

Wait And Assert Text Present
    [Documentation]    Wait for text and assert it's present
    [Arguments]    ${text}    ${timeout}=20s
    Wait Until Page Contains    ${text}    timeout=${timeout}
    Page Should Contain    ${text}

# URL and Navigation Utilities
Get Current URL Path
    [Documentation]    Get current URL path without domain
    ${current_url}=    Get Location
    ${path}=    Evaluate    urllib.parse.urlparse('${current_url}').path    urllib.parse
    RETURN    ${path}

Verify Current URL Contains
    [Documentation]    Verify current URL contains expected text
    [Arguments]    ${expected_text}
    ${current_url}=    Get Location
    Should Contain    ${current_url}    ${expected_text}

# Screenshot Utilities
Take Screenshot With Custom Name
    [Documentation]    Take screenshot with custom filename
    [Arguments]    ${name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${filename}=    Set Variable    ${name}_${timestamp}.png
    Capture Page Screenshot    Results/Screenshots/${filename}
    RETURN    ${filename}

# Table Utilities
Get Table Cell Text
    [Documentation]    Get text from specific table cell
    [Arguments]    ${table_locator}    ${row}    ${column}
    ${cell_locator}=    Set Variable    ${table_locator} tbody tr:nth-child(${row}) td:nth-child(${column})
    ${text}=    Get Text    ${cell_locator}
    RETURN    ${text}

Verify Table Contains Text
    [Documentation]    Verify table contains specific text
    [Arguments]    ${table_locator}    ${expected_text}
    ${table_text}=    Get Text    ${table_locator}
    Should Contain    ${table_text}    ${expected_text}