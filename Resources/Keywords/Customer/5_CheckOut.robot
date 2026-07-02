*** Settings ***
Library    SeleniumLibrary

Resource    ../../PageObject/Customer/7_CheckOutPage.robot
Resource    ../../PageObject/Customer/6_ShoppingCartPage.robot
Resource    ../Common/imports.robot
Resource    ../../../Config/1_Environments.robot

*** Keywords ***
# NAVIGATION
Navigate To Checkout From Cart
    [Documentation]    From cart page: accept ToS and click Checkout button
    6_ShoppingCartPage.Verify Cart Page Loaded
    6_ShoppingCartPage.Verify Cart Has Items
    7_CheckoutPage.Click Checkout From Cart
    7_CheckoutPage.Verify Checkout Page Loaded

# STEP-BY-STEP CHECKOUT FLOW
Complete Billing Step
    [Documentation]    Select New Address, fill form with test data, proceed
    [Arguments]
    ...    ${firstname}=${BILLING_FIRSTNAME_DATA}
    ...    ${lastname}=${BILLING_LASTNAME_DATA}
    ...    ${email}=${BILLING_EMAIL_DATA}
    ...    ${country}=${BILLING_COUNTRY_DATA}
    ...    ${city}=${BILLING_CITY_DATA}
    ...    ${address}=${BILLING_ADDRESS1_DATA}
    ...    ${zip}=${BILLING_ZIP_DATA}
    ...    ${phone}=${BILLING_PHONE_DATA}
    7_CheckoutPage.Verify Billing Step Active
    7_CheckoutPage.Select New Address Option
    7_CheckoutPage.Fill Billing Address Form
    ...    ${firstname}    ${lastname}    ${email}
    ...    ${country}    ${city}    ${address}    ${zip}    ${phone}
    7_CheckoutPage.Click Billing Continue

Complete Shipping Step
    [Documentation]    Proceed through shipping address step
    7_CheckoutPage.Verify Shipping Step Active
    7_CheckoutPage.Click Shipping Continue

Complete Shipping Method Step
    [Documentation]    Select shipping method from Variable and proceed
    [Arguments]    ${method}=${SHIPPING_METHOD_DATA}
    7_CheckoutPage.Verify Shipping Method Step Active
    7_CheckoutPage.Select Shipping Method    ${method}
    7_CheckoutPage.Click Shipping Method Continue

Complete Payment Method Step
    [Documentation]    Select payment method from Variable and proceed
    [Arguments]    ${method}=${PAYMENT_METHOD_DATA}
    7_CheckoutPage.Verify Payment Method Step Active
    7_CheckoutPage.Select Payment Method    ${method}
    7_CheckoutPage.Click Payment Method Continue

Complete Payment Info Step
    [Documentation]    Fill payment info based on selected method and proceed
    [Arguments]    ${method}=${PAYMENT_METHOD_DATA}
    7_CheckoutPage.Verify Payment Info Step Active
    7_CheckoutPage.Fill Payment Info    ${method}
    7_CheckoutPage.Click Payment Info Continue

Confirm And Place Order
    [Documentation]    Verify confirm step and place order
    7_CheckoutPage.Verify Confirm Order Step Active
    7_CheckoutPage.Click Confirm Order

# COMPLETE CHECKOUT WORKFLOW
Complete Full Checkout Flow
    [Documentation]    Complete entire checkout flow
    ...    All steps driven by Variables in checkout_data.robot
    ...    Returns order number after successful placement
    Complete Billing Step
    Complete Shipping Step
    Complete Shipping Method Step
    Complete Payment Method Step
    Complete Payment Info Step
    Confirm And Place Order
    ${order_number}=    7_CheckoutPage.Verify Order Completed Successfully
    RETURN    ${order_number}

Proceed To Checkout And Complete Order
    [Documentation]    Full workflow: from cart page to order completed
    ...    Pre-condition: user logged in, cart has items
    Navigate To Checkout From Cart
    ${order_number}=    Complete Full Checkout Flow
    Log    Checkout completed! Order number: ${order_number}
    RETURN    ${order_number}
