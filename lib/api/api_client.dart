import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiClient {
  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/token'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'client_id': clientId,
        'secret_id': secretId,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']['access_token'];
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }

  Future<String?> initiatePayment(String accessToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment/create'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': '100.00', // Example amount
        'currency': 'ILS',
        'return_url': 'https://www.example.com/success',
        'cancel_url': 'https://www.example.com/cancel',
        'custom': '123456789ABCD',
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']['payment_url'];
    } else {
      throw Exception('Failed to initiate payment: ${response.body}');
    }
  }
}
