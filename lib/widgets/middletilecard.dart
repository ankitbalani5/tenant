import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MiddleCardWidget extends StatelessWidget {
  late String name1;
  late String name2;
  late var name3;
  MiddleCardWidget(
      {required this.name1, required this.name2, required this.name3});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text(name1),
              Container(
                  child: SvgPicture.asset(
                    name2,
                    height: 30,
                    color: Color(0xffc56c86),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
              Text('$name3'),
            ],
          ),
        ),
      ),
    );
  }
}
