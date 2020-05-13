import 'dart:convert';

class FavorDBModel {
  int id;
  int movieId;
  FavorDBModel({this.id, this.movieId});

  // gelen map'i jsona dönüştür
  factory FavorDBModel.fromMap(Map<String, dynamic> json) =>
      new FavorDBModel(id: json["id"], movieId: json["movie_id"]);

  //gelen json'ı map'e dönüştür
  Map<String, dynamic> toMap() => {"id": id, "movie_id": movieId};
}

FavorDBModel movieFavorFromJson(String str) {
  final jsonData = json.decode(str);
  return FavorDBModel.fromMap(jsonData);
}

String movieFavorToJson(FavorDBModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
