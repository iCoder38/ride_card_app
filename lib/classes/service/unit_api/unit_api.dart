// import 'dart:convert';
// import 'package:http/http.dart' as http;

// var token2 =
//     'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw';

// class UnitApiService {
//   final String baseUrl = 'https://api.s.unit.sh/customers';
//   final String token =
//       'v2.public.eyJyb2xlIjoiYWRtaW4iLCJ1c2VySWQiOiI3NTY3Iiwic3ViIjoianVzdGluYmVubmV0dEByaWRlYXBwaW5jZ2xvYmFsLmNvbSIsImV4cCI6IjIwMjQtMDgtMjZUMTI6NDM6NTguNzA1WiIsImp0aSI6IjMzMDY2NSIsIm9yZ0lkIjoiNDIxOSIsInNjb3BlIjoiYXBwbGljYXRpb25zIGFwcGxpY2F0aW9ucy13cml0ZSBjdXN0b21lcnMgY3VzdG9tZXJzLXdyaXRlIGN1c3RvbWVyLXRhZ3Mtd3JpdGUgY3VzdG9tZXItdG9rZW4td3JpdGUgYWNjb3VudHMgYWNjb3VudHMtd3JpdGUgY2FyZHMgY2FyZHMtd3JpdGUgY2FyZHMtc2Vuc2l0aXZlIHRyYW5zYWN0aW9ucyB0cmFuc2FjdGlvbnMtd3JpdGUgYXV0aG9yaXphdGlvbnMgc3RhdGVtZW50cyBwYXltZW50cyBwYXltZW50cy13cml0ZSBwYXltZW50cy13cml0ZS1jb3VudGVycGFydHkgcGF5bWVudHMtd3JpdGUtbGlua2VkLWFjY291bnQgYWNoLXBheW1lbnRzLXdyaXRlIHdpcmUtcGF5bWVudHMtd3JpdGUgcmVwYXltZW50cyByZXBheW1lbnRzLXdyaXRlIHBheW1lbnRzLXdyaXRlLWFjaC1kZWJpdCBjb3VudGVycGFydGllcyBiYXRjaC1yZWxlYXNlcyBiYXRjaC1yZWxlYXNlcy13cml0ZSBsaW5rZWQtYWNjb3VudHMgd2ViaG9va3Mgd2ViaG9va3Mtd3JpdGUgZXZlbnRzIGV2ZW50cy13cml0ZSBhdXRob3JpemF0aW9uLXJlcXVlc3RzIGF1dGhvcml6YXRpb24tcmVxdWVzdHMtd3JpdGUgY2FzaC1kZXBvc2l0cyBjYXNoLWRlcG9zaXRzLXdyaXRlIGNoZWNrLWRlcG9zaXRzIGNoZWNrLWRlcG9zaXRzLXdyaXRlIHJlY2VpdmVkLXBheW1lbnRzIHJlY2VpdmVkLXBheW1lbnRzLXdyaXRlIGRpc3B1dGVzIGNoYXJnZWJhY2tzIHJld2FyZHMgcmV3YXJkcy13cml0ZSBjaGVjay1wYXltZW50cyBjaGVjay1wYXltZW50cy13cml0ZSBjcmVkaXQtZGVjaXNpb25zIGxlbmRpbmctcHJvZ3JhbXMgY3JlZGl0LWFwcGxpY2F0aW9ucyBjcmVkaXQtYXBwbGljYXRpb25zLXdyaXRlIG1pZ3JhdGlvbnMgbWlncmF0aW9ucy13cml0ZSIsIm9yZyI6IlJpZGUgYXBwIGluYyIsInNvdXJjZUlwIjoiIiwidXNlclR5cGUiOiJvcmciLCJpc1VuaXRQaWxvdCI6ZmFsc2V9oPEe4b0t2NMYJM38ZXvYzwKpPxoQK1NbYAsnOSMI-Ut2I8YBF2gDkIaCoN7Ua6LO8WVauqrCD_LhXoRqJeqIBw';

//   Future<Map<String, dynamic>> createCustomer(
//       Map<String, dynamic> customerData) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {
//         'Content-Type': 'application/vnd.api+json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({
//         'data': {'type': 'individualCustomer', 'attributes': customerData}
//       }),
//     );

//     if (response.statusCode == 201) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to create customer: ${response.body}');
//     }
//   }
// }

// // class UnitApiService {
// //   final String baseUrl = 'https://api.s.unit.sh/customers';
// //   final String token = token2;

// //   Future<Map<String, dynamic>> createCustomer(
// //       Map<String, dynamic> customerData) async {
// //     final response = await http.post(
// //       Uri.parse(baseUrl),
// //       headers: {
// //         'Content-Type': 'application/vnd.api+json',
// //         'Authorization': 'Bearer $token',
// //       },
// //       body: jsonEncode({
// //         'data': {'type': 'individualCustomer', 'attributes': customerData}
// //       }),
// //     );

// //     if (response.statusCode == 201) {
// //       return jsonDecode(response.body);
// //     } else {
// //       throw Exception('Failed to create customer: ${response.body}');
// //     }
// //   }
// // }
