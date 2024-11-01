import 'package:flutter/material.dart';
import './Home/HomePage.dart';
import './Avaliacoes/Avaliacoes.dart';
import './Recomendacoes/Recomendacoes.dart';
import './Home/Search/Search.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

MaterialApp routes(){
  return MaterialApp(
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      routes: {
        "/search": (context) => Search(),
        "/avaliacoes": (context) => Avaliacoes(),
        "/recomendacoes": (context) => Recomendacoes(),
      },
      home: HomePage(),
  );
}