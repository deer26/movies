import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/genre_model.dart';

class GenreApiProvider {
  Client client = Client();
  final baseUrl = "http://api.themoviedb.org/3/genre/movie/list?";

  Future<GenreModel> fetchGenreList()async {
    final Response response = await client
        .get("$baseUrl$apiKey");
    if (response.statusCode == 200) {
      return GenreModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load post");
    }
  }
}
const String photoBaseUrl = "https://image.tmdb.org/t/p/w200";