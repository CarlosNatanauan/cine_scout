// models/app_config.dart
class AppConfig {
  final String apiKey;
  final String baseApiUrl;
  final String baseImageApiUrl;

  AppConfig({
    required this.apiKey,
    required this.baseApiUrl,
    required this.baseImageApiUrl,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      apiKey: json['API_KEY'],
      baseApiUrl: json['BASE_API_URL'],
      baseImageApiUrl: json['BASE_IMAGE_API_URL'],
    );
  }
}
