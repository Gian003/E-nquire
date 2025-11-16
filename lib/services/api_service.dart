import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static String baseUrl = dotenv.get(
    'API_URL',
    fallback: 'http://localhost:8000/api',
  );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders({bool hasFiles = false}) async {
    final token = await _storage.read(key: 'auth_token');
    final headers = {
      if (!hasFiles) 'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> _handleRequest(
    String method,
    String endPoint, {
    dynamic data,
    bool hasFiles = false,
  }) async {
    try {
      final headers = await _getHeaders(hasFiles: hasFiles);
      final url = Uri.parse('$baseUrl/$endPoint');

      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
        case 'POST':
          if (hasFiles && data is http.MultipartRequest) {
            response = await http.Response.fromStream(await data.send());
          } else {
            response = await http.post(
              url,
              headers: headers,
              body: hasFiles ? data : json.encode(data),
            );
          }
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: hasFiles ? data : json.encode(data),
          );
        case 'DELETE':
          response = await http.delete(url, headers: headers);
        default:
          throw Exception('Unsupported HTTP method');
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  http.Response _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw Exception('Bad request');
      case 401:
        throw Exception('Unauthorized - Please login again');
      case 403:
        throw Exception('Forbidden - Access denied');
      case 404:
        throw Exception('Resource not found');
      case 422:
        throw Exception('Validation failed: ${response.body}');
      case 500:
        throw Exception('Server error - Please try again later');
      default:
        throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  //Auth Methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _handleRequest(
      'POST',
      'login',
      data: {'email': email, 'password': password},
    );

    final data = json.decode(response.body);

    if (data['success'] == true) {
      await _storage.write(
        key: 'auth_token',
        value: data['data']['access_token'],
      );
      await _storage.write(
        key: 'user_data',
        value: json.encode(data['data']['user']),
      );
    }

    return data;
  }
}
