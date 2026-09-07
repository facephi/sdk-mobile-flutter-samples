import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Fip360Service {
  static const String _url = 'https://xxx.xxx.com';

  String getUUID() {
    final random = Random();
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
      RegExp(r'[xy]'),
      (match) {
        final r = random.nextInt(16);
        final v = match.group(0) == 'x' ? r : (r & 0x3) | 0x8;
        return v.toRadixString(16);
      },
    );
  }

  Future<String> getSessionId({
    String method = '/api/init',
    Map<String, dynamic> bodyParams = const {},
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_url$method'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyParams),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        if (data is Map && data['sessionId'] is String && (data['sessionId'] as String).isNotEmpty) {
          return data['sessionId'] as String;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('getSessionId error: $error');
      }
    }

    return getUUID();
  }
}
