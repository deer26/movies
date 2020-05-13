import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';

class MovieApiProvider {
  Client client = Client();
  final baseUrl = "https://api.themoviedb.org/3/movie/";

  Future<ItemModel> fetchMovieList(String tur) async {
    final Response response = await client
        .get("https://api.themoviedb.org/3/movie/$tur?$apiKey");
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load post");
    }
  }
}
const String photoBaseUrl = "https://image.tmdb.org/t/p/w200";
const String photoDetailUrl = "https://image.tmdb.org/t/p/w300";