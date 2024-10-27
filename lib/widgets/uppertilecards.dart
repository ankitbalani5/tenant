import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UpperCardWidget extends StatelessWidget {
  late String name1;
  late String name2;
  int name3;
  late List<String> list;
  late String headname;
  UpperCardWidget({
    required this.name1,
    required this.name2,
    required this.name3,
    // required this.list,
    required this.headname,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        // onTap: () => showDialog<String>(
        //   context: context,
        //   builder: (BuildContext context) => AlertDialog(
        //     scrollable: true,
        //     title: Text('$headname'),
        //     content: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //           height: 400,
        //           width: 80,
        //           child: ListView.builder(
        //               shrinkWrap: true,
        //               itemCount: list.length,
        //               itemBuilder: (context, index) =>
        //                   Container(child: Text(list[index]))),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        child: Card(
          child: Container(
            // padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name1),
                Container(
                  child: SvgPicture.asset(
                    name2,
                    height: 40,
                    color: Color(0xffc56c86),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                ),
                Text('$name3'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
