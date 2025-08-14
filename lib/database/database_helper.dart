import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'photo_editor_app.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL UNIQUE,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // 이미지 경로 추가
  Future<int> insertImage(String imagePath) async {
    Database db = await database;
    try {
      return await db.insert(
        'images',
        {'path': imagePath, 'createdAt': DateTime.now().toIso8601String()},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    catch (e) {
      print("Error inserting image: $e");
      return -1;
    }
  }

  // 모든 이미지 경로 가져오기 (최신순)
  Future<List<String>> getAllImagePaths() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('images', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return maps[i]['path'] as String;
    });
  }

  // 이미지 경로 삭제
  Future<int> deleteImage(String imagePath) async {
    Database db = await database;
    return await db.delete(
      'images',
      where: 'path = ?',
      whereArgs: [imagePath],
    );
  }

  // 테이블 전체 삭제
  Future<void> clearAllImages() async {
    Database db = await database;
    await db.delete('images');
  }
}