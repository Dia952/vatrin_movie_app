//Packages
import 'package:get_it/get_it.dart';

//Models
import '../models/app_config.dart';

class Movie {
  final String? name;
  final int id;
  final String? language;
  final bool isAdult;
  final String? description;
  final String? posterPath;
  final String? backdropPath;
  final num? rating;
  final String? releaseDate;
  final String? duration;
  final List? genreIds;

  Movie({
    required this.name,
    required this.id,
    required this.language,
    required this.isAdult,
    required this.description,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.duration,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['title'],
      id: json['id'],
      language: json['original_language'],
      isAdult: json['adult'],
      description: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      rating: json['vote_average'],
      releaseDate: json['release_date'],
      duration: json['duration'],
      genreIds: json['genre_ids'],
    );
  }

  String posterURL() {
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.BASE_IMAGE_API_URL}$posterPath';
  }
}
