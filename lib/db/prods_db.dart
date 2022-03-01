import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/prods_model.dart';

class ProdsDb {
  static final ProdsDb _instance = new ProdsDb.internal();

  factory ProdsDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'products';
  final String column_id = 'prods_id';
  final String column_name = 'prods_name';
  final String column_desc = 'prods_desc';
  final String column_price = 'prods_price';
  final String column_promo = 'prods_promo';
  final String column_category = 'prods_category';
  final String column_image = 'prods_image';
  final String column_link = 'prods_link';
  final String column_total_order = 'prods_total_order';
  final String column_fav = 'prods_fav';

  static Database _db;

  ProdsDb.internal();

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
        '$column_name varchar(40), '
        '$column_desc varchar(200), '
        '$column_price int, '
        '$column_promo varchar(20), '
        '$column_category int, '
        '$column_image varchar(120), '
        '$column_link varchar(120), '
        '$column_total_order int, '
        '$column_fav int DEFAULT 0)');
    return db;
  }

  Future<List> insert(int id, String name, String desc, int price, String promo,
      int category, String image, int total_order, String link) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($column_id, $column_name, $column_desc, $column_price, $column_promo, '
        '$column_category, $column_image, $column_total_order, $column_link) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + desc + '", ' +
        price.toString() + ', "' + promo + '", ' + category.toString() +
        ', "' + image + '", ' + total_order.toString() + ', "' + link + '")');
    return result.toList();
  }

  Future<List> topProds() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, packages.packages_name AS prods_package '
        'FROM $tableName INNER JOIN packages ON $column_category = packages.packages_id '
        'ORDER BY $column_total_order DESC LIMIT 4');
    return result.toList();
  }

  Future<List> recomended() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, '
        'packages.packages_name AS prods_package FROM $tableName INNER JOIN packages '
        'ON $column_category = packages.packages_id WHERE packages_recomended = 1');
    return result.toList();
  }

  Future<List> packages(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, '
        'packages.packages_name AS prods_package, packages.packages_sub_title AS prods_sub_title '
        'FROM $tableName INNER JOIN packages '
        'ON $column_category = packages.packages_id WHERE $column_category = ' + id.toString());
    return result.toList();
  }

  Future<List> single(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, '
        'packages.packages_name AS prods_package FROM $tableName INNER JOIN packages '
        'ON $column_category = packages.packages_id WHERE $column_id = ' + id.toString());
    return result.toList();
  }

  Future<int> count(int id) async {
    var dbClient = await db;
    var result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName '
        'WHERE $column_id = ' + id.toString()));
    return result;
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    return result.toList();
  }

  Future<List> favList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, packages.packages_name AS prods_package '
        'FROM $tableName INNER JOIN packages ON $column_category = packages.packages_id '
        'WHERE $column_fav = 1');
    return result.toList();
  }

  Future<int> updateFav(Prods fav) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, fav.updateFav(), where: '$column_id = ?', whereArgs: [fav.prods_id],
    );
    return result;
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}