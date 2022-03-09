import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/branch_model.dart';

class BranchDb {
  static final BranchDb _instance = new BranchDb.internal();

  factory BranchDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'branch';
  final String column_id = 'branch_id';
  final String column_name = 'branch_name';
  final String column_desc = 'branch_desc';
  final String column_address_1 = 'branch_address_1';
  final String column_address_2 = 'branch_address_2';
  final String column_phone_1 = 'branch_phone_1';
  final String column_phone_2 = 'branch_phone_2';
  final String column_email_1 = 'branch_email_1';
  final String column_email_2 = 'branch_email_2';
  final String column_image = 'branch_image';
  final String column_latitude = 'branch_latitude';
  final String column_longitude = 'branch_longitude';
  final String column_direction = 'branch_direction';
  final String column_distance = 'branch_distance';

  static Database _db;

  BranchDb.internal();

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
        '$column_name varchar(50), '
        '$column_desc varchar(200), '
        '$column_address_1 varchar(120), '
        '$column_address_2 varchar(120), '
        '$column_phone_1 varchar(15), '
        '$column_phone_2 varchar(15), '
        '$column_email_1 varchar(30), '
        '$column_email_2 varchar(30), '
        '$column_image varchar(120), '
        '$column_latitude varchar(15), '
        '$column_longitude varchar(15), '
        '$column_direction varchar(500),'
        '$column_distance double)');
    return db;
  }

  Future<List> insert(int id, String name, String desc, String address_1, String address_2,
      String phone_1, String phone_2, String email_1, String email_2, String image,
      String latitude, String longitude) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($column_id, $column_name, $column_desc, $column_address_1, $column_address_2, '
        '$column_phone_1, $column_phone_2, $column_email_1, $column_email_2, $column_image, '
        '$column_latitude, $column_longitude) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + desc + '", "' + address_1 +
        '", "' + address_2 + '", "' + phone_1 + '", "' + phone_2 + '", "' + email_1 +
        '", "' + email_2 + '", "' + image + '", "' + latitude + '", "' + longitude + '")');
    return result.toList();
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName ORDER BY $column_distance');
    return result.toList();
  }

  Future<int> updateDistance(Branch branch) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, branch.updateDistance(), where: '$column_id = ?', whereArgs: [branch.branch_id],
    );
    return result;
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}