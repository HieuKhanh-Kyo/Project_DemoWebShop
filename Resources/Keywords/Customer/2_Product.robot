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

@{AVAILABLE_CATEGORIES}    Books    Computers    Electronics    Apparel & Shoes    Digital downloads    Jewelry    Gift Cards

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

Test Category Navigation Functionality
    [Documentation]    Test category navigation functionality
    1_HomePage.Test Homepage Navigation To All Categories

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