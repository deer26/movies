import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:movie/database/movie_db_helper.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/resources/genre_api_provider.dart';
import 'package:movie/resources/see_all_api_provider.dart';

import 'detail_movie_screen.dart';

class SeeAllMovie extends StatefulWidget {
  final String movieType;
  SeeAllMovie({@required this.movieType});

  @override
  _SeeAllMovieState createState() => _SeeAllMovieState();
}

class _SeeAllMovieState extends State<SeeAllMovie> {
  int get count => list.length;

  List<Results> list = [];
  int pageNo = 1;
  int totalPage = 0;

  void initState() {
    super.initState();
    _getData();
  }

  void load() {
    print("load");
    setState(() {
      _getData();
      print("data count = ${list.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: new AppBar(
        backgroundColor: bgColor,
        title: widget.movieType == "popular"
            ? Text("All Popular List")
            : Text("All Recent List"),
      ),
      body: Container(
        child: RefreshIndicator(
          child: LoadMore(
            isFinish: pageNo > totalPage,
            onLoadMore: _loadMore,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
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
                            for (var item in list[index].genreIds) {
                              for (var str in genreModelGlobal.genres) {
                                if (item == str.id) {
                                  _currentGenres.add(str.name);
                                }
                              }
                            }
                          }
                          FavorDBHelper dbHelper = FavorDBHelper();
                          var sonuc = await dbHelper.isFavorDB(list[index].id);
                          bool isFavor = false;
                          if (sonuc.isNotEmpty) {
                            isFavor = true;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMovieScreen(
                                  list[index], _currentGenres, isFavor),
                            ),
                          );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: list[index].getPosterPath != null
                                ? Image.network(
                                    "$photoBaseUrl${list[index].getPosterPath}",
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
                              list[index].title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                            Text(
                              list[index].getReleaseDate,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              getGenreType(list[index].genreIds),
                              softWrap: true,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              "🌟 ${list[index].voteAverage} / 10",
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
              },
              itemCount: count,
            ),
            whenEmptyLoad: false,
            delegate: DefaultLoadMoreDelegate(),
            textBuilder: (status) {
              String text;
              switch (status) {
                case LoadMoreStatus.fail:
                  text = "Load Failed...";
                  break;
                case LoadMoreStatus.idle:
                  text = "Empty Data...";
                  break;
                case LoadMoreStatus.loading:
                  text = "Loading...";
                  break;
                case LoadMoreStatus.nomore:
                  text = "No More...";
                  break;
                default:
                  text = "";
              }
              return text;
            },
          ),
          onRefresh: _refresh,
        ),
      ),
    );
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

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));

    setState(() {
      pageNo++;
    });
    load();
    return true;
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    list.clear();
    load();
  }

  void _getData() async {
    SeeAllApiProvider()
        .fetchSeeAll(widget.movieType, pageNo.toString())
        .then((value) {
      setState(() {
        list.addAll(value.results);
        totalPage = value.totalPages;
      });
    });
  }
}
