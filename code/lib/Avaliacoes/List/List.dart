import 'package:flutter/material.dart';
import '../../style.dart';
import '../../DataBase/ReviewDB.dart';
import '../../BookDetails/Reviewinfos.dart';
import 'package:flutter/gestures.dart';

Future<List> _carregarItens() async{
  var books = await ReviewDB.getUserReviews();
  List _itens = [];
  for (int i = 0; i < books.length; i++) {
    Map<String, dynamic> item = Map();
    item["titulo"] = books[i]["title"];
    item["descricao"] = books[i]["description"]!= null?"${books[i]["description"]}":"Clique aqui para saber mais";
    item["ISBN"] = books[i]["ISBN"];
    item["review"] = books[i]["review"];
    _itens.add(item);
  }
  return _itens;
}

Flexible CardBody(avaliacoes) {
  if (avaliacoes > 0) {
    return Flexible(
        child: Center(child:Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          List.generate(5, (index) {
            return  Icon(
              avaliacoes > index?Icons.star:Icons.star_outline,
              color: textColor,
              size: 18,
            );
          }),
    )));
  }
  return Flexible(
      child: Text(
    "Gênero:\tTerror \nAutor:\tArthur Silva\nPreço:\tRS23,99",
    style: TextStyle(fontSize: 10, color: textColor),
  ));
}

Widget CardMaker(avaliacoes, _itens, index) {
  return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
      padding: const EdgeInsets.all(16.0),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Center(child:Text(_itens[index]["titulo"],
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    )),
    CardBody(_itens[index]["review"])
  ],
  ),
      ),
  );
}

void tapReact(context, _itens, indice) {
  if(context.mounted) {
    Navigator.popAndPushNamed(context, "/bookdetails",
        arguments: Reviewinfos(
            _itens[indice]["ISBN"], -1));
  }
}

Future<Container> getLista(bool avaliacoes, context) async {
  List _itens = await _carregarItens();
  if(_itens.length == 0)return Container(child: Center(child: Text("Nenhuma avaliação ainda!"),),);
  return Container(
      child: GridView.count(
    crossAxisCount: 2,
    children: List.generate(_itens.length, (index) {
      return GestureDetector(child: Container(
        width: 200,
        height: 20,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backColor,
        ),
        padding: EdgeInsets.all(10),
        child: CardMaker(avaliacoes, _itens, index),
      ),
      onTap: (){
        tapReact(context, _itens, index);
      },);
    }),
  ));
}
