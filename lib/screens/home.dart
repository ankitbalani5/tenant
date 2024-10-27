// import 'package:provider/provider.dart';
// import 'package:roomertenant/api/apitget.dart';
// import 'package:roomertenant/screens/amenities.dart';
// import 'package:roomertenant/screens/bill.dart';
// import 'package:roomertenant/screens/deposites.dart';
// import 'package:roomertenant/screens/login.dart';
// import 'package:flutter/material.dart';
// import 'package:roomertenant/widgets/appbartitle.dart';
// import 'package:roomertenant/widgets/appbarbody.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:roomertenant/api/providerfuction.dart';
// import 'tenant_complain.dart';
// import 'package:roomertenant/screens/newhome.dart';

// class HomeApp extends StatefulWidget {
//   static const String id = "home";
//   static dynamic userValues;
//   static dynamic userId;
//   static dynamic userBills;
//   static dynamic userComplains;
//   static dynamic complainHead;
//   static String? finalusernumber;
//   static getValidationData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? obtainEmail = prefs.getString('email');

//     finalusernumber = obtainEmail!;
//     return finalusernumber;
//   }

//   @override
//   _HomeAppState createState() => _HomeAppState();
// }

// class _HomeAppState extends State<HomeApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<APIprovider>(
//       builder: (context, apiprovider, child) => Scaffold(
//         backgroundColor: Colors.blue[100],
//         appBar: AppBar(
//           backgroundColor: Colors.blue[900],
//           title: Apptitle(),
//         ),
//         body: Consumer<APIprovider>(
//           builder: (context, apiprovider, child) => CustomScrollView(
//             slivers: [
//               // SliverAppBar(
//               //   title: Apptitle(),
//               //   floating: true,
//               //   pinned: true,
//               //   flexibleSpace: Appbody(),
//               //   expandedHeight: 150,
//               //   actions: [
//               //     GestureDetector(
//               //       onTap: () {
//               //         print('add profile page');
//               //       },
//               //       child: CircleAvatar(
//               //         foregroundImage: NetworkImage(
//               //           'https://cdn-icons-png.flaticon.com/512/2922/2922510.png',
//               //         ),
//               //         radius: 20,
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               SliverGrid.count(
//                 crossAxisCount: 2,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Container(
//                       height: 20,
//                       width: 20,
//                       child: Center(
//                           child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Next Due Date',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             HomeApp.userValues['residents']
//                                     [apiprovider.getDropDownValue()]['due_date']
//                                 .toString(),
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       )),
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(50),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment(0.8,
//                               0.0), // 10% of the width, so there are ten blinds.
//                           colors: <Color>[
//                             Color(0xff531061),
//                             Color(0xffA43991),
//                           ], // red to yellow
//                           // repeats the gradient over the canvas
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.7),
//                             spreadRadius: 5,
//                             blurRadius: 5,
//                             offset: Offset(3, 4),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {},
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         child: Center(
//                             child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Due Rent',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               HomeApp.userValues['residents']
//                                       [apiprovider.getDropDownValue()]
//                                       ['due_amount']
//                                   .toString(),
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         )),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(50),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment(0.8,
//                                 0.0), // 10% of the width, so there are ten blinds.
//                             colors: <Color>[
//                               Color(0xff531061),
//                               Color(0xffA43991),
//                             ], // red to yellow
//                             // repeats the gradient over the canvas
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.7),
//                               spreadRadius: 5,
//                               blurRadius: 5,
//                               offset: Offset(3, 4),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       showDialog<String>(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) => AlertDialog(
//                           title: const Text('Loading...'),
//                           content: Container(
//                             child: LinearProgressIndicator(),
//                           ),
//                         ),
//                       );
//                       await apiprovider.sendUserID(
//                           HomeApp.userValues['residents']
//                               [apiprovider.getDropDownValue()]['tenant_id']);
//                       HomeApp.userBills =
//                           await API.bill(apiprovider.getUserID());
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, BillPage.id);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         child: Center(
//                             child: Text(
//                           'Bill',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(50),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment(0.8,
//                                 0.0), // 10% of the width, so there are ten blinds.
//                             colors: <Color>[
//                               Color(0xff004AF8),
//                               Color(0xff00B9FC),
//                             ], // red to yellow
//                             // repeats the gradient over the canvas
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.7),
//                               spreadRadius: 5,
//                               blurRadius: 5,
//                               offset: Offset(3, 4),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       showDialog<String>(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) => AlertDialog(
//                           title: const Text('Loading...'),
//                           content: Container(
//                             child: LinearProgressIndicator(),
//                           ),
//                         ),
//                       );
//                       await apiprovider.sendUserID(
//                           HomeApp.userValues['residents']
//                               [apiprovider.getDropDownValue()]['tenant_id']);
//                       HomeApp.userComplains =
//                           await API.complains(apiprovider.getUserID());
//                       Page2App.complaints_options.clear();
//                       for (var item in HomeApp.userComplains['complainHead']) {
//                         Page2App.complaints_options.add(item['head_name']);
//                       }
//                       apiprovider
//                           .sendComplainHeader(Page2App.complaints_options[0]);
//                       HomeApp.complainHead =
//                           HomeApp.userComplains['complainHead'];
//                       // print(HomeApp.userComplains);
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, Page2App.id);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         child: Center(
//                             child: Text(
//                           'Complaints',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(50),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment(0.8,
//                                 0.0), // 10% of the width, so there are ten blinds.
//                             colors: <Color>[
//                               Color(0xff004AF8),
//                               Color(0xff00B9FC),
//                             ], // red to yellow
//                             // repeats the gradient over the canvas
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.7),
//                               spreadRadius: 5,
//                               blurRadius: 5,
//                               offset: Offset(3, 4),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, DepositesPage.id);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         child: Center(
//                             child: Text(
//                           'Deposites',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(50),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment(0.8,
//                                 0.0), // 10% of the width, so there are ten blinds.
//                             colors: <Color>[
//                               Color(0xff004AF8),
//                               Color(0xff00B9FC),
//                             ], // red to yellow
//                             // repeats the gradient over the canvas
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.7),
//                               spreadRadius: 5,
//                               blurRadius: 5,
//                               offset: Offset(3, 4),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, AmenitiesPage.id);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 20,
//                         width: 20,
//                         child: Center(
//                             child: Text(
//                           'Amenities',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(50),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment(0.8,
//                                 0.0), // 10% of the width, so there are ten blinds.
//                             colors: <Color>[
//                               Color(0xff004AF8),
//                               Color(0xff00B9FC),
//                             ], // red to yellow
//                             // repeats the gradient over the canvas
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.7),
//                               spreadRadius: 5,
//                               blurRadius: 5,
//                               offset: Offset(3, 4),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               SafeArea(
//                 child: ListTile(
//                   title: const Text('Log out'),
//                   onTap: () async {
//                     final SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                     prefs.setBool('isLoggedIn', false);
//                     prefs.remove("email");

//                     Navigator.pushNamed(context, Login.id);
//                   },
//                   leading: Icon(Icons.logout_sharp),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.new_releases_outlined),
//                 title: Text('New Home page temp'),
//                 onTap: () {
//                   Navigator.pushNamed(context, NewHomeApp.id);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
