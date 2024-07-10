var SANDBOX_LIVE_URL = 'https://api.s.unit.sh';
var CREATE_APPLICATION_URL = '$SANDBOX_LIVE_URL/applications';
var CUSTOMER_ACCOUNTS_URL = '$SANDBOX_LIVE_URL/accounts?filter[customerId]=';
var CUSTOMER_CARDS_URL = '$SANDBOX_LIVE_URL/cards?filter[accountId]=';
var CREATE_AN_ACCOUNT_URL = '$SANDBOX_LIVE_URL/accounts';
var FREEZE_AN_ACCOUNT_URL = '$SANDBOX_LIVE_URL/accounts';
var ISSUE_CARD_URL = '$SANDBOX_LIVE_URL/cards';
var GET_CUSTOMER_URL = '$SANDBOX_LIVE_URL/customers';

// attributes
var ACCOUNT_FREEZE = 'accountFreeze';
var ACCOUNT_CLOSE_DEPORIT = 'depositAccountClose';
var CARD_INDIVIDUAL_V_D_C_TYPE = 'individualVirtualDebitCard';

// CARDS NAME
var CARD_INDIVIDUAL_VIRTUAL_DEBIT_CARD = 'Individual Virtual Debit Card';
var CARD_I_V_D_C_DAILY_WITHDRAWAL = 10000;
var CARD_I_V_D_C_DAILY_PURCHASE = 5000;
var CARD_I_V_D_C_MONTHLY_WITHDRAWAL = 20000;
var CARD_I_V_D_C_MONTHLY_PURCHASE = 10000;

// business
var CARD_BUSINESS_VIRTUAL_DEBIT_CARD_UNIT = 'businessVirtualDebitCard';
var CARD_BUSINESS_VIRTUAL_DEBIT_CARD_NAME = 'Business Virtual Debit Card';
