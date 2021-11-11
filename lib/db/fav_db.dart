import 'dart:async';
import 'package:path/path.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
import 'package:sahabat_bumil_v2/model/favtmp_model.dart';
import 'package:sqflite/sqflite.dart';

class FavDb {
  static final FavDb _instance = new FavDb.internal();

  factory FavDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'fav';
  final String column_id = 'fav_id';
  final String column_name = 'fav_name';
  final String column_desc = 'fav_desc';
  final String column_sex = 'fav_sex';
  final String column_cat = 'fav_cat';
  final String column_filter = 'fav_filter';
  final String column_check = 'fav_check';

  static Database _db;

  FavDb.internal();

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
        '$column_name varchar(20), '
        '$column_desc varchar(200), '
        '$column_sex varchar(20), '
        '$column_cat varchar(20), '
        '$column_filter varchar(20), '
        '$column_check int)');
    return db;
  }

  Future<int> insert(Fav fav) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableName, fav.set());
    return result;
  }

  Future<List> list(String sex, String cap) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_sex = "' + sex + '" AND '
            'SUBSTR($column_name, 1, 1) = "' + cap + '" AND $column_desc != ""'
    );
    return result.toList();
  }

  Future<List> listwcat(String sex, String cat, String cap) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_sex = "' + sex + '" AND $column_cat = "' + cat + '" AND '
            'SUBSTR($column_name, 1, 1) = "' + cap + '" AND $column_desc != ""'
    );
    return result.toList();
  }

  Future<List> listwcat1cap(String sex, String cat) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_sex = "' + sex + '" AND $column_cat = "' + cat + '"'
    );
    return result.toList();
  }

  Future<List> listfav() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_check = 1'
    );
    return result.toList();
  }

  Future<List> listCapsAll(String sex) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT *, SUBSTR($column_name,1,1) AS caps FROM $tableName '
            'WHERE $column_sex = "' + sex + '" AND $column_desc != "" '
            'GROUP BY caps ORDER BY caps'
    );
    return result.toList();
  }

  Future<List> listCapsWCat(String sex, String cat) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT *, SUBSTR($column_name,1,1) AS caps FROM $tableName '
            'WHERE $column_sex = "' + sex + '" AND $column_cat = "' + cat + '" '
            'GROUP BY caps ORDER BY caps'
    );
    return result.toList();
  }

  Future<int> update(Fav check) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, check.update(), where: '$column_id = ?', whereArgs: [check.fav_id],
    );
    return result;
  }

  Future<int> updatefrtmp(FavTmp check) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, check.set(), where: '$column_id = ?', whereArgs: [check.fav_id],
    );
    return result;
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}