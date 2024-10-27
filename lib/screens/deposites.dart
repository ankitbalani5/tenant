import 'package:flutter/material.dart';

class DepositesPage extends StatefulWidget {
  static const String id = 'depositespage';

  @override
  _DepositesPageState createState() => _DepositesPageState();
}

class _DepositesPageState extends State<DepositesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposites'),
      ),
    );
  }
}
