import 'package:flutter/material.dart';

class Page3App extends StatefulWidget {
  static const String id = "page3";
  @override
  _Page3AppState createState() => _Page3AppState();
}

class _Page3AppState extends State<Page3App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
    );
  }
}
