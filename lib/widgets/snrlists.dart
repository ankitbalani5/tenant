// import 'package:flutter/material.dart';

// class SnRListApp extends StatelessWidget {
//   final List mainlist;
//   final List mainlistindex;
//   final List item;

//   SnRListApp(
//       {required this.mainlist,
//       required this.mainlistindex,
//       required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: mainlist.length > 0
//           ? ListView.builder(
//               itemCount: mainlist.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
//                   child: Card(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(right: 30),
//                               child: Text(item[index]),
//                             ),
//                             Expanded(
//                               child: Text(mainlistindex['complain_date']),
//                             ),
//                             Expanded(
//                               child: Text(mainlistindex['remark']),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           : const Text('No Complaints'),
//     );
//   }
// }
