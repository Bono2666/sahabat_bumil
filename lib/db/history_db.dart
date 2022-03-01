import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDb {
  static final HistoryDb _instance = new HistoryDb.internal();

  factory HistoryDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'history';
  final String column_id = 'prods_id';
  final String column_date = 'prods_date';
  final String column_package = 'prods_package';
  final String column_name = 'prods_name';
  final String column_desc = 'prods_desc';
  final String column_price = 'prods_price';
  final String column_image = 'prods_image';

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
        '$column_id int, '
        '$column_date date, '
        '$column_package varchar(30), '
        '$column_name varchar(40), '
        '$column_desc varchar(200), '
        '$column_price int, '
        '$column_image varchar(120), PRIMARY KEY ($column_id, $column_date))');
    return db;
  }

  Future<List> insert(int id, String name, String desc, int price, String package,
      String image) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($column_id, $column_name, $column_desc, $column_price, $column_package, '
        '$column_image) '
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