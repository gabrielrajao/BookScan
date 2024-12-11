import 'package:flutter/material.dart';
import '../../style.dart';
import '../../DataBase/ReviewDB.dart';
import '../../BookDetails/Reviewinfos.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String,dynamic>>> findBooks(var reviews) async {
  // Encontra a língua mais comum
  final languageCounts = <String, int>{};
  for (var review in reviews) {
    languageCounts[review["language"]] = (languageCounts[review["language"]] ?? 0) + 1;
  }
  final mostCommonLanguage = languageCounts.entries
      .reduce((a, b) => a.value > b.value ? a : b)
      .key;

  // Encontra a categoria com a maior média de avaliação
  final categoryRatings = <String, List<int>>{};
  for (var review in reviews) {
    if(review["categories"].length > 0) {
      List<String> categories = review["categories"].split(",");
      for (var category in categories) {
        categoryRatings.putIfAbsent(category, () => []).add(review["review"]);
      }
    }
  }
  final highestRatedCategory = categoryRatings.entries
      .map((entry) => MapEntry(
    entry.key,
    entry.value.reduce((a, b) => a + b) / entry.value.length,
  ))
      .reduce((a, b) => a.value > b.value ? a : b)
      .key;
  // Filtra livros na API do Google Books
  final evaluatedIsbns = reviews.map((review) => review["ISBN"]).toSet();
  final books = <Map<String, dynamic>>[];
  int startIndex = 0;

  while (books.length < 5) {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=subject:$highestRatedCategory&langRestrict=$mostCommonLanguage&startIndex=$startIndex&maxResults=40'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar livros: ${response.reasonPhrase}');
    }

    final data = json.decode(response.body);
    final items = data['items'] as List<dynamic>?;

    if (items == null || items.isEmpty) break;

    for (var item in items) {
      final volumeInfo = item['volumeInfo'] as Map<String, dynamic>;
      final industryIdentifiers = volumeInfo['industryIdentifiers'] as List<dynamic>?;

      if (industryIdentifiers != null) {
        final isbn = industryIdentifiers
            .firstWhere(
                (id) => id['type'] == 'ISBN_13',
            orElse: () => {'identifier': ''})['identifier']
            .toString();
        if (isbn!= "" && !evaluatedIsbns.contains(isbn)) {
          books.add(volumeInfo);
          evaluatedIsbns.add(isbn);
        }
      }

      if (books.length >= 6) break;
    }

    startIndex += 40;
  }

  return books;
}

String arrayToString(List<dynamic> strs){
  String result = "";
  bool first = true;
  strs.forEach((str){
  if(!first)result+=",";
  result += str;
  first = false;
  });
  return result;
}


Future<List> _carregarItens() async{
  var reviews = await ReviewDB.getUserReviews();
  var books = [];
  if(!reviews.isEmpty)books = await findBooks(reviews);
  List _itens = [];
  for (int i = 0; i < books.length; i++) {
    String ISBN = "";
    books[i]["industryIdentifiers"].forEach((element){
      if(element["type"].compareTo("ISBN_13") == 0)ISBN = element["identifier"];
    });
    print(ISBN);
    Map<String, dynamic> item = Map();
    item["titulo"] = books[i]["title"];
    item["categories"] = arrayToString(books[i]["categories"]?? <dynamic>[]);
    item["authors"] = arrayToString(books[i]["authors"]?? <dynamic>[]);
    item["ISBN"] = ISBN;
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
              size: 40,
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

Widget CardMaker( List<dynamic> _itens, int index) {
  return Card(
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              _itens[index]["titulo"],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Categorias: " + _itens[index]["categories"],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            "Autores: " + _itens[index]["authors"],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
  if(_itens.length == 0)return Container(child: Center(child: Text("Faça avaliações para receber recomendações!"),),);
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
        child: CardMaker( _itens, index),
      ),
      onTap: (){
        tapReact(context, _itens, index);
      },);
    }),
  ));
}
