import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './BookAPI.dart';

class BookDB{

  static Future<String> create(ISBN) async {
    Map<String, dynamic> book = await BookAPI.retrieveBookByISBN(ISBN);

    if(!book.containsKey("error")){
      _create(book);
      return "Success";
    }

    return "Error";
  }

  static void _create(Map<String,dynamic> book) async{
    Database bd = await DataBase.recuperarBancoDados();
    await bd.insert("book", book);
  }

  static Future<dynamic> get(String ISBN) async{
    try{
     return await _getBook(ISBN, true);
    }catch(err){
      if((await create(ISBN)).compareTo("Error") != 0){return await _getBook(ISBN, false);}
    }
    return {
      "ERRO": "Livro não encontrado",
    };
  }

  static  _getBook(String ISBN, bool throws) async{
    Database bd = await DataBase.recuperarBancoDados();
    var book = await bd.query("book", where: "ISBN = ?", whereArgs: [ ISBN]);
    if(!book.isEmpty)return book[0];

    if(throws)throw Exception("err");
    return Map<String,dynamic>();
  }

}