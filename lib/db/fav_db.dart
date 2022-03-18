// @dart=2.9
import 'dart:async';
import 'package:path/path.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
import 'package:sqflite/sqflite.dart';

class FavDb {
  static final FavDb _instance = new FavDb.internal();

  factory FavDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'fav';
  final String columnId = 'fav_id';
  final String columnName = 'fav_name';
  final String columnDesc = 'fav_desc';
  final String columnSex = 'fav_sex';
  final String columnNoCat = 'fav_no_cat';
  final String columnCat = 'fav_cat';
  final String columnFilter = 'fav_filter';
  final String columnPrefix = 'fav_prefix';
  final String columnMiddle = 'fav_middle';
  final String columnSuffix = 'fav_sufix';
  final String columnCheck = 'fav_check';
  final String columnStatus = 'fav_status';

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
        '$columnId varchar(20) primary key, '
        '$columnName varchar(20), '
        '$columnDesc varchar(200), '
        '$columnSex varchar(20), '
        '$columnNoCat int, '
        '$columnCat varchar(20), '
        '$columnFilter varchar(20), '
        '$columnPrefix int DEFAULT 1, '
        '$columnMiddle int DEFAULT 1, '
        '$columnSuffix int DEFAULT 1, '
        '$columnCheck int DEFAULT 0, '
        '$columnStatus varchar(20))');
    return db;
  }

  Future<List> insert(String id, String name, String desc, String sex, int noCat,
      String cat, String filter, int prefix, int middle, int sufix, String status) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId, $columnName, $columnDesc, $columnSex, $columnNoCat, $columnCat, '
        '$columnFilter, $columnPrefix, $columnMiddle, $columnSuffix, $columnCheck, $columnStatus) '
        'VALUES ("' + id + '", "' + name + '", "' + desc + '", "' + sex + '", ' +
        noCat.toString() + ', "' + cat + '", "' + filter + '", ' + prefix.toString() +
        ', ' + middle.toString() + ', ' + sufix.toString() + ', 0, "' + status + '")');
    return result.toList();
  }

  Future<List> listAll() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    return result.toList();
  }

  Future<List> list(String sex, String cap) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $columnSex = "' + sex + '" AND '
            'SUBSTR($columnName, 1, 1) = "' + cap + '" AND $columnDesc != "" '
            'AND $columnStatus != "delete" ORDER BY $columnName'
    );
    return result.toList();
  }

  Future<List> listwcat(String sex, String cat, String cap) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $columnSex = "' + sex + '" AND $columnCat = "' + cat + '" AND '
            'SUBSTR($columnName, 1, 1) = "' + cap + '" AND $columnDesc != "" '
            'AND $columnStatus != "delete" ORDER BY $columnName'
    );
    return result.toList();
  }

  Future<List> listwcat1cap(String sex, String cat) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $columnSex = "' + sex + '" '
            'AND $columnCat = "' + cat + '" AND $columnStatus != "delete"'
    );
    return result.toList();
  }

  Future<List> listfav() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $columnCheck = 1 '
            'AND $columnStatus != "delete" ORDER BY $columnName'
    );
    return result.toList();
  }

  Future<List> listCapsAll(String sex) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT *, SUBSTR($columnName,1,1) AS caps FROM $tableName '
            'WHERE $columnSex = "' + sex + '" AND $columnDesc != "" AND $columnStatus != "delete" '
            'GROUP BY caps ORDER BY caps'
    );
    return result.toList();
  }

  Future<List> listCapsWCat(String sex, String cat) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT *, SUBSTR($columnName,1,1) AS caps FROM $tableName '
            'WHERE $columnSex = "' + sex + '" AND $columnCat = "' + cat + '" '
            'AND $columnStatus != "delete" GROUP BY caps ORDER BY caps'
    );
    return result.toList();
  }

  Future<List> listCat(String sex) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName '
            'WHERE $columnFilter <> "" AND $columnSex = "' + sex + '" AND '
            '$columnStatus != "delete" GROUP BY $columnCat ORDER BY $columnNoCat'
    );
    return result.toList();
  }

  Future<List> listCatDrop(String sex, String col) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName '
            'WHERE $columnSex = "' + sex + '" AND ' + col + ' = 1 AND '
            '$columnStatus != "delete" GROUP BY $columnCat ORDER BY $columnNoCat'
    );
    return result.toList();
  }

  Future<int> update(Fav name) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, name.update(), where: '$columnId = ?', whereArgs: [name.favId],
    );
    return result;
  }

  Future<int> updateFav(Fav check) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, check.updateFav(), where: '$columnId = ?', whereArgs: [check.favId],
    );
    return result;
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}