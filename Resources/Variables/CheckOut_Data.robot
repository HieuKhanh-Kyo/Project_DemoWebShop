*** Variables ***
# BILLING ADDRESS - Test Data
${BILLING_FIRSTNAME_DATA}           Test
${BILLING_LASTNAME_DATA}            Automation
${BILLING_EMAIL_DATA}               hikakyo@gmail.com
${BILLING_COUNTRY_DATA}             Viet Nam
${BILLING_CITY_DATA}                Ha Noi
${BILLING_ADDRESS1_DATA}            123 Test Street
${BILLING_ZIP_DATA}                 100000
${BILLING_PHONE_DATA}               0987654321

# SHIPPING METHOD - Test Data
# Options: Ground / Next Day Air / 2nd Day Air
${SHIPPING_METHOD_DATA}             Ground

# PAYMENT METHOD - Test Data
# Options: CashOnDelivery / CheckMoneyOrder / Manual / PurchaseOrder
${PAYMENT_METHOD_DATA}              PurchaseOrder

# CREDIT CARD INFO - Test Data
# Only used when PAYMENT_METHOD_DATA = Manual
${CC_TYPE_DATA}                     Visa
${CC_NAME_DATA}                     Test Automation
${CC_NUMBER_DATA}                   4111111111111111
${CC_EXPIRE_MONTH_DATA}             12
${CC_EXPIRE_YEAR_DATA}              2027
${CC_CODE_DATA}                     123

# PURCHASE ORDER INFO - Test Data
# Only used when PAYMENT_METHOD_DATA = PurchaseOrder
${PO_NUMBER_DATA}                   PO-NUMBER-TEST-0123
