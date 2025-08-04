*** Settings ***

Resource    ../Common/imports.robot
Resource    ../../PageObject/Customer/imports.robot

*** Variables ***
${VALID_EMAIL}          testuser@gmail.com
${VALID_PASSWORD}       Test123!
${INVALID_EMAIL}        invalid@gmail.com
${INVALID_PASSWORD}     wrongpass

*** Keywords ***
Login With Valid Credentials
    [Documentation]    Login with valid email and password
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Verify Login Page Loaded
    Enter Email    ${email}
    Enter Password    ${password}
    Click Login Button
    Verify Login Success

Login With Invalid Credentials
    [Documentation]    Login with invalid credentials
    [Arguments]    ${email}    ${password}    ${expected_error}
    Verify Login Page Loaded
    Enter Email    ${email}
    Enter Password    ${password}
    Click Login Button
    Verify Login Error Message    ${expected_error}

Login With Empty Fields
    [Documentation]    Attempt login with empty fields
    Verify Login Page Loaded
    Clear Login Form
    Click Login Button
    ${validation_messages}=    Get Login Form Validation Messages
    Should Not Be Empty    ${validation_messages}

Login With Random Credentials
    [Documentation]    Login with randomly generated credentials
    ${random_email}=    Generate Random Email
    ${random_password}=    Generate Random String    10
    Login With Invalid Credentials    ${random_email}    ${random_password}    Invalid credentials

Logout User
    [Documentation]    Logout current user
    Wait For Element And Click    ${HEADER_LOGOUT_LINK}
    # Verify redirect to login page or home page
    Wait For Page To Load

Navigate To Login Page
    [Documentation]    Navigate to login page from any page
    Go To    ${URL}/login
    Wait For Page To Load
    Verify Login Page Loaded

Verify User Is Logged In
    [Documentation]    Verify user is currently logged in
    # Check for logout button or user menu
    Wait And Assert Element Visible    ${HEADER_LOGOUT_LINK}

Verify User Is Logged Out
    [Documentation]    Verify user is logged out
    # Should see login form or login link
    Wait And Assert Element Visible    ${LOGIN_FORM}

Login And Remember Me
    [Documentation]    Login with remember me checked
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Verify Login Page Loaded
    Enter Email    ${email}
    Enter Password    ${password}
    Check Remember Me
    Click Login Button
    Verify Login Success

Test Password Reset Flow
    [Documentation]    Test forgot password functionality
    Verify Login Page Loaded
    Click Forgot Password Link
    # Add verification for password reset page
    Wait For Page To Load
    Verify Current URL Contains    forgot-password

# Login Validation Test Keywords
Test Email Field Validation
    [Documentation]    Test email field validation
    Verify Login Page Loaded

    # Test empty email
    Enter Email    ${EMPTY}
    Enter Password    ${VALID_PASSWORD}
    Click Login Button
    Verify Login Error Message    Email is required

    # Test invalid email format
    Clear Login Form
    Enter Email    invalid-email
    Enter Password    ${VALID_PASSWORD}
    Click Login Button
    Verify Login Error Message    Invalid email format

Test Password Field Validation
    [Documentation]    Test password field validation
    Verify Login Page Loaded

    # Test empty password
    Enter Email    ${VALID_EMAIL}
    Enter Password    ${EMPTY}
    Click Login Button
    Verify Login Error Message    Password is required

    # Test short password
    Clear Login Form
    Enter Email    ${VALID_EMAIL}
    Enter Password    123
    Click Login Button
    Verify Login Error Message    Password too short

# Session Management Keywords
Verify Session Timeout
    [Documentation]    Test session timeout functionality
    Login With Valid Credentials
    # Wait for session timeout or simulate
    Sleep    ${TIMEOUT}
    Refresh Page
    Verify User Is Logged Out

Test Multiple Login Attempts
    [Documentation]    Test account lockout after multiple failed attempts
    FOR    ${i}    IN RANGE    1    6
        Login With Invalid Credentials    ${VALID_EMAIL}    wrongpassword    Invalid credentials
        Sleep    1s
    END
    # After 5 attempts, should show account locked message
    Login With Invalid Credentials    ${VALID_EMAIL}    wrongpassword    Account temporarily locked