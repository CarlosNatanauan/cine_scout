import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_animated_button/simple_animated_button.dart';
import '../floating_forms/movie_details_form.dart';

class MovieTile extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  final double height;
  final double width;
  final Movie movie;
  final VoidCallback onTap; // Callback for when the tile is tapped
  final bool isSelected; // New parameter to indicate if the tile is selected

  MovieTile({
    required this.movie,
    required this.height,
    required this.width,
    required this.onTap, // Accept the onTap callback
    this.isSelected = false, // Default isSelected to false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Log movie details with genres directly
        print(
            'Movie ID: ${movie.id}, Title: ${movie.name}, Genre: ${movie.genreNames.join(', ')}');
        onTap(); // Call the onTap function when tapped
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.black54 : Colors.transparent,
          border: isSelected
              ? Border.all(color: Color.fromARGB(137, 58, 58, 58), width: 3.0)
              : null,
        ),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _moviePosterWidget(movie.posterURL()),
                _movieInfoWidget(),
              ],
            ),
            Positioned(
              bottom: 3,
              right: 3,
              child: _actionButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    return ElevatedLayerButton(
      onClick: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MovieDetailsScreen(
              movie: movie,
              onClose: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            );
          },
        );
      },
      buttonHeight: 30, // Adjust height for a smaller button
      buttonWidth: 90, // Set desired width for the button
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.ease,
      topDecoration: BoxDecoration(
        color: Color.fromARGB(
            255, 1, 109, 176), // Change button color for the top layer
      ),
      topLayerChild: Row(
        mainAxisSize: MainAxisSize.min, // Minimize size of the top layer
        children: [
          Icon(Icons.info, size: 14, color: Colors.white), // Smaller icon size
          SizedBox(width: 4), // Space between icon and text
          Text(
            "More Info",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10, // Font size for the text
            ),
          ),
        ],
      ),
      baseDecoration: BoxDecoration(
        color: Color.fromARGB(
            255, 0, 35, 112), // Change button color for the base layer
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Container(
      height: height,
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.56,
                child: Text(
                  movie.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                movie.rating.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
            child: Text(
              'Language: ${movie.language.toUpperCase()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
            child: Text(
              'Release Date: ${movie.releaseDate}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
            child: Text(
              'Genre: ${movie.genreNames.join(', ')}',
              maxLines: 2, // Allow a maximum of 2 lines
              overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String imagePath) {
    return Container(
      width: width * 0.3,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
