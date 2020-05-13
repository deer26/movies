import 'package:flutter/material.dart';
import 'package:movie/database/movie_db_helper.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/models/favor_model.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/models/movie_db_model.dart';
import 'package:movie/resources/favor_api_provider.dart';
import 'package:movie/resources/genre_api_provider.dart';

import 'detail_movie_screen.dart';

class FavorMovieScreen extends StatefulWidget {
  @override
  _FavorMovieScreenState createState() => _FavorMovieScreenState();
}

class _FavorMovieScreenState extends State<FavorMovieScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Favourite List"),
        backgroundColor: bgColor,
      ),
      body: FutureBuilder(
          future: _getFavList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<FavorDBModel>> snap) {
            if (snap.hasData && snap.data.length > 0) {
              return ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getMovieApi(snap.data[index].movieId),
                        builder: (BuildContext context,
                            AsyncSnapshot<FavorModel> snapshot) {
                          if (snapshot.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18, bottom: 18),
                                  child: InkWell(
                                    onTap: () async {
                                      List<String> _currentGenres = List();
                                      if (snapshot.data.genres.length > 0) {
                                        snapshot.data.genres.forEach((val) {
                                          _currentGenres.add(val.name);
                                        });
                                      }
                                      bool isFavor = true;
                                      Results results = Results();
                                      results.backdropPath =
                                          snapshot.data.backdropPath;
                                      results.voteAverage =
                                          snapshot.data.voteAverage.toString();
                                      results.voteCount =
                                          snapshot.data.voteCount;
                                      results.overview = snapshot.data.overview;
                                      results.id = snapshot.data.id;
                                      results.posterPath =
                                          snapshot.data.posterPath;
                                      results.popularity =
                                          snapshot.data.popularity.toString();
                                      results.title = snapshot.data.title;
                                      results.releaseDate =
                                          snapshot.data.releaseDate;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailMovieScreen(results,
                                                  _currentGenres, isFavor),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          _getFavList();
                                        });
                                      });
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.network(
                                          "$photoBaseUrl${snapshot.data.posterPath}",
                                          height: 200,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.title,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data.releaseDate,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          getGenreType(snapshot.data.genres),
                                          softWrap: true,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          "🌟 ${snapshot.data.voteAverage} / 10",
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  });
            }
            return Center(
              child: Text(
                "Your favourite list\n is empty",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            );
          }),
    );
  }
}

Future<List<FavorDBModel>> _getFavList() async {
  FavorDBHelper dbHelper = FavorDBHelper();
  List<FavorDBModel> sonuc = await dbHelper.getAllFavor();
  return sonuc;
}

Future<FavorModel> getMovieApi(int movieId) async {
  FavorApiProvider apiProvider = FavorApiProvider();
  FavorModel sonuc = await apiProvider.getFavorList(movieId);
  return sonuc;
}

String getGenreType(List<Genres> genres) {
  String _tip = " ";
  List<String> _tipler = List();
  if (genres.length > 0) {
    genres.forEach((val) => _tipler.add(val.name));
    _tip = _tipler.join(",");
  }
  return _tip;
}
