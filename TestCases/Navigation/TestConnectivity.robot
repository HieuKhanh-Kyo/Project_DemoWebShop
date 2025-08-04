*** Settings ***
Documentation       Script Test Connect To Website

Resource    ../../Resources/Keywords/Common/imports.robot
Resource    ../../Resources/PageObject/Common/imports.robot

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
    2_BrowserNavigation.Go Back
    2_Header.Click Register Link
    1_CommonWeb.Verify Page Title Contains    Register

#Test Category Navigation