import 'package:flutter/material.dart';
import 'package:roomertenant/screens/newhome.dart';

import '../utils/utils.dart';

class AmenitiesPage extends StatefulWidget {
  const AmenitiesPage({Key? key}) : super(key: key);
  static const String id = 'amenpage';

  @override
  _AmenitiesPageState createState() => _AmenitiesPageState();
}

class _AmenitiesPageState extends State<AmenitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Amenities'),
      ),
      //TODO: add condition of if data is not fetched
      body:
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
        child:
        SingleChildScrollView(
          child: Wrap(
            children: List.generate(NewHomeApp.userValues['amenities'].length, (index) =>  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Chip(
                  padding: EdgeInsets.all(8),
                  backgroundColor: Color(0xffD9E2FF),
                  shadowColor: Colors.black,
                  label: Text(
                    '${index+1}. ${NewHomeApp.userValues['amenities'][index]['amenity_name']}',
                    style: TextStyle(fontSize: 14,color:Color(0xff001944) ),
                  )),
            )),
          ),
        )
      /*  [
        *//*  Container(
            height: MediaQuery.of(context).size.height * 0.05,
            color: Color(0xfff3f2f7),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 40),
                  child: const Text(
                    '#',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'Amenities',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),*//*
          Container(
            margin: EdgeInsets.only(top: 40),
            height: MediaQuery.of(context).size.height,
            color: Color(0xfff3f2f7),
            child: ListView.builder(
              itemCount: NewHomeApp.userValues['amenities'].length,
              itemBuilder: (context, index) {
                return
                  Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Column(
                    children: [
                      Chip(
                       // elevation: 10,
                        padding: EdgeInsets.all(8),
                        backgroundColor: Color(0xffD9E2FF),
                        shadowColor: Colors.black,
                       *//* avatar: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"), //NetworkImage
                        ),*//* //CircleAvatar
                        label: Text(
                          NewHomeApp.userValues['amenities'][index]['amenity_name'],
                          style: TextStyle(fontSize: 14,color:Color(0xff001944) ),
                        ), //Text
                      )
                  *//*    Container(
                        margin: EdgeInsets.only(left: 15, right: 40),
                        child: Text((index + 1).toString()),
                      ),
                      Text(NewHomeApp.userValues['amenities'][index]['amenity_name']),
                    *//*
                    ],
                  ),
                );
              },
            ),
          ),
        ],*/
      ),
    );
  }
}
