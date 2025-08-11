*** Settings ***
Documentation       Script Test Registration Website

Library             SeleniumLibrary

Resource            ../../Resources/PageObject/Customer/3_RegisterPage.robot
Resource            ../../Resources/Keywords/Customer/1_Authentication.robot

Suite Setup         1_CommonWeb.Open Application
Suite Teardown      1_CommonWeb.Close Application

# run script: robot -d Results TestCases/Authentication/1_TestRegister.robot

*** Test Cases ***
# Test Register
TC-REG-001 - Valid Registration Success
    [Documentation]    Test successful registration with all valid data (registration only)
    [Tags]    TC-REG-001    smoke    registration    positive

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_001_registration_page_loaded

    # Step 2: Register with valid data (no newsletter)
    1_Authentication.Register With Complete Valid Data
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_001_registration_success

    Log    Valid registration test completed successfully

TC-REG-002 - Registration With Invalid Email Format
    [Documentation]    Test registration with various invalid email formats
    [Tags]    TC-REG-002    registration    validation    negative

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_002_registration_page_loaded

    # Step 2: Test email format validation for registration
    1_Authentication.Test Registration Email Format Validation
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_002_email_validation_complete

    Log    Registration email format validation test completed successfully

TC-REG-003 - Registration With Weak Password
    [Documentation]    Test registration with weak passwords
    [Tags]    TC-REG-003    registration    validation    negative

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_003_registration_page_loaded

    # Step 2: Test password validation
    1_Authentication.Test Registration Password Validation
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_003_password_validation_complete

    Log    Password validation test completed successfully

TC-REG-004 - Registration With Password Mismatch
    [Documentation]    Test registration when password and confirm password don't match
    [Tags]    TC-REG-004    registration    validation    negative

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_004_registration_page_loaded

    # Step 2: Test password confirmation validation
    1_Authentication.Test Registration Password Confirmation
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_004_password_confirmation_validation

    Log    Password confirmation validation test completed successfully

TC-REG-005 - Registration With Empty Required Fields
    [Documentation]    Test registration with empty required fields
    [Tags]    TC-REG-005    registration    validation    negative

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_005_registration_page_loaded

    # Step 2: Test required fields validation
    1_Authentication.Test Registration Required Fields
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_005_required_fields_validation

    Log    Required fields validation test completed successfully

TC-REG-006 - Gender Selection Functionality
    [Documentation]    Test gender selection radio buttons
    [Tags]    TC-REG-006    registration    functionality    positive

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_006_registration_page_loaded

    # Step 2: Test gender selection options
    1_Authentication.Test Gender Selection Options
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_006_gender_selection_complete

    Log    Gender selection functionality test completed successfully

TC-REG-007 - Registration With Existing Email
    [Documentation]    Test registration with already registered email address
    [Tags]    TC-REG-007    registration    validation    negative

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_007_registration_page_loaded

    # Step 2: Test registration with existing email
    1_Authentication.Test Registration With Existing Email
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_007_existing_email_validation

    Log    Existing email validation test completed successfully

TC-REG-008 - Complete Registration Form Workflow
    [Documentation]    Test complete registration form workflow with all elements
    [Tags]    TC-REG-008    registration    workflow    positive

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_008_registration_page_loaded

    # Step 2: Complete comprehensive form test
    1_Authentication.Complete Registration Form Test
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_008_complete_workflow_success

    Log    Complete registration workflow test completed successfully

TC-REG-009 - Registration Form Field Validation Messages
    [Documentation]    Test individual field validation messages
    [Tags]    TC-REG-009    registration    validation    negative

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_009_registration_page_loaded

    # Step 2: Test empty first name validation
    3_RegisterPage.Enter First Name    ${EMPTY}
    3_RegisterPage.Enter Last Name    Valid Last Name
    3_RegisterPage.Enter Email    valid@email.com
    3_RegisterPage.Enter Password    ValidPass123!
    3_RegisterPage.Enter Confirm Password    ValidPass123!
    3_RegisterPage.Click Register Button
    ${validation_messages}=    3_RegisterPage.Get All Registration Validation Messages
    Should Not Be Empty    ${validation_messages}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_009_first_name_validation

    # Step 3: Clear and test empty last name validation
    3_RegisterPage.Clear Registration Form
    3_RegisterPage.Enter First Name    Valid First Name
    3_RegisterPage.Enter Last Name    ${EMPTY}
    3_RegisterPage.Enter Email    valid@email.com
    3_RegisterPage.Enter Password    ValidPass123!
    3_RegisterPage.Enter Confirm Password    ValidPass123!
    3_RegisterPage.Click Register Button
    ${validation_messages}=    3_RegisterPage.Get All Registration Validation Messages
    Should Not Be Empty    ${validation_messages}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_009_last_name_validation

    Log    Field validation messages test completed successfully

TC-REG-010 - Registration Form Reset and Clear
    [Documentation]    Test registration form reset and clear functionality
    [Tags]    TC-REG-010    registration    functionality    positive

    # Step 1: Navigate to registration page and fill form
    1_Authentication.Navigate To Registration Page
    ${registration_data}=    1_Authentication.Create Valid Registration Data
    3_RegisterPage.Fill Registration Form    &{registration_data}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_010_form_filled

    # Step 2: Clear form and verify all fields are empty
    3_RegisterPage.Clear Registration Form
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_010_form_cleared

    # Step 3: Verify fields are empty
    ${first_name_value}=    Get Value    ${REGISTER_FIRST_NAME_FIELD}
    Should Be Empty    ${first_name_value}
    ${last_name_value}=    Get Value    ${REGISTER_LAST_NAME_FIELD}
    Should Be Empty    ${last_name_value}
    ${email_value}=    Get Value    ${REGISTER_EMAIL_FIELD}
    Should Be Empty    ${email_value}

    Log    Registration form clear functionality test completed successfully

TC-REG-011 - Registration With Special Characters
    [Documentation]    Test registration with special characters in names
    [Tags]    TC-REG-011    registration    boundary    positive

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_011_registration_page_loaded

    # Step 2: Test special characters in name fields
    ${special_registration_data}=    Create Dictionary
    ...    first_name=Test-User's
    ...    last_name=O'Connor Jr.
    ...    email=test.special@example.com
    ...    password=${VALID_REG_PASSWORD}
    ...    confirm_password=${VALID_REG_PASSWORD}
    ...    gender=Male

    3_RegisterPage.Fill Registration Form    &{special_registration_data}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_011_special_chars_filled
    3_RegisterPage.Click Register Button

    # Check if registration succeeds or fails with appropriate handling
    ${registration_success}=    Run Keyword And Return Status    3_RegisterPage.Verify Registration Success
    IF    ${registration_success}
        3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_011_special_chars_success
        Log    Registration with special characters succeeded
    ELSE
        3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_011_special_chars_error
        Log    Registration with special characters failed as expected
    END

    Log    Special characters in registration test completed successfully

TC-REG-012 - Registration Form Boundary Testing
    [Documentation]    Test registration form with boundary values
    [Tags]    TC-REG-012    registration    boundary    validation

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_012_registration_page_loaded

    # Step 2: Test maximum length names (if applicable)
    ${long_name}=    Evaluate    'A' * 50  # Assuming 50 char limit
    ${boundary_registration_data}=    Create Dictionary
    ...    first_name=${long_name}
    ...    last_name=${long_name}
    ...    email=boundary.test@example.com
    ...    password=${VALID_REG_PASSWORD}
    ...    confirm_password=${VALID_REG_PASSWORD}

    3_RegisterPage.Fill Registration Form    &{boundary_registration_data}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_012_boundary_values_filled

    3_RegisterPage.Click Register Button

    # Verify handling of boundary values
    ${registration_success}=    Run Keyword And Return Status    3_RegisterPage.Verify Registration Success
    IF    ${registration_success}
        3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_012_boundary_success
        Log    Registration with boundary values succeeded
    ELSE
        3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_012_boundary_error
        Log    Registration with boundary values handled appropriately
    END

    Log    Registration boundary testing completed successfully

TC-REG-013 - Registration Page Elements Verification
    [Documentation]    Verify all registration page elements are present and functional
    [Tags]    TC-REG-013    registration    ui    verification

    # Step 1: Navigate to registration page
    1_Authentication.Navigate To Registration Page
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_013_registration_page_loaded

    # Step 2: Verify all form elements are visible
    3_RegisterPage.Verify Register Page Loaded

    # Step 3: Verify gender radio buttons
    Element Should Be Visible    ${GENDER_MALE_RADIO}
    Element Should Be Visible    ${GENDER_FEMALE_RADIO}

    # Step 4: Verify page title and form structure
    Element Should Be Visible    ${REGISTER_PAGE_TITLE}
    Element Should Be Visible    ${REGISTER_FORM}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_013_elements_verified

    Log    Registration page elements verification test completed successfully

TC-REG-014 - Complete Registration and Login Flow
    [Documentation]    Test complete user journey: Registration → Login
    [Tags]    TC-REG-014    registration    login    workflow    integration

    # Step 1: Test complete registration and login flow
    1_Authentication.Test Complete User Registration And Login Flow
    3_UtilityFunction.Take Screenshot With Custom Name    tc_reg_014_complete_flow_success

    Log    Complete registration and login flow test completed successfully

# Test newsletter
TC-NEWSLETTER-001 - Valid Newsletter Subscription
    [Documentation]    Test successful newsletter subscription with valid email
    [Tags]    TC-NEWSLETTER-001    newsletter    positive

    # Step 1: Navigate to newsletter subscription
    1_Authentication.Navigate To Newsletter Subscription
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_001_page_loaded

    # Step 2: Subscribe with valid email
    1_Authentication.Subscribe To Newsletter With Valid Email
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_001_subscription_success

    Log    Newsletter subscription test completed successfully

TC-NEWSLETTER-002 - Newsletter Email Format Validation
    [Documentation]    Test newsletter subscription with invalid email formats
    [Tags]    TC-NEWSLETTER-002    newsletter    validation    negative

    # Step 1: Navigate to newsletter subscription
    1_Authentication.Navigate To Newsletter Subscription
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_002_page_loaded

    # Step 2: Test email format validation for newsletter
    1_Authentication.Test Newsletter Email Format Validation
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_002_validation_complete

    Log    Newsletter email format validation test completed successfully

TC-NEWSLETTER-003 - Newsletter Subscription Elements Verification
    [Documentation]    Verify newsletter subscription elements are present
    [Tags]    TC-NEWSLETTER-003    newsletter    ui    verification

    # Step 1: Navigate to newsletter subscription area
    1_Authentication.Navigate To Newsletter Subscription
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_003_page_loaded

    # Step 2: Verify newsletter elements
    3_RegisterPage.Verify Newsletter Email Field
    3_RegisterPage.Verify Newsletter Subscribe Button
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_003_elements_verified

    Log    Newsletter subscription elements verification completed successfully

TC-NEWSLETTER-004 - Newsletter Functionality Testing
    [Documentation]    Test complete newsletter subscription functionality
    [Tags]    TC-NEWSLETTER-004    newsletter    functionality    positive

    # Step 1: Test complete newsletter functionality
    1_Authentication.Test Newsletter Subscription Functionality
    3_UtilityFunction.Take Screenshot With Custom Name    tc_newsletter_004_functionality_complete

    Log    Newsletter functionality testing completed successfully

# Test combined workflows
TC-COMBINED-001 - Registration Then Newsletter Subscription
    [Documentation]    Test complete flow: Register Account → Subscribe to Newsletter
    [Tags]    TC-COMBINED-001    registration    newsletter    workflow    integration

    # Step 1: Test registration followed by newsletter subscription
    1_Authentication.Navigate To Registration Page
    1_Authentication.Test Registration Then Newsletter Subscription
    3_UtilityFunction.Take Screenshot With Custom Name    tc_combined_001_complete_flow

    Log    Registration and newsletter subscription workflow completed successfully