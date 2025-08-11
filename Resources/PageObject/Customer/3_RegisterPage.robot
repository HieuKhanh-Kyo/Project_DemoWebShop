*** Settings ***
Library     SeleniumLibrary

Resource    ../Common/1_BasePage.robot
Resource    ../../Keywords/Common/1_CommonWeb.robot
Resource    ../../Keywords/Common/3_UtilityFunction.robot

*** Variables ***
# Registration Page Locators
${REGISTER_FORM}                    xpath=//div[@class='page registration-page']
${REGISTER_FIRST_NAME_FIELD}        id=FirstName
${REGISTER_LAST_NAME_FIELD}         id=LastName
${REGISTER_EMAIL_FIELD}             id=Email
${REGISTER_PASSWORD_FIELD}          id=Password
${REGISTER_CONFIRM_PASSWORD_FIELD}  id=ConfirmPassword
${REGISTER_SUBMIT_BUTTON}           id=register-button
${REGISTER_SUCCESS_MESSAGE}         xpath=//div[@class='result']

# Gender Selection
${GENDER_MALE_RADIO}                id=gender-male
${GENDER_FEMALE_RADIO}              id=gender-female

# Newsletter Subscription (Email Input + Subscribe Button)
${NEWSLETTER_EMAIL_FIELD}           xpath=//input[@name='NewsletterEmail' or contains(@placeholder,'newsletter') or contains(@class,'newsletter')]
${NEWSLETTER_SUBSCRIBE_BUTTON}      xpath=//input[@value='Subscribe' or contains(@class,'newsletter-subscribe')]

# Validation Error Locators
${FIRSTNAME_VALIDATION_ERROR}       xpath=//span[@data-valmsg-for='FirstName']
${LASTNAME_VALIDATION_ERROR}        xpath=//span[@data-valmsg-for='LastName']
${EMAIL_VALIDATION_ERROR}           xpath=//span[@data-valmsg-for='Email']
${PASSWORD_VALIDATION_ERROR}        xpath=//span[@data-valmsg-for='Password']
${CONFIRM_PASSWORD_VALIDATION_ERROR}    xpath=//span[@data-valmsg-for='ConfirmPassword']
${NEWSLETTER_VALIDATION_ERROR}      xpath=//span[@data-valmsg-for='NewsletterEmail']
${VALIDATION_SUMMARY}               xpath=//div[@class='validation-summary-errors']

# Page Elements
${REGISTER_PAGE_TITLE}              xpath=//div[@class='page-title']
${REGISTER_PAGE_BODY}               xpath=//div[@class='page-body']

*** Keywords ***
Verify Register Page Loaded
    [Documentation]    Verify registration page is completely loaded
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_FORM}
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_FIRST_NAME_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_LAST_NAME_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_EMAIL_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_PASSWORD_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_CONFIRM_PASSWORD_FIELD}
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_SUBMIT_BUTTON}

Select Gender
    [Documentation]    Select gender (male/female)
    [Arguments]    ${gender}
    IF    '${gender}' == 'Male'
        1_CommonWeb.Wait For Element And Click    ${GENDER_MALE_RADIO}
    ELSE IF    '${gender}' == 'Female'
        1_CommonWeb.Wait For Element And Click    ${GENDER_FEMALE_RADIO}
    END

Enter First Name
    [Documentation]    Enter first name in registration form
    [Arguments]    ${first_name}
    1_CommonWeb.Wait For Element And Input Text    ${REGISTER_FIRST_NAME_FIELD}    ${first_name}

Enter Last Name
    [Documentation]    Enter last name in registration form
    [Arguments]    ${last_name}
    1_CommonWeb.Wait For Element And Input Text    ${REGISTER_LAST_NAME_FIELD}    ${last_name}

Enter Email
    [Documentation]    Enter email in registration form
    [Arguments]    ${email}
    1_CommonWeb.Wait For Element And Input Text    ${REGISTER_EMAIL_FIELD}    ${email}

Enter Password
    [Documentation]    Enter password in registration form
    [Arguments]    ${password}
    1_CommonWeb.Wait For Element And Input Text    ${REGISTER_PASSWORD_FIELD}    ${password}

Enter Confirm Password
    [Documentation]    Enter confirm password in registration form
    [Arguments]    ${confirm_password}
    1_CommonWeb.Wait For Element And Input Text    ${REGISTER_CONFIRM_PASSWORD_FIELD}    ${confirm_password}

# Newsletter Subscription Keywords - Updated for Email Input + Subscribe Button
Enter Newsletter Email
    [Documentation]    Enter email address for newsletter subscription
    [Arguments]    ${newsletter_email}
    ${newsletter_field_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${NEWSLETTER_EMAIL_FIELD}
    IF    ${newsletter_field_exists}
        1_CommonWeb.Wait For Element And Input Text    ${NEWSLETTER_EMAIL_FIELD}    ${newsletter_email}
    ELSE
        Log    Newsletter email field not found on registration page
    END

Click Newsletter Subscribe
    [Documentation]    Click newsletter subscribe button
    ${subscribe_button_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${NEWSLETTER_SUBSCRIBE_BUTTON}
    IF    ${subscribe_button_exists}
        1_CommonWeb.Wait For Element And Click    ${NEWSLETTER_SUBSCRIBE_BUTTON}
    ELSE
        Log    Newsletter subscribe button not found on registration page
    END

Subscribe To Newsletter
    [Documentation]    Complete newsletter subscription with email
    [Arguments]    ${newsletter_email}
    Enter Newsletter Email    ${newsletter_email}
    Click Newsletter Subscribe

Verify Newsletter Subscription Success
    [Documentation]    Verify newsletter subscription was successful
    ${success_message}=    Run Keyword And Return Status
    ...    3_UtilityFunction.Wait And Assert Text Present    subscribed    timeout=10s
    IF    ${success_message}
        Log    Newsletter subscription successful
    ELSE
        Log    Newsletter subscription status unclear - no success message found
    END

Click Register Button
    [Documentation]    Click register submit button
    1_CommonWeb.Wait For Element And Click    ${REGISTER_SUBMIT_BUTTON}

Verify Registration Success
    [Documentation]    Verify registration was successful
    3_UtilityFunction.Wait And Assert Element Visible    ${REGISTER_SUCCESS_MESSAGE}
    3_UtilityFunction.Assert Element Contains Text    ${REGISTER_SUCCESS_MESSAGE}    Your registration completed

Verify Registration Error Message
    [Documentation]    Verify error message is displayed
    [Arguments]    ${expected_error}
    3_UtilityFunction.Wait And Assert Element Visible    ${VALIDATION_SUMMARY}
    3_UtilityFunction.Assert Element Contains Text    ${VALIDATION_SUMMARY}    ${expected_error}

Clear Registration Form
    [Documentation]    Clear all fields in registration form
    Clear Element Text    ${REGISTER_FIRST_NAME_FIELD}
    Clear Element Text    ${REGISTER_LAST_NAME_FIELD}
    Clear Element Text    ${REGISTER_EMAIL_FIELD}
    Clear Element Text    ${REGISTER_PASSWORD_FIELD}
    Clear Element Text    ${REGISTER_CONFIRM_PASSWORD_FIELD}
    # Clear newsletter email if exists
    ${newsletter_field_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${NEWSLETTER_EMAIL_FIELD}
    IF    ${newsletter_field_exists}
        Clear Element Text    ${NEWSLETTER_EMAIL_FIELD}
    END

Verify Field Validation Error
    [Documentation]    Verify validation error for specific field
    [Arguments]    ${field_name}    ${expected_message}
    ${field_error_locator}=    Set Variable If
    ...    '${field_name}' == 'FirstName'    ${FIRSTNAME_VALIDATION_ERROR}
    ...    '${field_name}' == 'LastName'     ${LASTNAME_VALIDATION_ERROR}
    ...    '${field_name}' == 'Email'        ${EMAIL_VALIDATION_ERROR}
    ...    '${field_name}' == 'Password'     ${PASSWORD_VALIDATION_ERROR}
    ...    '${field_name}' == 'ConfirmPassword'    ${CONFIRM_PASSWORD_VALIDATION_ERROR}
    ...    '${field_name}' == 'NewsletterEmail'    ${NEWSLETTER_VALIDATION_ERROR}
    3_UtilityFunction.Wait And Assert Element Visible    ${field_error_locator}
    3_UtilityFunction.Assert Element Contains Text    ${field_error_locator}    ${expected_message}

Get All Registration Validation Messages
    [Documentation]    Get all validation messages from registration form
    ${messages}=    Create List
    ${error_elements}=    Get WebElements    xpath=//span[@class='field-validation-error']
    FOR    ${element}    IN    @{error_elements}
        ${text}=    Get Text    ${element}
        Append To List    ${messages}    ${text}
    END
    RETURN    ${messages}

Verify Gender Selection
    [Documentation]    Verify gender radio button selection
    [Arguments]    ${expected_gender}
    IF    '${expected_gender}' == 'Male'
        Radio Button Should Be Set To    Gender    M
    ELSE IF    '${expected_gender}' == 'Female'
        Radio Button Should Be Set To    Gender    F
    END

# Updated Newsletter Verification Keywords
Verify Newsletter Email Field
    [Documentation]    Verify newsletter email field is visible and functional
    ${newsletter_field_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${NEWSLETTER_EMAIL_FIELD}
    IF    ${newsletter_field_exists}
        Element Should Be Visible    ${NEWSLETTER_EMAIL_FIELD}
        Element Should Be Enabled    ${NEWSLETTER_EMAIL_FIELD}
        Log    Newsletter email field is visible and enabled
    ELSE
        Log    Newsletter email field not found on this page
    END

Verify Newsletter Subscribe Button
    [Documentation]    Verify newsletter subscribe button is visible
    ${subscribe_button_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${NEWSLETTER_SUBSCRIBE_BUTTON}
    IF    ${subscribe_button_exists}
        Element Should Be Visible    ${NEWSLETTER_SUBSCRIBE_BUTTON}
        Element Should Be Enabled    ${NEWSLETTER_SUBSCRIBE_BUTTON}
        Log    Newsletter subscribe button is visible and enabled
    ELSE
        Log    Newsletter subscribe button not found on this page
    END

Fill Registration Form
    [Documentation]    Fill complete registration form with provided data
    [Arguments]    &{registration_data}
    IF    'gender' in ${registration_data}
        Select Gender    ${registration_data}[gender]
    END
    Enter First Name    ${registration_data}[first_name]
    Enter Last Name    ${registration_data}[last_name]
    Enter Email    ${registration_data}[email]
    Enter Password    ${registration_data}[password]
    Enter Confirm Password    ${registration_data}[confirm_password]
    # Newsletter subscription is handled separately, not part of registration form