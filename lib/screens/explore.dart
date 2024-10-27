import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/ExploreModel.dart';
import 'package:roomertenant/model/filter_model.dart';
import 'package:roomertenant/screens/chat.dart';
import 'package:roomertenant/screens/explore_bloc/explore_bloc.dart';
import 'package:roomertenant/screens/pg_requested.dart';
import 'package:roomertenant/screens/userprofile.dart';
import 'package:roomertenant/screens/visitor_list/exploreDetails.dart';
import 'package:roomertenant/screens/wishlist_bloc/wishlist_bloc.dart';
import 'package:roomertenant/widgets/appbartitle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import '../model/gender_model.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'google_map.dart';
import 'internet_check.dart';

const List<String> list = <String>['Jaipur'];

String filterBy = 'City';

enum FilterItem { ascending, descending }



class ExploreScreen extends StatefulWidget {
  static const id = 'explore';

  final bool back;
  const ExploreScreen(this.back);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class Address {
  final String name;
  final double latitude;
  final double longitude;

  Address({required this.name, required this.latitude, required this.longitude});
}

class _ExploreScreenState extends State<ExploreScreen> {
  var apply = false;
  bool login = false;
  String dropdownValue = list[0];
  int currentIndexPage = 0;
  final CarouselController _controller = CarouselController();
  List<FilterModel> filterCityList=[];
  List<GenderModel> filterGenderList=[];

  bool sorting = false;
  bool isBoys = false;
  bool isGirls = false;
  bool isOthers = false;
  bool like = false;

  final FocusNode _focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  final TextEditingController _shareLinkcontroller = TextEditingController();
  bool isSearchStarted = false;
  List<Property> searchLead = [];
  List<Property> sortedLead = [];
  FilterItem? selectedMenu;
  PackageInfo? packageInfo;
  String? email;
  String? mobile_no;
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesLists = [];
  String _identifier = '';
  String? _currentAddress;
  Position? _currentPosition;
  var address;
  var wifiIP;

  logIn() async {
    packageInfo= await PackageInfo.fromPlatform();
    // packageName = packageInfo.packageName
    print(packageInfo!.packageName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = await prefs.getBool('isLoggedIn') ?? false;
    email = await prefs.getString('email');
    mobile_no = await prefs.getString('mobile_no');
  }

  @override
  void initState() {
    _determinePosition();

    fetchData();
    Future.delayed(Duration.zero, () {

      BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
    },);
    logIn();
    super.initState();
    searchController.addListener(() {
      onChange();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('User tapped on the notification from the background state! $message');

      SharedPreferences pref = await SharedPreferences.getInstance();
      if (message.notification?.title == 'Vishal text you') {
        int _yourId = int.tryParse(message.data['id']) ?? 0;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PgRequested()));
      }
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('::::::::::::::::::::::::::::::$position');
    // setState(() async {
      _currentPosition = position;

      List<Placemark> newPlace = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);
      Placemark placeMark = newPlace[0];
      String name = placeMark.name.toString();
      String subLocality = placeMark.subLocality.toString();
      String locality = placeMark.locality.toString();
      String administrativeArea = placeMark.administrativeArea.toString();
      String postalCode = placeMark.postalCode.toString();
      String country = placeMark.country.toString();
      address = "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
    //   }
    // );

    }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text('Location Permission'),
      //         content: Text('Location access is permanently denied. Please enable location access in the settings.'),
      //         actions: <Widget>[
      //           TextButton(
      //             child: Text('Open Settings'),
      //             onPressed: () async {
      //               Navigator.of(context).pop();
      //               await openAppSettings();
      //             },
      //           ),
      //         ],
      //       );});
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location services are disabled. Please enable the services')));
      // return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // permission = await Geolocator.requestPermission();
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permission'),
              content: Text('Location access is permanently denied. Please enable location access in the settings.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Open Settings'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await openAppSettings();
                  },
                ),
              ],
            );});
      // openAppSettings();
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  fetchData() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
    });
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      /*setState(() =>*/ _currentPosition = position/*)*/;
    }).catchError((e) {
      debugPrint(e);
    });
    List<Placemark> newPlace = await placemarkFromCoordinates(_currentPosition!.latitude , _currentPosition!.longitude);
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";

    wifiIP = await Ipify.ipv4();
    print('Ip Address: ${wifiIP}');
  }

  Future onRefresh() async{
    BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
  }

  // Function to format rent range
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  List<Property> leadListing = [];
  List<Property> leadListingTemp = [];
  List<String?> cityNames = [];
  List<String?> genderNames = [];
  bool citySelect = false;
  var controller = TextEditingController();

  String? selectedCity = 'All Data';

  String _searchedAddress = '';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return _nearbyAddresses.map((address) => address.toString()).join('\n');
  }


  List<Property> _nearbyAddresses = [];

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }
  double _latitude = 0.0;
  double _longitude =0.0;


  void _searchLocation(String location, List<Property> address) async {
    try {
      List<Property> nearbyAddresses = [];
      List<Location> locations = await locationFromAddress(location);
      if (locations != null && locations.isNotEmpty) {
        setState(() {
          _latitude = locations[0].latitude;
          _longitude = locations[0].longitude;
          print('$location --- ${_latitude}');
          print('$location --- ${_longitude}');
        });

        // Calculate the distance between the searched location and each address
        for (Property property in address) {
          if (property.latitude!.isNotEmpty && property.longitude!.isNotEmpty) {
            try {
              double lat = double.parse(property.latitude!);
              double lng = double.parse(property.longitude!);
              double distance = calculateDistance(_latitude, _longitude, lat, lng);
              if (distance <= 5.0) { // Filter addresses within a 5 km radius
                nearbyAddresses.add(property);
              }
            } catch (e) {
              // Handle case where parsing fails
              print('Error parsing latitude or longitude: $e');
            }
          }
        }

        // Update the UI with nearby addresses
        setState(() {
          _searchedAddress = searchController.text;
          _nearbyAddresses = nearbyAddresses;
          print('nearby addresses: $_nearbyAddresses');
        });
      } else {
        setState(() {
          // Handle case when location is not found
        });
      }
    } catch (e) {
      setState(() {
        // Handle error
      });
      print('Error: $e');
    }
  }

  void onChange() {
    if(_sessionToken == null){
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion (searchController.text);
  }

  // void getSuggestion(String input) async{
  //   String kPLACES_API_KEY = 'AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c';
  //   String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  //   String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
  //
  //   var response = await http.get(Uri.parse(request));
  //   var data = response.body.toString();
  //
  //   print('data');
  //   print(data);
  //   if(response.statusCode == 200){
  //     setState(() {
  //       _placesLists = jsonDecode(response.body.toString())['predictions'];
  //     });
  //   }else{
  //     throw Exception('Failed to load data');
  //   }
  // }

  void getSuggestion(String input) async {

    // Check if the input length is at least 3 characters
    if (input.length < 3) {
      // Clear the suggestions list if input length is less than 3
      setState(() {
        _placesLists = [];
      });
      return; // Exit the function
    }

    // String kPLACES_API_KEY = 'AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c'; // Replace with your API key
    // String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // // String country = 'country=in'; // Country code for India
    // // String request = '$baseURL?input=$input&$country&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    // String country = 'country:IN'; // Country code for India
    // String request = '$baseURL?input=$input&components=$country&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    //
    //
    // var response = await http.get(Uri.parse(request));
    // var data = response.body.toString();
    //
    // print('data');
    // print(data);
    // if (response.statusCode == 200) {
    //   setState(() {
    //     _placesLists = jsonDecode(response.body.toString())['predictions'];
    //   });
    // } else {
    //   throw Exception('Failed to load data');
    // }

    /*String kPLACES_API_KEY = 'AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c'; // Replace with your API key
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String country = 'country:IN'; // Country code for India
    String types = '(regions)';
    String request =
        '$baseURL?input=$input&components=$country&types=$types&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    print(data);
    if (response.statusCode == 200) {
      setState(() {
        _placesLists = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }*/

    String kPLACES_API_KEY = 'AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c'; // Replace with your API key
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String country = 'country:IN'; // Country code for India
    String types = '(regions)';
    String sessionToken = 'Your_Session_Token_Here'; // Replace with your session token
    String request =
        '$baseURL?input=$input&components=$country&types=$types&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    print(data);
    if (response.statusCode == 200) {
      // Parse the JSON response
      var decodedData = jsonDecode(response.body);

      // Extract the predictions array from the response
      List<dynamic> predictions = decodedData['predictions'];

      // Filter the predictions to prioritize current state on top
      List<dynamic> currentStateResults = [];
      List<dynamic> otherResults = [];

      predictions.forEach((prediction) {
        // Check if the prediction's description contains the current state
        if (prediction['description'].toLowerCase().contains('your_current_state_name')) {
          currentStateResults.add(prediction);
        } else {
          otherResults.add(prediction);
        }
      });

      // Combine the filtered results with current state on top
      List<dynamic> filteredResults = [...currentStateResults, ...otherResults];

      setState(() {
        _placesLists = filteredResults;
      });
    } else {
      throw Exception('Failed to load data');
    }



  }


  bool listShow = false;
  // Define a FocusNode for the TextFormField
  final FocusNode _searchFocusNode = FocusNode();

  // Flag to track if TextFormField is out of focus
  bool _isOutOfFocus = false;
  // GestureDetector onTap callback to detect taps outside of the TextFormField
  void _handleTapOutside() {
    _isOutOfFocus = true;
    setState(() {

    });
    // Check if the TextFormField has focus
    if (_searchFocusNode.hasFocus) {
      // TextFormField has focus, set the flag to true
      setState(() {
        _isOutOfFocus = true;
      });
      // Unfocus the TextFormField
      _searchFocusNode.unfocus();
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  List items = ['one', 'two'];

  // void SearchBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(height: 50),
  //               Container(
  //                 margin: const EdgeInsets.all(10),
  //                 height: 40,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 child: TextFormField(
  //                   controller: searchController,
  //                   focusNode: _searchFocusNode,
  //                   autofocus: false,
  //                   decoration: InputDecoration(
  //                     border: InputBorder.none,
  //                     prefixIcon: Icon(Icons.search),
  //                     hintText: 'Search by City/PG Name/Locality',
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                     hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 14, fontWeight: FontWeight.w400),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 // height: 150, // Set a specific height for the container holding the ListView
  //                 child: ListView(
  //                   scrollDirection: Axis.horizontal,
  //                   children: [
  //                     Container(
  //                       width: 100,
  //                       child: DropdownSearch<String>(
  //                         popupProps: PopupProps.menu(
  //                           showSelectedItems: true,
  //                           disabledItemFn: (String s) => s.startsWith('I'),
  //                         ),
  //                         items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                         dropdownDecoratorProps: DropDownDecoratorProps(
  //                           dropdownSearchDecoration: InputDecoration(
  //                             labelText: "Menu mode",
  //                             hintText: "country in menu mode",
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         onChanged: print,
  //                         selectedItem: "Brazil",
  //                       ),
  //                     ),
  //                     SizedBox(width: 10),
  //                     Container(
  //                       width: 100,
  //                       child: DropdownSearch<String>(
  //                         items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                         dropdownDecoratorProps: DropDownDecoratorProps(
  //                           dropdownSearchDecoration: InputDecoration(
  //                             labelText: "Menu mode",
  //                             hintText: "country in menu mode",
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         onChanged: print,
  //                         selectedItem: "Brazil",
  //                       ),
  //                     ),
  //                     SizedBox(width: 10),
  //                     Container(
  //                       width: 100,
  //                       child: DropdownSearch<String>(
  //                         items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                         dropdownDecoratorProps: DropDownDecoratorProps(
  //                           dropdownSearchDecoration: InputDecoration(
  //                             labelText: "Menu mode",
  //                             hintText: "country in menu mode",
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         onChanged: print,
  //                         selectedItem: "Brazil",
  //                       ),
  //                     ),
  //                     SizedBox(width: 10),
  //                     Container(
  //                       width: 100,
  //                       child: DropdownSearch<String>(
  //                         items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                         dropdownDecoratorProps: DropDownDecoratorProps(
  //                           dropdownSearchDecoration: InputDecoration(
  //                             labelText: "Menu mode",
  //                             hintText: "country in menu mode",
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         onChanged: print,
  //                         selectedItem: "Brazil",
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


  // void SearchBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     builder: (context) {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min, // Make sure the column takes up the minimum space needed
  //         children: [
  //           SizedBox(height: 50),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //             child: Container(
  //               margin: const EdgeInsets.all(10),
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               child: TextFormField(
  //                 controller: searchController,
  //                 focusNode: _searchFocusNode,
  //                 autofocus: false,
  //                 decoration: InputDecoration(
  //                   border: InputBorder.none,
  //                   prefixIcon: Icon(Icons.search),
  //                   hintText: ' Search by City/PG Name/Locality',
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                   hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 14, fontWeight: FontWeight.w400),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //             child: Container(
  //               height: 150, // Set a specific height for the container holding the ListView
  //               child: ListView(
  //                 scrollDirection: Axis.horizontal,
  //                 children: [
  //                   Container(
  //                     width: 100,
  //                     child: DropdownSearch<String>(
  //                       popupProps: PopupProps.menu(
  //                         showSelectedItems: true,
  //                         disabledItemFn: (String s) => s.startsWith('I'),
  //                       ),
  //                       items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                       dropdownDecoratorProps: DropDownDecoratorProps(
  //                         dropdownSearchDecoration: InputDecoration(
  //                           labelText: "Menu mode",
  //                           hintText: "country in menu mode",
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       onChanged: print,
  //                       selectedItem: "Brazil",
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Container(
  //                     width: 100,
  //                     child: DropdownSearch<String>(
  //                       items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                       dropdownDecoratorProps: DropDownDecoratorProps(
  //                         dropdownSearchDecoration: InputDecoration(
  //                           labelText: "Menu mode",
  //                           hintText: "country in menu mode",
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       onChanged: print,
  //                       selectedItem: "Brazil",
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Container(
  //                     width: 100,
  //                     child: DropdownSearch<String>(
  //                       items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                       dropdownDecoratorProps: DropDownDecoratorProps(
  //                         dropdownSearchDecoration: InputDecoration(
  //                           labelText: "Menu mode",
  //                           hintText: "country in menu mode",
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       onChanged: print,
  //                       selectedItem: "Brazil",
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Container(
  //                     width: 100,
  //                     child: DropdownSearch<String>(
  //                       items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
  //                       dropdownDecoratorProps: DropDownDecoratorProps(
  //                         dropdownSearchDecoration: InputDecoration(
  //                           labelText: "Menu mode",
  //                           hintText: "country in menu mode",
  //                           border: OutlineInputBorder(),
  //                         ),
  //                       ),
  //                       onChanged: print,
  //                       selectedItem: "Brazil",
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }


  SearchBottomSheet(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.grey.shade100,
      builder: (context) {
      return Column(

        children: [
          SizedBox(height: 50),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
                margin: const EdgeInsets.all(10),
                // padding: EdgeInsets.all(10),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: Colors.black, width: 1)
                ),
                child: TextFormField(
                  controller: searchController,
                  focusNode: _searchFocusNode,
                  autofocus: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: ' Search by City/PG Name/Locality',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                )
            ),
          ),
          // SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Container(
              padding: EdgeInsets.all(20),
              // color: Colors.red,
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    // color: Colors.red,
                    height: 100,
                    width: 120,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Menu mode",
                          hintText: "country in menu mode",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: print,
                      selectedItem: "Brazil",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    // color: Colors.red,
                    height: 100,
                    width: 120,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Menu mode",
                          hintText: "country in menu mode",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: print,
                      selectedItem: "Brazil",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    // color: Colors.red,
                    height: 100,
                    width: 120,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(filled: true,
                          labelText: "Menu mode",
                          hintText: "country in menu mode",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: print,
                      selectedItem: "Brazil",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    // color: Colors.red,
                    height: 100,
                    width: 120,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Menu mode",
                          hintText: "country in menu mode",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: print,
                      selectedItem: "Brazil",
                    ),
                  )
                ],
              ),
            )
          )


        ],
      );
    },);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Constant.bgLight, // Color for Android
        // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    return GestureDetector(
      onTap: _handleTapOutside,
      child: Scaffold(
        // backgroundColor: Constant.bgTile,
        body: NetworkObserverBlock(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Stack(
                      children: [
                        Container(
                          height: 120,
                          color: Constant.bgLight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // SizedBox(
                                    //   width: 20,
                                    // ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.back?InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.arrow_back_ios, color: Colors.white,)):SizedBox(),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Find my PG',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                mobile_no != null
                               ? InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PgRequested()));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    // padding: EdgeInsets.,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Constant.bgTile,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bookmark, color: Constant.bgText,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(child: /*Icon(Icons.bookmark, color: Colors.white,)*/Center(child: Text('My PG', style: TextStyle(color: Constant.bgText, fontSize: 10),)),),
                                            Center(child: /*Icon(Icons.bookmark, color: Colors.white,)*/Center(child: Text('Selection', style: TextStyle(color: Constant.bgText, fontSize: 10),)),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                Positioned(
                    top: 85,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Constant.bgTile,
                          // color: Colors.white,

                          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                      ),
                      child: BlocBuilder<ExploreBloc, ExploreState>(
                                      builder: (context, state) {
                      if (state is ExploreLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ExploreSuccess) {

                        List<Property> leadListCopy = state.exploreModel.property!;

                        //isSearchStarted ? leadListing = searchLead : leadListing = state.exploreModel.property!;
                        print('leadlisting............${leadListing.toString()}');

                        if (isSearchStarted) {
                          print("isSearchStarted : ${isSearchStarted}");
                          leadListing = searchLead;
                          var likelist = leadListing.map((e) => e.interested).toList();
                          var like = likelist.any((element) => element == 1) ? true : false;
                          print('likelist -- ${likelist}');
                          print('like -- ${like}');
                          print(leadListing.length);

                        } else if (sorting) {
                          print("sorting : ${sorting}");
                          leadListing = sortedLead;
                        } else {
                          print("explore : ${sorting}");

                          leadListing = state.exploreModel.property!;
                          leadListingTemp = state.exploreModel.property!;
                        }

                        print(state.exploreModel.property);
                        Property? cityName;

                        cityNames = state.exploreModel.property?.map((property) => property.cityName)
                            .where((city) => city != null && city != '')
                            .toSet()
                            .toList() ?? [];
                        print(cityNames);
                        genderNames = state.exploreModel.property?.map((e) => e.pgType)
                            .where((gender) => gender != null )
                            .toSet()
                            .toList() ?? [];
                        print(genderNames);
                        // String selectedCity = cityNames[0].toString();
                        // String selectedCity = cityNames.isNotEmpty ? cityNames[0]! : '';
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                // Text('Longitude: $_longitude'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    // padding: EdgeInsets.all(10),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      // border: Border.all(color: Colors.black, width: 1)
                                    ),
                                    child: TextFormField(
                                      controller: searchController,
                                      // onTap: (){
                                      //   SearchBottomSheet();
                                      // },
                                      onFieldSubmitted: (value) {
                                        listShow = false;
                                        _searchLocation(value,  state.exploreModel.property!);
                                        setState(() {});
                                      },
                                      focusNode: _searchFocusNode,
                                      onChanged: (value) {
                                        _isOutOfFocus = false;
                                        listShow = true;
                                        // isSearchStarted = true;
                                        isSearchStarted =
                                            searchController.text.isNotEmpty &&
                                                searchController.text.trim().length > 0;

                                        if (isSearchStarted) {
                                          _searchLocation(value, state.exploreModel.property!);

                                          print('nearby addresses: ${_nearbyAddresses.length}');
                                          searchLead = state.exploreModel.property!
                                              .where((element) =>
                                          element.branchName!.toLowerCase().contains(value.toLowerCase()) ||
                                              element.cityName!.toLowerCase().contains(value.toLowerCase()) ||
                                              element.pgIdealFor!.trim().toLowerCase().contains(value.toLowerCase()) ||
                                              element.rentRange!.trim().toLowerCase().contains(value.toLowerCase()) ||
                                              element.branchAddress!.trim().toLowerCase().contains(value.toLowerCase())
                                          )

                                              .toList();
                                          // searchData(value, state.exploreModel.property!);
                                        }
                                        setState(() {});
                                      },
                                      // focusNode: _focusNode.unfocus(),
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.search),
                                        /*prefixIcon: Transform.scale(
                                    scale:
                                        0.5, // Adjust this value to control the size
                                    child: SvgPicture.asset(
                                      'assets/explore/search.svg',
                                      alignment: Alignment.topLeft,
                                    ),
                                  ),*/
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Visibility(
                                                visible: searchController.text.isEmpty || searchController.text == null ? false : true,
                                                child: InkWell(
                                                    onTap: (){
                                                      FocusScope.of(context).unfocus();
                                                      searchController.clear();
                                                      setState(() {
                                                        searchLead = state.exploreModel.property!;
                                                      });
                                                    },
                                                    child: Icon(Icons.cancel)),
                                              ),
                                              SizedBox(width: 5),
                                              InkWell(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                                                  },
                                                  child: Image.asset('assets/explore/googleMaps.png', height: 20, width: 20)/*Icon(Icons.map)*/)
                                            ],
                                          ),
                                        ),
                                        hintText:
                                        ' Search by City/PG Name/Locality',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        // contentPadding: EdgeInsets.all(0),
                                        hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  //   TextFormField(
                                  //     controller: searchController,
                                  //     onFieldSubmitted: (value) {
                                  //       listShow = false;
                                  //       _searchLocation(value,  state.exploreModel.property!);
                                  //       setState(() {});
                                  //     },
                                  //     focusNode: _searchFocusNode,
                                  //     onChanged: (value) {
                                  //       _isOutOfFocus = false;
                                  //       listShow = true;
                                  //       // isSearchStarted = true;
                                  //       isSearchStarted =
                                  //           searchController.text.isNotEmpty &&
                                  //               searchController.text.trim().length > 0;
                                  //
                                  //       if (isSearchStarted) {
                                  //         _searchLocation(value, state.exploreModel.property!);
                                  //
                                  //         print('nearby addresses: ${_nearbyAddresses.length}');
                                  //         searchLead = state.exploreModel.property!
                                  //             .where((element) =>
                                  //         element.branchName!.toLowerCase().contains(value.toLowerCase()) ||
                                  //             element.cityName!.toLowerCase().contains(value.toLowerCase()) ||
                                  //             element.pgIdealFor!.trim().toLowerCase().contains(value.toLowerCase()) ||
                                  //             element.rentRange!.trim().toLowerCase().contains(value.toLowerCase()) ||
                                  //             element.branchAddress!.trim().toLowerCase().contains(value.toLowerCase())
                                  //         )
                                  //
                                  //             .toList();
                                  //         // searchData(value, state.exploreModel.property!);
                                  //       }
                                  //       setState(() {});
                                  //     },
                                  //     // focusNode: _focusNode.unfocus(),
                                  //     autofocus: false,
                                  //     decoration: InputDecoration(
                                  //       border: InputBorder.none,
                                  //       prefixIcon: Icon(Icons.search),
                                  //       /*prefixIcon: Transform.scale(
                                  //   scale:
                                  //       0.5, // Adjust this value to control the size
                                  //   child: SvgPicture.asset(
                                  //     'assets/explore/search.svg',
                                  //     alignment: Alignment.topLeft,
                                  //   ),
                                  // ),*/
                                  //       suffixIcon: Padding(
                                  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.end,
                                  //           mainAxisSize: MainAxisSize.min,
                                  //           children: [
                                  //             Visibility(
                                  //               visible: searchController.text.isEmpty || searchController.text == null ? false : true,
                                  //               child: InkWell(
                                  //                   onTap: (){
                                  //                     FocusScope.of(context).unfocus();
                                  //                     searchController.clear();
                                  //                     setState(() {
                                  //                       searchLead = state.exploreModel.property!;
                                  //                     });
                                  //                   },
                                  //                   child: Icon(Icons.cancel)),
                                  //             ),
                                  //             SizedBox(width: 5),
                                  //             InkWell(
                                  //                 onTap: (){
                                  //                   Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                                  //                 },
                                  //                 child: Image.asset('assets/explore/googleMaps.png', height: 20, width: 20)/*Icon(Icons.map)*/)
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       hintText:
                                  //           ' Search by City/PG Name/Locality',
                                  //       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  //       // contentPadding: EdgeInsets.all(0),
                                  //       hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 14, fontWeight: FontWeight.w400),
                                  //     ),
                                  //   )
                                ),
                                listShow && searchController.text.toString().isNotEmpty && _placesLists.isNotEmpty && _isOutOfFocus == false ? Container(
                                  height: 120,decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ]
                                ),
                                  // padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _placesLists.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () async{
                                                List<Location> locations = await locationFromAddress(_placesLists[index]['description']);
                                                searchController.text = _placesLists[index]['description'].toString();
                                                listShow = false;
                                                setState(() {
                                                  _searchLocation(_placesLists[index]['description'].toString(), state.exploreModel.property!);
                                                });
                                                print('latitude---${locations.last.latitude}');
                                                print('longitude---${locations.last.longitude}');

                                              },
                                              title: Text(_placesLists[index]['description'])
                                          ),
                                        ],
                                      );
                                    },),
                                ): SizedBox.shrink(),
                                const SizedBox(
                                  height: 10,
                                ),

                                Expanded(
                                  child: leadListing.isEmpty
                                      ?  SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text('0 PG found in selected location'),
                                            const SizedBox(height: 10,),
                                            const Text('Suggest nearby property', style: TextStyle(color: Colors.red)),
                                            const SizedBox(height: 10),

                                            _searchedAddress.isNotEmpty && _nearbyAddresses.isNotEmpty
                                                ? ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: _nearbyAddresses.length,
                                                itemBuilder: (context, index) {
                                                  return _nearbyAddresses[index].latitude!.isNotEmpty && _nearbyAddresses[index].longitude!.isNotEmpty
                                                  ? Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16),
                                                  color: Colors.white,
                                                ),
                                                child: /*Text('\u{20B9}${4000}')*/
                                                InkWell(
                                                  borderRadius: BorderRadius.circular(16),
                                                  onTap: () {
                                                    _isOutOfFocus = true;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ExploreDetails(data: _nearbyAddresses[index])
                                                        ),
                                                    );
                                                  },
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:
                                                      Column(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              SizedBox(
                                                                height: 220,
                                                                // width: 200,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width*.9,
                                                                    child: CachedNetworkImage(
                                                                      memCacheWidth: 400,
                                                                      imageUrl: _nearbyAddresses[index].propertyImage![0].imagePath.toString(),
                                                                      fit: BoxFit.fill,
                                                                      // placeholder: (context, url) => Image.asset(
                                                                      //   'assets/explore/placeholder.png',
                                                                      //   color: Constant.bgLight,
                                                                      //   fit: BoxFit.fill,
                                                                      // ),
                                                                      errorWidget: (context, url, error) => Image.asset(
                                                                        'assets/explore/placeholder.png',
                                                                        color: Constant.bgLight,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              _nearbyAddresses[index].isVerified == 'Yes' ?
                                                              Positioned(
                                                                  top: 10,
                                                                  left: 10,
                                                                  child: SvgPicture.asset('assets/explore/verify.svg', ))/*SvgPicture.asset('assets/verified.svg', height: 20, width: 20,))*/ : SizedBox(),
                                                              Positioned(
                                                                  top: 10,
                                                                  right: 10,
                                                                  child: InkWell(
                                                                      onTap: (){
                                                                        openMap(double.parse(_nearbyAddresses[index].latitude.toString()), double.parse(_nearbyAddresses[index].longitude.toString()));
                                                                      },
                                                                    child: Image.asset('assets/explore/googleMaps.png', height: 30, width: 30,)/*SvgPicture.asset('assets/explore/location.svg')*/)
                                                              ) ,
                                                              login/*!widget.back*/ ? Positioned(
                                                                  bottom: 5,
                                                                  right: 5,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      color: Colors.grey.shade100.withOpacity(0.3),
                                                                    ),
                                                                    child: BlocListener<WishlistBloc, WishlistState>(listener: (context, state) {
                                                                      if(state is WishlistLoading){
                                                                        Center(child: CircularProgressIndicator(color: Colors.blue,));
                                                                      }
                                                                      if(state is WishlistSuccess){
                                                                        _isOutOfFocus = true;
                                                                        isSearchStarted = false;
                                                                        BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));

                                                                        print('leadlist ---- ${_nearbyAddresses[0].toString()}');
                                                                      }
                                                                      if(state is WishlistError){
                                                                        print(state.error);
                                                                      }

                                                                    },child:  InkWell(
                                                                        onTap: () async{
                                                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                                                          BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(_nearbyAddresses[index].branchId.toString(),
                                                                              pref.getString('login_id').toString(), _identifier, wifiIP, _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address));
                                                                          print('branchId--${_nearbyAddresses[index].branchId.toString()}');
                                                                          print("tenantID--${pref.getString('login_id').toString()}");
                                                                          print('imei--$_identifier');
                                                                          print('IP--$wifiIP');
                                                                          print("lat--${_currentPosition!.latitude.toString()}");
                                                                          print("long--${_currentPosition!.longitude.toString()}");
                                                                          print(address);
                                                                          print('controller -- ${searchController}');

                                                                          // API.addWishlist(branch_id, tenant_id, imei_no, ip_address, latitude, longitude, address);
                                                                          // like = true;

                                                                        },
                                                                        child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(20),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Icon(_nearbyAddresses[index].wishlist == 'Yes' ? Icons.favorite : Icons.favorite_border,
                                                                                color: _nearbyAddresses[index].wishlist == 'Yes'? Colors.red : Colors.red,),))
                                                                    ),
                                                                    ),
                                                                  )

                                                              ) : SizedBox()
                                                            ],
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 5),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(right: 10.0),
                                                                        child: Text(
                                                                          _nearbyAddresses[index].branchName!,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontFamily: 'Product Sans',
                                                                              fontSize: 16),
                                                                        ),
                                                                      )),
                                                                  Text(
                                                                    '\u{20B9}${formatRentRange(_nearbyAddresses[index].rentRange.toString())/*leadListing[index].rentRange.toString()??''*/}',
                                                                    style: const TextStyle(
                                                                        fontSize: 16,
                                                                        fontFamily: 'Product Sans',
                                                                        fontWeight: FontWeight.w700),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  // leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                  _nearbyAddresses[index].cityName == null || _nearbyAddresses[index].cityName.toString().isEmpty
                                                                      ? SizedBox()
                                                                      : Row(
                                                                    children: [
                                                                      Icon(Icons.star, color: Constant.bgText, size: 15,),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                                        child: Text(_nearbyAddresses[index].ratingPercentage.toString()),
                                                                      ),
                                                                      _nearbyAddresses[index].cityName.toString() == '' && _nearbyAddresses[index].cityName.toString() == 'null' && _nearbyAddresses[index].cityName == null
                                                                          ? SizedBox()
                                                                          : SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                      Text(
                                                                        _nearbyAddresses[index].cityName.toString() == '' && _nearbyAddresses[index].cityName.toString() == 'null' && _nearbyAddresses[index].cityName == null
                                                                            ? ''
                                                                            : _nearbyAddresses[index].cityName.toString() ,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                            fontSize: 12,
                                                                            color: Color(0xff6F7894),
                                                                            fontWeight: FontWeight.w400
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Text(
                                                                    'Starting from',
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Color(0xff6F7894),
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(_nearbyAddresses[index].branchAddress.toString(),
                                                                  maxLines: 1, overflow: TextOverflow.ellipsis,style: const TextStyle(
                                                                      fontSize: 12,
                                                                      color: Color(0xff6F7894),
                                                                      fontWeight: FontWeight.w400
                                                                  ),
                                                                ),
                                                              ),
                                                              // Text(leadListing[index].pgType!),
                                                              // const SizedBox(height: 10,),
                                                              // Row(
                                                              //   children: [
                                                              //     Expanded(
                                                              //       child: Wrap(
                                                              //         children: List.generate(
                                                              //           _nearbyAddresses[index].branchAmenities!.length > 3
                                                              //               ? 3
                                                              //               : _nearbyAddresses[index].branchAmenities!.length,
                                                              //               (idx) {
                                                              //             String amenity = _nearbyAddresses[index].branchAmenities![idx].amenities.toString();
                                                              //             return amenity.isNotEmpty
                                                              //                 ? Container(
                                                              //               margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                              //               decoration: BoxDecoration(
                                                              //                 color: Constant.bgTile,
                                                              //                 borderRadius: BorderRadius.circular(20),
                                                              //               ),
                                                              //               child: Padding(
                                                              //                 padding: const EdgeInsets.all(8.0),
                                                              //                 child: Text(
                                                              //                   amenity,
                                                              //                   style: const TextStyle(
                                                              //                     color: Constant.bgText,
                                                              //                     fontWeight: FontWeight.w400,
                                                              //                     fontSize: 12,
                                                              //                   ),
                                                              //                 ),
                                                              //               ),
                                                              //             )
                                                              //                 : SizedBox.shrink();
                                                              //           },
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //
                                                              //     state.exploreModel.tenantOnboarded == 0 ?
                                                              //     _nearbyAddresses[index].interested == 1 ? InkWell(
                                                              //         onTap: (){
                                                              //           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(_nearbyAddresses[index].branchName.toString(),
                                                              //               _nearbyAddresses[index].propertyImage![0].imagePath.toString(), _nearbyAddresses[index].branchId.toString())));
                                                              //         },
                                                              //         child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                              //         : state.exploreModel.tenantOnboarded == 1 ? InkWell(
                                                              //         onTap: (){
                                                              //           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(_nearbyAddresses[index].branchName.toString(),
                                                              //               _nearbyAddresses[index].propertyImage![0].imagePath.toString(), _nearbyAddresses[index].branchId.toString())));
                                                              //         },
                                                              //         child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                              //   ],
                                                              // ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Wrap(
                                                                          children: List.generate(
                                                                            _nearbyAddresses[index].branchAmenities!.length > 2
                                                                                ? 2
                                                                                : _nearbyAddresses[index].branchAmenities!.length,
                                                                                (idx) {
                                                                              String amenity = _nearbyAddresses[index].branchAmenities![idx].amenities.toString();
                                                                              return amenity.isNotEmpty
                                                                                  ? Container(
                                                                                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                                decoration: BoxDecoration(
                                                                                  color: Constant.bgTile,
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    amenity,
                                                                                    style: const TextStyle(
                                                                                      color: Constant.bgText,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      fontSize: 12,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                                  : SizedBox.shrink();
                                                                            },
                                                                          ),
                                                                        ),
                                                                        _nearbyAddresses[index].branchAmenities!.length > 2 ? Container(
                                                                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                          decoration: BoxDecoration(
                                                                            color: Constant.bgTile,
                                                                            borderRadius: BorderRadius.circular(20),
                                                                          ),
                                                                          child: const Padding(
                                                                            padding: EdgeInsets.all(8.0),
                                                                            child: Text(
                                                                              '+ more',
                                                                              style: TextStyle(
                                                                                color: Constant.bgText,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ) : SizedBox()
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  state.exploreModel.tenantOnboarded == 0 ?
                                                                  _nearbyAddresses[index].interested == 1 ? InkWell(
                                                                      onTap: (){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                                                            _nearbyAddresses[index].branchName.toString(),
                                                                            _nearbyAddresses[index].pgProfileImg.toString()/*_nearbyAddresses[index].propertyImage![0].imagePath.toString()*/,
                                                                            _nearbyAddresses[index].branchId.toString(),
                                                                            _nearbyAddresses[index].contactNumber.toString())));
                                                                      },
                                                                      child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                                      : state.exploreModel.tenantOnboarded == 1 ? InkWell(
                                                                      onTap: (){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                                                            _nearbyAddresses[index].branchName.toString(),
                                                                            _nearbyAddresses[index].pgProfileImg.toString()/*_nearbyAddresses[index].propertyImage![0].imagePath.toString()*/,
                                                                            _nearbyAddresses[index].branchId.toString(),
                                                                          _nearbyAddresses[index].contactNumber.toString()
                                                                        )));
                                                                      },
                                                                      child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                            ],
                                                          )
                                                        ],
                                                      )

                                                    // Column(
                                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                                    //   children: [
                                                    //     Stack(
                                                    //       children: [
                                                    //         Padding(
                                                    //           padding: const EdgeInsets.only(top: 0.0),
                                                    //           child: ClipRRect(
                                                    //
                                                    //             borderRadius: BorderRadius.circular(16),
                                                    //             child: CarouselSlider(
                                                    //               carouselController: _controller,
                                                    //               options: CarouselOptions(
                                                    //                   height: 200,
                                                    //                   initialPage: 0,
                                                    //                   // aspectRatio: 16/9,
                                                    //                   viewportFraction: 1.0,
                                                    //                   autoPlay: true,
                                                    //                   reverse: false,
                                                    //                   enableInfiniteScroll: false,
                                                    //                   autoPlayInterval: const Duration(seconds: 3),
                                                    //                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                                    //                   onPageChanged: (idx,reason ){
                                                    //                     if (reason == CarouselPageChangedReason.manual) {
                                                    //                       setState(() {
                                                    //                         currentIndexPage = idx;
                                                    //                       });
                                                    //                     }
                                                    //                   }),
                                                    //               items: leadListing[index].propertyImage!.map<Widget>((i) {
                                                    //                 // items: widget.data['pics'].map<Widget>((i) {
                                                    //
                                                    //                 return Builder(
                                                    //                   builder: (BuildContext context) {
                                                    //                     return Container(
                                                    //                       width: MediaQuery.of(context).size.width,
                                                    //                       margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                                    //                       // decoration: BoxDecoration(
                                                    //                       //   // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                    //                       //   image:DecorationImage(
                                                    //                       //       image: NetworkImage(i.imagePath!,),
                                                    //                       //       fit: BoxFit.fill
                                                    //                       //   ),
                                                    //                       // ),
                                                    //                       child: Image.network(i.imagePath.toString(), fit: BoxFit.fill,
                                                    //                           errorBuilder: (context, error, stackTrace) {
                                                    //                             return Image.asset('assets/explore/placeholder.png', color: Colors.white,);
                                                    //                           },
                                                    //                       ),
                                                    //                     );
                                                    //                   },
                                                    //                 );
                                                    //               }).toList(),
                                                    //             ),
                                                    //           ),
                                                    //
                                                    //         ),
                                                    //         Positioned(
                                                    //             top: 15,
                                                    //             right: 15,
                                                    //             child: GestureDetector(
                                                    //                 onTap: () async{
                                                    //                   {
                                                    //                     print("---ShareLink----" + _shareLinkcontroller.text);
                                                    //
                                                    //                     launch(
                                                    //                         "https://wa.me/?text=https://play.google.com/store/apps/details?id=${packageInfo!.packageName.toString()}"
                                                    //                             "\nBranch Name: ${state.exploreModel.property![index].branchName}"
                                                    //                             "\nCity : ${state.exploreModel.property![index].cityName}"
                                                    //                             "\nPgType : ${state.exploreModel.property![index].pgType}"
                                                    //                             "\nRent : ${state.exploreModel.property![index].rentRange}");
                                                    //                     // await Whatsapp().openwhatsapp(context,
                                                    //                     //     number: '+91${8385894167}',
                                                    //                     //     content:
                                                    //                     //     'https://play.google.com/store/apps/details?id=com.zucol.roomertenant');
                                                    //                     _shareLinkcontroller.clear();
                                                    //                     // Navigator.of(context).pop();
                                                    //                   }
                                                    //                 },
                                                    //                 child: Image.asset('assets/explore/share.png', height: 20, width: 20, color: Constant.bgLight,))
                                                    //         ),
                                                    //         /*Positioned(
                                                    //           bottom: 10,
                                                    //           left: 0,
                                                    //           right: 0,
                                                    //           child:
                                                    //           DotsIndicator(
                                                    //             // onTap: (position) {
                                                    //             //   setState(() => _currentPos = position);
                                                    //             // },
                                                    //             // onTap: (e) => _controller.animateToPage(e),
                                                    //             dotsCount: leadListing[index].propertyImage!.length,
                                                    //             // dotsCount: widget.data['pics'].length,
                                                    //             position: currentIndexPage % leadListing[index].propertyImage!.length,
                                                    //             // position: leadListing[index].propertyImage!.length % currentIndexPage,
                                                    //             decorator: DotsDecorator(
                                                    //               size: const Size.square(6.0),
                                                    //               spacing: const EdgeInsets.all(2),
                                                    //               activeColor: Colors.white,
                                                    //               activeSize: const Size(6.0, 6.0),
                                                    //               activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                    //             ),
                                                    //           ),)*/
                                                    //       ],
                                                    //     ),
                                                    //     const SizedBox(height: 10),
                                                    //
                                                    //     Row(
                                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //       children: [
                                                    //         Flexible(
                                                    //             child: Text(
                                                    //               leadListing[index].branchName!,
                                                    //               overflow: TextOverflow.ellipsis,
                                                    //               style: const TextStyle(
                                                    //                   fontWeight: FontWeight.w700,
                                                    //                   fontFamily: 'Product Sans',
                                                    //                   fontSize: 16),
                                                    //             )),
                                                    //         Text(
                                                    //           '\u{20B9}${int.parse(leadListing[index].rentRange.toString())}',
                                                    //           style: const TextStyle(
                                                    //               fontSize: 16,
                                                    //               fontFamily: 'Product Sans',
                                                    //               fontWeight: FontWeight.w700),
                                                    //         )
                                                    //       ],
                                                    //     ),
                                                    //     Row(
                                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //       children: [
                                                    //         leadListing[index].cityName == null || leadListing[index].cityName.toString().isEmpty
                                                    //             ? SizedBox()
                                                    //             : Row(
                                                    //           children: [
                                                    //             /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                    //                   ? SizedBox()
                                                    //                   : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                    //             Text(
                                                    //               /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                    //                     ? ''
                                                    //                     : */leadListing[index].cityName.toString() ,
                                                    //               overflow: TextOverflow.ellipsis,
                                                    //               style: const TextStyle(
                                                    //                   fontSize: 12,
                                                    //                   color: Color(0xff6F7894),
                                                    //                   fontWeight: FontWeight.w400
                                                    //               ),
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //         const Text(
                                                    //           'Starting from',
                                                    //           style: TextStyle(
                                                    //               fontSize: 12,
                                                    //               color: Color(0xff6F7894),
                                                    //               fontWeight: FontWeight.w400
                                                    //           ),
                                                    //         )
                                                    //       ],
                                                    //     ),
                                                    //     const SizedBox(height: 10,),
                                                    //
                                                    //     Wrap(
                                                    //       children: List.generate(
                                                    //           state.exploreModel.property![index].branchAmenities!.length >= 3
                                                    //               ? 3
                                                    //               : state.exploreModel.property![index].branchAmenities!.length,
                                                    //               (idx)
                                                    //               {
                                                    //                 String amenity = state.exploreModel.property![index].branchAmenities![idx].amenities.toString();
                                                    //                 return amenity.isNotEmpty
                                                    //                     ? Container(
                                                    //                                 margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                    //                                 decoration: BoxDecoration(color: Constant.bgTile,
                                                    //                                   borderRadius: BorderRadius.circular(20),),
                                                    //                                 child: Padding(
                                                    //                                   padding: const EdgeInsets.all(8.0),
                                                    //                                   child:
                                                    //                                       Text(
                                                    //                                     state.exploreModel.property![index].branchAmenities![idx].amenities.toString(),
                                                    //                                     style:
                                                    //                                         const TextStyle(
                                                    //                                       color: Constant.bgText,
                                                    //                                       fontWeight: FontWeight.w400,
                                                    //                                       fontSize: 12,
                                                    //                                     ),
                                                    //                                   ),
                                                    //                                 ),
                                                    //                               )
                                                    //                             : const SizedBox.shrink();
                                                    //                       }),
                                                    //     ) ,
                                                    //
                                                    //     const SizedBox(height: 10,),
                                                    //   ],
                                                    // )
                                                  ),
                                                  // main content of _nearbyAddresses
                                                  // Padding(
                                                  //     padding: const EdgeInsets.all(8.0),
                                                  //     child:
                                                  //     Row(
                                                  //       children: [
                                                  //         Stack(
                                                  //           children: [
                                                  //             SizedBox(
                                                  //               height: 100,
                                                  //               width: 100,
                                                  //               child: ClipRRect(
                                                  //                 borderRadius: BorderRadius.circular(12),
                                                  //                 child: Image.network(_nearbyAddresses[index].
                                                  //                 propertyImage![0].imagePath.toString(),
                                                  //                     fit: BoxFit.fill,filterQuality: FilterQuality.none,
                                                  //                     errorBuilder: (context, error, stackTrace) {
                                                  //                       return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                                  //                     }
                                                  //                 ),
                                                  //               ),
                                                  //             ),
                                                  //             _nearbyAddresses[index].isVerified == 'Yes' ?
                                                  //             Positioned(
                                                  //                 top: 10,
                                                  //                 left: 10,
                                                  //                 child: SvgPicture.asset('assets/verified.svg', height: 20, width: 20,)) : SizedBox(),
                                                  //             !widget.back ? Positioned(
                                                  //                 bottom: 5,
                                                  //                 right: 5,
                                                  //                 child: BlocListener<WishlistBloc, WishlistState>(listener: (context, state) {
                                                  //                   if(state is WishlistLoading){
                                                  //                     Center(child: CircularProgressIndicator(color: Colors.blue,));
                                                  //                   }
                                                  //                   if(state is WishlistSuccess){
                                                  //                     _isOutOfFocus = true;
                                                  //                     isSearchStarted = false;
                                                  //                     BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                                                  //                   }
                                                  //                   if(state is WishlistError){
                                                  //                     print('error');
                                                  //                   }
                                                  //
                                                  //                 },child:  InkWell(
                                                  //                   onTap: () async{
                                                  //                     SharedPreferences pref = await SharedPreferences.getInstance();
                                                  //                     BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(_nearbyAddresses[index].branchId.toString(),
                                                  //                         pref.getString('login_id').toString(), _identifier, wifiIP, _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address));
                                                  //                     print('branchId--${_nearbyAddresses[index].branchId.toString()}');
                                                  //                     print("tenantID--${pref.getString('login_id').toString()}");
                                                  //                     print('imei--$_identifier');
                                                  //                     print('IP--$wifiIP');
                                                  //                     print("lat--${_currentPosition!.latitude.toString()}");
                                                  //                     print("long--${_currentPosition!.longitude.toString()}");
                                                  //                     print(address);
                                                  //                     print('controller -- ${searchController}');
                                                  //                     // API.addWishlist(branch_id, tenant_id, imei_no, ip_address, latitude, longitude, address);
                                                  //                     // like = true;
                                                  //
                                                  //                   },
                                                  //                   child: Icon(_nearbyAddresses[index].wishlist == 'Yes' ? Icons.favorite : Icons.favorite_border,
                                                  //                     color: _nearbyAddresses[index].wishlist == 'Yes'? Colors.red : Colors.grey,),
                                                  //                 ),
                                                  //                 )
                                                  //
                                                  //             ) : SizedBox()
                                                  //           ],
                                                  //         ),
                                                  //
                                                  //         const SizedBox(width: 10,),
                                                  //         Expanded(
                                                  //           child: Column(
                                                  //             mainAxisAlignment: MainAxisAlignment.start,
                                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                                  //             children: [
                                                  //               Row(
                                                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //                 children: [
                                                  //                   Flexible(
                                                  //                       child: Padding(
                                                  //                         padding: const EdgeInsets.only(right: 10.0),
                                                  //                         child: Text(
                                                  //                           _nearbyAddresses[index].branchName!,
                                                  //                           overflow: TextOverflow.ellipsis,
                                                  //                           style: const TextStyle(
                                                  //                               fontWeight: FontWeight.w700,
                                                  //                               fontFamily: 'Product Sans',
                                                  //                               fontSize: 16),
                                                  //                         ),
                                                  //                       )),
                                                  //                   Text(
                                                  //                     '\u{20B9}${formatRentRange(_nearbyAddresses[index].rentRange.toString())??''}',
                                                  //                     style: const TextStyle(
                                                  //                         fontSize: 16,
                                                  //                         fontFamily: 'Product Sans',
                                                  //                         fontWeight: FontWeight.w700),
                                                  //                   )
                                                  //                 ],
                                                  //               ),
                                                  //               Row(
                                                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //                 children: [
                                                  //                   // leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                  //                   _nearbyAddresses[index].cityName == null || _nearbyAddresses[index].cityName.toString().isEmpty
                                                  //                       ? SizedBox()
                                                  //                       : Row(
                                                  //                     children: [
                                                  //                       /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                  //                     ? SizedBox()
                                                  //                     : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                  //                       Text(
                                                  //                         /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                  //                       ? ''
                                                  //                       : */_nearbyAddresses[index].cityName.toString() ,
                                                  //                         overflow: TextOverflow.ellipsis,
                                                  //                         style: const TextStyle(
                                                  //                             fontSize: 12,
                                                  //                             color: Color(0xff6F7894),
                                                  //                             fontWeight: FontWeight.w400
                                                  //                         ),
                                                  //                       ),
                                                  //                     ],
                                                  //                   ),
                                                  //                   const Text(
                                                  //                     'Starting from',
                                                  //                     style: TextStyle(
                                                  //                         fontSize: 12,
                                                  //                         color: Color(0xff6F7894),
                                                  //                         fontWeight: FontWeight.w400
                                                  //                     ),
                                                  //                   )
                                                  //                 ],
                                                  //               ),
                                                  //               Padding(
                                                  //                 padding: const EdgeInsets.all(5.0),
                                                  //                 child: Text(_nearbyAddresses[index].branchAddress.toString(),
                                                  //                   maxLines: 1, overflow: TextOverflow.ellipsis,style: const TextStyle(
                                                  //                       fontSize: 12,
                                                  //                       color: Color(0xff6F7894),
                                                  //                       fontWeight: FontWeight.w400
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //               // Text(leadListing[index].pgType!),
                                                  //               // const SizedBox(height: 10,),
                                                  //               Row(
                                                  //                 children: [
                                                  //                   Expanded(
                                                  //                     child: Wrap(
                                                  //                       children: List.generate(
                                                  //                         _nearbyAddresses[index].branchAmenities!.length > 2
                                                  //                             ? 2
                                                  //                             : _nearbyAddresses[index].branchAmenities!.length,
                                                  //                             (idx) {
                                                  //                           String amenity = _nearbyAddresses[index].branchAmenities![idx].amenities.toString();
                                                  //                           return amenity.isNotEmpty
                                                  //                               ? Container(
                                                  //                             margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                  //                             decoration: BoxDecoration(
                                                  //                               color: Constant.bgTile,
                                                  //                               borderRadius: BorderRadius.circular(20),
                                                  //                             ),
                                                  //                             child: Padding(
                                                  //                               padding: const EdgeInsets.all(8.0),
                                                  //                               child: Text(
                                                  //                                 amenity,
                                                  //                                 style: const TextStyle(
                                                  //                                   color: Constant.bgText,
                                                  //                                   fontWeight: FontWeight.w400,
                                                  //                                   fontSize: 12,
                                                  //                                 ),
                                                  //                               ),
                                                  //                             ),
                                                  //                           )
                                                  //                               : SizedBox.shrink();
                                                  //                         },
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                   state.exploreModel.tenantOnboarded == 0 ?
                                                  //                   _nearbyAddresses[index].interested == 1 ? InkWell(
                                                  //                       onTap: (){
                                                  //                         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(_nearbyAddresses[index].branchName.toString(),
                                                  //                             _nearbyAddresses[index].propertyImage![0].imagePath.toString(), _nearbyAddresses[index].branchId.toString())));
                                                  //                       },
                                                  //                       child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                  //                       : state.exploreModel.tenantOnboarded == 1 ? InkWell(
                                                  //                       onTap: (){
                                                  //                         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(_nearbyAddresses[index].branchName.toString(),
                                                  //                             _nearbyAddresses[index].propertyImage![0].imagePath.toString(), _nearbyAddresses[index].branchId.toString())));
                                                  //                       },
                                                  //                       child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                  //                 ],
                                                  //               ),
                                                  //               // const SizedBox(height: 10,),
                                                  //             ],
                                                  //           ),
                                                  //         )
                                                  //       ],
                                                  //     )
                                                  //
                                                  // ),
                                                ),
                                                  ) : Center(child: Text('No data found'));
                                                  },
                                            ): Center(child: Text('No data found')),
                                          ],
                                        ),
                                      )
                                      : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: leadListing.length,
                                      itemBuilder: (context, index) {
                                        print('rentRange------------------${state.exploreModel.property![index].rentRange.toString()}');
                                        return
                                          Container(
                                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Colors.white,
                                          ),
                                          child: /*Text('\u{20B9}${4000}')*/
                                          InkWell(
                                            borderRadius: BorderRadius.circular(16),
                                            onTap: () {
                                              _isOutOfFocus = true;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ExploreDetails(
                                                        data: leadListing[index])),
                                              );
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                                Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        SizedBox(
                                                          height: 220,
                                                          // width: 200,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width*.9,
                                                              child: CachedNetworkImage(
                                                                memCacheWidth: 400,
                                                                imageUrl: leadListing[index].propertyImage![0].imagePath.toString(),
                                                                fit: BoxFit.fill,
                                                                // placeholder: (context, url) => Image.asset(
                                                                //   'assets/explore/placeholder.png',
                                                                //   color: Constant.bgLight,
                                                                //   fit: BoxFit.fill,
                                                                // ),
                                                                errorWidget: (context, url, error) => Image.asset(
                                                                  'assets/explore/placeholder.png',
                                                                  color: Constant.bgLight,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        leadListing[index].isVerified == 'Yes' ?
                                                        Positioned(
                                                            top: 10,
                                                            left: 10,
                                                            child: SvgPicture.asset('assets/explore/verify.svg', ))/*SvgPicture.asset('assets/verified.svg', height: 20, width: 20,))*/ : SizedBox(),
                                                        Positioned(
                                                            top: 10,
                                                            right: 10,
                                                            child: InkWell(
                                                                onTap: (){
                                                                  print(leadListing[index].latitude.toString());
                                                                  print(leadListing[index].longitude.toString());
                                                                  openMap(double.parse(leadListing[index].latitude.toString()), double.parse(leadListing[index].longitude.toString()));
                                                                },
                                                                child: Image.asset('assets/explore/googleMaps.png', height: 30, width: 30)/*SvgPicture.asset('assets/explore/location.svg')*/)
                                                        ) ,
                                                        login/*!widget.back*/ ? Positioned(
                                                            bottom: 5,
                                                            right: 5,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                                color: Colors.grey.shade100.withOpacity(0.3),
                                                              ),
                                                              child: BlocListener<WishlistBloc, WishlistState>(listener: (context, state) {
                                                                if(state is WishlistLoading){
                                                                  Center(child: CircularProgressIndicator(color: Colors.blue,));
                                                                }
                                                                if(state is WishlistSuccess){
                                                                  _isOutOfFocus = true;
                                                                  isSearchStarted = false;
                                                                  BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));

                                                                  print('leadlist ---- ${leadListing[0].toString()}');
                                                                }
                                                                if(state is WishlistError){
                                                                  print(state.error);
                                                                }

                                                              },child:  InkWell(
                                                                onTap: () async{
                                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                                  BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(leadListing[index].branchId.toString(),
                                                                      pref.getString('login_id').toString(), _identifier, wifiIP, _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address));
                                                                  print('branchId--${leadListing[index].branchId.toString()}');
                                                                  print("tenantID--${pref.getString('login_id').toString()}");
                                                                  print('imei--$_identifier');
                                                                  print('IP--$wifiIP');
                                                                  print("lat--${_currentPosition!.latitude.toString()}");
                                                                  print("long--${_currentPosition!.longitude.toString()}");
                                                                  print(address);
                                                                  print('controller -- ${searchController}');

                                                                  // API.addWishlist(branch_id, tenant_id, imei_no, ip_address, latitude, longitude, address);
                                                                  // like = true;

                                                                },
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                child: Icon(leadListing[index].wishlist == 'Yes' ? Icons.favorite : Icons.favorite_border,
                                                                  color: leadListing[index].wishlist == 'Yes'? Colors.red : Colors.red,),))
                                                              ),
                                                              ),
                                                            )

                                                        ) : SizedBox()
                                                      ],
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: 5),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Text(
                                                                      leadListing[index].branchName!,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: 'Product Sans',
                                                                          fontSize: 16),
                                                                    ),
                                                                  )),
                                                              Text(
                                                                '\u{20B9}${formatRentRange(leadListing[index].rentRange.toString())/*leadListing[index].rentRange.toString()??''*/}',
                                                                style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontFamily: 'Product Sans',
                                                                    fontWeight: FontWeight.w700),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              // leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                              leadListing[index].cityName == null || leadListing[index].cityName.toString().isEmpty
                                                                  ? SizedBox()
                                                                  : Row(
                                                                children: [
                                                                  Icon(Icons.star, color: Constant.bgText, size: 15,),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                                    child: Text(leadListing[index].ratingPercentage.toString()),
                                                                  ),
                                                                  leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                          ? SizedBox()
                                                                          : SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                  Text(
                                                                    leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                            ? ''
                                                                            : leadListing[index].cityName.toString() ,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(
                                                                        fontSize: 12,
                                                                        color: Color(0xff6F7894),
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Text(
                                                                'Starting from',
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Color(0xff6F7894),
                                                                    fontWeight: FontWeight.w400
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Text(leadListing[index].branchAddress.toString(),
                                                            maxLines: 1, overflow: TextOverflow.ellipsis,style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Color(0xff6F7894),
                                                                fontWeight: FontWeight.w400
                                                            ),
                                                          ),
                                                        ),
                                                        // Text(leadListing[index].pgType!),
                                                        // const SizedBox(height: 10,),
                                                        // Row(
                                                        //   children: [
                                                        //     Expanded(
                                                        //       child: Wrap(
                                                        //         children: List.generate(
                                                        //           leadListing[index].branchAmenities!.length > 3
                                                        //               ? 3
                                                        //               : leadListing[index].branchAmenities!.length,
                                                        //               (idx) {
                                                        //             String amenity = leadListing[index].branchAmenities![idx].amenities.toString();
                                                        //             return amenity.isNotEmpty
                                                        //                 ? Container(
                                                        //               margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                        //               decoration: BoxDecoration(
                                                        //                 color: Constant.bgTile,
                                                        //                 borderRadius: BorderRadius.circular(20),
                                                        //               ),
                                                        //               child: Padding(
                                                        //                 padding: const EdgeInsets.all(8.0),
                                                        //                 child: Text(
                                                        //                   amenity,
                                                        //                   style: const TextStyle(
                                                        //                     color: Constant.bgText,
                                                        //                     fontWeight: FontWeight.w400,
                                                        //                     fontSize: 12,
                                                        //                   ),
                                                        //                 ),
                                                        //               ),
                                                        //             )
                                                        //                 : SizedBox.shrink();
                                                        //           },
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //
                                                        //     state.exploreModel.tenantOnboarded == 0 ?
                                                        //     leadListing[index].interested == 1 ? InkWell(
                                                        //         onTap: (){
                                                        //           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(leadListing[index].branchName.toString(),
                                                        //               leadListing[index].propertyImage![0].imagePath.toString(), leadListing[index].branchId.toString())));
                                                        //         },
                                                        //         child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                        //         : state.exploreModel.tenantOnboarded == 1 ? InkWell(
                                                        //         onTap: (){
                                                        //           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(leadListing[index].branchName.toString(),
                                                        //               leadListing[index].propertyImage![0].imagePath.toString(), leadListing[index].branchId.toString())));
                                                        //         },
                                                        //         child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                        //   ],
                                                        // ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Wrap(
                                                                    children: List.generate(
                                                                      leadListing[index].branchAmenities!.length > 2
                                                                          ? 2
                                                                          : leadListing[index].branchAmenities!.length,
                                                                          (idx) {
                                                                        String amenity = leadListing[index].branchAmenities![idx].amenities.toString();
                                                                        return amenity.isNotEmpty
                                                                            ? Container(
                                                                          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                          decoration: BoxDecoration(
                                                                            color: Constant.bgTile,
                                                                            borderRadius: BorderRadius.circular(20),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Text(
                                                                              amenity,
                                                                              style: const TextStyle(
                                                                                color: Constant.bgText,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : SizedBox.shrink();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  leadListing[index].branchAmenities!.length > 2 ? Container(
                                                                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                    decoration: BoxDecoration(
                                                                      color: Constant.bgTile,
                                                                      borderRadius: BorderRadius.circular(20),
                                                                    ),
                                                                    child: const Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        '+ more',
                                                                        style: TextStyle(
                                                                          color: Constant.bgText,
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ) : SizedBox(),
                                                                ],
                                                              ),
                                                            ),

                                                            state.exploreModel.tenantOnboarded == 0 ?
                                                            leadListing[index].interested == 1 ? InkWell(
                                                                onTap: (){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                                                      leadListing[index].branchName.toString(),
                                                                      leadListing[index].pgProfileImg.toString()/*leadListing[index].propertyImage![0].imagePath.toString()*/,
                                                                      leadListing[index].branchId.toString(),
                                                                    leadListing[index].contactNumber.toString()
                                                                  )));
                                                                },
                                                                child: const Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                                : state.exploreModel.tenantOnboarded == 1 ? InkWell(
                                                                onTap: (){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                                                      leadListing[index].branchName.toString(),
                                                                      leadListing[index].pgProfileImg.toString()/*leadListing[index].propertyImage![0].imagePath.toString()*/,
                                                                      leadListing[index].branchId.toString(),
                                                                    leadListing[index].contactNumber.toString()
                                                                  )));
                                                                },
                                                                child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox()
                                                          ],
                                                        ),
                                                        const SizedBox(height: 10,),
                                                      ],
                                                    )
                                                  ],
                                                )

                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   mainAxisAlignment: MainAxisAlignment.start,
                                                //   children: [
                                                //     Stack(
                                                //       children: [
                                                //         Padding(
                                                //           padding: const EdgeInsets.only(top: 0.0),
                                                //           child: ClipRRect(
                                                //
                                                //             borderRadius: BorderRadius.circular(16),
                                                //             child: CarouselSlider(
                                                //               carouselController: _controller,
                                                //               options: CarouselOptions(
                                                //                   height: 200,
                                                //                   initialPage: 0,
                                                //                   // aspectRatio: 16/9,
                                                //                   viewportFraction: 1.0,
                                                //                   autoPlay: true,
                                                //                   reverse: false,
                                                //                   enableInfiniteScroll: false,
                                                //                   autoPlayInterval: const Duration(seconds: 3),
                                                //                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                                //                   onPageChanged: (idx,reason ){
                                                //                     if (reason == CarouselPageChangedReason.manual) {
                                                //                       setState(() {
                                                //                         currentIndexPage = idx;
                                                //                       });
                                                //                     }
                                                //                   }),
                                                //               items: leadListing[index].propertyImage!.map<Widget>((i) {
                                                //                 // items: widget.data['pics'].map<Widget>((i) {
                                                //
                                                //                 return Builder(
                                                //                   builder: (BuildContext context) {
                                                //                     return Container(
                                                //                       width: MediaQuery.of(context).size.width,
                                                //                       margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                                //                       // decoration: BoxDecoration(
                                                //                       //   // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                //                       //   image:DecorationImage(
                                                //                       //       image: NetworkImage(i.imagePath!,),
                                                //                       //       fit: BoxFit.fill
                                                //                       //   ),
                                                //                       // ),
                                                //                       child: Image.network(i.imagePath.toString(), fit: BoxFit.fill,
                                                //                           errorBuilder: (context, error, stackTrace) {
                                                //                             return Image.asset('assets/explore/placeholder.png', color: Colors.white,);
                                                //                           },
                                                //                       ),
                                                //                     );
                                                //                   },
                                                //                 );
                                                //               }).toList(),
                                                //             ),
                                                //           ),
                                                //
                                                //         ),
                                                //         Positioned(
                                                //             top: 15,
                                                //             right: 15,
                                                //             child: GestureDetector(
                                                //                 onTap: () async{
                                                //                   {
                                                //                     print("---ShareLink----" + _shareLinkcontroller.text);
                                                //
                                                //                     launch(
                                                //                         "https://wa.me/?text=https://play.google.com/store/apps/details?id=${packageInfo!.packageName.toString()}"
                                                //                             "\nBranch Name: ${state.exploreModel.property![index].branchName}"
                                                //                             "\nCity : ${state.exploreModel.property![index].cityName}"
                                                //                             "\nPgType : ${state.exploreModel.property![index].pgType}"
                                                //                             "\nRent : ${state.exploreModel.property![index].rentRange}");
                                                //                     // await Whatsapp().openwhatsapp(context,
                                                //                     //     number: '+91${8385894167}',
                                                //                     //     content:
                                                //                     //     'https://play.google.com/store/apps/details?id=com.zucol.roomertenant');
                                                //                     _shareLinkcontroller.clear();
                                                //                     // Navigator.of(context).pop();
                                                //                   }
                                                //                 },
                                                //                 child: Image.asset('assets/explore/share.png', height: 20, width: 20, color: Constant.bgLight,))
                                                //         ),
                                                //         /*Positioned(
                                                //           bottom: 10,
                                                //           left: 0,
                                                //           right: 0,
                                                //           child:
                                                //           DotsIndicator(
                                                //             // onTap: (position) {
                                                //             //   setState(() => _currentPos = position);
                                                //             // },
                                                //             // onTap: (e) => _controller.animateToPage(e),
                                                //             dotsCount: leadListing[index].propertyImage!.length,
                                                //             // dotsCount: widget.data['pics'].length,
                                                //             position: currentIndexPage % leadListing[index].propertyImage!.length,
                                                //             // position: leadListing[index].propertyImage!.length % currentIndexPage,
                                                //             decorator: DotsDecorator(
                                                //               size: const Size.square(6.0),
                                                //               spacing: const EdgeInsets.all(2),
                                                //               activeColor: Colors.white,
                                                //               activeSize: const Size(6.0, 6.0),
                                                //               activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                //             ),
                                                //           ),)*/
                                                //       ],
                                                //     ),
                                                //     const SizedBox(height: 10),
                                                //
                                                //     Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Flexible(
                                                //             child: Text(
                                                //               leadListing[index].branchName!,
                                                //               overflow: TextOverflow.ellipsis,
                                                //               style: const TextStyle(
                                                //                   fontWeight: FontWeight.w700,
                                                //                   fontFamily: 'Product Sans',
                                                //                   fontSize: 16),
                                                //             )),
                                                //         Text(
                                                //           '\u{20B9}${int.parse(leadListing[index].rentRange.toString())}',
                                                //           style: const TextStyle(
                                                //               fontSize: 16,
                                                //               fontFamily: 'Product Sans',
                                                //               fontWeight: FontWeight.w700),
                                                //         )
                                                //       ],
                                                //     ),
                                                //     Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         leadListing[index].cityName == null || leadListing[index].cityName.toString().isEmpty
                                                //             ? SizedBox()
                                                //             : Row(
                                                //           children: [
                                                //             /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                //                   ? SizedBox()
                                                //                   : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                //             Text(
                                                //               /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                //                     ? ''
                                                //                     : */leadListing[index].cityName.toString() ,
                                                //               overflow: TextOverflow.ellipsis,
                                                //               style: const TextStyle(
                                                //                   fontSize: 12,
                                                //                   color: Color(0xff6F7894),
                                                //                   fontWeight: FontWeight.w400
                                                //               ),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //         const Text(
                                                //           'Starting from',
                                                //           style: TextStyle(
                                                //               fontSize: 12,
                                                //               color: Color(0xff6F7894),
                                                //               fontWeight: FontWeight.w400
                                                //           ),
                                                //         )
                                                //       ],
                                                //     ),
                                                //     const SizedBox(height: 10,),
                                                //
                                                //     Wrap(
                                                //       children: List.generate(
                                                //           state.exploreModel.property![index].branchAmenities!.length >= 3
                                                //               ? 3
                                                //               : state.exploreModel.property![index].branchAmenities!.length,
                                                //               (idx)
                                                //               {
                                                //                 String amenity = state.exploreModel.property![index].branchAmenities![idx].amenities.toString();
                                                //                 return amenity.isNotEmpty
                                                //                     ? Container(
                                                //                                 margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                //                                 decoration: BoxDecoration(color: Constant.bgTile,
                                                //                                   borderRadius: BorderRadius.circular(20),),
                                                //                                 child: Padding(
                                                //                                   padding: const EdgeInsets.all(8.0),
                                                //                                   child:
                                                //                                       Text(
                                                //                                     state.exploreModel.property![index].branchAmenities![idx].amenities.toString(),
                                                //                                     style:
                                                //                                         const TextStyle(
                                                //                                       color: Constant.bgText,
                                                //                                       fontWeight: FontWeight.w400,
                                                //                                       fontSize: 12,
                                                //                                     ),
                                                //                                   ),
                                                //                                 ),
                                                //                               )
                                                //                             : const SizedBox.shrink();
                                                //                       }),
                                                //     ) ,
                                                //
                                                //     const SizedBox(height: 10,),
                                                //   ],
                                                // )
                                            ),
                                          ),
                                        );
                                      },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      if (state is ExploreError) {
                        print(state.error);
                        return Center(child: Container(
                          child: Text(state.error),
                        ),);
                      }
                      print('error');
                      return SizedBox();
                                      },
                                    ),
                    ))
              ]
            ),
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
            height: 60,
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
                  GestureDetector(
                    // borderRadius: BorderRadius.circular(12),
                    onTap: () => sortBottomSheet(),
                    child: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: /*currentTap == 0 ? const Color(0xffDDE9FE) : */Colors.transparent,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.sort, size: 20, color: Colors.red  /*color: *//*currentTap == 0 ? Color(0xff001944) : *//*Color(0xff717D96),*/),
                            SizedBox(width: 5),
                            Text('Sort', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red/* color: *//*currentTap == 0 ? Color(0xff001944) : *//*Color(0xff717D96),*/
                            ),
                            )
                          ],
                        )
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/explore/searchline.svg',
                    // width: 30,
                    height: 20,
                  ),
                  GestureDetector(
                    // borderRadius: BorderRadius.circular(12),
                    onTap: () => filterBottomSheet(context),
                    child: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: /*currentTap == 1 ? const Color(0xffDDE9FE) : */Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/explore/sort.svg', height: 20, width: 20, color: Colors.red /*color: *//*currentTap == 1 ? Color(0xff001944) : *//*Color(0xff717D96),*/),
                            const SizedBox(width: 5),
                            const Text('Filter', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red/* color: *//*currentTap == 1 ? Color(0xff001944) : *//*Color(0xff717D96),*/),)
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sortBottomSheet () {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                sortList(true); // Sort in ascending order
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Image.asset('assets/explore/lowtohigh.png', height: 20, width: 20,),
                title: Text('Price: Low to High', style: TextStyle(fontSize: 14),),
              ),
            ),
            GestureDetector(
              onTap: (){
                sortList(false); // Sort in descending order
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Image.asset('assets/explore/hightolow.png', height: 20, width: 20),
                title: Text('Price: High to Low', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      );
    },);
  }


  void sortList(bool ascending) {
    leadListing.sort((a, b) {
      // Convert rentRange to int if it's a string
      int rentRangeA = int.tryParse(a.rentRange!) ?? 0;
      int rentRangeB = int.tryParse(b.rentRange!) ?? 0;
      if (ascending) {
        return rentRangeA.compareTo(rentRangeB);
      } else {
        return rentRangeB.compareTo(rentRangeA);
      }
    });

    // Update your UI or perform any other actions after sorting
    setState(() {
      // Update state if necessary
    });
  }

  Future<void> filterBottomSheet(BuildContext ctx) {

    // filterCityList.clear();
    // filterGenderList.clear();
    if(apply == false){
      clearAllFilters();
    }
    if(filterCityList.isEmpty){
      for(int i=0;i<cityNames.length;i++){
        filterCityList.add(FilterModel(cityNames[i].toString(), false));
      }
    }

    if(filterGenderList.isEmpty){
      for(int i = 0; i < genderNames.length; i++){
        filterGenderList.add(GenderModel(genderNames[i].toString(), false));
      }
    }


    return showModalBottomSheet<void>(
      useRootNavigator: false,
      enableDrag: true,
      showDragHandle: true,
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: ctx, // Use 'ctx' instead of 'context'
      builder: (BuildContext context) {

        return StatefulBuilder(builder: (context, setState) {
          List<bool> cityStatus = [];

          if (filterBy == 'City') {
            isSearchStarted = true;
            cityStatus = List.generate(cityNames.length, (index) => false);
          }

          return Container(
            // height: MediaQuery.of(context).size.height-100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('FILTERS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                          GestureDetector(
                              onTap: (){
                                apply = false;
                                clearAllFilters();
                                setState((){});
                              },
                              child: const Text('CLEAR ALL', style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2), thickness: 1, height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 210,
                        width: MediaQuery.of(context).size.width * 0.40,
                        color: Colors.grey.withOpacity(0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // InkWell(
                            //   onTap: () {
                            //     filterBy = 'Price';
                            //     setState(() {});
                            //   },
                            //   child: Container(
                            //     height: 50,
                            //     width: MediaQuery.of(context).size.width * 0.40,
                            //     decoration: BoxDecoration(
                            //       color: filterBy == 'Price' ? Colors.white : Colors.transparent,
                            //     ),
                            //     child: const Center(child: Text('Price', style: TextStyle(fontWeight: FontWeight.w400))),
                            //   ),
                            // ),
                            // Divider(color: Colors.grey.withOpacity(0.2), thickness: 1, height: 1),
                            InkWell(
                              onTap: () {
                                filterBy = 'City';
                                setState(() {});
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.40,
                                decoration: BoxDecoration(
                                  color: filterBy == 'City' ? Colors.white : Colors.transparent,
                                ),
                                child: Center(child: Text('City')),
                              ),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.2), thickness: 1, height: 1),
                            InkWell(
                              onTap: () {
                                filterBy = 'Gender';
                                setState(() {});
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.40,
                                decoration: BoxDecoration(
                                  color: filterBy == 'Gender' ? Colors.white : Colors.transparent,
                                ),
                                child: Center(child: Text('Gender')),
                              ),
                            ),
                            Divider(color: Colors.grey.withOpacity(0.2), thickness: 1, height: 1),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 210,
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: filterBy == 'Gender'
                            ? Container(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<ExploreBloc, ExploreState>(
                            builder: (context, state) {
                              List<bool> genderStatus = [];
                              isSearchStarted = true;
                              genderStatus = List.generate(filterGenderList.length, (index) => false);

                              return StatefulBuilder(builder: (context, setState) {
                                return ListView.builder(
                                  itemCount: filterGenderList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        genderStatus[index] = !genderStatus[index];
                                        filterGenderList[index].genderStatus = !filterGenderList[index].genderStatus;
                                        if(filterGenderList[index].genderStatus == true){

                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 50,
                                        color: Colors.white,
                                        width: MediaQuery.of(context).size.width*.60,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 15,),
                                            Icon(
                                              Icons.check,
                                              color: filterGenderList[index].genderStatus ? Colors.red : Colors.grey,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 15,),
                                            Text(
                                              filterGenderList[index].toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: filterGenderList[index].genderStatus ? FontWeight.w700 : FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                            },
                          ),
                        )
                            : filterBy == 'City'
                            ? Container(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<ExploreBloc, ExploreState>(
                            builder: (context, state) {
                              List<bool> cityStatus = [];
                              isSearchStarted = true;
                              cityStatus = List.generate(filterCityList.length, (index) => false);

                              return StatefulBuilder(builder: (context, setState) {
                                return ListView.builder(
                                  itemCount: filterCityList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        cityStatus[index] = !cityStatus[index];
                                        filterCityList[index].cityStatus=! filterCityList[index].cityStatus;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 50,
                                        color: Colors.white,
                                        width: MediaQuery.of(context).size.width*.60,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 15,),
                                            Icon(
                                              Icons.check,
                                              color: filterCityList[index].cityStatus ? Colors.red : Colors.grey,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 15,),
                                            Text(
                                              filterCityList[index].toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: filterCityList[index].cityStatus ? FontWeight.w700 : FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                            },
                          ),
                        )
                            : Container(),
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if(apply == false){
                                    clearAllFilters();
                                  }
                                  searchLead = List.from(leadListing);
                                  Navigator.pop(context);

                                },
                                child: const Center(child: Text('BACK', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300))),
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/explore/searchline.svg',
                                  height: 20,
                                ),
                              ),
                              BlocBuilder<ExploreBloc, ExploreState>(builder: (context, state) {
                                if(state is ExploreLoading){
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                                if(state is ExploreSuccess){
                                  List<Property> leadListingCopy = state.exploreModel.property!;
                                return GestureDetector(
                                onTap: () {
                                  apply = true;
                                searchLead.clear();

                                // if (!filterCityList.any((element) => element.cityStatus) && !filterGenderList.any((element) => element.genderStatus)) {
                                //   searchLead = List.from(leadListing);
                                //   print('searchLead when leadlisting---${searchLead}');
                                // }

                                for(int i=0;i<filterCityList.length;i++){
                                if(filterCityList[i].cityStatus){
                                print("FilterData : ${filterCityList[i].cityName}");
                                print('searchCity length-----${searchLead.length}');
                                searchLead.addAll(leadListingTemp!.where((pg) => pg.cityName?.toLowerCase() == filterCityList[i].cityName!.toLowerCase()).toList());


                                print(searchLead);
                                }
                                }

                                if(searchLead.isEmpty){
                                for(int i = 0; i < filterGenderList.length; i++){
                                if(filterGenderList[i].genderStatus){
                                print('GenderData : ${filterGenderList[i].genderName}');
                                print('searchGender length----${searchLead.length}');

                                searchLead.addAll(leadListingTemp!.where((pg) => pg.pgType?.toLowerCase() == filterGenderList[i].genderName.toLowerCase()).toList());
                                }
                                }
                                if(searchLead.isEmpty){
                                // BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                                searchLead = List.from(leadListing);
                                searchLead = List.from(leadListingCopy);
                                // Navigator.pop(context);
                                }
                                }


                                else {
                                List<Property> listTemp = List.from(searchLead);
                                // searchLead.clear();

                                for (int i = 0; i < filterGenderList.length; i++) {
                                if (filterGenderList[i].genderStatus) {
                                searchLead.clear();
                                print('GenderData : ${filterGenderList[i].genderName}');
                                print('searchGender length----${searchLead.length}');
                                print('listTemp length----${listTemp.length}');
                                searchLead.addAll(listTemp!.where((pg) => pg.pgType?.toLowerCase() == filterGenderList[i].genderName.toLowerCase()).toList());
                                print('doublefilter------------${searchLead.toString()}');

                                }
                                }
                                }

                                Navigator.pop(context);
                                //  setState((){});

                                initState();
                                },
                                child: const Center(child: Text('APPLY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red))),
                                );
                                }
                                if(state is ExploreError){
                                  return Center(child: Text('Apply'),);
                                }
                                return SizedBox();
                              },
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void clearAllFilters() {
    // Reset cityStatus and genderStatus
    for (int i = 0; i < filterCityList.length; i++) {
      filterCityList[i].cityStatus = false;
    }
    for (int i = 0; i < filterGenderList.length; i++) {
      filterGenderList[i].genderStatus = false;
    }
    //
    // // Clear cityNames and genderNames
    // filterCityList.clear();
    // filterGenderList.clear();
    //
    // // Reinitialize cityNames and genderNames
    // for (int i = 0; i < cityNames.length; i++) {
    //   filterCityList.add(FilterModel(cityNames[i].toString(), false));
    // }
    // for (int i = 0; i < genderNames.length; i++) {
    //   filterGenderList.add(GenderModel(genderNames[i].toString(), false));
    // }
  }
}
// _foundUser.sort((a, b) => double.parse(a['rent_range_from']).compareTo(double.parse(b['rent_range_from'])));
// _foundUser.sort((a, b) => double.parse(b['rent_range_from']).compareTo(double.parse(a['rent_range_from'])));
