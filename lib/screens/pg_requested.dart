import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:roomertenant/screens/chat.dart';
import 'package:roomertenant/screens/explore.dart';
import 'package:roomertenant/screens/get_wishlist_bloc/get_wishlist_bloc.dart';
import 'package:roomertenant/screens/requested_pg_bloc/requested_pg_bloc.dart';
import 'package:roomertenant/screens/requested_pg_details.dart';
import 'package:roomertenant/screens/visitor_list/exploreDetails.dart';
import 'package:roomertenant/screens/wishlist_bloc/wishlist_bloc.dart';
import 'package:roomertenant/wishlist_pg_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../constant/constant.dart';
import '../model/ExploreModel.dart';
import '../model/requested_pg_model.dart';
import 'explore_bloc/explore_bloc.dart';

class PgRequested extends StatefulWidget {
  const PgRequested({super.key});

  @override
  State<PgRequested> createState() => _PgRequestedState();
}

class _PgRequestedState extends State<PgRequested>  with SingleTickerProviderStateMixin{
  String? mobile_no;
  String _identifier = '';
  late TabController _tabController;
  String? _currentAddress;
  Position? _currentPosition;
  var address;
  var wifiIP;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(handleChange);
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  handleChange(){
    setState(() {

    });
  }

// Function to format rent range
  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    mobile_no = pref.getString('mobile_no');
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

      _identifier = identifier!;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // final hasPermission = await _handleLocationPermission();
    // if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(";;;;;;;;;;;;;;;;;;"+e);
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
    BlocProvider.of<RequestedPgBloc>(context).add(RequestedPgRefreshEvent(mobile_no.toString()??''));
    BlocProvider.of<GetWishlistBloc>(context).add(GetWishlistRefreshEvent(pref.getString('branch_id').toString(), _identifier, pref.getString('login_id').toString()));
    print(mobile_no.toString());
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    print('this is stack');
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no??''));
        Navigator.pop(context);
        return Future.value(true);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Color(0xff001944),
          //   foregroundColor: Colors.white,
          //   title: Text("Terms & Conditions"),
          // ),
          body: Stack(
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
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                        BlocProvider.of<ExploreBloc>(context).add(ExploreRefreshEvent(mobile_no ?? ''));

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
                                  "My PG Selection",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20),
                                )
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
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)
                          )
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16
                            ),
                            child: Container(
                              // height: 45,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16)
                              ),

                              child: TabBar(
                                // indicator: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(
                                //     25.0,
                                //   ),
                                //   color: Constant.bgLight/*Color(0xff001944)*/,
                                // ),
                                indicatorPadding: EdgeInsets.symmetric(vertical: 2),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.white,
                                dividerColor: Colors.transparent,
                                unselectedLabelColor: Color(0xff8b8787),
                                //padding: EdgeInsets.symmetric(horizontal: 10),

                                // indicatorSize: TabBarIndicatorSize.tab,
                                // labelColor: Colors.white,
                                // unselectedLabelColor: Constant.bgLight,
                                labelPadding: EdgeInsets.symmetric(horizontal: 4),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0,),
                                  color: Color(0xff8787FF),
                                ),

                                tabs: [
                                  Tab(child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.0,),
                                // color: const Color(0xff6F7894).withOpacity(0.10),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Contacted",style: TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.w400),),
                                  const SizedBox(width: 10,),
                                  BlocBuilder<RequestedPgBloc, RequestedPgState>(builder: (context, state) {
                                    // if(state is RequestedPgLoading){
                                    //   return Center(child: CircularProgressIndicator());
                                    // }
                                    if(state is RequestedPgSuccess){
                                      return Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 25
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: _tabController.index == 0 ? Colors.white :Colors.grey.shade400,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(state.requestedPgModel.property!.length.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w400, color: _tabController.index == 0 ? Colors.black :Colors.white,),),
                                      );
                                    }
                                    // if(state is RequestedPgError){
                                    //   return Center(child: Text(state.errorMsg));
                                    // }
                                    return SizedBox();
                                  },

                                  )

                                ],
                              ),
                            ),
                                    // icon: Text('Contacted'/*, style: TextStyle(color: Colors.white)*/,),),
                                  // Tab(icon: Text('Shortlisted'/*, style: TextStyle(color: Colors.white)*/)
                                  ),
                                  Tab(child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0,),
                                      // color: const Color(0xff6F7894).withOpacity(0.10),
                                    ),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text("Shortlisted",style: TextStyle(fontSize: 12,
                                            fontWeight: FontWeight.w400),),
                                        const SizedBox(width: 10,),
                                        BlocBuilder<GetWishlistBloc, GetWishlistState>(builder: (context, state) {
                                          // if(state is GetWishlistLoading){
                                          //   return Center(child: CircularProgressIndicator(),);
                                          // }
                                          if(state is GetWishlistSuccess){
                                            return Container(
                                              constraints: const BoxConstraints(
                                                  minWidth: 25
                                              ),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: _tabController.index == 0 ? Colors.white :Colors.grey.shade400,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(state.getWishlistModel.success == 0 ? '0' : state.getWishlistModel.property!.length.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: 12,
                                                fontWeight: FontWeight.w400, color: _tabController.index == 0 ? Colors.black :Colors.white,),),
                                            );
                                          }
                                          // if(state is GetWishlistError){
                                          //   return Center(child: Text(state.error));
                                          // }
                                          return SizedBox();
                                        },

                                        )

                                      ],
                                    ),
                                  ),
                                    // icon: Text('Contacted'/*, style: TextStyle(color: Colors.white)*/,),),
                                    // Tab(icon: Text('Shortlisted'/*, style: TextStyle(color: Colors.white)*/)
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10),
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(24.0,),
                            //     color: const Color(0xff6F7894).withOpacity(0.10),
                            //   ),
                            //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //     children: [
                            //       const Text("Deleted",style: TextStyle(fontSize: 12,
                            //           fontWeight: FontWeight.w400),),
                            //       const SizedBox(width: 10,),
                            //       Container(
                            //         constraints: const BoxConstraints(
                            //             minWidth: 25
                            //         ),
                            //         padding: const EdgeInsets.all(5),
                            //         decoration: BoxDecoration(
                            //           color: _tabController.index == 2 ? Colors.white :Colors.grey.shade400,
                            //           borderRadius: BorderRadius.circular(20),
                            //         ),
                            //         child: Text(deletedComplain.length.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: 12,
                            //           fontWeight: FontWeight.w400, color: _tabController.index == 2 ? Colors.black :Colors.white,),),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                          Expanded(
                            child: Container(
                              child: TabBarView(
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Constant.bgTile,
                                                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                                              ),
                                              child: BlocBuilder<RequestedPgBloc, RequestedPgState>(builder: (context, state) {

                                                if(state is RequestedPgLoading){
                                                  return const Center(child: CircularProgressIndicator(),);
                                                }
                                                if(state is RequestedPgSuccess){
                                                  // List<Property>? leadListing = state.requestedPgModel.property!;
                                                  return /*leadListing.isEmpty? SizedBox():*/ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.requestedPgModel.property!.length,
                                                    itemBuilder: (context, index) {
                                                      // leadListing = state.requestedPgModel.property!;
                                                      return InkWell(
                                                        borderRadius: BorderRadius.circular(16),
                                                        // onTap: () {
                                                        //   Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) => /*login == true
                                                        //                       ? */ExploreDetails(
                                                        //             data: state.requestedPgModel.property![index])
                                                        //       /*: Login()*/),
                                                        //     // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
                                                        //   );
                                                        // },
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(16),
                                                            color: Colors.white,
                                                          ),
                                                          child: /*Text('\u{20B9}${4000}')*/
                                                          InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestedPgDetails(data: state.requestedPgModel.property![index])));
                                                            },
                                                            borderRadius: BorderRadius.circular(16),
                                                            child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child:
                                                                Row(
                                                                  children: [
                                                                    Stack(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 100,
                                                                          width: 100,
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(12),
                                                                            child: Image.network(state.requestedPgModel.property![index].propertyImage![0].imagePath.toString(), fit: BoxFit.fill,
                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        state.requestedPgModel.property![index].isVerified == 'Yes' ?
                                                                        Positioned(
                                                                            top: 10,
                                                                            left: 10,
                                                                            child: SvgPicture.asset('assets/verified.svg', height: 20, width: 20,)) : SizedBox(),
                                                                       Positioned(
                                                                            bottom: 5,
                                                                            right: 5,
                                                                            child: BlocListener<WishlistBloc, WishlistState>(listener: (context, state) async {
                                                                              if(state is WishlistLoading){
                                                                                Center(child: CircularProgressIndicator(color: Colors.blue,));
                                                                              }
                                                                              if(state is WishlistSuccess){
                                                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                BlocProvider.of<RequestedPgBloc>(context).add(RequestedPgRefreshEvent(mobile_no.toString()??''));
                                                                                BlocProvider.of<GetWishlistBloc>(context).add(GetWishlistRefreshEvent(pref.getString('branch_id').toString(), _identifier, pref.getString('login_id').toString()));

                                                                              }
                                                                              if(state is WishlistError){
                                                                                print(state.error);
                                                                              }

                                                                            },child:  InkWell(
                                                                              onTap: () async{
                                                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(state.requestedPgModel.property![index].branchId.toString(),
                                                                                    pref.getString('login_id').toString(), _identifier, wifiIP??'', _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address));
                                                                                print('branchId--${state.requestedPgModel.property![index].branchId.toString()}');
                                                                                print("tenantID--${pref.getString('login_id').toString()}");
                                                                                print('imei--$_identifier');
                                                                                print('IP--$wifiIP');
                                                                                print("lat--${_currentPosition!.latitude.toString()}");
                                                                                print("long--${_currentPosition!.longitude.toString()}");
                                                                                print(address);

                                                                                // API.addWishlist(branch_id, tenant_id, imei_no, ip_address, latitude, longitude, address);
                                                                                // like = true;

                                                                              },
                                                                              child: Icon(state.requestedPgModel.property![index].wishlist == 'Yes' ? Icons.favorite : Icons.favorite_border,
                                                                                color: state.requestedPgModel.property![index].wishlist == 'Yes'? Colors.red : Colors.grey,),
                                                                            ),
                                                                            )

                                                                        )
                                                                      ],
                                                                    ),

                                                                    const SizedBox(width: 10,),
                                                                    Expanded(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Flexible(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                                    child: Text(
                                                                                      state.requestedPgModel.property![index].branchName!,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: const TextStyle(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          fontFamily: 'Product Sans',
                                                                                          fontSize: 16),
                                                                                    ),
                                                                                  )),
                                                                              Text(
                                                                                '\u{20B9}${formatRentRange(state.requestedPgModel.property![index].rentRange.toString())??''}',
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
                                                                              state.requestedPgModel.property![index].cityName == null || state.requestedPgModel.property![index].cityName.toString().isEmpty
                                                                                  ? SizedBox()
                                                                                  : Row(
                                                                                children: [
                                                                                  /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                ? SizedBox()
                                                                : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                                  Text(
                                                                                    /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                  ? ''
                                                                  : */state.requestedPgModel.property![index].cityName.toString() ,
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
                                                                            child: Text(state.requestedPgModel.property![index].branchAddress.toString(),
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
                                                                                child: Wrap(
                                                                                  children: List.generate(
                                                                                    state.requestedPgModel.property![index].branchAmenities!.length > 2
                                                                                        ? 2
                                                                                        : state.requestedPgModel.property![index].branchAmenities!.length,
                                                                                        (idx) {
                                                                                      String amenity = state.requestedPgModel.property![index].branchAmenities![idx].amenities.toString();
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
                                                                              ),
                                                                              InkWell(
                                                                                onTap: (){
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                                                      ChatScreen(state.requestedPgModel.property![index].branchName.toString(),
                                                                                          state.requestedPgModel.property![index].pgProfileImg.toString()/*state.requestedPgModel.property![index].propertyImage![0].imagePath.toString()*/,
                                                                                          state.requestedPgModel.property![index].branchId.toString(),
                                                                                          state.requestedPgModel.property![index].contactNumber.toString())));
                                                                                },
                                                                                  child: Icon(Icons.chat, color: Constant.bgLight))
                                                                            ],
                                                                          ),
                                                                          // const SizedBox(height: 10,),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },);
                                                }
                                                if(state is RequestedPgError){
                                                  return Center(child: Text(state.errorMsg),);
                                                }
                                                return SizedBox();
                                              },)

                                          )
                                      )],
                                  ),
                                  Stack(
                                    children: [
                                      Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Constant.bgTile,
                                                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                                              ),
                                              child: BlocBuilder<GetWishlistBloc, GetWishlistState>(builder: (context, state) {

                                                if(state is GetWishlistLoading){
                                                  return const Center(child: CircularProgressIndicator(),);
                                                }
                                                if(state is GetWishlistSuccess){
                                                  // List<Property>? leadListing = state.requestedPgModel.property!;
                                                  return state.getWishlistModel.success == 0 ? Center(child: Text('0 PG Shortlisted')) : ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.getWishlistModel.property!.length,
                                                    itemBuilder: (context, index) {
                                                      // leadListing = state.requestedPgModel.property!;
                                                      return InkWell(
                                                        borderRadius: BorderRadius.circular(16),
                                                        // onTap: () {
                                                        //   Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) => /*login == true
                                                        //                       ? */ExploreDetails(
                                                        //             data: state.requestedPgModel.property![index])
                                                        //       /*: Login()*/),
                                                        //     // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
                                                        //   );
                                                        // },
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(16),
                                                            color: Colors.white,
                                                          ),
                                                          child: /*Text('\u{20B9}${4000}')*/
                                                          InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> WishlistPGDetails(data: state.getWishlistModel.property![index])));
                                                            },
                                                            borderRadius: BorderRadius.circular(16),
                                                            child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child:
                                                                Row(
                                                                  children: [
                                                                    Stack(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 100,
                                                                          width: 100,
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(12),
                                                                            child: Image.network(state.getWishlistModel.property![index].propertyImage![0].imagePath.toString(), fit: BoxFit.fill,
                                                                              errorBuilder: (context, error, stackTrace) {
                                                                                return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        state.getWishlistModel.property![index].isVerified == 'Yes' ?
                                                                        Positioned(
                                                                            top: 10,
                                                                            left: 10,
                                                                            child: SvgPicture.asset('assets/verified.svg', height: 20, width: 20,)) : SizedBox(),
                                                                        Positioned(
                                                                            bottom: 5,
                                                                            right: 5,
                                                                            child: BlocListener<WishlistBloc, WishlistState>(listener: (context, state) async {
                                                                              if(state is WishlistLoading){
                                                                                Center(child: CircularProgressIndicator(color: Colors.blue,));
                                                                              }
                                                                              if(state is WishlistSuccess){
                                                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                BlocProvider.of<RequestedPgBloc>(context).add(RequestedPgRefreshEvent(mobile_no.toString()));
                                                                                BlocProvider.of<GetWishlistBloc>(context).add(GetWishlistRefreshEvent(pref.getString('branch_id').toString(), _identifier, pref.getString('login_id').toString()));

                                                                              }
                                                                              if(state is WishlistError){
                                                                                print(state.error);
                                                                              }

                                                                            },child:  InkWell(
                                                                              onTap: () async{
                                                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                BlocProvider.of<WishlistBloc>(context).add(WishlistRefreshEvent(state.getWishlistModel.property![index].branchId.toString(),
                                                                                    pref.getString('login_id').toString(), _identifier, wifiIP??'', _currentPosition!.latitude.toString(), _currentPosition!.longitude.toString(), address));
                                                                                print('branchId--${state.getWishlistModel.property![index].branchId.toString()}');
                                                                                print("tenantID--${pref.getString('login_id').toString()}");
                                                                                print('imei--$_identifier');
                                                                                print('IP--$wifiIP');
                                                                                print("lat--${_currentPosition!.latitude.toString()}");
                                                                                print("long--${_currentPosition!.longitude.toString()}");
                                                                                print(address);

                                                                                // API.addWishlist(branch_id, tenant_id, imei_no, ip_address, latitude, longitude, address);
                                                                                // like = true;

                                                                              },
                                                                              child: Icon(/*state.getWishlistModel.property![index].wishlist == 'Yes' ? */Icons.favorite /*: Icons.favorite_border*/,
                                                                                color: /*state.getWishlistModel.property![index].wishlist == 'Yes'?*/ Colors.red /*: Colors.grey,*/),
                                                                            ),
                                                                            )

                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(width: 10,),
                                                                    Expanded(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Flexible(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                                    child: Text(
                                                                                      state.getWishlistModel.property![index].branchName!,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: const TextStyle(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          fontFamily: 'Product Sans',
                                                                                          fontSize: 16),
                                                                                    ),
                                                                                  )),
                                                                              Text(
                                                                                '\u{20B9}${formatRentRange(state.getWishlistModel.property![index].rentRange.toString())??''}',
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
                                                                              state.getWishlistModel.property![index].cityName == null || state.getWishlistModel.property![index].cityName.toString().isEmpty
                                                                                  ? SizedBox()
                                                                                  : Row(
                                                                                children: [
                                                                                  /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                ? SizedBox()
                                                                : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                                  Text(
                                                                                    /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                  ? ''
                                                                  : */state.getWishlistModel.property![index].cityName.toString() ,
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
                                                                            child: Text(state.getWishlistModel.property![index].branchAddress.toString(),
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
                                                                                child: Wrap(
                                                                                  children: List.generate(
                                                                                    state.getWishlistModel.property![index].branchAmenities!.length > 2
                                                                                        ? 2
                                                                                        : state.getWishlistModel.property![index].branchAmenities!.length,
                                                                                        (idx) {
                                                                                      String amenity = state.getWishlistModel.property![index].branchAmenities![idx].amenities.toString();
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
                                                                              ),
                                                                              InkWell(
                                                                                  onTap: (){
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                                                        ChatScreen(state.getWishlistModel.property![index].branchName.toString(),
                                                                                           /* state.getWishlistModel.property![index].pgProfileImg.toString()*/state.getWishlistModel.property![index].propertyImage![0].imagePath.toString(),
                                                                                            state.getWishlistModel.property![index].branchId.toString(),
                                                                                            state.getWishlistModel.property![index].contactNumber.toString())));
                                                                                  },
                                                                                  child: Icon(Icons.chat, color: Constant.bgLight))
                                                                            ],
                                                                          ),
                                                                          // const SizedBox(height: 10,),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },);
                                                }
                                                if(state is GetWishlistError){
                                                  return Center(child: Text(state.error),);
                                                }
                                                return SizedBox();
                                              },)

                                          )
                                      )],
                                  ),
                                  /*Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child:Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(textList.length, (index) =>
                                                Card(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
                                                    child: Text(
                                                      textList[index].term.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(pdfList.length, (index) {
                                            print(pdfList[index].url.toString()+pdfList[index].tcPdf.toString());
                                            print(pdfList[index].tcPdf.toString());
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "* T & C Updated on ${pdfList[index].updatedAt.toString().split("T")[0]}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    showDialog<String>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      barrierLabel: MaterialLocalizations.of(context)
                                                          .modalBarrierDismissLabel,
                                                      builder: (BuildContext context) => WillPopScope(
                                                        onWillPop: () async => false,
                                                        child: AlertDialog(
                                                          elevation: 0,
                                                          backgroundColor: Colors.transparent,
                                                          content: Container(
                                                            child: Image.asset(
                                                                'assets/images/loading_anim.gif'),
                                                            height: 100,
                                                          ),
                                                        ),
                                                      ),
                                                    );

                                                    await openFile(
                                                      url: pdfList[index].url.toString()+"/"+pdfList[index].tcPdf.toString(),
                                                      fileName:"btroomer_terms_${DateTime.now().toString().split(" ")[0]}.pdf",
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Icon(
                                                    Icons.file_download_outlined,
                                                    size: 30,
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                        ),
                                      ) ,
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),]
          ),

        ),
      ),
    );
      Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Constant.bgLight,
            // title: const Text('TabBar Sample'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Text('Requested PG', style: TextStyle(color: Colors.white),)
                ),
                Tab(
                  icon: Text('Wishlist', style: TextStyle(color: Colors.white))
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Stack(
                children: [
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     height: 120,
                  //     color: Constant.bgLight,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                  //       child: Row(
                  //         children: [
                  //           InkWell(
                  //               onTap: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               child: const Icon(
                  //                 Icons.arrow_back_ios,
                  //                 size: 18,
                  //                 color: Colors.white,
                  //               )),
                  //           const SizedBox(
                  //             width: 20,
                  //           ),
                  //           const Text(
                  //             'Requested Pg',
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Colors.white,
                  //                 fontSize: 20),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Constant.bgTile,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                              ),
                              child: BlocBuilder<RequestedPgBloc, RequestedPgState>(builder: (context, state) {

                                if(state is RequestedPgLoading){
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                                if(state is RequestedPgSuccess){
                                  // List<Property>? leadListing = state.requestedPgModel.property!;
                                  return /*leadListing.isEmpty? SizedBox():*/ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: state.requestedPgModel.property!.length,
                                    itemBuilder: (context, index) {
                                      // leadListing = state.requestedPgModel.property!;
                                      return InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        // onTap: () {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => /*login == true
                                        //                       ? */ExploreDetails(
                                        //             data: state.requestedPgModel.property![index])
                                        //       /*: Login()*/),
                                        //     // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
                                        //   );
                                        // },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Colors.white,
                                          ),
                                          child: /*Text('\u{20B9}${4000}')*/
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> RequestedPgDetails(data: state.requestedPgModel.property![index])));
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(state.requestedPgModel.property![index].propertyImage![0].imagePath.toString(), fit: BoxFit.fill,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Text(
                                                                      state.requestedPgModel.property![index].branchName!,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: 'Product Sans',
                                                                          fontSize: 16),
                                                                    ),
                                                                  )),
                                                              Text(
                                                                '\u{20B9}${int.parse(state.requestedPgModel.property![index].rentRange.toString())??''}',
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
                                                              state.requestedPgModel.property![index].cityName == null || state.requestedPgModel.property![index].cityName.toString().isEmpty
                                                                  ? SizedBox()
                                                                  : Row(
                                                                children: [
                                                                  /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                  ? SizedBox()
                                                                  : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                  Text(
                                                                    /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                    ? ''
                                                                    : */state.requestedPgModel.property![index].cityName.toString() ,
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
                                                            child: Text(state.requestedPgModel.property![index].branchAddress.toString(),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(0xff6F7894),
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ),
                                                          // Text(leadListing[index].pgType!),
                                                          // const SizedBox(height: 10,),
                                                          Wrap(
                                                            children: List.generate(
                                                              state.requestedPgModel.property![index].branchAmenities!.length > 2
                                                                  ? 2
                                                                  : state.requestedPgModel.property![index].branchAmenities!.length,
                                                                  (idx) {
                                                                String amenity = state.requestedPgModel.property![index].branchAmenities![idx].amenities.toString();
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
                                                          // const SizedBox(height: 10,),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                      );
                                    },);
                                }
                                if(state is RequestedPgError){
                                  return Center(child: Text(state.errorMsg),);
                                }
                                return SizedBox();
                              },)

                          )
                      )
                  )],
              ),
              Stack(
                children: [
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     height: 120,
                  //     color: Constant.bgLight,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                  //       child: Row(
                  //         children: [
                  //           InkWell(
                  //               onTap: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               child: const Icon(
                  //                 Icons.arrow_back_ios,
                  //                 size: 18,
                  //                 color: Colors.white,
                  //               )),
                  //           const SizedBox(
                  //             width: 20,
                  //           ),
                  //           const Text(
                  //             'Requested Pg',
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Colors.white,
                  //                 fontSize: 20),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Constant.bgTile,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                              ),
                              child: BlocBuilder<GetWishlistBloc, GetWishlistState>(builder: (context, state) {

                                if(state is GetWishlistLoading){
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                                if(state is GetWishlistSuccess){
                                  // List<Property>? leadListing = state.requestedPgModel.property!;
                                  return /*leadListing.isEmpty? SizedBox():*/ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: state.getWishlistModel.property!.length,
                                    itemBuilder: (context, index) {
                                      // leadListing = state.requestedPgModel.property!;
                                      return InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        // onTap: () {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => /*login == true
                                        //                       ? */ExploreDetails(
                                        //             data: state.requestedPgModel.property![index])
                                        //       /*: Login()*/),
                                        //     // context, MaterialPageRoute(builder: (context) => login == true ? ExploreDetails(data: _foundUser[index]) : Login()),
                                        //   );
                                        // },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Colors.white,
                                          ),
                                          child: /*Text('\u{20B9}${4000}')*/
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> WishlistPGDetails(data: state.getWishlistModel.property![index])));
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(state.getWishlistModel.property![index].propertyImage![0].imagePath.toString(), fit: BoxFit.fill,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Image.asset('assets/explore/placeholder.png', color: Colors.black, fit: BoxFit.fill,);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Text(
                                                                      state.getWishlistModel.property![index].branchName!,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: 'Product Sans',
                                                                          fontSize: 16),
                                                                    ),
                                                                  )),
                                                              Text(
                                                                '\u{20B9}${int.parse(state.getWishlistModel.property![index].rentRange.toString())??''}',
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
                                                              state.getWishlistModel.property![index].cityName == null || state.getWishlistModel.property![index].cityName.toString().isEmpty
                                                                  ? SizedBox()
                                                                  : Row(
                                                                children: [
                                                                  /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                  ? SizedBox()
                                                                  : */SvgPicture.asset('assets/explore/locationmini.svg'),
                                                                  Text(
                                                                    /*leadListing[index].cityName.toString() == '' && leadListing[index].cityName.toString() == 'null' && leadListing[index].cityName == null
                                                                    ? ''
                                                                    : */state.getWishlistModel.property![index].cityName.toString() ,
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
                                                            child: Text(state.getWishlistModel.property![index].branchAddress.toString(),
                                                              maxLines: 1, overflow: TextOverflow.ellipsis,style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(0xff6F7894),
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ),
                                                          // Text(leadListing[index].pgType!),
                                                          // const SizedBox(height: 10,),
                                                          Wrap(
                                                            children: List.generate(
                                                              state.getWishlistModel.property![index].branchAmenities!.length > 2
                                                                  ? 2
                                                                  : state.getWishlistModel.property![index].branchAmenities!.length,
                                                                  (idx) {
                                                                String amenity = state.getWishlistModel.property![index].branchAmenities![idx].amenities.toString();
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
                                                          // const SizedBox(height: 10,),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                      );
                                    },);
                                }
                                if(state is GetWishlistError){
                                  return Center(child: Text(state.error),);
                                }
                                return SizedBox();
                              },)

                          )
                      )
                  )],
              ),
            ],
          ),
        ),
      )

    );
  }
}
