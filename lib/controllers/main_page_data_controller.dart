//Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../models/search_category.dart';

//Services
import '../models/movie_details.dart';
import '../services/movie_service.dart';

//Models
import '../models/main_page_data.dart';
import '../models/movie.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> movies = [];
      List<Movie> nowPlayingMovies = [];

      if (state.searchText.isEmpty) {
        movies = await movieService.getMovies(
            page: state.page, movieTypeEndpoint: 'popular');

        nowPlayingMovies = await movieService.getMovies(
            page: state.page, movieTypeEndpoint: 'now_playing');
      } else {
        movies = await movieService.searchMovies(state.searchText);
      }

      state = state.copyWith(
        movies: [...state.movies, ...movies],
        nowPlayingMovies: [...state.nowPlayingMovies, ...nowPlayingMovies],
        page: state.page + 1,
      );
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String? category) {
    try {
      state = state.copyWith(
        movies: [],
        nowPlayingMovies: [],
        page: 1,
        searchCategory: category,
        searchText: '',
      );
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  Future<List<MovieDetails>> getMovieDetails(int movieId) async {
    try {
      List<MovieDetails> movieDetails = [];
      movieDetails = await movieService.getMovieDetails(movieId: movieId);
      return movieDetails;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<MovieDetailsCredits>> getMovieDetailsCredit(int movieId) async {
    try {
      List<MovieDetailsCredits> movieDetailsCredits = [];
      movieDetailsCredits =
          await movieService.getMovieDetailsCredits(movieId: movieId);
      return movieDetailsCredits;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
