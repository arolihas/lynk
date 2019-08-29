import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lynk_mobile/models/user_model.dart';
import 'package:lynk_mobile/models/link_model.dart';

class DBProvider {
  DBProvider._();

  static final db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    return _database != null ? _database : await initDB();
  }

  initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'app.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user(
            userID INTEGER PRIMARY KEY,
            name TEXT,
            url TEXT DEFAULT '',
            pic BLOB,
            FOREIGN KEY(userID) REFERENCES links(linkID)
          );
          CREATE TABLE links(
            linkID Integer PRIMARY KEY,
            linkURL TEXT,
            description TEXT
          )
        ''');
      });
  }

  accessDB() async {
    return await database;
  }

  newUser(User user) async {
    final db = accessDB();
    return await db.insert('user', user.toJson());
  }

  getUser(String url) async{
    final db = accessDB();
    var user = await db.query('user', where: 'url = ?', whereArgs: [url]);
    return user.isNotEmpty ? User.fromJson(user.first) : null;
  }

  updateUser(User user) async {
    final db = accessDB();
    return await db.update('user', user.toJson(), 
      where: 'url = ?', whereArgs: [user.url]);
  }

  deleteUser(String url) async {
    final db = accessDB();
    db.delete('user', where: 'url = ?', whereArgs: [url]);
  }

  newLink(Link link) async {
    final db = accessDB();
    return await db.insert('links', link.toJson());
  }

  getLink(String source) async {
    final db = accessDB();
    var link = await db.query('links', where: 'linkURL = ?', whereArgs: [source]);
    return link.isNotEmpty ? Link.fromJson(link.first) : null;
  }

  updateLink(Link link) async {
    final db = accessDB();
    return await db.update('links', link.toJson(), 
      where: 'linkURL = ?', whereArgs: [link.source]);
  }

  deleteLink(String source) async {
    final db = accessDB();
    db.delete('links', where: 'linkURL = ?', whereArgs: [source]);
  }

}



