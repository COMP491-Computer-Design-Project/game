import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  String? _authToken;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  final String baseUrl = 'http://ec2-51-20-187-23.eu-north-1.compute.amazonaws.com:8090';

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<bool> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      String token = response.body;
      setAuthToken(token);
      return true;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  Future<bool> register(String email, String password) async {
    final uri = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final newUri = Uri.parse('$baseUrl/api/users');
      await login(email, password);
      await http.post(
        newUri,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return true;

    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  Future<Stream<String>> startChat(Map<String, dynamic> requestBody) async {
    final uri = Uri.parse('$baseUrl/api/chat/start');
    print(_headers);
    print(requestBody);

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(requestBody),
    );


    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Assuming the server sends a stream of text
      return Stream.value(response.body); // Replace this with actual stream handling
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }


  Future<Stream<String>> continueChat(String message, String threadId) async {
    final uri = Uri.parse('$baseUrl/api/chat/$threadId/continue');
    final requestBody = jsonEncode({
      'message': message,
    });

    final response = await http.post(
      uri,
      headers: _headers,
      body: requestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Check if the API returns a stream-like response (chunked or line-delimited JSON)
      return Stream.value(response.body);
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }


}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  ApiException({
    required this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException: $message (HTTP $statusCode)';
  }
}


