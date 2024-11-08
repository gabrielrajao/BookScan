import 'package:http/http.dart' as http;
import 'dart:convert';

class BookAPI{

  static Future<Map<String, dynamic>> retrieveBookByISBN(String ISBN) async {
      final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:'+ISBN);

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Parse the JSON data
          final data = json.decode(response.body);
          if(data['totalItems'] == 1){
            return await generateBookMap(data['items'][0]['volumeInfo']);
          }
        } else {
          print("Failed to load data: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }

    return{
      "error": "Book not found",
    };
  }

  static Future<List<Map<String, dynamic>>> retrieveBookByName(String Name) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=intitle:'+Name);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = json.decode(response.body);
        if(data['totalItems'] > 0){
          int size = data['totalItems'] > 10 ?10:data['totalItems'];
          List<Map<String, dynamic>> itemsList = <Map<String, dynamic>>[];
          for(int i = 0; i < size; i++){
            itemsList.add(generateBookMap(data['items'][i]['volumeInfo']));

          }
          return await itemsList;
        }
        else print("Data: $data");
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    return[{
      "error": "Book not found",
    }];
  }

  static Map<String, dynamic> generateBookMap(Map<String, dynamic> book) {
    Map<String, dynamic> bookMap = {
      "title": book["title"],
      "authors": book["authors"],
      "language":book["language"],
      "categories": book["categories"],
      "description":book["description"],
    };
    return bookMap;

  }



}