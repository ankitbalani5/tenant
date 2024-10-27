import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/ExploreModel.dart';
import 'package:roomertenant/model/review_model.dart';
import 'package:roomertenant/screens/explore_bloc/explore_bloc.dart';
import 'package:roomertenant/screens/review_bloc/review_bloc.dart';
import 'package:roomertenant/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../api/apitget.dart';
import '../../utils/common.dart';
import '../../utils/utils.dart';
import '../interested.dart';
import '../no_login.dart';
import '../wishlist_bloc/wishlist_bloc.dart';

class ExploreDetails extends StatefulWidget {
  static const id = 'exploreDetails';
  final Property data;
  // final Map<String, dynamic> data;
  const ExploreDetails({Key? key, required this.data}) : super(key: key);

  @override
  State<ExploreDetails> createState() => _ExploreDetailsState();
}

class _ExploreDetailsState extends State<ExploreDetails> {
  var _formKey = GlobalKey<FormState>();
  int currentIndexPage = 0;
  bool like = false;
  // final CarouselController _controller = CarouselController();
  var _controller;
  String? branchId;
  bool process = false;
  String? mobile_no;
  String? name;
  String? email;
  String? message;
  String _identifier = '';
  String? _currentAddress;
  Position? _currentPosition;
  var wifiIP = "";
  var address;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  // Future<List<Map<String, dynamic>>> fetchNearbyPlaces(double latitude, double longitude, String apiKey) async {
  //   final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
  //       '?location=$latitude,$longitude'
  //       '&radius=1000'
  //       '&type=hospital&restaurant&train_station&movie_theater&supermarket'
  //       '&key=$apiKey';
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     final List results = jsonResponse['results'];
  //     print('railways ${results.map((e) => e['name'])}');
  //     print('address ${results.map((e) => e['vicinity'])}');
  //
  //     return results.map((place) {
  //       return {
  //         'name': place['name'],
  //         'address': place['vicinity'],
  //       };
  //     }).toList();
  //   } else {
  //     throw Exception('Failed to load nearby places');
  //   }
  // }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
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

  // Function to format rent range
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }
  var isLogIn;
  bool? hasPermission;

  fetchData() async{
    // fetchNearbyPlaces(double.parse(widget.data.latitude.toString()), double.parse(widget.data.longitude.toString()), 'AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c');
    BlocProvider.of<ReviewBloc>(context).add(ReviewRefreshEvent(widget.data.branchId.toString()));
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString('branch_id');
    isLogIn = pref.getBool('isLoggedIn');
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
    hasPermission = await _handleLocationPermission();
    if (!hasPermission!) return ;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
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

    debugPrint(address);
    print('imei $_identifier');
    print('branchId ${widget.data.branchId}');
    print('ip_address $wifiIP');
    print('tenant_id ${pref.getString('tenant_id')}');
    print("lat ${_currentPosition?.latitude ??''} ");
    print('long ${_currentPosition?.longitude ??''} ');
    print('address $address');
    API.visitHistory(widget.data.branchId.toString(), pref.getString('tenant_id').toString(),
        _identifier,
        wifiIP, _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address
    );


  }

  Widget imageDialog(List<PropertyImage>? exploredetails, context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ))
            ],
          ),
          Container(
            /////  *****   Widget for image slider  ***** //////
            child: CarouselSlider.builder(
                itemCount: exploredetails!.length,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndexPage = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realindex) {
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => /*imageDialog(exploredetails, context)*/
                          ZoomImage(
                                exploredetails[index].imagePath.toString(),
                                context)
                        );
                      },
                      child: Container(
                        height: 600,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  exploredetails[index].imagePath.toString()),
                              // filterQuality: FilterQuality.low,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                }),


          ),
        ],
      ),
    );
  }

  Widget ZoomImage(path, context) {
    print(path.toString());
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ))
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width/*double.maxFinite*/,
            height: /*MediaQuery.of(context).size.height*/500,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              imageProvider: NetworkImage(path),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  // final CarouselController _carouselController = CarouselController();
  var _carouselController;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, // Color for Android
      // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    final tagName = widget.data.pgOccupancy!;
    final split = tagName.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    return
      WillPopScope(
        onWillPop: () async {
          if (bottomSheet == true) {
            // Prevents popping the screen
            return false;
          }
          // Allows popping the screen
          return true;
        },
        child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                child: Stack(
                  children: [

                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
                      ),
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: CarouselSlider.builder(
                          itemCount: widget.data.propertyImage!.length,
                          carouselController: _controller,
                          options: CarouselOptions(
                              height: 500,
                              initialPage: 0,
                              // aspectRatio: 16/9,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              reverse: false,
                              enableInfiniteScroll: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              onPageChanged: (index,reason ){
                                setState(() {
                                  currentIndexPage = index;
                                });
                              }),
                          /*itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                    barrierColor: Colors.white*//*Colors.transparent.withOpacity(0.8)*//*,
                                  builder: (context) {
                                  return Stack(
                                    children: [

                                      Positioned(
                                        top: 20,
                                          bottom: 20,
                                          left: 20,
                                          right: 20,
                                          child:
                                          CarouselSlider.builder(
                                            itemCount: widget.data.propertyImage!.length,
                                            itemBuilder: (context, index, realIdx) {
                                              return PhotoView(
                                                imageProvider: CachedNetworkImageProvider(
                                                    widget.data.propertyImage![index].imagePath.toString()),
                                              );
                                            },
                                            options: CarouselOptions(
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll: false,
                                            ),
                                            carouselController: _carouselController,
                                          ),
                                  ),
                                    Positioned(
                                      left: 10,
                                      top: MediaQuery.of(context).size.height/2.2,
                                      child: ElevatedButton(
                                        onPressed: () => _carouselController.previousPage(),
                                        child: Icon(Icons.arrow_left),
                                      ),
                                    ),
                                      Positioned(
                                          right: 10,
                                          top: MediaQuery.of(context).size.height/2.2,
                                          child: ElevatedButton(
                                            onPressed: () => _carouselController.nextPage(),
                                            child: Icon(Icons.arrow_right),
                                          ),
                                      ),

                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 30,
                                            )),),
                                    ]
                                  );
                                },);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                decoration: const BoxDecoration(
                                  // borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                  *//*image: DecorationImage(
                                        image: NetworkImage(i.imagePath!,),
                                        fit: BoxFit.fill
                                      )*//*
                                ),
                                child: Image.network(widget.data.propertyImage![index].imagePath!, fit: BoxFit.cover,
                                    filterQuality: FilterQuality.none,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                    }
                                ),
                              ),
                            );
                          },*/
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.black/*Colors.transparent.withOpacity(0.8)*/,
                                    builder: (context) {
                                      return Stack(
                                          children: [

                                            Positioned(
                                              top: 20,
                                              bottom: 20,
                                              left: 20,
                                              right: 20,
                                              child:
                                              CarouselSlider.builder(
                                                itemCount: widget.data.propertyImage!.length,
                                                itemBuilder: (context, index, realIdx) {
                                                  return PhotoView(
                                                    imageProvider: CachedNetworkImageProvider(widget.data.propertyImage![index].imagePath.toString()),
                                                    minScale: PhotoViewComputedScale.contained * 1.0,
                                                    maxScale: PhotoViewComputedScale.covered * 2.5,
                                                    initialScale: PhotoViewComputedScale.contained *1.0,
                                                    enableRotation: false,
                                                    tightMode: true,

                                                  );
                                                },
                                                options: CarouselOptions(
                                                  enlargeCenterPage: true,
                                                  enableInfiniteScroll: false,
                                                  viewportFraction: 1.0,
                                                  aspectRatio: 1.0,
                                                  initialPage: realIndex,
                                                  onPageChanged: (index, reason) {
                                                    // setState(() {
                                                    //   _current = index;
                                                    // });
                                                  },
                                                ),
                                                carouselController: _carouselController,
                                              ),
                                            ),

                                            Positioned(
                                              left: 10,
                                              top: MediaQuery.of(context).size.height/2.2,
                                              child: IconButton(
                                                onPressed: () => _carouselController.previousPage(),
                                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                                              ),
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: MediaQuery.of(context).size.height/2.2,
                                              child: IconButton(

                                                onPressed: () => _carouselController.nextPage(),
                                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                                              ),
                                            ),

                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )),),
                                          ]
                                      );
                                    },);

                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                  decoration: const BoxDecoration(
                                    // borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                    /*image: DecorationImage(
                                        image: NetworkImage(i.imagePath!,),
                                        fit: BoxFit.fill
                                      )*/
                                  ),
                                  child: Image.network(widget.data.propertyImage![index].imagePath!, fit: BoxFit.cover,
                                      filterQuality: FilterQuality.none,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                      }
                                  ),
                                ),
                              );
                              }
                          // items: widget.data.propertyImage!.map<Widget>((i) {
                          //
                          //   return Builder(
                          //     builder: (BuildContext context) {
                          //       return GestureDetector(
                          //         onTap: (){
                          //           showDialog(
                          //               context: context,
                          //               builder: (_) => ZoomImage(
                          //                   i.imagePath.toString(),
                          //                   context));
                          //         },
                          //         child: Container(
                          //           width: MediaQuery.of(context).size.width,
                          //           margin: const EdgeInsets.symmetric(horizontal: 0.0),
                          //           decoration: BoxDecoration(
                          //             // borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                          //             /*image: DecorationImage(
                          //               image: NetworkImage(i.imagePath!,),
                          //               fit: BoxFit.fill
                          //             )*/
                          //           ),
                          //           child: Image.network(i.imagePath!, fit: BoxFit.cover,),
                          //         ),
                          //       );
                          //     },
                          //   );
                          // }).toList(),
                        ),
                      )
                  ),
                    // Back Icon
                    Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(onPressed: () {
                          Navigator.pop(context);
                        },
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                        )
                    ),
                    Positioned(
                        left: 25,
                        bottom: 22,
                        child: Container(
                          // color: Colors.red,
                          child: Row(
                            children: [

                              widget.data.lastWeekViews!.isNotEmpty ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.transparent.withOpacity(1),
                                ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/explore/eye.png', height: 20, width: 20,),
                                        const SizedBox(width: 2,),
                                        Text(widget.data.lastWeekViews.toString(), style: const TextStyle(fontSize: 12, color: Colors.white70),),
                                      ],
                                    ),
                                  )) : SizedBox()
                            ],
                          ),
                        )
                    ),

                    // Like
                    isLogIn == true
                   ? Positioned(
                      bottom: 20,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade100.withOpacity(0.3),
                          ),
                          child: BlocListener<WishlistBloc, WishlistState>(listener: (context, state) {
                            if(state is WishlistLoading){
                              Center(child: CircularProgressIndicator(),);
                            }
                            if(state is WishlistSuccess){
                              Navigator.pop(context);
                              BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                              // setState(() {
                              //
                              // });

                            }
                            if(state is WishlistError){
                              print('error');
                            }
                          },child: GestureDetector(
                            onTap: () async {
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(widget.data.branchId.toString(),
                                  pref.getString('login_id').toString(), _identifier, wifiIP??'', _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address));
                              print('branchId--${widget.data.branchId.toString()}');
                              print("login_id--${pref.getString('login_id').toString()}");
                              print('imei--$_identifier');
                              print('IP--$wifiIP');
                              print("lat--${_currentPosition!.latitude.toString()}");
                              print("long--${_currentPosition!.longitude.toString()}");
                              print(address);

                              // API.addWishlist(branch_id, tenant_id, imei_no, ip_address, latitude, longitude, address);
                              // like = true;
                              // like = !like;
                              // setState(() {
                              //
                              // });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(widget.data.wishlist=='No' ? Icons.favorite_border : Icons.favorite, color: widget.data.wishlist=='No' ? Colors.white : Colors.red,),
                              ),
                            ),
                          ),
                          )

                        )
                    )
                      : SizedBox(),

                    // Dot Indicator
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child:
                    DotsIndicator(
                      // onTap: (position) {
                      //   setState(() => _currentPos = position);
                      // },
                      onTap: (e) => _controller.animateToPage(e),
                      dotsCount: widget.data.propertyImage!.length,
                      // dotsCount: widget.data['pics'].length,
                      position: currentIndexPage,
                      decorator: DotsDecorator(
                        size: const Size.square(5.0),
                        spacing: const EdgeInsets.all(2),
                        activeColor: Colors.white,
                        activeSize: const Size(5.0, 5.0),
                        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),)
                  ]
                ),
              ),
              // Name and Address
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))
                ),
                child: /*Container(color: Colors.grey,)*/
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(widget.data.branchName!,
                              // Text(widget.data['name'],
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                              child: Text(widget.data.pgType.toString()),
                            ),
                          )
                        ],
                      ),
                      widget.data.cityName!.isNotEmpty
                          ? Row(
                        children: [
                          Icon(Icons.star, color: Constant.bgText, size: 15,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(widget.data.ratingPercentage.toString()),
                          ),
                          SvgPicture.asset('assets/explore/locationmini.svg'),
                          Text(widget.data.cityName??'', style: const TextStyle(color: Color(0xff717D96)),),
                        ],
                      ) : SizedBox(),


                      const SizedBox(height: 10,),
                      Text(widget.data.branchAddress.toString()),
                      const SizedBox(height: 20,),
                      const Text('Per month rent starting from', style: TextStyle(color: Colors.grey),),
                      Text('\u{20B9}${formatRentRange(widget.data.rentRange.toString())/*widget.data.rentRange*/}',
                        // Text('\u{20B9}${widget.data['rupee']}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 20,),

                      // Sharing Type
                      const Text('Sharing Type',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: values.length,
                        itemBuilder: (context, index) {

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.1)

                          ),
                          child: Center(child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(values[index].toString(), style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  fontSize: 12
                                ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/explore/bed.svg'),
                                    /*const Text(' x '),
                                    Text('2')*/

                                  ],
                                ),/*
                                Text(('${
                                      double.parse(widget.data.rentRange!) * 2
                                    }/mo*').toString())*/
                              ],
                            ),
                          )),
                        );
                      },),

                      const SizedBox(height: 20,),
                      // Amenities
                      const Text('Amenities',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10,),
                      Wrap(
                          children: List.generate(
                              widget.data.branchAmenities!.length
                              , (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                                color: Constant.bgTile,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.data.branchAmenities![index].amenities.toString(), style: TextStyle(color: Constant.bgText),),
                            ),
                          ))
                      )

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('House Rules',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              ),
              const SizedBox(height: 10,),
              // House rules
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                    widget.data.propertyTermsCondition!.map<Widget>((rules){
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            const Text("• ", style: TextStyle(fontSize: 15),), //bullet text
                            const SizedBox(width: 10,), //space between bullet and text
                            Expanded(
                              child:Text(rules.terms.toString(),style: const TextStyle(fontWeight: FontWeight.w500),), //text
                            )
                          ]
                      );
                    }).toList(),

                ),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Nearby Places',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              ),
              DefaultTabController(length: 5,
                  child: Container(
                    height: 200.0,
                    child: Column(
                      children: [
                        const TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          tabs: [
                            Tab(text: 'Restaurant'),
                            Tab(text: 'Hospital'),
                            Tab(text: 'Railway Station'),
                            Tab(text: 'Supermarket'),
                            Tab(text: 'Movie Theater'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.data.nearbyLocations?.restaurant!.length != 0 ? widget.data.nearbyLocations?.restaurant!.length : 1,
                                  itemBuilder: (context, index) {
                                    return widget.data.nearbyLocations!.restaurant!.isEmpty
                                        ? Center(child: Text('No Place found', style: TextStyle(color: Colors.black),))
                                        : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                                width: MediaQuery.of(context).size.width*.7,
                                                child: Text('• ${widget.data.nearbyLocations!.restaurant![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                            SizedBox(width: 10,),
                                            InkWell(
                                              onTap: (){
                                                print(widget.data.nearbyLocations!.restaurant![index].latitude.toString());
                                                print(widget.data.nearbyLocations!.restaurant![index].longitude.toString());
                                                openMap(double.parse(widget.data.nearbyLocations!.restaurant![index].latitude.toString()), double.parse(widget.data.nearbyLocations!.restaurant![index].longitude.toString()));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/explore/location.svg',
                                                width: 24,  // Adjust width as needed
                                                height: 24, // Adjust height as needed
                                                color: Constant.bgLight,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('${widget.data.nearbyLocations!.restaurant![index].address.toString()}', style: TextStyle(color: Colors.grey)),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  },),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.data.nearbyLocations?.hospital?.length != 0 ? widget.data.nearbyLocations?.hospital?.length : 1,
                                  itemBuilder: (context, index) {
                                    return widget.data.nearbyLocations!.hospital!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                                width: MediaQuery.of(context).size.width*.7,
                                                child: Text('• ${widget.data.nearbyLocations!.hospital![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                            SizedBox(width: 10,),
                                            InkWell(
                                              onTap: (){
                                                print(widget.data.nearbyLocations!.hospital![index].latitude.toString());
                                                print(widget.data.nearbyLocations!.hospital![index].longitude.toString());
                                                openMap(double.parse(widget.data.nearbyLocations!.hospital![index].latitude.toString()), double.parse(widget.data.nearbyLocations!.hospital![index].longitude.toString()));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/explore/location.svg',
                                                width: 24,  // Adjust width as needed
                                                height: 24, // Adjust height as needed
                                                color: Constant.bgLight,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('${widget.data.nearbyLocations!.hospital![index].address.toString()}', style: TextStyle(color: Colors.grey)),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  },),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.data.nearbyLocations?.trainStation?.length != 0 ? widget.data.nearbyLocations?.trainStation?.length : 1,
                                  itemBuilder: (context, index) {
                                    return widget.data.nearbyLocations!.trainStation!.isEmpty
                                        ? Center(child: Text('No Place found'))
                                        : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                                width: MediaQuery.of(context).size.width*.7,
                                                child: Text('• ${widget.data.nearbyLocations!.trainStation![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                            SizedBox(width: 10,),
                                            InkWell(
                                              onTap: (){
                                                print(widget.data.nearbyLocations!.trainStation![index].latitude.toString());
                                                print(widget.data.nearbyLocations!.trainStation![index].longitude.toString());
                                                openMap(double.parse(widget.data.nearbyLocations!.trainStation![index].latitude.toString()), double.parse(widget.data.nearbyLocations!.trainStation![index].longitude.toString()));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/explore/location.svg',
                                                width: 24,  // Adjust width as needed
                                                height: 24, // Adjust height as needed
                                                color: Constant.bgLight,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('${widget.data.nearbyLocations!.trainStation![index].address.toString()}', style: TextStyle(color: Colors.grey)),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  },),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.data.nearbyLocations?.supermarket?.length != 0 ? widget.data.nearbyLocations?.supermarket?.length : 1,
                                  itemBuilder: (context, index) {
                                    return widget.data.nearbyLocations!.supermarket!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                                width: MediaQuery.of(context).size.width*.7,
                                                child: Text('• ${widget.data.nearbyLocations!.supermarket![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                            SizedBox(width: 10,),
                                            InkWell(
                                              onTap: (){
                                                print(widget.data.nearbyLocations!.supermarket![index].latitude.toString());
                                                print(widget.data.nearbyLocations!.supermarket![index].longitude.toString());
                                                openMap(double.parse(widget.data.nearbyLocations!.supermarket![index].latitude.toString()), double.parse(widget.data.nearbyLocations!.supermarket![index].longitude.toString()));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/explore/location.svg',
                                                width: 24,  // Adjust width as needed
                                                height: 24, // Adjust height as needed
                                                color: Constant.bgLight,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('${widget.data.nearbyLocations!.supermarket![index].address.toString()}', style: TextStyle(color: Colors.grey)),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  },),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.data.nearbyLocations?.movieTheater?.length != 0 ? widget.data.nearbyLocations?.movieTheater?.length : 1,
                                  itemBuilder: (context, index) {
                                    return widget.data.nearbyLocations!.movieTheater!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                                width: MediaQuery.of(context).size.width*.7,
                                                child: Text('• ${widget.data.nearbyLocations!.movieTheater![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                            SizedBox(width: 10,),
                                            InkWell(
                                              onTap: (){
                                                print(widget.data.nearbyLocations!.movieTheater![index].latitude.toString());
                                                print(widget.data.nearbyLocations!.movieTheater![index].longitude.toString());
                                                openMap(double.parse(widget.data.nearbyLocations!.movieTheater![index].latitude.toString()), double.parse(widget.data.nearbyLocations!.movieTheater![index].longitude.toString()));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/explore/location.svg',
                                                width: 24,  // Adjust width as needed
                                                height: 24, // Adjust height as needed
                                                color: Constant.bgLight,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text('${widget.data.nearbyLocations!.movieTheater![index].address.toString()}', style: TextStyle(color: Colors.grey)),
                                        SizedBox(height: 10,)
                                      ],
                                    );
                                  },),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ),


              // TabBarView(
              //   children: [
              //     restaurant(),
              //     // hospital(),
              //     // train_station(),
              //     // supermarket(),
              //     // movie_theater(),
              //   ],
              // ),
              /*DefaultTabController(
                  length: 5,
                  child: TabBar(tabs: [
                    Text('restaurant'),
                    Text('hospital'),
                    Text('train_station'),
                    Text('supermarket'),
                    Text('movie_theater'),
                  ],
                  ),


              ),*/

              const SizedBox(height: 20,),

              BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  if(state is ReviewLoading){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if(state is ReviewSuccess){
                    return state.reviewModel.data!.isEmpty ? SizedBox() :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text('Ratings & Reviews',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          // height: state.reviewModel.data?.length == 1 ? 200 : 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: state.reviewModel.data?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          child: Center(child: Text(state.reviewModel.data![index].residentName.toString().substring(0, 1)),),
                                        ),
                                        title: Text(state.reviewModel.data![index].residentName.toString(), style: TextStyle(fontSize: 15),),
                                        subtitle: RatingBarIndicator(
                                          rating: (int.parse(state.reviewModel.data![index].rating.toString())).toDouble(), // Use the rating value from the property
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                        ),
                                        trailing: Text(state.reviewModel.data![index].insertedDate.toString()),
                                      ),
                                      // SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 75.0),
                                        child: Text(state.reviewModel.data![index].discription.toString()),
                                      ),
                                      SizedBox(height: 10,),

                                    ]

                                ),
                              );
                            },),
                        ),
                      ],
                    );
                  }
                  if(state is ReviewError){
                    return Center(child: Text(state.error),);
                  }
                  return SizedBox();

                },
              ),


              const SizedBox(height: 20,),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey,
                  blurRadius: 1.5,
                )],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                branchId = widget.data.branchId;
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("branchId");
                mobile_no = pref.getString('mobile_no');
                name = pref.getString('name');
                email = pref.getString('email');
                // message = pref.getString('message');
                pref.setString('branchId', branchId!);
                if (widget.data.interested == 0) {

                  if(mobile_no.toString().isNotEmpty && mobile_no != null){
                    messageDialog();


                  }else{
                    Navigator.pushNamed(context, Interested.id);
                  }
                }
                else {
                  // You can provide an alternative action here, or leave it as null for no action
                }
              },
              child: BottomAppBar(
                height: 50,
                color: Colors.transparent,
                padding: EdgeInsets.zero,
                surfaceTintColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        color: widget.data.interested == 0 ? Constant.bgButton : Colors.grey,
                        ),
                        child: Center(child: Text(widget.data.interested == 0 ? 'I am Interested' : 'Request already submitted', style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
            ),
      );
  }
  messageDialog(){
    TextEditingController messageController = TextEditingController();
    // showDialog(context: context, builder: AlertDialog())
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Container(
                  // width: 350,
                  child: AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: const Text("Remark",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    content: TextFormField(
                      expands: false,
                      maxLines: 4,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          // borderSide: BorderSide.none
                        )

                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Please enter message';
                        }
                        return null;
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child: const Text("Cancel",
                              style: TextStyle(
                                  color: Color(
                                      0xffc56c86)))),
                      TextButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            /*isLogin = pref.getBool('isLoggedIn');
                            if(isLogin == true){
                              await API.bookNow(name.toString(), email.toString(), email.toString(), messageController.text, branchId!).then((value) {
                                if(value['success'] == 1){
                                  messageDialog();
                                  // Navigator.pushNamed(context, Interested.id);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoLogin()), (route) => false);
                                }
                              });
                            }*/
                            process = true;
                            setState(() {

                            });
                            Common.showDialogLoading(context);
                            // showDialog(context: context, builder: (context) {
                            //
                            //   return Visibility(
                            //     visible: process == true ? true : false,
                            //     child: AlertDialog(
                            //       elevation: 0.0,
                            //       backgroundColor:Colors.transparent,
                            //       // shape: RoundedRectangleBorder(
                            //       //     borderRadius: BorderRadius.all(Radius.circular(20))),
                            //       // // contentPadding: EdgeInsets.all(24),
                            //       insetPadding: EdgeInsets.symmetric(horizontal: 155),
                            //       content: Container(
                            //           color: Colors.transparent,
                            //           height: 40,
                            //           width: 40,
                            //           child: CircularProgressIndicator()),
                            //     ),
                            //   );
                            // },);
                            await API.bookNow(name.toString(), email.toString(), mobile_no.toString(), messageController.text, branchId!).then((value) {
                              if(value['success'] == 1){
                                // messageDialog();

                                // Navigator.pushNamed(context, Interested.id);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                thankyouBottomSheet();
                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                // if(branchId == 0 || branchId == '0'){
                                //
                                //   Navigator.pop(context);
                                //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoLogin()), (route) => false);
                                // }else{
                                //
                                //   BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                                //   Navigator.pop(context);
                                //   Navigator.pop(context);
                                //   Navigator.pop(context);
                                //   Navigator.pop(context);
                                // }
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Constant.bgButton,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Center(
                            child: Text("Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  bool bottomSheet = false;

    Future<void> thankyouBottomSheet()
    {
      bottomSheet = true;
      return showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Prevents closing the bottom sheet with back button
              return false;
            },
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset('assets/interested/interested_page.svg'),
                    const Text('Thank you for showing Interest!', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('We have shared your details with the property owner they will contact you soon!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500, fontSize: 15),),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Constant.bgTile),
                          child: const Text('Close', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w500),),
                          onPressed: () {
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                            if(branchId == 0 || branchId == '0'){

                              // Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoLogin()), (route) => false);
                            }else{

                              BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }




}
