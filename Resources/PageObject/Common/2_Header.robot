*** Settings ***
Library    SeleniumLibrary

Resource   ../../Keywords/Common/imports.robot

*** Variables ***
# Header Navigation Locators
${HEADER_LOGO}              xpath=//div[@class='header-logo']
${HEADER_SEARCH_BOX}        xpath=//div[@class='search-box']
${HEADER_SEARCH_BUTTON}     xpath=//input[@type='submit']
${HEADER_LOGIN_LINK}        xpath=//a[@class='ico-login']
${HEADER_REGISTER_LINK}     xpath=//a[@class='ico-register']
${HEADER_LOGOUT_LINK}       xpath=//a[@class='ico-logout']
${HEADER_CART_LINK}         xpath=//a[@class='ico-cart']
${HEADER_WISHLIST_LINK}     xpath=//a[@class='ico-wishlist']

# Navigation Menu
#${NAV_BOOKS}                /books
#${NAV_COMPUTERS}            /computers
#${NAV_ELECTRONICS}          /electronics
#${NAV_APPAREL_&_SHOES}      /apparel-shoes
#${NAV_DIGITAL_DOWNLOADS}    /digital-downloads
#${NAV_JEWELRY}              /jewelry
#${NAV_GIFT_CARDS}           /gift-cards
#
## <Dict> Category
#&{CATEGORY_MAP}
#...    Books=${NAV_BOOKS}
#...    Computers=${NAV_COMPUTERS}
#...    Electronics=${NAV_ELECTRONICS}
#...    Apparel & Shoes=${NAV_APPAREL_&_SHOES}
#...    Digital Downloads=${NAV_DIGITAL_DOWNLOADS}
#...    Jewelry=${NAV_JEWELRY}
#...    Gift Cards=${NAV_GIFT_CARDS}

*** Keywords ***
Verify Header Is Visible
    [Documentation]    Verify main header elements are visible
    Wait Until Element Is Visible    ${HEADER_LOGO}
    Wait Until Element Is Visible    ${HEADER_SEARCH_BOX}
    Wait Until Element Is Visible    ${HEADER_LOGIN_LINK}

Click Login Link
    [Documentation]    Click on login link in header
    1_CommonWeb.Wait For Element And Click    ${HEADER_LOGIN_LINK}

Click Register Link
    [Documentation]    Click on register link in header
    1_CommonWeb.Wait For Element And Click    ${HEADER_REGISTER_LINK}

Search For Product
    [Documentation]    Search for product using header search
    [Arguments]    ${search_term}
    1_CommonWeb.Wait For Element And Input Text    ${HEADER_SEARCH_BOX}    ${search_term}
    1_CommonWeb.Wait For Element And Click    ${HEADER_SEARCH_BUTTON}

#Navigate To Category
#    [Documentation]    Navigate to specific category
#    [Arguments]    ${category}
#
#    CommonWeb.Wait For Element And Click    ${CATEGORY_MAP}[${category}]