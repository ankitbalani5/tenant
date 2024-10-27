import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/providerfuction.dart';

class UserCardApp extends StatelessWidget {
  late String constString;
  late String varString;
  UserCardApp({
    required this.constString,
    required this.varString,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<APIprovider>(
      builder: (context, apiprovider, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                '$constString',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: Text(
              varString.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
