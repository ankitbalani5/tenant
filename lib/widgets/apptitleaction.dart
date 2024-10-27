import 'package:flutter/material.dart';

class AppTitleAction extends StatelessWidget {
  final IconData? actionicon;
  final String actionvalue;
  AppTitleAction({required this.actionicon, required this.actionvalue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            actionicon,
            size: 35,
          ),
          onPressed: () {},
        ),
        Positioned(
          right: 5,
          top: 5,
          child: Container(
            child: Center(
              child: Text(
                actionvalue,
                style: TextStyle(fontSize: 12),
              ),
            ),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
