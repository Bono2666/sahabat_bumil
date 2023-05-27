import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/prods_model.dart';

class ProdsDb {
  static final ProdsDb _instance = new ProdsDb.internal();

  factory ProdsDb() => _instance;

  final String dbName = 'sahabat_bumil.db';
  final String tableName = 'products';
  final String columnId = 'prods_id';
  final String columnName = 'prods_name';
  final String columnDesc = 'prods_desc';
  final String columnPrice = 'prods_price';
  final String columnPromo = 'prods_promo';
  final String columnCategory = 'prods_category';
  final String columnImage = 'prods_image';
  final String columnLink = 'prods_link';
  final String columnTotalOrder = 'prods_total_order';
  final String columnFav = 'prods_fav';

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
        '$columnId int primary key, '
        '$columnName varchar(40), '
        '$columnDesc varchar(200), '
        '$columnPrice int, '
        '$columnPromo varchar(20), '
        '$columnCategory int, '
        '$columnImage varchar(120), '
        '$columnLink varchar(120), '
        '$columnTotalOrder int, '
        '$columnFav int DEFAULT 0)');
    return db;
  }

  Future<List> insert(int id, String name, String desc, int price, String promo,
      int category, String image, int totalOrder, String link) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('INSERT INTO $tableName '
        '($columnId, $columnName, $columnDesc, $columnPrice, $columnPromo, '
        '$columnCategory, $columnImage, $columnTotalOrder, $columnLink) '
        'VALUES (' + id.toString() + ', "' + name + '", "' + desc + '", ' +
        price.toString() + ', "' + promo + '", ' + category.toString() +
        ', "' + image + '", ' + totalOrder.toString() + ', "' + link + '")');
    return result.toList();
  }

  Future<List> topProds() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, packages.packages_name AS prods_package '
        'FROM $tableName INNER JOIN packages ON $columnCategory = packages.packages_id '
        'ORDER BY $columnTotalOrder DESC LIMIT 4');
    return result.toList();
  }

  Future<List> recomended() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, '
        'packages.packages_name AS prods_package FROM $tableName INNER JOIN packages '
        'ON $columnCategory = packages.packages_id WHERE packages_recomended = 1');
    return result.toList();
  }

  Future<List> packages(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, '
        'packages.packages_name AS prods_package, packages.packages_sub_title AS prods_sub_title '
        'FROM $tableName INNER JOIN packages '
        'ON $columnCategory = packages.packages_id WHERE $columnCategory = ' + id.toString());
    return result.toList();
  }

  Future<List> single(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.*, '
        'packages.packages_name AS prods_package FROM $tableName INNER JOIN packages '
        'ON $columnCategory = packages.packages_id WHERE $columnId = ' + id.toString());
    return result.toList();
  }

  Future<int> count(int id) async {
    var dbClient = await db;
    var result = Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName '
        'WHERE $columnId = ' + id.toString()));
    return result;
  }

  Future<List> list() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');
    return result.toList();
  }

  Future<List> favList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT products.* FROM $tableName WHERE $columnFav = 1');
    return result.toList();
  }

  Future<int> updateFav(Prods fav) async {
    var dbClient = await db;
    var result = await dbClient.update(
      tableName, fav.updateFav(), where: '$columnId = ?', whereArgs: [fav.prodsId],
    );
    return result;
  }

  Future<int> delete() async {
    var dbClient = await db;
    var result = await dbClient.delete(tableName);
    return result;
  }
}