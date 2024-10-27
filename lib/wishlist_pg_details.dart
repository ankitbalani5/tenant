import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:roomertenant/model/requested_pg_model.dart';
import 'package:roomertenant/screens/explore_bloc/explore_bloc.dart';
import 'package:roomertenant/screens/get_wishlist_bloc/get_wishlist_bloc.dart';
import 'package:roomertenant/screens/no_login.dart';
import 'package:roomertenant/screens/wishlist_bloc/wishlist_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';
import '../model/ExploreModel.dart';
import 'model/get_wishlist_model.dart';

class WishlistPGDetails extends StatefulWidget {
  final GetWishlistProperty data;
  const WishlistPGDetails({Key? key, required this.data});

  @override
  State<WishlistPGDetails> createState() => _RequestedPgDetailsState();
}

class _RequestedPgDetailsState extends State<WishlistPGDetails> {

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

  // Function to format rent range
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }

  refreshData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    BlocProvider.of<GetWishlistBloc>(context).add(GetWishlistRefreshEvent(pref.getString('branch_id').toString(), _identifier, pref.getString('login_id').toString()));

  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
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
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return ;
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
  }

  Widget imageDialog(PropertyImage exploredetails, context) {
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
                itemCount: exploredetails.imagePath!.length,
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
                            builder: (_) => ZoomImage(
                                exploredetails.imagePath![index].toString(),
                                context));
                      },
                      child: Container(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  exploredetails.imagePath!.toString()),
                              filterQuality: FilterQuality.low,
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
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ))
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 250,
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
      Scaffold(
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
                              itemBuilder: (context, index, realIndex) {
                                return GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      barrierColor: Colors.transparent.withOpacity(0.8),
                                      builder: (context) {
                                        return Stack(
                                            children: [

                                              Positioned(
                                                child:
                                                PhotoView(
                                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                                  imageProvider: NetworkImage(widget.data.propertyImage![index].imagePath.toString()),
                                                  minScale: PhotoViewComputedScale.contained * 0.8,
                                                  maxScale: 4.0,
                                                ),),
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
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (_) => ZoomImage(widget.data.propertyImage![index].imagePath, context)
                                    // );
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
                              },
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

                      // Like
                      // Like
                      Positioned(
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
                                  refreshData();
                                  // BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                                  setState(() {

                                  });

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
                                    child: Icon(/*widget.data.wishlist=='No' ? Icons.favorite_border : */Icons.favorite, color: /*widget.data.wishlist=='No' ? Colors.white : */Colors.red,),
                                  ),
                                ),
                              ),
                              )

                          )
                      ),
                      // Positioned(
                      //   bottom: 20,
                      //     right: 20,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(20),
                      //         color: Colors.grey.shade100.withOpacity(0.3),
                      //       ),
                      //       child: GestureDetector(
                      //         onTap: (){
                      //           like = !like;
                      //           setState(() {
                      //
                      //           });
                      //         },
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(20),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Icon(like == false ? Icons.favorite_border : Icons.favorite, color: like == false ? Colors.white : Colors.red,),
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      // ),

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
                          SvgPicture.asset('assets/explore/locationmini.svg'),
                          Text(widget.data.cityName??'', style: const TextStyle(color: Color(0xff717D96)),),
                        ],
                      ) : SizedBox(),


                      const SizedBox(height: 20,),
                      const Text('Per month rent starting from', style: TextStyle(color: Colors.grey),),
                      Text('\u{20B9}${formatRentRange(widget.data.rentRange.toString())}',
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
              // ListView.builder(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: widget.data.propertyTermsCondition!.length,
              //   itemBuilder: (context, index) {
              //   return Row(
              //     children: [
              //       Flexible(
              //         child: Text("• ${widget.data.propertyTermsCondition![index].terms!}",
              //           style: TextStyle(fontWeight: FontWeight.w500),),
              //       ),
              //     ],
              //   );
              // },),
              const SizedBox(height: 20,),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(color: Colors.grey,
        //         blurRadius: 1.5,
        //       )],
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: InkWell(
        //       onTap: () async {
        //         branchId = widget.data.branchId;
        //         SharedPreferences pref = await SharedPreferences.getInstance();
        //         pref.remove("branchId");
        //         mobile_no = pref.getString('mobile_no');
        //         name = pref.getString('name');
        //         email = pref.getString('email');
        //         // message = pref.getString('message');
        //         pref.setString('branchId', branchId!);
        //         if (widget.data.interested == 0) {
        //
        //           if(mobile_no.toString().isNotEmpty && mobile_no != null){
        //             messageDialog();
        //
        //
        //           }else{
        //             Navigator.pushNamed(context, Interested.id);
        //           }
        //         }
        //         else {
        //           // You can provide an alternative action here, or leave it as null for no action
        //         }
        //       },
        //       child: BottomAppBar(
        //         height: 50,
        //         color: Colors.transparent,
        //         padding: EdgeInsets.zero,
        //         surfaceTintColor: Colors.white,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Expanded(
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(20),
        //                   color: widget.data.interested == 0 ? Constant.bgButton : Colors.grey,
        //                 ),
        //                 child: Center(child: Text(widget.data.interested == 0 ? 'I am Interested' : 'Request already submitted', style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),)),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // )
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
                            // showDialog(context: context, builder: (context) {
                            //   process = true;
                            //   setState(() {
                            //
                            //   });
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
                                messageDialog();
                                // Navigator.pushNamed(context, Interested.id);
                                thankyouBottomSheet();
                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                if(branchId == 0 || branchId == '0'){
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoLogin()), (route) => false);
                                }else{
                                  BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
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


  Future<void> thankyouBottomSheet()
  {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
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
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
