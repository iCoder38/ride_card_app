import 'package:http/http.dart' as http;

Future<bool> acceptTermsOfService({
  required String connectedAccountId,
  required String apiKey,
  required int acceptanceDate, // Timestamp for the TOS acceptance
  required String acceptanceIp, // IP address from where TOS was accepted
}) async {
  final url =
      Uri.parse('https://api.stripe.com/v1/accounts/$connectedAccountId');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'tos_acceptance[date]':
          acceptanceDate.toString(), // Date as UNIX timestamp
      'tos_acceptance[ip]': acceptanceIp, // IP address for TOS acceptance
    },
  );

  if (response.statusCode == 200) {
    print('TOS accepted successfully.');
    return true;
  } else {
    print('Failed to accept TOS: ${response.body}');
    return false;
  }
}
