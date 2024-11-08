import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBase{
  static recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "bookscan.db");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sqlUser = '''
            CREATE TABLE user (
              id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, 
              username VARCHAR UNIQUE, 
              password VARCHAR
            )
          ''';
          db.execute(sqlUser);
          String sqlReview = '''
            CREATE TABLE review (
              userid INTEGER,
              ISBN CHAR(13),
              grade INT,
              PRIMARY KEY (userid, ISBN),
              FOREIGN KEY (userid) REFERENCES user(id)
            )
          ''';
          db.execute(sqlReview);
        }
    );
    return bd;

  }
}