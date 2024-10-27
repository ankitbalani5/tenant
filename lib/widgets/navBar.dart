import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/explore.dart';
import 'package:roomertenant/screens/login.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/splash.dart';
import 'package:roomertenant/screens/userprofile.dart';

import '../screens/bill.dart';
import '../screens/internet_check.dart';
import '../screens/tenant_complain.dart';
import '../utils/common.dart';
import '../utils/utils.dart';

class NavBar extends StatefulWidget {
  static const id = 'NavBar';
  static List<Widget> Screens = [
    NewHomeApp(),
    ExploreScreen(false),
    BillPage(isHomeNavigation: true),
    Page2App(isHomeNavigation: true,)

  ];

  static GlobalKey getBottomNavigationBarKey() {
    return _NavBarState().getBottomNavigationBarKey;
  }
  // static const Color navIcon = ;
  
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  final GlobalKey bottomNavigationBarKey = GlobalKey();

  GlobalKey get getBottomNavigationBarKey => bottomNavigationBarKey;
  int currentTap = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = NewHomeApp();

  var currentTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        DateTime now = DateTime.now();
        if(currentTap != 0){
          currentTap = 0;
          Future.delayed(Duration(microseconds: 200)).then((value) {
            currentScreen = NavBar.Screens[0];
          });
          setState(() {

          });

          return Future.value(false);
        }else{
          Navigator.pop(context);
          exit(0);
        }
        },
      child: Scaffold(
        body: NetworkObserverBlock(
          child: PageStorage(
            bucket: bucket,
            child: currentScreen,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey,
                blurRadius: 1.5,
            )],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
            )
          ),
          child: BottomAppBar(
            key: bottomNavigationBarKey,
            height: 70,
            color: Colors.transparent,
            surfaceTintColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
              // height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: (){
                      setState(() {
                        currentScreen = NavBar.Screens[0];
                        currentTap = 0;
                      });
                    },
                    child: Container(
                      width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: currentTap == 0 ? Constant.bgTile : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SvgPicture.asset('assets/navbar/homeIcon.svg', color: currentTap == 0 ? Color(0xff001944) : Color(0xff717D96),),
                            // Text('Home', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: currentTap == 0 ? Color(0xff001944) : Color(0xff717D96),
                            Icon(Icons.home,  color: currentTap == 0 ? Color(0xff001944) : Color(0xff717D96),),
                          // SvgPicture.asset('assets/navbar/homeIcon.svg', height: 20, width: 20, color: currentTap == 1 ? Color(0xff001944) : Color(0xff717D96),),
                            Text('Home', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: currentTap == 0 ? Color(0xff001944) : Color(0xff717D96),
                            ),
                            )
                          ],
                        )
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: (){
                      setState(() {
                        currentScreen = NavBar.Screens[1];
                        currentTap = 1;
                      });
                    },
                    child: Container(
                      width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: currentTap == 1 ? Constant.bgTile : Colors.transparent,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/navbar/exploreIcon.svg', color: currentTap == 1 ? Color(0xff001944) : Color(0xff717D96),),
                            Text('Find my PG', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: currentTap == 1 ? Color(0xff001944) : Color(0xff717D96),),)
                          ],
                        )
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: (){
                      setState(() {
                        currentScreen = NavBar.Screens[2];
                        currentTap = 2;
                      });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BillPage()),
                      // );
                    },
                    child: Container(
                      width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: currentTap == 2 ? Constant.bgTile : Colors.transparent,
                        ),
                        child: InkWell(

                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/navbar/invoicesIcon.svg', color: currentTap == 2 ? Color(0xff001944) : Color(0xff717D96),),
                              Text('Receipts', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: currentTap == 2 ? Color(0xff001944) : Color(0xff717D96),),)
                            ],
                          ),
                        )
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: (){
                      setState(() {
                        currentScreen = NavBar.Screens[3];
                        currentTap = 3;
                      });
                    },
                    child: Container(
                        width: 80,
                      height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                      color: currentTap == 3 ? Constant.bgTile/*Color(0xffDDE9FE)*/ : Colors.transparent,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/navbar/complaintsIcon.svg', color: currentTap == 3 ? Color(0xff001944) : Color(0xff717D96),),
                            Text('Complaints', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: currentTap == 3 ? Color(0xff001944) : Color(0xff717D96),),)
                          ],
                        )
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
        /*bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
            currentIndex: selectedIndex,
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'explore',
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
              label: 'invoice',
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_alert),
              label: 'complaint',
              backgroundColor: Colors.white
          )
        ]),*/
      ),
    );
  }
}
