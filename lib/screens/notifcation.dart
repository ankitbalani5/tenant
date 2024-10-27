// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:roomertenant/api/apitget.dart';
// import 'package:roomertenant/api/providerfunction.dart';
// import 'package:roomertenant/constant/constant.dart';
// import 'package:roomertenant/model/notification_model.dart';
// import 'package:roomertenant/screens/clearNotificationBloc/clear_notification_bloc.dart';
// import 'package:roomertenant/screens/newhome.dart';
// import 'package:roomertenant/screens/notificationList/notification_list_bloc.dart';
// import 'package:roomertenant/screens/read_notification.dart';
// import 'package:roomertenant/screens/unread_notification.dart';
// import 'package:roomertenant/utils/utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import 'internet_check.dart';
//
// class NotificationPage extends StatefulWidget {
//   // List<ReadData>? readNotificationList;
//   List<NotificationData>? notificationData;
//   NotificationPage(this.notificationData,{Key? key}): super(key: key);
//   // NotificationPage(this.readNotificationList,{Key? key}): super(key: key);
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage>  with SingleTickerProviderStateMixin {
//   bool state = false;
//   late TabController _tabController;
//   TextPainter? textPainter;
//   bool isOpen = false;
//   bool descTextShowFlag = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _tabController = TabController(initialIndex: 0,length: 2, vsync: this);
//     fetchData();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Future<dynamic> clearData() async{
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var tenant_id = pref.getString('tenant_id').toString();
//     API.clearNotificationdata(tenant_id).then((value) {
//       if(value.success == 1){
//         if(value.data![0].status == 'Unread'){
//           var dataLength = value.data!.length;
//         }
//       }
//     });
//   }
//
//   fetchData() async{
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var tenant_id = pref.getString('tenant_id').toString();
//     BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(tenant_id));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('buildcall');
//     // final notifitydetails = ModalRoute.of(context)!.settings.arguments as List<Unread>;
//     return Scaffold(
//
//       body: NetworkObserverBlock(
//         child: Stack(
//           children: [
//           Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 120,
//             color: Constant.bgLight,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Icon(
//                             Icons.arrow_back_ios,
//                             size: 18,
//                             color: Colors.white,
//                           )),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       const Text(
//                         'Notification',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                             fontSize: 20),
//                       ),
//                     ],
//                   ),
//                   InkWell(
//                     onTap: () async{
//                       SharedPreferences pref = await SharedPreferences.getInstance();
//                       var tenant_id = pref.getString('tenant_id').toString();
//                       BlocProvider.of<ClearNotificationBloc>(context).add(ClearNotificationRefreshEvent(tenant_id));
//                       setState(() {
//
//                       });
//                     },
//                     child: Align(
//                         alignment: Alignment.centerRight,
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.grey.shade200
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),),
//                             ))),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // Container
//         Positioned(
//             top: 85,
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: ClipRRect(
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
//
//                 child: Container(
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
//                 ),
//                 child: BlocBuilder<NotificationListBloc, NotificationListState>(builder: (context, state) {
//                   // if(state is NotificationListLoading){
//                   //   return Center(child: CircularProgressIndicator(),);
//                   // }
//                   if(state is NotificationListSuccess){
//                     return ListView.builder(
//                       padding: EdgeInsets.zero,
//                       itemCount: state.notificationModel.data?.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: (){
//                             API.readNotification(state.notificationModel.data![index].id.toString()).then((value) async {
//                               if(value['success'] == 1){
//
//                                 SharedPreferences pref = await SharedPreferences.getInstance();
//                                 var tenant_id = pref.getString('tenant_id').toString();
//                                 BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(tenant_id));
//                               }
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Constant.bgTile
//                             ),
//                             child: Container(
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   state.notificationModel.data![index].status == 'Read' ? Icon(Icons.email_outlined) : Icon(FontAwesomeIcons.envelopeOpen),
//                                   SizedBox(width: 10,),
//                                   SizedBox(
//                                     width: MediaQuery.of(context).size.width*.7,
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(state.notificationModel.data![index].title.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
//                                         Text(state.notificationModel.data![index].discription.toString(), style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis,),
//
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                             // Container(
//                             //       // color: state.notificationModel.data![index].status == 'Unread' ? Colors.blue.shade100 : Colors.orange.shade100,
//                             //       child: Column(
//                             //         mainAxisAlignment: MainAxisAlignment.start,
//                             //         crossAxisAlignment: CrossAxisAlignment.start,
//                             //         children: [
//                             //           Text(state.notificationModel.data![index].title.toString(),style: TextStyle(
//                             //               fontSize: 14,
//                             //               fontWeight: FontWeight.w500
//                             //           ),),
//                             //           Container(
//                             //             padding: EdgeInsets.only(left: 0,bottom: 0),
//                             //             width: MediaQuery.of(context).size.width,
//                             //             child: Row(
//                             //               children: [
//                             //                 state.notificationModel.data![index].status=='Unread'?
//                             //                 Container(
//                             //                     // width: MediaQuery.of(context).size.width * 0.90,
//                             //                     child:  state.notificationModel.data![index].discription!.length>50?Text(
//                             //                       state.notificationModel.data![index].discription!.substring(0,50).toString(),
//                             //                       overflow: TextOverflow.ellipsis,
//                             //                       maxLines: 1,
//                             //                       softWrap: false,
//                             //                       style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),):Text(
//                             //                       state.notificationModel.data![index].discription.toString(),
//                             //                       overflow: TextOverflow.ellipsis,
//                             //                       maxLines: 1,
//                             //                       softWrap: false,
//                             //                       style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),)
//                             //                 ):
//                             //                 Container(
//                             //                   // width: MediaQuery.of(context).size.width * 0.90,
//                             //                   child: Text(
//                             //                     state.notificationModel.data![index].discription.toString(),
//                             //                     style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),),
//                             //                 ),
//                             //               ],
//                             //             ),
//                             //           ),
//                             //           /*if (index != widget.notificationData!.length - 1) // Check if it's not the last item
//                             //                                     Divider(
//                             //                                       thickness: 1,
//                             //                                       color: Color(0xffD9E2FF),
//                             //                                     ),*/
//                             //           /*Divider(
//                             //                                     thickness: 1,
//                             //                                     color: Color(0xffD9E2FF
//                             //                                     ),
//                             //                                   )*/
//                             //         ],
//                             //       ),
//                             //     ),
//                           ),
//                         );
//                     //       Container(
//                     //       // color: state.notificationModel.data![index].status == 'Unread' ? Colors.blue.shade100 : Colors.orange.shade100,
//                     //       child: Padding(
//                     //         padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//                     //         child: Column(
//                     //           mainAxisAlignment: MainAxisAlignment.start,
//                     //           crossAxisAlignment: CrossAxisAlignment.start,
//                     //           children: [
//                     //             Text(state.notificationModel.data![index].title.toString(),style: TextStyle(
//                     //                 fontSize: 14,
//                     //                 fontWeight: FontWeight.w500
//                     //             ),),
//                     //             Container(
//                     //               padding: EdgeInsets.only(left: 0,bottom: 0),
//                     //               width: MediaQuery.of(context).size.width,
//                     //               child: Row(
//                     //                 children: [
//                     //                   state.notificationModel.data![index].status=='Unread'?
//                     //                   Container(
//                     //                       width: MediaQuery.of(context).size.width * 0.90,
//                     //                       child:  state.notificationModel.data![index].discription!.length>50?Text(
//                     //                         state.notificationModel.data![index].discription!.substring(0,50).toString(),
//                     //                         overflow: TextOverflow.ellipsis,
//                     //                         maxLines: 1,
//                     //                         softWrap: false,
//                     //                         style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),):Text(
//                     //                         state.notificationModel.data![index].discription.toString(),
//                     //                         overflow: TextOverflow.ellipsis,
//                     //                         maxLines: 1,
//                     //                         softWrap: false,
//                     //                         style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),)
//                     //                   ):
//                     //                   Container(
//                     //                     width: MediaQuery.of(context).size.width * 0.90,
//                     //                     child: Text(
//                     //                       state.notificationModel.data![index].discription.toString(),
//                     //                       style: TextStyle(color: Color(0xff717D96),fontWeight: FontWeight.w500),),
//                     //                   ),
//                     //                   Icon(Icons.email)
//                     //                 ],
//                     //               ),
//                     //             ),
//                     //             /*if (index != widget.notificationData!.length - 1) // Check if it's not the last item
//                     //   Divider(
//                     //     thickness: 1,
//                     //     color: Color(0xffD9E2FF),
//                     //   ),*/
//                     //             /*Divider(
//                     //   thickness: 1,
//                     //   color: Color(0xffD9E2FF
//                     //   ),
//                     // )*/
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     );
//                       },
//                     );
//                   }
//                   if(state is NotificationListError){
//                     return Center(child: Text(state.error),);
//                   }
//                   return SizedBox();
//                 },),
//               ),
//             )
//         )
//           ],
//         ),
//       )
//
//     );
//
//   }
// }


import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/api/providerfunction.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/notification_model.dart';
import 'package:roomertenant/screens/clearNotificationBloc/clear_notification_bloc.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/notificationList/notification_list_bloc.dart';
import 'package:roomertenant/screens/read_notification.dart';
import 'package:roomertenant/screens/unread_notification.dart';
import 'package:roomertenant/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'internet_check.dart';

class NotificationPage extends StatefulWidget {
  List<bool>? statusList1;
  NotificationPage(this.statusList1, {Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  bool state = false;
  late TabController _tabController;
  bool isOpen = false;
  bool descTextShowFlag = false;
  Set<int> expandedIndices = {};
  bool isExpanded = false;
  List<bool>? statusList = [];
  List<NotificationData>? notificationData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    // fetchData();
    // getData();

    FirebaseMessaging.onMessage.listen(
          (message) async {
            statusList = [];
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            final residentId = prefs.getString('tenant_id');

            NotificationModel paymentPending = await API.notificationList(residentId.toString());
            setState(() {
              notificationData = paymentPending.data;
              // getData();
              if (notificationData != null) {
                for (var item in notificationData!) {
                  if (item.status == 'Read') {
                    statusList?.add(true);
                  } else {
                    statusList?.add(false);
                  }
                }
              }
              // unreadnotificationList = paymentPending.data!.unread;
              // readnotificationList = paymentPending.data!.read;
            });
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<dynamic> clearData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var tenant_id = pref.getString('tenant_id').toString();
    API.clearNotificationdata(tenant_id).then((value) {
      if (value.success == 1) {
        if (value.data![0].status == 'Unread') {
          var dataLength = value.data!.length;
        }
      }
    });
  }

  // getData(){
  //   BlocListener<NotificationListBloc, NotificationListState>(listener: (context, state) {
  //     if(state is NotificationListSuccess){
  //
  //       List<NotificationData>? list = state.notificationModel.data;
  //
  //       if (list != null) {
  //         for (var item in list) {
  //           if (item.status == 'Read') {
  //             statusList?.add(true);
  //           } else {
  //             statusList?.add(false);
  //           }
  //         }
  //       }
  //     }
  //   },);
  // }

  // fetchData() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var tenant_id = pref.getString('tenant_id').toString();
  //   BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(tenant_id));
  //   NotificationModel paymentPending = await API.notificationList(tenant_id.toString());
  //   setState(() {
  //     notificationData = paymentPending.data;
  //     getData();
  //     if (notificationData != null) {
  //       for (var item in notificationData!) {
  //         if (item.status == 'Read') {
  //           statusList?.add(true);
  //         } else {
  //           statusList?.add(false);
  //         }
  //       }
  //     }
  //     // unreadnotificationList = paymentPending.data!.unread;
  //     // readnotificationList = paymentPending.data!.read;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    statusList = widget.statusList1;
    // getData();
    return Scaffold(

      body: WillPopScope(

        onWillPop: () async{
          SharedPreferences pref = await SharedPreferences.getInstance();
          var residentId = pref.getString('tenant_id').toString();
          BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(residentId));
        //   NotificationModel paymentPending = await API.notificationList(residentId.toString());
        // setState(() {
        //   notificationData = paymentPending.data;
        //   // getData();
        //   if (notificationData != null) {
        //     for (var item in notificationData!) {
        //       if (item.status == 'Read') {
        //         return statusList?.add(true);
        //       } else {
        //         return statusList?.add(false);
        //       }
        //     }
        //   }
        //   // unreadnotificationList = paymentPending.data!.unread;
        //   // readnotificationList = paymentPending.data!.read;
        // });
          return true;
        },
        child: NetworkObserverBlock(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  color: Constant.bgLight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                var residentId = pref.getString('tenant_id').toString();
                                BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(residentId));
                                NotificationModel paymentPending = await API.notificationList(residentId.toString());
                                // setState(() {
                                //   notificationData = paymentPending.data;
                                //   // getData();
                                //   if (notificationData != null) {
                                //     for (var item in notificationData!) {
                                //       if (item.status == 'Read') {
                                //         return statusList?.add(true);
                                //       } else {
                                //         return statusList?.add(false);
                                //       }
                                //     }
                                //   }
                                //   // unreadnotificationList = paymentPending.data!.unread;
                                //   // readnotificationList = paymentPending.data!.read;
                                // });
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'Notification',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<NotificationListBloc, NotificationListState>(
                          builder: (context, state) {
                            if(state is NotificationListSuccess){
                              List<NotificationData>? list = state.notificationModel.data;

                              bool hasReadNotifications = list?.any((notification) => notification.status == 'Unread') ?? false;
                              // bool hasReadNotifications = statusList?.any((notification) => notification == false) ?? false;

                              return /*otherList.isNotEmpty*/hasReadNotifications ? InkWell(
                                onTap: () async {
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  var tenant_id = pref.getString('tenant_id').toString();
                                  API.clearNotificationdata(tenant_id).then((value) {
                                    if(value.success == 1){
                                      BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(tenant_id));
                                    }
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Mark all read',
                                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ) : SizedBox();
                            }
                            return SizedBox();
                            },
                        ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                    ),
                    child: BlocBuilder<NotificationListBloc, NotificationListState>(
                      builder: (context, state) {
                        if (state is NotificationListSuccess) {

                          // var statuslist = lis;
                          // var statusList = list?.map((e) => e.status).toList();
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.notificationModel.data?.length,
                            itemBuilder: (context, index) {
                              // bool isExpanded = expandedIndices.contains(index);
                              return InkWell(
                                onTap: () {

                                  API.readNotification(state.notificationModel.data![index].id.toString()).then((value) async {
                                    if (value['success'] == 1) {
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      var tenant_id = pref.getString('tenant_id').toString();
                                      if(statusList![index] == true){
                                        statusList?[index] = false;
                                      }else{
                                        statusList?[index] = true;
                                      }
                                      // isExpanded = true;
                                      setState(() {

                                      });
                                    //  BlocProvider.of<NotificationListBloc>(context).add(NotificationListRefreshEvent(tenant_id));
                                    }
                                  });
                                },
                                child: /*ExpansionTile(
                                  title: Text(state.notificationModel.data![index].title.toString()),
                                  // subtitle: const Text('Custom expansion arrow icon'),

                                  children: <Widget>[
                                    // Text(state.notificationModel.data![index].title.toString()),
                                    Text(state.notificationModel.data![index].discription.toString()),

                                    // ListTile(
                                    //     title: Text('This is tile number 2')),
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    setState(() {
                                      // _customTileExpanded = expanded;
                                    });
                                  },
                                ),*/
                                /*state.notificationModel.data![index].status == 'Read'
                                  ? */Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    decoration: BoxDecoration(color: const Color(0xffF9F9FF),
                                        borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                          child: statusList![index] == true ?  Icon(CupertinoIcons.envelope_open) : Icon(CupertinoIcons.envelope_fill),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*.75,
                                          child: statusList?[index] == true ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      state.notificationModel.data![index].title.toString(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  /*Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                    child: Text(state.notificationModel.data![index].title.toString(),
                                                              style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500,), overflow: TextOverflow.ellipsis,),


                                                  ),*/
                                                  Text(state.notificationModel.data![index].notificationDate.toString(), style: TextStyle(fontSize: 12, color: Colors.grey),)
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(state.notificationModel.data![index].discription.toString(),
                                                    style: TextStyle(color:Colors.grey),

                                                  ),
                                                ),
                                              ),

                                            ],
                                          ) : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                            child: Text(state.notificationModel.data![index].title.toString(),
                                                style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500)),


                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                  /*: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    decoration: BoxDecoration(color: const Color(0xffF9F9FF),
                                        borderRadius: BorderRadius.circular(16)),
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                          child: statusList![index] == true ? Icon(CupertinoIcons.envelope_fill) : Icon(CupertinoIcons.envelope_open),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*.7,
                                          child: statusList?[index] == true ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                child: Text(state.notificationModel.data![index].title.toString(),
                                                    style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500)),
                                              ),
                                            ],
                                          ) : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                child: Text(state.notificationModel.data![index].title.toString(),
                                                    style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(state.notificationModel.data![index].discription.toString(),
                                                    style: TextStyle(color:Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )*/






                                // Padding(
                                //     padding: const EdgeInsets.all(10),
                                //     child: Container(
                                //       decoration: BoxDecoration(color: const Color(0xffF9F9FF),
                                //           borderRadius: BorderRadius.circular(16)),
                                //       padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                //       child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           IntrinsicHeight(
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                //               child: Row(
                                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //
                                //                   Expanded(
                                //
                                //                     child: Text(state.notificationModel.data![index].title.toString(),
                                //                         style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w500)),
                                //
                                //                   ),
                                //
                                //                   /*Padding(
                                //                     padding: const EdgeInsets.only(right: 10),
                                //                     child: Container(
                                //                       width: 100,
                                //                       child: Text( state.notificationModel.data![index].updatedAt.toString(),
                                //
                                //                       ),
                                //                     ),
                                //                   ),*/
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //           Padding(
                                //             padding: const EdgeInsets.symmetric(horizontal: 10),
                                //             child: Container(
                                //               alignment: Alignment.topLeft,
                                //               child: Text(state.notificationModel.data![index].discription.toString(),
                                //                 style: TextStyle(color:Colors.grey),
                                //
                                //               ),
                                //             ),
                                //           ),
                                //
                                //         ],
                                //       ),
                                //     ),
                                // )
                              );
                            },
                          );
                        }
                        if (state is NotificationListError) {
                          return Center(child: Text(state.error));
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
