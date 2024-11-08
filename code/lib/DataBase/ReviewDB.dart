import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewDB{

  static void fazReview(String ISBN, int grade) async{
    if(grade > 0 && grade < 6 && ISBN.length == 13){
      final prefs = await SharedPreferences.getInstance();
      int id = await prefs.getInt('loggedUser')?? -1;
      if(id != -1){
        _create({
          "userid": id,
          "ISBN": ISBN,
          "grade": grade,
        });
      }
    }
  }

  static void getUserReviews() async {
    final prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('loggedUser')?? -1;
    if(id != -1){
      print( await _getUserReviews(id));
    }
  }

  static void atualizaReview(String ISBN, int grade) async{
    if(grade > 0 && grade < 6 && ISBN.length == 13){
      final prefs = await SharedPreferences.getInstance();
      int id = await prefs.getInt('loggedUser')?? -1;
      if(id != -1){
        _update({
          "userid": id,
          "ISBN": ISBN,
          "grade": grade,
        });
      }
    }
  }

  static void deletaReview(String ISBN) async{
    if(ISBN.length == 13){
      final prefs = await SharedPreferences.getInstance();
      int id = await prefs.getInt('loggedUser')?? -1;
      if(id != -1){
        _delete({
          "ISBN": ISBN,
          "userid": id,
        });
      }
    }
  }

  static void _create(Map<String,dynamic> review) async{
    Database bd = await DataBase.recuperarBancoDados();
    await bd.insert("review", review);
  }

  static  _getUserReviews(int userId) async{
    Database bd = await DataBase.recuperarBancoDados();
    var reviews = await bd.query("review", where: "userid = ?", whereArgs: [userId]);
    return reviews;
  }

  static void _update(Map<String,dynamic> review) async{
    Database bd = await DataBase.recuperarBancoDados();
    await bd.update(
        "review", review,
        where: "userid = ? AND ISBN = ?",  //caracter curinga
        whereArgs: [review["userid"], review["ISBN"]]
    );
  }

  static void _delete(Map<String,dynamic> review) async{
    Database bd = await DataBase.recuperarBancoDados();
    await bd.delete(
      "review",
      where: "userid = ? AND ISBN = ?",  //caracter curinga
      whereArgs: [review["userid"], review["ISBN"]]
    );
  }

}