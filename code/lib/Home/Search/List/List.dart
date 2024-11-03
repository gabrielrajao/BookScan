import 'package:flutter/material.dart';
import '../../../style.dart';

List _carregarItens() {
  List _itens = [];
  for (int i = 0; i <= 10; i++) {
    Map<String, dynamic> item = Map();
    item["titulo"] = "Livro ${i}";
    item["descricao"] = "Clique aqui para saber mais";
    _itens.add(item);
  }
  return _itens;
}

void tapReact(context, _itens, indice) {
//print("Clique com onTap ${indice}");
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: double.infinity,
          title: Text(_itens[indice]["titulo"]),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: textColor,
          ),
          content: Text(_itens[indice]["descricao"]),
          actions: <Widget>[
            //definir widgets
            TextButton(
                onPressed: () {
                  print("Selecionado sim");
                  Navigator.pop(context);
                },
                child: Text("Sim")),
            TextButton(
                onPressed: () {
                  print("Selecionado não");
                  Navigator.pop(context);
                },
                child: Text("Não")),
          ],
        );
      });
}

Container getLista() {
  List _itens = _carregarItens();
  return Container(
    child: ListView.builder(
        itemCount: _itens.length,
        itemBuilder: (context, indice) {
          return Container(
              height: 90,
              margin: EdgeInsets.symmetric(horizontal: 8 , vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: backColor),
              child: ListTile(
                onTap: () {
                  tapReact(context, _itens, indice);
                },
                title: Text(_itens[indice]["titulo"], style: TextStyle(color: textColor),),
                subtitle: Text(_itens[indice]["descricao"], style: TextStyle(color:textColor),),
              ));
        }),
  );
}
