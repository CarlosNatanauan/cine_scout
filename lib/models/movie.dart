import 'package:get_it/get_it.dart';
import 'package:movie_app/models/app_config.dart';
import '../models/genre.dart';

class Movie {
  late final int id; // Make sure to declare 'id'
  late final String name;
  late final String language;
  late final bool isAdult;
  late final String description;
  late final String posterPath;
  late final String backdropPath;
  late final num rating;
  late final String releaseDate;
  late final List<int> genreIds; // Add this line
  List<Genre>? availableGenres; // New property to hold the genres

  Movie({
    required this.id, // Include 'id' in the constructor
    required this.name,
    required this.language,
    required this.isAdult,
    required this.description,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.genreIds, // Include genreIds in the constructor
    this.availableGenres, // Add availableGenres to constructor
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0, // Provide default value if 'id' is not available
      name: json['title'] ?? 'Unknown', // Provide default values
      language: json['original_language'] ?? 'en',
      isAdult: json['adult'] ?? false,
      description: json['overview'] ?? 'No description available',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      rating: json['vote_average'] ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown',
      genreIds: List<int>.from(json['genre_ids'] ?? []), // Add this line
    );
  }

  String posterURL() {
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.baseImageApiUrl}${this.posterPath}';
  }

  List<String> get genreNames {
    if (availableGenres == null) return [];
    return availableGenres!
        .where((genre) => genreIds.contains(genre.id))
        .map((genre) => genre.name)
        .toList();
  }
}
