import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for number formatting
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/cast.dart'; // Import Cast model
import 'package:movie_app/models/movie_details.dart'; // Import MovieDetails model
import 'package:movie_app/services/movie_service.dart'; // Import MovieService
import 'package:movie_app/models/video.dart'; // Import Video model
import 'package:movie_app/video/trailer_player.dart'; // Import TrailerPlayer

import 'package:simple_animated_button/simple_animated_button.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  final VoidCallback onClose; // Callback to close the screen

  MovieDetailsScreen({required this.movie, required this.onClose});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late MovieService _movieService;
  List<Cast> _castList = [];
  MovieDetails? _movieDetails; // To hold the movie details
  List<Video> _videos = []; // To hold the video list
  String? _trailerKey; // To hold the trailer video key
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _movieService = MovieService(); // Initialize the MovieService
    _fetchMovieCast(); // Fetch the cast for the movie
    _fetchMovieDetails(); // Fetch the details for the movie
    _fetchMovieVideos(); // Fetch the videos for the movie
  }

  Future<void> _fetchMovieCast() async {
    try {
      List<Cast> cast =
          await _movieService.getMovieCast(movieId: widget.movie.id);
      setState(() {
        _castList = cast;
        _isLoading = false; // Set loading to false after fetching cast
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Handle loading state in case of error
      });
      print('Error fetching cast: $e');
    }
  }

  Future<void> _fetchMovieDetails() async {
    try {
      MovieDetails details =
          await _movieService.getMovieDetails(movieId: widget.movie.id);
      setState(() {
        _movieDetails = details; // Store the movie details
      });
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }

  Future<void> _fetchMovieVideos() async {
    try {
      List<Video> videos =
          await _movieService.getMovieVideos(movieId: widget.movie.id);
      if (videos.isNotEmpty) {
        _trailerKey = videos.first.key;
      }
      setState(() {
        _videos = videos; // Store the video list
      });
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Solid black background color
      body: Stack(
        children: [
          SingleChildScrollView(
            // Make the entire screen scrollable
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align all content to the start
                children: [
                  SizedBox(height: 50), // Space for the AppBar
                  _movieTitle(), // Movie title section
                  SizedBox(height: 10),
                  _moviePoster(), // Movie poster image
                  SizedBox(height: 20),
                  _buildMovieDetails(), // Overview comes first
                  SizedBox(height: 20),
                  _trailerSection(), // Trailer section
                  SizedBox(height: 20),
                  _castSection(), // Cast section after the trailer
                  SizedBox(height: 10),
                  _otherMovieDetails(), // Other movie details (budget, revenue, etc.)
                ],
              ),
            ),
          ),
          _customAppBar(context), // Custom AppBar section in the stack
        ],
      ),
    );
  }

  Widget _customAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 16, 16, 16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
        children: [
          ElevatedLayerButton(
            onClick: () {
              // Close the screen or perform any other action
              Navigator.of(context).pop();
            },
            buttonHeight: 30, // Adjust height for the button
            buttonWidth: 90, // Set desired width for the button
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.ease,
            topDecoration: BoxDecoration(
              color: Color.fromARGB(255, 167, 17, 0), // Top layer color
            ),
            topLayerChild: Row(
              mainAxisSize: MainAxisSize.min, // Minimize size of the top layer
              children: [
                Icon(Icons.close, size: 14, color: Colors.white), // Close icon
                SizedBox(width: 4), // Space between icon and text
                Text(
                  "Close", // Button text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Font size for the text
                  ),
                ),
              ],
            ),
            baseDecoration: BoxDecoration(
              color: Color.fromARGB(255, 74, 7, 0), // Base layer color
            ),
          ),
        ],
      ),
    );
  }

  Widget _movieTitle() {
    return Center(
      child: Text(
        widget.movie.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24, // Increased font size for the title
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _moviePoster() {
    return Center(
      child: Container(
        width: 120, // Set fixed width for the image
        height: 180, // Set fixed height for the image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.movie.posterURL()),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
      ),
    );
  }

  Widget _buildMovieDetails() {
    if (_movieDetails == null) {
      return CircularProgressIndicator(
          color: Colors.white); // Show loading spinner
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview', // Title for overview section
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8), // Space between title and content
        Text(
          _movieDetails!.overview,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _trailerSection() {
    if (_trailerKey == null) {
      return Container(); // No trailer available
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trailer', // Title for the trailer section
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TrailerPlayer(videoKey: _trailerKey!), // Embedded trailer player
      ],
    );
  }

  Widget _castSection() {
    if (_castList.isEmpty) {
      return Text(
        'No cast available.',
        style: TextStyle(color: Colors.white, fontSize: 14),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast', // Cast section title
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 150, // Fixed height for cast cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            itemCount: _castList.length,
            itemBuilder: (context, index) {
              return _castCard(_castList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _castCard(Cast cast) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          // Cast image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: cast.profilePath.isNotEmpty
                    ? NetworkImage(
                        'https://image.tmdb.org/t/p/w500${cast.profilePath}')
                    : AssetImage('assets/images/no_image_profile.png')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8), // Space between image and name
          Flexible(
            child: Text(
              cast.name,
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Add ellipsis if overflow
            ),
          ),
          SizedBox(height: 4), // Space between name and character
          Text(
            cast.character,
            style: TextStyle(
                color: Colors.grey, fontSize: 10), // Character name style
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _otherMovieDetails() {
    if (_movieDetails == null) {
      return Container(); // Return empty container if no details
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other Details', // Title for other movie details section
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Genres: ${_movieDetails!.genres.join(', ')}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          'Duration: ${_movieDetails!.runtime} minutes',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          'Release Date: ${_movieDetails!.releaseDate}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          'Status: ${_movieDetails!.status}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          'Budget: \$${NumberFormat('#,##0').format(_movieDetails!.budget)}', // Format the budget
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          'Revenue: \$${NumberFormat('#,##0').format(_movieDetails!.revenue)}', // Format the revenue
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
