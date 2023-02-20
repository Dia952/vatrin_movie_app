import 'dart:ui';

//Packages
import 'package:flutter/material.dart';

//Widgets
import '../models/movie_details.dart';

class MovieDetailsPage extends StatelessWidget {
  double? _deviceHeight;
  double? _deviceWidth;

  List<MovieDetails> movieDetails;
  List<MovieDetailsCredits> movieCredits;

  MovieDetailsPage({
    super.key,
    required this.movieDetails,
    required this.movieCredits,
  });

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SizedBox(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(movieDetails[0].posterURL()),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _foregroundWidgets() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movieDetails[0].posterURL()),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _movieInfoWidget(),
                  Container(
                    height: _deviceHeight! * 0.25,
                    padding: EdgeInsets.only(top: _deviceHeight! * 0.01),
                    child: _actorsListViewWidget(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movieDetails[0].name.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.yellow,
              size: 17,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "${movieDetails[0].rating!.toStringAsFixed(1)}/10",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Colors.teal,
            padding: const EdgeInsets.all(4),
            child: Text(
              movieDetails[0].genreIds![0]['name'].toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              "Length",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
            Text(
              "Language",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
            Text(
              "Rating",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '${movieDetails[0].duration.toString()}min',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Text(
              movieDetails[0].language.toString().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Text(
              movieDetails[0].isAdult ? '+18' : 'PG',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          movieDetails[0].description.toString(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Actors',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _actorsListViewWidget() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: movieCredits[0].cast.length,
      itemBuilder: (BuildContext context, int index) {
        if (movieCredits[0].cast[index]['profile_path'] != null) {
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: _deviceHeight! * 0.01, horizontal: 0),
            child: Image(
              image: NetworkImage(
                getImagePath(movieCredits[0].cast[index]['profile_path']),
              ),
            ),
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(width: 10),
    );
  }

  String getImagePath(String path) {
    return 'https://image.tmdb.org/t/p/w440_and_h660_face/$path';
  }
}
