// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:roomertenant/api/apitget.dart';
// import 'package:roomertenant/model/notification_model.dart';
//
// class UnReadNotification extends StatefulWidget {
//   List<Unread>? notifitydetails;
//   UnReadNotification(this.notifitydetails,{Key? key}): super(key: key);
//
//   @override
//   State<UnReadNotification> createState() => _UnReadNotificationState();
// }
//
// class _UnReadNotificationState extends State<UnReadNotification> {
//   bool descTextShowFlag = false;
//   @override
//   Widget build(BuildContext context) {
//     // widget.notifitydetails.sort((a, b) => b.notificationDate!.compareTo(a.notificationDate!));
//
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       child: ListView.builder(
//         itemCount: widget.notifitydetails?.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.notifitydetails![index].title.toString(),style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500
//                 ),),
//                 Container(
//                   padding: EdgeInsets.only(left: 0,bottom: 0),
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     children: [
//                       widget.notifitydetails![index].status=='Read'?
//                       Container(
//                           width: MediaQuery.of(context).size.width * 0.90,
//                           child:  widget.notifitydetails![index].discription!.length>50?Text(
//                             widget.notifitydetails![index].discription!.substring(0,50).toString(),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             softWrap: false,
//                             style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),):Text(
//                             widget.notifitydetails![index].discription.toString(),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             softWrap: false,
//                             style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),)
//                       ):
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.90,
//                         child: Text(
//                           widget.notifitydetails![index].discription.toString(),
//                           style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),),
//                       ),
//                     ],
//                   ),
//                 ),
//                 widget.notifitydetails![index].discription!.length>50
//                     ? InkWell(
//                   onTap: () {
//                     setState(() {
//                       descTextShowFlag = !descTextShowFlag;
//                       if(descTextShowFlag){
//                         widget.notifitydetails![index].status='Unread';
//                         API.notificationRead(widget.notifitydetails![index].id.toString());
//                       }else{
//                         widget.notifitydetails![index].status='Read';
//                       }
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         widget.notifitydetails![index].status=='Unread'
//                             ? Text(
//                           "Show Less",
//                           style: TextStyle(fontSize: 12,color: Colors.blue),
//                         )
//                             : Text("Show More",
//                             style: TextStyle(fontSize: 12,color: Colors.blue))
//                       ],
//                     ),
//                   ),
//                 )
//                     : SizedBox(),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 0),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     crossAxisAlignment: CrossAxisAlignment.center,
//                 //     children: [
//                 //       Text(
//                 //         widget.notifitydetails[index].totalPay != ""
//                 //             ?  "₹ ${widget.notifitydetails[index].totalPay.toString()}" : "",
//                 //         style: TextStyle(fontSize: 16,
//                 //             color:
//                 //             Color(0xff67BA6C)),
//                 //       ),
//                 //       widget.notifitydetails![index].url != ""
//                 //           ? IconButton(onPressed: () async {
//                 //         showDialog<String>(
//                 //           context: context,
//                 //           barrierDismissible: false,
//                 //           barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//                 //           builder: (BuildContext
//                 //           context) =>
//                 //               WillPopScope(
//                 //                 onWillPop: () async => false,
//                 //                 child: AlertDialog(
//                 //                   elevation: 0,
//                 //                   backgroundColor: Colors.transparent,
//                 //                   content: Container(
//                 //                     child: Image.asset(
//                 //                         'assets/images/loading_anim.gif'),
//                 //                     height: 100,
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //         );
//                 //         await openFile(
//                 //           url: widget.notifitydetails![index].url.toString(),
//                 //           fileName:
//                 //           "Rec:${widget.notifitydetails![index].id}-${widget.notifitydetails![index].notificationDate}.pdf",
//                 //
//                 //         );
//                 //         Navigator.of(context).pop();
//                 //       }, icon: Icon(
//                 //         Icons.picture_as_pdf,
//                 //         color: Colors.red,
//                 //         size: 20,
//                 //       ))
//                 //           : SizedBox(),
//                 //       Spacer(),
//                 //       Text( widget.notifitydetails[index].notificationDate.toString(),
//                 //         style: TextStyle(fontSize: 14,
//                 //             color:
//                 //             Color(0xffABAFB8)),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 Divider(
//                   thickness: 1,
//                   color: Color(0xffD9E2FF
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Future openFile({required String url, required String? fileName}) async {
//     final file = await downloadFile(url, fileName);
//     if (file == null) return;
//     print('Path : ${file.path}');
//
//     OpenFilex.open(file.path);
//   }
//
//   Future<File?> downloadFile(String url, String? name) async {
//     final appstorage = await getApplicationDocumentsDirectory();
//     final file = File('${appstorage.path}/$name');
//
//     final response = await Dio().get(
//       url,
//       options: Options(
//         responseType: ResponseType.bytes,
//         followRedirects: false,
//         receiveTimeout: 0,
//       ),
//     );
//
//     final raf = file.openSync(mode: FileMode.write);
//     raf.writeFromSync(response.data);
//     await raf.close();
//
//     return file;
//   }
// /////  *****  Method for show the alert dialog   ***** //////
// }
