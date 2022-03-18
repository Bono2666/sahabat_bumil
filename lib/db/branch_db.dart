// @dart=2.9
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/branch_model.dart';

class BranchDb {
  static final BranchDb _instance = new BranchDb.internal();

  factory BranchDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'branch';
  final String columnId = 'branch_id';
  final String columnName = 'branch_name';
  final String columnDesc = 'branch_desc';
  final String columnAddress1 = 'branch_address_1';
  final String columnAddress2 = 'branch_address_2';
  final String columnPhone1 = 'branch_phone_1';
  final String columnPhone2 = 'branch_phone_2';
  final String columnEmail1 = 'branch_email_1';
  final String columnEmail2 = 'branch_email_2';
  final String columnImage = 'branch_image';
  final String columnLatitude = 'branch_latitude';
  final String columnLongitude = 'branch_longitude';
  final String columnDirection = 'branch_direction';
  final String columnDistance = 'branch_distance';

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
        '$columnId int primary key, '
        '$columnName varchar(50), '
        '$columnDesc varchar(200), '
        '$columnAddress1 varchar(120), '
        '$columnAddress2 varchar(120), '
        '$columnPhone1 varchar(15), '
        '$columnPhone2 varchar(15), '
        '$columnEmail1 varchar(30), '
        '$columnEmail2 varchar(30), '
        '$columnImage varchar(120), '
        '$columnLatitude varchar(15), '
        '$columnLongitude varchar(15), '
        '$columnDirection varchar(500),'
        '$columnDistance double)');
    return db;
  }

  Future<List> insert(int id, String name, String desc, String address_1, String address_2,
      String phone_1, String phone_2, String email_1, String email_2, String image,
      String latitude, String longitude) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId, $columnName, $columnDesc, $columnAddress1, $columnAddress2, '
        '$columnPhone1, $columnPhone2, $columnEmail1, $columnEmail2, $columnImage, '
        '$columnLatitude, $columnLongitude) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + desc + '", "' + address_1 +
        '", "' + address_2 + '", "' + phone_1 + '", "' + phone_2 + '", "' + email_1 +
        '", "' + email_2 + '", "' + image + '", "' + latitude + '", "' + longitude + '")');
    return result.toList();
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName ORDER BY $columnDistance');
    return result.toList();
  }

  Future<int> updateDistance(Branch branch) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, branch.updateDistance(), where: '$columnId = ?', whereArgs: [branch.branchId],
    );
    return result;
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}