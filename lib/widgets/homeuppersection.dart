import 'package:flutter/material.dart';

import '../utils/utils.dart';

class UpperSection extends StatelessWidget {
  late String datenum;
  late String date;

  UpperSection({required this.datenum, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.red,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.05,
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '$datenum',
                style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('$date',style: TextStyle(color:Colors.white ),)
                ],
              )
            ],
          ),
        ),

      ],
    );
  }
}
