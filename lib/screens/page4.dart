import 'package:flutter/material.dart';

class Page4App extends StatefulWidget {
  static const String id = "page4";

  @override
  _Page4AppState createState() => _Page4AppState();
}

class _Page4AppState extends State<Page4App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 4'),
      ),
    );
  }
}
