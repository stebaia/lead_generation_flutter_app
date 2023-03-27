import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lead_generation_flutter_app/model/scan_offline.dart';
import 'package:lead_generation_flutter_app/model/user_model/user.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'user.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          email TEXT,
          password TEXT,
          userType INTEGER,
          manifestationId INTEGER,
          manifestationName TEXT,
          courseName TEXT,
          courseId INTEGER
      )
      ''');
    await db.execute('''
      CREATE TABLE offlineScan(
          idManifestazione INTEGER,
          codice TEXT,
          idUtilizzatore TEXT,
          dataOra INTEGER,
          idCorso INTEGER,
          ckExit TEXT
      )
      ''');
  }

  Future<User> getUser() async {
    Database db = await instance.database;
    var users = await db.query('users', orderBy: 'email');
    List<User> usersList =
        users.isNotEmpty ? users.map((c) => User.fromMap(c)).toList() : [];
    return usersList.first;
  }

  Future<bool> isUserLogged() async {
    Database db = await instance.database;
    var users = await db.query('users', orderBy: 'email');
    if (users.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    Database db = await instance.database;
    return await db.update('users', user.toMap(),
        where: "email = ?", whereArgs: [user.email]);
  }

  Future<int> add(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<OfflineScan>> getOfflineScan() async {
    Database database = await instance.database;
    var getOfflineScan =
        await database.query('offlineScan', orderBy: 'idManifestazione');
    List<OfflineScan> listOfflineScan = getOfflineScan.isNotEmpty
        ? getOfflineScan.map((e) => OfflineScan.fromMap(e)).toList()
        : [];
    return listOfflineScan;
  }

  Future<int> addOfflineScan(OfflineScan offlineScan) async {
    Database database = await instance.database;
    return await database.insert('offlineScan', offlineScan.toMap());
  }

  Future<int> deleteOfflineScan(int id) async {
    Database database = await instance.database;
    return await database
        .delete('offlineScan', where: 'idManifestazione = ?', whereArgs: [id]);
  }
}
