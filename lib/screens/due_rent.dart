
import 'package:flutter/material.dart';

class DueRent extends StatefulWidget {
  static const String id = "rentpage";

  @override
  _DueRentState createState() => _DueRentState();
}

class _DueRentState extends State<DueRent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Due Rent"),
      ),
      body: Center(
        child: Text("Due Rent"),
      ),
    );
  }
}
