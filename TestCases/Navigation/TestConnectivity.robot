*** Settings ***
Documentation       Script Test Connect To Website

Resource    ../../Resources/Keywords/Common/imports.robot
Resource    ../../Resources/Keywords/Customer/imports.robot
Resource    ../../Resources/PageObject/Common/imports.robot
Resource    ../../Resources/PageObject/Customer/imports.robot

Suite Setup         1_CommonWeb.Open Application
Suite Teardown      1_CommonWeb.Close Application

# run script: robot -d Results TestCases/Navigation/TestConnectivity.robot

*** Test Cases ***
Test Website Connectivity
    [Documentation]    Verify we can connect to the website
    [Tags]             TestConnectivity
    1_CommonWeb.Verify Page Title Contains    Demo Web Shop
    2_Header.Verify Header Is Visible

Test Basic Navigation
    [Documentation]    Test basic website navigation
    [Tags]             TestConnectivity
    2_Header.Click Login Link
    1_CommonWeb.Verify Page Title Contains    Login
    2_BrowserNavigation.Go Back Page
    2_Header.Click Register Link
    1_CommonWeb.Verify Page Title Contains    Register

#Test Category Navigation


Manual Login Verification
    [Documentation]    Manual test of login functionality
    [Tags]    manual    login   test

    Navigate To Login Page

    # Test valid login
    Login With Valid Credentials
    Take Screenshot With Custom Name    successful_login

    Logout User

    # Test invalid login
    Navigate To Login Page
    Login With Invalid Credentials    invalid@test.com    wrongpass    Login was unsuccessful
    Take Screenshot With Custom Name    invalid_login
