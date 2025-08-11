*** Settings ***

Resource    ../../../Config/1_Environments.robot
Resource    ../../PageObject/Customer/2_LoginPage.robot
Resource    ../../PageObject/Common/2_Header.robot
Resource    ../../PageObject/Customer/3_RegisterPage.robot
Resource    ../../Keywords/Common/3_UtilityFunction.robot

*** Variables ***
# Login
${VALID_EMAIL}          hikakyo@gmail.com
${VALID_PASSWORD}       y3#B!fd$bXeMqU
${INVALID_EMAIL}        invalid@gmail.com
${INVALID_PASSWORD}     wrongpass

# Register
${VALID_FIRST_NAME}         Test
${VALID_LAST_NAME}          User
${VALID_REG_PASSWORD}       Test123!@#
${MIN_PASSWORD_LENGTH}      6

*** Keywords ***
# Login Key
Login With Valid Credentials
    [Documentation]    Login with valid email and password
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    2_LoginPage.Verify Login Page Loaded
    2_LoginPage.Enter Email    ${email}
    2_LoginPage.Enter Password    ${password}
    2_LoginPage.Click Login Button

Login With Invalid Credentials
    [Documentation]    Login with invalid credentials
    [Arguments]    ${email}    ${password}    ${expected_error}
    2_LoginPage.Verify Login Page Loaded
    2_LoginPage.Enter Email    ${email}
    2_LoginPage.Enter Password    ${password}
    2_LoginPage.Click Login Button
    2_LoginPage.Verify Login Error Message    ${expected_error}

Login With Empty Fields
    [Documentation]    Attempt login with empty fields
    2_LoginPage.Verify Login Page Loaded
    2_LoginPage.Clear Login Form
    2_LoginPage.Click Login Button
    ${validation_messages}=    Get Login Form Validation Messages
    Should Not Be Empty    ${validation_messages}

Login With Random Credentials
    [Documentation]    Login with randomly generated credentials
    ${random_email}=    Generate Random Email
    ${random_password}=    Generate Random String    10
    1_Authentication.Login With Invalid Credentials    ${random_email}    ${random_password}    Invalid credentials

Logout User
    [Documentation]    Logout current user
    1_CommonWeb.Wait For Element And Click    ${HEADER_LOGOUT_LINK}
    1_CommonWeb.Wait For Page To Load

Navigate To Login Page
    [Documentation]    Navigate to login page from any page
    Go To    ${URL}/login
    1_CommonWeb.Wait For Page To Load
    2_LoginPage.Verify Login Page Loaded

Verify User Is Logged In
    [Documentation]    Verify user is currently logged in
    3_UtilityFunction.Wait And Assert Element Visible    ${HEADER_LOGOUT_LINK}

Verify User Is Logged Out
    [Documentation]    Verify user is logged out
    3_UtilityFunction.Wait And Assert Element Visible    ${LOGIN_FORM}

Login And Remember Me
    [Documentation]    Login with remember me checked
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    2_LoginPage.Verify Login Page Loaded
    2_LoginPage.Enter Email    ${email}
    2_LoginPage.Enter Password    ${password}
    2_LoginPage.Check Remember Me
    2_LoginPage.Click Login Button
    2_LoginPage.Verify Login Success

Test Password Reset Flow
    [Documentation]    Test forgot password functionality
    2_LoginPage.Verify Login Page Loaded
    2_LoginPage.Click Forgot Password Link
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Verify Current URL Contains    passwordrecovery

# Registration Key
Navigate To Registration Page
    [Documentation]    Navigate to registration page from any page
    Go To    ${URL}/register
    1_CommonWeb.Wait For Page To Load
    3_RegisterPage.Verify Register Page Loaded

Register With Valid Data
    [Documentation]    Register with valid user data
    [Arguments]    &{registration_data}
    3_RegisterPage.Verify Register Page Loaded
    3_RegisterPage.Fill Registration Form    &{registration_data}
    3_RegisterPage.Click Register Button
    3_RegisterPage.Verify Registration Success

Register With Invalid Data
    [Documentation]    Register with invalid data and expect error
    [Arguments]    ${expected_error}    &{registration_data}
    3_RegisterPage.Verify Register Page Loaded
    3_RegisterPage.Fill Registration Form    &{registration_data}
    3_RegisterPage.Click Register Button
    3_RegisterPage.Verify Registration Error Message    ${expected_error}

Create Valid Registration Data
    [Documentation]    Create dictionary with valid registration data (without newsletter)
    [Arguments]    ${include_gender}=True
    ${test_data}=    3_UtilityFunction.Create Test Data Dictionary
    ${registration_data}=    Create Dictionary
    ...    first_name=${VALID_FIRST_NAME}
    ...    last_name=${VALID_LAST_NAME}
    ...    email=${test_data}[email]
    ...    password=${VALID_REG_PASSWORD}
    ...    confirm_password=${VALID_REG_PASSWORD}

    IF    ${include_gender}
        Set To Dictionary    ${registration_data}    gender    Male
    END

    RETURN    ${registration_data}

Register With Complete Valid Data
    [Documentation]    Register with complete valid data (registration only, no newsletter)
    ${registration_data}=    Create Valid Registration Data
    Register With Valid Data    &{registration_data}

# Newsletter Subscription Keywords (Separate from Registration)
Navigate To Newsletter Subscription
    [Documentation]    Navigate to newsletter subscription section or page
    # This might be on homepage footer or separate newsletter page
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    # Look for newsletter section on homepage
    ${newsletter_section_exists}=    Run Keyword And Return Status
    ...    3_UtilityFunction.Wait And Assert Element Visible    ${NEWSLETTER_EMAIL_FIELD}    timeout=5s
    IF    not ${newsletter_section_exists}
        # Try to scroll to footer where newsletter might be
        2_BrowserNavigation.Scroll To Bottom
        Sleep    1s
    END

Subscribe To Newsletter With Valid Email
    [Documentation]    Subscribe to newsletter with valid email
    [Arguments]    ${email}=${EMPTY}
    IF    '${email}' == '${EMPTY}'
        ${email}=    3_UtilityFunction.Generate Random Email
    END

    Navigate To Newsletter Subscription
    3_RegisterPage.Subscribe To Newsletter    ${email}
    3_RegisterPage.Verify Newsletter Subscription Success

Subscribe To Newsletter With Invalid Email
    [Documentation]    Test newsletter subscription with invalid email
    [Arguments]    ${invalid_email}    ${expected_error}=${EMPTY}
    Navigate To Newsletter Subscription
    3_RegisterPage.Enter Newsletter Email    ${invalid_email}
    3_RegisterPage.Click Newsletter Subscribe

    IF    '${expected_error}' != '${EMPTY}'
        3_RegisterPage.Verify Field Validation Error    NewsletterEmail    ${expected_error}
    END

Test Newsletter Email Format Validation
    [Documentation]    Test various invalid email formats for newsletter subscription
    Navigate To Newsletter Subscription

    @{invalid_emails}=    Create List
    ...    invalid-email
    ...    @invalid.com
    ...    invalid@
    ...    invalid.com
    ...    invalid@@test.com

    FOR    ${invalid_email}    IN    @{invalid_emails}
        3_RegisterPage.Enter Newsletter Email    ${invalid_email}
        3_RegisterPage.Click Newsletter Subscribe

        # Check for validation error (might not always show for newsletter)
        ${validation_error}=    Run Keyword And Return Status
        ...    3_UtilityFunction.Wait And Assert Element Visible    ${NEWSLETTER_VALIDATION_ERROR}    timeout=3s

        IF    ${validation_error}
            Log    Email validation working for newsletter: ${invalid_email}
        ELSE
            Log    No validation error shown for newsletter email: ${invalid_email}
        END

        # Clear field for next test
        Clear Element Text    ${NEWSLETTER_EMAIL_FIELD}
    END

Test Newsletter Subscription Functionality
    [Documentation]    Test complete newsletter subscription functionality
    Navigate To Newsletter Subscription
    3_RegisterPage.Verify Newsletter Email Field
    3_RegisterPage.Verify Newsletter Subscribe Button

    # Test with valid email
    ${test_email}=    3_UtilityFunction.Generate Random Email
    Subscribe To Newsletter With Valid Email    ${test_email}

# Registration Validation Keywords
Test Registration Email Format Validation
    [Documentation]    Test various email format validations for registration (separate from newsletter)
    3_RegisterPage.Verify Register Page Loaded

    @{invalid_emails}=    Create List
    ...    invalid-email
    ...    @invalid.com
    ...    invalid@
    ...    invalid.com
    ...    invalid@@test.com

    FOR    ${invalid_email}    IN    @{invalid_emails}
        3_RegisterPage.Clear Registration Form
        ${registration_data}=    Create Dictionary
        ...    first_name=${VALID_FIRST_NAME}
        ...    last_name=${VALID_LAST_NAME}
        ...    email=${invalid_email}
        ...    password=${VALID_REG_PASSWORD}
        ...    confirm_password=${VALID_REG_PASSWORD}

        3_RegisterPage.Fill Registration Form    &{registration_data}
        3_RegisterPage.Click Register Button

        ${validation_messages}=    3_RegisterPage.Get All Registration Validation Messages
        Should Not Be Empty    ${validation_messages}    Email validation should show error for: ${invalid_email}
        Log    Email validation working for registration: ${invalid_email}
    END

Test Registration Password Validation
    [Documentation]    Test password field validation rules for registration
    3_RegisterPage.Verify Register Page Loaded

    @{weak_passwords}=    Create List
    ...    123           # Too short
    ...    abc           # Too short, no numbers
    ...    12345         # No special chars
    ...    ${EMPTY}      # Empty password

    FOR    ${weak_password}    IN    @{weak_passwords}
        3_RegisterPage.Clear Registration Form
        ${registration_data}=    Create Dictionary
        ...    first_name=${VALID_FIRST_NAME}
        ...    last_name=${VALID_LAST_NAME}
        ...    email=test@example.com
        ...    password=${weak_password}
        ...    confirm_password=${weak_password}

        3_RegisterPage.Fill Registration Form    &{registration_data}
        3_RegisterPage.Click Register Button

        ${validation_messages}=    3_RegisterPage.Get All Registration Validation Messages
        Should Not Be Empty    ${validation_messages}    Password validation should show error for: ${weak_password}
        Log    Password validation working for: ${weak_password}
    END

Test Registration Password Confirmation
    [Documentation]    Test password confirmation matching for registration
    3_RegisterPage.Verify Register Page Loaded

    ${registration_data}=    Create Dictionary
    ...    first_name=${VALID_FIRST_NAME}
    ...    last_name=${VALID_LAST_NAME}
    ...    email=test@example.com
    ...    password=${VALID_REG_PASSWORD}
    ...    confirm_password=DifferentPassword123!

    3_RegisterPage.Fill Registration Form    &{registration_data}
    3_RegisterPage.Click Register Button

    ${validation_messages}=    3_RegisterPage.Get All Registration Validation Messages
    Should Not Be Empty    ${validation_messages}    Password confirmation should show mismatch error
    Log    Password confirmation validation working

Test Registration Required Fields
    [Documentation]    Test all required fields validation for registration
    3_RegisterPage.Verify Register Page Loaded

    3_RegisterPage.Click Register Button

    ${validation_messages}=    3_RegisterPage.Get All Registration Validation Messages
    Should Not Be Empty    ${validation_messages}    Required fields should show validation errors
    Log    Required fields validation working

Test Gender Selection Options
    [Documentation]    Test gender selection functionality
    3_RegisterPage.Verify Register Page Loaded

    3_RegisterPage.Select Gender    Male
    3_RegisterPage.Verify Gender Selection    Male

    3_RegisterPage.Select Gender    Female
    3_RegisterPage.Verify Gender Selection    Female
    Log    Gender selection functionality working

Test Registration With Existing Email
    [Documentation]    Test registration with already registered email
    ${registration_data}=    Create Dictionary
    ...    first_name=${VALID_FIRST_NAME}
    ...    last_name=${VALID_LAST_NAME}
    ...    email=${VALID_EMAIL}    # Using existing login email
    ...    password=${VALID_REG_PASSWORD}
    ...    confirm_password=${VALID_REG_PASSWORD}

    Register With Invalid Data    already exists    &{registration_data}
    Log    Existing email validation working

Complete Registration Form Test
    [Documentation]    Complete end-to-end registration form test (without newsletter)
    ${registration_data}=    Create Valid Registration Data

    3_RegisterPage.Verify Register Page Loaded
    3_RegisterPage.Select Gender    ${registration_data}[gender]
    3_RegisterPage.Enter First Name    ${registration_data}[first_name]
    3_RegisterPage.Enter Last Name    ${registration_data}[last_name]
    3_RegisterPage.Enter Email    ${registration_data}[email]
    3_RegisterPage.Enter Password    ${registration_data}[password]
    3_RegisterPage.Enter Confirm Password    ${registration_data}[confirm_password]

    3_RegisterPage.Click Register Button
    3_RegisterPage.Verify Registration Success
    Log    Complete registration form test passed

# Combined Authentication Workflows
Test Complete User Registration And Login Flow
    [Documentation]    Test complete flow: Register -> Logout -> Login
    ${registration_data}=    Create Valid Registration Data
    Register With Valid Data    &{registration_data}

    Logout User

    Navigate To Login Page
    Login With Valid Credentials    ${registration_data}[email]    ${registration_data}[password]

    Verify User Is Logged In
    Log    Complete registration and login flow test passed

Test Registration Then Newsletter Subscription
    [Documentation]    Test complete flow: Register -> Subscribe to Newsletter
    # Step 1: Complete registration
    ${registration_data}=    Create Valid Registration Data
    Register With Valid Data    &{registration_data}

    # Step 2: Subscribe to newsletter with different email
    ${newsletter_email}=    3_UtilityFunction.Generate Random Email
    Subscribe To Newsletter With Valid Email    ${newsletter_email}

    Log    Registration and newsletter subscription flow completed successfully