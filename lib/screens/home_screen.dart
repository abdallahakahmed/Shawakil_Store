import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../screens/payment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiClient apiClient = ApiClient();

    return Scaffold(
      appBar: AppBar(title: const Text('Shawakil Store')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final accessToken = await apiClient.getAccessToken();
              if (accessToken != null) {
                final paymentUrl = await apiClient.initiatePayment(accessToken);
                if (paymentUrl != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentScreen(paymentUrl: paymentUrl),
                    ),
                  );
                }
              }
            } catch (e) {
              print('Error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed: ${e.toString()}')),
              );
            }
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
