*** Settings ***
Resource    ../Common/imports.robot
Resource    ../../Keywords/Customer/imports.robot

*** Variables ***
# Login Page Locators
${LOGIN_EMAIL_FIELD}       id=Email
${LOGIN_PASSWORD_FIELD}    id=Password
${LOGIN_SUBMIT_BUTTON}     xpath=//input[@class='button-1 login-button']
${LOGIN_FORM}              xpath=//div[@class='form-fields']
${REMEMBER_ME_CHECKBOX}    id=RememberMe
${FORGOT_PASSWORD_LINK}    xpath=//span[@class='forgot-password']

${ERROR_MESSAGE}           xpath=//div[@class='message-error']

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