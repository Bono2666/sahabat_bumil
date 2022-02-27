import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PackagesDb {
  static final PackagesDb _instance = new PackagesDb.internal();

  factory PackagesDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'packages';
  final String column_id = 'packages_id';
  final String column_name = 'packages_name';
  final String column_sub_title = 'packages_sub_title';
  final String column_image = 'packages_image';
  final String column_recomended = 'packages_recomended';

  static Database _db;

  PackagesDb.internal();

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
        '$column_id int primary key, '
        '$column_name varchar(30), '
        '$column_sub_title varchar(60), '
        '$column_image varchar(120), '
        '$column_recomended int)');
    return db;
  }

  Future<List> insert(int id, String name, String sub_title, String image, int recomended) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($column_id, $column_name, $column_sub_title, $column_image, $column_recomended) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + sub_title + '", "' + image + '", ' +
        recomended.toString() + ')');
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}