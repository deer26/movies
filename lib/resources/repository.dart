import 'package:movie/models/abstract_model.dart';
import 'package:movie/models/genre_model.dart';
import 'package:movie/resources/movie_api_provider.dart';

import 'genre_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();
  final genreApiProvider = GenreApiProvider();

  Future<AbstractModel> fetchAllMovies(String tur) =>
      movieApiProvider.fetchMovieList(tur);

  Future<GenreModel> fetchAllGenres() => genreApiProvider.fetchGenreList();
}
