// @dart=2.9
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavProdsDb {
  static final FavProdsDb _instance = new FavProdsDb.internal();

  factory FavProdsDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'fav_prods';
  final String columnId = 'prods_id';

  static Database _db;

  FavProdsDb.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);
    var db = await openDatabase(path, version: 1);
    await db.execute('create table IF NOT EXISTS $tableName('
        '$columnId int primary key)');
    return db;
  }

  Future<List> insert(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId) VALUES (' + id.toString() + ')');
    return result.toList();
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}