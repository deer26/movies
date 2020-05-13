import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/constants/colors.dart';
import 'package:movie/ui/pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mycustom_screen.dart';

class ApiIntroScreen extends StatefulWidget {
  @override
  _ApiIntroScreenState createState() => _ApiIntroScreenState();
}

class _ApiIntroScreenState extends State<ApiIntroScreen> {
  String baseImage = "assets/imageintro/";
  List<String> title = ["Movie Contexts", "Offline Mode", "Notifications"];
  List<String> desc = [
    "You available millons of movie context.\nRead,watch and add favorouite list.",
    "If you add context to favourite list.You can\n available them.",
    "You can learn that your favor movie,\nfilm ext,before it will show"
  ];
  List<String> imagesPath = ["movie.png", "database.png", "notification.png"];
  bool show = true;
  double indicator = 0;

  @override
  void initState() {
    super.initState();
    _setFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: show,
              child: InkWell(
                onTap: _getHomeScreen,
                child: Text(
                  "SKIP",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 300,
                    viewportFraction: 1,
                    initialPage: 0,
                    aspectRatio: 1,
                    reverse: false,
                    onPageChanged: (i, reason) {
                      indicator = i.toDouble();
                      setState(() => show = i == 2 ? false : true);
                    },
                    enableInfiniteScroll: false),
                items: [0, 1, 2].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: bgColor,
                                ),
                                child: Image.asset(
                                  "$baseImage${imagesPath[i]}",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "${title[i]}",
                              style: TextStyle(
                                  color: iconColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${desc[i]}",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            i == 2
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: bgColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: _getHomeScreen,
                                        child: Text(
                                          "GET STARTED",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: DotsIndicator(
                dotsCount: 3,
                position: indicator,
                decorator: DotsDecorator(
                  size: Size.square(10),
                  activeSize: Size.square(20),
                  color: Colors.black38,
                  activeColor: bgColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getHomeScreen() => Navigator.push(
      context, new MyCustomRoute(builder: (context) => new HomeScreen()));

  void _setFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("firstRun", true);
  }
}
