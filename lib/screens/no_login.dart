import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roomertenant/screens/otp_login_profile.dart';
import 'package:roomertenant/screens/pg_requested.dart';
import 'package:roomertenant/screens/visitor_list/exploreDetails.dart';
import 'package:roomertenant/screens/wishlist_bloc/wishlist_bloc.dart';
import 'package:roomertenant/widgets/navBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';
import '../model/ExploreModel.dart';
import 'chat.dart';
import 'explore.dart';
import 'explore_bloc/explore_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'internet_check.dart';
import 'login.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';


class NoLogin extends StatefulWidget {
  static const id = 'NoLogin';
  const NoLogin({super.key});

  @override
  State<NoLogin> createState() => _NoLoginState();
}

class _NoLoginState extends State<NoLogin> {
  bool login = false;
  int currentIndexPage = 0;
  final CarouselController _controller = CarouselController();
  TextEditingController searchController = TextEditingController();
  final TextEditingController _shareLinkcontroller = TextEditingController();
  bool isSearchStarted = false;
  List<Property> leadListing = [];
  List<Property> searchLead = [];
  List<Property> sortedLead = [];
  FilterItem? selectedMenu;
  PackageInfo? packageInfo;
  bool sorting = false;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  String? mobile_no ;
  String? tenant_id ;
  String? name ;
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesLists = [];
  String _identifier = '';
  String? _currentAddress;
  Position? _currentPosition;
  var address;
  var wifiIP;
  var isLogIn;

  // String? onboarded;

  @override
  void initState() {
    fetchData();
    exploreApi();
    super.initState();
    searchController.addListener(() {
      onChange();
    });
  }


  void onChange() {
    if(_sessionToken == null){
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion (searchController.text);
  }

  // Function to format rent range
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }

  void getSuggestion(String input) async{
    String kPLACES_API_KEY = 'AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    String country = 'country:IN'; // Country code for India
    String request = '$baseURL?input=$input&components=$country&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    print('data');
    print(data);
    if(response.statusCode == 200){
      setState(() {
        _placesLists = jsonDecode(response.body.toString())['predictions'];
      });
    }else{
      throw Exception('Failed to load data');
    }
  }

  bool listShow = false;

  exploreApi() async{
    packageInfo= await PackageInfo.fromPlatform();
    // packageName = packageInfo.packageName
    print(packageInfo!.packageName);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.getBool('isLoggedIn');
    // isLogIn = pref.getBool('isLoggedIn');
    mobile_no = await pref.getString('mobile_no');
    tenant_id = await pref.getString('tenant_id');
    name = await pref.getString('name');
    print('tenant_id-----$tenant_id');
    print('mobile_no-----$tenant_id');
    // onboarded = await pref.getString('onboarded');
    // BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
  }


  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshData() async {

    print('tenant_id-----$tenant_id');
    // Call your API here
    await API.explore(mobile_no ?? '').then((value) {
      if (value.tenantOnboarded == 1) {
        Navigator.pushNamedAndRemoveUntil(context, NavBar.id, (route) => false);
      }
      print('tenantOnboardedStatus---------${value.tenantOnboarded}');
    });
  }



  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return _nearbyAddresses.map((address) => address.toString()).join('\n');
  }

  String _searchedAddress = '';
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

      }
    } catch (e) {

      print('Error: $e');
    }
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

    SharedPreferences pref = await SharedPreferences.getInstance();
    isLogIn = pref.getBool('isLoggedIn');
    print('isLogin ---$isLogIn');

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
    // await [
    //   Permission.locationWhenInUse,
    // ].request();
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      /*setState(() =>*/ _currentPosition = position/*)*/;
    }).catchError((e) {
      debugPrint( e);
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

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }
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


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Constant.bgLight, // Color for Android
      // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    print('mobile_no----$mobile_no');
    // print('onboarded----${onboarded}');
    return GestureDetector(
      onTap: _handleTapOutside,
      child: Scaffold(
        backgroundColor: Constant.bgTile,
        body: NetworkObserverBlock(
          child: Stack(
            fit: StackFit.loose,
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
                  ),
                    //login or logout
                    Positioned(
                      top: 45,
                      right: 20,
                      child:
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: mobile_no == null
                                    ? const Text(
                                  'Welcome',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                )
                                    : Text(
                                  'Welcome to $name',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Visibility(
                                  visible: mobile_no == null ? false : true,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PgRequested()));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Constant.bgDark,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.bookmark,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                InkWell(
                                  onTap: () {
                                    if (mobile_no == null) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpLoginProfile()));
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: mobile_no == null ? 120 : 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: mobile_no == null
                                          ? const Text(
                                        'Login/Register',
                                        style: TextStyle(color: Constant.bgDark),
                                      )
                                          : const Icon(
                                        Icons.person,
                                        color: Constant.bgDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /*SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: mobile_no == null ? const Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 20),) : Text('Welcome to $name', overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 20),),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: mobile_no == null ? false : true,
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PgRequested()));
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          // padding: EdgeInsets.,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Constant.bgDark,
                                          ),
                                          child: const Center(child: Icon(Icons.bookmark, color: Colors.white,)*//*Text('Requested', style: TextStyle(color: Colors.white, fontSize: 12),)*//*,),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    InkWell(
                                        onTap: (){
                                    if(mobile_no == null){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                    }else{

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OtpLoginProfile()));
                                    }
                                    }, child: Container(
                                      height: 30,
                                      width: mobile_no == null ? 120 : 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Center(child: mobile_no == null ? const Text('Login/Register', style: TextStyle(color: Constant.bgDark),) : const Icon(Icons.person, color: Constant.bgDark,),)

                                    )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                    ),


                  ]
                ),
              ),
              RefreshIndicator(

                key: _refreshIndicatorKey,
                onRefresh: _refreshData,
                child: Positioned(
                    top: 85,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white/*Constant.bgTile*/,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 16,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child:
                              BlocBuilder<ExploreBloc, ExploreState>(builder: (context, state) {

                                if(state is ExploreSuccess){
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffF6F5FF),
                                                borderRadius: BorderRadius.circular(30),
                                                border: Border.all(
                                                    color: Constant.bgDark,
                                                    width: 1.5
                                                )
                                            ),
                                            child: TextFormField(
                                              focusNode: _searchFocusNode,
                                              controller: searchController,
                                              onFieldSubmitted: (value) {
                                                _searchLocation(value,  state.exploreModel.property!);
                                              },
                                              onChanged: (value) {
                                                _isOutOfFocus = false;
                                                listShow = true;
                                                // isSearchStarted = true;
                                                isSearchStarted =
                                                    searchController.text.isNotEmpty &&
                                                        searchController.text.trim().length > 0;

                                                if (isSearchStarted) {
                                                  _searchLocation(value, state.exploreModel.property!);
                                                  searchLead = state.exploreModel.property!
                                                      .where((element) =>
                                                      element.branchName!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase()) ||
                                                          element.cityName!.toLowerCase().contains(value.toLowerCase()) ||
                                                          element.pgIdealFor!.toLowerCase().contains(value.toLowerCase()) ||
                                                          element.rentRange!.toLowerCase().contains(value.toLowerCase()) ||
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
                                                  suffixIcon: Visibility(
                                                    visible: searchController.text.isEmpty || searchController.text == null ? false : true,
                                                    child: InkWell(
                                                        onTap: (){
                                                          searchController.clear();
                                                          setState(() {
                                                            searchLead = state.exploreModel.property!;
                                                          });
                                                        },
                                                        child: Icon(Icons.cancel)),
                                                  ),
                                                  prefixIcon: Icon(Icons.search,size: 24,),
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.all(12),
                                                  hintText: 'Search by City/PG Name/Locality',
                                                  hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 16, fontWeight: FontWeight.w400)
                                              ),
                                            )
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: (){
                                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMap()));
                                      //   },
                                      //   child: const Padding(
                                      //     padding: EdgeInsets.all(8.0),
                                      //     child: Icon(Icons.location_disabled),
                                      //   ),
                                      // )
                                    ],
                                  );
                                }
                                return const SizedBox();
                              },
                              )

                            ),
                            BlocBuilder<ExploreBloc, ExploreState>(
                              builder: (context, state) {
                                if(state is ExploreSuccess){
                                  return listShow && searchController.text.toString().isNotEmpty && _placesLists.isNotEmpty  && _isOutOfFocus == false ?Container(
                                    height: 120,
                                    decoration: BoxDecoration(
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
                                        return ListTile(
                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                            onTap: () async{
                                              _isOutOfFocus = true;
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
                                        );
                                      },),
                                  ): SizedBox.shrink();
                                }
                              return SizedBox();
                            },),

                            const SizedBox(height: 20,),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ExploreScreen(true)));
                                              // Navigator.pushNamed(context, ExploreScreen.id, );
                                            },
                                              child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                        width: 100/*MediaQuery.of(context).size.width*/,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        color: Constant.bgTile,
                                                      ),
                                                        child: SvgPicture.asset('assets/nologin/searchcity.svg',/* height: 100,*/)),
                                                    Text('Search by City',
                                                      style: TextStyle(/*fontWeight: FontWeight.w700,*/
                                                          fontSize: 14, fontFamily: 'Product Sans', color: Colors.black),
                                                    ),
                                                  ]
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: InkWell(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ExploreScreen(true)));
                                                // Navigator.pushNamed(context, ExploreScreen.id);
                                              },
                                              child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                        width: 100/*MediaQuery.of(context).size.width/2*/,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Constant.bgTile,
                                                        ),
                                                        child: SvgPicture.asset('assets/nologin/searchpg.svg'/*, height: 100*/,)),
                                                    Text('Search by PG',
                                                      style: TextStyle(/*fontWeight: FontWeight.w700,*/
                                                          fontSize: 14, fontFamily: 'Product Sans', color: Colors.black),
                                                    ),
                                                  ]
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                BlocBuilder<ExploreBloc, ExploreState>(builder: (context, state) {
                                  if(state is ExploreLoading){
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if(state is ExploreSuccess){
                                    //isSearchStarted ? leadListing = searchLead : leadListing = state.exploreModel.property!;
                                    print('leadlisting............${leadListing.toString()}');

                                    if (isSearchStarted) {
                                      print("isSearchStarted : $isSearchStarted");
                                      leadListing = searchLead;
                                    } else if (sorting) {
                                      print("sorting : $sorting");
                                      leadListing = sortedLead;
                                    } else {
                                      print("explore : $sorting");

                                      leadListing = state.exploreModel.property!;
                                    }
                                    // list of PG
                                    return InkWell(
                                      onTap: (){},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        color: Colors.white/*Constant.bgTile*/,
                                        // height: MediaQuery.of(context).size.height*0.45,
                                        child: leadListing.isEmpty
                                            ?  SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('0 PG found in selected location'),
                                              SizedBox(height: 10,),
                                              Text('Suggest nearby property', style: TextStyle(color: Colors.red)),
                                              SizedBox(height: 10),

                                              _searchedAddress.isNotEmpty && _nearbyAddresses.isNotEmpty
                                                  ?ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: _nearbyAddresses.length,
                                                itemBuilder: (context, index) {
                                                  _isOutOfFocus = true;
                                                  return _nearbyAddresses[index].latitude!.isNotEmpty && _nearbyAddresses[index].longitude!.isNotEmpty
                                                      ? Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      color: Constant.bgTile,
                                                    ),
                                                    child: /*Text('\u{20B9}${4000}')*/
                                                    InkWell(
                                                      borderRadius: BorderRadius.circular(16),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => /*login == true
                                                  ? */ExploreDetails(
                                                                  data: _nearbyAddresses[index])
                                                            /*: Login()*/),
                                                          // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
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
                                                                    // width: 100,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      child: _nearbyAddresses[index].propertyImage != null
                                                                          ? Container(
                                                                        width: MediaQuery.of(context).size.width*.9,
                                                                            child: CachedNetworkImage(
                                                                              memCacheWidth: 400,
                                                                              imageUrl: _nearbyAddresses[index].propertyImage![0].imagePath.toString(),
                                                                              fit: BoxFit.fill,
                                                                            //   placeholder: (context, url) => Image.asset(
                                                                            // 'assets/explore/placeholder.png',
                                                                            // color: Constant.bgLight,
                                                                            // fit: BoxFit.fill,
                                                                            //   ),
                                                                              errorWidget: (context, url, error) => Image.asset(
                                                                            'assets/explore/placeholder.png',
                                                                            color: Constant.bgLight,
                                                                            fit: BoxFit.fill,
                                                                              ),
                                                                              ),
                                                                          )
                                                                          : Image.asset(
                                                                        'assets/explore/placeholder.png',
                                                                        color: Constant.bgLight,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  _nearbyAddresses[index].isVerified == 'Yes'
                                                                      ? Positioned(
                                                                    top: 10,
                                                                    left: 10,
                                                                    child: SvgPicture.asset('assets/explore/verify.svg', )
                                                                  )
                                                                      : SizedBox(),
                                                                  Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child: InkWell(
                                                                          onTap: (){
                                                                            openMap(double.parse(_nearbyAddresses[index].latitude.toString()), double.parse(_nearbyAddresses[index].longitude.toString()));
                                                                          },
                                                                          child: Image.asset('assets/explore/googleMaps.png', height: 30, width: 30)/*SvgPicture.asset('assets/explore/location.svg')*/)
                                                                  ) ,
                                                                  isLogIn == true
                                                                      ? Positioned(
                                                                    bottom: 5,
                                                                    right: 5,
                                                                    child: InkWell(
                                                                      onTap: () async {
                                                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                                                        API.addWishlist(_nearbyAddresses[index].branchId.toString(),
                                                                          pref.getString('login_id').toString(),
                                                                          _identifier,
                                                                          wifiIP,
                                                                          _currentPosition!.latitude.toString(),
                                                                          _currentPosition!.longitude.toString(),
                                                                          address,).then((value) {
                                                                          print(value);
                                                                          if (value.success == 1) {
                                                                            print(';;;;;;;;;;;;;;;;;;;');
                                                                            _isOutOfFocus = true;
                                                                            isSearchStarted = false;
                                                                            BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no ?? ''));
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          color: Colors.grey.shade100.withOpacity(0.3),
                                                                        ),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(
                                                                          _nearbyAddresses[index].wishlist == 'Yes' ? Icons.favorite : Icons.favorite_border,
                                                                          color: _nearbyAddresses[index].wishlist == 'Yes' ? Colors.red : Colors.red,
                                                                        ),))
                                                                      ),
                                                                    ),
                                                                  )
                                                                      : SizedBox(),
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
                                                                        '\u{20B9}${formatRentRange(_nearbyAddresses[index].rentRange.toString())/*_nearbyAddresses[index].rentRange.toString()*/??''}',
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
                                                                      /*_nearbyAddresses[index].cityName == null || _nearbyAddresses[index].cityName.toString().isEmpty
                                                                          ? SizedBox()
                                                                          : Row(
                                                                        children: [
                                                                          *//*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                  ? SizedBox()
                                                                  : *//*SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                          Text(
                                                                            *//*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                    ? ''
                                                                    : *//*_nearbyAddresses[index].cityName.toString() ,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: const TextStyle(
                                                                                fontSize: 12,
                                                                                color: Color(0xff6F7894),
                                                                                fontWeight: FontWeight.w400
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),*/
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
                                                                                      color: Color(0xffDCDCFD)/*Constant.bgTile*/,
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
                                                                                color: Color(0xffDCDCFD),
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
                                                                      isLogIn == true ?
                                                                      _nearbyAddresses[index].interested == 1 ? InkWell(
                                                                          onTap: (){
                                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                                                                _nearbyAddresses[index].branchName.toString(),
                                                                                _nearbyAddresses[index].propertyImage![0].imagePath.toString(),
                                                                                _nearbyAddresses[index].branchId.toString(),
                                                                              _nearbyAddresses[index].contactNumber.toString()
                                                                            )));
                                                                          },
                                                                          child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox() : SizedBox(),
                                                                    ],
                                                                  )
                                                                  // const SizedBox(height: 10,),
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
                                                  ) : Center(child: Text('No data found'));
                                                },
                                              ): Center(child: Text('No data found')),
                                            ],
                                          ),
                                        )

                                            :
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: leadListing.length,
                                          itemBuilder: (context, index) {

                                            // return InkWell(
                                            //   onTap: (){
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) => /*login == true
                                            //                 ? */ExploreDetails(
                                            //               data: leadListing[index])
                                            //         /*: Login()*/
                                            //       ),
                                            //       // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
                                            //     );
                                            //   },
                                            //   child: Container(
                                            //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            //     height: 120,
                                            //     width: MediaQuery.of(context).size.width,
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(12),
                                            //       border: Border.all(color: Colors.grey),
                                            //     ),
                                            //     child: Row(
                                            //       children: [
                                            //         Container(
                                            //           height: 100,
                                            //           width: 100,
                                            //           child: ClipRRect(
                                            //             borderRadius: BorderRadius.circular(12),
                                            //             child: Image.network(
                                            //               state.exploreModel.property![index].propertyImage![0].imagePath.toString(),
                                            //               fit: BoxFit.fill,
                                            //               errorBuilder: (context, error, stackTrace) {
                                            //                 return Image.asset('assets/explore/placeholder.png', color: Colors.white,);
                                            //                 },
                                            //             ),
                                            //           ),
                                            //         ),
                                            //         const SizedBox(width: 5),
                                            //         Expanded(
                                            //           child: Column(
                                            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //             crossAxisAlignment: CrossAxisAlignment.start,
                                            //             children: [
                                            //               Flexible(
                                            //                 child: Text(
                                            //                   state.exploreModel.property![index].branchName.toString() ?? '',
                                            //                   overflow: TextOverflow.ellipsis,
                                            //                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            //                 ),
                                            //               ),
                                            //               SizedBox(
                                            //                 width: 200,
                                            //                 child: Row(
                                            //                   children: [
                                            //                     SvgPicture.asset('assets/explore/locationmini.svg'),
                                            //                     const SizedBox(width: 2,),
                                            //                     Flexible(
                                            //                       child: Text(
                                            //                         state.exploreModel.property![index].branchAddress.toString() ?? '',
                                            //                         overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               ),
                                            //               Row(
                                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //                 children: [
                                            //                   Container(
                                            //                     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            //                     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            //                       decoration: BoxDecoration(
                                            //                         color: Colors.grey,
                                            //                         borderRadius: BorderRadius.circular(12)
                                            //                       ),
                                            //                       child: Text(state.exploreModel.property![index].pgType.toString() ?? '', style: TextStyle(color: Colors.white),)),
                                            //                   Text('₹ ${state.exploreModel.property![index].rentRange.toString()}' ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                            //                 ],
                                            //               ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // );

                                            /*Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                              height: 100,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: Colors.grey)
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 80,
                                                    width: 80,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(state.exploreModel.property![index].propertyImage![0].imagePath.toString(),
                                                        fit: BoxFit.fill,
                                                        // errorBuilder: (context, error, stackTrace) {
                                                        //   return
                                                        // },
                                                      )*//*state.exploreModel.property![index].propertyImage![0]*//*,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(child: Text(state.exploreModel.property![index].branchName.toString()??'', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
                                                      SizedBox(
                                                          width: 200,
                                                          child: Flexible(child: Text(state.exploreModel.property![index].branchAddress.toString()??'', overflow: TextOverflow.ellipsis,))),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(state.exploreModel.property![index].pgType.toString()??''),
                                                            Text(state.exploreModel.property![index].rentRange.toString()??''),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );*/



                                            return Container(
                                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                color: Constant.bgTile/*Colors.white*/,
                                              ),
                                              child: /*Text('\u{20B9}${4000}')*/
                                              InkWell(
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => /*login == true
                                                            ? */ExploreDetails(
                                                            data: leadListing[index])
                                                            /*: Login()*/
                                                  ),
                                                    // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
                                                  );
                                                },
                                                borderRadius: BorderRadius.circular(16),
                                                child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child:
                                                        Column(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                SizedBox(
                                                                  height: 220,
                                                                  // width: 220,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    child: leadListing[index].propertyImage != null
                                                                        ? Container(
                                                                      width: MediaQuery.of(context).size.width*.9,
                                                                          child: CachedNetworkImage(
                                                                            memCacheWidth: 400,
                                                                          imageUrl: leadListing[index].propertyImage![0].imagePath.toString(),
                                                                          fit: BoxFit.fill,
                                                                          // placeholder: (context, url) => Image.asset(
                                                                          // 'assets/explore/placeholder.png',
                                                                          // color: Constant.bgLight,
                                                                          // fit: BoxFit.fill,
                                                                          // ),
                                                                          errorWidget: (context, url, error) => Image.asset(
                                                                          'assets/explore/placeholder.png',
                                                                          color: Constant.bgLight,
                                                                          fit: BoxFit.fill,
                                                                          ),
                                                                          ),
                                                                        )
                                                                        : Image.asset(
                                                                      'assets/explore/placeholder.png',
                                                                      color: Constant.bgLight,
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                leadListing[index].isVerified == 'Yes'
                                                                    ? Positioned(
                                                                  top: 10,
                                                                  left: 10,
                                                                  child: SvgPicture.asset('assets/explore/verify.svg', )
                                                                )
                                                                    : SizedBox(),
                                                                Positioned(
                                                                    top: 10,
                                                                    right: 10,
                                                                    child: InkWell(
                                                                        onTap: (){
                                                                          openMap(double.parse(leadListing[index].latitude.toString()), double.parse(leadListing[index].longitude.toString()));
                                                                        },
                                                                        child: Image.asset('assets/explore/googleMaps.png', height: 30, width: 30)/*SvgPicture.asset('assets/explore/location.svg')*/)
                                                                ) ,
                                                                isLogIn == true
                                                                    ? Positioned(
                                                                  bottom: 5,
                                                                  right: 5,
                                                                  child: InkWell(
                                                                    onTap: () async {
                                                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                                                        API.addWishlist(leadListing[index].branchId.toString(),
                                                                          pref.getString('login_id').toString(),
                                                                          _identifier,
                                                                          wifiIP,
                                                                          _currentPosition!.latitude.toString(),
                                                                          _currentPosition!.longitude.toString(),
                                                                          address,).then((value) {
                                                                            print(value);
                                                                            if (value.success == 1) {
                                                                              print(';;;;;;;;;;;;;;;;;;;');
                                                                              _isOutOfFocus = true;
                                                                              isSearchStarted = false;
                                                                          BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no ?? ''));
                                                                        }
                                                                        });
                                                                        // BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(
                                                                        //   leadListing[index].branchId.toString(),
                                                                        //   pref.getString('login_id').toString(),
                                                                        //   _identifier,
                                                                        //   wifiIP,
                                                                        //   _currentPosition!.latitude.toString(),
                                                                        //   _currentPosition!.longitude.toString(),
                                                                        //   address,
                                                                        // ));



                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        color: Colors.grey.shade100.withOpacity(0.3),
                                                                      ),child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                      child: Icon(
                                                                        leadListing[index].wishlist == 'Yes' ? Icons.favorite : Icons.favorite_border,
                                                                        color: leadListing[index].wishlist == 'Yes' ? Colors.red : Colors.red,
                                                                      ),))
                                                                    ),
                                                                  ),
                                                                )
                                                                    : SizedBox(),
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
                                                                            leadListing[index].branchName!,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w700,
                                                                                fontFamily: 'Product Sans',
                                                                                fontSize: 16),
                                                                          ),
                                                                        )),
                                                                    Text(
                                                                      '\u{20B9}${formatRentRange(leadListing[index].rentRange.toString())??''}',
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
                                                                    /*leadListing[index].cityName == null || leadListing[index].cityName.toString().isEmpty
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                      children: [
                                                                        *//*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                    ? SizedBox()

                                                                    : *//*SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                        Text(
                                                                          *//*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                      ? ''
                                                                      : *//*leadListing[index].cityName.toString() ,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: Color(0xff6F7894),
                                                                              fontWeight: FontWeight.w400
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),*/
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
                                                                                    color: Color(0xffDCDCFD)/*Constant.bgTile*/,
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
                                                                                    : const SizedBox.shrink();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          leadListing[index].branchAmenities!.length > 2 ? Container(
                                                                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                            decoration: BoxDecoration(
                                                                              color: Color(0xffDCDCFD),
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
                                                                    isLogIn == true ?
                                                                    leadListing[index].interested == 1 ? InkWell(
                                                                        onTap: (){
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                                                              leadListing[index].branchName.toString(),
                                                                              leadListing[index].propertyImage![0].imagePath.toString(),
                                                                              leadListing[index].branchId.toString(),
                                                                            leadListing[index].contactNumber.toString()
                                                                          )));
                                                                        },
                                                                        child: Icon(Icons.chat, color: Constant.bgLight,)) : SizedBox() : SizedBox(),
                                                                  ],
                                                                )
                                                                // const SizedBox(height: 10,),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                    // Column(
                                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                                    //   children: [
                                                    //     SizedBox(
                                                    //       height: 80,
                                                    //       width: 80,
                                                    //       child: ClipRRect(
                                                    //           borderRadius: BorderRadius.circular(12),
                                                    //           child: Image.network(state.exploreModel.property![index].propertyImage![0].imagePath.toString(), fit: BoxFit.fill,)),
                                                    //     ),
                                                    //
                                                    //   //   Stack(
                                                    //   //     children: [
                                                    //   //       Padding(
                                                    //   //         padding: const EdgeInsets.only(top: 0.0),
                                                    //   //         child: ClipRRect(
                                                    //   //
                                                    //   //           borderRadius: BorderRadius.circular(16),/*,color: Colors.red*/
                                                    //   //           /*decoration: BoxDecoration(
                                                    //   // ),*/
                                                    //   //           child:
                                                    //   //
                                                    //   //           CarouselSlider(
                                                    //   //             carouselController: _controller,
                                                    //   //             options: CarouselOptions(
                                                    //   //                 height: 200,
                                                    //   //                 initialPage: 0,
                                                    //   //                 // aspectRatio: 16/9,
                                                    //   //                 viewportFraction: 1.0,
                                                    //   //                 autoPlay: true,
                                                    //   //                 reverse: false,
                                                    //   //                 enableInfiniteScroll: false,
                                                    //   //                 autoPlayInterval: Duration(seconds: 3),
                                                    //   //                 autoPlayAnimationDuration: Duration(milliseconds: 800),
                                                    //   //                 onPageChanged: (index,reason ){
                                                    //   //                   if (reason == CarouselPageChangedReason.manual) {
                                                    //   //                     setState(() {
                                                    //   //                       currentIndexPage = index;
                                                    //   //                     });
                                                    //   //                   }
                                                    //   //                 }),
                                                    //   //             items: leadListing[index].propertyImage!.map<Widget>((i) {
                                                    //   //               // items: widget.data['pics'].map<Widget>((i) {
                                                    //   //               return Builder(
                                                    //   //                 builder: (BuildContext context) {
                                                    //   //                   return Container(
                                                    //   //                     width: MediaQuery.of(context).size.width,
                                                    //   //                     margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                                    //   //                     child: Image.network(i.imagePath.toString(), fit: BoxFit.fill,
                                                    //   //                       errorBuilder: (context, error, stackTrace) {
                                                    //   //                       return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                                    //   //                     },),
                                                    //   //                   );
                                                    //   //                 },
                                                    //   //               );
                                                    //   //             }).toList(),
                                                    //   //           ),
                                                    //   //         ),
                                                    //   //
                                                    //   //       ),
                                                    //   //       Positioned(
                                                    //   //           top: 15,
                                                    //   //           right: 15,
                                                    //   //           child: GestureDetector(
                                                    //   //               onTap: () async{
                                                    //   //                 {
                                                    //   //                   print("---ShareLink----" + _shareLinkcontroller.text);
                                                    //   //
                                                    //   //                   launch(
                                                    //   //                       "https://wa.me/?text=https://play.google.com/store/apps/details?id=${packageInfo!.packageName.toString()}"
                                                    //   //                           "\nBranch Name: ${state.exploreModel.property![index].branchName}"
                                                    //   //                           "\nCity : ${state.exploreModel.property![index].cityName}"
                                                    //   //                           "\nPgType : ${state.exploreModel.property![index].pgType}"
                                                    //   //                           "\nRent : ${state.exploreModel.property![index].rentRange}");
                                                    //   //                   // await Whatsapp().openwhatsapp(context,
                                                    //   //                   //     number: '+91${8385894167}',
                                                    //   //                   //     content:
                                                    //   //                   //     'https://play.google.com/store/apps/details?id=com.zucol.roomertenant');
                                                    //   //                   // _shareLinkcontroller.clear();
                                                    //   //                   // Navigator.of(context).pop();
                                                    //   //                 }
                                                    //   //               },
                                                    //   //               child: Image.asset('assets/explore/share.png', height: 20, width: 20, color: Constant.bgLight,))
                                                    //   //       ),
                                                    //   //       /*Positioned(
                                                    //   //         bottom: 10,
                                                    //   //         left: 0,
                                                    //   //         right: 0,
                                                    //   //         child:
                                                    //   //         *//*Row(
                                                    //   //           mainAxisAlignment: MainAxisAlignment.center,
                                                    //   //           children: leadListing[index].propertyImage!.map((url) {
                                                    //   //             int indexm = leadListing[index].propertyImage!.indexOf(url);
                                                    //   //             return Container(
                                                    //   //               width: 8.0,
                                                    //   //               height: 8.0,
                                                    //   //               margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                                    //   //               decoration: BoxDecoration(
                                                    //   //                 shape: BoxShape.circle,
                                                    //   //                 color: currentIndexPage == indexm ? Colors.blueAccent : Colors.grey,
                                                    //   //               ),
                                                    //   //             );
                                                    //   //           }).toList(),
                                                    //   //         ),*//*
                                                    //   //         DotsIndicator(
                                                    //   //           dotsCount: leadListing[index].propertyImage!.length,
                                                    //   //           position: currentIndexPage % leadListing[index].propertyImage!.length,
                                                    //   //           decorator: DotsDecorator(
                                                    //   //             size: const Size.square(6.0),
                                                    //   //             spacing: const EdgeInsets.all(2),
                                                    //   //             activeColor: Colors.white,
                                                    //   //             activeSize: const Size(6.0, 6.0),
                                                    //   //             activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                    //   //           ),
                                                    //   //         ),)*/
                                                    //   //     ],
                                                    //   //   ),
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
                                                    //           '\u{20B9}${int.parse(leadListing[index].rentRange.toString())??''}',
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
                                                    //         // leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                    //         leadListing[index].cityName == null || leadListing[index].cityName.toString().isEmpty
                                                    //             ? SizedBox()
                                                    //             : Row(
                                                    //           children: [
                                                    //             /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                    //                 ? SizedBox()
                                                    //                 : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                    //             Text(
                                                    //               /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                    //                   ? ''
                                                    //                   : */leadListing[index].cityName.toString() ,
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
                                                    //     // Text(leadListing[index].pgType!),
                                                    //     const SizedBox(height: 10,),
                                                    //     Wrap(
                                                    //       children: List.generate(
                                                    //         state.exploreModel.property![index].branchAmenities!.length > 3
                                                    //             ? 3
                                                    //             : state.exploreModel.property![index].branchAmenities!.length,
                                                    //             (idx) {
                                                    //           String amenity = state.exploreModel.property![index].branchAmenities![idx].amenities.toString();
                                                    //           return amenity.isNotEmpty
                                                    //               ? Container(
                                                    //             margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                    //             decoration: BoxDecoration(
                                                    //               color: Constant.bgTile,
                                                    //               borderRadius: BorderRadius.circular(20),
                                                    //             ),
                                                    //             child: Padding(
                                                    //               padding: const EdgeInsets.all(8.0),
                                                    //               child: Text(
                                                    //                 amenity,
                                                    //                 style: const TextStyle(
                                                    //                   color: Constant.bgText,
                                                    //                   fontWeight: FontWeight.w400,
                                                    //                   fontSize: 12,
                                                    //                 ),
                                                    //               ),
                                                    //             ),
                                                    //           )
                                                    //               : SizedBox.shrink();
                                                    //         },
                                                    //       ),
                                                    //     ),
                                                    //     const SizedBox(height: 10,),
                                                    //   ],
                                                    // )
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                  if(state is ExploreError){
                                    return Center(child: Text(state.error),);
                                    // return Center(child: CircularProgressIndicator(),);
                                  }
                                  return const SizedBox();
                                },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
