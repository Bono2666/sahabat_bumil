import 'dart:async';
import 'package:path/path.dart';
import 'package:sahabat_bumil_v2/model/checklist_model.dart';
import 'package:sqflite/sqflite.dart';

class ChecklistDb {
  static final ChecklistDb _instance = new ChecklistDb.internal();

  factory ChecklistDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'checklist';
  final String column_id = 'cl_id';
  final String column_week = 'cl_week';
  final String column_title = 'cl_title';
  final String column_image = 'cl_image';
  final String column_checked = 'cl_checked';

  static Database _db;

  ChecklistDb.internal();

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
        '$column_id varchar(3) primary key, '
        '$column_week integer, '
        '$column_title varchar(50), '
        '$column_image varchar(255), '
        '$column_checked integer)');
    return db;
  }

  Future<int> insert(Checklist checklist) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableName, checklist.set());
    return result;
  }

  Future<List> list(int week) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE $column_week = $week'
    );
    return result.toList();
  }

  Future<int> update(Checklist checklist) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, checklist.set(), where: '$column_id = ?', whereArgs: [checklist.cl_id],
    );
    return result;
  }
}