

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:roomertenant/model/ExploreModel.dart';
import 'package:image/image.dart' as img;

import '../constant/constant.dart';
import 'explore_bloc/explore_bloc.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  var searchController = TextEditingController();
  List<Marker> _marker = [];
  List<Circle> _circles = [];
  LatLng? currentPosition;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
  }

  double _latitude = 0.0;
  double _longitude =0.0;

  List<Property> _nearbyAddresses = [];
  String _searchedAddress = '';
  List<dynamic> _placesLists = [];
  Property? _selectedProperty;
  var uuid = Uuid();
  String _sessionToken = '122344';
  int currentIndexPage = 0;
  var _carouselController;

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  Future<BitmapDescriptor> resizeImageAsset(String asset, int width, int height) async {
    ByteData data = await rootBundle.load(asset);
    Uint8List bytes = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }

    img.Image resizedImage = img.copyResize(image, width: width, height: height);
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  void addCustomIcon() {
    resizeImageAsset("assets/explore/dotLocation.png", 30, 30).then(
          (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return _nearbyAddresses.map((address) => address.toString()).join('\n');
  }

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
              if (distance <= 1.0) { // Filter addresses within a 5 km radius
                nearbyAddresses.add(property);
              }
            } catch (e) {
              // Handle case where parsing fails
              print('Error parsing latitude or longitude: $e');
            }
          }
        }

        // Update the UI with nearby addresses
      //   setState(() {
      //     _searchedAddress = searchController.text;
      //     _nearbyAddresses = nearbyAddresses;
      //     print('nearby addresses: $_nearbyAddresses');
      //   });
      // }
        setState(() {
          _searchedAddress = searchController.text;
          _nearbyAddresses = nearbyAddresses;
          _marker = nearbyAddresses.map((property) {
            return Marker(
              markerId: MarkerId(property.branchName.toString()),
              position: LatLng(double.parse(property.latitude!), double.parse(property.longitude!)),
              infoWindow: InfoWindow(title: property.branchName, snippet: property.branchAddress),
              icon: markerIcon,
              onTap: (){
                Future.delayed(Duration(seconds: 1)).then((value) {
                  _showPropertyList(context, property);
                });
              }
            );
          }).toList();


          _circles = [
            Circle(
              circleId: CircleId('searchedLocationCircle'),
              center: LatLng(_latitude, _longitude),
              radius: 1000,
              fillColor: Colors.blue.withOpacity(0.1),
              strokeColor: Colors.blue,
              strokeWidth: 1
            )
          ];


          print('search address length -- ${_nearbyAddresses.length}');
          print('markers -- ${_marker}');
        });

        // Update the map to show all markers
        if (_marker.isNotEmpty) {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLngBounds(
            _getLatLngBounds(_marker),
            50.0, // Padding
          ));
          print('set marker ${location}');
        }
      }
      else {
        setState(() {
          // Handle case when location is not found
        });
      }
    }
    catch (e) {
      setState(() {
        // Handle error
      });
      print('Error: $e');
    }
  }

  LatLngBounds _getLatLngBounds(List<Marker> markers) {
    final southwest = LatLng(
      markers.map((m) => m.position.latitude).reduce((a, b) => a < b ? a : b),
      markers.map((m) => m.position.longitude).reduce((a, b) => a < b ? a : b),
    );
    final northeast = LatLng(
      markers.map((m) => m.position.latitude).reduce((a, b) => a > b ? a : b),
      markers.map((m) => m.position.longitude).reduce((a, b) => a > b ? a : b),
    );
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }


  void getSuggestion(String input) async {

    // Check if the input length is at least 3 characters
    if (input.length < 3) {
      // Clear the suggestions list if input length is less than 3
      setState(() {
        _placesLists = [];
      });
      return; // Exit the function
    }

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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.92, 75.77),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Search on Map',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
      // Container
      Positioned(
        top: 85,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
          ),
          child: Column(
            children: [
              const SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) {
                      if(state is ExploreSuccess){
                        return GooglePlaceAutoCompleteTextField(
                          textEditingController: searchController,
                          googleAPIKey: "AIzaSyBBLKXOkLw9JxYbGe3MYNeB032s8ntci1c",
                          inputDecoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: ' Search by City/PG Name/Locality',
                            contentPadding: EdgeInsets.symmetric(horizontal: 20,),
                            hintStyle: TextStyle(color: Color(0xff6F7894), fontSize: 14, fontWeight: FontWeight.w400,),
                          ),
                          debounceTime: 800,
                          countries: ["in"],
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) async {
                            // This callback is called when isLatLngRequired is true and the place details are returned with lat/lng
                            double lat = double.parse(prediction.lat.toString());
                            double lng = double.parse(prediction.lng.toString());
                            LatLng selectedPlace = LatLng(lat, lng);

                            // setState(() {
                            //   _marker = [
                            //     Marker(
                            //       markerId: MarkerId('searchedLocation'),
                            //       position: selectedPlace,
                            //       infoWindow: InfoWindow(title: prediction.description),
                            //       // onTap: (){
                            //       //   _showPropertyList(context, _nearbyAddresses);
                            //       // }
                            //     ),
                            //   ];
                            // });

                            GoogleMapController controller = await _controller.future;
                            controller.animateCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: selectedPlace,
                                zoom: 14,
                              ),
                            ));
                          },
                          itemClick: (Prediction prediction) {
                            searchController.text = prediction.description!;
                            searchController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
                            _searchLocation(searchController.text.toString(), state.exploreModel.property!);
                          },
                          itemBuilder: (context, index, Prediction prediction) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  const SizedBox(width: 7),
                                  Expanded(child: Text(prediction.description ?? "")),
                                ],
                              ),
                            );
                          },
                          seperatedBuilder: Divider(),
                          isCrossBtnShown: true,
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ),
              // const SizedBox(height: 40,),
              Expanded(
                child: Container(
                  // height: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(_marker),
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onTap: (LatLng latLng){
                        setState(() {
                          _selectedProperty = null;
                        });
                      },
                      circles: Set<Circle>.of(_circles),
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
      )
        ],

      ),
    );
  }

  void _showPropertyList(BuildContext context, Property properties) {
    final tagName = properties.pgOccupancy!;
    final split = tagName.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            // final property = properties[index];
            return Container(
              color: Colors.white,
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
                                    itemCount: properties.propertyImage!.length,
                                    carouselController: _carouselController,
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
                                                        itemCount: properties.propertyImage!.length,
                                                        itemBuilder: (context, index, realIdx) {
                                                          return PhotoView(
                                                            imageProvider: CachedNetworkImageProvider(properties.propertyImage![index].imagePath.toString()),
                                                            minScale: PhotoViewComputedScale.contained * 1.2,
                                                            maxScale: PhotoViewComputedScale.covered * 2.5,
                                                            initialScale: PhotoViewComputedScale.contained *1.2,
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
                                                          )
                                                      ),
                                                    ),
                                                  ]
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                          decoration: const BoxDecoration(
                                          ),
                                          child: Image.network(properties.propertyImage![index].imagePath!, fit: BoxFit.cover,
                                              filterQuality: FilterQuality.none,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                              }
                                          ),
                                        ),
                                      );
                                    }
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

                                    properties.lastWeekViews!.isNotEmpty ? Container(
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
                                              Text(properties.lastWeekViews.toString(), style: const TextStyle(fontSize: 12, color: Colors.white70),),
                                            ],
                                          ),
                                        )) : SizedBox()
                                  ],
                                ),
                              )
                          ),
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
                                child: Text(properties.branchName!,
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
                                  child: Text(properties.pgType.toString()),
                                ),
                              )
                            ],
                          ),
                          properties.cityName!.isNotEmpty
                              ? Row(
                            children: [
                              Icon(Icons.star, color: Constant.bgText, size: 15,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(properties.ratingPercentage.toString()),
                              ),
                              SvgPicture.asset('assets/explore/locationmini.svg'),
                              Text(properties.cityName??'', style: const TextStyle(color: Color(0xff717D96)),),
                            ],
                          ) : SizedBox(),


                          const SizedBox(height: 10,),
                          Text(properties.branchAddress.toString()),
                          const SizedBox(height: 20,),
                          const Text('Per month rent starting from', style: TextStyle(color: Colors.grey),),
                          Text('\u{20B9}${formatRentRange(properties.rentRange.toString())/*widget.data.rentRange*/}',
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
                                        ],
                                      ),
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
                                  properties.branchAmenities!.length
                                  , (index) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                decoration: BoxDecoration(
                                    color: Constant.bgTile,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(properties.branchAmenities![index].amenities.toString(), style: TextStyle(color: Constant.bgText),),
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
                      properties.propertyTermsCondition!.map<Widget>((rules){
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
                                    itemCount: properties.nearbyLocations?.restaurant?.length != 0 ? properties.nearbyLocations?.restaurant?.length : 1,
                                    itemBuilder: (context, index) {
                                      print('restaurant -- ${properties.nearbyLocations!.restaurant!}');
                                      return properties.nearbyLocations!.restaurant!.isEmpty ? const Center(child: Text('No Place found')) : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(width: 10,),
                                              Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Text('• ${properties.nearbyLocations!.restaurant![index].name.toString()}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                              const SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  print(properties.nearbyLocations!.restaurant![index].latitude.toString());
                                                  print(properties.nearbyLocations!.restaurant![index].longitude.toString());
                                                  openMap(double.parse(properties.nearbyLocations!.restaurant![index].latitude.toString()), double.parse(properties.nearbyLocations!.restaurant![index].longitude.toString()));
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
                                          Text('${properties.nearbyLocations!.restaurant![index].address.toString()}', style: const TextStyle(color: Colors.grey)),
                                          const SizedBox(height: 10,)
                                        ],
                                      );
                                    },),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: properties.nearbyLocations?.hospital?.length != 0 ? properties.nearbyLocations?.hospital?.length : 1,
                                    itemBuilder: (context, index) {
                                      return properties.nearbyLocations!.hospital!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Text('• ${properties.nearbyLocations!.hospital![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  print(properties.nearbyLocations!.hospital![index].latitude.toString());
                                                  print(properties.nearbyLocations!.hospital![index].longitude.toString());
                                                  openMap(double.parse(properties.nearbyLocations!.hospital![index].latitude.toString()), double.parse(properties.nearbyLocations!.hospital![index].longitude.toString()));
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
                                          Text('${properties.nearbyLocations!.hospital![index].address.toString()}', style: TextStyle(color: Colors.grey)),
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
                                    itemCount: properties.nearbyLocations?.trainStation?.length != 0 ? properties.nearbyLocations?.trainStation?.length : 1,
                                    itemBuilder: (context, index) {
                                      return properties.nearbyLocations!.trainStation!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Text('• ${properties.nearbyLocations!.trainStation![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  print(properties.nearbyLocations!.trainStation![index].latitude.toString());
                                                  print(properties.nearbyLocations!.trainStation![index].longitude.toString());
                                                  openMap(double.parse(properties.nearbyLocations!.trainStation![index].latitude.toString()), double.parse(properties.nearbyLocations!.trainStation![index].longitude.toString()));
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
                                          Text('${properties.nearbyLocations!.trainStation![index].address.toString()}', style: TextStyle(color: Colors.grey)),
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
                                    itemCount: properties.nearbyLocations?.supermarket?.length != 0 ? properties.nearbyLocations?.supermarket?.length : 1,
                                    itemBuilder: (context, index) {
                                      return properties.nearbyLocations!.supermarket!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Text('• ${properties.nearbyLocations!.supermarket![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  print(properties.nearbyLocations!.supermarket![index].latitude.toString());
                                                  print(properties.nearbyLocations!.supermarket![index].longitude.toString());
                                                  openMap(double.parse(properties.nearbyLocations!.supermarket![index].latitude.toString()), double.parse(properties.nearbyLocations!.supermarket![index].longitude.toString()));
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
                                          Text('${properties.nearbyLocations!.supermarket![index].address.toString()}', style: TextStyle(color: Colors.grey)),
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
                                    itemCount: properties.nearbyLocations?.movieTheater?.length != 0 ? properties.nearbyLocations?.movieTheater?.length : 1,
                                    itemBuilder: (context, index) {
                                      return properties.nearbyLocations!.movieTheater!.isEmpty ? Center(child: Text('No Place found')) : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Text('• ${properties.nearbyLocations!.movieTheater![index].name.toString()}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis),)),
                                              SizedBox(width: 10,),
                                              InkWell(
                                                onTap: (){
                                                  print(properties.nearbyLocations!.movieTheater![index].latitude.toString());
                                                  print(properties.nearbyLocations!.movieTheater![index].longitude.toString());
                                                  openMap(double.parse(properties.nearbyLocations!.movieTheater![index].latitude.toString()), double.parse(properties.nearbyLocations!.movieTheater![index].longitude.toString()));
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
                                          Text('${properties.nearbyLocations!.movieTheater![index].address.toString()}', style: TextStyle(color: Colors.grey)),
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
                ],
              ),
            );
            /*ListTile(
              title: Text(properties.branchName.toString()),
              subtitle: Text('Latitude: ${properties.latitude}, Longitude: ${properties.longitude}'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                // Handle property selection if needed
              },
            );*/
          },
        );
      },
    );
  }

  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

}
