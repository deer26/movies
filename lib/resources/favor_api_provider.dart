import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/favor_model.dart';

List<FavorModel> finalList = List<FavorModel>();

class FavorApiProvider {
  Client client = Client();
  final baseUrl = "https://api.themoviedb.org/3/movie/";

  Future<FavorModel> getFavorList(int movieId) async {
    FavorModel favorModel = FavorModel();
    Response response =
        await client.get("$baseUrl${movieId.toString()}?$apiKey");
    if (response.statusCode == 200) {
      favorModel = FavorModel.fromJson(json.decode(response.body));
      return favorModel;
    } else {
      throw Exception("not load data");
    }
  }
}
