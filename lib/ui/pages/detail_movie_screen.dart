import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movie/database/movie_db_helper.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/models/movie_db_model.dart';
import 'package:movie/models/trailer_model.dart';
import 'package:movie/resources/movie_api_provider.dart';
import 'package:movie/resources/trailer_api_provider.dart';
import 'package:movie/ui/pages/favor_movie_screen.dart';
import 'package:movie/ui/pages/similar_movie_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMovieScreen extends StatefulWidget {
  final Results result;
  final List<String> currentGenres;
  final bool isFavor;
  DetailMovieScreen(this.result, this.currentGenres, this.isFavor);

  @override
  _DetailMovieScreenState createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  TrailerApiProvider trailerApiProvider = TrailerApiProvider();
  FavorDBHelper favorDBHelper = FavorDBHelper();
  bool favor;
  FlutterLocalNotificationsPlugin localNotifPlugin;
  @override
  void initState() {
    super.initState();
    favor = widget.isFavor;

    // notification process initialization

    var initSetAndroid = new AndroidInitializationSettings("app_icon");
    // var initSetAnd = new AndroidInitializationSettings("@mipmap/ic_launcher");//if you want to use default app icon
    var initSetIOS = new IOSInitializationSettings();

    var initSet = new InitializationSettings(initSetAndroid, initSetIOS);
    localNotifPlugin = FlutterLocalNotificationsPlugin();
    localNotifPlugin.initialize(initSet, onSelectNotification: _onSelectNotif);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: ListTile(
                              dense: true,
                              subtitle: Text(
                                widget.result.releaseDate != null
                                    ? widget.result.releaseDate
                                    : widget.result.getReleaseDate,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              title: Text(
                                widget.result.title,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          child: IconButton(
                              color: Colors.white,
                              icon: Icon(
                                favor ? Icons.favorite : Icons.favorite_border,
                              ),
                              onPressed: () {
                                _notificationProcess(favor);
                                _favorListProcess(favor).then((value) {
                                  AchievementView(context, onTab: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavorMovieScreen()));
                                  },
                                          isCircle: true,
                                          icon: value["icon"],
                                          duration: Duration(seconds: 1),
                                          color: bgColor,
                                          textStyleSubTitle:
                                              TextStyle(color: Colors.white),
                                          title: value["title"],
                                          subTitle: value["subtitle"])
                                      .show();
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    // alignment: WrapAlignment.spaceAround,
                    children: _genresList(),
                  ),
                ],
              ),
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.result.posterPath != null
                        ? NetworkImage(
                            "$photoDetailUrl${widget.result.posterPath}",
                          )
                        : AssetImage("assets/icon/noimage.jpg"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: textColor,
              thickness: 1,
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.result.popularity.toString(),
                            style:
                                TextStyle(color: popularityColor, fontSize: 30),
                          ),
                          Text(
                            "Popularity",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.green,
                            size: 30,
                          ),
                          RichText(
                            text: TextSpan(
                                text: widget.result.voteAverage,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "/10",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.result.voteCount.toString(),
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Vote Count",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Divider(
              indent: 10,
              endIndent: 10,
              color: textColor,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FlatButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SimilarMovie(id: widget.result.id)));
                      },
                      child: Text(
                        "Similar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                widget.result.overview,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Trailers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FutureBuilder(
                future: trailerApiProvider
                    .fetchTrailerList(widget.result.id.toString()),
                builder: (BuildContext context, AsyncSnapshot<Trailers> snap) {
                  if (snap.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          crossAxisCount: 3,
                          // scrollDirection: Axis.vertical,
                          children: _trailerList(snap.data.results)),
                    );
                  }
                  return Center(
                    child: Text(
                      "Trailer not available for this movie",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  List<Widget> _trailerList(List<ResultsTrailers> resultsTrailers) {
    List<Widget> listTrailer = List();

    resultsTrailers.forEach((val) {
      listTrailer.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  String _baseUrl;
                  if (val.site == "YouTube") {
                    _baseUrl = "https://www.youtube.com/watch?v=${val.key}";
                  } else if (val.site == "Vimeo") {
                    _baseUrl = "ttps://vimeo.com/${val.key}";
                  }

                  _launchVideo(_baseUrl);
                },
                child: Container(
                  height: 200,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.result.backdropPath != null
                          ? NetworkImage(
                              "$photoBaseUrl${widget.result.backdropPath}")
                          : AssetImage("assets/icon/noimage.jpg"),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                val.name,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
    if (listTrailer.length > 0) {
      return listTrailer;
    }
    listTrailer.add(
      Center(
        child: Text(
          "Trailer not available for this movie",
          style: TextStyle(
              color: Colors.yellow, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return listTrailer;
  }

  List<Widget> _genresList() {
    List<Widget> _movieGenres = List();
    widget.currentGenres.forEach((val) {
      _movieGenres.add(
        Container(
          margin: EdgeInsets.only(left: 5, top: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              val,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      );
    });

    if (_movieGenres.length > 0) {
      return _movieGenres;
    }

    _movieGenres.add(
      Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Not available to movie genres",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
    return _movieGenres;
  }

  void _launchVideo(String baseUrl) async {
    if (await canLaunch(baseUrl)) {
      await launch(baseUrl);
    } else {
      throw 'Could not launch $baseUrl';
    }
  }

  Future<Map<String, dynamic>> _favorListProcess(bool isFavor) async {
    Map<String, dynamic> _mesaj = Map();
    FavorDBHelper dbHelper = FavorDBHelper();
    FavorDBModel favorModel = FavorDBModel();

    var durum = isFavor;
    favorModel.movieId = widget.result.id;
    if (!durum) {
      var sonuc = await dbHelper.newFavor(favorModel);
      if (sonuc != null) {
        _mesaj["title"] = "List Added";
        _mesaj["subtitle"] = "Successfull Add Process";
        _mesaj["icon"] = Icon(Icons.movie);
        setState(() {
          favor = true;
        });
      } else {
        _mesaj["title"] = "Problem";
        _mesaj["subtitle"] = "Add process not processing";
        _mesaj["icon"] = Icon(Icons.error);
      }
    } else {
      var sonuc = await dbHelper.deleteFavor(widget.result.id);
      if (sonuc != null) {
        _mesaj["title"] = "List Deleted";
        _mesaj["subtitle"] = "Successfull Delete Process";
        _mesaj["icon"] = Icon(Icons.movie);
        setState(() {
          favor = false;
        });
      } else {
        _mesaj["title"] = "Problem";
        _mesaj["subtitle"] = "Delete process not processing";
        _mesaj["icon"] = Icon(Icons.sync_problem);
      }
    }
    return _mesaj;
  }

  Future _notificationProcess(bool favor) async {
    if (!favor) {
      DateTime releaseDate = DateTime(
        int.parse(widget.result.releaseDate.substring(0, 4)),
        int.parse(widget.result.releaseDate.substring(5, 7)),
        int.parse(widget.result.releaseDate.substring(8, 10)),
        13,
        30,
      );
      if (releaseDate.isAfter(DateTime.now())) {
        var scheduleNotifDateTime = releaseDate;
        var androidPltfmChnlSpec = AndroidNotificationDetails(
          "channelId",
          "channelName",
          "channelDescription",
          importance: Importance.Max,
          color: bgColor,
          enableLights: true,
          enableVibration: true,
        );
        var iosPltfmChnlSpec = IOSNotificationDetails();

        NotificationDetails notificationDetails = NotificationDetails(
          androidPltfmChnlSpec,
          iosPltfmChnlSpec,
        );
        await localNotifPlugin.schedule(
          widget.result.id,
          "Movie Reminder",
          "you will be notified before ${widget.result.title} is released.",
          scheduleNotifDateTime,
          notificationDetails,
          payload: "Default_Sound",
        );
      }
    } else {
      localNotifPlugin.cancel(widget.result.id);
    }
  }

  Future _onSelectNotif(String payload) async {
    // showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text("Notification Information"),
    //           content: Text(favor
    //               ? "You will get to information before\n ${widget.result.title} show"
    //               : "Notification canceled"),
    //         ));
  }
}
