import 'package:bookscan/BookDetails/Reviewinfos.dart';
import 'package:bookscan/DataBase/BookDB.dart';
import 'package:flutter/material.dart';
import '../style.dart';
import '../DataBase/ReviewDB.dart';

class BookDetailsPage extends StatefulWidget {



  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  int _rating = 0;
  bool ratingUpdate = false;


  @override
  void initState(){


    super.initState();

  }

  void getRating()async{
    int grade =(await ReviewDB.getBook((ModalRoute.of(context)!.settings.arguments as Reviewinfos).isbn))["review"];
    if(grade > 0)_rating = grade;
    ratingUpdate = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getRating();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Reviewinfos;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Livro"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/');
          },
        ),
      ),
      body: FutureBuilder<Map<String,dynamic>>(
        future: fetchData(args),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message
          } else if (snapshot.hasData) {
            return mainPadding(snapshot.data?["book"], snapshot.data?["review"]); // Show data
          } else {
            return Text('ERRO DESCONHECIDO'); // In case of no data
          }


        },
      )
    );
  }

  void _submitRating(String ISBN) async {
    if (_rating < 1 || _rating > 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("A avaliação deve estar entre 1 e 5"),
      ));
      return;
    }
    // Lógica para salvar a avaliação


      if (await ReviewDB.fazReview(ISBN, _rating) == -1  &&   ModalRoute.of(context)?.settings.name?.compareTo("/cadastro") != 0) {
        Navigator.popAndPushNamed(context, "/cadastro");
      }else {
        Navigator.popAndPushNamed(context, "/");
      }
  }

  void _updateBookDetails(String ISBN) {
    if (
    _rating < 1 ||
        _rating > 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Preencha todos os campos corretamente"),
      ));
      return;
    }
    // Lógica para atualizar os detalhes do livro
    ReviewDB.atualizaReview(ISBN, _rating);
    Navigator.popAndPushNamed(context, "/");
  }

  void _deleteBook(String ISBN) {
    // Lógica para deletar o livro
    ReviewDB.deletaReview(ISBN);
    Navigator.popAndPushNamed(context, "/");
  }

  Future<Map<String,dynamic>> fetchData(Reviewinfos args) async{
    return await ReviewDB.getBook(args.isbn);
  }



  Padding mainPadding(Map<String, dynamic>? book, int review){
    if(book == null)return Padding(padding: const EdgeInsets.all(16.0),
        child: Center(child: Text("ERRO: Livro não encontrado!")));
    if(book != null && book.containsKey("ERRO"))return Padding(padding: const EdgeInsets.all(16.0),
        child: Center(child: Text("ERRO: Livro não encontrado!")));
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Título: ${book?["title"] ?? ""}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Autores: ${book?["authors"] ?? ""}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            "Categoria: ${book?["categories"] ?? ""}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            "Língua: ${book?["language"] ?? ""}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Flexible(child: Text(
            "Descrição: ${book?["description"] ?? ""}",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),),
          SizedBox(height: 30),
          Row(
            children: [
              Text(
                "Avaliação:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: _rating > index ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (book != null && review == -1)
                ElevatedButton(
                  onPressed: () {
                    _submitRating(book["ISBN"]);
                  },
                  child: Text("Avaliar"),
                ),
              if (book != null && review > 0)
                ElevatedButton(
                  onPressed: () {
                    _updateBookDetails(book["ISBN"]);
                  },
                  child: Text("Atualizar"),
                ),
              if (book != null && review > 0)
                ElevatedButton(
                  onPressed: () {
                    _deleteBook(book["ISBN"]);
                  },
                  child: Text("Deletar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
