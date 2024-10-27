// import 'package:flutter/material.dart';
//
// import 'package:roomertenant/screens/tenant_complain.dart';
// import 'package:roomertenant/utils/utils.dart';
// import 'package:roomertenant/widgets/customStepperHorizontal.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../api/apitget.dart';
// import '../model/complain_model.dart';
//
// class TabApp extends StatefulWidget {
//   late List<String> page2item;
//   late List<Complain> page2complist;
//   late bool isPending;
//   TabApp(
//       {required this.page2item,
//       required this.page2complist,
//       required this.isPending});
//
//   @override
//   State<TabApp> createState() => _TabAppState();
// }
//
// class _TabAppState extends State<TabApp> {
//   int _index = 0;
//   List<String> _choicesList = ['In Process', 'Completed', 'Rejected'];
//   int defaultChoiceIndex = 0;
//   String selectedChip = "In Process";
//   TextEditingController remarkCtx = TextEditingController();
//   int curStep = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     print('complainData.....${widget.page2complist}');
//     return Center(
//       child: widget.page2complist.length > 0
//           ? ListView.builder(
//               itemCount: widget.page2complist.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(/*top: 8, bottom: 8,*/ left: 8),
//                   child: Column(
//                     children: [
//                       Theme(
//                         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//                         child: ExpansionTile(
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.7,
//                                 child: Row(
//                                   children: [
//                                     Flexible(
//                                       flex: 2,
//                                       child: Text(
//                                         widget.page2complist![index].remark!,
//                                         style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 12,
//                                     ),
//                                     Flexible(
//                                       flex: 0,
//                                       child: Container(
//                                         //  color: Colors.red,
//                                         child: Text(
//                                           widget.page2complist![index].complainDate!,
//                                           // widget.page2complist[index]['complain_date'],
//                                           style:
//                                               TextStyle(color: Color(0xffABAFB8)),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               widget.isPending
//                                   ? Row(
//                                       children: [
//                                         // const SizedBox(
//                                         //   width: 8,
//                                         // ),
//                                         Container(
//                                             //margin: EdgeInsets.only(left: 8),
//                                             child: InkWell(
//                                                 onTap: () {
//                                                   showModalBottomSheet<void>(
//                                                     context: context,
//                                                     builder:
//                                                         (BuildContext context) {
//                                                       return StatefulBuilder(
//                                                           builder: (BuildContext context, StateSetter setState) {
//                                                         return Container(
//                                                           height: 450,
//                                                           color: Colors.white,
//                                                           child: Padding(
//                                                             padding: const EdgeInsets.all(16.0),
//                                                             child: Column(mainAxisAlignment: MainAxisAlignment.start,
//                                                               mainAxisSize: MainAxisSize.min,
//                                                               children: <Widget>[
//                                                                 const Text(
//                                                                   'Update Status',
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                       fontSize:
//                                                                           16),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   height: 20,
//                                                                 ),
//                                                                 Wrap(
//                                                                   spacing: 8,
//                                                                   children: List.generate(_choicesList.length, (index) {
//                                                                     return ChoiceChip(
//                                                                       labelPadding: const EdgeInsets.all(2.0),
//                                                                       label: Text(_choicesList[index],
//                                                                       // label: Text(_choicesList[index],
//                                                                         style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                                                                                 color: defaultChoiceIndex == index ? Colors.white : Color(0xff001944),
//                                                                                 fontSize: 14,
//                                                                                 fontWeight: FontWeight.w400),
//                                                                       ),
//                                                                       selected: defaultChoiceIndex == index,
//                                                                       selectedColor: const Color(0xff001944),
//                                                                       checkmarkColor: Colors.white /*Color(0xff001944)*/,
//                                                                       backgroundColor: /*Colors.black26*/ Colors.white,
//
//                                                                       onSelected: (value) {
//                                                                         setState(() {
//                                                                           defaultChoiceIndex = value
//                                                                               ? index
//                                                                               : defaultChoiceIndex;
//                                                                         });
//
//                                                                         if (defaultChoiceIndex.toString() == "0") {
//                                                                           selectedChip = "In Process";
//                                                                         } else if (defaultChoiceIndex.toString() == "1") {
//                                                                           selectedChip = "Completed";
//                                                                         } else {
//                                                                           selectedChip = "Rejected";
//                                                                         }
//
//                                                                         print("-----default chip-----" + selectedChip.toString());
//                                                                       },
//                                                                       // backgroundColor: color,
//                                                                       elevation: 1,
//                                                                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                                                                     );
//                                                                   }),
//                                                                 ),
//                                                                 const SizedBox(height: 16,),
//                                                                 TextFormField(
//                                                                   controller: remarkCtx,
//                                                                   minLines: 4, // any number you need (It works as the rows for the textarea)
//                                                                   keyboardType: TextInputType.multiline,
//                                                                   maxLines: null,
//                                                                   cursorColor:
//                                                                       Colors.black,
//                                                                   decoration: InputDecoration(
//                                                                     border: OutlineInputBorder(
//                                                                         borderSide: BorderSide(
//                                                                             color: Colors.black.withOpacity(.4))),
//                                                                     focusedBorder:
//                                                                         OutlineInputBorder(
//                                                                             borderSide:
//                                                                                 new BorderSide(color: Colors.black.withOpacity(.4))),
//                                                                     enabledBorder:
//                                                                         OutlineInputBorder(
//                                                                             borderSide:
//                                                                                 new BorderSide(color: Colors.black.withOpacity(.4))),
//                                                                     hintText:
//                                                                         'Write something here..',
//                                                                     helperText:
//                                                                         'Keep it short.',
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 10,
//                                                                 ),
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                                   children: [
//                                                                     InkWell(
//                                                                       onTap:
//                                                                           () async {
//                                                                         SharedPreferences prefs = await SharedPreferences.getInstance();
//                                                                         String branch_id = await prefs.getString("branch_id").toString();
//                                                                         String user_id = await prefs.getString("user_id").toString();
//                                                                         String status = selectedChip.toString();
//                                                                         String complain_id = widget.page2complist[index].id
//                                                                         // String complain_id = widget.page2complist[index]['id']
//                                                                             .toString();
//                                                                         String remark = remarkCtx.text;
//                                                                         String follow_date = "";
//
//                                                                         showDialog<String>(
//                                                                           context: context,
//                                                                           barrierDismissible: false,
//                                                                           barrierLabel:
//                                                                               MaterialLocalizations.of(context).modalBarrierDismissLabel,
//                                                                           builder: (BuildContext context) => WillPopScope(
//                                                                             onWillPop: () async => false,
//                                                                             child:
//                                                                                 AlertDialog(
//                                                                               elevation: 0,
//                                                                               backgroundColor: Colors.transparent,
//                                                                               content: Container(
//                                                                                 child: Image.asset('assets/images/loading_anim.gif'),
//                                                                                 height: 100,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         );
//
//                                                                         await API
//                                                                             .complaintsStatusUpdateApi(branch_id, user_id, status,
//                                                                                 complain_id, remark, follow_date)
//                                                                             .then(
//                                                                                 (value) {
//                                                                           final snackbar =
//                                                                               SnackBar(
//                                                                                   content: Text('Complain updated successfully !!',
//                                                                             style: TextStyle(color: Colors.red),
//                                                                           ));
//                                                                           ScaffoldMessenger.of(context)
//                                                                               .showSnackBar(snackbar);
//                                                                           Navigator.pop(
//                                                                               context);
//                                                                           Navigator.pop(
//                                                                               context);
//                                                                           Navigator.pop(
//                                                                               context);
//                                                                         });
//                                                                       },
//                                                                       child:
//                                                                           Container(
//                                                                         alignment: Alignment.center,
//                                                                         width: 140,
//                                                                         height: 50,
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           borderRadius: BorderRadius.circular(10),
//                                                                           color: Color(0xff001944),
//                                                                         ),
//                                                                         child:
//                                                                             Text("Post",
//                                                                           style: TextStyle(color: Colors.white,
//                                                                               fontSize: 16,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       });
//                                                     },
//                                                   );
//                                                 },
//                                                 child: Icon(
//                                                   Icons.update,
//                                                   color: Colors.black,
//                                                 ))),
//                                       ],
//                                     )
//                                   : Container(),
//                             ],
//                           ),
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//
//                               // height: 200,
//                               //color: Colors.red,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Flexible(
//                                     child: SingleChildScrollView(
//                                       child: Container(
//                                         //  width: MediaQuery.of(context).size.width*.5,
//                                         // color: Colors.red,
//                                         // padding: EdgeInsets.only(left: 40),
//                                         child: Theme(
//                                           data: ThemeData(
//                                             canvasColor: Colors.white,
//                                             colorScheme: Theme.of(context)
//                                                 .colorScheme
//                                                 .copyWith(
//                                                   primary: Colors.orange,
//                                                 ),
//                                           ),
//                                           child:
//                                               /*StepProgressView(curStep: curStep, titles: ['Pending', 'Completed'], width: MediaQuery.of(context).size.width, color: Colors.green ,)*/
//                                           // StepProgressView(page2item: widget.page2item, page2complist: widget.page2complist, isPending: widget.isPending),
//                                           StepProgressView(
//                                             trail: (widget.page2complist[index].trail ),
//                                             // trail: (widget.page2complist[index]['trail'] as List).cast<Map<String, dynamic>>(),
//                                             isPending: widget.isPending,)
//
//                                           //     Container(
//                                           //   height: 100,
//                                           //   color: Colors.white,
//                                           //   width:
//                                           //       MediaQuery.of(context).size.width,
//                                           //   child: Stepper(
//                                           //     // connectorThickness: 2,
//                                           //       stepIconBuilder:
//                                           //           (stepIndex, stepState) {
//                                           //         return Container(
//                                           //           // height: 80,
//                                           //           // width: 80,
//                                           //           decoration: BoxDecoration(
//                                           //               borderRadius: BorderRadius.circular(20),
//                                           //               color: stepIndex == 0
//                                           //                   ? Colors.orangeAccent
//                                           //                   : stepIndex == 1 && widget.page2complist[index]['trail'][stepIndex]['status'] ==
//                                           //                   "Completed"
//                                           //                   ? Colors.green
//                                           //                   : Colors.red),
//                                           //           child: Center(
//                                           //               child: stepIndex == 0
//                                           //                   ? Text((stepIndex + 1).toString(), style: const TextStyle(color: Colors.white),)
//                                           //                   : stepIndex == 1 && widget.page2complist[index]['trail'][stepIndex]['status'] ==
//                                           //                   "Completed"
//                                           //                   ? const Icon(Icons.check, color: Colors.white,)
//                                           //                   : const Icon(Icons.cancel, color: Colors.white,)
//                                           //           ),
//                                           //         );
//                                           //       },
//                                           //       elevation: 0,
//                                           //       type: StepperType.horizontal,
//                                           //       currentStep: _index,
//                                           //       // onStepCancel: () {
//                                           //       //   /*if (_index > 0) {
//                                           //       //                           setState(() {
//                                           //       //                             _index -= 1;
//                                           //       //                           });
//                                           //       //                         }*/
//                                           //       //   Navigator.pop(context);
//                                           //       // },
//                                           //
//                                           //       // onStepContinue: () {
//                                           //       //   if (_index <= 0) {
//                                           //       //     setState(() {
//                                           //       //       _index += 1;
//                                           //       //     });
//                                           //       //   }
//                                           //       // },
//                                           //       // onStepTapped: (int index) {
//                                           //       //   setState(() {
//                                           //       //     _index = index;
//                                           //       //   });
//                                           //       // },
//                                           //       /*controlsBuilder: (context, controller) {
//                                           //                             return const SizedBox.shrink();
//                                           //                           },*/
//                                           //       steps: List.generate(
//                                           //         widget.page2complist[index]['trail'].length,
//                                           //         (index1) => Step(
//                                           //             title: Text(widget.page2complist[index]['trail'][index1]['status'],
//                                           //                 style: TextStyle(
//                                           //                     fontSize: 16,
//                                           //                     color:
//                                           //                         Colors.black)),
//                                           //             subtitle:
//                                           //                 widget.page2complist[index]['trail'][index1]['status'] ==
//                                           //                         "Completed"
//                                           //                     ? Text(widget.page2complist[index]['trail'][index1]['remark_date'],
//                                           //                         style: TextStyle(
//                                           //                             fontSize:
//                                           //                                 11))
//                                           //                     : Column(
//                                           //                         crossAxisAlignment:
//                                           //                             CrossAxisAlignment
//                                           //                                 .start,
//                                           //                         children: [
//                                           //                           Text(
//                                           //                               widget.page2complist[index]['trail']
//                                           //                                       [
//                                           //                                       index1]
//                                           //                                   [
//                                           //                                   'remark_date'],
//                                           //                               style: TextStyle(
//                                           //                                   fontSize:
//                                           //                                       11)),
//                                           //                           // Text("FollowUp ${ widget.page2complist[index]['trail'][index1]['follow_date'] }")
//                                           //                         ],
//                                           //                       ),
//                                           //             content: Container(),
//                                           //             isActive: _index >= 0,
//                                           //             /*  state: _index >= 1 ?
//                                           //         StepState.complete : StepState.disabled,*/
//                                           //             state: /*widget.page2complist[index]['trail'].length >= 0*/
//                                           //                 widget.page2complist[index]['trail']
//                                           //                                 [index1]
//                                           //                             ['status'] ==
//                                           //                         "Completed"
//                                           //                     ? StepState.complete
//                                           //                     : StepState.disabled),
//                                           //       )
//                                           //       /* [
//                                           //         Step(
//                                           //           title: const Text('Step 1 title'),
//                                           //           subtitle: Text("2022-02-04"), content: Container(),
//                                           //           isActive: _index >= 0,
//                                           //           state: _index >= 1 ?
//                                           //           StepState.complete : StepState.disabled,
//                                           //
//                                           //         ),
//                                           //         Step(
//                                           //           title: Text('Step 2 title'),
//                                           //           subtitle:Text("2022-02-04") ,
//                                           //           content: Container(),
//                                           //           isActive: _index >= 0,
//                                           //           state: _index >= 2 ?
//                                           //           StepState.complete : StepState.disabled,
//                                           //
//                                           //         ),
//                                           //       ],*/
//                                           //       ),
//                                           // ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//
//                                   /*  Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: const [
//                                                 Expanded(
//                                                   child: Text('Remark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     'Status',
//                                                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Text('Remark Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                                                 ),
//                                                 Expanded(
//                                                   child: Text('Follow Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                                                 )
//                                               ],
//                                             ),
//                                             const Divider(
//                                               color: Colors.black,
//                                             ),
//                                             Expanded(
//                                               child: Container(
//                                                 // height: 250,
//                                                 child: ListView.builder(
//                                                   itemCount: page2complist[index]['trail'].length,
//                                                   itemBuilder: (BuildContext, int index1) {
//                                                     return IntrinsicHeight(
//                                                       child:
//                                                       Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Expanded(
//                                                               child: Text(page2complist[index]['trail'][index1]['remark'],
//                                                                   style: TextStyle(fontSize: 11))),
//                                                           VerticalDivider(
//                                                             color: Colors.grey,
//                                                             thickness: 1,
//                                                             width: 2.5,
//                                                           ),
//                                                           Expanded(
//                                                               child: Text(page2complist[index]['trail'][index1]['status'],
//                                                                   style: TextStyle(fontSize: 11))),
//                                                           VerticalDivider(
//                                                             color: Colors.grey,
//                                                             thickness: 1,
//                                                             width: 2.5,
//                                                           ),
//                                                           Expanded(
//                                                               child: Text(page2complist[index]['trail'][index1]['remark_date'],
//                                                                   style: TextStyle(fontSize: 11))),
//                                                           VerticalDivider(
//                                                             color: Colors.grey,
//                                                             thickness: 1,
//                                                             width: 2.5,
//                                                           ),
//                                                           Expanded(
//                                                               child: Text(page2complist[index]['trail'][index1]['follow_date'],
//                                                                   style: TextStyle(fontSize: 11))),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ),*/
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: 8.0),
//                         child: Divider(
//                           color: Colors.grey.shade300,
//                           thickness: 1,
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//
//                 //   Padding(
//                 //   padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
//                 //   child: Column(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       SizedBox(
//                 //         height: 4,
//                 //       ),
//                 //       Row(
//                 //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //         children: [
//                 //           Container(
//                 //             width: MediaQuery.of(context).size.width * 0.7,
//                 //             child: Row(
//                 //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //               children: [
//                 //                 Flexible(
//                 //                   flex: 2,
//                 //                   child: Text(
//                 //                     widget.page2complist[index]['remark'],
//                 //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 //                   ),
//                 //                 ),
//                 //                 SizedBox(
//                 //                   width: 12,
//                 //                 ),
//                 //                 Flexible(
//                 //                   flex: 0,
//                 //                   child: Container(
//                 //                     //  color: Colors.red,
//                 //                     child: Text(
//                 //                       widget.page2complist[index]['complain_date'],
//                 //                       style: TextStyle(color: Color(0xffABAFB8)),
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //           Container(
//                 //             child: Row(
//                 //               children: [
//                 //                 Container(
//                 //
//                 //                   //margin: EdgeInsets.only(left: 8),
//                 //                     child: InkWell(
//                 //                         onTap: () {
//                 //                           showDialog<String>(
//                 //                             context: context,
//                 //                             builder: (BuildContext context) => AlertDialog(
//                 //                               insetPadding: EdgeInsets.symmetric(horizontal: 20),
//                 //                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
//                 //                               title: Column(
//                 //                                 children: [
//                 //                                   const Text('Complain Trails'),
//                 //                                   Divider(
//                 //                                     thickness: 1,
//                 //                                     color: Color(0xffD9E2FF),
//                 //                                   )
//                 //                                 ],
//                 //                               ),
//                 //                               contentPadding: EdgeInsets.zero,
//                 //                               content: Container(
//                 //                                 width: MediaQuery.of(context).size.width,
//                 //
//                 //                                 // height: 200,
//                 //                                 //color: Colors.red,
//                 //                                 child: Column(
//                 //                                   mainAxisSize: MainAxisSize.min,
//                 //                                   children: [
//                 //                                     Flexible(
//                 //                                       child: SingleChildScrollView(
//                 //                                         child: Container(
//                 //                                           //  width: MediaQuery.of(context).size.width*.5,
//                 //                                           // color: Colors.red,
//                 //                                           padding: EdgeInsets.only(left: 40),
//                 //                                           child: Theme(
//                 //                                             data: ThemeData(
//                 //                                               canvasColor: Colors.yellow,
//                 //                                               colorScheme: Theme.of(context).colorScheme.copyWith(
//                 //                                                 primary: primaryColor,
//                 //                                                 // background: Colors.red,
//                 //                                                 //  secondary: Colors.red,
//                 //                                               ),
//                 //                                             ),
//                 //                                             child: Stepper(
//                 //                                                 currentStep: _index,
//                 //                                                 onStepCancel: () {
//                 //                                                   /*if (_index > 0) {
//                 //                                                           setState(() {
//                 //                                                             _index -= 1;
//                 //                                                           });
//                 //                                                         }*/
//                 //                                                   Navigator.pop(context);
//                 //                                                 },
//                 //                                                 onStepContinue: () {
//                 //                                                   if (_index <= 0) {
//                 //                                                     setState(() {
//                 //                                                       _index += 1;
//                 //                                                     });
//                 //                                                   }
//                 //                                                 },
//                 //                                                 onStepTapped: (int index) {
//                 //                                                   setState(() {
//                 //                                                     _index = index;
//                 //                                                   });
//                 //                                                 },
//                 //                                                 /*controlsBuilder: (context, controller) {
//                 //                                                         return const SizedBox.shrink();
//                 //                                                       },*/
//                 //                                                 steps: List.generate(
//                 //                                                     widget.page2complist[index]['trail'].length,
//                 //                                                         (index1) => Step(
//                 //                                                         title: Text(widget.page2complist[index]['trail'][index1]['status'],
//                 //                                                             style: TextStyle(fontSize: 16, color: Colors.black)),
//                 //                                                         subtitle: widget.page2complist[index]['trail'][index1]['status'] ==
//                 //                                                             "Completed"
//                 //                                                             ? Text(widget.page2complist[index]['trail'][index1]['remark_date'],
//                 //                                                             style: TextStyle(fontSize: 11))
//                 //                                                             : Column(
//                 //                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                 //                                                           children: [
//                 //                                                             Text(widget.page2complist[index]['trail'][index1]['remark_date'],
//                 //                                                                 style: TextStyle(fontSize: 11)),
//                 //                                                             // Text("FollowUp ${ widget.page2complist[index]['trail'][index1]['follow_date'] }")
//                 //                                                           ],
//                 //                                                         ),
//                 //                                                         content: Container(),
//                 //                                                         isActive: _index >= 0,
//                 //                                                         /*  state: _index >= 1 ?
//                 //                                     StepState.complete : StepState.disabled,*/
//                 //                                                         state: widget.page2complist[index]['trail'][index1]['status'] == "Completed"
//                 //                                                             ? StepState.complete
//                 //                                                             : StepState.disabled))
//                 //                                               /* [
//                 //                                     Step(
//                 //                                       title: const Text('Step 1 title'),
//                 //                                       subtitle: Text("2022-02-04"), content: Container(),
//                 //                                       isActive: _index >= 0,
//                 //                                       state: _index >= 1 ?
//                 //                                       StepState.complete : StepState.disabled,
//                 //
//                 //                                     ),
//                 //                                     Step(
//                 //                                       title: Text('Step 2 title'),
//                 //                                       subtitle:Text("2022-02-04") ,
//                 //                                       content: Container(),
//                 //                                       isActive: _index >= 0,
//                 //                                       state: _index >= 2 ?
//                 //                                       StepState.complete : StepState.disabled,
//                 //
//                 //                                     ),
//                 //                                   ],*/
//                 //                                             ),
//                 //                                           ),
//                 //                                         ),
//                 //                                       ),
//                 //                                     ),
//                 //
//                 //                                     /*  Row(
//                 //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //                                   children: const [
//                 //                                     Expanded(
//                 //                                       child: Text('Remark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                 //                                     ),
//                 //                                     Expanded(
//                 //                                       child: Text(
//                 //                                         'Status',
//                 //                                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                 //                                       ),
//                 //                                     ),
//                 //                                     Expanded(
//                 //                                       child: Text('Remark Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                 //                                     ),
//                 //                                     Expanded(
//                 //                                       child: Text('Follow Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                 //                                     )
//                 //                                   ],
//                 //                                 ),
//                 //                                 const Divider(
//                 //                                   color: Colors.black,
//                 //                                 ),
//                 //                                 Expanded(
//                 //                                   child: Container(
//                 //                                     // height: 250,
//                 //                                     child: ListView.builder(
//                 //                                       itemCount: page2complist[index]['trail'].length,
//                 //                                       itemBuilder: (BuildContext, int index1) {
//                 //                                         return IntrinsicHeight(
//                 //                                           child:
//                 //                                           Row(
//                 //                                             crossAxisAlignment: CrossAxisAlignment.start,
//                 //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //                                             children: [
//                 //                                               Expanded(
//                 //                                                   child: Text(page2complist[index]['trail'][index1]['remark'],
//                 //                                                       style: TextStyle(fontSize: 11))),
//                 //                                               VerticalDivider(
//                 //                                                 color: Colors.grey,
//                 //                                                 thickness: 1,
//                 //                                                 width: 2.5,
//                 //                                               ),
//                 //                                               Expanded(
//                 //                                                   child: Text(page2complist[index]['trail'][index1]['status'],
//                 //                                                       style: TextStyle(fontSize: 11))),
//                 //                                               VerticalDivider(
//                 //                                                 color: Colors.grey,
//                 //                                                 thickness: 1,
//                 //                                                 width: 2.5,
//                 //                                               ),
//                 //                                               Expanded(
//                 //                                                   child: Text(page2complist[index]['trail'][index1]['remark_date'],
//                 //                                                       style: TextStyle(fontSize: 11))),
//                 //                                               VerticalDivider(
//                 //                                                 color: Colors.grey,
//                 //                                                 thickness: 1,
//                 //                                                 width: 2.5,
//                 //                                               ),
//                 //                                               Expanded(
//                 //                                                   child: Text(page2complist[index]['trail'][index1]['follow_date'],
//                 //                                                       style: TextStyle(fontSize: 11))),
//                 //                                             ],
//                 //                                           ),
//                 //                                         );
//                 //                                       },
//                 //                                     ),
//                 //                                   ),
//                 //                                 ),*/
//                 //                                   ],
//                 //                                 ),
//                 //                               ),
//                 //                             ),
//                 //                           );
//                 //                         },
//                 //                         child: Icon(
//                 //                           Icons.arrow_forward_ios,
//                 //                           color: Colors.black,
//                 //                         ))),
//                 //                 widget.isPending
//                 //                     ? Row(
//                 //                   children: [
//                 //                     const SizedBox(
//                 //                       width: 8,
//                 //                     ),
//                 //                     Container(
//                 //                       //margin: EdgeInsets.only(left: 8),
//                 //                         child: InkWell(
//                 //                             onTap: () {
//                 //                               showModalBottomSheet<void>(
//                 //                                 context: context,
//                 //                                 builder: (BuildContext context) {
//                 //                                   return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
//                 //                                     return Container(
//                 //                                       height: 450,
//                 //                                       color: Colors.white,
//                 //                                       child: Padding(
//                 //                                         padding: const EdgeInsets.all(16.0),
//                 //                                         child: Column(
//                 //                                           mainAxisAlignment: MainAxisAlignment.start,
//                 //                                           mainAxisSize: MainAxisSize.min,
//                 //                                           children: <Widget>[
//                 //                                             const Text(
//                 //                                               'Update Status',
//                 //                                               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//                 //                                             ),
//                 //                                             SizedBox(
//                 //                                               height: 20,
//                 //                                             ),
//                 //                                             Wrap(
//                 //                                               spacing: 8,
//                 //                                               children: List.generate(_choicesList.length, (index) {
//                 //                                                 return ChoiceChip(
//                 //                                                   labelPadding: EdgeInsets.all(2.0),
//                 //                                                   label: Text(
//                 //                                                     _choicesList[index],
//                 //                                                     style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                 //                                                         color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
//                 //                                                   ),
//                 //                                                   selected: defaultChoiceIndex == index,
//                 //                                                   selectedColor: Color(0xff001944),
//                 //                                                   checkmarkColor: Colors.white,
//                 //                                                   backgroundColor: Colors.black26,
//                 //
//                 //                                                   onSelected: (value) {
//                 //                                                     setState(() {
//                 //                                                       defaultChoiceIndex = value ? index : defaultChoiceIndex;
//                 //                                                     });
//                 //
//                 //                                                     if (defaultChoiceIndex.toString() == "0") {
//                 //                                                       selectedChip = "In Process";
//                 //                                                     } else if (defaultChoiceIndex.toString() == "1") {
//                 //                                                       selectedChip = "Completed";
//                 //                                                     } else {
//                 //                                                       selectedChip = "Rejected";
//                 //                                                     }
//                 //
//                 //                                                     print("-----default chip-----" + selectedChip.toString());
//                 //                                                   },
//                 //                                                   // backgroundColor: color,
//                 //                                                   elevation: 1,
//                 //                                                   padding: EdgeInsets.symmetric(horizontal: 16),
//                 //                                                 );
//                 //                                               }),
//                 //                                             ),
//                 //                                             SizedBox(
//                 //                                               height: 16,
//                 //                                             ),
//                 //                                             TextFormField(
//                 //                                               controller: remarkCtx,
//                 //                                               minLines: 4, // any number you need (It works as the rows for the textarea)
//                 //                                               keyboardType: TextInputType.multiline,
//                 //                                               maxLines: null,
//                 //                                               cursorColor: Colors.black,
//                 //                                               decoration: new InputDecoration(
//                 //                                                 border: new OutlineInputBorder(
//                 //                                                     borderSide: new BorderSide(color: Colors.black.withOpacity(.4))),
//                 //                                                 focusedBorder: OutlineInputBorder(
//                 //                                                     borderSide: new BorderSide(color: Colors.black.withOpacity(.4))),
//                 //                                                 enabledBorder: OutlineInputBorder(
//                 //                                                     borderSide: new BorderSide(color: Colors.black.withOpacity(.4))),
//                 //                                                 hintText: 'Write something here..',
//                 //                                                 helperText: 'Keep it short.',
//                 //                                               ),
//                 //                                             ),
//                 //                                             SizedBox(
//                 //                                               height: 10,
//                 //                                             ),
//                 //                                             Row(
//                 //                                               mainAxisAlignment: MainAxisAlignment.end,
//                 //                                               children: [
//                 //                                                 InkWell(
//                 //                                                   onTap: () async {
//                 //                                                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                 //                                                     String branch_id = await prefs.getString("branch_id").toString();
//                 //                                                     String user_id = await prefs.getString("user_id").toString();
//                 //                                                     String status = selectedChip.toString();
//                 //                                                     String complain_id = widget.page2complist[index]['id'].toString();
//                 //                                                     String remark = remarkCtx.text;
//                 //                                                     String follow_date = "";
//                 //
//                 //                                                     showDialog<String>(
//                 //                                                       context: context,
//                 //                                                       barrierDismissible: false,
//                 //                                                       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//                 //                                                       builder: (BuildContext context) => WillPopScope(
//                 //                                                         onWillPop: () async => false,
//                 //                                                         child: AlertDialog(
//                 //                                                           elevation: 0,
//                 //                                                           backgroundColor: Colors.transparent,
//                 //                                                           content: Container(
//                 //                                                             child: Image.asset('assets/images/loading_anim.gif'),
//                 //                                                             height: 100,
//                 //                                                           ),
//                 //                                                         ),
//                 //                                                       ),
//                 //                                                     );
//                 //
//                 //                                                     await API
//                 //                                                         .complaintsStatusUpdateApi(
//                 //                                                         branch_id, user_id, status, complain_id, remark, follow_date)
//                 //                                                         .then((value) {
//                 //                                                       final snackbar = SnackBar(
//                 //                                                           content: Text(
//                 //                                                             'Complain updated successfully !!',
//                 //                                                             style: TextStyle(color: Colors.red),
//                 //                                                           ));
//                 //                                                       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//                 //                                                       Navigator.pop(context);
//                 //                                                       Navigator.pop(context);
//                 //                                                       Navigator.pop(context);
//                 //                                                     });
//                 //                                                   },
//                 //                                                   child: Container(
//                 //                                                     alignment: Alignment.center,
//                 //                                                     width: 140,
//                 //                                                     height: 50,
//                 //                                                     decoration: BoxDecoration(
//                 //                                                       borderRadius: BorderRadius.circular(10),
//                 //                                                       color: Color(0xff001944),
//                 //                                                     ),
//                 //                                                     child: Text(
//                 //                                                       "Post",
//                 //                                                       style: TextStyle(
//                 //                                                           color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                 //                                                     ),
//                 //                                                   ),
//                 //                                                 ),
//                 //                                               ],
//                 //                                             )
//                 //                                           ],
//                 //                                         ),
//                 //                                       ),
//                 //                                     );
//                 //                                   });
//                 //                                 },
//                 //                               );
//                 //                             },
//                 //                             child: Icon(
//                 //                               Icons.update,
//                 //                               color: Colors.black,
//                 //                             ))),
//                 //                   ],
//                 //                 )
//                 //                     : Container(),
//                 //                 const SizedBox(
//                 //                   width: 16,
//                 //                 )
//                 //               ],
//                 //             ),
//                 //           )
//                 //         ],
//                 //       ),
//                 //       const SizedBox(
//                 //         height: 4,
//                 //       ),
//                 //       const Divider(
//                 //         thickness: 1,
//                 //         color: Color(0xffD9E2FF),
//                 //       )
//                 //     ],
//                 //   ),
//                 // );
//               },
//             )
//           : const Text('No Complaints'),
//     );
//   }
// }
