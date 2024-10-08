import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/cast.dart';
import 'package:movie_app/models/movie_details.dart';
import 'package:movie_app/models/video.dart';
import 'package:movie_app/services/http_service.dart';
import 'package:movie_app/models/genre.dart';
import 'package:movie_app/models/genre_list.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService _http; // Use 'late final' for initialization

  MovieService() {
    _http = getIt.get<HTTPService>(); // Fetch the HTTPService instance
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    // Fetch genres
    List<Genre> genres = await fetchGenres();
    // Fetch movies
    List<Movie> movies = await _fetchMovies('/movie/popular', page: page);

    // Assign genres to each movie
    for (var movie in movies) {
      movie.availableGenres = genres; // Set the available genres for each movie
    }

    return movies;
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    List<Genre> genres = await fetchGenres(); // Fetch genres
    List<Movie> movies = await _fetchMovies('/movie/upcoming', page: page);

    for (var movie in movies) {
      movie.availableGenres = genres; // Assign genres to each movie
    }

    return movies;
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    List<Genre> genres = await fetchGenres(); // Fetch genres
    List<Movie> movies = await _fetchMovies('/movie/now_playing', page: page);

    for (var movie in movies) {
      movie.availableGenres = genres; // Assign genres to each movie
    }

    return movies;
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    List<Genre> genres = await fetchGenres(); // Fetch genres
    List<Movie> movies = await _fetchMovies('/movie/top_rated', page: page);

    for (var movie in movies) {
      movie.availableGenres = genres; // Assign genres to each movie
    }

    return movies;
  }

  Future<List<Movie>> _fetchMovies(String endpoint, {int page = 1}) async {
    Response<dynamic>? response = await _http.get(endpoint, query: {
      'page': page,
    });

    if (response == null || response.statusCode != 200) {
      throw Exception('Could not load movies from $endpoint');
    }

    Map<String, dynamic> data = response.data;
    List<Movie> movies = (data['results'] as List)
        .map((movieData) => Movie.fromJson(movieData))
        .toList();
    return movies;
  }

  Future<List<Movie>> searchMovies({required String query}) async {
    try {
      List<Genre> genres = await fetchGenres(); // Fetch genres
      final response = await _http.get('/search/movie', query: {
        'query': query,
        'language': 'en-US',
      });

      if (response == null ||
          response.data == null ||
          response.data['results'] == null ||
          response.data['results'].isEmpty) {
        print('No results found for query: $query');
        return [];
      }

      // Use a Set to track unique movie IDs instead of names
      Set<int> uniqueMovieIds = {};
      List<Movie> movies = [];

      for (var movieData in response.data['results']) {
        Movie movie = Movie.fromJson(movieData);
        if (!uniqueMovieIds.contains(movie.id)) {
          uniqueMovieIds.add(movie.id); // Track by movie ID, not name
          movies.add(movie);
        }
      }

      // Assign genres to each unique movie
      for (var movie in movies) {
        movie.availableGenres = genres; // Set available genres
      }

      return movies;
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  Future<List<Cast>> getMovieCast({required int movieId}) async {
    try {
      final response = await _http.get('/movie/$movieId/credits');

      if (response == null || response.statusCode != 200) {
        print('Invalid response for movie ID: $movieId');
        return [];
      }

      final List<dynamic> castData = response.data['cast'] ?? [];
      return castData.map((castJson) => Cast.fromJson(castJson)).toList();
    } catch (e) {
      print('Error fetching cast for movie ID $movieId: $e');
      return [];
    }
  }

  Future<MovieDetails> getMovieDetails({required int movieId}) async {
    try {
      final response = await _http.get('/movie/$movieId');

      if (response == null || response.statusCode != 200) {
        throw Exception('Failed to load movie details for ID: $movieId');
      }

      return MovieDetails.fromJson(response.data);
    } catch (e) {
      print('Error fetching details for movie ID $movieId: $e');
      throw e; // Re-throw the exception for further handling
    }
  }

  Future<List<Video>> getMovieVideos({required int movieId}) async {
    try {
      final response = await _http.get('/movie/$movieId/videos');

      if (response == null || response.statusCode != 200) {
        print('Invalid response for movie ID: $movieId');
        return [];
      }

      final List<dynamic> videoData = response.data['results'] ?? [];
      return videoData
          .where((videoJson) => videoJson['type'] == 'Trailer')
          .map((videoJson) => Video.fromJson(videoJson))
          .toList();
    } catch (e) {
      print('Error fetching videos for movie ID $movieId: $e');
      return [];
    }
  }

  Future<List<Genre>> fetchGenres() async {
    try {
      final response = await _http.get('/genre/movie/list');

      if (response == null || response.statusCode != 200) {
        throw Exception('Failed to load genres');
      }

      final List<dynamic> genresData = response.data['genres'];
      return genresData.map((genreJson) => Genre.fromJson(genreJson)).toList();
    } catch (e) {
      print('Error fetching genres: $e');
      return [];
    }
  }
}
