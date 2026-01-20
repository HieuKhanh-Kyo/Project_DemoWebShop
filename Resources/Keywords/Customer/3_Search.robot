*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String

Resource    ../../PageObject/Common/2_Header.robot
Resource    ../../PageObject/Customer/1_HomePage.robot
Resource    ../../PageObject/Customer/5_SearchResultsPage.robot
Resource    ../Common/imports.robot

*** Variables ***
# Common search terms for testing
@{VALID_SEARCH_TERMS}    computer    book    laptop    phone    shirt
@{PARTIAL_SEARCH_TERMS}    comp    lap    boo
@{INVALID_SEARCH_TERMS}    xyzabc123notexist    qwerty9999    zzzzzz999

*** Keywords ***
# Basic Search Keywords
Search For Product
    [Documentation]    Perform a product search using header search box
    [Arguments]    ${search_term}
    2_Header.Search For Product    ${search_term}
    1_CommonWeb.Wait For Page To Load
    5_SearchResultsPage.Verify Search Results Page Loaded

Search And Verify Results Page
    [Documentation]    Search and verify results page loaded successfully
    [Arguments]    ${search_term}
    Search For Product    ${search_term}
    5_SearchResultsPage.Verify Search Page Title Contains    Search

Search With Empty Keyword
    [Documentation]    Attempt to search with empty keyword
    2_Header.Search For Product    ${EMPTY}
#    1_CommonWeb.Wait For Page To Load

# Search Verification Keywords
Verify Search Results For Keyword
    [Documentation]    Search and verify results contain keyword
    [Arguments]    ${keyword}
    Search For Product    ${keyword}
    ${results_count}=    5_SearchResultsPage.Get Search Results Count

    IF    ${results_count} > 0
        5_SearchResultsPage.Verify At Least One Result Contains Keyword    ${keyword}
        Log    Search for "${keyword}" returned ${results_count} results
    ELSE
        Log    Search for "${keyword}" returned no results
        5_SearchResultsPage.Verify No Results Message
    END
    RETURN    ${results_count}

Verify Search Results Display Correctly
    [Documentation]    Verify search results display all required elements
    [Arguments]    ${search_term}
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    IF    ${results_count} > 0
        5_SearchResultsPage.Verify Search Results Have Images
        5_SearchResultsPage.Verify Search Results Have Prices
        5_SearchResultsPage.Verify Search Results Have Add To Cart Buttons
        Log    All ${results_count} search results display correctly
    ELSE
        Log    No results to verify display for
    END

Verify No Results For Invalid Keyword
    [Documentation]    Search with invalid keyword and verify no results
    [Arguments]    ${invalid_keyword}
    Search For Product    ${invalid_keyword}
    5_SearchResultsPage.Verify No Products Found
    5_SearchResultsPage.Verify No Results Message
    Log    No results message displayed for invalid keyword: ${invalid_keyword}

# Advanced Search Keywords
Search And Navigate To Product Details
    [Documentation]    Search for product and navigate to details page
    [Arguments]    ${search_term}    ${product_index}=1
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} >= ${product_index}    Not enough results

    5_SearchResultsPage.Click Search Result Product By Index    ${product_index}
    1_CommonWeb.Wait For Page To Load
    Log    Navigated to product details from search results

Search And Add To Cart
    [Documentation]    Search for product and add to cart from results
    [Arguments]    ${search_term}    ${product_index}=1
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} >= ${product_index}    Not enough results

    5_SearchResultsPage.Add To Cart From Search Results By Index    ${product_index}
    1_CommonWeb.Wait For Page To Load
    Log    Added product from search results to cart

# Empty Search Handling
Search With Empty Keyword And Handle Alert
    [Documentation]    Attempt to search with empty keyword and handle alert if present
    ${search_box}=    Set Variable    ${HEADER_SEARCH_BOX}
    ${search_button}=    Set Variable    ${HEADER_SEARCH_BUTTON}

    # Clear and attempt empty search
    Clear Element Text    ${search_box}
    Click Element    ${search_button}

    # IMPORTANT: Handle alert IMMEDIATELY before any other operations
    Sleep    0.5s    # Brief wait for alert to appear
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=2s

    IF    ${alert_present}
        ${alert_text}=    Handle Alert    action=ACCEPT
        Log    Alert dismissed with text: ${alert_text}
        Should Contain    ${alert_text}    search    ignore_case=True
        # After accepting alert, we're back to original page - no need to wait
        RETURN    alert_handled
    ELSE
        # No alert means page navigated - wait for page load
        1_CommonWeb.Wait For Page To Load
        Log    No alert - page handled empty search differently
        RETURN    no_alert
    END

# Search with Special Cases
Test Search With Special Characters
    [Documentation]    Test search functionality with special characters
    [Arguments]    ${special_chars}
    Search For Product    ${special_chars}
    1_CommonWeb.Wait For Page To Load

    # Verify page loads without error
    ${page_loaded}=    Run Keyword And Return Status
    ...    5_SearchResultsPage.Verify Search Results Page Loaded
    Should Be True    ${page_loaded}    Page did not load with special characters
    Log    Search handled special characters gracefully: ${special_chars}

Test Search With Long Keyword
    [Documentation]    Test search with very long keyword
    [Arguments]    ${long_keyword}
    Search For Product    ${long_keyword}
    1_CommonWeb.Wait For Page To Load

    ${page_loaded}=    Run Keyword And Return Status
    ...    5_SearchResultsPage.Verify Search Results Page Loaded
    Should Be True    ${page_loaded}    Page did not load with long keyword
    Log    Search handled long keyword: ${long_keyword}

# Search Results Interaction
Get Product Names From Search Results
    [Documentation]    Get all product names from current search results
    ${product_names}=    5_SearchResultsPage.Get All Search Result Product Names
    Log    Found ${product_names.__len__()} products in search results
    RETURN    ${product_names}

Get First Product Name From Search
    [Documentation]    Search and get first product name from results
    [Arguments]    ${search_term}
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results found

    ${product_names}=    5_SearchResultsPage.Get All Search Result Product Names
    ${first_product}=    Get From List    ${product_names}    0
    RETURN    ${first_product}

# Search Sorting Tests
Test Search Results Sorting
    [Documentation]    Test sorting functionality in search results
    [Arguments]    ${search_term}    ${sort_option}
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results to sort

    5_SearchResultsPage.Change Search Results Sort Order    ${sort_option}
    1_CommonWeb.Wait For Page To Load

    # Verify page reloaded with sorting applied
    5_SearchResultsPage.Verify Search Results Page Loaded
    Log    Search results sorted by: ${sort_option}

Test Search Results Page Size
    [Documentation]    Test page size change in search results
    [Arguments]    ${search_term}    ${page_size}
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results for page size test

    5_SearchResultsPage.Change Search Results Page Size    ${page_size}
    1_CommonWeb.Wait For Page To Load

    ${new_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${new_count} <= ${page_size}    Page size not applied correctly
    Log    Page size changed to: ${page_size}, showing ${new_count} results

# Search Pagination Tests
Test Search Results Pagination
    [Documentation]    Test pagination in search results
    [Arguments]    ${search_term}
    Search For Product    ${search_term}

    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Should Be True    ${results_count} > 0    No results for pagination test

    # Try to go to next page
    ${next_page_success}=    Run Keyword And Return Status
    ...    5_SearchResultsPage.Go To Next Search Results Page

    IF    ${next_page_success}
        Log    Successfully navigated to next page of search results
        5_SearchResultsPage.Verify Search Results Page Loaded

        # Try to go back
        5_SearchResultsPage.Go To Previous Search Results Page
        5_SearchResultsPage.Verify Search Results Page Loaded
        Log    Successfully navigated back to previous page
    ELSE
        Log    Only one page of search results available
    END

# Comprehensive Search Test
Perform Comprehensive Search Test
    [Documentation]    Perform comprehensive search functionality test
    [Arguments]    ${search_term}

    # Step 1: Search
    Search For Product    ${search_term}
    3_UtilityFunction.Take Screenshot With Custom Name    search_${search_term}_results

    # Step 2: Verify results count
    ${results_count}=    5_SearchResultsPage.Get Search Results Count
    Log    Search returned ${results_count} results

    IF    ${results_count} > 0
        # Step 3: Verify display
        5_SearchResultsPage.Verify Search Results Have Images
        5_SearchResultsPage.Verify Search Results Have Prices

        # Step 4: Get product names
        ${product_names}=    Get Product Names From Search Results
        Log    Products found: ${product_names}

        # Step 5: Test interaction
        ${first_product_price}=    5_SearchResultsPage.Get Search Result Product Price By Index    1
        Log    First product price: ${first_product_price}

        RETURN    ${results_count}
    ELSE
        5_SearchResultsPage.Verify No Results Message
        Log    No results found for: ${search_term}
        RETURN    0
    END

# Search from Different Pages
Search From Homepage
    [Documentation]    Perform search from homepage
    [Arguments]    ${search_term}
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    Search For Product    ${search_term}

Search From Category Page
    [Documentation]    Perform search from category page
    [Arguments]    ${search_term}    ${category}=Books
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    1_HomePage.Navigate To Category    ${category}
    1_CommonWeb.Wait For Page To Load
    Search For Product    ${search_term}

Search From Product Details Page
    [Documentation]    Perform search from product details page
    [Arguments]    ${search_term}
    # Navigate to any product first
    Go To    ${URL}
    1_HomePage.Click Featured Product By Index    1
    1_CommonWeb.Wait For Page To Load
    Search For Product    ${search_term}

# Validation Keywords
Verify Search Input Accepts Text
    [Documentation]    Verify search input field accepts text input
    [Arguments]    ${test_text}
    ${search_box}=    Set Variable    ${HEADER_SEARCH_BOX}
    Element Should Be Visible    ${search_box}
    Element Should Be Enabled    ${search_box}
    Input Text    ${search_box}    ${test_text}
    ${value}=    Get Value    ${search_box}
    Should Be Equal    ${value}    ${test_text}
    Log    Search input accepts text correctly

Verify Search Button Clickable
    [Documentation]    Verify search button is clickable
    ${search_button}=    Set Variable    ${HEADER_SEARCH_BUTTON}
    Element Should Be Visible    ${search_button}
    Element Should Be Enabled    ${search_button}
    Log    Search button is visible and clickable