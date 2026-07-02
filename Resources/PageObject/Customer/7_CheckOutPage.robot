*** Settings ***
Library    SeleniumLibrary

Resource    ../../Keywords/Common/imports.robot
Resource    ../../Variables/CheckOut_Data.robot

*** Variables ***
# CART PAGE - Pre-checkout
${TERMS_OF_SERVICE_CHECKBOX}            id=termsofservice
${TERMS_WARNING_BOX}                    id=terms-of-service-warning-box
${CART_CHECKOUT_BUTTON}                 id=checkout

# CHECKOUT PAGE - General
${CHECKOUT_PAGE_CONTAINER}              xpath=//div[@class='page checkout-page']
${CHECKOUT_STEPS}                       id=checkout-steps

# STEP 1 - Billing Address
${BILLING_STEP_CONTENT}                 id=checkout-step-billing
${BILLING_ADDRESS_SELECT}               id=billing-address-select
${BILLING_NEW_ADDRESS_FORM}             id=billing-new-address-form

${BILLING_FIRSTNAME}                    id=BillingNewAddress_FirstName
${BILLING_LASTNAME}                     id=BillingNewAddress_LastName
${BILLING_EMAIL}                        id=BillingNewAddress_Email
${BILLING_COUNTRY}                      id=BillingNewAddress_CountryId
${BILLING_STATE}                        id=BillingNewAddress_StateProvinceId
${BILLING_CITY}                         id=BillingNewAddress_City
${BILLING_ADDRESS1}                     id=BillingNewAddress_Address1
${BILLING_ZIP}                          id=BillingNewAddress_ZipPostalCode
${BILLING_PHONE}                        id=BillingNewAddress_PhoneNumber

${BILLING_CONTINUE_BUTTON}              xpath=//div[@id='billing-buttons-container']//input[contains(@class,'new-address-next-step-button')]

# STEP 2 - Shipping Address
${SHIPPING_STEP_CONTENT}                id=checkout-step-shipping
${SHIPPING_CONTINUE_BUTTON}             xpath=//div[@id='shipping-buttons-container']//input[contains(@class,'new-address-next-step-button')]

# STEP 3 - Shipping Method
${SHIPPING_METHOD_STEP_CONTENT}         id=checkout-step-shipping-method
${SHIPPING_METHOD_LOAD}                 id=checkout-shipping-method-load
${SHIPPING_METHOD_RADIO}                xpath=//input[@name='shippingoption'][contains(@value,'${SHIPPING_METHOD_DATA}')]
${SHIPPING_METHOD_CONTINUE_BUTTON}      xpath=//div[@id='shipping-method-buttons-container']//input[contains(@class,'shipping-method-next-step-button')]

# STEP 4 - Payment Method
${PAYMENT_METHOD_STEP_CONTENT}          id=checkout-step-payment-method
${PAYMENT_METHOD_LOAD}                  id=checkout-payment-method-load
${PAYMENT_METHOD_RADIO}                 xpath=//input[@name='paymentmethod'][contains(@value,'${PAYMENT_METHOD_DATA}')]
${PAYMENT_METHOD_CONTINUE_BUTTON}       xpath=//div[@id='payment-method-buttons-container']//input[contains(@class,'payment-method-next-step-button')]

# STEP 5 - Payment Information
${PAYMENT_INFO_STEP_CONTENT}            id=checkout-step-payment-info
${PAYMENT_INFO_LOAD}                    id=checkout-payment-info-load
${PAYMENT_INFO_CONTINUE_BUTTON}         xpath=//div[@id='payment-info-buttons-container']//input[contains(@class,'payment-info-next-step-button')]

# Credit Card fields
${CC_TYPE}                              id=CreditCardType
${CC_NAME}                              id=CardholderName
${CC_NUMBER}                            id=CardNumber
${CC_EXPIRE_MONTH}                      id=ExpireMonth
${CC_EXPIRE_YEAR}                       id=ExpireYear
${CC_CODE}                              id=CardCode

# Purchase Order field
${PO_NUMBER_FIELD}                            xpath=//*[@id="PurchaseOrderNumber"]

# STEP 6 - Confirm Order
${CONFIRM_ORDER_STEP_CONTENT}           id=checkout-step-confirm-order
${CONFIRM_ORDER_LOAD}                   id=checkout-confirm-order-load
${CONFIRM_ORDER_BUTTON}                 xpath=//div[@id='confirm-order-buttons-container']//input[contains(@class,'confirm-order-next-step-button')]

# ORDER COMPLETED PAGE
${ORDER_COMPLETED_PAGE}                 xpath=//div[contains(@class,'order-completed')]
${ORDER_COMPLETED_TITLE}                xpath=/html/body/div[4]/div[1]/div[4]/div/div/div[2]/div/div[1]
${ORDER_NUMBER}                         xpath=//div[contains(@class,'order-completed')]//ul[@class='details']

*** Keywords ***
# PAGE VERIFICATION
Verify Checkout Page Loaded
    Wait Until Element Is Visible    ${CHECKOUT_PAGE_CONTAINER}    timeout=15s
    Wait Until Element Is Visible    ${CHECKOUT_STEPS}             timeout=15s
    1_CommonWeb.Wait For Page To Load

Verify Order Completed Page Loaded
    Wait Until Element Is Visible    ${ORDER_COMPLETED_PAGE}       timeout=20s
    Wait Until Element Is Visible    ${ORDER_COMPLETED_TITLE}      timeout=10s

# CART PAGE ACTIONS
Accept Terms Of Service
    Wait Until Element Is Visible    ${TERMS_OF_SERVICE_CHECKBOX}    timeout=10s
    Select Checkbox                  ${TERMS_OF_SERVICE_CHECKBOX}

Click Checkout From Cart
    Accept Terms Of Service
    1_CommonWeb.Wait For Element And Click    ${CART_CHECKOUT_BUTTON}
    1_CommonWeb.Wait For Page To Load

# STEP 1 - BILLING ADDRESS
Verify Billing Step Active
    Wait Until Element Is Visible    ${BILLING_STEP_CONTENT}    timeout=15s

Select New Address Option
    Wait Until Element Is Visible    ${BILLING_ADDRESS_SELECT}      timeout=10s
    Select From List By Value        ${BILLING_ADDRESS_SELECT}      ${EMPTY}
    Wait Until Element Is Visible    ${BILLING_NEW_ADDRESS_FORM}    timeout=10s

Fill Billing Address Form
    [Arguments]
    ...    ${firstname}=${BILLING_FIRSTNAME_DATA}
    ...    ${lastname}=${BILLING_LASTNAME_DATA}
    ...    ${email}=${BILLING_EMAIL_DATA}
    ...    ${country}=${BILLING_COUNTRY_DATA}
    ...    ${city}=${BILLING_CITY_DATA}
    ...    ${address}=${BILLING_ADDRESS1_DATA}
    ...    ${zip}=${BILLING_ZIP_DATA}
    ...    ${phone}=${BILLING_PHONE_DATA}
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_FIRSTNAME}    ${firstname}
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_LASTNAME}     ${lastname}
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_EMAIL}        ${email}
    Select From List By Label                      ${BILLING_COUNTRY}      ${country}
    Sleep    1s    # Wait for State dropdown AJAX reload
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_CITY}         ${city}
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_ADDRESS1}     ${address}
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_ZIP}          ${zip}
    1_CommonWeb.Wait For Element And Input Text    ${BILLING_PHONE}        ${phone}

Click Billing Continue
    1_CommonWeb.Wait For Element And Click    ${BILLING_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${SHIPPING_STEP_CONTENT}    timeout=15s

# STEP 2 - SHIPPING ADDRESS
Verify Shipping Step Active
    Wait Until Element Is Visible    ${SHIPPING_STEP_CONTENT}    timeout=15s

Click Shipping Continue
    1_CommonWeb.Wait For Element And Click    ${SHIPPING_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${SHIPPING_METHOD_STEP_CONTENT}    timeout=15s

# STEP 3 - SHIPPING METHOD
Verify Shipping Method Step Active
    Wait Until Element Is Visible    ${SHIPPING_METHOD_STEP_CONTENT}    timeout=15s
    Wait Until Element Is Visible    ${SHIPPING_METHOD_LOAD}            timeout=10s

Select Shipping Method
    [Arguments]    ${method}=${SHIPPING_METHOD_DATA}
    Wait Until Element Is Visible    xpath=//input[@name='shippingoption'][contains(@value,'${method}')]    timeout=10s
    Click Element                    xpath=//input[@name='shippingoption'][contains(@value,'${method}')]

Click Shipping Method Continue
    1_CommonWeb.Wait For Element And Click    ${SHIPPING_METHOD_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${PAYMENT_METHOD_STEP_CONTENT}    timeout=15s

# STEP 4 - PAYMENT METHOD
Verify Payment Method Step Active
    Wait Until Element Is Visible    ${PAYMENT_METHOD_STEP_CONTENT}    timeout=15s
    Wait Until Element Is Visible    ${PAYMENT_METHOD_LOAD}            timeout=10s

Select Payment Method
    [Arguments]    ${method}=${PAYMENT_METHOD_DATA}
    ${is_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible    xpath=//input[@name='paymentmethod'][contains(@value,'${method}')]
    IF    ${is_visible}
        Click Element    xpath=//input[@name='paymentmethod'][contains(@value,'${method}')]
    ELSE
        Log    Payment method radio not found - may be "Payment is not required"
    END

Click Payment Method Continue
    1_CommonWeb.Wait For Element And Click    ${PAYMENT_METHOD_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${PAYMENT_INFO_STEP_CONTENT}    timeout=15s

# STEP 5 - PAYMENT INFORMATION
Verify Payment Info Step Active
    Wait Until Element Is Visible    ${PAYMENT_INFO_STEP_CONTENT}    timeout=15s
    Wait Until Element Is Visible    ${PAYMENT_INFO_LOAD}            timeout=10s

Fill Credit Card Info
    [Arguments]
    ...    ${card_type}=${CC_TYPE_DATA}
    ...    ${card_name}=${CC_NAME_DATA}
    ...    ${card_number}=${CC_NUMBER_DATA}
    ...    ${expire_month}=${CC_EXPIRE_MONTH_DATA}
    ...    ${expire_year}=${CC_EXPIRE_YEAR_DATA}
    ...    ${card_code}=${CC_CODE_DATA}
    Select From List By Value                      ${CC_TYPE}          ${card_type}
    1_CommonWeb.Wait For Element And Input Text    ${CC_NAME}          ${card_name}
    1_CommonWeb.Wait For Element And Input Text    ${CC_NUMBER}        ${card_number}
    Select From List By Value                      ${CC_EXPIRE_MONTH}  ${expire_month}
    Select From List By Value                      ${CC_EXPIRE_YEAR}   ${expire_year}
    1_CommonWeb.Wait For Element And Input Text    ${CC_CODE}          ${card_code}

Fill Purchase Order Info
    [Arguments]    ${po_number}=${PO_NUMBER_DATA}
    1_CommonWeb.Wait For Element And Input Text    ${PO_NUMBER_FIELD}    ${po_number}

Fill Payment Info
    [Arguments]    ${method}=${PAYMENT_METHOD_DATA}
    IF    '${method}' == 'CashOnDelivery'
        Log    COD selected - no payment info required
    ELSE IF    '${method}' == 'CheckMoneyOrder'
        Log    Check/Money Order selected - no payment info required
    ELSE IF    '${method}' == 'Manual'
        Fill Credit Card Info
    ELSE IF    '${method}' == 'PurchaseOrder'
        Fill Purchase Order Info
    ELSE
        Log    Unknown payment method: ${method}
    END

Click Payment Info Continue
    1_CommonWeb.Wait For Element And Click    ${PAYMENT_INFO_CONTINUE_BUTTON}
    Wait Until Element Is Visible    ${CONFIRM_ORDER_STEP_CONTENT}    timeout=15s

# STEP 6 - CONFIRM ORDER
Verify Confirm Order Step Active
    Wait Until Element Is Visible    ${CONFIRM_ORDER_STEP_CONTENT}    timeout=15s
    Wait Until Element Is Visible    ${CONFIRM_ORDER_LOAD}            timeout=10s

Click Confirm Order
    1_CommonWeb.Wait For Element And Click    ${CONFIRM_ORDER_BUTTON}
    Wait Until Element Is Visible    ${ORDER_COMPLETED_PAGE}    timeout=20s

# ORDER COMPLETED
Get Order Number
    Wait Until Element Is Visible    ${ORDER_NUMBER}    timeout=10s
    ${order_number}=    Get Text    ${ORDER_NUMBER}
    RETURN    ${order_number}

Verify Order Completed Successfully
    Verify Order Completed Page Loaded
    ${title_text}=    Get Text    ${ORDER_COMPLETED_TITLE}
    Should Contain    ${title_text}    Your order has been successfully processed!    ignore_case=True
    ${order_number}=    Get Order Number
    Log    Order placed successfully! Order: ${order_number}
    RETURN    ${order_number}
