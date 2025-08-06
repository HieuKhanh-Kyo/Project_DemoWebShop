*** Settings ***

Resource    ../Common/imports.robot
Resource    ../../PageObject/Customer/imports.robot

*** Variables ***
${VALID_EMAIL}          hikakyo@gmail.com
${VALID_PASSWORD}       y3#B!fd$bXeMqU
${INVALID_EMAIL}        invalid@gmail.com
${INVALID_PASSWORD}     wrongpass

*** Keywords ***
Login With Valid Credentials
    [Documentation]    Login with valid email and password
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    2_LoginPage.Verify Login Page Loaded
    2_LoginPage.Enter Email    ${email}
    2_LoginPage.Enter Password    ${password}
    2_LoginPage.Click Login Button
#    2_LoginPage.Verify Login Success

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
    # Verify redirect to login page or home page
    1_CommonWeb.Wait For Page To Load

Navigate To Login Page
    [Documentation]    Navigate to login page from any page
    Go To    ${URL}/login
    1_CommonWeb.Wait For Page To Load
    2_LoginPage.Verify Login Page Loaded

Verify User Is Logged In
    [Documentation]    Verify user is currently logged in
    # Check for logout button or user menu
    3_UtilityFunction.Wait And Assert Element Visible    ${HEADER_LOGOUT_LINK}

Verify User Is Logged Out
    [Documentation]    Verify user is logged out
    # Should see login form or login link
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
    # Add verification for password reset page
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Verify Current URL Contains    passwordrecovery

# Login Validation Test Keywords
Test Email Field Validation
    [Documentation]    Test email field validation
    2_LoginPage.Verify Login Page Loaded

    # Test empty email
    2_LoginPage.Enter Email    ${EMPTY}
    2_LoginPage.Enter Password    ${VALID_PASSWORD}
    2_LoginPage.Click Login Button
    2_LoginPage.Verify Login Error Message    Email is required

    # Test invalid email format
    2_LoginPage.Clear Login Form
    2_LoginPage.Enter Email    invalid-email
    2_LoginPage.Enter Password    ${VALID_PASSWORD}
    2_LoginPage.Click Login Button
    2_LoginPage.Verify Login Error Message    Invalid email format

Test Password Field Validation
    [Documentation]    Test password field validation
    2_LoginPage.Verify Login Page Loaded

    # Test empty password
    2_LoginPage.Enter Email    ${VALID_EMAIL}
    2_LoginPage.Enter Password    ${EMPTY}
    2_LoginPage.Click Login Button
    2_LoginPage.Verify Login Error Message    Password is required

    # Test short password
    2_LoginPage.Clear Login Form
    2_LoginPage.Enter Email    ${VALID_EMAIL}
    2_LoginPage.Enter Password    123
    2_LoginPage.Click Login Button
    2_LoginPage.Verify Login Error Message    Password too short

# Session Management Keywords
Verify Session Timeout
    [Documentation]    Test session timeout functionality
    1_Authentication.Login With Valid Credentials
    # Wait for session timeout or simulate
    Sleep    ${TIMEOUT}
    2_BrowserNavigation.Refresh Page
    1_Authentication.Verify User Is Logged Out

Test Multiple Login Attempts
    [Documentation]    Test account lockout after multiple failed attempts
    FOR    ${i}    IN RANGE    1    6
        1_Authentication.Login With Invalid Credentials    ${VALID_EMAIL}    wrongpassword    Invalid credentials
        Sleep    1s
    END
    # After 5 attempts, should show account locked message
    1_Authentication.Login With Invalid Credentials    ${VALID_EMAIL}    wrongpassword    Account temporarily locked


# Enhaced email password
Test Email Field Validation Enhanced
    [Documentation]    Enhanced email field validation testing
    2_LoginPage.Verify Login Page Loaded

    # Test various invalid email formats
    @{invalid_emails}=    Create List    invalid-email    @invalid.com    invalid@    .com
    FOR    ${invalid_email}    IN    @{invalid_emails}
        2_LoginPage.Clear Login Form
        2_LoginPage.Enter Email    ${invalid_email}
        2_LoginPage.Enter Password    ${VALID_PASSWORD}
        2_LoginPage.Click Login Button
        Element Should Be Visible    ${ERROR_MESSAGE}
        Sleep    1s
    END

Test Password Field Validation Enhanced
    [Documentation]    Enhanced password field validation testing
    2_LoginPage.Verify Login Page Loaded

    # Test various password scenarios
    @{weak_passwords}=    Create List    123    abc    12    ${EMPTY}
    FOR    ${weak_password}    IN    @{weak_passwords}
        2_LoginPage.Clear Login Form
        2_LoginPage.Enter Email    ${VALID_EMAIL}
        2_LoginPage.Enter Password    ${weak_password}
        2_LoginPage.Click Login Button
        Element Should Be Visible    ${ERROR_MESSAGE}
        Sleep    1s
    END

Verify Multiple Login Attempts Handling
    [Documentation]    Test handling of multiple failed login attempts
    FOR    ${attempt}    IN RANGE    1    4
        1_Authentication.Login With Invalid Credentials    ${VALID_EMAIL}    wrongpass    Login was unsuccessful
        Sleep    2s
    END
    # After 3 attempts, check if any rate limiting appears
    3_UtilityFunction.Take Screenshot With Custom Name    multiple_failed_attempts