import 'dart:async';

import 'package:movie/models/abstract_model.dart';
import 'package:movie/models/item_model.dart';
import 'package:movie/resources/repository.dart';

class MovieBloc {
  ItemModel _itemModel;

  final _movieStateController = StreamController<ItemModel>();

  StreamSink<AbstractModel> get _intoMovies => _movieStateController.sink;

  Stream<ItemModel> get movies => _movieStateController.stream;

  final _moviesEventController = StreamController<String>();

  Sink<String> get movieEventSink => _moviesEventController.sink;

  MovieBloc() {
    _moviesEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(String tur) async {
    Repository _repository = Repository();
    _itemModel = await _repository.fetchAllMovies(tur);

    _intoMovies.add(_itemModel);

  }

  void dispatch(String tur) {
    movieEventSink.add(tur);
  }

  void dispose() {
    _movieStateController.close();
    _moviesEventController.close();
  }
}
