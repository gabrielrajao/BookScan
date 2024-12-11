import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './BookDB.dart';

class ReviewDB{

  static Future<int> fazReview(String ISBN, int grade) async{
    if(grade > 0 && grade < 6 && ISBN.length == 13){
      final prefs = await SharedPreferences.getInstance();
      int id = await prefs.getInt('loggedUser')?? -1;
      if(id != -1){
        _create({
          "userid": id,
          "ISBN": ISBN,
          "grade": grade,
        });
      } else {
        return -1;
      }
    }
    return 10;
  }

  static Future<dynamic> getBook(String ISBN) async {
    Map<String, dynamic> book = await BookDB.get(ISBN) as Map<String, dynamic>;
    Map<String, dynamic> result = {
      "book": book,
      "review": -1,
    };



    final prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('loggedUser')?? -1;
    if(id != -1){
      try {
        result["review"] = ((await _getReview(id, ISBN)));


      }catch(err){
      }


    }
    return result;

  }

  static Future<List<Map<String,dynamic>>> getUserReviews() async {
    final prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('loggedUser')?? -1;
    List<Map<String,dynamic>> result = [];
    if(id != -1){
      List<dynamic> lista = await _getUserReviews(id);
      for(int i = 0; i < lista.length; i++){
        var review = lista[i];
        Map<String,dynamic> livro = await _nameAndReviewPair(review);
        result.add(livro);
      }
    }
    return result;
  }

  static Future<Map<String,dynamic>> _nameAndReviewPair(dynamic review) async{
    return{
      "ISBN": review["ISBN"],
      "title": (await getBook(review["ISBN"]))["book"]["title"],
      "categories": (await getBook(review["ISBN"]))["book"]["categories"],
      "language": (await getBook(review["ISBN"]))["book"]["language"],
      "review": review["grade"],
    };
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

  static  _getReview(int userId, String ISBN) async{
    Database bd = await DataBase.recuperarBancoDados();
    var reviews = await bd.query("review", where: "userid = ? AND ISBN = ?", whereArgs: [userId, ISBN]);
    return reviews[0]["grade"];
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