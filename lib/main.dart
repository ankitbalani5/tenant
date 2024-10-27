import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/api/providerfuction.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/amenities.dart';
import 'package:roomertenant/screens/bill.dart';
import 'package:roomertenant/screens/accomodation.dart';
import 'package:roomertenant/screens/bill_bloc/bill_bloc.dart';
import 'package:roomertenant/screens/chat.dart';
import 'package:roomertenant/screens/clearNotificationBloc/clear_notification_bloc.dart';
import 'package:roomertenant/screens/complain_bloc/complain_bloc.dart';
import 'package:roomertenant/screens/explore.dart';
import 'package:roomertenant/screens/explore_bloc/explore_bloc.dart';
import 'package:roomertenant/screens/getMessageChat/getmessagechat_bloc.dart';
import 'package:roomertenant/screens/get_wishlist_bloc/get_wishlist_bloc.dart';
import 'package:roomertenant/screens/home_bloc/home_bloc.dart';
import 'package:roomertenant/screens/interested.dart';
import 'package:roomertenant/screens/interested_bloc/interested_bloc.dart';
import 'package:roomertenant/screens/internetBloc/internet_bloc.dart';
import 'package:roomertenant/screens/login_bloc/login_bloc.dart';
import 'package:roomertenant/screens/logout_otp_tenant_bloc/logout_otp_tenant_bloc.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/no_login.dart';
import 'package:roomertenant/screens/notificationList/notification_list_bloc.dart';
import 'package:roomertenant/screens/requested_pg_bloc/requested_pg_bloc.dart';
import 'package:roomertenant/screens/review_bloc/review_bloc.dart';
import 'package:roomertenant/screens/sendMessageChat/sendmessagechat_bloc.dart';
import 'package:roomertenant/screens/splash.dart';
import 'package:roomertenant/screens/tenant_complain.dart';
import 'package:roomertenant/screens/next_due_date.dart';
import 'package:roomertenant/screens/due_rent.dart';
import 'package:flutter/material.dart';
import 'package:roomertenant/screens/login.dart';
import 'package:roomertenant/screens/tenant_rating/tenant_rating_bloc.dart';
import 'package:roomertenant/screens/terms_conditions.dart';
import 'package:roomertenant/screens/update_receipt_payment/update_receipt_payment_bloc.dart';
import 'package:roomertenant/screens/userprofile.dart';
import 'package:roomertenant/screens/visitor_list/exploreDetails.dart';
import 'package:roomertenant/screens/wishlist_bloc/wishlist_bloc.dart';
import 'package:roomertenant/utils/PushNotificationService.dart';
import 'package:roomertenant/widgets/navBar.dart';
import 'screens/Tenant_Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
/*Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
}*/

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> backgroundHandler(RemoteMessage message) async{
//   print(message.data.toString());
//   print(message.notification!.title);
// }

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Title: ${message.notification!.title}');
  print('Body: ${message.notification!.body}');
  print('Payload: ${message.data}');

  if (message.data['type'] == 'chat') {
    navigatorKey.currentState?.pushNamed(ChatScreen.id);
  }

}

dynamic isLogIn = false;
void main() async {
  BuildContext context;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await PushNotificationService().setupInteractedMessage();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
  ));


  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLogIn = prefs.getBool('isLoggedIn');
  String branch_id = await prefs.getString("branch_id").toString();
  // if (!(prefs.getString('email') == null)) {
  //   NewHomeApp.userValues =
  //       await API.user(prefs.getString('email').toString(), branch_id);
  // }
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
        BlocProvider<BillBloc>(create: (context) => BillBloc()),
        BlocProvider<ComplainBloc>(create: (context) => ComplainBloc()),
        BlocProvider<ExploreBloc>(create: (context) => ExploreBloc()),
        BlocProvider<InterestedBloc>(create: (context) => InterestedBloc()),
        BlocProvider<LogoutOtpTenantBloc>(create: (context) => LogoutOtpTenantBloc()),
        BlocProvider<UpdateReceiptPaymentBloc>(create: (context) => UpdateReceiptPaymentBloc()),
        BlocProvider<RequestedPgBloc>(create: (context) => RequestedPgBloc()),
        BlocProvider<WishlistBloc>(create: (context) => WishlistBloc()),
        BlocProvider<GetWishlistBloc>(create: (context) => GetWishlistBloc()),
        BlocProvider<SendmessagechatBloc>(create: (context) => SendmessagechatBloc()),
        BlocProvider<GetmessagechatBloc>(create: (context) => GetmessagechatBloc()),
        BlocProvider<ClearNotificationBloc>(create: (context) => ClearNotificationBloc()),
        BlocProvider<NotificationListBloc>(create: (context) => NotificationListBloc()),
        BlocProvider<InternetBlock>(create: (context) => InternetBlock()),
        BlocProvider<ReviewBloc>(create: (context) => ReviewBloc()),
        BlocProvider<TenantRatingBloc>(create: (context) => TenantRatingBloc()),
      ],
      child: const MyApp()),
     /* MultiProvider(
        providers: [
           ChangeNotifierProvider(create: (_) => APIprovider()),
    ],
    child: const MyApp(),
  )*/);
  String? token = await FirebaseMessaging.instance.getToken();
  prefs.setString('token', token.toString());
  print("Token : " + token.toString());
  await Permission.notification.isDenied.then(
    (bool value) {
      if (value) {
        print("Permission");
        Permission.notification.request();
      } else {
        print("No Permission");
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        theme: ThemeData(
          //fontFamily: 'Poppins'
            textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
                ),
          scaffoldBackgroundColor: Colors.white,
            ),

        /*ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Constant.bgLight,
            primaryColorDark: SplashScreen.bgColor,
            textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: SplashScreen.bgColor,
                fontSize: 16,
              ),
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            )),*/


        initialRoute: SplashScreen.id,
        routes: {
          ExploreScreen.id: (context) => ExploreScreen(false),
          ChatScreen.id: (context) => ChatScreen('','','', ''),
          NoLogin.id: (context) => NoLogin(),

          Interested.id: (context) => Interested(),
          // ExploreDetails.id: (context) => ExploreDetails(data: data[0],),
          NavBar.id: (context) => NavBar(),
          SplashScreen.id: (context) => SplashScreen(),
          Login.id: (context) => Login(),
          // HomeApp.id: (context) => HomeApp(),
          NewHomeApp.id: (context) => NewHomeApp(),
          Page1App.id: (context) => Page1App(),
          Page2App.id: (context) => Page2App(isHomeNavigation: true,),
          QrcodePage.id: (context) => QrcodePage(),
          DueRent.id: (context) => DueRent(),
          BillPage.id: (context) => BillPage(isHomeNavigation: true,),
          AccommodationPage.id: (context) => AccommodationPage(),
          AmenitiesPage.id: (context) => AmenitiesPage(),
          UserProfileApp.id: (context) => UserProfileApp(),
          TermsConditions.id: (context) => TermsConditions(),
        },
      );
    // }

  }
}
