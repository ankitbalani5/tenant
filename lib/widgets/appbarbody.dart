import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/providerfuction.dart';

import 'package:roomertenant/screens/newhome.dart';

import 'appbartitle.dart';

class Appbody extends StatefulWidget {
  const Appbody({Key? key}) : super(key: key);

  @override
  _AppbodyState createState() => _AppbodyState();
}

class _AppbodyState extends State<Appbody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<APIprovider>(
      builder: (context, apiprovider, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: Text('Father`s Name',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(
                          NewHomeApp.userValues['residents']
                                  [apiprovider.getDropDownValue()]['f_name']
                              .toString(),
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text('Registratioin Date',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(
                          NewHomeApp.userValues['residents']
                                  [apiprovider.getDropDownValue()]
                                  ['registration_date']
                              .toString(),
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text('Date of Birth',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(
                          NewHomeApp.userValues['residents']
                                  [apiprovider.getDropDownValue()]['dob']
                              .toString(),
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text('Bed name',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(
                          NewHomeApp.userValues['residents']
                                  [apiprovider.getDropDownValue()]['bed_name']
                              .toString(),
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text('Room Name',
                          style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(
                          NewHomeApp.userValues['residents']
                                  [apiprovider.getDropDownValue()]['room_name']
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child:
                          Text('Rent', style: TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(
                          NewHomeApp.userValues['residents']
                                  [apiprovider.getDropDownValue()]['rent']
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
