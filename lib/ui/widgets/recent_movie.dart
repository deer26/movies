import 'package:flutter/material.dart';
import 'package:movie/bloc/movies_bloc.dart';
import 'package:movie/database/movie_db_helper.dart';
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/resources/movie_api_provider.dart';
import 'package:movie/ui/pages/detail_movie_screen.dart';

class RecentMovie extends StatefulWidget {
  @override
  _RecentMovieState createState() => _RecentMovieState();
}

class _RecentMovieState extends State<RecentMovie> {
  final movieBloc = MovieBloc();
  @override
  void initState() {
    super.initState();
    movieBloc.dispatch("now_playing");
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
            return Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              height: 250,
              child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: snapshot.data.results.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
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
                      child: Container(
                        margin: EdgeInsets.all(0),
                        width: 180,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 0, right: 8, bottom: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: snapshot.data.results[index]
                                              .getPosterPath !=
                                          null
                                      ? Image.network(
                                          "$photoBaseUrl${snapshot.data.results[index].getPosterPath}",
                                        )
                                      : Image.asset("assets/icon/noimage.jpg"),
                                ),
                              ),
                            ),
                            Text(
                              snapshot.data.results[index].getTitle,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
