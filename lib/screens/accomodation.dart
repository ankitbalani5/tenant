import 'package:flutter/material.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/providerfuction.dart';

import '../utils/utils.dart';

class AccommodationPage extends StatefulWidget {
  static const String id = 'AccommodationPage';

  @override
  _AccommodationPageState createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Accommodation'),
        backgroundColor: primaryColor,
      ),
      //TODO: add condition of if data is not fetched
      body: Consumer<APIprovider>(
        builder: (context, apiprovider, child) => Container(
         // color: Color(0xfff3f2f7),
          child: Column(
            children: <Widget>[
            /*  Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // color: const Color(0xff355c7d),
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 50),
                          child: Text('#',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Expanded(
                          child: Text('Branch',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Expanded(
                            child: Text('Room',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                        Expanded(
                            child: Text('Bed',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                        Expanded(
                            child: Text('Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                      ],
                    ),
                  ),
                ),
              ),*/
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.845,
                child:
                ListView.builder(
                  itemCount: NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Room No. ${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['room'].toString()}",style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize:16
                              ),),
                             Row(
                               children: [
                                 Icon(Icons.bed),
                                 SizedBox(width: 4,),
                                 Text("${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['bed'].toString()}",style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16
                                 ),)
                               ],
                             )
                            /*  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Room No. ${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['room'].toString()}",style: TextStyle(
                                      fontWeight: FontWeight.bold,fontSize:16
                                  ),),
                                  Icon(Icons.bed),
                                  Text("${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['bed'].toString()}")
                                ],
                              ),*/
/*

                              Text((index + 1).toString()),
                              Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['branch'].toString()),
                              Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['room'].toString()),
                              Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['bed'].toString()),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      const Text('From : '),
                                      Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['from_date']
                                          .toString()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text('To : '),
                                      Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['to_date']
                                          .toString()),
                                    ],
                                  ),
                                ],
                              ),*/
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Branch",style: TextStyle(
                                  color: Color(0xffABAFB8)
                                ),),
                                  Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['branch'].toString(),style: TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),)],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Date",style: TextStyle(
                                  color: Color(0xffABAFB8)
                    )),
                                  Text('${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['from_date'].toString()} ${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['to_date']
                                      .toString()}',style: TextStyle(
                                      fontWeight: FontWeight.w500
                                  ),),],
                              )

                            ],
                          ),
                          SizedBox(
                            height:4 ,
                          ),
                          Divider(
                            thickness: 1,
                            color: Color(0xffD9E2FF),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
