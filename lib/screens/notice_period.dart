// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
//
// import '../constant/constant.dart';
//
// class NoticePeriod extends StatefulWidget {
//   String startDate;
//   NoticePeriod(this.startDate);
//
//   @override
//   State<NoticePeriod> createState() => _NoticePeriodState();
// }
//
// class _NoticePeriodState extends State<NoticePeriod> {
//   TextEditingController fromdate = TextEditingController();
//   TextEditingController todate = TextEditingController();
//   DateTime? pickedDate1;
//   DateTime? fromDateValue;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     print('start date: --${widget.startDate}');
//     setState(() {
//
//     });
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 120,
//               color: Constant.bgLight,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
//                 child: Row(
//                   children: [
//                     InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Icon(
//                           Icons.arrow_back_ios,
//                           size: 18,
//                           color: Colors.white,
//                         )),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     const Text(
//                       'Notice Period',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           fontSize: 20),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Container
//           Positioned(
//               top: 85,
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 40,),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               SizedBox(
//                                 height: 50,
//                                 width: 150,
//                                 child: TextFormField(
//                                   controller: fromdate,
//                                   readOnly: true,
//                                   onTap: () async {
//                                     final now = DateTime.now();
//                                     DateTime? pickedDate = await showDatePicker(
//                                       context: context,
//                                       initialDate: now,
//                                       firstDate: DateTime(2021),
//                                       lastDate: DateTime(2100),
//                                     );
//
//                                     if (pickedDate != null) {
//                                       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//
//                                       setState(() {
//                                         fromDateValue = pickedDate;
//                                         fromdate.text = formattedDate;
//                                         // Automatically set the To Date to 15 days after the From Date
//                                         final toDateValue = pickedDate.add(Duration(days: 15));
//                                         todate.text = DateFormat('dd-MM-yyyy').format(toDateValue);
//                                       });
//                                     } else {
//                                       print("Date is not selected");
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     label: Text('From Date'),
//                                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     suffixIcon: Icon(Icons.calendar_month),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               SizedBox(
//                                 height: 50,
//                                 width: 150,
//                                 child: TextFormField(
//                                   controller: todate,
//                                   readOnly: true,
//                                   onTap: () async {
//                                     if (fromDateValue == null) {
//                                       // If no from date is selected, show a message or handle accordingly
//                                       print("Please select a From Date first");
//                                       return;
//                                     }
//
//                                     DateTime? pickedDate = await showDatePicker(
//                                       context: context,
//                                       initialDate: fromDateValue!.add(Duration(days: 15)),
//                                       firstDate: fromDateValue!.add(Duration(days: 15)),
//                                       lastDate: DateTime(2100),
//                                     );
//
//                                     if (pickedDate != null) {
//                                       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//                                       setState(() {
//                                         todate.text = formattedDate;
//                                       });
//                                     } else {
//                                       print("Date is not selected");
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     label: Text('To Date'),
//                                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     suffixIcon: Icon(Icons.calendar_month),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 50,
//                                 width: 150,
//                                 child: TextFormField(
//                                   controller: fromdate,
//                                   readOnly: true,
//                                   onTap: () async {
//                                     final now = DateTime.now();
//                                     final firstDate = DateTime(now.year - 1, now.month, now.day);
//                                     pickedDate1 = await showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime(2021), //DateTime.now() - not to allow to choose before today.
//                                         lastDate: DateTime(2100)/*now*/
//                                     );
//
//                                     if(pickedDate1 != null ){
//                                       print(pickedDate1);  //pickedDate output format => 2021-03-10 00:00:00.000
//                                       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate1!);
//                                       print(formattedDate); //formatted date output using intl package =>  2021-03-16
//                                       //you can implement different kind of Date Format here according to your requirement
//
//                                       setState(() {
//                                         fromdate.text = formattedDate; //set output date to TextField value.
//
//                                         // Automatically set the To Date to 15 days after the From Date
//                                         final toDateValue = pickedDate1?.add(Duration(days: 15));
//                                         todate.text = DateFormat('dd-MM-yyyy').format(toDateValue!);
//                                       });
//                                     }else{
//                                       print("Date is not selected");
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                       border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(20)
//                                       ),
//                                     suffixIcon: Icon(Icons.calendar_month)
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 50,
//                                 width: 150,
//                                 child: TextFormField(
//                                   controller: todate,
//                                   readOnly: true,
//                                   onTap: () async {
//
//                                     final now = DateTime.now();
//                                     // final firstDate = DateTime(now.year - 1, now.month, now.day);
//                                     DateTime firstDate = pickedDate1!.add(Duration(days: 15));
//                                     DateTime? pickedDate = await showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: firstDate, //DateTime.now() - not to allow to choose before today.
//                                         lastDate: DateTime(2100)/*now*/
//                                     );
//
//                                     if(pickedDate != null ){
//                                       print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
//                                       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//                                       print(formattedDate); //formatted date output using intl package =>  2021-03-16
//                                       //you can implement different kind of Date Format here according to your requirement
//
//                                       setState(() {
//                                         todate.text = formattedDate; //set output date to TextField value.
//
//
//                                       });
//                                     }else{
//                                       print("Date is not selected");
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(20)
//                                     ),
//                                       suffixIcon: Icon(Icons.calendar_month)
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     InkWell(
//                       onTap: (){
//
//                       },
//                       child: Container(
//                         height: 50,
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Constant.bgButton
//                         ),
//                         child: Center(child: Text('Submit', style: TextStyle(color: Colors.white),)),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//           )
//         ],
//       ),
//     );
//   }
// }
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:roomertenant/model/NoticePeriodHistoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';

class NoticePeriod extends StatefulWidget {
  final String? startDate; // Start date as string

  const NoticePeriod(this.startDate);

  @override
  State<NoticePeriod> createState() => _NoticePeriodState();
}

class _NoticePeriodState extends State<NoticePeriod> {
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  DateTime? fromDateValue; // Variable to hold the selected From Date
  String? branch_id;
  String? tenant_id;
  String? login_id;
  String? fromdatesend;
  String? todatesend;
  var _formKey = GlobalKey<FormState>();
  NoticePeriodHistoryModel? noticePeriodHistoryModel;
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    branch_id = await pref.getString("branch_id").toString();
    tenant_id = await pref.getString("tenant_id").toString();
    login_id = await pref.getString("login_id").toString();

    noticePeriodHistoryModel = await API.noticePeriodHistory(branch_id.toString(), tenant_id.toString());
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    print('start date: ${widget.startDate}');
    DateTime? defaultStartDate;

    if (widget.startDate != null && widget.startDate!.isNotEmpty) {
      try {
        // Parse the start date string to DateTime
        defaultStartDate = DateFormat('yyyy-MM-dd').parse(widget.startDate!);
        print(defaultStartDate);
      } catch (e) {
        // Handle parsing error if necessary
        defaultStartDate = DateTime(2021); // Default to 2021 if parsing fails
      }
    } else {
      defaultStartDate = DateTime(2021); // Default to 2021 if start date is not provided
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              color: Constant.bgLight, // Replace Constant.bgLight with your color
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Notice Period',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 85,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  // height: 60,
                                  width: 160,
                                  child: TextFormField(
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter from Date';
                                      }
                                      return null;
                                    },
                                    controller: fromdate,
                                    readOnly: true,
                                    onTap: () async {
                                      final now = DateTime.now();
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: defaultStartDate ?? now,
                                        firstDate: defaultStartDate ?? DateTime(2021),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        todate.clear();
                                        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                        fromdatesend = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        fromdatesend = DateFormat('yyyy-MM-dd').format(pickedDate);

                                        setState(() {
                                          fromDateValue = pickedDate;
                                          fromdate.text = formattedDate;
                                          // Automatically set the To Date to 15 days after the From Date
                                          final toDateValue = pickedDate.add(Duration(days: 15));
                                          // todate.text = DateFormat('dd-MM-yyyy').format(toDateValue);
                                        });
                                      } else {
                                        print("Date is not selected");
                                      }
                                    },
                                    decoration: InputDecoration(
                                      label: Text('From Date'),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      suffixIcon: Icon(Icons.calendar_month),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  // height: 60,
                                  width: 160,
                                  child: TextFormField(
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return 'Enter to Date';
                                      }
                                      return null;
                                    },
                                    controller: todate,
                                    readOnly: true,
                                    onTap: () async {
                                      if (fromDateValue == null) {

                                        // If no from date is selected, show a message or handle accordingly
                                        print("Please select a From Date first");
                                        return;
                                      }

                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: fromDateValue!.add(Duration(days: 1)),
                                        firstDate: fromDateValue!.add(Duration(days: 1)),
                                        lastDate: fromDateValue!.add(Duration(days: 15)),
                                      );

                                      if (pickedDate != null) {

                                        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                        todatesend = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        print('todatesend -- ${todatesend}');
                                        setState(() {
                                          todate.text = formattedDate;
                                        });
                                      } else {
                                        print("Date is not selected");
                                      }
                                    },
                                    decoration: InputDecoration(
                                      label: Text('To Date'),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      suffixIcon: Icon(Icons.calendar_month),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          print('${branch_id.toString()}--${tenant_id.toString()}--${login_id.toString()}--${fromdatesend.toString()}--${todatesend.toString()}');

                          if(_formKey.currentState!.validate()){
                            API.noticePeriod(branch_id.toString(), tenant_id.toString(), login_id.toString(), fromdatesend.toString(), todatesend.toString()).then((value){
                              if(value['success'] == 1){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));

                              }
                            });
                          }

                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Constant.bgButton
                          ),
                          child: Center(child: Text('Submit', style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                      SizedBox(height: 10,),
                      noticePeriodHistoryModel == null ? Center(child: CircularProgressIndicator()) :
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: noticePeriodHistoryModel?.data?.length,
                          itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            // height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Constant.bgTile,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${noticePeriodHistoryModel?.data?[index].residentName.toString()}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Start Date: ${noticePeriodHistoryModel?.data?[index].noticeSdate.toString()}'),
                                      Text('End Date: ${noticePeriodHistoryModel?.data?[index].noticeEdate.toString()}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Status: ',),
                                      Text('${noticePeriodHistoryModel?.data?[index].approvedStatus.toString()}', style: TextStyle(color: noticePeriodHistoryModel?.data?[index].approvedStatus.toString() == 'Approved' ? Colors.green : Colors.red),),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          );
                        },),
                      ),
                      const SizedBox(height: 10,)
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
