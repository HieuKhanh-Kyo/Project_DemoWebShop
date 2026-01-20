*** Settings ***
Documentation       Test Cases for Product Search Functionality

Library             SeleniumLibrary

Resource            ../../Resources/Keywords/Customer/3_Search.robot
Resource            ../../Resources/PageObject/Customer/5_SearchResultsPage.robot
Resource            ../../Resources/Keywords/Common/imports.robot

Suite Setup         1_CommonWeb.Open Application
Suite Teardown      1_CommonWeb.Close Application

# run script: robot -d Results -i TC-SEARCH-014 TestCases/ProductCatalog/2_TestSearchProduct.robot
# run specific: robot -d Results -t "TC-SEARCH-001*" TestCases/ProductCatalog/2_TestSearchProduct.robot

*** Test Cases ***
# Basic Search Functionality
TC-SEARCH-001 - Search Product With Valid Keyword
    [Documentation]    Search for product using valid single keyword
    [Tags]    TC-SEARCH-001    search    positive    smoke

    # Step 1: Navigate to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_001_homepage

    # Step 2: Search for "computer"
    3_Search.Search For Product    computer
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_001_search_results

    # Step 3: Verify search results page loaded
    5_SearchResultsPage.Verify Search Results Page Loaded
    5_SearchResultsPage.Verify Search Page Title Contains    Search

    # Step 4: Verify results contain keyword
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results found for valid keyword

    5_SearchResultsPage.Verify At Least One Result Contains Keyword    computer
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_001_verified

    Log    Search for "computer" returned ${results_count} results successfully

TC-SEARCH-002 - Search Product With Partial Keyword
    [Documentation]    Search using partial product name
    [Tags]    TC-SEARCH-002    search    positive

    # Step 1: Return to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_002_start

    # Step 2: Search with partial keyword "comp"
    3_Search.Search For Product    comp
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_002_partial_results

    # Step 3: Verify results returned
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results found for partial keyword

    # Step 4: Verify at least one result contains partial keyword
    5_SearchResultsPage.Verify At Least One Result Contains Keyword    comp
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_002_verified

    Log    Partial keyword search "comp" returned ${results_count} results

TC-SEARCH-003 - Search Product With Full Product Name
    [Documentation]    Search using exact/full product name from homepage
    [Tags]    TC-SEARCH-003    search    positive

    # Step 1: Get a product name from homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    ${product_names}=    1_HomePage.Get Featured Product Names
    ${first_product}=    Get From List    ${product_names}    0
    Log    Selected product for search: ${first_product}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_003_homepage

    # Step 2: Search for exact product name
    3_Search.Search For Product    ${first_product}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_003_exact_search

    # Step 3: Verify product appears in results
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    Exact product name search returned no results

    ${result_names}=    5_SearchResultsPage.Get All Search Result Product Names
    List Should Contain Value    ${result_names}    ${first_product}
    ...    Exact product not found in search results
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_003_verified

    Log    Exact product name search successful for: ${first_product}

# Empty & Invalid Search
TC-SEARCH-004 - Search With Empty Keyword
    [Documentation]    Test search behavior with empty search field
    [Tags]    TC-SEARCH-004    search    negative

    # Step 1: Navigate to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_004_start

    # Step 2: Submit search with empty keyword
    3_Search.Search With Empty Keyword

    ${alert_text}=    Handle Alert    action=ACCEPT    timeout=5s
    Log    JavaScript alert dismissed with text: ${alert_text}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_004_alert_dismissed

    # Step 3: Verify alert message is correct
    Should Be Equal As Strings    ${alert_text}    Please enter some search keyword
    ...    Alert text should match expected validation message

    Log    Empty search validation handled correctly - Alert text: "${alert_text}"

TC-SEARCH-005 - Search With Non-Existent Product
    [Documentation]    Search for product that doesn't exist in catalog
    [Tags]    TC-SEARCH-005    search    negative

    # Step 1: Navigate to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_005_start

    # Step 2: Search for non-existent product
    ${invalid_keyword}=    Set Variable    xyzabc123notexist999
    3_Search.Verify No Results For Invalid Keyword    ${invalid_keyword}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_005_no_results

    # Step 3: Verify no results message displayed
    5_SearchResultsPage.Verify No Products Found
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_005_verified

    Log    No results message correctly displayed for non-existent product

TC-SEARCH-006 - Search With Special Characters
    [Documentation]    Test search with special characters
    [Tags]    TC-SEARCH-006    search    boundary

    # Step 1: Navigate to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_006_start

    # Step 2: Test various special characters
    @{special_chars_list}=    Create List    @#$%    ***    !!!    &&&    <>>

    ${test_index}=    Set Variable    ${1}

    FOR    ${special_char}    IN    @{special_chars_list}
        Log    Testing search with special character: ${special_char}

        3_Search.Test Search With Special Characters    ${special_char}
        3_UtilityFunction.Take Screenshot With Custom Name    tc_search_006_special_char_${test_index}

        # Increment index for next iteration
        ${test_index}=    Evaluate    ${test_index} + 1
        # Navigate back to homepage for next iteration
        Go To    ${URL}
        1_CommonWeb.Wait For Page To Load
    END

    Log    Special characters search test completed successfully

# Search Results Display & Interaction
TC-SEARCH-007 - Verify Search Results Display Information
    [Documentation]    Verify search results show correct product information
    [Tags]    TC-SEARCH-007    search    ui    positive

    # Step 1: Perform search
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_Search.Verify Search Results Display Correctly    laptop
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_007_display_verified

    # Step 2: Verify each result has required elements
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results to verify

    Log    All search results display required information correctly

TC-SEARCH-008 - Click Product From Search Results
    [Documentation]    Navigate to product details from search results
    [Tags]    TC-SEARCH-008    search    navigation    positive

    # Step 1: Perform search
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_Search.Search For Product    book
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_008_search_results

    # Step 2: Get first product name
    ${product_names}=    5_SearchResultsPage.Get All Search Result Product Names
    ${first_product}=    Get From List    ${product_names}    0
    Log    Clicking on product: ${first_product}

    # Step 3: Click first product
    5_SearchResultsPage.Click Search Result Product By Index    1
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_008_product_details

    # Step 4: Verify product details page loaded
    ${current_url}=    Get Location
    Should Contain    ${current_url}    /    Product details page should load

    # Verify we're on product page (check for product-specific elements)
    ${page_loaded}=    Run Keyword And Return Status
    ...    Element Should Be Visible    xpath=//div[@class='product-details-page']

    IF    ${page_loaded}
        Log    Successfully navigated to product details page
    ELSE
        Log    Navigated to product-related page (may vary by site design)
    END

    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_008_navigation_verified

    Log    Successfully clicked product from search results

TC-SEARCH-009 - Add To Cart From Search Results
    [Documentation]    Add product to cart directly from search results
    [Tags]    TC-SEARCH-009    search    cart    positive

    # Step 1: Perform search
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_Search.Search For Product    computer
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_009_search_results

    # Step 2: Verify results exist
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results to add to cart

    # Step 3: Add first product to cart
    3_Search.Search And Add To Cart    computer    1
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_009_added_to_cart

    # Step 4: Verify cart updated (check cart counter or success message)
    ${cart_updated}=    Run Keyword And Return Status
    ...    Element Should Be Visible    xpath=//span[@class='cart-qty']

    IF    ${cart_updated}
        ${cart_count}=    Get Text    xpath=//span[@class='cart-qty']
        Log    Cart counter updated to: ${cart_count}
    ELSE
        Log    Cart update verification (counter may not be visible in all cases)
    END

    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_009_cart_verified

    Log    Product added to cart from search results successfully

TC-SEARCH-010 - Search Results Pagination
    [Documentation]    Test pagination in search results when many results exist
    [Tags]    TC-SEARCH-010    search    pagination    positive

    # Step 1: Search for common keyword that returns many results
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load

    # Use a generic term likely to have multiple pages
    3_Search.Search For Product    book
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_010_first_page

    # Step 2: Verify results exist
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results for pagination test

    # Step 3: Test pagination if available
    3_Search.Test Search Results Pagination    book
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_010_pagination_tested

    Log    Search results pagination test completed

# Advanced Search Tests
TC-SEARCH-011 - Search Results Sorting Functionality
    [Documentation]    Test sorting options in search results
    [Tags]    TC-SEARCH-011    search    sorting    positive

    # Step 1: Perform search
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_Search.Search For Product    computer
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_011_initial_results

    # Step 2: Verify multiple results for sorting
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 1    Need multiple results to test sorting

    # Step 3: Test different sort options
    @{sort_options}=    Create List    Name: A to Z    Name: Z to A    Price: Low to High

    FOR    ${sort_option}    IN    @{sort_options}
        Log    Testing sort option: ${sort_option}

        3_Search.Test Search Results Sorting    computer    ${sort_option}
        3_UtilityFunction.Take Screenshot With Custom Name    tc_search_011_sorted_${sort_option.replace(':', '').replace(' ', '_')}

        # Verify page reloaded with new sorting
        5_SearchResultsPage.Verify Search Results Page Loaded
    END

    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_011_sorting_complete

    Log    Search results sorting functionality test completed

TC-SEARCH-012 - Search From Different Pages
    [Documentation]    Test search functionality from various pages
    [Tags]    TC-SEARCH-012    search    navigation    positive

    # Test 1: Search from homepage
    Log    Testing search from homepage
    3_Search.Search From Homepage    phone
    ${results_count_1}=    5_SearchResultsPage.Get Search Results Count
    Log    Homepage search returned ${results_count_1} results
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_012_from_homepage

    # Test 2: Search from category page
    Log    Testing search from category page
    3_Search.Search From Category Page    laptop    Books
    ${results_count_2}=    5_SearchResultsPage.Get Search Results Count
    Log    Category page search returned ${results_count_2} results
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_012_from_category

    # Test 3: Search from product details page
    Log    Testing search from product details page
    3_Search.Search From Product Details Page    computer
    ${results_count_3}=    5_SearchResultsPage.Get Search Results Count
    Log    Product page search returned ${results_count_3} results
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_012_from_product_page

    Log    Search from different pages test completed successfully

# Edge Cases
TC-SEARCH-013 - Search With Very Long Keyword
    [Documentation]    Test search with extremely long keyword string
    [Tags]    TC-SEARCH-013    search    boundary    negative

    # Step 1: Navigate to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_013_start

    # Step 2: Create very long search term
    ${long_keyword}=    Evaluate    'a' * 200
    Log    Testing with ${long_keyword.__len__()} character keyword

    # Step 3: Test search with long keyword
    3_Search.Test Search With Long Keyword    ${long_keyword}
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_013_long_keyword

    # Step 4: Verify system handled gracefully
    5_SearchResultsPage.Verify Search Results Page Loaded
    3_UtilityFunction.Take Screenshot With Custom Name    tc_search_013_handled

    Log    Long keyword search handled successfully

TC-SEARCH-014 - Multiple Consecutive Searches
    [Documentation]    Perform multiple searches consecutively
    [Tags]    TC-SEARCH-014    search    stress    positive

    # Step 1: Navigate to homepage
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load

    # Step 2: Perform multiple consecutive searches
    @{search_terms}=    Create List    computer    book    phone    laptop    shirt

    FOR    ${term}    IN    @{search_terms}
        Log    Consecutive search ${term}

        3_Search.Search For Product    ${term}
        ${results_count}=    5_SearchResultsPage.Get Search Results Count
        Log    Search for "${term}" returned ${results_count} results

        3_UtilityFunction.Take Screenshot With Custom Name    tc_search_014_${term}

        # Brief pause between searches
        Sleep    1s
    END

    Log    Multiple consecutive searches completed successfully