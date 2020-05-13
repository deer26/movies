import 'dart:convert';

import "package:http/http.dart" show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/item_model.dart';

class SearchApiProvider {
  Client client = Client();
  final baseUrl =
  
      "https://api.themoviedb.org/3/search/movie?$apiKey&query=";
  final lastfix = "&include_adult=true";

  Future<List<Results>> fetchSearchList(String movieName) async {
      final Response response = await client.get("$baseUrl$movieName$lastfix");
      if (response.statusCode == 200) {
        ItemModel itemModel = ItemModel.fromJson(json.decode(response.body));
        return itemModel.results;
      } else {
        throw Exception("Failed to load search list");
      }
  }
}
