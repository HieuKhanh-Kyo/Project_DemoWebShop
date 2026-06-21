*** Settings ***
Documentation       Test Cases for Add to Cart Functionality

Library             SeleniumLibrary

Resource            ../../Config/1_Environments.robot
Resource            ../../Resources/Keywords/Common/1_CommonWeb.robot
Resource            ../../Resources/Keywords/Common/2_BrowserNavigation.robot
Resource            ../../Resources/Keywords/Common/3_UtilityFunction.robot
Resource            ../../Resources/Keywords/Customer/4_ShoppingCart.robot
Resource            ../../Resources/PageObject/Customer/1_HomePage.robot
Resource            ../../Resources/PageObject/Customer/4_ProductListPage.robot
Resource            ../../Resources/PageObject/Customer/6_ShoppingCartPage.robot
Resource            ../../Resources/PageObject/Common/2_Header.robot

Suite Setup         1_CommonWeb.Open Application With Login
Suite Teardown      1_CommonWeb.Close Application

Test Setup          Clear Cart Before Test
Test Teardown       Take Screenshot If Test Failed

# run script: robot -d Results TestCases/ShoppingCart/1_TestAddToCart.robot
# run specific: robot -d Results -i "TC-CART-010*" TestCases/ShoppingCart/1_TestAddToCart.robot

*** Keywords ***
Clear Cart Before Test
    [Documentation]    Clear cart before each test
    TRY
        4_ShoppingCart.Clear Shopping Cart
    EXCEPT
        Log    Cart already empty or first run
    END

Take Screenshot If Test Failed
    [Documentation]    Take screenshot if test fails
    Run Keyword If Test Failed    3_UtilityFunction.Take Screenshot With Custom Name    test_failed

*** Test Cases ***
# Basic Add to Cart Tests
TC-CART-001 - Add Single Product From Homepage
    [Documentation]    Add single product to cart from homepage
    [Tags]    TC-CART-001    cart    add-to-cart    smoke    positive

    # Step 1: Add product from homepage
    ${product_info}=    4_ShoppingCart.Add Product And Verify In Cart    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_001_product_added

    # Step 2: Verify cart has 1 item
    4_ShoppingCart.Verify Cart Item Count    1
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_001_verified

    Log    Successfully added product to cart

TC-CART-002 - Add Product Via Search
    [Documentation]    Search for product and add to cart
    [Tags]    TC-CART-002    cart    add-to-cart    search    positive

    # Step 1: Search and add product
    ${product_name}=    4_ShoppingCart.Add Product Via Search And Verify    laptop
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_002_added_via_search

    # Step 2: Verify product in cart
    6_ShoppingCartPage.Verify Product In Cart    ${product_name}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_002_verified

    Log    Successfully added product via search: ${product_name}

TC-CART-003 - Add Multiple Products From Catalog
    [Documentation]    Add multiple different products to cart
    [Tags]    TC-CART-003    cart    add-to-cart    multiple    positive

    # Step 1: Add 3 products from catalog
    ${products}=    4_ShoppingCart.Test Add Multiple Products Workflow    3
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_003_multiple_added

    # Step 2: Verify all products in cart
    ${cart_count}=    6_ShoppingCartPage.Get Cart Items Count
    Should Be Equal As Numbers    ${cart_count}    3
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_003_verified

    Log    Successfully added ${cart_count} products to cart

TC-CART-004 - Add Same Product Multiple Times
    [Documentation]    Add same product to cart multiple times
    [Tags]    TC-CART-004    cart    add-to-cart    duplicate    positive

    # Step 1: Add same product twice
    ${product_info_1}=    4_ShoppingCart.Add Product To Cart From Homepage    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_004_first_add
    Sleep    1s

    ${product_info_2}=    4_ShoppingCart.Add Product To Cart From Homepage    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_004_second_add
    Sleep    3s

    # Step 2: Navigate to cart and verify
    4_ShoppingCart.Navigate To Shopping Cart
    ${cart_count}=    6_ShoppingCartPage.Get Cart Items Count

    # Verify cart behavior (might be 1 item with qty 2, or 2 separate items)
    Should Be True    ${cart_count} >= 1    Cart should have at least 1 item
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_004_verified

    Log    Added same product twice - cart has ${cart_count} item(s)

# Cart Display and Verification Tests
TC-CART-005 - Verify Product Details In Cart
    [Documentation]    Verify product details are correctly displayed in cart
    [Tags]    TC-CART-005    cart    display    verification    positive

    # Step 1: Add product to cart
    ${product_info}=    4_ShoppingCart.Add Product To Cart From Homepage    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_005_product_added

    # Step 2: Navigate to cart
    sleep    3s
    4_ShoppingCart.Navigate To Shopping Cart
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_005_cart_page

    # Step 3: Verify product details are displayed
    6_ShoppingCartPage.Verify Cart Item Details    1

    ${product_name}=    6_ShoppingCartPage.Get Product Name By Index    1
    Should Not Be Empty    ${product_name}

    ${quantity}=    6_ShoppingCartPage.Get Product Quantity By Index    1
    Should Not Be Empty    ${quantity}

    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_005_details_verified

    Log    Product details verified in cart for: ${product_name}

TC-CART-006 - Verify Cart Total Displayed
    [Documentation]    Verify cart total is calculated and displayed
    [Tags]    TC-CART-006    cart    total    calculation    positive

    # Step 1: Add products to cart
    ${products}=    4_ShoppingCart.Add Multiple Products To Cart From Catalog    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_006_products_added

    # Step 2: Navigate to cart and verify total
    4_ShoppingCart.Navigate To Shopping Cart
    6_ShoppingCartPage.Verify Cart Total Displayed

    ${total}=    6_ShoppingCartPage.Get Cart Total
    Should Not Be Empty    ${total}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_006_total_verified

    Log    Cart total displayed: ${total}

TC-CART-007 - Verify Empty Cart Message
    [Documentation]    Verify empty cart displays correct message
    [Tags]    TC-CART-007    cart    empty    verification    positive

    # Step 1: Navigate to empty cart
    4_ShoppingCart.Verify Empty Cart Behavior
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_007_empty_cart

    # Step 2: Verify empty message
    ${items_count}=    6_ShoppingCartPage.Get Cart Items Count
    Should Be Equal As Numbers    ${items_count}    0
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_007_verified

    Log    Empty cart message verified successfully

# Navigation Tests
TC-CART-008 - Continue Shopping From Cart
    [Documentation]    Test continue shopping functionality from cart
    [Tags]    TC-CART-008    cart    navigation    positive

    # Step 1: Add product and go to cart
    ${product_info}=    4_ShoppingCart.Add Product To Cart From Homepage    2

    Sleep   3s
    4_ShoppingCart.Navigate To Shopping Cart
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_008_in_cart

    # Step 2: Continue shopping
    4_ShoppingCart.Continue Shopping From Cart
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_008_continued_shopping

    # Step 3: Verify navigation back to shopping area
    ${current_url}=    Get Location
    Should Contain    ${current_url}    ${URL}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_008_verified

    Log    Continue shopping navigation verified

TC-CART-009 - Access Cart From Multiple Pages
    [Documentation]    Test accessing cart from different pages
    [Tags]    TC-CART-009    cart    navigation    positive

    # Step 1: Add product from homepage
    ${product_info}=    4_ShoppingCart.Add Product To Cart From Homepage    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_009_added_from_home

    # Step 2: Navigate to search page
    Go To    ${URL}
    2_Header.Search For Product    book
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_009_on_search_page

    # Step 3: Access cart from search page
    4_ShoppingCart.Navigate To Shopping Cart
    6_ShoppingCartPage.Verify Cart Has Items
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_009_cart_from_search

    # Step 4: Verify product still in cart
    ${product_name}=    Set Variable    ${product_info}[name]
    6_ShoppingCartPage.Verify Product In Cart    ${product_name}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_009_verified

    Log    Cart accessible and consistent from multiple pages

# Edge Cases
TC-CART-010 - Add Product Then Clear Cart
    [Documentation]    Add products then clear entire cart
    [Tags]    TC-CART-010    cart    clear    edge-case

    # Step 1: Add multiple products
    ${products}=    4_ShoppingCart.Add Multiple Products To Cart From Catalog    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_010_products_added

    # Step 2: Verify products in cart
    4_ShoppingCart.Navigate To Shopping Cart
    ${initial_count}=    6_ShoppingCartPage.Get Cart Items Count
    Should Be True    ${initial_count} > 0
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_010_before_clear

    # Step 3: Clear cart
    4_ShoppingCart.Clear Shopping Cart
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_010_after_clear

    # Step 4: Verify cart is empty
    6_ShoppingCartPage.Verify Cart Is Empty
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_010_verified_empty

    Log    Cart cleared successfully - from ${initial_count} items to 0

TC-CART-011 - Verify Cart Persists Across Navigation
    [Documentation]    Verify cart contents persist when navigating between pages
    [Tags]    TC-CART-011    cart    persistence    positive

    # Step 1: Add product to cart
    ${product_info}=    4_ShoppingCart.Add Product To Cart From Homepage    2
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_011_product_added

    # Step 2: Navigate to different pages
    Go To    ${URL}
    1_HomePage.Navigate To Category    Books
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_011_on_books_page

    Go To    ${URL}
    2_Header.Search For Product    computer
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_011_on_search_page

    # Step 3: Go back to cart
    4_ShoppingCart.Navigate To Shopping Cart
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_011_back_to_cart

    # Step 4: Verify product still in cart
    ${product_name}=    Set Variable    ${product_info}[name]
    6_ShoppingCartPage.Verify Product In Cart    ${product_name}
    ${cart_count}=    6_ShoppingCartPage.Get Cart Items Count
    Should Be Equal As Numbers    ${cart_count}    1
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_011_verified

    Log    Cart contents persisted across navigation

TC-CART-012 - Add Product From Category Page
    [Documentation]    Add product to cart from category page
    [Tags]    TC-CART-012    cart    category    positive

    # Step 1: Navigate to category
    Go To    ${URL}
    1_HomePage.Navigate To Category    Apparel & Shoes
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_012_apparel & shoes_page

    # Step 2: Add product from category
    ${products_available}=    4_ProductListPage.Get Products Count
    Should Be True    ${products_available} > 0    No products in category

    4_ProductListPage.Add Product To Cart By Index    2
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_012_product_added

    # Step 3: Verify in cart
    4_ShoppingCart.Navigate To Shopping Cart
    6_ShoppingCartPage.Verify Cart Has Items
    ${cart_count}=    6_ShoppingCartPage.Get Cart Items Count
    Should Be Equal As Numbers    ${cart_count}    1
    3_UtilityFunction.Take Screenshot With Custom Name    tc_cart_012_verified

    Log    Product added to cart from category page successfully