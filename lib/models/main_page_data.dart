import 'package:movie_app/models/search_category.dart';
import './movie.dart';

class MainPageData {
  late final List<Movie> movies;
  late final int page;
  late final String
      searchCategory; // You may want to change this to SearchCategory type for consistency
  late final String searchText;
  late final String
      selectedCategoryLabel; // New property for selected category label
  late final bool isLoading; // Indicates if loading is in progress
  late final bool hasMoreMovies; // Indicates if there are more movies to load

  MainPageData({
    required this.movies,
    required this.page,
    required this.searchCategory,
    required this.selectedCategoryLabel, // Include this in the constructor
    required this.searchText,
    this.isLoading = false,
    this.hasMoreMovies = true, // Initialize with true
  });

  MainPageData.initial()
      : movies = [],
        page = 1,
        searchCategory =
            SearchCategory.popular, // Change this to the appropriate type
        selectedCategoryLabel = '', // Initialize with empty string
        searchText = '',
        isLoading = false,
        hasMoreMovies = true; // Initialize with true

  MainPageData copyWith({
    List<Movie>? movies,
    int? page,
    String? searchCategory,
    String? searchText,
    String? selectedCategoryLabel, // Add this parameter
    bool? isLoading,
    bool? hasMoreMovies, // Add this parameter
  }) {
    return MainPageData(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      searchCategory: searchCategory ?? this.searchCategory,
      selectedCategoryLabel: selectedCategoryLabel ??
          this.selectedCategoryLabel, // Update selected category label
      searchText: searchText ?? this.searchText,
      isLoading: isLoading ?? this.isLoading,
      hasMoreMovies:
          hasMoreMovies ?? this.hasMoreMovies, // Update the loading state
    );
  }
}
