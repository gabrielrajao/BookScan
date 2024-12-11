import 'package:flutter/material.dart';
import '../../style.dart';

import './List/AppBar.dart';
import './List/List.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  TextEditingController _textEditingController = TextEditingController();

  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: PreferredSize(preferredSize: Size(90, 70), child: AppBar(
          shadowColor: Colors.black,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(
              colors: [Color(0xffffffff), backColor],
              stops: [0, 0.7],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),),
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/");
            },
          ),
          title: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                filled: true,
                fillColor: searchBoxColor,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "Pesquise o nome de um livro"
            ),
            style: TextStyle(
              fontSize: 15,
            ),
            controller: _textEditingController, //controlador do nosso campo de texto
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _search = _textEditingController.text;
                  });
                },
                style: circleBtnStyle,
                child: const Icon(Icons.search)
            ),
          ]
      ),
      ),
      body:FutureBuilder<Container>(
        future: getLista(_search),
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
      )
    );
  }
}
