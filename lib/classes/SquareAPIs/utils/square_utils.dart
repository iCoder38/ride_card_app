import 'package:flutter_dotenv/flutter_dotenv.dart';

// base url
var squareBaseURL = 'https://connect.squareup.com/v2';

// square keys
var SQUARE_APP_ID = dotenv.env["SQUARE_APPLICATION_ID"].toString();
var SQUARE_ACCESS_TOKEN = dotenv.env["SQUARE_ACCESS_TOKEN"].toString();
