import 'package:flutter/material.dart';
import 'package:movie/bloc/movies_bloc.dart';
import 'package:movie/database/movie_db_helper.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/resources/movie_api_provider.dart';
import 'package:movie/ui/pages/detail_movie_screen.dart';

class PoupularMovie extends StatefulWidget {
  @override
  _PoupularMovieState createState() => _PoupularMovieState();
}

class _PoupularMovieState extends State<PoupularMovie> {
  final movieBloc = MovieBloc();
  @override
  void initState() {
    super.initState();
    movieBloc.dispatch("popular");
  }

  @override
  void dispose() {
    super.dispose();
    movieBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: movieBloc.movies,
        builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.results.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () async {
                              List<String> _currentGenres = List();
                              if (genreModelGlobal != null) {
                                for (var item
                                    in snapshot.data.results[index].genreIds) {
                                  for (var str in genreModelGlobal.genres) {
                                    if (item == str.id) {
                                      _currentGenres.add(str.name);
                                    }
                                  }
                                }
                              }
                              FavorDBHelper dbHelper = FavorDBHelper();
                              var sonuc = await dbHelper
                                  .isFavorDB(snapshot.data.results[index].id);
                              bool isFavor = false;
                              if (sonuc.isNotEmpty) {
                                isFavor = true;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailMovieScreen(
                                      snapshot.data.results[index],
                                      _currentGenres,
                                      isFavor),
                                ),
                              );
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: snapshot.data.results[index]
                                            .getPosterPath !=
                                        null
                                    ? Image.network(
                                        "$photoBaseUrl${snapshot.data.results[index].getPosterPath}",
                                        height: 200,
                                      )
                                    : Image.asset(
                                        "assets/icon/noimage.jpg",
                                        height: 200,
                                      )),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data.results[index].title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  snapshot.data.results[index].getReleaseDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  getGenreType(
                                      snapshot.data.results[index].genreIds),
                                  softWrap: true,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  "🌟 ${snapshot.data.results[index].voteAverage} / 10",
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
                  }),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  String getGenreType(List<int> genreIds) {
    List<String> _tipler = List();
    String _tip = " ";
    if (genreModelGlobal != null) {
      for (var item in genreIds) {
        for (var str in genreModelGlobal.genres) {
          if (item == str.id) {
            _tipler.add(str.name);
          }
        }
      }
    }

    if (_tipler.length > 0) {
      _tip = _tipler.join(",");
    }
    return _tip;
  }
}
