import 'package:movie/models/movie_db_model.dart';
import 'package:sqflite/sqflite.dart';

class FavorDBHelper {
  static Future<Database> databaseFavorMovie() async {
    final dbFavorPath = await getDatabasesPath();
    const dbFavorSQL = "CREATE TABLE Favormovie ("
        "id INTEGER PRIMARY KEY,"
        "movie_id INTEGER"
        ")";

    return openDatabase(
      "${dbFavorPath}Favormovie.db",
      version: 1,
      onCreate: (db, index) => db.execute(dbFavorSQL),
    );
  }

  Future<int> newFavor(FavorDBModel favorModel) async {
    final db = await databaseFavorMovie();

    int sonuc = await db.insert("Favormovie", favorModel.toMap());

    return sonuc;
  }

  Future<List<FavorDBModel>> getAllFavor() async {
    final db = await  databaseFavorMovie();

    var sonuc = await db.query("Favormovie",orderBy: "id DESC");

    List<FavorDBModel> listFavor = sonuc.isNotEmpty
        ? sonuc.map((val) => FavorDBModel.fromMap(val)).toList()
        : [];

    return listFavor;
  }

  isFavorDB(int movieId) async {
    final db = await databaseFavorMovie();
    var sonuc = await db
        .query("Favormovie", where: "movie_id = ?", whereArgs: [movieId]);
    return sonuc;
  }

  Future<int> deleteFavor(int moveiId) async {
    final db = await databaseFavorMovie();
    var sonuc = await db.delete("Favormovie", where: "movie_id = ?", whereArgs: [moveiId]);
    return sonuc;
  }

  Future<int> deleteAll() async {
    final db = await databaseFavorMovie();
    var sonuc = await db.rawDelete("Delete * from Favormovie");
    return sonuc;
  }
}
