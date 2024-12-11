import 'package:flutter/material.dart';
import '../../../style.dart';
import '../../../DataBase/BookAPI.dart';
import '../../../BookDetails/Reviewinfos.dart';

Future<List> _carregarItens(String name) async {
  var books = await BookAPI.retrieveBookByName(name);
  if((books[0] as Map<String,dynamic>).containsKey("error"))return [];
  List _itens = [];
  for (int i = 0; i <= 10 && i < books.length; i++) {
    Map<String, dynamic> item = Map();
    item["titulo"] = "${books[i]["title"]}";
    item["descricao"] = books[i]["description"]!= null?"${books[i]["description"]}":"Clique aqui para saber mais";
    item["ISBN"] = books[i]["ISBN"];
    _itens.add(item);
  }
  return _itens;
}

void tapReact(context, _itens, indice) {
  if(context.mounted) {
    Navigator.popAndPushNamed(context, "/bookdetails",
        arguments: Reviewinfos(
            _itens[indice]["ISBN"], -1));
  }
}

Future<Container> getLista(String search) async {
  if(search.compareTo("") == 0)return Container(  child: Center(child: Text("Pesquise um livro pelo nome")));
  List _itens = await _carregarItens(search);
  if(_itens.length == 0)return Container(  child: Center(child: Text("Nenhum livro encontrado")));
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
                title: Text(
                  _itens[indice]["titulo"],
                  style: TextStyle(color: textColor),
                  maxLines: 1, // Limita o texto a uma linha
                  overflow: TextOverflow.ellipsis, // Adiciona "..." no final se o texto for longo demais
                ),
                subtitle: Text(
                  _itens[indice]["descricao"],
                  style: TextStyle(color: textColor),
                  maxLines: 1, // Opcional: também pode truncar a descrição
                  overflow: TextOverflow.ellipsis,
                ),
              ));
        }),
  );
}
