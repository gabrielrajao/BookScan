import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDB{

  static void login(String username, String password) async{
    Map<String, dynamic> dadosUsuario = {
      "username": username,
      "password": password,
    };
    await _authenticateUser(dadosUsuario);
  }

  static void cadastro(String username, String password) async{
    String encrypted = _encrypt(password);
    Map<String, dynamic> dadosUsuario = {
      "username" : username,
      "password" : encrypted,
    };
    await _salvarDados(dadosUsuario);
  }

  static void deletaConta() async{
    final prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('loggedUser')?? -1;
    if(id != -1){
      await _excluirUsuario(id);
    }

  }

  static void atualizaConta(String username, String password) async {
    String encrypted = _encrypt(password);
    Map<String, dynamic> dadosUsuario = {
      "username" : username,
      "password" : encrypted,
    };
    final prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('loggedUser')?? -1;
    if(id != -1){
      await _atualizarUsuario(id, dadosUsuario);
    }

  }

  static void sair() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');
  }

  static Future<int> getLogged() async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getInt('loggedUser')?? -1;
}

  static String _encrypt(String text){
    var bytes = utf8.encode(text);
    return "${sha256.convert(bytes)}";
  }

  static _getUser(String username) async{
    Database bd = await DataBase.recuperarBancoDados();
    var user = await bd.query("user", where: "username = ?", whereArgs: [username]);
    return user;
  }

  static _authenticateUser(Map<String, dynamic> dadosUsuario) async{
    String username = dadosUsuario['username'];
    String password = dadosUsuario['password'];
    var user = await _getUser(username);
    String encrypted = _encrypt(password);
    if(user.length > 0) {
      String userPassword = user.first['password'];
      if (encrypted.compareTo(userPassword) == 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('loggedUser', user.first['id']);
      }
    }
  }
  
  static _salvarDados(Map<String, dynamic> dadosUsuario) async {
    Database bd = await DataBase.recuperarBancoDados();
    int id = await bd.insert("user", dadosUsuario);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loggedUser', id);
  }

  static _excluirUsuario(int id) async{
    Database bd = await DataBase.recuperarBancoDados();
    await bd.delete(
        "user",
        where: "id = ?",  //caracter curinga
        whereArgs: [id],
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');
  }

  static _atualizarUsuario(int id, Map<String, dynamic> dadosUsuario) async{
    Database bd = await DataBase.recuperarBancoDados();
    await bd.update(
        "user", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [id]
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');
  }
}