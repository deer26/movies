import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';

class SimilarApiProvider {
  Client client = Client();
  final baseUrl = "https://api.themoviedb.org/3/movie/";
  Future<ItemModel> fetchSimilarMovies(int movieId,String pageNo) async {
    Response response =
        await client.get("$baseUrl${movieId.toString()}/similar?${apiKey.toString()}&page=$pageNo");
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}
