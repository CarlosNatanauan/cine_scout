// movie_details.dart

class MovieDetails {
  final String title;
  final String overview;
  final String tagline;
  final List<String> genres; // List of genres
  final int runtime; // Duration in minutes
  final String releaseDate; // Release date
  final String homepage; // Movie homepage
  final int budget; // Budget of the movie
  final int revenue; // Revenue of the movie
  final String status; // Release status

  MovieDetails({
    required this.title,
    required this.overview,
    required this.tagline,
    required this.genres,
    required this.runtime,
    required this.releaseDate,
    required this.homepage,
    required this.budget,
    required this.revenue,
    required this.status,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      tagline: json['tagline'] ?? '',
      genres: List<String>.from(json['genres'].map((genre) => genre['name'])),
      runtime: json['runtime'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      homepage: json['homepage'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}
