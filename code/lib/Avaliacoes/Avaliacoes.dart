import 'package:flutter/material.dart';
import '../navBar/navBar.dart';
import '../style.dart';
import './List/List.dart';

class Avaliacoes extends StatefulWidget {
  const Avaliacoes({super.key});

  @override
  _Avaliacoes createState() => _Avaliacoes();
}



class _Avaliacoes extends State<Avaliacoes> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar( automaticallyImplyLeading: false, backgroundColor: Colors.transparent, title: const Text("Avaliações"),),
      body: getLista(true),
      bottomNavigationBar: navBar(context),
    );
  }
}
