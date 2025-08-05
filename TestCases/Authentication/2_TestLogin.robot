*** Settings ***
Documentation       Script Test Login Website

Resource    ../../Resources/Keywords/Common/imports.robot
Resource    ../../Resources/Keywords/Customer/imports.robot
Resource    ../../Resources/PageObject/Common/imports.robot
Resource    ../../Resources/PageObject/Customer/imports.robot

Suite Setup         1_CommonWeb.Open Application
Suite Teardown      1_CommonWeb.Close Application

# run script: robot -d Results TestCases/Authentication/2_TestLogin.robot

*** Test Cases ***
TC-001 - Valid Login Success
    [Documentation]    Test successful login with valid credentials
    [Tags]    TC-001    smoke    login    positive

    # Step 1: Navigate to login page
    1_Authentication.Navigate To Login Page
    3_UtilityFunction.Take Screenshot With Custom Name    login_page_loaded

    # Step 2: Enter valid credentials, submit and verrify redirect to dashboard/home
    1_Authentication.Login With Valid Credentials
    3_UtilityFunction.Take Screenshot With Custom Name    successful_login

    # Step 3: Verify redirect to expected page
    2_LoginPage.Verify Login Success

    Log    Login test completed successfully