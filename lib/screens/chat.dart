import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/pg_requested.dart';
import 'package:roomertenant/screens/sendMessageChat/sendmessagechat_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/getMessageChatModel.dart';
import 'getMessageChat/getmessagechat_bloc.dart';
import 'internet_check.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat';
  final String name;
  final String image;
  final String branch_id;
  final String contact;
  const ChatScreen(this.name, this.image, this.branch_id, this.contact);

  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  var _messageController = TextEditingController();
  String tenant_name ='';
  String? formattedDate;
  late ScrollController _scrollController;
  var login_id;
  var dataList;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FocusNode focusNode = FocusNode();
  String searchQuery = "";


  @override
  void dispose() {
    _messageController.dispose();

    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    dataList.clear();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom, fetch more data for pagination
      // Implement your pagination logic here
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    _scrollController = ScrollController()..addListener(_scrollListener);

    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token: $token");
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a new message while app is in the foreground! $message');
      BlocProvider.of<GetmessagechatBloc>(context).add(GetmessagechatRefreshEvent(login_id.toString(), widget.branch_id));
      // Handle the notification message here
      // For example, show a dialog or update UI
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('User tapped on the notification from the background state! $message');

      SharedPreferences pref = await SharedPreferences.getInstance();
      var isLogin = pref.getBool('isLoggedIn');
      // if(isLogin == true)
      // {
      if (message.data['badge'] == 1) {
        int _yourId = int.tryParse(message.data['id']) ?? 0;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PgRequested()));
      }
      // }else{
      //   print('please Login first');
      // }
      // Navigator.push(context, MaterialPageRoute(builder: (context) => PgRequested()));
      // Handle the notification message here
      // For example, navigate to a specific screen
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Handle the notification message here when the app is in background
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    login_id = pref.getString('login_id');
    tenant_name = pref.getString('name').toString();
    BlocProvider.of<GetmessagechatBloc>(context).add(GetmessagechatRefreshEvent(login_id.toString(), widget.branch_id));
    // now = new DateTime.now();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print('today date: $formattedDate');
  }

  _launchCaller(String contact) async {
    final url = "tel:$contact";
    try{
      await launch(url);
    } catch(e) {
      throw e.toString();
    }
  }


  final List<String> _messages = [];
  List<Map<String, dynamic>> messages = [
    {
      'message': 'Hii',
      'date': '6/5/2024',
      'time': '10.05 am',
      'isMe': true,
      'isSelected': false,
    },
    {
      'message': 'Hey',
      'date': '6/5/2024',
      'time': '10.05 am',
      'isMe': false,
      'isSelected': false,
    },
    {
      'message': 'How are you?',
      'date': '6/5/2024',
      'time': '10.06 am',
      'isMe': true,
      'isSelected': false,
    },
    {
      'message': 'I am good',
      'date': '6/5/2024',
      'time': '10.07 am',
      'isMe': false,
      'isSelected': false,
    },
    {
      'message': 'What you doing right now',
      'date': '6/5/2024',
      'time': '10.07 am',
      'isMe': true,
      'isSelected': false,
    },
    {
      'message': 'Nothing',
      'date': '6/5/2024',
      'time': '10.08 am',
      'isMe': false,
      'isSelected': false,
    },
    {
      'message': "I like your PG's review please contact to me",
      'date': '6/5/2024',
      'time': '10.07 am',
      'isMe': true,
      'isSelected': false,
    },
  ];

  void addMessage(String message, ){
    setState(() {
      messages.add({
        'message': message,
        'date': '6/5/2024',
        'time': '10:10 am',
        'isMe': true,
        'isSelected': false,
      });
      // _messages.insert(0, message);
      _messageController.clear();
    });
  }


  List<int> _selectedIndexes = [];

  void toggleMessageSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void deleteSelectedMessages() {
    setState(() {
      _selectedIndexes.sort((a, b) => b.compareTo(a)); // Sort in descending order
      for (int index in _selectedIndexes) {
        messages.removeAt(index);
      }
      _selectedIndexes.clear();
    });
  }

  /*String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }*/

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  Widget _buildChatGroup(String date, List<ChatData> messages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateSeparator(context, _formatDate(DateFormat('yyyy-MM-dd', 'en_US').parse(
            date.toString()))),
        // ListView.builder(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: messages.length,
        //   reverse: true,
        //   itemBuilder: (context, index) {
        //     var message = messages[index];
        //     bool isFirstMessageFromUser = index == messages.length - 1 ||
        //         message.userType != messages[index + 1].userType;
        //     bool containsSearchQuery = message.msg!.toLowerCase().contains(searchQuery);
        //
        //     return Container(
        //       color: Colors.white,
        //       child: Row(
        //         mainAxisAlignment: message.userType == 'Tenant'
        //             ? MainAxisAlignment.end
        //             : MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           // Show avatar for the first message from the user
        //           if (message.userType != 'Tenant')
        //             isFirstMessageFromUser
        //                 ? Padding(
        //               padding: const EdgeInsets.only(top: 5),
        //               child: CircleAvatar(
        //                 radius: 18,
        //                 backgroundColor: Color(0xffF4F4F4),
        //                 child: SvgPicture.asset('assets/user.svg'),
        //               ),
        //             )
        //                 : SizedBox(width: 35,),
        //           Flexible(
        //             child: ConstrainedBox(
        //               constraints: const BoxConstraints(
        //                 maxWidth: 200,
        //                 minWidth: 50,
        //               ),
        //               child: Container(
        //                 padding: const EdgeInsets.symmetric(
        //                   vertical: 8,
        //                   horizontal: 14,
        //                 ),
        //                 margin: const EdgeInsets.symmetric(
        //                   vertical: 4,
        //                   horizontal: 4,
        //                 ),
        //                 // decoration: BoxDecoration(
        //                 //   borderRadius: message.userType == 'Tenant'
        //                 //       ? const BorderRadius.only(
        //                 //     topLeft: Radius.circular(12),
        //                 //     topRight: Radius.circular(12),
        //                 //     bottomLeft: Radius.circular(12),
        //                 //     bottomRight: Radius.circular(12),
        //                 //   )
        //                 //       : const BorderRadius.only(
        //                 //     topRight: Radius.circular(12),
        //                 //     topLeft: Radius.circular(12),
        //                 //     bottomLeft: Radius.circular(12),
        //                 //     bottomRight: Radius.circular(12),
        //                 //   ),
        //                 //   color: message.userType == 'Tenant'
        //                 //       ? Color(0xffEEEEFF)
        //                 //       : Color(0xffF4F4F4),
        //                 // ),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(12),
        //                   color: searchQuery.isNotEmpty ? containsSearchQuery ? Colors.yellow : (message.userType == 'Tenant' ? Color(0xffEEEEFF) : Color(0xffF4F4F4)) : (message.userType == 'Tenant' ? Color(0xffEEEEFF) : Color(0xffF4F4F4)),
        //                 ),
        //                 child: Column(
        //                   crossAxisAlignment: message.userType == 'Tenant'
        //                       ? CrossAxisAlignment.end
        //                       : CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       message.msg.toString(),
        //                       style: TextStyle(
        //                           color: Color(0xff464647),
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.w400),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //           // Show avatar for the first message from the tenant
        //           if (message.userType == 'Tenant')
        //             isFirstMessageFromUser
        //                 ? Padding(
        //               padding: const EdgeInsets.only(top: 5),
        //               child: CircleAvatar(
        //                 backgroundColor: Color(0xffEEEEFF),
        //                 radius: 18,
        //                 child: SvgPicture.asset('assets/user.svg'),
        //               ),
        //             )
        //                 : SizedBox(width: 35,),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: messages.length,
          reverse: true,
          itemBuilder: (context, index) {
            var message = messages[index];
            bool isFirstMessageFromUser = index == messages.length - 1 ||
                message.userType != messages[index + 1].userType;
            bool containsSearchQuery = message.msg!.toLowerCase().contains(searchQuery);

            return Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: message.userType == 'Tenant'
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show avatar for the first message from the user
                  if (message.userType != 'Tenant')
                    isFirstMessageFromUser
                        ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xffF4F4F4),
                        child: SvgPicture.asset('assets/user.svg'),
                      ),
                    )
                        : SizedBox(width: 35),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 200,
                        minWidth: 50,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 14,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: message.userType == 'Tenant'
                              ? Color(0xffEEEEFF)
                              : Color(0xffF4F4F4),
                        ),
                        child: Column(
                          crossAxisAlignment: message.userType == 'Tenant'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            _highlightSearchTerm(message.msg.toString(), searchQuery),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Show avatar for the first message from the tenant
                  if (message.userType == 'Tenant')
                    isFirstMessageFromUser
                        ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CircleAvatar(
                        backgroundColor: Color(0xffEEEEFF),
                        radius: 18,
                        child: SvgPicture.asset('assets/user.svg'),
                      ),
                    )
                        : SizedBox(width: 35),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _highlightSearchTerm(String text, String searchTerm) {
    if (searchTerm.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: Color(0xff464647),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    List<TextSpan> spans = [];
    int start = 0;
    int index = text.toLowerCase().indexOf(searchTerm);

    while (index != -1) {
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: TextStyle(
              color: Color(0xff464647),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + searchTerm.length),
          style: TextStyle(
            backgroundColor: Colors.yellow,
            color: Color(0xff464647),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
      start = index + searchTerm.length;
      index = text.toLowerCase().indexOf(searchTerm, start);
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(
            color: Color(0xff464647),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _dateSeparator(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,

                  ),
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool search = false;
  var _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    print('branchName: ${widget.name} branchId: ${widget.branch_id}');
    return Scaffold(
        body: SafeArea(
            child: NetworkObserverBlock(
              child: InkWell(
                onTap: (){
                  search = false;
                  setState(() {

                  });
                },
                child: BlocBuilder<GetmessagechatBloc, GetmessagechatState>(
                  builder: (context, state) {
                    if(state is GetmessagechatSuccess){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height ,
                        child: Stack(
                          children: [

                            Container(
                              color: const Color(0xff8787FF),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.17,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                                child: search == true
                                    ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 20,
                                    margin: const EdgeInsets.only( bottom: 65),
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Set the background color to white
                                      borderRadius: BorderRadius.circular(20), // Set circular border radius
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: CupertinoSearchTextField(
                                      focusNode: focusNode,
                                      controller: _searchController,
                                      autofocus: false,
                                      onChanged: (value){
                                        var result = state.getMessageChatModel.data!.where((e) => e.msg!.toLowerCase().toString().contains(value.toLowerCase().toString())).toList();

                                        setState(() {
                                          searchQuery = value.toLowerCase();
                                          print('result----$result');
                                        });
                                      },
                                    ),
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),


                                        CircleAvatar(
                                          radius: 20,
                                          // backgroundImage: NetworkImage(widget.image.toString()),
                                          backgroundImage: widget.image.isNotEmpty ? NetworkImage(widget.image) : null,
                                          child: widget.image.isEmpty ? Text(
                                            widget.name.toString().substring(0, 1),
                                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                          ) : null,
                                          // child: Image.asset('assets/selection.png'),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            height: 50,
                                            width: 180,
                                            //width: MediaQuery.of(context).size.width * 0.38,
                                            child: Center(child:
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(widget.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 18),)),
                                            )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        widget.contact.isNotEmpty
                                            ? IconButton(onPressed: (){
                                          _launchCaller(widget.contact.toString());
                                        }, icon: const Icon(Icons.call_outlined,color: Colors.white,))
                                            : const SizedBox(),
                                        IconButton(onPressed: (){
                                          search = true;
                                          // focusNode.canRequestFocus;
                                          focusNode.requestFocus();
                                          setState(() {

                                          });
                                        }, icon: Icon(Icons.search,color: Colors.white,)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.08),
                              child: Container(
                                padding: const EdgeInsets.only(top: 14,right: 10,left: 10),
                                width: MediaQuery.of(context).size.width ,
                                height: MediaQuery.of(context).size.height* 0.87,
                                decoration: BoxDecoration(color: Colors.white,
                                    borderRadius: BorderRadius.circular(32)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: BlocBuilder<GetmessagechatBloc, GetmessagechatState>(
                                        builder: (context, state) {
                                          if(state is GetmessagechatLoading){
                                            return const Center(child: CircularProgressIndicator(color: Constant.bgLight,),);
                                          }
                                          if(state is GetmessagechatSuccess){
                                            dataList = state.getMessageChatModel.data!;
                                            Map<String, List<ChatData>> groupedMessages = {};
                                            state.getMessageChatModel.data!.forEach((message) {
                                              if (!groupedMessages.containsKey(message.postDate)) {
                                                groupedMessages[message.postDate.toString()] = [];
                                              }
                                              groupedMessages[message.postDate]!.add(message);
                                            });

                                            // Create a list of chat groups by date
                                            List<Widget> chatGroups = groupedMessages.entries
                                                .map((entry) => _buildChatGroup(entry.key, entry.value))
                                                .toList();
                                            return ListView(
                                              reverse: true,
                                              children: chatGroups,
                                            );
                                          }
                                          if(state is GetmessagechatError){
                                            return Center(child: Text(state.error));
                                          }
                                          return SizedBox();
                                        },
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only( bottom: 10,top: 10,left: 10,right: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: TextField(
                                                controller: _messageController,
                                                textCapitalization: TextCapitalization.sentences,
                                                autocorrect: true,
                                                enableSuggestions: true,
                                                maxLines: null,
                                                style: const TextStyle(fontSize: 12), // Reduce font size
                                                decoration: InputDecoration(
                                                  hintText: 'Message',
                                                  hintStyle: const TextStyle(color: Color(0xff464647), fontSize: 12, fontWeight: FontWeight.w400),
                                                  filled: true,
                                                  fillColor: const Color(0xffE9E9FF),
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                                                  enabledBorder: OutlineInputBorder(
                                                    gapPadding: 0,
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.circular(32),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    gapPadding: 0,
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.circular(32),
                                                  ),
                                                  // suffixIcon:
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(30),
                                            onTap: () async {
                                              if(_messageController.text.trim().isNotEmpty) {
                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                login_id = pref.getString('login_id').toString();
                                                BlocProvider.of<SendmessagechatBloc>(context).add(SendMessageChatRefresh(login_id, widget.branch_id.toString(), _messageController.text.toString(), tenant_name));
                                                Future.delayed(const Duration(seconds: 1), () => BlocProvider.of<GetmessagechatBloc>(context).add(GetmessagechatRefreshEvent(login_id.toString(), widget.branch_id)));


                                                /*addMessage(
                                                      _messageController.text.toString());*/
                                                _messageController.clear();
                                              }
                                            },

                                            child: Container(
                                              // height: 40,
                                                padding: EdgeInsets.symmetric(horizontal: 22,vertical: 12),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(32),
                                                    color: Color(0xff6151FF)
                                                ),
                                                child: Text("SEND",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white),)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  return SizedBox();
                    },
                ),
              ),
            ),
            ),
        );
    }
}