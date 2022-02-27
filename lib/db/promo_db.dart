import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PromoDb {
  static final PromoDb _instance = new PromoDb.internal();

  factory PromoDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'promo';
  final String column_id = 'promo_id';
  final String column_title = 'promo_title';
  final String column_desc = 'promo_desc';
  final String column_price = 'promo_price';
  final String column_label = 'promo_label';
  final String column_image = 'promo_image';
  final String column_package = 'promo_package';
  final String column_product = 'promo_product';

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
        '$column_id int primary key, '
        '$column_title varchar(50), '
        '$column_desc varchar(80), '
        '$column_price varchar(30), '
        '$column_label varchar(15), '
        '$column_image varchar(120), '
        '$column_package int, '
        '$column_product int)');
    return db;
  }

  Future<List> insert(int id, String title, String desc, String price, String label,
      String image, int package, int product) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($column_id, $column_title, $column_desc, $column_price, $column_label, '
        '$column_image, $column_package, $column_product) '
        'VALUES (' + id.toString() + ', "' + title + '", "' + desc + '", "' + price +
        '", "' + label + '", "' + image + '", ' + package.toString() + ', ' + product.toString() + ')');
    return result.toList();
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName ORDER BY $column_id');
    return result.toList();
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}