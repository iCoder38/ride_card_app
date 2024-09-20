import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

var BASE_URL = 'https://demo4.evirtualservices.net/ridewallet/services/index';

var COUNTRY_US = 'US';
var COUNTRY_CURRENCY = '\$';
var COUNTRY_US_PHONE_CODE = '1';

var HIVE_BOX_KEY = 'myBox1';
var RESPONSE_ROLE = 'Member';

var NOT_AUTHORIZED = 'You are not authorize to access the API';

var SHARED_PREFRENCE_LOCAL_KEY = 'key_save_token_locally';

var TAX_TYPE_PERCENTAGE = 'Percentage';
var TAX_TYPE_FIXED_PRICE = 'Fix';

var REFRESH_CONVENIENCE_FEES = 'refreshConvenienceFees';
var FEES_CHARGE_TITLE = 'Bank account';

// CHECK CC SCORE KEYS
// var CC_SCORE_BASE_URL = dotenv.env['CC_SCORE_BASE_URL'];
// var CC_SCORE_CLIENT_ID = dotenv.env['CC_SCORE_CLIENT_ID'];
// var CC_SCORE_CLIENT_SECRET = dotenv.env['CC_SCORE_CLIENT_SECRET'];
// var CC_SCORE_MODULE_SECRET = dotenv.env['CC_SCORE_MODULE_SECRET'];
// var CC_SCORE_PROVIDER_SECRET = dotenv.env['CC_SCORE_PROVIDER_SECRET'];

String TESTING_TOKEN =
    // 'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw';
    'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjUtMDctMDNUMTI6Mzc6MTIuMTI4WiIsImp0aSI6IjM0MjUyMiIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIGNhcmRzLXNlbnNpdGl2ZS13cml0ZSB0cmFuc2FjdGlvbnMgdHJhbnNhY3Rpb25zLXdyaXRlIGF1dGhvcml6YXRpb25zIHN0YXRlbWVudHMgcGF5bWVudHMgcGF5bWVudHMtd3JpdGUgcGF5bWVudHMtd3JpdGUtY291bnRlcnBhcnR5IHBheW1lbnRzLXdyaXRlLWxpbmtlZC1hY2NvdW50IGFjaC1wYXltZW50cy13cml0ZSB3aXJlLXBheW1lbnRzLXdyaXRlIHJlcGF5bWVudHMgcmVwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1hY2gtZGViaXQgY291bnRlcnBhcnRpZXMgY291bnRlcnBhcnRpZXMtd3JpdGUgYmF0Y2gtcmVsZWFzZXMgYmF0Y2gtcmVsZWFzZXMtd3JpdGUgbGlua2VkLWFjY291bnRzIGxpbmtlZC1hY2NvdW50cy13cml0ZSB3ZWJob29rcyB3ZWJob29rcy13cml0ZSBldmVudHMgZXZlbnRzLXdyaXRlIGF1dGhvcml6YXRpb24tcmVxdWVzdHMgYXV0aG9yaXphdGlvbi1yZXF1ZXN0cy13cml0ZSBjYXNoLWRlcG9zaXRzIGNhc2gtZGVwb3NpdHMtd3JpdGUgY2hlY2stZGVwb3NpdHMgY2hlY2stZGVwb3NpdHMtd3JpdGUgcmVjZWl2ZWQtcGF5bWVudHMgcmVjZWl2ZWQtcGF5bWVudHMtd3JpdGUgZGlzcHV0ZXMgY2hhcmdlYmFja3MgY2hhcmdlYmFja3Mtd3JpdGUgcmV3YXJkcyByZXdhcmRzLXdyaXRlIGNoZWNrLXBheW1lbnRzIGNoZWNrLXBheW1lbnRzLXdyaXRlIGNyZWRpdC1kZWNpc2lvbnMgY3JlZGl0LWRlY2lzaW9ucy13cml0ZSBsZW5kaW5nLXByb2dyYW1zIGxlbmRpbmctcHJvZ3JhbXMtd3JpdGUgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9_iS4-M4viz0flRGx6NossLt52Exj5ll7Ty1mjbG5-LQmVBUFZ3RwGLQzmnYPf00OjzlVWzlmc2h_bzWD_3PCBg';

String STRIPE_CHARGE_AMOUNT_URL =
    'https://demo4.evirtualservices.net/ridewallet/webroot/strip_master/strip_master/charge_test.php';
var OPEN_CARD_DETAILS_URL =
    'https://demo4.evirtualservices.net/ridewallet/displaycard.php?cardid=';
var SET_PIN_URL =
    'https://demo4.evirtualservices.net/ridewallet/setpin.php?customerid=';

// STRIPE KEYS
String? STRIPE_KEY = dotenv.env['STRIPE_KEY'];
String? STRIPE_STATUS = dotenv.env['STRIPE_STATUS'];

final Logger logger = Logger(
  level:
      kReleaseMode ? Level.off : Level.debug, // Disable logging in production
  printer: PrettyPrinter(), // Customize as needed
);
