import 'package:bookscan/BookDetails/BookDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import './Home/HomePage.dart';
import './Avaliacoes/Avaliacoes.dart';
import './Recomendacoes/Recomendacoes.dart';
import './Home/Search/Search.dart';
import './UserPages/login.dart';
import './UserPages/cadastro.dart';
import './UserPages/usuario.dart';
import 'BookDetails/Reviewinfos.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

MaterialApp routes(){
  return MaterialApp(
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      routes: {
        "/search": (context) => Search(),
        "/avaliacoes": (context) => Avaliacoes(),
        "/recomendacoes": (context) => Recomendacoes(),
        "/login": (context) => LoginScreen(),
        "/cadastro": (context) => CadastroScreen(),
        "/user": (context) => UserPage(),
        "/bookdetails": (context)=>BookDetailsPage(),
      },
      home: HomePage(),
  );
}