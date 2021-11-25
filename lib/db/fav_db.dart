import 'dart:async';
import 'package:path/path.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
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
  final String column_no_cat = 'fav_no_cat';
  final String column_cat = 'fav_cat';
  final String column_filter = 'fav_filter';
  final String column_prefix = 'fav_prefix';
  final String column_middle = 'fav_middle';
  final String column_sufix = 'fav_sufix';
  final String column_check = 'fav_check';
  final String column_status = 'fav_status';

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
        '$column_no_cat int, '
        '$column_cat varchar(20), '
        '$column_filter varchar(20), '
        '$column_prefix int DEFAULT 1, '
        '$column_middle int DEFAULT 1, '
        '$column_sufix int DEFAULT 1, '
        '$column_check int DEFAULT 0, '
        '$column_status varchar(20))');
    return db;
  }

  Future<List> insert(String id, String name, String desc, String sex, int no_cat,
      String cat, String filter, int prefix, int middle, int sufix, String status) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($column_id, $column_name, $column_desc, $column_sex, $column_no_cat, $column_cat, '
        '$column_filter, $column_prefix, $column_middle, $column_sufix, $column_check, $column_status) '
        'VALUES ("' + id + '", "' + name + '", "' + desc + '", "' + sex + '", ' +
        no_cat.toString() + ', "' + cat + '", "' + filter + '", ' + prefix.toString() +
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
        'SELECT * FROM $tableName WHERE $column_sex = "' + sex + '" AND '
            'SUBSTR($column_name, 1, 1) = "' + cap + '" AND $column_desc != "" '
            'AND $column_status != "delete" ORDER BY $column_name'
    );
    return result.toList();
  }

  Future<List> listwcat(String sex, String cat, String cap) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_sex = "' + sex + '" AND $column_cat = "' + cat + '" AND '
            'SUBSTR($column_name, 1, 1) = "' + cap + '" AND $column_desc != "" '
            'AND $column_status != "delete" ORDER BY $column_name'
    );
    return result.toList();
  }

  Future<List> listwcat1cap(String sex, String cat) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_sex = "' + sex + '" '
            'AND $column_cat = "' + cat + '" AND $column_status != "delete"'
    );
    return result.toList();
  }

  Future<List> listfav() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_check = 1 '
            'AND $column_status != "delete" ORDER BY $column_name'
    );
    return result.toList();
  }

  Future<List> listCapsAll(String sex) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT *, SUBSTR($column_name,1,1) AS caps FROM $tableName '
            'WHERE $column_sex = "' + sex + '" AND $column_desc != "" AND $column_status != "delete" '
            'GROUP BY caps ORDER BY caps'
    );
    return result.toList();
  }

  Future<List> listCapsWCat(String sex, String cat) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT *, SUBSTR($column_name,1,1) AS caps FROM $tableName '
            'WHERE $column_sex = "' + sex + '" AND $column_cat = "' + cat + '" '
            'AND $column_status != "delete" GROUP BY caps ORDER BY caps'
    );
    return result.toList();
  }

  Future<List> listCat(String sex) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName '
            'WHERE $column_filter <> "" AND $column_sex = "' + sex + '" AND '
            '$column_status != "delete" GROUP BY $column_cat ORDER BY $column_no_cat'
    );
    return result.toList();
  }

  Future<List> listCatDrop(String sex, String col) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName '
            'WHERE $column_sex = "' + sex + '" AND ' + col + ' = 1 AND '
            '$column_status != "delete" GROUP BY $column_cat ORDER BY $column_no_cat'
    );
    return result.toList();
  }

  Future<int> update(Fav name) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, name.update(), where: '$column_id = ?', whereArgs: [name.fav_id],
    );
    return result;
  }

  Future<int> updateFav(Fav check) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, check.updateFav(), where: '$column_id = ?', whereArgs: [check.fav_id],
    );
    return result;
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}