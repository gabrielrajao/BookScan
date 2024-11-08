import 'package:bookscan/BookDetails/Reviewinfos.dart';
import 'package:flutter/material.dart';
import '../style.dart';
import '../DataBase/BookAPI.dart';

class BookDetailsPage extends StatefulWidget {



  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  int _rating = 0;


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Reviewinfos;
    if(args.isbn.length != 13 || args.rating < -1 || args.rating > 5){
      Navigator.popAndPushNamed(context, "/");
    }
    if(args.rating > -1)_rating = args.rating;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para título do livro
            Text(
              "Titulo: "
            ),
            // Campo para autores
            Text(
              "Autores: "
            ),
            // Campo para categoria
            Text(
               "Categoria: "
            ),
            // Campo para língua
            Text(
              "Língua: "
            ),
            // Campo para descrição (campo longo)
            Text(
              "Descrição: \n"
            ),
            SizedBox(height: 20),
            // Input para avaliação
            Row(
              children: [
                Text("Avaliação:"),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: _rating.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _rating = int.tryParse(value) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "0 a 5",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Botões Avaliar, Atualizar, Deletar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (args.rating == -1)ElevatedButton(
                  onPressed: () {
                    _submitRating();
                  },
                  child: Text("Avaliar"),
                ),
                // Exibe o botão Atualizar se rating > -1
                if (args.rating > -1)
                  ElevatedButton(
                    onPressed: () {
                      _updateBookDetails();
                    },
                    child: Text("Atualizar"),
                  ),
                // Exibe o botão Deletar se rating > -1
                if (args.rating > -1)
                  ElevatedButton(
                    onPressed: () {
                      _deleteBook();
                    },
                    child: Text("Deletar"),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    foregroundColor: Colors.white),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    if (_rating < 0 || _rating > 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("A avaliação deve estar entre 0 e 5"),
      ));
      return;
    }
    // Lógica para salvar a avaliação
  }

  void _updateBookDetails() {
    if (
      _rating < 0 ||
        _rating > 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Preencha todos os campos corretamente"),
      ));
      return;
    }
    // Lógica para atualizar os detalhes do livro
  }

  void _deleteBook() {
    // Lógica para deletar o livro
  }
}
