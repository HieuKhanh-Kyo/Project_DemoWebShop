*** Settings ***
Documentation       Script Test Login Website

Library             SeleniumLibrary

Resource            ../../Resources/PageObject/Customer/2_LoginPage.robot
Resource            ../../Resources/Keywords/Customer/1_Authentication.robot

Suite Setup         1_CommonWeb.Open Application
Suite Teardown      1_CommonWeb.Close Application

# run script: robot -d Results TestCases/Authentication/2_TestLogin.robot

*** Test Cases ***
# 1. Invalid login
TC-001 - Valid Login Success
    [Documentation]    Test successful login with valid credentials
    [Tags]    TC-001    smoke    login    positive

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc001_login_page_loaded

    # Step 2: Enter valid credentials and submit
    1_Authentication.Login With Valid Credentials
    3_UtilityFunction.Take Screenshot With Custom Name    tc001_successful_login

    # Step 3: Verrify redirect to expected page
    2_LoginPage.Verify Login Success

    Log    Login test completed successfully

TC-002 - Invalid Email Login
    [Documentation]    Test login with invalid email address
    [Tags]    TC-002    login    negative

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc002_login_page_loaded

    # Step 2: Enter invalid email and valid password, submit form
    1_Authentication.Login With Invalid Credentials    invalid@test.com    ${VALID_PASSWORD}    Login was unsuccessful
    3_UtilityFunction.Take Screenshot With Custom Name    tc002_invalid_email_error

    # Step 3: Verify error message is displayed and login is unsuccessful
    Element Should Be Visible    ${ERROR_MESSAGE}

    Log    Invalid email login test completed successfully

TC-003 - Invalid Password Login
    [Documentation]    Test login with invalid password
    [Tags]    TC-003    login    negative

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc003_login_page_loaded

    # Step 2: Enter valid email and invalid password, submit form
    1_Authentication.Login With Invalid Credentials    ${VALID_EMAIL}    wrongpassword    Login was unsuccessful
    3_UtilityFunction.Take Screenshot With Custom Name    tc003_invalid_password_error

    # Step 3: Verify error message is displayed and login is unsuccessful
    Element Should Be Visible    ${ERROR_MESSAGE}

    Log    Invalid password login test completed successfully

TC-004 - Invalid Email and Password Login
    [Documentation]    Test login with both invalid email and password
    [Tags]    TC-004    login    negative

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc004_login_page_loaded

    # Step 2: Enter invalid email and invalid password, submit form
    1_Authentication.Login With Invalid Credentials    invalid@test.com    wrongpassword    Login was unsuccessful
    3_UtilityFunction.Take Screenshot With Custom Name    tc004_invalid_credentials_error

    # Step 3: Verify error message is displayed and login is unsuccessful
    Element Should Be Visible    ${ERROR_MESSAGE}

    Log    Invalid credentials login test completed successfully

# Empty Field Validation
TC-005 - Empty Email Field
    [Documentation]    Test login with empty email field validation
    [Tags]    TC-005    login    validation    negative

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc005_login_page_loaded

    # Step 2: Enter valid password only, leave email empty and submit form
    2_LoginPage.Enter Email    ${EMPTY}
    2_LoginPage.Enter Password    ${VALID_PASSWORD}
    2_LoginPage.Click Login Button
    3_UtilityFunction.Take Screenshot With Custom Name    tc005_empty_email_validation

    # Step 3: Verify validation error message for empty email field
    2_LoginPage.Verify Login Error Message    Login was unsuccessful

    Log    Empty email field validation test completed successfully

TC-006 - Empty Password Field
    [Documentation]    Test login with empty password field validation
    [Tags]    TC-006    login    validation    negative

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc006_login_page_loaded

    # Step 2: Enter valid email only, leave password empty and submit form
    2_LoginPage.Enter Email    ${VALID_EMAIL}
    2_LoginPage.Enter Password    ${EMPTY}
    2_LoginPage.Click Login Button
    3_UtilityFunction.Take Screenshot With Custom Name    tc006_empty_password_validation

    # Step 3: Verify validation error message for empty password field
    2_LoginPage.Verify Login Error Message    Login was unsuccessful

    Log    Empty password field validation test completed successfully

TC-007 - Empty Email and Password Fields
    [Documentation]    Test login with both email and password fields empty
    [Tags]    TC-007    login    validation    negative

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc007_login_page_loaded

    # Step 2: Submit form with both fields empty
    1_Authentication.Login With Empty Fields
    3_UtilityFunction.Take Screenshot With Custom Name    tc007_empty_fields_validation

    # Step 3: Verify validation error messages appear for both required fields
    ${validation_messages}=    2_LoginPage.Get Login Form Validation Messages
    Should Not Be Empty    ${validation_messages}

    Log    Empty fields validation test completed successfully

# 3. Forgot Password Functionality
TC-008 - Forgot Password Link Navigation
    [Documentation]    Test forgot password link functionality and navigation
    [Tags]    TC-008    login    forgot-password

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc008_login_page_loaded

    # Step 2: Click on forgot password link
    2_LoginPage.Click Forgot Password Link
    3_UtilityFunction.Take Screenshot With Custom Name    tc008_forgot_password_clicked

    # Step 3: Verify navigation to password recovery page
    3_UtilityFunction.Verify Current URL Contains    passwordrecovery
    1_CommonWeb.Verify Page Title Contains    Password Recovery

    Log    Forgot password link navigation test completed successfully

TC-009 - Password Recovery Flow
    [Documentation]    Test complete password recovery functionality
    [Tags]    TC-009    login    forgot-password

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc009_login_page_loaded

    # Step 2: Initiate password recovery flow
    1_Authentication.Test Password Reset Flow
    3_UtilityFunction.Take Screenshot With Custom Name    tc009_password_recovery_flow

    # Step 3: Verify password recovery page is loaded and functional
    3_UtilityFunction.Verify Current URL Contains    passwordrecovery

    Log    Password recovery flow test completed successfully

# 4. Remember Me Functionality
TC-010 - Remember Me Checkbox Functionality
    [Documentation]    Test remember me checkbox basic functionality
    [Tags]    TC-010    login    remember-me

    # Step 1: Navigate to login page and verify checkbox exists
    1_Authentication.Navigate To Login Page
    Element Should Be Visible    ${REMEMBER_ME_CHECKBOX}
    Checkbox Should Not Be Selected    ${REMEMBER_ME_CHECKBOX}
    3_UtilityFunction.Take Screenshot With Custom Name    tc010_checkbox_unchecked

    # Step 2: Check remember me and login
    Select Checkbox    ${REMEMBER_ME_CHECKBOX}
    Checkbox Should Be Selected    ${REMEMBER_ME_CHECKBOX}
    3_UtilityFunction.Take Screenshot With Custom Name    tc010_checkbox_checked
    1_Authentication.Login With Valid Credentials

    # Step 3: Verify login successful with remember me
    2_LoginPage.Verify Login Success
    3_UtilityFunction.Take Screenshot With Custom Name    tc010_login_success

    # Step 4: Logout and navigate back to login to check if credentials are remembered
    1_Authentication.Logout User
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc010_back_to_login

    # Step 5: Verify credentials are pre-filled
    ${email_value}=    Get Value    ${LOGIN_EMAIL_FIELD}
    Should Be Equal    ${email_value}    ${VALID_EMAIL}    Email should be remembered
    Log    SUCCESS: Email is pre-filled with: ${email_value}
    3_UtilityFunction.Take Screenshot With Custom Name    tc010_credentials_remembered

    Log    Remember me checkbox functionality test completed successfully

# 5. Error Message Validation
TC-011 - Error Message Display and Content
    [Documentation]    Test error message display and content accuracy
    [Tags]    TC-011    login    error-messages
    1_Authentication.Navigate To Login Page

    # Test different error scenarios
    1_Authentication.Login With Invalid Credentials    invalid@email.com    wrongpass    Login was unsuccessful
    Element Should Be Visible    ${ERROR_MESSAGE}

    # Clear form and test another scenario
    2_LoginPage.Clear Login Form
    1_Authentication.Login With Invalid Credentials    ${VALID_EMAIL}    short    Login was unsuccessful
    3_UtilityFunction.Take Screenshot With Custom Name    tc-011_error_message_validation