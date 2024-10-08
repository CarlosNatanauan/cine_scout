# CineScout

<p align="center">
  <img src="https://github.com/user-attachments/assets/5cf1b1e1-216c-4744-9e2a-7b0c85b0247b" width="230" height="500"/>
  <br />
  <strong>CineScout App Showcase</strong>
</p>

## Overview

CineScout is a simple Flutter application that serves as a test app for a REST API. It allows users to explore and search for movies. Users can view popular, upcoming, now playing, and top-rated movies. The app also includes a search feature for specific movie titles and provides detailed information about selected movies.

<p align="center">
  <img src="https://github.com/user-attachments/assets/663afdc1-47f3-4406-8e12-b005bff91803" width="700" />
  <img src="https://github.com/user-attachments/assets/73edc02a-a179-41db-813b-34c6d5d683d9" width="700" />
</p>

## Features

- **Browse Movies**: Users can browse through different categories of movies, including:
  - Popular Movies
  - Upcoming Movies
  - Now Playing Movies
  - Top Rated Movies

- **Search Functionality**: Users can search for movies by title using a search bar.

- **Movie Details**: Clicking on a movie will display detailed information, including genres and cast.

## Technologies Used

- **Flutter**: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Riverpod**: A state management library for Flutter applications that provides a simple and efficient way to manage state.
- **Dio**: A powerful HTTP client for Dart, used for making API requests.
- **GetIt**: A service locator for Dart and Flutter to easily manage dependencies.

## API

This application uses the **REST API** provided by [The Movie Database (TMDb) API](https://www.themoviedb.org/documentation/api) to fetch movie data. The TMDb API is a public API that allows developers to access a vast collection of movie and TV show data through standard HTTP requests. Key features of the API include:

- Movie details (title, overview, release date, genres, etc.)
- Cast information
- Movie trailers and videos
- Popularity rankings and ratings

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/movie_app.git


2. Navigate to the project directory:
   ```bash
   cd movie_app


3. Install the dependencies:
   ```bash
   flutter pub get


4. Run the app:
   ```bash
   flutter run
