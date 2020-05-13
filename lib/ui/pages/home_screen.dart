import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:movie/database/movie_db_helper.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/resources/movie_api_provider.dart';
import 'package:movie/resources/search_api_provider.dart';
import 'package:movie/ui/pages/detail_movie_screen.dart';
import 'package:movie/ui/pages/favor_movie_screen.dart';
import 'package:movie/ui/pages/see_all_movie_screen.dart';
import 'package:movie/ui/widgets/popular_movie.dart';
import 'package:movie/ui/widgets/recent_movie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.clear();
    _typeAheadController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light, statusBarColor: bgColor));
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: new Text(
                            "Search",
                            style: TextStyle(
                              fontFamily: "SubstanceMedium",
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 35,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FavorMovieScreen()));
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Form(
                    key: this._formKey,
                    child: Container(
                      padding: EdgeInsets.only(left: 8),
                      margin: EdgeInsets.only(right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: TypeAheadField(
                        hideOnEmpty: true,
                        hideOnError: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          autofocus: false,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter movies...",
                            hintStyle:
                                TextStyle(color: textColor, fontSize: 22),
                          ),
                        ),
                        suggestionsCallback: (movieName) async {
                          if (movieName.isNotEmpty &&
                              movieName != null &&
                              movieName != "" &&
                              movieName != " ") {
                            return SearchApiProvider()
                                .fetchSearchList(movieName);
                          }
                          return null;
                        },
                        itemBuilder: (context, Results results) {
                          return ListTile(
                              leading: results.getPosterPath != null
                                  ? Image.network(
                                      "$photoBaseUrl${results.getPosterPath}",
                                      height: 100,
                                    )
                                  : Image.asset(
                                      "assets/icon/noimage.jpg",
                                      height: 100,
                                    ),
                              title: Text(results.title),
                              subtitle: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: iconColor,
                                  ),
                                  Text(results.voteAverage),
                                  Text(
                                    "/10",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ));
                        },
                        onSuggestionSelected: (Results result) async {
                          this._typeAheadController.text = result.title;
                          List<String> _currentGenres = List();
                          if (genreModelGlobal != null) {
                            for (var item in result.genreIds) {
                              for (var str in genreModelGlobal.genres) {
                                if (item == str.id) {
                                  _currentGenres.add(str.name);
                                }
                              }
                            }
                          }
                          FavorDBHelper dbHelper = FavorDBHelper();
                          var sonuc = await dbHelper.isFavorDB(result.id);
                          bool isFavor = false;
                          if (sonuc.isNotEmpty) {
                            isFavor = true;
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailMovieScreen(
                                result, _currentGenres, isFavor);
                          }));
                          _typeAheadController.clear();
                        },
                        transitionBuilder:
                            (context, suggestionBox, controller) {
                          return suggestionBox;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              expandedHeight: 90,
              backgroundColor: bgColor,
              floating: true,
              snap: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Divider(
                color: textColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Recent",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllMovie(movieType: "now_playing"),
                      ),
                    ),
                    child: Text(
                      "SEE ALL",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              RecentMovie(),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Popular",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllMovie(movieType: "popular"),
                      ),
                    ),
                    child: Text(
                      "SEE ALL",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              PoupularMovie(),
            ])),

            // Place sliver widgets here
          ],
        ),
      ),
    );
  }
}
