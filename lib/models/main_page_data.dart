//Models
import '../models/movie.dart';
import '../models/search_category.dart';

class MainPageData {
  final List<Movie> movies;
  final List<Movie> nowPlayingMovies;
  final int page;
  final String searchCategory;
  final String searchText;

  MainPageData({
    required this.movies,
    required this.nowPlayingMovies,
    required this.page,
    required this.searchCategory,
    required this.searchText,
  });

  MainPageData.initial()
      : movies = [],
        nowPlayingMovies = [],
        page = 1,
        searchCategory = SearchCategory.none,
        searchText = '';

  MainPageData copyWith({
    List<Movie>? movies,
    List<Movie>? nowPlayingMovies,
    int? page,
    String? searchCategory,
    String? searchText,
  }) {
    return MainPageData(
      movies: movies ?? this.movies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      page: page ?? this.page,
      searchCategory: searchCategory ?? this.searchCategory,
      searchText: searchText ?? this.searchText,
    );
  }
}
