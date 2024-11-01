import 'package:flutter/material.dart';
import '../navBar/navBar.dart';
import '../style.dart';
import '../Avaliacoes/List/List.dart';

class Recomendacoes extends StatefulWidget {
  const Recomendacoes({super.key});

  @override
  _Recomendacoes createState() => _Recomendacoes();
}



class _Recomendacoes extends State<Recomendacoes> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar( automaticallyImplyLeading: false, backgroundColor: Colors.transparent, title: const Text("Recomendações"),),
      body: getLista(false),
      bottomNavigationBar: navBar(context),
    );
  }
}
