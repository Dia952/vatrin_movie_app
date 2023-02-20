import 'dart:ui';

//Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/main_page_data.dart';
import '../models/movie.dart';

//Widgets
import '../widgets/movie_tile.dart';

//Models
import '../models/search_category.dart';

//Controllers
import '../controllers/main_page_data_controller.dart';
import 'movie_details_page.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController>(
        (ref) => MainPageDataController());

final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final movies = ref.watch(mainPageDataControllerProvider.state).movies;
  return movies.isNotEmpty ? movies[0].posterURL() : null;
});

class MainPage extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;

  var selectedMoviePosterURL;

  MainPageDataController? mainPageDataController;
  MainPageData? mainPageData;

  TextEditingController? _searchTextFieldController;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    mainPageDataController = watch(mainPageDataControllerProvider);
    mainPageData = watch(mainPageDataControllerProvider.state);
    selectedMoviePosterURL = watch(selectedMoviePosterURLProvider);

    _searchTextFieldController = TextEditingController();

    _searchTextFieldController!.text = mainPageData!.searchText;

    return _buildUI(context);
  }

  Widget _buildUI(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Vatrin Film',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      drawer: const NavigationDrawer(
        backgroundColor: Colors.transparent,
        elevation: 1,
        children: [
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            title: Text(
              'Favorites',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.movie_filter_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Movies',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
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
    if (selectedMoviePosterURL.state != null) {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(selectedMoviePosterURL.state),
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
    } else {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
  }

  Widget _foregroundWidgets() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, _deviceHeight! * 0.02, 0, 0),
        width: _deviceWidth! * 0.88,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBarWidget(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Now Showing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 320,
              child: _moviesHorizontalListViewWidget(),
            ),
            const Text(
              'Popular',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: _deviceHeight! * 0.5,
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
              child: _moviesVerticalListViewWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    const border = InputBorder.none;

    return SizedBox(
      width: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (input) {
          mainPageDataController!.updateTextSearch(input);
        },
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          focusedBorder: border,
          border: border,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white24,
          ),
          hintStyle: TextStyle(color: Colors.white54),
          filled: false,
          fillColor: Colors.white24,
          hintText: 'Search...',
        ),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: mainPageData!.searchCategory,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        color: Colors.transparent,
      ),
      onChanged: (value) => value.toString().isNotEmpty
          ? mainPageDataController!.updateSearchCategory(value)
          : null,
      items: const [
        DropdownMenuItem(
          value: SearchCategory.popular,
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.nowShowing,
          child: Text(
            SearchCategory.nowShowing,
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownMenuItem(
          value: SearchCategory.none,
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _moviesVerticalListViewWidget() {
    final List<Movie> movies = mainPageData!.movies;

    if (movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              mainPageDataController!.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight! * 0.01, horizontal: 0),
              child: GestureDetector(
                onTap: () {
                  selectedMoviePosterURL.state = movies[index].posterURL();
                  mainPageDataController!
                      .getMovieDetails(movies[index].id)
                      .then((movieDetails) {
                    mainPageDataController!
                        .getMovieDetailsCredit(movies[index].id)
                        .then((movieCredits) => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MovieDetailsPage(
                                        movieDetails: movieDetails,
                                        movieCredits: movieCredits)),
                              )
                            });
                  });
                },
                child: MovieTile(
                  movie: movies[index],
                  height: _deviceHeight! * 0.20,
                  width: _deviceWidth! * 0.85,
                  vertical: true,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _moviesHorizontalListViewWidget() {
    final List<Movie> movies = mainPageData!.nowPlayingMovies;

    if (movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              mainPageDataController!.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                selectedMoviePosterURL.state = movies[index].posterURL();
                mainPageDataController!
                    .getMovieDetails(movies[index].id)
                    .then((movieDetails) {
                  mainPageDataController!
                      .getMovieDetailsCredit(movies[index].id)
                      .then((movieCredits) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailsPage(
                                      movieDetails: movieDetails,
                                      movieCredits: movieCredits)),
                            )
                          });
                });
              },
              child: Row(
                children: [
                  MovieTile(
                    movie: movies[index],
                    height: _deviceHeight! * 0.30,
                    width: _deviceWidth! * 0.90,
                    vertical: false,
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          color: Colors.white,
        ),
      );
    }
  }
}
