// models/genre_list.dart
import 'genre.dart';

class GenreList {
  final List<Genre> genres;

  GenreList({required this.genres});

  // Factory method to create GenreList from JSON response
  factory GenreList.fromJson(List<dynamic> json) {
    List<Genre> genres =
        json.map((genreJson) => Genre.fromJson(genreJson)).toList();
    return GenreList(genres: genres);
  }

  // Method to get genre names by their IDs
  String getGenreNames(List<int> genreIds) {
    return genreIds
        .map((id) => genres
            .firstWhere((genre) => genre.id == id,
                orElse: () => Genre(id: 0, name: 'Unknown'))
            .name)
        .join(', ');
  }
}
