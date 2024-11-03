import 'package:flutter/material.dart';
import '../../style.dart';

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

Flexible CardBody(avaliacoes) {
  if (avaliacoes) {
    return Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: textColor,
          size: 14,
        ),
        Icon(
          Icons.star,
          color: textColor,
          size: 14,
        ),
        Icon(
          Icons.star,
          color: textColor,
          size: 14,
        ),
        Icon(
          Icons.star,
          color: textColor,
          size: 14,
        ),
        Icon(
          Icons.star_outline,
          color: textColor,
          size: 14,
        ),
      ],
    ));
  }
  return Flexible(
      child: Text(
    "Gênero:\tTerror \nAutor:\tArthur Silva\nPreço:\tRS23,99",
    style: TextStyle(fontSize: 10, color: textColor),
  ));
}

Column CardMaker(avaliacoes, _itens, index) {
  return Column(children: [
    Image.network('https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=', height: 55, width: 100, scale: 1,),
    Text(_itens[index]["titulo"],
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
    CardBody(avaliacoes)
  ]);
}

Container getLista(bool avaliacoes) {
  List _itens = _carregarItens();
  return Container(
      child: GridView.count(
    crossAxisCount: 3,
    children: List.generate(_itens.length, (index) {
      return Container(
        height: 90,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backColor,
        ),
        padding: EdgeInsets.all(10),
        child: CardMaker(avaliacoes, _itens, index),
      );
    }),
  ));
}
