import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._privateConstructor();
  static Database? _database;

  LocalDbService._privateConstructor();

  factory LocalDbService() {
    return _instance;
  }

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
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
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT,
        surname TEXT
      )
    ''');
  }
  

  Future<int> saveUserLocally({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    Database db = await _db;
    return await db.insert('users', {
      'email': email,
      'password': password, 
      'name': name,
      'surname': surname,
    });
  }
  

  Future<Map<String, dynamic>?> getUser(String email) async {
    Database db = await _db;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
