*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String

Resource   ../../Keywords/Common/imports.robot
Resource   ../../PageObject/Common/imports.robot

*** Variables ***
# Product Listing Page Structure
${PRODUCT_LISTING_CONTAINER}    xpath=//div[@class='page category-page']
${PRODUCT_GRID}                xpath=//div[@class='product-grid']
${PRODUCT_LIST}                xpath=//div[@class='product-grid']
${PRODUCT_ITEMS}               xpath=//div[@class='item-box']

# Category Page Elements
${CATEGORY_TITLE}              xpath=//div[@class='page-title']//h1
${CATEGORY_DESCRIPTION}        xpath=//div[@class='category-description']
${SUB_CATEGORIES}              xpath=//div[@class='sub-category-item']
${SUB_CATEGORY_TITLE}          xpath=//h2[@class='sub-category-title']//a

# Sorting and Filtering
${SORT_DROPDOWN}               id=products-orderby
${PAGE_SIZE_DROPDOWN}          id=products-pagesize
${VIEW_MODE_GRID}              xpath=//a[@title='Grid']
${VIEW_MODE_LIST}              xpath=//a[@title='List']

# Pagination Elements
${PAGINATION_CONTAINER}        xpath=//div[@class='pager']
${PAGINATION_PREVIOUS}         xpath=//a[@class='previous-page']
${PAGINATION_NEXT}             xpath=//a[@class='next-page']
${PAGINATION_PAGES}            xpath=//div[@class='individual-page']//a
${PAGINATION_CURRENT_PAGE}     xpath=//li[@class='current-page']

*** Keywords ***
# Page Verification Keywords
Verify Product Listing Page Loaded
    [Documentation]    Verify product listing page is loaded correctly
    3_UtilityFunction.Wait And Assert Element Visible    ${PRODUCT_LISTING_CONTAINER}
    Element Should Be Visible    ${CATEGORY_TITLE}
    1_CommonWeb.Wait For Page To Load

Verify Category Title
    [Documentation]    Verify category page title matches expected category
    [Arguments]    ${expected_category}
    ${actual_title}=    Get Text    ${CATEGORY_TITLE}
    Should Contain    ${actual_title}    ${expected_category}    ignore_case=True

Get Category Title
    [Documentation]    Get the current category page title
    ${title}=    Get Text    ${CATEGORY_TITLE}
    RETURN    ${title}

# Product Listing Keywords
Get Products Count
    [Documentation]    Get total number of products displayed on current page
    ${count}=    Get Element Count    ${PRODUCT_ITEMS}
    RETURN    ${count}

Get All Product Names
    [Documentation]    Get list of all product names on current page
    @{product_names}=    Create List
    @{product_elements}=    Get WebElements    ${PRODUCT_ITEMS}//h2[@class='product-title']//a
    FOR    ${element}    IN    @{product_elements}
        ${product_name}=    Get Text    ${element}
        Append To List    ${product_names}    ${product_name}
    END
    RETURN    ${product_names}

# Product Interaction Keywords
Click Product By Index
    [Documentation]    Click on product by index (1-based)
    [Arguments]    ${index}
    ${product_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//h2[@class='product-title']//a
    1_CommonWeb.Wait For Element And Click    ${product_locator}

Click Product By Name
    [Documentation]    Click on product by name
    [Arguments]    ${product_name}
    ${product_locator}=    Set Variable    xpath=//h2[@class='product-title']//a[contains(text(),'${product_name}')]
    1_CommonWeb.Wait For Element And Click    ${product_locator}

Add Product To Cart By Index
    [Documentation]    Add product to cart by index
    [Arguments]    ${index}
    ${add_to_cart_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//input[@value='Add to cart']
    1_CommonWeb.Wait For Element And Click    ${add_to_cart_locator}

Add Product To Wishlist By Index
    [Documentation]    Add product to wishlist by index
    [Arguments]    ${index}
    ${add_to_wishlist_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//input[@value='Add to wishlist']
    1_CommonWeb.Wait For Element And Click    ${add_to_wishlist_locator}

Add Product To Compare By Index
    [Documentation]    Add product to compare list by index
    [Arguments]    ${index}
    ${add_to_compare_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//input[@value='Add to compare list']
    1_CommonWeb.Wait For Element And Click    ${add_to_compare_locator}

# Sorting and View Mode Keywords
Change Sort Order
    [Documentation]    Change product sort order
    [Arguments]    ${sort_option}
    # sort_option examples: 'Name: A to Z', 'Name: Z to A', 'Price: Low to High', 'Price: High to Low'
    Select From List By Label    ${SORT_DROPDOWN}    ${sort_option}
    1_CommonWeb.Wait For Page To Load

Change Page Size
    [Documentation]    Change number of products displayed per page
    [Arguments]    ${page_size}
    # page_size examples: 4, 8, 12
    Select From List By Label    ${PAGE_SIZE_DROPDOWN}    ${page_size}
    1_CommonWeb.Wait For Page To Load

Switch To Grid View
    [Documentation]    Switch to grid view mode
    1_CommonWeb.Wait For Element And Click    ${VIEW_MODE_GRID}

Switch To List View
    [Documentation]    Switch to list view mode
    1_CommonWeb.Wait For Element And Click    ${VIEW_MODE_LIST}

Get Current Sort Order
    [Documentation]    Get currently selected sort order
    ${selected_option}=    Get Selected List Label    ${SORT_DROPDOWN}
    RETURN    ${selected_option}

Get Current Page Size
    [Documentation]    Get currently selected page size
    ${selected_size}=    Get Selected List Label    ${PAGE_SIZE_DROPDOWN}
    RETURN    ${selected_size}

# Pagination Keywords
Get Current Page Number
    [Documentation]    Get current page number with safe error handling
    TRY
        ${current_page}=    Get Text    ${PAGINATION_CURRENT_PAGE}
        RETURN    ${current_page}
    EXCEPT
        Log    No pagination found or element not visible, returning default page 1
        RETURN    1
    END

Go To Next Page
    [Documentation]    Navigate to next page of products
    ${next_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${PAGINATION_NEXT}
    IF    ${next_exists}
        1_CommonWeb.Wait For Element And Click    ${PAGINATION_NEXT}
        1_CommonWeb.Wait For Page To Load
    ELSE
        Log    No next page available
    END

Go To Previous Page
    [Documentation]    Navigate to previous page of products
    ${prev_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${PAGINATION_PREVIOUS}
    IF    ${prev_exists}
        1_CommonWeb.Wait For Element And Click    ${PAGINATION_PREVIOUS}
        1_CommonWeb.Wait For Page To Load
    ELSE
        Log    No previous page available
    END

Go To Page Number
    [Documentation]    Navigate to specific page number
    [Arguments]    ${page_number}
    ${page_locator}=    Set Variable    xpath=//div[@class='individual-page']//a[text()='${page_number}']
    ${page_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${page_locator}
    IF    ${page_exists}
        1_CommonWeb.Wait For Element And Click    ${page_locator}
        1_CommonWeb.Wait For Page To Load
    ELSE
        Log    Page ${page_number} not available
    END

Get Available Page Numbers
    [Documentation]    Get list of available page numbers
    @{page_numbers}=    Create List
    @{page_elements}=    Get WebElements    ${PAGINATION_PAGES}
    FOR    ${element}    IN    @{page_elements}
        ${page_num}=    Get Text    ${element}
        Append To List    ${page_numbers}    ${page_num}
    END
    RETURN    ${page_numbers}


# Product Verification Keywords
Verify All Products Have Images
    [Documentation]    Verify all products on page have images
    ${product_count}=    Get Products Count
    FOR    ${index}    IN RANGE    1    ${product_count}+ 1
        ${image_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//div[@class='picture']//img
        Element Should Be Visible    ${image_locator}
        ${src}=    Get Element Attribute    ${image_locator}    src
        Should Not Be Empty    ${src}
    END

Verify All Products Have Prices
    [Documentation]    Verify all products on page have prices displayed
    ${product_count}=    Get Products Count
    FOR    ${index}    IN RANGE    1    ${product_count}+ 1
        ${price_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//span[@class='price actual-price']
        Element Should Be Visible    ${price_locator}
        ${price_text}=    Get Text    ${price_locator}
        Should Not Be Empty    ${price_text}
    END

Verify All Products Are Clickable
    [Documentation]    Verify all product titles are clickable
    ${product_count}=    Get Products Count
    FOR    ${index}    IN RANGE    1    ${product_count}+ 1
        ${product_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//h2[@class='product-title']//a
        Element Should Be Visible    ${product_locator}
        Element Should Be Enabled    ${product_locator}
    END

# Category Testing Keywords
Test Category Navigation
    [Documentation]    Test navigation through all pages in current category
    ${current_page}=    Get Current Page Number
    Log    Starting category navigation test from page ${current_page}

    # Test next page navigation
    ${page_num}=    Convert To Integer    ${current_page}
    WHILE    True
        ${next_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${PAGINATION_NEXT}
        IF    not ${next_exists}    BREAK
        Go To Next Page
        ${page_num}=    Evaluate    ${page_num} + 1
        Log    Navigated to page ${page_num}
    END

    # Go back to first page
    Go To Page Number    1
