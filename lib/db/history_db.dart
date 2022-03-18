// @dart=2.9
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDb {
  static final HistoryDb _instance = new HistoryDb.internal();

  factory HistoryDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'history';
  final String columnId = 'prods_id';
  final String columnDate = 'prods_date';
  final String columnPackage = 'prods_package';
  final String columnName = 'prods_name';
  final String columnDesc = 'prods_desc';
  final String columnPrice = 'prods_price';
  final String columnImage = 'prods_image';

  static Database _db;

  HistoryDb.internal();

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
        '$columnId int, '
        '$columnDate date, '
        '$columnPackage varchar(30), '
        '$columnName varchar(40), '
        '$columnDesc varchar(200), '
        '$columnPrice int, '
        '$columnImage varchar(120), PRIMARY KEY ($columnId, $columnDate))');
    return db;
  }

  Future<List> insert(int id, String name, String desc, int price, String package,
      String image) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId, $columnName, $columnDesc, $columnPrice, $columnPackage, '
        '$columnImage) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + desc + '", ' +
        price.toString() + ', "' + package.toString() + '", "' + image + '")');
    return result.toList();
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    return result.toList();
  }
}