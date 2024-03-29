import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// the database helper class
class Databasehelper {
  // database name
  static final _databasename = "todo.db";
  static final _databaseversion = 1;

  // the table name
  static final table = "my_table";

  // column names
  static final columnID = 'id';
  static final columnName = "todo";

  // a database
  static Database? _database;

  // private constructor
  Databasehelper._privateConstructor();
  static final Databasehelper instance = Databasehelper._privateConstructor();

  // asking for a database
  Future<Database> get database async {
    if (_database != null) return _database!;
    // create a database if one doesn't exist
    _database = await _initDatabase();
    return _database!;
  }

  // function to return a database
  _initDatabase() async {
    Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path, _databasename);
    return await openDatabase(path,
        version: _databaseversion, onCreate: _onCreate);
  }

  // create a database since it doesn't exist
  Future _onCreate(Database db, int version) async {
    // sql code
    await db.execute('''
      CREATE TABLE $table (
        $columnID INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL
      )
    ''');
  }

  // functions to insert data
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // function to query all the rows
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // function to delete some data
  Future<int> deleteData(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
