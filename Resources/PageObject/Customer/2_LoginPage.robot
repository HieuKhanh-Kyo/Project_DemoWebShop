*** Settings ***
Library     SeleniumLibrary

Resource    ../Common/imports.robot
Resource    ../../Keywords/Customer/imports.robot

*** Variables ***
# Login Page Locators
${LOGIN_EMAIL_FIELD}       id=Email
${LOGIN_PASSWORD_FIELD}    id=Password
${LOGIN_SUBMIT_BUTTON}     xpath=//input[@class='button-1 login-button']
${LOGIN_FORM}              xpath=//div[@class='form-fields']
${REMEMBER_ME_CHECKBOX}    id=RememberMe
${FORGOT_PASSWORD_LINK}    xpath=//a[contains(@href,'passwordrecovery')]
${ERROR_MESSAGE}           xpath=//div[@class='message-error']

# Error Elements
${PASSWORD_RECOVERY_LINK}      xpath=//a[contains(@href, 'passwordrecovery')]
${VALIDATION_SUMMARY}          xpath=//div[@class='validation-summary-errors']
${EMAIL_VALIDATION_ERROR}      xpath=//span[@data-valmsg-for='Email']
${PASSWORD_VALIDATION_ERROR}   xpath=//span[@data-valmsg-for='Password']

# Page Elements
${LOGIN_PAGE_TITLE}        xpath=//div[@class='page-title']
${LOGIN_FORM_CONTAINER}    xpath=//div[@class='page login-page']
${REGISTER_BUTTON}         xpath=//input[@class='button-1 register-button']

*** Keywords ***
Verify Login Page Loaded
    [Documentation]    Verify login page is completely loaded
    3_UtilityFunction.Wait And Assert Element Visible    ${LOGIN_FORM}
    3_UtilityFunction.Wait And Assert Element Visible    ${LOGIN_EMAIL_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${LOGIN_PASSWORD_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${LOGIN_SUBMIT_BUTTON}

Enter Email
    [Documentation]    Enter email in login form
    [Arguments]    ${email}
    1_BasePage.Wait And Input Text    ${LOGIN_EMAIL_FIELD}    ${email}

Enter Password
    [Documentation]    Enter password in login form
    [Arguments]    ${password}
    1_BasePage.Wait And Input Text    ${LOGIN_PASSWORD_FIELD}    ${password}

Click Login Button
    [Documentation]    Click login submit button
    1_CommonWeb.Wait For Element And Click    ${LOGIN_SUBMIT_BUTTON}

Check Remember Me
    [Documentation]    Check remember me checkbox
    1_CommonWeb.Wait For Element And Click    ${REMEMBER_ME_CHECKBOX}

Click Forgot Password Link
    [Documentation]    Click forgot password link
    1_CommonWeb.Wait For Element And Click    ${FORGOT_PASSWORD_LINK}

Verify Login Error Message
    [Documentation]    Verify error message is displayed
    [Arguments]    ${expected_error}
    3_UtilityFunction.Wait And Assert Element Visible    ${ERROR_MESSAGE}
    3_UtilityFunction.Assert Element Contains Text    ${ERROR_MESSAGE}    ${expected_error}

Verify Login Success
    [Documentation]    Verify login was successful
    3_UtilityFunction.Verify Current URL Contains    https://demowebshop.tricentis.com/

Clear Login Form
    [Documentation]    Clear all fields in login form
    Clear Element Text    ${LOGIN_EMAIL_FIELD}
    Clear Element Text    ${LOGIN_PASSWORD_FIELD}

Get Login Form Validation Messages
    [Documentation]    Get all validation messages from login form
    ${messages}=    Create List
    ${error_elements}=    Get WebElements    xpath=//div[@class='validation-summary-errors']//span | //div[@class='validation-summary-errors']//li
    FOR    ${element}    IN    @{error_elements}
        ${text}=    Get Text    ${element}
        Append To List    ${messages}    ${text}
    END
    RETURN    ${messages}

# Key verify error message
Verify Remember Me Checkbox
    [Documentation]    Verify remember me checkbox functionality
    Element Should Be Visible    ${REMEMBER_ME_CHECKBOX}
    Element Should Not Be Selected    ${REMEMBER_ME_CHECKBOX}

Toggle Remember Me
    [Documentation]    Toggle remember me checkbox
    Click Element    ${REMEMBER_ME_CHECKBOX}

Verify Validation Error For Field
    [Documentation]    Verify validation error for specific field
    [Arguments]    ${field_name}    ${expected_message}
    ${field_error_locator}=    Set Variable If    '${field_name}' == 'email'    ${EMAIL_VALIDATION_ERROR}    ${PASSWORD_VALIDATION_ERROR}
    3_UtilityFunction.Wait And Assert Element Visible    ${field_error_locator}
    3_UtilityFunction.Assert Element Contains Text    ${field_error_locator}    ${expected_message}

Get All Error Messages
    [Documentation]    Get all error messages displayed on login page
    ${error_messages}=    Create List
    ${error_elements}=    Get WebElements    xpath=//div[contains(@class,'validation')]//span | //div[contains(@class,'error')]
    FOR    ${element}    IN    @{error_elements}
        ${text}=    Get Text    ${element}
        Run Keyword If    '${text}' != ''    Append To List    ${error_messages}    ${text}
    END
    RETURN    ${error_messages}