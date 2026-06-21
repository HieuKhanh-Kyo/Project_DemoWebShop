*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String

Resource   ../../Keywords/Common/imports.robot

*** Variables ***
# Shopping Cart Page Structure
${CART_PAGE_CONTAINER}          xpath=//div[@class='page shopping-cart-page']
${CART_PAGE_TITLE}              xpath=//div[@class='page-title']//h1
${CART_ITEMS_TABLE}             xpath=//table[@class='cart']

# Cart Items
${CART_ITEM_ROWS}               //table[@class='cart']//tbody//tr[@class='cart-item-row']
${CART_ITEM_REMOVE_CHECKBOX}    //input[@name='removefromcart']
${CART_UPDATE_CART_BUTTON}      xpath=//input[@name='updatecart']
${CART_CONTINUE_SHOPPING}       xpath=//input[@name='continueshopping']

# Empty Cart
${EMPTY_CART_MESSAGE}           xpath=//div[@class='order-summary-content']
${EMPTY_CART_TEXT}              Your Shopping Cart is empty!

# Cart Item Details
${ITEM_PRODUCT_NAME}            //a[@class='product-name']
${ITEM_UNIT_PRICE}              //span[@class='product-unit-price']
${ITEM_QUANTITY_INPUT}          //input[contains(@class,'qty-input')]
${ITEM_SUBTOTAL}                //span[@class='product-subtotal']

# Cart Summary
${CART_TOTAL_LABEL}             xpath=//table[@class='cart-total']
${CART_TOTAL_VALUE}             xpath=/html/body/div[4]/div[1]/div[4]/div/div/div[2]/div/form/div[2]/div[2]/div[1]/table/tbody/tr[1]/td[2]/span/span

# Checkout
${CHECKOUT_BUTTON}              xpath=//button[@id='checkout']
${TERMS_OF_SERVICE_CHECKBOX}    xpath=//input[@id='termsofservice']

*** Keywords ***
# Page Verification
Verify Cart Page Loaded
    [Documentation]    Verify shopping cart page is loaded
    3_UtilityFunction.Wait And Assert Element Visible    ${CART_PAGE_CONTAINER}
    Element Should Be Visible    ${CART_PAGE_TITLE}
    1_CommonWeb.Wait For Page To Load

Verify Cart Page Title
    [Documentation]    Verify cart page title
    ${title}=    Get Text    ${CART_PAGE_TITLE}
    Should Contain    ${title}    Shopping cart    ignore_case=True

# Cart Item Management
Get Cart Items Count
    [Documentation]    Get number of items in cart
    ${count}=    Get Element Count    ${CART_ITEM_ROWS}
    RETURN    ${count}

Verify Cart Is Empty
    [Documentation]    Verify shopping cart is empty
    ${items_count}=    Get Cart Items Count

    IF    ${items_count} == 0
        Log    Cart is empty - verified by item count
    ELSE
        Fail    Expected cart to be empty but found ${items_count} items
    END

Verify Cart Has Items
    [Documentation]    Verify cart contains items
    ${items_count}=    Get Cart Items Count
    Should Be True    ${items_count} > 0    Cart should contain items

Get Product Name By Index
    [Documentation]    Get product name by row index (1-based)
    [Arguments]    ${index}
    ${name_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_PRODUCT_NAME}
    ${name}=    Get Text    ${name_locator}
    RETURN    ${name}

Get All Product Names In Cart
    [Documentation]    Get list of all product names in cart
    @{product_names}=    Create List

    # Get all product name elements from cart rows
    ${items_count}=    Get Cart Items Count

    FOR    ${index}    IN RANGE    1    ${items_count} + 1
        ${name_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_PRODUCT_NAME}
        ${name}=    Get Text    ${name_locator}
        Append To List    ${product_names}    ${name}
    END

    RETURN    ${product_names}

Get Product Quantity By Index
    [Documentation]    Get product quantity by index
    [Arguments]    ${index}
    ${qty_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_QUANTITY_INPUT}
    ${quantity}=    Get Value    ${qty_locator}
    RETURN    ${quantity}

Update Product Quantity By Index
    [Documentation]    Update product quantity by index
    [Arguments]    ${index}    ${new_quantity}
    ${qty_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_QUANTITY_INPUT}
    Clear Element Text    ${qty_locator}
    Input Text    ${qty_locator}    ${new_quantity}

Click Update Cart Button
    [Documentation]    Click update cart button
    1_CommonWeb.Wait For Element And Click    ${CART_UPDATE_CART_BUTTON}
    1_CommonWeb.Wait For Page To Load

Remove Product By Index
    [Documentation]    Remove product from cart by index
    [Arguments]    ${index}
    ${checkbox_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${CART_ITEM_REMOVE_CHECKBOX}
    Select Checkbox    ${checkbox_locator}
    Click Update Cart Button

Remove All Products
    [Documentation]    Remove all products from cart
    ${items_count}=    Get Cart Items Count

    FOR    ${index}    IN RANGE    1    ${items_count} + 1
        ${checkbox_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${CART_ITEM_REMOVE_CHECKBOX}
        Select Checkbox    ${checkbox_locator}
    END

    Click Update Cart Button

# Cart Summary
Get Cart Total
    [Documentation]    Get cart total value
    ${total}=    Get Text    ${CART_TOTAL_VALUE}
    RETURN    ${total}

Verify Cart Total Displayed
    [Documentation]    Verify cart total is displayed
    Element Should Be Visible    ${CART_TOTAL_LABEL}
    Element Should Be Visible    ${CART_TOTAL_VALUE}

# Navigation
Click Continue Shopping
    [Documentation]    Click continue shopping button
    1_CommonWeb.Wait For Element And Click    ${CART_CONTINUE_SHOPPING}
    1_CommonWeb.Wait For Page To Load

Click Checkout Button
    [Documentation]    Click checkout button
    ${terms_checkbox_exists}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${TERMS_OF_SERVICE_CHECKBOX}

    IF    ${terms_checkbox_exists}
        Select Checkbox    ${TERMS_OF_SERVICE_CHECKBOX}
    END

    1_CommonWeb.Wait For Element And Click    ${CHECKOUT_BUTTON}
    1_CommonWeb.Wait For Page To Load

# Verification Keywords
Verify Product In Cart
    [Documentation]    Verify specific product exists in cart
    [Arguments]    ${product_name}
    ${product_names}=    Get All Product Names In Cart
    List Should Contain Value    ${product_names}    ${product_name}
    ...    Product "${product_name}" not found in cart

Verify Cart Item Details
    [Documentation]    Verify cart item has all required details
    [Arguments]    ${index}
    ${name_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_PRODUCT_NAME}
    ${price_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_UNIT_PRICE}
    ${qty_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_QUANTITY_INPUT}
    ${subtotal_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_SUBTOTAL}

    Element Should Be Visible    ${name_locator}
    Element Should Be Visible    ${price_locator}
    Element Should Be Visible    ${qty_locator}
    Element Should Be Visible    ${subtotal_locator}

Get Product Price By Index
    [Documentation]    Get product unit price by index
    [Arguments]    ${index}
    ${price_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_UNIT_PRICE}
    ${price}=    Get Text    ${price_locator}
    RETURN    ${price}

Get Product Subtotal By Index
    [Documentation]    Get product subtotal by index
    [Arguments]    ${index}
    ${subtotal_locator}=    Set Variable    xpath=(${CART_ITEM_ROWS})[${index}]${ITEM_SUBTOTAL}
    ${subtotal}=    Get Text    ${subtotal_locator}
    RETURN    ${subtotal}