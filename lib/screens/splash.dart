import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomertenant/screens/explore.dart';
import 'package:roomertenant/screens/pg_requested.dart';
import 'package:roomertenant/screens/visitor_list/exploreDetails.dart';
import 'package:roomertenant/widgets/navBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';
import 'explore_bloc/explore_bloc.dart';
import 'internet_check.dart';
import 'login.dart';
import 'newhome.dart';
import 'no_login.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash";
  static Color bgColor = Color(0xff001944);
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogIn = false;
  String? branch_id ;
  String? mobile_no ;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: '',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    print(":::::::::::::::::::::::::::");
    SharedPreferences pref= await SharedPreferences.getInstance();
    var version = 'v.${_packageInfo.version}(${_packageInfo.buildNumber})';
    pref.setString('version',version);
    print(_packageInfo.version);
  }

  @override
  void initState() {
    _initPackageInfo();
    login();



    Timer(const Duration(seconds: 2),() {
      Navigator.pushReplacementNamed(context, isLogIn == false || isLogIn == null
          || branch_id! == '0' ?  NoLogin.id/*ExploreScreen.id*/ : NavBar.id );
    },);

    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('User tapped on the notification from the background state! $message');

      SharedPreferences pref = await SharedPreferences.getInstance();
      if (message.notification?.title == 'Vishal text you') {
        int _yourId = int.tryParse(message.data['id']) ?? 0;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PgRequested()));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print("MessageOpened"+message.toString());
        print("body"+message.notification!.body.toString());
        print("type"+message.data['type'].toString());
        print("id"+message.data['id'].toString());

        if (message.data['type'] == 'chat') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen('name', 'image', '6', '')));
          // Navigator.pushNamed(context, '/notification', arguments: ChatArguments(notification);
        }

        Future<void> backgroundHandler(RemoteMessage message) async {
          print(message.data.toString());
          print(message.notification!.title);

          FirebaseMessaging.onMessageOpenedApp.listen(
                (RemoteMessage message) {
              print("MessageOpened"+message.toString());
              print("body"+message.notification!.body.toString());
              print("type"+message.data['type'].toString());
              print("id"+message.data['id'].toString());

              if (message.data['type'] == 'chat') {
                // navigatorKey.currentState?.pushNamed(ChatScreen.id);
                Navigator.push(context!, MaterialPageRoute(builder: (context) => ChatScreen('name', 'image', '6', '')));
                // Navigator.pushNamed(context, '/notification', arguments: ChatArguments(notification);
              }


              // notificationRedirect(message.data[keyTypeValue], message.data[keyType]);
            },
          );

          if (message.data['type'] == 'chat') {
            // Navigator.pushNamed(context, routeName);
            Navigator.push(context!, MaterialPageRoute(builder: (context) => ChatScreen('name', 'image', '6', '')));
            // navigatorKey.currentState?.pushNamed(ChatScreen.id);
            // Navigator.pushNamed(context, '/notification', arguments: ChatArguments(notification);
          }

          // // Check if the notification message contains data to determine where to navigate
          // if (message.data.containsKey('id')) {
          //   String screenName = message.data['id'];
          //
          //   // Navigate to the desired screen based on the data received
          //   if (screenName == '123456') {
          //     navigatorKey.currentState?.pushNamed(ChatScreen.id);
          //   } else {
          //     // Handle other cases if needed
          //   }
          // }
        }


        // notificationRedirect(message.data[keyTypeValue], message.data[keyType]);
      },
    );

  }

  login() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogIn = await prefs.getBool('isLoggedIn') ?? false;
    branch_id = await prefs.getString('branch_id')?? '0';
    mobile_no = await prefs.getString('mobile_no');

    BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white,));
    return Scaffold(
      body: Stack(
        children: [
      Positioned(
        child: Center(
          child: Image.asset('assets/splash/Logo.png')
        ),
      ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('v.${_packageInfo.version}(${_packageInfo.buildNumber})', style: const TextStyle(
                    color: Color(0xff6F7894), fontWeight: FontWeight.w500,
                    fontSize: 16),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
