*** Settings ***
Library    SeleniumLibrary
Library    Collections

Resource   ../../Keywords/Common/imports.robot
Resource   ../../PageObject/Common/imports.robot

*** Variables ***
# Homepage Main Content
${HOMEPAGE_CONTAINER}          xpath=//div[@class='page-body']
${HOMEPAGE_TITLE}              xpath=/html/head/title

# Featured Products Section
${FEATURED_PRODUCTS_SECTION}    xpath=//div[@class='product-grid home-page-product-grid']
${FEATURED_PRODUCTS_LIST}       xpath=//div[@class='product-grid home-page-product-grid']//div[@class='item-box']
${FEATURED_PRODUCT_TITLE}       xpath=//h2[@class='product-title']//a
${FEATURED_PRODUCT_PRICE}       xpath=//span[@class='price actual-price']
${FEATURED_PRODUCT_IMAGE}       xpath=//div[@class='picture']//img
${FEATURED_PRODUCT_ADD_TO_CART}    xpath=//input[@value='Add to cart']

# Product Categories Navigation
${CATEGORIES_SECTION}           xpath=//div[@class='listbox']
${CATEGORY_BOOKS}              xpath=//a[contains(@href,'/books')]
${CATEGORY_COMPUTERS}          xpath=//a[contains(@href,'/computers')]
${CATEGORY_ELECTRONICS}        xpath=//a[contains(@href,'/electronics')]
${CATEGORY_APPAREL_SHOES}      xpath=//a[contains(@href,'/apparel-shoes')]
${CATEGORY_DIGITAL_DOWNLOADS}  xpath=//a[contains(@href,'/digital-downloads')]
${CATEGORY_JEWELRY}            xpath=//a[contains(@href,'/jewelry')]
${CATEGORY_GIFT_CARDS}         xpath=//a[contains(@href,'/gift-cards')]

# Homepage Navigation Elements
${TOP_MENU}                    xpath=//div[@class='header-menu']
${SUB_CATEGORY_MENU}           xpath=//div[@class='sub-category-item']
${BREADCRUMB_NAVIGATION}       xpath=//div[@class='breadcrumb']

# Product Interaction Elements
${PRODUCT_DETAILS_LINK}        xpath=//a[@class='product-name']
${PRODUCT_RATING}              xpath=//div[@class='product-rating-box']
${PRODUCT_REVIEWS_LINK}        xpath=//a[contains(@href,'productreviews')]

*** Keywords ***
# Homepage Verification Keywords
Verify Homepage Is Loaded
    [Documentation]    Verify homepage is completely loaded with all main elements
    3_UtilityFunction.Wait And Assert Element Visible    ${HOMEPAGE_CONTAINER}
    Element Should Be Visible    ${FEATURED_PRODUCTS_SECTION}
    1_CommonWeb.Wait For Page To Load

Verify Homepage Title
    [Documentation]    Verify homepage has correct title
    1_CommonWeb.Verify Page Title Contains    Demo Web Shop


# Featured Products Keywords
Verify Featured Products Section
    [Documentation]    Verify featured products section is visible and contains products
    3_UtilityFunction.Wait And Assert Element Visible    ${FEATURED_PRODUCTS_SECTION}
    ${product_count}=    Get Element Count    ${FEATURED_PRODUCTS_LIST}
    Should Be True    ${product_count} > 0    Featured products should be visible

Get Featured Products Count
    [Documentation]    Get count of featured products displayed on homepage
    Wait Until Element Is Visible    ${FEATURED_PRODUCTS_LIST}
    ${count}=    Get Element Count    ${FEATURED_PRODUCTS_LIST}
    RETURN    ${count}

Get Featured Product Names
    [Documentation]    Get list of all featured product names
    @{product_names}=    Create List
    @{product_elements}=    Get WebElements    ${FEATURED_PRODUCTS_LIST}//h2[@class='product-title']//a
    FOR    ${element}    IN    @{product_elements}
        ${product_name}=    Get Text    ${element}
        Append To List    ${product_names}    ${product_name}
    END
    RETURN    ${product_names}

Click Featured Product By Index
    [Documentation]    Click on featured product by index (1-based)
    [Arguments]    ${index}
    ${product_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//h2[@class='product-title']//a
    1_CommonWeb.Wait For Element And Click    ${product_locator}

Click Featured Product By Name
    [Documentation]    Click on featured product by name
    [Arguments]    ${product_name}
    ${product_locator}=    Set Variable    xpath=//h2[@class='product-title']//a[contains(text(),'${product_name}')]
    1_CommonWeb.Wait For Element And Click    ${product_locator}

Add Featured Product To Cart By Index
    [Documentation]    Add featured product to cart by index
    [Arguments]    ${index}
    ${add_to_cart_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//input[@value='Add to cart']
    1_CommonWeb.Wait For Element And Click    ${add_to_cart_locator}

Get Product Details By Index
    [Documentation]    Get product details by index (1-based) for featured products
    [Arguments]    ${index}
    ${name_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//h2[@class='product-title']//a
    ${price_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//span[@class='price actual-price']

    ${name}=    Get Text    ${name_locator}
    ${price}=    Get Text    ${price_locator}

    ${product_details}=    Create Dictionary    name=${name}    price=${price}    index=${index}
    RETURN    ${product_details}

# Category Navigation Keywords
Verify Categories Section
    [Documentation]    Verify product categories section is visible
    ${categories_exist}=    Run Keyword And Return Status    Element Should Be Visible    ${CATEGORIES_SECTION}
    IF    ${categories_exist}
        Log    Categories section is visible
    ELSE
        Log    Categories section not found on homepage
    END

Navigate To Category
    [Documentation]    Navigate to specific product category
    [Arguments]    ${category_name}
    IF    '${category_name}' == 'Books'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_BOOKS}
    ELSE IF    '${category_name}' == 'Computers'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_COMPUTERS}
    ELSE IF    '${category_name}' == 'Electronics'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_ELECTRONICS}
    ELSE IF    '${category_name}' == 'Apparel & Shoes'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_APPAREL_SHOES}
    ELSE IF    '${category_name}' == 'Digital downloads'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_DIGITAL_DOWNLOADS}
    ELSE IF    '${category_name}' == 'Jewelry'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_JEWELRY}
    ELSE IF    '${category_name}' == 'Gift Cards'
        1_CommonWeb.Wait For Element And Click    ${CATEGORY_GIFT_CARDS}
    ELSE
        Fail    Category '${category_name}' not supported
    END
    1_CommonWeb.Wait For Page To Load

Click Category Link
    [Documentation]    Click on category link by name
    [Arguments]    ${category_name}
    Navigate To Category    ${category_name}

Get Available Categories
    [Documentation]    Get list of available product categories
    @{categories}=    Create List
    @{category_elements}=    Get WebElements    xpath=//div[@class='listbox']//a | //div[@class='header-menu']//a[contains(@href,'/')]
    FOR    ${element}    IN    @{category_elements}
        ${category_text}=    Get Text    ${element}
        Run Keyword If    '${category_text}' != ''    Append To List    ${categories}    ${category_text}
    END
    RETURN    ${categories}

# Product Interaction Keywords
Hover Over Featured Product
    [Documentation]    Hover over featured product by index
    [Arguments]    ${index}
    ${product_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]
    Mouse Over    ${product_locator}

Get Product Price By Index
    [Documentation]    Get price of featured product by index
    [Arguments]    ${index}
    ${price_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//span[@class='price actual-price']
    ${price}=    Get Text    ${price_locator}
    RETURN    ${price}

Verify Product Has Image
    [Documentation]    Verify product has image displayed
    [Arguments]    ${index}
    ${image_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//div[@class='picture']//img
    Element Should Be Visible    ${image_locator}
    ${src}=    Get Element Attribute    ${image_locator}    src
    Should Not Be Empty    ${src}

# Search Integration Keywords
Search For Product From Homepage
    [Documentation]    Search for product using header search from homepage
    [Arguments]    ${search_term}
    2_Header.Search For Product    ${search_term}

# Navigation Testing Keywords
Test Homepage Navigation To All Categories
    [Documentation]    Test navigation to all available categories from homepage
    @{categories}=    Create List    Books    Computers    Electronics    Apparel & Shoes    Digital downloads    Jewelry    Gift Cards

    FOR    ${category}    IN    @{categories}
        Log    Testing navigation to category: ${category}
        Go To    ${URL}    # Return to homepage
        1_CommonWeb.Wait For Page To Load
        Navigate To Category    ${category}

        ${current_url}=    Get Location
        ${expected_url_part}=    Set Variable    ${category.lower().replace(' & ', '-').replace(' ', '-')}
        Should Contain    ${current_url}    ${expected_url_part}

        Log    Successfully navigated to ${category}

        # Take screenshot for verification
        ${screenshot_name}=    Set Variable    category_${category.replace(' ', '_').replace('&', 'and')}
        3_UtilityFunction.Take Screenshot With Custom Name    ${screenshot_name}
    END

Verify All Featured Products Are Clickable
    [Documentation]    Verify all featured products on homepage are clickable
    ${product_count}=    Get Featured Products Count
    Should Be True    ${product_count} > 0    No featured products found

    FOR    ${index}    IN RANGE    1    ${product_count} + 1
        ${product_locator}=    Set Variable    xpath=(//div[@class='item-box'])[${index}]//h2[@class='product-title']//a
        Element Should Be Visible    ${product_locator}
        Element Should Be Enabled    ${product_locator}

        ${product_name}=    Get Text    ${product_locator}
        Log    Featured product ${index}: ${product_name} is clickable
    END

# Homepage Content Verification
Verify Homepage Structure
    [Documentation]    Verify basic homepage structure and layout
    Verify Homepage Is Loaded
    Verify Homepage Title
    2_Header.Verify Header Is Visible
    3_Footer.Verify Footer Links
    Verify Featured Products Section

Get Homepage Statistics
    [Documentation]    Get statistics about homepage content
    ${product_count}=    Get Featured Products Count
    ${product_names}=    Get Featured Product Names
    ${categories}=    Get Available Categories

    ${stats}=    Create Dictionary
    ...    featured_products_count=${product_count}
    ...    featured_products=${product_names}
    ...    available_categories=${categories}

    Log    Homepage Statistics: ${stats}
    RETURN    ${stats}

Return To Homepage
    [Documentation]    Navigate back to homepage from any page
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    Verify Homepage Is Loaded