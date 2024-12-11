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
      appBar: AppBar( automaticallyImplyLeading: false, backgroundColor: Colors.transparent, title: const Text("Avaliações"),actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/user");
            },
            style: circleBtnStyleSmall,
            child: const Icon(Icons.person)
        ),
      ]),
      body: FutureBuilder<Container>(
        future: getLista(true, context),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message
          } else if (snapshot.hasData) {
            return snapshot.data ?? Text("ERRO");
          } else {
            return Text('ERRO DESCONHECIDO'); // In case of no data
          }


        },
      ),
      bottomNavigationBar: navBar(context),
    );
  }
}
