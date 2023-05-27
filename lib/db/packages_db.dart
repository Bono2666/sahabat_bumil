import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PackagesDb {
  static final PackagesDb _instance = new PackagesDb.internal();

  factory PackagesDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'packages';
  final String columnId = 'packages_id';
  final String columnName = 'packages_name';
  final String columnSubTitle = 'packages_sub_title';
  final String columnImage = 'packages_image';
  final String columnRecomended = 'packages_recomended';

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
        '$columnId int primary key, '
        '$columnName varchar(30), '
        '$columnSubTitle varchar(60), '
        '$columnImage varchar(120), '
        '$columnRecomended int)');
    return db;
  }

  Future<List> insert(int id, String name, String subTitle, String image, int recomended) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId, $columnName, $columnSubTitle, $columnImage, $columnRecomended) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + subTitle + '", "' + image + '", ' +
        recomended.toString() + ')');
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}