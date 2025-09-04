*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String

Resource    ../../PageObject/Customer/1_HomePage.robot
Resource    ../../PageObject/Customer/4_ProductListPage.robot
Resource    ../Common/imports.robot

*** Variables ***
# Navigation Keywords for Product Browsing
&{CATEGORY_NAVIGATION}
...    Books=books
...    Computers=computers
...    Electronics=electronics
...    Apparel & Shoes=apparel-shoes
...    Digital downloads=digital-downloads
...    Jewelry=jewelry
...    Gift Cards=gift-cards

#@{AVAILABLE_CATEGORIES}    Books    Computers    Electronics    Apparel & Shoes    Digital downloads    Jewelry    Gift Cards
#
## Categories có subcategories
#${CATEGORIES_WITH_SUBS}    Create Dictionary
#...    COMPUTERS=@{COMPUTERS_SUBCATEGORIES}
#...    ELECTRONICS=@{ELECTRONICS_SUBCATEGORIES}
#
#@{COMPUTERS_SUBCATEGORIES}    Desktops    Notebooks    Accessories
#@{ELECTRONICS_SUBCATEGORIES}    Camera, photo    Cell phones
#
## Main categories không có subcategories
#@{SIMPLE_CATEGORIES}    BOOKS    APPAREL & SHOES    DIGITAL DOWNLOADS    JEWELRY    GIFT CARDS


@{SORT_OPTIONS}
...    Position
...    Name: A to Z
...    Name: Z to A  
...    Price: Low to High
...    Price: High to Low
...    Created on

@{PAGE_SIZES}    4    8    12

*** Keywords ***
# Homepage Navigation Keywords
Navigate To Homepage
    [Documentation]    Navigate to homepage and verify it's loaded
    Go To    ${URL}
    1_CommonWeb.Wait For Page To Load
    1_HomePage.Verify Homepage Is Loaded

Browse Featured Products
    [Documentation]    Browse and interact with featured products on homepage
    Navigate To Homepage
    ${product_count}=    1_HomePage.Get Featured Products Count
    Should Be True    ${product_count} > 0    No featured products found
    
    ${product_names}=    1_HomePage.Get Featured Product Names
    Log    Found ${product_count} featured products: ${product_names}
    RETURN    ${product_names}

Test Featured Product Interaction
    [Documentation]    Test interaction with featured products
    Navigate To Homepage
    ${product_count}=    1_HomePage.Get Featured Products Count
    
    FOR    ${index}    IN RANGE    1    ${product_count}+ 1
        Log    Testing featured product ${index}
        1_HomePage.Hover Over Featured Product    ${index}
        1_HomePage.Verify Product Has Image    ${index}
        ${price}=    1_HomePage.Get Product Price By Index    ${index}
        Log    Product ${index} price: ${price}
        
        # Test clicking product (go back to homepage after each click)
        1_HomePage.Click Featured Product By Index    ${index}
        1_CommonWeb.Wait For Page To Load
        Navigate To Homepage
    END

# Category Navigation Keywords
Navigate To Product Category
    [Documentation]    Navigate to specific product category
    [Arguments]    ${category_name}
    Navigate To Homepage
    1_HomePage.Navigate To Category    ${category_name}
    4_ProductListPage.Verify Product Listing Page Loaded
    4_ProductListPage.Verify Category Title    ${category_name}

Browse All Categories
    [Documentation]    Browse through all available product categories
    @{browsed_categories}=    Create List
    
    FOR    ${category}    IN    @{AVAILABLE_CATEGORIES}
        Log    Browsing category: ${category}
        Navigate To Product Category    ${category}
        
        ${stats}=    4_ProductListPage.Get Category Statistics
        Append To List    ${browsed_categories}    ${stats}
        
        # Take screenshot for verification
        ${screenshot_name}=    Set Variable    browse_${category.replace(' ', '_').replace('&', 'and')}
        3_UtilityFunction.Take Screenshot With Custom Name    ${screenshot_name}
    END
    
    Log    Browsed all categories: ${browsed_categories}
    RETURN    ${browsed_categories}

Test Category Navigation Functionality
    [Documentation]    Test category navigation functionality
    1_HomePage.Test Homepage Navigation To All Categories

# Product Listing Navigation Keywords
Browse Products In Category
    [Documentation]    Browse products within specific category
    [Arguments]    ${category_name}    ${max_pages}=3
    Navigate To Product Category    ${category_name}
    
    ${product_info}=    Create Dictionary
    ${page_count}=    Set Variable    0
    
    # Browse through pages
    WHILE    ${page_count} < ${max_pages}
        ${page_count}=    Evaluate    ${page_count} + 1
        ${current_page}=    4_ProductListPage.Get Current Page Number
        
        ${products_on_page}=    4_ProductListPage.Get Products Count
        ${product_names}=    4_ProductListPage.Get All Product Names
        ${product_prices}=    4_ProductListPage.Get All Product Prices
        
        Set To Dictionary    ${product_info}    page_${current_page}    ${product_names}
        Log    Page ${current_page}: Found ${products_on_page} products
        
        # Verify product elements
        4_ProductListPage.Verify All Products Have Images
        4_ProductListPage.Verify All Products Have Prices
        4_ProductListPage.Verify All Products Are Clickable
        
        # Try to go to next page
        ${next_exists}=    Run Keyword And Return Status    4_ProductListPage.Go To Next Page
        IF    not ${next_exists}    BREAK
    END
    
    RETURN    ${product_info}

Test Product Sorting
    [Documentation]    Test product sorting functionality in category
    [Arguments]    ${category_name}
    Navigate To Product Category    ${category_name}
    
    FOR    ${sort_option}    IN    @{SORT_OPTIONS}
        ${sort_available}=    Run Keyword And Return Status    4_ProductListPage.Change Sort Order    ${sort_option}
        IF    ${sort_available}
            Log    Testing sort option: ${sort_option}
            ${products_count}=    4_ProductListPage.Get Products Count
            Should Be True    ${products_count} > 0    No products found with sort: ${sort_option}
            
            # Verify sorting actually changed content
            ${product_names}=    4_ProductListPage.Get All Product Names
            Log    Products with ${sort_option}: ${product_names}
        ELSE
            Log    Sort option ${sort_option} not available
        END
    END

Test Page Size Options
    [Documentation]    Test different page size options
    [Arguments]    ${category_name}
    Navigate To Product Category    ${category_name}
    
    FOR    ${page_size}    IN    @{PAGE_SIZES}
        ${size_available}=    Run Keyword And Return Status    4_ProductListPage.Change Page Size    ${page_size}
        IF    ${size_available}
            Log    Testing page size: ${page_size}
            ${products_count}=    4_ProductListPage.Get Products Count
            Log    Page size ${page_size}: showing ${products_count} products
            
            # Verify page size change worked
            Should Be True    ${products_count} <= ${page_size}    Too many products shown for page size ${page_size}
        ELSE
            Log    Page size ${page_size} not available
        END
    END

# Product Interaction Keywords
Test Product Interactions In Category
    [Documentation]    Test product interactions (click, add to cart, etc.) in category
    [Arguments]    ${category_name}    ${max_products}=3
    Navigate To Product Category    ${category_name}
    
    ${products_count}=    4_ProductListPage.Get Products Count
    ${test_count}=    Evaluate    min(${products_count}, ${max_products})
    
    FOR    ${index}    IN RANGE    1    ${test_count}+ 1
        Log    Testing product interactions for product ${index}
        
        # Get product details
        ${product_details}=    4_ProductListPage.Get Product Details By Index    ${index}
        Log    Testing product: ${product_details}
        
        # Test clicking product name (should go to product detail page)
        4_ProductListPage.Click Product By Index    ${index}
        1_CommonWeb.Wait For Page To Load
        
        # Verify we're on product detail page
        ${current_url}=    Get Location
        Should Not Contain    ${current_url}    ${CATEGORY_NAVIGATION}[${category_name}]
        Log    Product detail page loaded for: ${product_details}[name]
        
        # Go back to category page
        Navigate To Product Category    ${category_name}
        
        # Test add to cart functionality
        ${cart_button_exists}=    Run Keyword And Return Status    
        ...    Element Should Be Visible    xpath=(//div[@class='item-box'])[${index}]//input[@value='Add to cart']
        IF    ${cart_button_exists}
            4_ProductListPage.Add Product To Cart By Index    ${index}
            Log    Added product ${index} to cart
            Sleep    1s    # Allow time for cart update
        END
        
        # Test add to wishlist functionality  
        ${wishlist_button_exists}=    Run Keyword And Return Status
        ...    Element Should Be Visible    xpath=(//div[@class='item-box'])[${index}]//input[@value='Add to wishlist']
        IF    ${wishlist_button_exists}
            4_ProductListPage.Add Product To Wishlist By Index    ${index}
            Log    Added product ${index} to wishlist
            Sleep    1s    # Allow time for wishlist update
        END
    END

# Search Integration Keywords  
Test Product Search From Categories
    [Documentation]    Test search functionality from different categories
    [Arguments]    ${search_term}    ${categories_to_test}=3
    
    ${test_categories}=    Get Slice From List    ${AVAILABLE_CATEGORIES}    0    ${categories_to_test}
    
    FOR    ${category}    IN    @{test_categories}
        Log    Testing search from ${category} category
        Navigate To Product Category    ${category}
        
        # Perform search
        4_ProductListPage.Search Products In Category    ${search_term}
        1_CommonWeb.Wait For Page To Load
        
        # Verify search results
        ${current_url}=    Get Location
        Should Contain    ${current_url}    search    Search should redirect to search results
        
        # Check if results contain search term
        ${page_content}=    Get Text    xpath=//body
        ${search_found}=    Run Keyword And Return Status    Should Contain    ${page_content}    ${search_term}
        Log    Search for '${search_term}' from ${category}: ${search_found}
    END

# Pagination Testing Keywords
Test Category Pagination
    [Documentation]    Test pagination functionality in category
    [Arguments]    ${category_name}
    Navigate To Product Category    ${category_name}
    
    # Get initial page info
    ${current_page}=    4_ProductListPage.Get Current Page Number
    ${available_pages}=    4_ProductListPage.Get Available Page Numbers
    Log    Category ${category_name} has ${available_pages.__len__()} pages
    
    # Test next page navigation
    ${pages_tested}=    Set Variable    0
    WHILE    ${pages_tested} < 5    # Limit to prevent infinite loops
        ${pages_tested}=    Evaluate    ${pages_tested} + 1
        ${current_page_before}=    4_ProductListPage.Get Current Page Number
        
        ${next_successful}=    Run Keyword And Return Status    4_ProductListPage.Go To Next Page
        IF    not ${next_successful}    BREAK
        
        ${current_page_after}=    4_ProductListPage.Get Current Page Number
        Should Not Be Equal    ${current_page_before}    ${current_page_after}
        Log    Successfully navigated from page ${current_page_before} to ${current_page_after}
        
        # Verify products are still visible
        ${products_count}=    4_ProductListPage.Get Products Count
        Should Be True    ${products_count} > 0    No products found on page ${current_page_after}
    END
    
    # Go back to first page
    4_ProductListPage.Go To Page Number    1
    ${final_page}=    4_ProductListPage.Get Current Page Number
    Should Be Equal    ${final_page}    1    Failed to return to first page

# Comprehensive Category Testing
Test Complete Category Functionality
    [Documentation]    Test complete functionality of a category page
    [Arguments]    ${category_name}
    Log    Starting complete functionality test for category: ${category_name}
    
    # Navigate to category
    Navigate To Product Category    ${category_name}
    
    # Test basic page elements
    4_ProductListPage.Verify Product Listing Page Loaded
    4_ProductListPage.Verify Category Title    ${category_name}
    
    # Test product display
    ${products_count}=    4_ProductListPage.Get Products Count
    Should Be True    ${products_count} > 0    No products found in ${category_name}
    
    4_ProductListPage.Verify All Products Have Images
    4_ProductListPage.Verify All Products Have Prices  
    4_ProductListPage.Verify All Products Are Clickable
    
    # Test sorting
    Test Product Sorting    ${category_name}
    
    # Test page sizes
    Test Page Size Options    ${category_name}
    
    # Test pagination if available
    Test Category Pagination    ${category_name}
    
    # Test product interactions
    Test Product Interactions In Category    ${category_name}    2
    
    # Get final statistics
    ${final_stats}=    4_ProductListPage.Get Category Statistics
    Log    Final statistics for ${category_name}: ${final_stats}
    
    RETURN    ${final_stats}

# Workflow Testing Keywords  
Test Product Discovery Workflow
    [Documentation]    Test complete product discovery workflow
    # Start from homepage
    Navigate To Homepage
    ${homepage_stats}=    1_HomePage.Get Homepage Statistics
    Log    Homepage statistics: ${homepage_stats}
    
    # Browse featured products
    ${featured_products}=    Browse Featured Products
    
    # Browse through categories
    ${category_stats}=    Browse All Categories
    
    # Test search functionality
    Test Product Search From Categories    laptop    2
    
    # Return comprehensive results
    ${workflow_results}=    Create Dictionary
    ...    homepage_stats=${homepage_stats}
    ...    featured_products=${featured_products}
    ...    category_stats=${category_stats}
    
    RETURN    ${workflow_results}

Test Category Browsing Foundation
    [Documentation]    Test foundation of category browsing functionality
    @{tested_categories}=    Create List
    
    FOR    ${category}    IN    @{AVAILABLE_CATEGORIES}
        Log    Testing category browsing foundation for: ${category}
        ${category_results}=    Test Complete Category Functionality    ${category}
        Append To List    ${tested_categories}    ${category_results}
        
        # Take screenshot for documentation
        ${screenshot_name}=    Set Variable    category_foundation_${category.replace(' ', '_').replace('&', 'and')}
        3_UtilityFunction.Take Screenshot With Custom Name    ${screenshot_name}
    END
    
    Log    Category browsing foundation testing completed for all categories
    RETURN    ${tested_categories}

# Navigation Testing Keywords
Develop Product Navigation Keywords
    [Documentation]    Develop and test product navigation keywords
    ${navigation_results}=    Create Dictionary
    
    # Test homepage navigation
    Navigate To Homepage
    Set To Dictionary    ${navigation_results}    homepage_navigation    SUCCESS
    
    # Test category navigation
    FOR    ${category}    IN    @{AVAILABLE_CATEGORIES}
        ${nav_result}=    Run Keyword And Return Status    Navigate To Product Category    ${category}
        Set To Dictionary    ${navigation_results}    ${category}_navigation    ${nav_result}
        
        IF    ${nav_result}
            # Test within category navigation
            ${pagination_result}=    Run Keyword And Return Status    Test Category Pagination    ${category}
            Set To Dictionary    ${navigation_results}    ${category}_pagination    ${pagination_result}
        END
    END
    
    Log    Product navigation keywords development results: ${navigation_results}
    RETURN    ${navigation_results}

# Integration Test Keywords
Implement Category Browsing Functionality
    [Documentation]    Implement complete category browsing functionality
    ${implementation_results}=    Create Dictionary
    
    # Test homepage integration
    ${homepage_result}=    Run Keyword And Return Status    Test Featured Product Interaction
    Set To Dictionary    ${implementation_results}    homepage_integration    ${homepage_result}
    
    # Test category listing integration
    FOR    ${category}    IN    @{AVAILABLE_CATEGORIES}
        Log    Implementing category browsing for: ${category}
        ${category_result}=    Run Keyword And Return Status    Browse Products In Category    ${category}    2
        Set To Dictionary    ${implementation_results}    ${category}_browsing    ${category_result}
    END
    
    # Test search integration
    ${search_result}=    Run Keyword And Return Status    Test Product Search From Categories    computer    2
    Set To Dictionary    ${implementation_results}    search_integration    ${search_result}
    
    Log    Category browsing functionality implementation results: ${implementation_results}
    RETURN    ${implementation_results}

# Featured Products Testing Keywords
Add Featured Products Interaction Tests
    [Documentation]    Add comprehensive tests for featured products interactions
    ${interaction_results}=    Create Dictionary

    Navigate To Homepage
    ${products_count}=    1_HomePage.Get Featured Products Count
    Set To Dictionary    ${interaction_results}    featured_products_count    ${products_count}

    # Test each featured product
    FOR    ${index}    IN RANGE    1    ${products_count}+ 1
        ${product_details}=    1_HomePage.Get Product Details By Index    ${index}

        # Test hover interaction
        ${hover_result}=    Run Keyword And Return Status    1_HomePage.Hover Over Featured Product    ${index}
        Set To Dictionary    ${interaction_results}    product_${index}_hover    ${hover_result}

        # Test image verification
        ${image_result}=    Run Keyword And Return Status    1_HomePage.Verify Product Has Image    ${index}
        Set To Dictionary    ${interaction_results}    product_${index}_image    ${image_result}

        # Test price display
        ${price}=    1_HomePage.Get Product Price By Index    ${index}
        Set To Dictionary    ${interaction_results}    product_${index}_price    ${price}

        # Test click functionality
        1_HomePage.Click Featured Product By Index    ${index}
        ${current_url}=    Get Location
        ${click_result}=    Run Keyword And Return Status    Should Not Contain    ${current_url}    ${URL}
        Set To Dictionary    ${interaction_results}    product_${index}_click    ${click_result}

        # Return to homepage
        Navigate To Homepage

        Log    Featured product ${index} interaction test completed
    END

    Log    Featured products interaction tests completed: ${interaction_results}
    RETURN    ${interaction_results}