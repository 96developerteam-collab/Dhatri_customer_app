import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Remove hardcoded values
  static final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';

  // ...existing code...

  Future<http.Response> _makeSecureRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 401) {
        throw UnauthorizedException();
      }
      return response;
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timeout');
    }
  }
}

