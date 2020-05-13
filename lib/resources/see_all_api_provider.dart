import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';

class SeeAllApiProvider {
  final baseUrl = "https://api.themoviedb.org/3/movie/";
  Client client = Client();
  Future<ItemModel> fetchSeeAll(String movieType, String pageNo) async {
    Response response =
        await client.get("$baseUrl${movieType.toString()}?${apiKey.toString()}&page=$pageNo");
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Problem load to movies");
    }
  }
}
