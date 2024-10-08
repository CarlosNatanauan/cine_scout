import '../models/app_config.dart'; // Import your AppConfig model
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio(); // Dio instance for HTTP requests
  final GetIt getIt = GetIt.instance; // Dependency injection

  late String _baseUrl; // Base URL for API requests
  late String _apiKey; // API Key for authentication

  // Constructor to initialize HTTPService and fetch config
  HTTPService() {
    AppConfig _config = getIt<AppConfig>(); // Retrieve AppConfig instance
    _baseUrl = _config.baseApiUrl; // Set base URL from config
    _apiKey = _config.apiKey; // Set API key from config
  }

  // GET request method
  Future<Response?> get(String path, {Map<String, dynamic>? query}) async {
    try {
      String url = '$_baseUrl$path'; // Complete URL for the request
      Map<String, dynamic> _query = {
        'api_key': _apiKey, // Include API key in query parameters
        'language': 'en-US', // Default language
      };

      // Add additional query parameters if provided
      if (query != null) {
        _query.addAll(query);
      }

      // Perform the GET request
      return await dio.get(url, queryParameters: _query);
    } on DioError catch (e) {
      // Handle errors gracefully
      print('Unable to perform GET request');
      print('DioError: $e');
      return null; // Return null if an error occurs
    }
  }
}
