import 'dart:convert';
import 'package:enquire/Screen/notification_flow/notification_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final String baseUrl;
  final String token;

  NotificationService({required this.baseUrl, required this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<List<NotificationModel>> fetchNotifications({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/notifications?page=$page'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] ?? body;
      return (data as List).map((j) => NotificationModel.fromJson(j)).toList();
    }
    throw Exception('failed to load notifications');
  }

  Future<void> markAsRead(int notificationId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
      headers: _headers,
    );
    if (response.statusCode != 200) throw Exception('Failed to mark read');
  }
}
