import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/utils.dart';

class LowerSection extends StatelessWidget {
  late String title;
  final Color colour;
  late String image;
  LowerSection({
    required this.title,
    required this.colour,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              height: MediaQuery.of(context).size.height * 0.1,
             // color: primaryColor,
            ),
            SizedBox(height: 16,),
            Text(
              '$title',textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        )),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:Color(0xffD9E2FF)
          ),
          boxShadow: [
          /*  BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 2),
            ),*/
          ],
        ),
      ),
    );
  }
}
