import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enquire/API/config.dart';

class AuthServices {
  /// Registers a user with the given email and password.
  ///
  /// This function sends a POST request to the register endpoint
  /// with the given email and password. The password is
  /// confirmed by sending the same password in the
  /// "password_confirmation" field.
  ///
  /// The response is expected to be a JSON object containing
  /// the user's data. This object is decoded and returned
  /// as a Map String, dynamic.
  static Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "password_confirmation": password,
      }),
    );
    return jsonDecode(response.body);
  }

  /// Logs a user in with the given email and password.
  ///
  /// This function sends a POST request to the login endpoint
  /// with the given email and password. The response is expected
  /// to be a JSON object containing the user's access token.
  ///
  /// If the response status code is 200 and the JSON object contains
  /// an "access_token" key, the access token is stored in the
  /// SharedPreferences with the key "token".
  ///
  /// The response JSON object is decoded and returned as a Map
  /// String, dynamic.
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    // Send a POST request to the login endpoint with the given email and password.
    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    // Decode the response body as a JSON object.
    final data = jsonDecode(response.body);

    // If the response status code is 200 and the JSON object contains an "access_token" key,
    // store the access token in the SharedPreferences with the key "token".
    if (response.statusCode == 200 && data.containsKey("access_token")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data["access_token"]);
    }

    // Return the decoded JSON object.
    return data;
  }

  /// Logs the user out by sending a POST request to the logout endpoint
  /// with the stored access token in the Authorization header.
  ///
  /// If the request is successful, the stored access token is removed
  /// from the SharedPreferences.
  static Future<void> logout() async {
    // Get the stored access token from SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    // If the access token is not null, send a POST request to the logout endpoint
    // with the access token in the Authorization header.
    if (token != null) {
      await http.post(
        Uri.parse("${Config.apiBaseUrl}/logout"),
        headers: {"Authorization": "Bearer $token"},
      );
    }

    // Remove the stored access token from SharedPreferences.
    prefs.remove("token");
  }
}
