import 'package:flutter/material.dart';
import '../navBar/navBar.dart';
import '../style.dart';
import './List/List.dart';



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
      appBar: AppBar( automaticallyImplyLeading: false, backgroundColor: Colors.transparent, title: const Text("Recomendações"),actions: [
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
