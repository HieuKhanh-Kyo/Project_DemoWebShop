*** Settings ***
Resource   ../../Keywords/Common/imports.robot

*** Variables ***
${FOOTER_INFORMATION}           xpath=//div[@class='column information']
${FOOTER_CUSTOMER_SERVICE}      xpath=//div[@class='column customer-service']
${FOOTER_MY_ACCOUNT}            xpath=//div[@class='column my-account']
${FOOTER_FOLLOW_US}             xpath=//div[@class='column follow-us']

*** Keywords ***
Verify Footer Links
    Wait Until Element Is Visible    ${FOOTER_INFORMATION}
    Wait Until Element Is Visible    ${FOOTER_CUSTOMER_SERVICE}
    Wait Until Element Is Visible    ${FOOTER_MY_ACCOUNT}
    Wait Until Element Is Visible    ${FOOTER_FOLLOW_US}

Click Information
    1_CommonWeb.Wait For Element And Click    ${FOOTER_INFORMATION}

Click Customer Service
    1_CommonWeb.Wait For Element And Click    ${FOOTER_CUSTOMER_SERVICE}

Click My Account
    1_CommonWeb.Wait For Element And Click    ${FOOTER_MY_ACCOUNT}

Click Follow Us
    1_CommonWeb.Wait For Element And Click    ${FOOTER_FOLLOW_US}