import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Address of the Node API. Supply this for a deployed app, for example:
/// flutter build web --dart-define=API_BASE_URL=https://your-api.example.com
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

class TelemetryApi {
  static Future<void> send(Map<String, dynamic> telemetry) async {
    if (apiBaseUrl.isEmpty) {
      throw StateError('API_BASE_URL has not been configured');
    }
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) throw StateError('Please sign in again');

    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/telemetry'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(telemetry),
    );
    if (response.statusCode != 200) {
      throw StateError('API error ${response.statusCode}: ${response.body}');
    }
  }
}
