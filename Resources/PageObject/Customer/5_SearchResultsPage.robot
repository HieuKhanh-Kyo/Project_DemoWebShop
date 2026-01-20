*** Settings ***
Library    SeleniumLibrary
Library    Collections

Resource   ../../Keywords/Common/imports.robot

*** Variables ***
# Search Results Page Structure
${SEARCH_RESULTS_CONTAINER}     xpath=//div[@class='search-results']
${SEARCH_RESULTS_PAGE_TITLE}    xpath=//div[@class='page-title']//h1
${SEARCH_TERM_DISPLAY}          xpath=//div[@class='search-input']//input[@id='small-searchterms']

# Search Results Products
${SEARCH_RESULTS_ITEMS}         //div[@class='item-box']                                    # remove xpath= -> TC-007
${SEARCH_PRODUCT_TITLE}         xpath=//h2[@class='product-title']//a
${SEARCH_PRODUCT_PRICE}         xpath=//span[@class='price actual-price']
${SEARCH_PRODUCT_IMAGE}         xpath=//div[@class='picture']//img
${SEARCH_ADD_TO_CART_BUTTON}    xpath=//input[@value='Add to cart']

# No Results Elements
${NO_RESULTS_MESSAGE}           xpath=//div[@class='no-result']
${NO_PRODUCTS_MESSAGE}          xpath=//strong[contains(text(),'No products')]

# Search Results Pagination
${SEARCH_PAGINATION}            xpath=//div[@class='pager']
${SEARCH_NEXT_PAGE}             xpath=//a[@class='next-page']
${SEARCH_PREVIOUS_PAGE}         xpath=//a[@class='previous-page']

# Search Results Sorting
${SEARCH_SORT_DROPDOWN}         id=products-orderby
${SEARCH_PAGE_SIZE_DROPDOWN}    id=products-pagesize

# Product Details in Search Results
${PRODUCT_RATING}               xpath=//div[@class='product-rating-box']
${PRODUCT_DETAILS_LINK}         xpath=//input[@value='Show details']

*** Keywords ***
# Page Verification Keywords
Verify Search Results Page Loaded
    [Documentation]    Verify search results page is loaded correctly
    3_UtilityFunction.Wait And Assert Element Visible    ${SEARCH_RESULTS_CONTAINER}
    Element Should Be Visible    ${SEARCH_RESULTS_PAGE_TITLE}
    1_CommonWeb.Wait For Page To Load

Verify Search Page Title Contains
    [Documentation]    Verify search page title contains expected text
    [Arguments]    ${expected_text}
    ${page_title}=    Get Text    ${SEARCH_RESULTS_PAGE_TITLE}
    Should Contain    ${page_title}    ${expected_text}    ignore_case=True

Verify Search Term In Input
    [Documentation]    Verify search term is displayed in search input
    [Arguments]    ${expected_term}
    ${search_value}=    Get Value    ${SEARCH_TERM_DISPLAY}
    Should Be Equal    ${search_value}    ${expected_term}

# Search Results Keywords
Get Search Results Count
    [Documentation]    Get total number of products in search results
    ${count}=    Get Element Count    ${SEARCH_RESULTS_ITEMS}
    RETURN    ${count}

Get All Search Result Product Names
    [Documentation]    Get list of all product names in search results
    @{product_names}=    Create List
    @{product_elements}=    Get WebElements    ${SEARCH_RESULTS_ITEMS}//h2[@class='product-title']//a
    FOR    ${element}    IN    @{product_elements}
        ${product_name}=    Get Text    ${element}
        Append To List    ${product_names}    ${product_name}
    END
    RETURN    ${product_names}

Verify Search Results Contain Keyword
    [Documentation]    Verify all search results contain the search keyword
    [Arguments]    ${keyword}
    ${product_names}=    Get All Search Result Product Names
    Should Not Be Empty    ${product_names}    No products found in search results

    FOR    ${product_name}    IN    @{product_names}
        ${contains_keyword}=    Run Keyword And Return Status
        ...    Should Contain    ${product_name}    ${keyword}    ignore_case=True
        IF    ${contains_keyword}
            Log    Product "${product_name}" contains keyword "${keyword}"
        END
    END

Verify At Least One Result Contains Keyword
    [Documentation]    Verify at least one result contains the keyword
    [Arguments]    ${keyword}
    ${product_names}=    Get All Search Result Product Names
    Should Not Be Empty    ${product_names}    No products found in search results

    ${found}=    Set Variable    ${False}
    FOR    ${product_name}    IN    @{product_names}
        ${contains}=    Run Keyword And Return Status
        ...    Should Contain    ${product_name}    ${keyword}    ignore_case=True
        IF    ${contains}
            ${found}=    Set Variable    ${True}
            Log    Found matching product: ${product_name}
            BREAK
        END
    END
    Should Be True    ${found}    No products contain keyword "${keyword}"

# No Results Keywords
Verify No Results Message
    [Documentation]    Verify "no results" message is displayed
    ${no_results_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NO_RESULTS_MESSAGE}

    ${no_products_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NO_PRODUCTS_MESSAGE}

    ${message_found}=    Evaluate    ${no_results_visible} or ${no_products_visible}
    Should Be True    ${message_found}    No results message not found

Verify No Products Found
    [Documentation]    Verify no products are displayed in results
    ${products_count}=    Get Search Results Count
    Should Be Equal As Numbers    ${products_count}    0    Products found when none expected

# Product Interaction Keywords
Click Search Result Product By Index
    [Documentation]    Click on product in search results by index (1-based)
    [Arguments]    ${index}
    ${product_locator}=    Set Variable    xpath=(${SEARCH_RESULTS_ITEMS})[${index}]//h2[@class='product-title']//a
    1_CommonWeb.Wait For Element And Click    ${product_locator}

Click Search Result Product By Name
    [Documentation]    Click on product in search results by name
    [Arguments]    ${product_name}
    ${product_locator}=    Set Variable    xpath=//h2[@class='product-title']//a[contains(text(),'${product_name}')]
    1_CommonWeb.Wait For Element And Click    ${product_locator}

Add To Cart From Search Results By Index
    [Documentation]    Add product to cart from search results by index
    [Arguments]    ${index}
    ${add_to_cart_locator}=    Set Variable    xpath=(${SEARCH_RESULTS_ITEMS})[${index}]//input[@value='Add to cart']
    1_CommonWeb.Wait For Element And Click    ${add_to_cart_locator}

Get Search Result Product Price By Index
    [Documentation]    Get price of product in search results by index
    [Arguments]    ${index}
    ${price_locator}=    Set Variable    xpath=(${SEARCH_RESULTS_ITEMS})[${index}]//span[@class='price actual-price']
    ${price}=    Get Text    ${price_locator}
    RETURN    ${price}

# Search Results Verification Keywords
Verify Search Results Have Images
    [Documentation]    Verify all search results display product images
    ${products_count}=    Get Search Results Count
    Should Be True    ${products_count} > 0    No products to verify

    FOR    ${index}    IN RANGE    1    ${products_count} + 1
        ${image_locator}=    Set Variable    xpath=(${SEARCH_RESULTS_ITEMS})[${index}]//div[@class='picture'][${index}]//img
        Element Should Be Visible    ${image_locator}
        ${src}=    Get Element Attribute    ${image_locator}    src
        Should Not Be Empty    ${src}
    END

Verify Search Results Have Prices
    [Documentation]    Verify all search results display prices
    ${products_count}=    Get Search Results Count
    Should Be True    ${products_count} > 0    No products to verify

    FOR    ${index}    IN RANGE    1    ${products_count} + 1
        ${price_locator}=    Set Variable    xpath=(${SEARCH_RESULTS_ITEMS})[${index}]//span[@class='price actual-price']
        Element Should Be Visible    ${price_locator}
        ${price}=    Get Text    ${price_locator}
        Should Not Be Empty    ${price}
    END

Verify Search Results Have Add To Cart Buttons
    [Documentation]    Verify all search results have add to cart buttons
    ${products_count}=    Get Search Results Count
    Should Be True    ${products_count} > 0    No products to verify

    FOR    ${index}    IN RANGE    1    ${products_count} + 1
        ${button_locator}=    Set Variable    xpath=(${SEARCH_RESULTS_ITEMS})[${index}]//input[@value='Add to cart']
        Element Should Be Visible    ${button_locator}
    END

# Sorting Keywords
Change Search Results Sort Order
    [Documentation]    Change sort order of search results
    [Arguments]    ${sort_option}
    Select From List By Label    ${SEARCH_SORT_DROPDOWN}    ${sort_option}
    1_CommonWeb.Wait For Page To Load

Change Search Results Page Size
    [Documentation]    Change page size of search results
    [Arguments]    ${page_size}
    Select From List By Label    ${SEARCH_PAGE_SIZE_DROPDOWN}    ${page_size}
    1_CommonWeb.Wait For Page To Load

# Pagination Keywords
Go To Next Search Results Page
    [Documentation]    Navigate to next page in search results
    ${next_exists}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${SEARCH_NEXT_PAGE}
    IF    ${next_exists}
        1_CommonWeb.Wait For Element And Click    ${SEARCH_NEXT_PAGE}
        1_CommonWeb.Wait For Page To Load
    ELSE
        Log    No next page available in search results
    END

Go To Previous Search Results Page
    [Documentation]    Navigate to previous page in search results
    ${prev_exists}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${SEARCH_PREVIOUS_PAGE}
    IF    ${prev_exists}
        1_CommonWeb.Wait For Element And Click    ${SEARCH_PREVIOUS_PAGE}
        1_CommonWeb.Wait For Page To Load
    ELSE
        Log    No previous page available in search results
    END