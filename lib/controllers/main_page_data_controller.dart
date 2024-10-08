import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/main_page_data.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/movie_service.dart';
import 'package:movie_app/models/search_category.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }

  late final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];

      // Check if we are searching
      if (state.searchText.isNotEmpty) {
        // Fetch movies based on the search text
        _movies = await _movieService.searchMovies(query: state.searchText);

        // Set the page to 1 since this is a fresh search
        state = state.copyWith(movies: _movies, page: 1); // Reset page to 1
      } else {
        // Fetch movies based on the current category
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await _movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await _movieService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.nowPlaying) {
          _movies = await _movieService.getNowPlayingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.topRated) {
          _movies = await _movieService.getTopRatedMovies(page: state.page);
        } else {
          _movies = []; // Handle 'none' case if needed
        }

        // Append to existing movies, but only if not searching
        state = state.copyWith(
            movies: [...state.movies, ..._movies], page: state.page + 1);
      }
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  // Method to update search category and reset the movie list
  void updateSearchCategory(String category) {
    // Reset the page and movie list when category changes
    state = state.copyWith(movies: [], page: 1, searchCategory: category);
    getMovies(); // Fetch movies with the new category
  }

// Method to update the search text and fetch movies based on it
  void updateSearchText(String searchText) {
    // Only reset the selected category label if there's text in the search field
    if (searchText.isNotEmpty) {
      state = state.copyWith(
        searchText: searchText,
        movies: [], // Clear the existing movies
        page: 1, // Reset page for new search
        searchCategory:
            SearchCategory.none, // Assuming 'none' is a valid category
        selectedCategoryLabel:
            '', // Set the selected category label to an empty string
      );
    } else {
      // If searchText is empty, just update the searchText without affecting other fields
      state = state.copyWith(searchText: searchText);
    }
    getMovies(); // Fetch movies with the new search text
  }
}
