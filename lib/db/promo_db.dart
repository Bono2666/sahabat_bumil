// @dart=2.9
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PromoDb {
  static final PromoDb _instance = new PromoDb.internal();

  factory PromoDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'promo';
  final String columnId = 'promo_id';
  final String columnTitle = 'promo_title';
  final String columnDesc = 'promo_desc';
  final String columnPrice = 'promo_price';
  final String columnLabel = 'promo_label';
  final String columnImage = 'promo_image';
  final String columnPackage = 'promo_package';
  final String columnProduct = 'promo_product';

  static Database _db;

  PromoDb.internal();

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
        '$columnTitle varchar(50), '
        '$columnDesc varchar(80), '
        '$columnPrice varchar(30), '
        '$columnLabel varchar(15), '
        '$columnImage varchar(120), '
        '$columnPackage int, '
        '$columnProduct int)');
    return db;
  }

  Future<List> insert(int id, String title, String desc, String price, String label,
      String image, int package, int product) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId, $columnTitle, $columnDesc, $columnPrice, $columnLabel, '
        '$columnImage, $columnPackage, $columnProduct) '
        'VALUES (' + id.toString() + ', "' + title + '", "' + desc + '", "' + price +
        '", "' + label + '", "' + image + '", ' + package.toString() + ', ' + product.toString() + ')');
    return result.toList();
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName ORDER BY $columnId');
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}