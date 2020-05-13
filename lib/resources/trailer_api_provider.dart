import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:movie/models/constants/constant.dart';
import 'package:movie/models/trailer_model.dart';

class TrailerApiProvider {
  Client client = Client();
  final baseUrl = "https://api.themoviedb.org/3/movie/";

  Future<Trailers> fetchTrailerList(String id) async {
    final Response response = await client.get("$baseUrl$id/videos?$apiKey");
    if (response.statusCode == 200) {
      return Trailers.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load post");
    }
  }
}
