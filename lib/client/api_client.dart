import 'dart:convert';
import 'package:game/model/leaderboard_item.dart';
import 'package:http/http.dart' as http;
import '../model/movie_data.dart';
import '../model/saved_game.dart';
import '../model/user_stats.dart';

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
    print('login start');
    final uri = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(Duration(seconds:10));
    print(response);
    print('login end');
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

  Future<bool> register(String email, String password, String username) async {
    final uri = Uri.parse('$baseUrl/auth/register');
    print('buradayım');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print('buradayım2');
    print(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final newUri = Uri.parse('$baseUrl/api/users');
      await login(email, password);
      await http.post(
        newUri,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'username': username,
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

    // Construct a Request manually
    final request = http.Request('POST', uri)
      ..headers.addAll(_headers)
      ..body = jsonEncode(requestBody);

    // Send the request to get a streamed response
    final streamedResponse = await http.Client().send(request);

    if (streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300) {
      // Transform the streamed byte response into a Stream of text
      return streamedResponse.stream.transform(utf8.decoder);
    } else {
      // On error, read the entire response as string to parse the error message
      final responseBody = await streamedResponse.stream.bytesToString();
      final body = responseBody.isNotEmpty ? jsonDecode(responseBody) : {};
      throw ApiException(
        statusCode: streamedResponse.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }


  Future<Stream<String>> continueChat(String message, String threadId) async {
    final uri = Uri.parse('$baseUrl/api/chat/$threadId/continue');
    final requestBody = jsonEncode({'message': message});

    final request = http.Request('POST', uri)
      ..headers.addAll(_headers)
      ..body = requestBody;

    final streamedResponse = await http.Client().send(request);

    if (streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300) {
      // Convert the byte stream to a string stream
      return streamedResponse.stream
          .transform(utf8.decoder); // => Stream<String>
    } else {
      final responseBody = await streamedResponse.stream.bytesToString();
      final body = responseBody.isNotEmpty ? jsonDecode(responseBody) : {};
      throw ApiException(
        statusCode: streamedResponse.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }


  Future<UserStats> getHomePageStats() async {
    final uri = Uri.parse('$baseUrl/api/chat/user/statistics');
    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return UserStats.fromJson(json);
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      print(body);
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final uri = Uri.parse('$baseUrl/api/users');
    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      print(body);
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  Future<List<SavedGame>> getUserChats() async {
    final uri = Uri.parse('$baseUrl/api/chat/user/chats');
    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      print(json);
      return SavedGame.fromJsonList(json);
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      print(body);
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  Future<Map<String, dynamic>> getChatHistory(String? threadId) async {
    final uri = Uri.parse('$baseUrl/api/chat/$threadId/history');
    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);

      final json = jsonDecode(utf8DecodedBody);
      printLongString(json);
      return json;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      print(body);
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  Future<List<MovieData>> getMovies() async {
    final uri = Uri.parse('$baseUrl/api/movies');
    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      printLongString(json);
      List<MovieData> movies = MovieData.fromJsonList(json);
      return movies;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }

  void printLongString(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    String prettyJson = encoder.convert(json);
    prettyJson.split('\n').forEach((element) => print(element));
  }

  Future<Leaderboard> getLeaderboard() async {
    final uri = Uri.parse('$baseUrl/api/users/leaderboard');
    final response = await http.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      print(json);
      Leaderboard leaderboard = Leaderboard.fromJson(json);
      return leaderboard;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      print(body);
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


