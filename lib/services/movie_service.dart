//Packages
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../models/movie_details.dart';
//Services
import '../services/http_service.dart';

//Models
import '../models/movie.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  HTTPService? http;

  MovieService() {
    http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getMovies(
      {int page = 1, String? movieTypeEndpoint}) async {
    String type = movieTypeEndpoint ?? 'popular';

    Response response = await http!.get('/movie/$type', query: {
      'page': page,
    });
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load $type movies..');
    }
  }

  Future<List<Movie>> searchMovies(String searchTerm, {int page = 1}) async {
    Response response = await http!.get('/search/movie', query: {
      'query': searchTerm,
      'page': page,
    });
    if (response.statusCode == 200) {
      Map data = response.data;

      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t perform movies search..');
    }
  }

  Future<List<MovieDetails>> getMovieDetails({int? movieId}) async {
    Response response = await http!.get('/movie/$movieId');
    if (response.statusCode == 200) {
      List data = [response.data];

      List<MovieDetails> movieDetails = data.map<MovieDetails>((movieData) {
        return MovieDetails.fromJson(movieData);
      }).toList();
      return movieDetails;
    } else {
      throw Exception('Couldn\'t load the movie details..');
    }
  }

  Future<List<MovieDetailsCredits>> getMovieDetailsCredits(
      {int? movieId}) async {
    Response response = await http!.get('/movie/$movieId/credits');
    if (response.statusCode == 200) {
      List data = [response.data];

      List<MovieDetailsCredits> movieDetailsCredits =
          data.map<MovieDetailsCredits>((movieData) {
        return MovieDetailsCredits.fromJson(movieData);
      }).toList();
      return movieDetailsCredits;
    } else {
      throw Exception('Couldn\'t load the movie details credits..');
    }
  }
}
