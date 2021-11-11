import 'dart:async';
import 'package:path/path.dart';
import 'package:sahabat_bumil_v2/model/criteria_model.dart';
import 'package:sqflite/sqflite.dart';

class CriteriaDb {
  static final CriteriaDb _instance = new CriteriaDb.internal();

  factory CriteriaDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'criteria';
  final String column_id = 'crit_id';
  final String column_cat = 'crit_cat';
  final String column_filter = 'crit_filter';

  static Database _db;

  CriteriaDb.internal();

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
    await db.execute('create table IF NOT EXISTS $tableName ('
        '$column_id varchar(50) PRIMARY KEY, '
        '$column_cat varchar(50), '
        '$column_filter varchar(30))');
    return db;
  }

  Future<int> insert(CriteriaName criteria) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableName, criteria.set());
    return result;
  }

  Future<List> list(String id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE SUBSTR($column_id,1,2) = "' + id + '" ORDER BY $column_id'
    );
    return result.toList();
  }

  Future<List> listFilter(String id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName '
            'WHERE $column_filter <> "" AND SUBSTR($column_id,1,1) = "' + id + '" '
            'GROUP BY $column_cat ORDER BY $column_id'
    );
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}