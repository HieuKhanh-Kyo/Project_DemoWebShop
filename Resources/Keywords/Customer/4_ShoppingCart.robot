*** Settings ***
Library    SeleniumLibrary
Library    Collections

Resource    ../../PageObject/Customer/6_ShoppingCartPage.robot
Resource    ../../PageObject/Customer/1_HomePage.robot
Resource    ../../PageObject/Customer/5_SearchResultsPage.robot
Resource    ../../PageObject/Customer/4_ProductListPage.robot
Resource    ../../PageObject/Common/2_Header.robot
Resource    ../Common/imports.robot
Resource    ../../../Config/1_Environments.robot

*** Variables ***
${CART_LINK}    xpath=//*[@id="topcartlink"]//span[@class="cart-label"]

*** Keywords ***
# Navigation Keywords
Navigate To Shopping Cart
    [Documentation]    Navigate to shopping cart page
    1_CommonWeb.Wait For Element And Click    ${CART_LINK}
    1_CommonWeb.Wait For Page To Load
    6_ShoppingCartPage.Verify Cart Page Loaded

Open Shopping Cart From Header
    [Documentation]    Open shopping cart from header link
    Navigate To Shopping Cart

# Add to Cart Keywords
Add Product To Cart From Homepage
    [Documentation]    Add featured product to cart from homepage by index
    [Arguments]    ${product_index}=1
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load

    ${product_details}=    1_HomePage.Get Product Details By Index    ${product_index}
    1_HomePage.Add Featured Product To Cart By Index    ${product_index}
    1_CommonWeb.Wait For Page To Load

    RETURN    ${product_details}

Add Product To Cart From Search
    [Documentation]    Search and add product to cart
    [Arguments]    ${search_term}
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load

    2_Header.Search For Product    ${search_term}
    1_CommonWeb.Wait For Page To Load

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No search results found

    ${product_names}=    5_SearchResultsPage.Get All Search Result Product Names
    ${first_product}=    Get From List    ${product_names}    0

    5_SearchResultsPage.Add To Cart From Search Results By Index    1
    1_CommonWeb.Wait For Page To Load

    RETURN    ${first_product}

Add Multiple Products To Cart
    [Documentation]    Add multiple products to cart from homepage
    [Arguments]    ${number_of_products}=2
    @{added_products}=    Create List

    Go To    ${URL}
    1_HomePage.Navigate To Category    Apparel & Shoes
    1_CommonWeb.Wait For Page To Load

    FOR    ${index}    IN RANGE    1    ${number_of_products} + 1
        4_ProductListPage.Add Product To Cart By Index    ${index}
        Sleep    1s
        1_HomePage.Navigate To Category    Apparel & Shoes
    END

    RETURN    ${added_products}

# Cart Verification Keywords
Verify Product Added To Cart
    [Documentation]    Verify product was added to cart
    [Arguments]    ${product_name}
    Navigate To Shopping Cart
    6_ShoppingCartPage.Verify Product In Cart    ${product_name}

Verify Multiple Products In Cart
    [Documentation]    Verify multiple products are in cart
    [Arguments]    @{expected_products}
    Navigate To Shopping Cart

    ${cart_products}=    6_ShoppingCartPage.Get All Product Names In Cart

    FOR    ${expected_product}    IN    @{expected_products}
        List Should Contain Value    ${cart_products}    ${expected_product}
        ...    Product "${expected_product}" not found in cart
    END

Verify Cart Item Count
    [Documentation]    Verify number of items in cart
    [Arguments]    ${expected_count}
    Navigate To Shopping Cart
    ${actual_count}=    6_ShoppingCartPage.Get Cart Items Count
    Should Be Equal As Numbers    ${actual_count}    ${expected_count}
    ...    Expected ${expected_count} items but found ${actual_count}

# Cart Management Keywords
Update Product Quantity In Cart
    [Documentation]    Update quantity of product in cart
    [Arguments]    ${product_index}    ${new_quantity}
    Navigate To Shopping Cart
    6_ShoppingCartPage.Update Product Quantity By Index    ${product_index}    ${new_quantity}
    6_ShoppingCartPage.Click Update Cart Button
    1_CommonWeb.Wait For Page To Load

Remove Product From Cart By Index
    [Documentation]    Remove product from cart by index
    [Arguments]    ${product_index}
    Navigate To Shopping Cart
    6_ShoppingCartPage.Remove Product By Index    ${product_index}
    1_CommonWeb.Wait For Page To Load

Clear Shopping Cart
    [Documentation]    Remove all products from cart
    Navigate To Shopping Cart

    ${items_count}=    6_ShoppingCartPage.Get Cart Items Count
    IF    ${items_count} > 0
        6_ShoppingCartPage.Remove All Products
        1_CommonWeb.Wait For Page To Load
    END

# Complete Workflows
Add Product And Verify In Cart
    [Documentation]    Complete workflow: Add product and verify it's in cart
    [Arguments]    ${product_index}=1
    ${product_info}=    Add Product To Cart From Homepage    ${product_index}
    Sleep    6s

    Navigate To Shopping Cart
    6_ShoppingCartPage.Verify Product In Cart    ${product_info}[name]

    RETURN    ${product_info}

Add Product Via Search And Verify
    [Documentation]    Search, add to cart, and verify
    [Arguments]    ${search_term}
    ${product_name}=    Add Product To Cart From Search    ${search_term}
    Sleep    1s

    Navigate To Shopping Cart
    6_ShoppingCartPage.Verify Cart Has Items

    RETURN    ${product_name}

Test Add Multiple Products Workflow
    [Documentation]    Test adding multiple products workflow
    [Arguments]    ${count}=3
    ${products}=    Add Multiple Products To Cart    ${count}

    Navigate To Shopping Cart
    Verify Multiple Products In Cart    @{products}
    Verify Cart Item Count    ${count}

    RETURN    ${products}

# Empty Cart Testing
Verify Empty Cart Behavior
    [Documentation]    Verify empty cart displays correct message
    Navigate To Shopping Cart

    ${items_count}=    6_ShoppingCartPage.Get Cart Items Count
    IF    ${items_count} > 0
        Clear Shopping Cart
    END

    6_ShoppingCartPage.Verify Cart Is Empty

# Cart Continuation
Continue Shopping From Cart
    [Documentation]    Continue shopping from cart page
    Navigate To Shopping Cart
    6_ShoppingCartPage.Click Continue Shopping
    1_CommonWeb.Wait For Page To Load

    # Verify returned to shopping area
    ${current_url}=    Get Location
    Should Contain    ${current_url}    ${URL}