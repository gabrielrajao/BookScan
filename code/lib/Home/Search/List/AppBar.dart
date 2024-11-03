import 'package:flutter/material.dart';
import '../../../style.dart';

PreferredSize getAppBar(BuildContext context, TextEditingController _textEditingController) {
  return PreferredSize(preferredSize: Size(90, 70), child: AppBar(
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
            },
            style: circleBtnStyle,
            child: const Icon(Icons.search)
        ),
      ]
  ),
  );
}