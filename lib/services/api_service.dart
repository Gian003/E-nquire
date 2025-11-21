import 'dart:convert';
import 'dart:io';
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

  Future<dynamic> apiCall({
    required String method,
    required String endPoint,
    dynamic data,
    bool requiresAuth = true,
    bool hasFiles = false,
  }) async {
    try {
      final headers = await _getHeaders(hasFiles: hasFiles);
      final url = Uri.parse('$baseUrl/$endPoint');

      http.Response response;

      switch (method.toUpperCase()) {
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
          response = await http.put(url, headers: headers);
        case 'DELETE':
          response = await http.delete(url, headers: headers);
        default:
          throw Exception('Unsupported HTTP methdd: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final String resonseBody = response.body;

    if (resonseBody.isEmpty) {
      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'status_code': response.statusCode,
      };
    }
    try {
      final dynamic responseData = json.decode(resonseBody);

      switch (response.statusCode) {
        case 200: //Ok

        case 201: // Created
          return responseData;

        case 400: //Bad Request
          throw ApiException(
            message: responseData['message'] ?? 'Bad request',
            errors: responseData['errors'],
            statusCode: 400,
          );

        case 401: //Unauthorized
          throw ApiException(
            message: responseData['Please login again'],
            statusCode: 401,
          );

        case 403: //Forbidden
          throw ApiException(
            message: responseData['Access denied'],
            statusCode: 403,
          );

        case 404: //Not Found
          throw ApiException(message: 'Resource not ofund', statusCode: 404);

        case 422: //Validation Error
          throw ApiException(
            message: responseData['meesage'] ?? 'Validation error',
            errors: responseData['errors'],
            statusCode: 422,
          );

        case 500: //Server Errod
          throw ApiException(
            message: 'Server error - Please try again later',
            statusCode: 500,
          );

        default:
          throw ApiException(
            message: 'Request failed with status: ${response.statusCode}',
            statusCode: response.statusCode,
          );
      }
    } catch (e) {
      //Handle JSON parsing errors
      throw Exception('Failed to parse server response');
    }
  }

  //Auth Methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await apiCall(
      method: 'POST',
      endPoint: 'login',
      data: {'email': email, 'password': password},
      requiresAuth: false,
    );

    if (result['success'] == true) {
      await _storage.write(
        key: 'auth_token',
        value: result['data']['access_token'],
      );
      await _storage.write(
        key: 'user_data',
        value: json.decode(result['data']['user']),
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final result = await apiCall(
      method: 'POST',
      endPoint: 'register',
      data: userData,
      requiresAuth: false,
    );

    if (result['success'] == true) {
      await _storage.write(
        key: 'auth_token',
        value: result['data']['access_token'],
      );
      await _storage.write(
        key: 'data',
        value: json.encode(result['data']['user']),
      );
    }

    return result;
  }

  Future<void> logout() async {
    try {
      await apiCall(method: 'POST', endPoint: 'logout');
    } catch (e) {
      print('Logout error: $e');
    } finally {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await apiCall(method: 'POST', endPoint: 'user');
    return json.decode(response.body);
  }

  Future<dynamic> sendVerificationCode({
    required String method,
    required String email,
    required String phone,
  }) async {
    return await apiCall(
      method: 'POST',
      endPoint: 'send-verification',
      data: {'method': method, 'email': email, 'phone': phone},
    );
  }

  Future<dynamic> verifyCode({
    required String code,
    required String method,
  }) async {
    return await apiCall(
      method: 'POST',
      endPoint: 'verify-code',
      data: {'code': code, 'method': method},
    );
  }

  //Certificate Request Methods
  Future<dynamic> submitCertificateRequest(
    Map<String, dynamic> requestData,
  ) async {
    return await apiCall(
      method: 'POST',
      endPoint: 'certificate-requests',
      data: requestData,
    );
  }

  Future<dynamic> getCertificateRequests({int page = 1}) async {
    return await apiCall(
      method: 'GET',
      endPoint: 'certificate-requests?page=$page',
    );
  }

  Future<dynamic> getCertificateRequest(int id) async {
    return await apiCall(method: 'GET', endPoint: 'certificate-requests/$id');
  }

  //File Upload Helper
  Future<http.MultipartRequest> prepareMultipartRequest({
    required String endPoint,
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final request = http.AbortableMultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$endPoint'),
    );

    //Add fields
    final token = await _storage.read(key: 'auth_token');
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    //Add Files
    for (final entry in files.entries) {
      request.files.add(
        await http.MultipartFile.fromPath(entry.key, entry.value.path),
      );
    }

    //Add fields
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    return request;
  }

  //Utility Methods
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  Future<bool> checkAuth() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  Future<Map<String, dynamic>?> getStoredUser() async {
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      return json.decode(userData);
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}

class ApiException implements Exception {
  final String message;
  final dynamic errors;
  final int statusCode;

  ApiException({required this.message, this.errors, required this.statusCode});

  @override
  String toString() {
    if (errors != null) {
      return 'ApiException: $message (Status: $statusCode) \nErrors: $errors';
    }
    return 'ApiException: $message (Status: $statusCode)';
  }
}
