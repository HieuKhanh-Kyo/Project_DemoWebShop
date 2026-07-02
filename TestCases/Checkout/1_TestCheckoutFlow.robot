*** Settings ***
Documentation       Test Cases for Checkout Flow - Successful Path

Library             SeleniumLibrary

Resource            ../../Config/1_Environments.robot
Resource            ../../Resources/Keywords/Common/1_CommonWeb.robot
Resource            ../../Resources/Keywords/Common/2_BrowserNavigation.robot
Resource            ../../Resources/Keywords/Common/3_UtilityFunction.robot
Resource            ../../Resources/Keywords/Customer/4_ShoppingCart.robot
Resource            ../../Resources/Keywords/Customer/5_CheckOut.robot
Resource            ../../Resources/PageObject/Customer/6_ShoppingCartPage.robot
Resource            ../../Resources/PageObject/Customer/7_CheckOutPage.robot

Suite Setup         1_CommonWeb.Open Application With Login
Suite Teardown      1_CommonWeb.Close Application

Test Setup          Prepare Cart Before Checkout Test
Test Teardown       Take Screenshot If Test Failed

# run: robot -d Results TestCases/Checkout/1_TestCheckoutFlow.robot

*** Keywords ***
Prepare Cart Before Checkout Test
    [Documentation]    Ensure cart has at least 1 product before each test
    TRY
        4_ShoppingCart.Clear Shopping Cart
    EXCEPT
        Log    Cart already empty or first run
    END
    4_ShoppingCart.Add Product To Cart From Homepage    2
    Sleep    3s
    4_ShoppingCart.Navigate To Shopping Cart

Take Screenshot If Test Failed
    Run Keyword If Test Failed
    ...    3_UtilityFunction.Take Screenshot With Custom Name    checkout_test_failed

*** Test Cases ***
TC-CHECKOUT-001 - Verify User Can Complete Checkout Successfully
    [Documentation]    Verify a logged-in user with items in cart can complete
    ...    the full checkout flow and receive an order confirmation.
    ...    All test data configured via Resources/Variables/checkout_data.robot
    [Tags]    TC-CHECKOUT-001    checkout    smoke    successful-path    positive

    # Step 1: Verify cart has item
    6_ShoppingCartPage.Verify Cart Has Items
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_01_cart_ready

    # Step 2: Navigate to checkout
    5_Checkout.Navigate To Checkout From Cart
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_02_checkout_page

    # Step 3: Fill billing address
    5_Checkout.Complete Billing Step
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_03_billing_done

    # Step 4: Shipping address
    5_Checkout.Complete Shipping Step
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_04_shipping_done

    # Step 5: Select shipping method
    5_Checkout.Complete Shipping Method Step
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_05_shipping_method_done

    # Step 6: Select payment method
    5_Checkout.Complete Payment Method Step
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_06_payment_method_done

    # Step 7: Fill payment information
    5_Checkout.Complete Payment Info Step
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_07_payment_info_done

    # Step 8: Confirm order
    5_Checkout.Confirm And Place Order
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_08_order_placed

    # Step 9: Verify order completed
    ${order_number}=    7_CheckoutPage.Verify Order Completed Successfully
    3_UtilityFunction.Take Screenshot With Custom Name    tc_checkout_001_09_order_completed

    Log    TC-CHECKOUT-001 PASSED - Order: ${order_number}