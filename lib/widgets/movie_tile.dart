//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Models
import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  final double height;
  final double width;
  final Movie movie;
  final bool vertical;

  MovieTile({
    super.key,
    required this.movie,
    required this.height,
    required this.width,
    required this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _moviePosterWidgetVertical(movie.posterURL()),
          _movieInfoWidgetVertical(),
        ],
      );
    } else {
      return SizedBox(
        width: width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _moviePosterWidgetHorizontal(movie.posterURL()),
            _movieInfoWidgetHorizontal(),
          ],
        ),
      );
    }
  }

  Widget _moviePosterWidgetVertical(String imageURL) {
    return Container(
      height: height,
      width: width * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageURL),
        ),
      ),
    );
  }

  Widget _moviePosterWidgetHorizontal(String imageURL) {
    return Container(
      height: height,
      width: width * 0.50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageURL),
        ),
      ),
    );
  }

  Widget _movieInfoWidgetVertical() {
    return SizedBox(
      height: height,
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.56,
                child: Text(
                  movie.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${movie.rating!.toStringAsFixed(1)}/10",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.watch_later_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    movieGenre(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _movieInfoWidgetHorizontal() {
    return SizedBox(
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.56,
                child: Text(
                  movie.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${movie.rating!.toStringAsFixed(1)}/10",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String movieGenre() {
    String genre = '';

    movie.genreIds?.forEach((element) {
      genre = '$genre${moviesGenreList[element]!}';
    });

    return genre;
  }

  static const moviesGenreList = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
  };
}
