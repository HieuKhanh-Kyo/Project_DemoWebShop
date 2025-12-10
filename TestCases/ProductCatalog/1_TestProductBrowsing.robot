*** Settings ***
Documentation       Test Cases for Product Browsing Foundation

Library             SeleniumLibrary

Resource            ../../Resources/Keywords/Customer/2_Product.robot
Resource            ../../Resources/PageObject/Customer/1_HomePage.robot
Resource            ../../Resources/PageObject/Customer/4_ProductListPage.robot

Suite Setup         1_CommonWeb.Open Application
Suite Teardown      1_CommonWeb.Close Application

# run script: robot -d Results -i TC-DATA-001 TestCases/ProductCatalog/1_TestProductBrowsing.robot
# robot -d Results -t "TC-CATEGORY-003*" TestCases/ProductCatalog/1_TestProductBrowsing.robot

*** Variables ***
@{AVAILABLE_CATEGORIES}    Books    Computers    Electronics    Apparel & Shoes    Digital downloads    Jewelry    Gift Cards


*** Test Cases ***
# Homepage and Featured Products Tests
TC-HOMEPAGE-001 - Homepage Loading and Structure
    [Documentation]    Test homepage loads correctly with all required elements
    [Tags]    TC-HOMEPAGE-001    homepage    smoke    positive

    # Step 1: Navigate to homepage
    2_Product.Navigate To Homepage
    3_UtilityFunction.Take Screenshot With Custom Name    tc_homepage_001_loaded

    # Step 2: Check if category has products
    ${products_count}=    4_ProductListPage.Get Products Count

    IF    ${products_count} == 0
        Log    Gift Cards category is empty - testing empty category handling
        # Verify empty state is handled gracefully
        Page Should Contain    No products    Expected empty state message
    ELSE
        Log    Gift Cards category has ${products_count} products
        # Test normal functionality
        4_ProductListPage.Verify All Products Have Images
        4_ProductListPage.Verify All Products Have Prices
    END

    3_UtilityFunction.Take Screenshot With Custom Name    tc_edge_001_empty_handling_complete

    Log    Empty category handling test completed successfully

TC-EDGE-003 - Large Page Size Handling
    [Documentation]    Test handling of large page sizes and pagination edge cases
    [Tags]    TC-EDGE-003    edge-case    pagination    large-data

    # Step 1: Navigate to category with most products (usually Books or Computers)
    2_Product.Navigate To Product Category    Books
    3_UtilityFunction.Take Screenshot With Custom Name    tc_edge_003_books_loaded

    # Step 2: Try largest page size
    ${large_size_result}=    Run Keyword And Return Status    4_ProductListPage.Change Page Size    12
    IF    ${large_size_result}
        ${products_count}=    4_ProductListPage.Get Products Count
        Log    Large page size shows ${products_count} products

        # Verify all products still load correctly
        4_ProductListPage.Verify All Products Have Images
        4_ProductListPage.Verify All Products Have Prices
    ELSE
        Log    Large page size option not available
    END

    # Step 3: Test last page navigation
    ${available_pages}=    4_ProductListPage.Get Available Page Numbers
    ${has_pagination}=    Evaluate    len(${available_pages}) > 0

    IF    ${has_pagination}
        ${last_page}=    Get From List    ${available_pages}    -1
        4_ProductListPage.Go To Page Number    ${last_page}
        ${products_on_last_page}=    4_ProductListPage.Get Products Count
        Should Be True    ${products_on_last_page} > 0    Last page should have products
    END

    3_UtilityFunction.Take Screenshot With Custom Name    tc_edge_003_large_data_complete

    Log    Large page size handling test completed successfully

# Integration and Compatibility Tests
TC-INTEGRATION-001 - Browser Back/Forward Navigation
    [Documentation]    Test browser back/forward navigation with product browsing
    [Tags]    TC-INTEGRATION-001    integration    browser-navigation    compatibility

    # Step 1: Navigate through multiple categories
    2_Product.Navigate To Product Category    Books
    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_001_books_loaded

    2_Product.Navigate To Product Category    Computers
    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_001_computers_loaded

    2_Product.Navigate To Product Category    Electronics
    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_001_electronics_loaded

    # Step 2: Test browser back navigation
    1_HomePage.Navigate To Category    Books
    1_HomePage.Navigate To Category    Computers
    1_HomePage.Navigate To Category    Electronics

    2_BrowserNavigation.Go Back Page
    1_CommonWeb.Wait For Page To Load
    ${current_url}=    Get Location
    Should Contain    ${current_url}    computers    Should be back to Computers category

    2_BrowserNavigation.Go Back Page
    1_CommonWeb.Wait For Page To Load
    ${current_url}=    Get Location
    Should Contain    ${current_url}    books    Should be back to Books category

    # Step 3: Test browser forward navigation
    2_BrowserNavigation.Go Forward
    1_CommonWeb.Wait For Page To Load
    ${current_url}=    Get Location
    Should Contain    ${current_url}    computers    Should be forward to Computers category

    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_001_navigation_complete

    Log    Browser back/forward navigation test completed successfully

TC-INTEGRATION-002 - Product Browsing with Search Integration
    [Documentation]    Test integration between product browsing and search functionality
    [Tags]    TC-INTEGRATION-002    integration    search    browsing

    # Step 1: Start from homepage
    2_Product.Navigate To Homepage
    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_002_homepage_start

    # Step 2: Browse to category
    2_Product.Navigate To Product Category    Electronics
    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_002_electronics_loaded

    # Step 3: Get product name for search
    click link           xpath=/html/body/div[4]/div[1]/div[4]/div[2]/div[2]/div[2]/div[1]/div[1]/div/h2/a
    ${product_names}=    4_ProductListPage.Get All Product Names
    ${first_product}=    Get From List    ${product_names}    0
    ${search_term}=    Get Substring    ${first_product}    0    37

    # Step 4: Perform search
    2_Header.Search For Product    ${search_term}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_002_search_performed

    # Step 5: Verify search results
    ${current_url}=    Get Location
    Should Contain    ${current_url}    search    Should be on search results page

    # Step 6: Navigate back to category browsing
    2_Product.Navigate To Product Category    Electronics
    4_ProductListPage.Verify Category Title    Electronics

    3_UtilityFunction.Take Screenshot With Custom Name    tc_integration_002_integration_complete

    Log    Product browsing with search integration test completed successfully

TC-HOMEPAGE-002 - Featured Products Display and Interaction
    [Documentation]    Test featured products are displayed and interactive
    [Tags]    TC-HOMEPAGE-002    homepage    featured-products    positive

    # Step 1: Browse featured products
    ${featured_products}=    2_Product.Browse Featured Products
    3_UtilityFunction.Take Screenshot With Custom Name    tc_homepage_002_featured_products

    # Step 2: Test featured product interactions
    2_Product.Test Featured Product Interaction
    3_UtilityFunction.Take Screenshot With Custom Name    tc_homepage_002_interactions_complete

    Log    Featured products display and interaction test completed successfully

TC-HOMEPAGE-003 - Featured Products Interaction Tests
    [Documentation]    Comprehensive testing of featured products interactions
    [Tags]    TC-HOMEPAGE-003    homepage    featured-products    interaction

    # Step 1: Test comprehensive featured products interactions
    ${interaction_results}=    2_Product.Add Featured Products Interaction Tests
    3_UtilityFunction.Take Screenshot With Custom Name    tc_homepage_003_interaction_tests

    # Step 2: Verify interaction results
    Should Be True    ${interaction_results}[featured_products_count] > 0    No featured products found
    Log    Featured products interaction test results: ${interaction_results}

    Log    Featured products interaction tests completed successfully

# Category Navigation Tests
TC-CATEGORY-001 - Category Navigation from Homepage
    [Documentation]    Test navigation to all product categories from homepage
    [Tags]    TC-CATEGORY-001    category    navigation    smoke

    # Step 1: Test category navigation functionality
    2_Product.Test Category Navigation Functionality
    3_UtilityFunction.Take Screenshot With Custom Name    tc_category_001_navigation_complete

    Log    Category navigation from homepage test completed successfully

# Navigation Keywords Development Tests
TC-NAVIGATION-001 - Product Navigation Keywords Development
    [Documentation]    Test development of product navigation keywords
    [Tags]    TC-NAVIGATION-001    navigation    keywords    development

    # Step 1: Develop and test product navigation keywords
    ${navigation_results}=    2_Product.Develop Product Navigation Keywords
    3_UtilityFunction.Take Screenshot With Custom Name    tc_navigation_001_keywords_developed

    # Step 2: Verify navigation keyword results
    Should Not Be Empty    ${navigation_results}    Navigation keywords development failed
    Should Be Equal    ${navigation_results}[homepage_navigation]    SUCCESS

    Log    Product navigation keywords development test completed successfully

TC-NAVIGATION-002 - Category Browsing Functionality Implementation
    [Documentation]    Test implementation of category browsing functionality
    [Tags]    TC-NAVIGATION-002    navigation    implementation    browsing

    # Step 1: Implement category browsing functionality
    ${implementation_results}=    2_Product.Implement Category Browsing Functionality
    3_UtilityFunction.Take Screenshot With Custom Name    tc_navigation_002_implementation_complete

    # Step 2: Verify implementation results
    Should Not Be Empty    ${implementation_results}    Implementation failed
    Should Be True    ${implementation_results}[homepage_integration]    Homepage integration failed

    Log    Category browsing functionality implementation test completed successfully
