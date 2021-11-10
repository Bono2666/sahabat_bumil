import 'dart:async';
import 'dart:core';
import 'package:path/path.dart';
import 'package:sahabat_bumil_v2/model/favtmp_model.dart';
import 'package:sqflite/sqflite.dart';

class FavTmpDb {
  static final FavTmpDb _instance = new FavTmpDb.internal();

  factory FavTmpDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'isfav';
  final String column_id = 'fav_id';
  final String column_check = 'fav_check';

  static Database _db;

  FavTmpDb.internal();

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
        '$column_id varchar(20) primary key, '
        '$column_check int)');
    return db;
  }

  Future<int> insert(FavTmp fav) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableName, fav.set());
    return result;
  }

  Future<List> listfav() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName'
    );
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}