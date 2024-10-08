import 'dart:ui';
import 'package:movie_app/controllers/main_page_data_controller.dart';
import 'package:movie_app/models/main_page_data.dart';
import '../widgets/movie_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_category.dart';
import '../models/movie.dart';
import 'package:flutter/foundation.dart';
import '../services/movie_service.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});

class MainPage extends ConsumerStatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final TextEditingController _searchTextFieldController =
      TextEditingController();
  late ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  Movie? _selectedMovie;
  String _selectedMovieImageUrl = '';

  late final MovieService _movieService;

  @override
  void initState() {
    super.initState();
    _movieService = MovieService();
    _searchTextFieldController.addListener(_onSearchTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movies = ref.read(mainPageDataControllerProvider).movies;
      if (movies.isNotEmpty) {
        setState(() {
          _selectedMovieImageUrl = movies[0].posterURL();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    Future.delayed(Duration(milliseconds: 300), () {
      String searchText = _searchTextFieldController.text;
      _searchQuery.value = searchText;
      ref
          .read(mainPageDataControllerProvider.notifier)
          .updateSearchText(searchText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    final _mainPageData = ref.watch(mainPageDataControllerProvider);
    final _mainPageDataController =
        ref.read(mainPageDataControllerProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(_deviceHeight, _deviceWidth),
            _foregroundWidgets(
              _mainPageData,
              _deviceHeight,
              _deviceWidth,
              _searchTextFieldController,
              _mainPageDataController,
              ref,
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
            _selectedMovieImageUrl.isNotEmpty
                ? _selectedMovieImageUrl
                : 'https://i.pinimg.com/736x/18/1e/e8/181ee8ed9c9638926b46dccc98b7b85d.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _foregroundWidgets(
    MainPageData mainPageData,
    double deviceHeight,
    double deviceWidth,
    TextEditingController searchTextFieldController,
    MainPageDataController mainPageDataController,
    WidgetRef ref,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, deviceHeight * 0.01, 0, 0),
      width: deviceWidth * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchBarWidget(mainPageDataController, searchTextFieldController,
              deviceHeight, deviceWidth),
          SizedBox(height: 5), // Space between search bar and category icons
          Text(
            'Categories', // Label for categories
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 12, // Small font size for label
              fontWeight: FontWeight.w400, // Optional: adjust font weight
            ),
          ),
          SizedBox(height: 5),
          _categoryIcons(mainPageDataController), // Icons below the search bar
          SizedBox(height: 5),
          _categoryLabel(mainPageDataController), // Display selected category
          Container(
            height: deviceHeight * 0.70, // Adjust height for better layout
            padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
            child: _movieListViewWidget(
                mainPageData.movies, deviceHeight, deviceWidth, ref),
          ),
        ],
      ),
    );
  }

  Widget _searchBarWidget(
      MainPageDataController mainPageDataController,
      TextEditingController searchTextFieldController,
      double deviceHeight,
      double deviceWidth) {
    return Container(
      height: deviceHeight * 0.09,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
      child: Row(
        children: [
          Expanded(
            child: _searchFieldWidget(
                searchTextFieldController, mainPageDataController),
          ),
        ],
      ),
    );
  }

  Widget _searchFieldWidget(TextEditingController searchTextFieldController,
      MainPageDataController mainPageDataController) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: TextField(
        controller: searchTextFieldController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white54),
          hintText: 'Search movie title...',
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.white54),
            onPressed: () {
              searchTextFieldController.clear();
              mainPageDataController.updateSearchText('');
            },
          ),
        ),
      ),
    );
  }

  Widget _categoryIcons(MainPageDataController mainPageDataController) {
    String selectedCategory = mainPageDataController.state.searchCategory;
    bool isSearchActive = mainPageDataController
        .state.searchText.isNotEmpty; // Determine if search is active

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _categoryIcon(
          Icons.whatshot, // Popular icon
          "Popular",
          selectedCategory,
          mainPageDataController,
          isSearchActive, // Pass the isSearchActive flag
        ),
        SizedBox(width: 10),
        _categoryIcon(
          Icons.new_releases, // Upcoming icon
          "Upcoming",
          selectedCategory,
          mainPageDataController,
          isSearchActive, // Pass the isSearchActive flag
        ),
        SizedBox(width: 10),
        _categoryIcon(
          Icons.play_circle_fill, // Now Playing icon
          "Now Playing",
          selectedCategory,
          mainPageDataController,
          isSearchActive, // Pass the isSearchActive flag
        ),
        SizedBox(width: 10),
        _categoryIcon(
          Icons.star, // Top Rated icon
          "Top Rated",
          selectedCategory,
          mainPageDataController,
          isSearchActive, // Pass the isSearchActive flag
        ),
      ],
    );
  }

  Widget _categoryIcon(
    IconData icon,
    String category,
    String selectedCategory,
    MainPageDataController mainPageDataController,
    bool isSearchActive, // New parameter
  ) {
    bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        // Only update the selected category if the search is inactive
        if (!isSearchActive) {
          mainPageDataController.updateSearchCategory(category);
        }
      },
      child: AbsorbPointer(
        absorbing: isSearchActive, // Disable interaction if search is active
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 30,
          ),
        ),
      ),
    );
  }

  // Display the currently selected category above the movie list
  Widget _categoryLabel(MainPageDataController mainPageDataController) {
    String selectedCategory = mainPageDataController.state.searchCategory;
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          selectedCategory.toUpperCase(), // Display category name
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _movieListViewWidget(List<Movie> movies, double deviceHeight,
      double deviceWidth, WidgetRef ref) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Check if we are at the bottom of the list
        if (!ref.read(mainPageDataControllerProvider).isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          ref.read(mainPageDataControllerProvider.notifier).getMovies();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: movies.length +
            (ref.read(mainPageDataControllerProvider).isLoading
                ? 1
                : 0), // Show loading indicator
        itemBuilder: (BuildContext context, int index) {
          if (index == movies.length) {
            return Center(
                child:
                    CircularProgressIndicator()); // Loading indicator at the end
          }

          bool isSelected = movies[index] ==
              _selectedMovie; // Check if this movie is selected

          return Padding(
            padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
            child: MovieTile(
              movie: movies[index],
              height: deviceHeight * 0.20,
              width: deviceWidth * 0.85,
              onTap: () {
                setState(() {
                  // Update the selected movie image URL and movie
                  _selectedMovieImageUrl = movies[index].posterURL();
                  _selectedMovie = movies[index]; // Set selected movie
                });
              },
              isSelected: isSelected, // Pass the isSelected flag
            ),
          );
        },
      ),
    );
  }
}
