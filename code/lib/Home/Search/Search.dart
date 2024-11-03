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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: getAppBar(context, _textEditingController),
      body: getLista(),
    );
  }
}
