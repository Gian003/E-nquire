import 'dart:convert'; // For encoding and decoding JSON data.
import 'dart:io'; // For working with files (e.g., uploading ID proof).
import 'package:http/http.dart' as http; // HTTP client for making requests.
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage for sensitive data.
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For loading environment variables (e.g., API URL).

/// ApiService is a singleton class responsible for all API-related operations.
/// It handles authentication, user data, and certificate requests.
class ApiService {
  // --- Singleton Pattern Implementation ---
  // Ensures only one instance of ApiService exists throughout the app.

  /// The single instance of ApiService (private).
  static final ApiService _instance = ApiService._internal();

  /// The base URL for the API, loaded from environment variables.
  /// If not set, defaults to 'http://localhost:8000/api'.
  static String baseUrl = dotenv.get(
    'API_URL',
    fallback: 'http://localhost:8000/api',
  );

  /// Secure storage instance for storing sensitive data like tokens.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Factory constructor returns the singleton instance.
  factory ApiService() => _instance;

  /// Private internal constructor (prevents external instantiation).
  ApiService._internal();

  // --- Helper Methods ---

  /// Builds HTTP headers for requests.
  /// Adds 'Authorization' header if a token is stored.
  /// Adds 'Content-Type: application/json' unless files are being uploaded.
  Future<Map<String, String>> _getHeaders({bool hasFiles = false}) async {
    final token = await _storage.read(
      key: 'auth_token',
    ); // Read token from secure storage.
    final headers = <String, String>{
      'Accept': 'application/json', // Always accept JSON responses.
    };
    if (!hasFiles) {
      headers['Content-Type'] =
          'application/json'; // Set content type for JSON requests.
    }
    if (token != null) {
      headers['Authorization'] = 'Bearer $token'; // Add token if available.
    }
    return headers;
  }

  /// Handles HTTP requests in a generic way.
  /// Supports GET, POST, PUT, DELETE, and file uploads.
  /// Returns the HTTP response.
  Future<http.Response> _handleRequest(
    String method,
    String endpoint, {
    dynamic data,
    bool hasFiles = false,
  }) async {
    final headers = await _getHeaders(
      hasFiles: hasFiles,
    ); // Get appropriate headers.
    final url = Uri.parse('$baseUrl/$endpoint'); // Build full URL.
    http.Response response;

    switch (method) {
      case 'GET':
        // Standard GET request.
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        if (hasFiles && data is http.MultipartRequest) {
          // If uploading files, send as multipart/form-data.
          response = http.Response.fromStream(await data.send());
        } else {
          // Standard POST with JSON body.
          response = await http.post(
            url,
            headers: headers,
            body: hasFiles ? data : json.encode(data),
          );
        }
        break;
      case 'PUT':
        // PUT request for updating resources.
        response = await http.put(
          url,
          headers: headers,
          body: hasFiles ? data : json.encode(data),
        );
        break;
      case 'DELETE':
        // DELETE request for removing resources.
        response = await http.delete(url, headers: headers);
        break;
      default:
        // If method is not supported, throw an error.
        throw Exception('Unsupported HTTP method');
    }
    return response;
  }

  // --- API Methods ---

  /// Submits a certificate request to the server.
  /// [request] should be a MultipartRequest containing form fields and files.
  /// Returns the server's response as a decoded JSON map.
  Future<Map<String, dynamic>> submitCertificateRequest(dynamic request) async {
    final response = await _handleRequest(
      'POST',
      'certificate-requests',
      data: request,
      hasFiles: true, // Indicates this is a file upload.
    );
    return json.decode(response.body); // Parse and return JSON response.
  }

  /// Fetches details of a specific certificate request by its [id].
  /// Returns the server's response as a decoded JSON map.
  Future<Map<String, dynamic>> getCertificateRequest(int id) async {
    final response = await _handleRequest('GET', 'certificate-requests/$id');
    return json.decode(response.body); // Parse and return JSON response.
  }

  /// Checks if the user is authenticated by verifying if a token exists in storage.
  /// Returns true if a token is found, false otherwise.
  Future<bool> checkAuth() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  /// Retrieves the stored user data from secure storage.
  /// Returns the user data as a decoded JSON map, or null if not found.
  Future<Map<String, dynamic>?> getStoredUser() async {
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      return json.decode(userData);
    }
    return null;
  }
}
