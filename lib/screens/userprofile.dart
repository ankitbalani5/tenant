import 'dart:io';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:roomertenant/api/providerfuction.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/model/terms_model.dart';
import 'package:roomertenant/model/user_model.dart';
import 'package:roomertenant/screens/change_password.dart';
import 'package:roomertenant/screens/eqaro.dart';
import 'package:roomertenant/screens/forgot_password.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/notice_period.dart';
import 'package:roomertenant/screens/pg_requested.dart';
import 'package:roomertenant/screens/profileimageview.dart';
import 'package:roomertenant/screens/search.dart';
import 'package:roomertenant/screens/tenant_rating.dart';
import 'package:roomertenant/screens/terms_conditions.dart';
import 'package:roomertenant/widgets/usercard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/apitget.dart';
import '../model/user_model.dart';
import '../model/user_model.dart';
import '../utils/common.dart';
import '../utils/utils.dart';
import 'Visitors_details.dart';
import 'chat.dart';
import 'home_bloc/home_bloc.dart';
import 'internet_check.dart';
import 'login.dart';
import 'logout_otp_tenant_bloc/logout_otp_tenant_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'no_login.dart';

class UserProfileApp extends StatefulWidget {
  const UserProfileApp({Key? key}) : super(key: key);
  static const String id = 'UserProfile';

  @override
  _UserProfileAppState createState() => _UserProfileAppState();
}

class _UserProfileAppState extends State<UserProfileApp> {
  var _formKey = GlobalKey<FormState>();
  bool? isCurrentPassword;
  bool? isNewPassword;
  bool? isConfirmPassword;
  String? mobile_no;
  String? email_no;
  String? ratingSend;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // userProfile();

    isCurrentPassword = false;
    isNewPassword = false;
    isConfirmPassword = false;
    super.initState();
  }

  void ImageSave(String value) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    mobile_no = pref.getString('mobile_no');
    email_no = pref.getString('email_id')=="null" || pref.getString('email_id')==""? '' : pref.getString('email_id');
    pref.setString('image', value);
    setState(() {

    });
  }

  String formatRentRange(String rent) {
    final formatter = NumberFormat('#,###');
    return formatter.format(int.parse(rent));
  }

  void _ratingBottomSheet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        showDragHandle: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 320,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)
                  )
              ),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Add Review",style: TextStyle(color: Color(0xff312F8B),fontWeight: FontWeight.w400,fontSize: 20),),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Rate your PG",
                                style: TextStyle(color: Color(0xff312F8B),fontWeight: FontWeight.w700,fontSize: 12),),
                            ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => SizedBox(
                            width: 20,
                            height: 20,
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          onRatingUpdate: (rating) {
                            ratingSend = rating.toString();
                            print(rating);
                          },
                        )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              label: Text('Write your review')
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return 'Please write the review';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              descriptionController.clear();
                                Navigator.pop(context);
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width * 0.45,
                              // decoration: BoxDecoration(
                              //     color: Color(0xff6151FF).withOpacity(0.15),
                              //     borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xff6151FF))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Center(
                                  child: Text('Cancel',
                                      style: TextStyle(color: Color(0xff6151FF), fontWeight: FontWeight.w700, fontFamily: 'Product Sans', fontSize: 16)),
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            // TODO: implement listener
                            if(state is HomeSuccess){
                              return InkWell(
                                onTap: () async {
                                  if(_formKey.currentState!.validate()){
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    var login_id = pref.getString('login_id').toString();
                                    API.ratingApi(ratingSend.toString(), descriptionController.text.toString(), state.userModel.residents![0].branchId.toString(),
                                        state.userModel.residents![0].tenantId.toString(), login_id).then((value) {
                                      if(value['success'] == 1){
                                        Navigator.pop(context);
                                        BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent(pref.getString('mobile_no').toString(),state.userModel.residents![0].branchId.toString()));
                                      }
                                    });
                                  }

                                },
                                child: Container(
                                  height: 48,
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff6151FF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xff6151FF))),
                                  child:  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Center(
                                      child: Text('Submit',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'Product Sans', fontSize: 16)),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          },
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),


                    ],
                  )
              ),
            ),
          );
        },
      );
    });
  }

  showLogoutDialog(){
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                // insetPadding:
                // const EdgeInsets.symmetric(
                //     horizontal: 10),
                // title: const Text(
                //   "Are you sure ?",
                //   style: TextStyle(
                //       fontWeight: FontWeight.normal, fontSize: 16),
                // ),
                title: Text('Logout!', style: TextStyle(color: Colors.red),),
                content: Text('Are you sure'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text("No",
                          style: TextStyle(
                              color: Colors.red))),
                  BlocListener<LogoutOtpTenantBloc, LogoutOtpTenantState>(listener: (context, state) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(state is LogoutOtpTenantLoading){
                      Common.showDialogLoading(context);
                    }
                    if(state is LogoutOtpTenantSuccess){
                      if(state.logoutOtpTenantModel.success == 1) {
                        prefs.clear();
                        setState(() {
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.logoutOtpTenantModel.details.toString()), backgroundColor: Colors.green,));
                        Navigator.pushNamedAndRemoveUntil(context, NoLogin.id, (route) => false);

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.logoutOtpTenantModel.details.toString()), backgroundColor: Colors.red,));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }
                    if(state is LogoutOtpTenantError){
                      print("Error "+state.error
                      );
                      Common.toastWarning(context, state.error);
                      Common.hideDialogLoading(context);
                    }
                  },
                    child: TextButton(
                      onPressed: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        var loginId = pref.getString('login_id');
                        BlocProvider.of<LogoutOtpTenantBloc>(context).add(LogoutOtpTenantRefreshEvent(loginId.toString()));
                        // API.logoutOtpTenant(tenantId.toString()).then((value) async{
                        //   if(value['success'] == 1) {
                        //     SharedPreferences prefs = await SharedPreferences.getInstance();
                        //     prefs.clear();
                        //     setState(() {
                        //     });
                        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                        //     Navigator.pushNamedAndRemoveUntil(context, NoLogin.id, (route) => false);
                        //
                        //   }else{
                        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                        //   }
                        // });
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.red),
                      ),
                    ),
                  )

                ],
              );
            }));
  }

  // userProfile() async{
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String branch_id = await pref.getString("branch_id").toString();
  //   NewHomeApp.userValues = await API.user(pref.getString('email').toString(),branch_id);
  //
  //   BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent(pref.getString('email').toString(),branch_id));
  // }

  Future openBottomSheetRentHistory() {
    return showModalBottomSheet(
      useRootNavigator: false,
      enableDrag: true,
      showDragHandle: true,
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height-320,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Colors.white,
        ),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if(state is HomeLoading){
            return const CircularProgressIndicator();
          }
          if(state is HomeSuccess){
            return state.userModel.accommodation == null ? const SizedBox() : ListView.builder(
              itemCount: state.userModel.accommodation!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constant.bgTile
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 220,
                              child: Text(state.userModel.accommodation![index].branch.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),)),
                          // Text('Sanika Hostel'),
                          Text(state.userModel.accommodation![index].room.toString(), style: const TextStyle(color: Colors.grey),),
                          Text('₹ ${formatRentRange(state.userModel.accommodation![index].rent.toString())}', style: const TextStyle(fontWeight: FontWeight.bold, )),

                        ],
                      ),
                      Column(
                        children: [
                          Text(state.userModel.accommodation![index].fromDate.toString(), style: const TextStyle(color: Colors.grey),),
                          // SvgPicture.asset('assets/home/download.svg',)
                        ],
                      ),

                    ],
                  ),
                );
              },);
          }
          if(state is HomeError){
            return Center(child: Text(state.error),);
          }
          return const SizedBox();
        },)

      );
    },
    );
  }

  // Function to launch the URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final imageUrl = UserModel().residents![0].image;
    // final imageUrl = UserModel().residents![0].image;
    // print('imageurl.........${imageUrl}');
    // final imageUrl = NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['image'];
    return Scaffold(
        body:
        NetworkObserverBlock(
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if(state is HomeLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(state is HomeSuccess){
            final imageUrl = state.userModel.residents![0].image ?? '';
            ImageSave(imageUrl);
            return Stack(
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
                            'Profile',
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileImageViewScreen(image: state.userModel.residents![0].image.toString())));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                        // margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                                        // padding: EdgeInsets.all(10),
                                      height: 72,
                                          width: 72,
                                          child: imageUrl != null
                                              ? Image.network(
                                                'https://mydashboard.btroomer.com/${state.userModel.residents![0].image}' ,
                      
                                                // 'https://dashboard.btroomer.com/${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['image']}' ,
                                                loadingBuilder: (context, child, loadingProgress) =>
                                                (loadingProgress == null) ? child : const CircularProgressIndicator(),
                                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                                'assets/images/man.png',
                                              color: Colors.black,
                                              fit: BoxFit.fill,
                                            ),
                                            fit: BoxFit.fill,
                                          )
                                              : Image.asset(
                                            'assets/images/man.png',
                                            color: Colors.black,
                                            fit: BoxFit.fill,
                                          ),
                                          )
                                  ),
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                              //   padding: EdgeInsets.all(10),
                              //     width: 72,
                              //     height: 72,
                              //     decoration: BoxDecoration(
                              //       border: Border.all(color: Colors.grey),
                              //       borderRadius: BorderRadius.circular(50)
                              //     ),
                              //     child:
                              //     imageUrl != null
                              //         ? Image.network(
                              //       'https://dashboard.btroomer.com/${state.userModel.residents![0].image}' ,
                              //
                              //       // 'https://dashboard.btroomer.com/${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['image']}' ,
                              //       loadingBuilder: (context, child, loadingProgress) =>
                              //       (loadingProgress == null) ? child : CircularProgressIndicator(),
                              //       errorBuilder: (context, error, stackTrace) => Image.asset(
                              //         'assets/images/man.png',
                              //         color: Colors.black,
                              //         fit: BoxFit.fill,
                              //       ),
                              //     )
                              //         : Image.asset(
                              //       'assets/images/man.png',
                              //       color: Colors.black,
                              //       fit: BoxFit.fill,
                              //     )
                              // ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.userModel.residents![0].residentName!??'',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                          fontFamily: 'Product Sans', color: Constant.bgText),),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantRating()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Constant.bgTile,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Constant.bgText, size: 20,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(state.userModel.tenantRating.toString()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // InkWell(
                //     onTap: (){
                //       Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                //     },
                //     child: Icon(Icons.search)),


                // InkWell(
                //     onTap: (){
                //       Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                //     },
                //     child: SvgPicture.asset('assets/profile/edit.svg'))
              ],
            ),

            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(mobile_no??'', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans', color: Color(0xff6F7894)), ),
                SizedBox(width: 20,),
                Text(email_no??'', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans', color: Color(0xff6F7894)),),
              ],
            )
          ],
          )

                                ),
                              ),
                              const SizedBox(height: 20,),
                      
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              height: 104,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Constant.bgTile
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 72,
                                    width: 60,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset('assets/profile/room.svg', height: 32, width: 27,),
                                        ),
                                        Container(
                                          height: 22,
                                          width: 60,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(12),
                                              bottomLeft: Radius.circular(12)),
                                              color: Constant.bgLight,
                                          ),
                                          child: Center(child: Text(state.userModel.residents![0].roomName.toString(), style: const TextStyle(color: Colors.white, fontSize: 12),)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Bed No.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans'),),
                                        Text(state.userModel.residents![0].bedName.toString(), style: const TextStyle(color: Constant.bgText, fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Product Sans')),
                                        const SizedBox(height: 10,),
                                        Text(  state.userModel.amenities != null || state.userModel.amenities!.contains('A.C.')
                                            ? 'AC room' : 'No AC room', style: const TextStyle(color: Constant.bgText, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans'))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Rent', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans'),),
                                        Text("₹ ${formatRentRange(state.userModel.residents![0].rent.toString())}", style: const TextStyle(color: Constant.bgText, fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Product Sans')),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Registered on', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans'),),
                                        Text(
                                                state.userModel.residents![0].registrationDate!, style: const TextStyle(color: Constant.bgText, fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Product Sans'),
                                        ),
                                        const SizedBox(height: 8,),
                                        // Text('Rent History ', style: TextStyle(color: Constant.bgText),),
                                        InkWell(
                                          onTap: () async {
                                            openBottomSheetRentHistory();
                                          },
                                          child: const Row(
                                            children: [
                                              Text('Rent History ', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Product Sans'),),
                                              Icon(Icons.keyboard_arrow_down, color: Constant.bgText,)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          InkWell(
                            onTap: state.userModel.residents![0].rating! == 0 ? _ratingBottomSheet : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Constant.bgTile
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Rate your PG', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w500),),
                                      // Add RatingBarIndicator here
                                      RatingBarIndicator(
                                        rating: state.userModel.residents![0].rating!.toDouble(), // Use the rating value from the property
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                      ),
                                      // RatingBar.builder(
                                      //   initialRating: 3,
                                      //   minRating: 0,
                                      //   direction: Axis.horizontal,
                                      //   allowHalfRating: true,
                                      //   itemCount: 5,
                                      //   itemSize: 20.0,
                                      //   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                      //   itemBuilder: (context, _) => SizedBox(
                                      //     width: 20,
                                      //     height: 20,
                                      //     child: Icon(
                                      //       Icons.star,
                                      //       color: Colors.amber,
                                      //     ),
                                      //   ),
                                      //   onRatingUpdate: (rating) {
                                      //     print(rating);
                                      //   },
                                      // )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Settings', style: TextStyle(fontWeight: FontWeight.w700, color: Constant.bgText, fontSize: 16),),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                                  state.userModel.residents![0].branchName.toString(), state.userModel.pgDetails!.pgProfile.toString(),
                                  state.userModel.residents![0].branchId.toString(), state.userModel.pgDetails!.contact.toString())));
                              // showChangePasswordDialog();
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Icon(Icons.chat_outlined, color: Colors.grey,)/*Image.asset('assets/selection.png', color: Colors.grey, height: 20, width: 20,)*/,
                                        ),
                                        Text(
                                          "Chat with my PG",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PgRequested()));
                              // showChangePasswordDialog();
                            },
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Image.asset('assets/selection.png', color: Colors.grey, height: 20, width: 20,),
                                        ),
                                        const Text(
                                          "My PG Selection",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()));
                              // showChangePasswordDialog();
                            },
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset('assets/profile/password.svg', color: Colors.black,),
                                                    const Text(
                                                      "Change Password",
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                const Icon(Icons.arrow_forward_ios, size: 16,)
                                              ],
                                            ),
                                          ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // Uri uri = Uri.parse("https://zucol.in/privacy_policy.php");
                              // if (await canLaunchUrl(uri)){
                              // await launchUrl(uri);
                              // } else {
                              // // can't launch url
                              // }
                              launch("https://zucol.in/privacy_policy.php");
                              // _launchURL("https://zucol.in/privacy_policy.php");
                            },
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/profile/privacy.svg'),
                                        const Text(
                                          "Privacy Policy",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                builder: (BuildContext context) => WillPopScope(
                                  onWillPop: () async => false,
                                  child: AlertDialog(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    content: SizedBox(
                                      child: Image.asset('assets/images/loading_anim.gif'),
                                      height: 100,
                                    ),
                                  ),
                                ),
                              );
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String branch_id = await prefs.getString("branch_id").toString();
                              TermsModel termsModel = await API.downloadTermsandconditionPdfApi(branch_id);
                              // print("download pdf value"+value.toString());
                              Navigator.pop(context);
                      
                              Navigator.pushNamed(context, TermsConditions.id, arguments: termsModel);
                            },
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset('assets/profile/term.svg'),
                                                      const Text(
                                                        "Terms & Conditions",
                                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(Icons.arrow_forward_ios, size: 16)
                                                ],
                                              ),
                                            ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const VisitorsDetails()));
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Icon(Icons.perm_identity_rounded, color: Colors.grey,),
                                        ),
                                        // SvgPicture.asset('assets/profile/term.svg'),
                                        Text(
                                          "Visitor Details",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // API.user('8569885985', '6').then((UserModel value) {
                              //   print("start date -- ${value.residents![0].noticeStartDate}");
                              // });

                              print("start date -- ${state.userModel.residents![0].noticeStartDate}");
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> NoticePeriod(state.userModel.residents![0].noticeStartDate.toString())));
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Icon(Icons.access_time_outlined, color: Colors.grey,),
                                        ),
                                        // SvgPicture.asset('assets/profile/term.svg'),
                                        Text(
                                          "Notice Period",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // BottomNavigationBar(items: BottomAppBar(child: ElevatedButton(onPressed: (){}, child: Text('Logout')),))
                      
                      
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
        
        
        
        
            // Container(
            //     // color: Colors.red,
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     child: Stack(
            //       children: [
            //
            //         // Back Image
            //         Container(
            //           // alignment: Alignment.topCenter,
            //             width: MediaQuery.of(context).size.width,
            //             height: MediaQuery.of(context).size.height * 0.40,
            //             decoration: BoxDecoration(
            //               color: Colors.black,
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.grey.withOpacity(0.7),
            //                   spreadRadius: 1,
            //                   blurRadius: 1,
            //                   offset: Offset(1, 1),
            //                 ),
            //               ],
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 SizedBox(
            //                     width: MediaQuery.of(context).size.width,
            //                     height: MediaQuery.of(context).size.height * 0.30,
            //                     // height: 50,
            //                     child: /*Image.asset(
            //                 'assets/images/man.png',
            //                 color: Colors.white,
            //                 fit: BoxFit.fill,
            //               ),*/
            //                     imageUrl != null
            //                         ? Image.network(
            //                       'https://dashboard.btroomer.com/${state.userModel.residents![0].image}' ,
            //                       // 'https://dashboard.btroomer.com/${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['image']}' ,
            //                       loadingBuilder: (context, child, loadingProgress) =>
            //                       (loadingProgress == null) ? child : CircularProgressIndicator(),
            //                       errorBuilder: (context, error, stackTrace) => Image.asset(
            //                         'assets/images/man.png',
            //                         color: Colors.white,
            //                         fit: BoxFit.fill,
            //                       ),
            //                     )
            //                         : Image.asset(
            //                       'assets/images/man.png',
            //                       color: Colors.white,
            //                       fit: BoxFit.fill,
            //                     )
            //                   /*child: CircleAvatar(
            //                     radius: 60,
            //                     backgroundImage: AssetImage('assets/images/man.png',),
            //                     foregroundImage: NetworkImage(
            //                         'https://dashboard.btroomer.com/${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['image']}'),
            //                     backgroundColor: Colors.white,
            //                   ),*/
            //                 ),
            //               ],
            //             )),
            //
            //         // Back arrow
            //         Positioned(
            //             left: 30,
            //             top: 40,
            //             child: Row(
            //               children: [
            //                 InkWell(
            //                     onTap: () {
            //                       Navigator.pop(context);
            //                     },
            //                     child: const Icon(
            //                       Icons.arrow_back_ios,
            //                       size: 20,
            //                       color: Colors.white,
            //                     )),
            //                 const SizedBox(
            //                   width: 20,
            //                 ),
            //                 const Text(
            //                   'Profile',
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.w500,
            //                       color: Colors.white,
            //                       fontSize: 25),
            //                 )
            //               ],
            //             )),
            //
            //         // all data
            //         Positioned(
            //           top: MediaQuery.of(context).size.height * 0.30,
            //           left: MediaQuery.of(context).size.width * 0.075,
            //           child: SingleChildScrollView(
            //             child: Column(
            //               children: [
            //
            //                 // details
            //                 Container(
            //                   width: MediaQuery.of(context).size.width * 0.85,
            //                   height: 290,
            //                   decoration: BoxDecoration(
            //                     // color: Color(0xff263B60),
            //                     color: Colors.white,
            //                     borderRadius: BorderRadius.circular(10),
            //                     boxShadow: [
            //                       BoxShadow(
            //                         color: Colors.grey.withOpacity(0.7),
            //                         spreadRadius: 1,
            //                         blurRadius: 7,
            //                         offset: Offset(1, 1),
            //                       ),
            //                     ],
            //                   ),
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     children: [
            //                       const SizedBox(
            //                         height: 16,
            //                       ),
            //                       Text(
            //                         state.userModel.residents![0].residentName!,
            //                         // NewHomeApp.userValues['residents']
            //                         //   [apiprovider.getDropDownValue()]['resident_name'],
            //                         style: TextStyle(
            //                             fontWeight: FontWeight.bold, fontSize: 18),
            //                       ),
            //                       const SizedBox(
            //                         height: 16,
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.symmetric(horizontal: 16),
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 const Text(
            //                                   "Father's Name",
            //                                   style: TextStyle(color: Color(0xffABAFB8)),
            //                                 ),
            //                                 Text(
            //                                   state.userModel.residents![0].fName ==
            //                                       // NewHomeApp.userValues['residents'][apiprovider
            //                                       //         .getDropDownValue()]['f_name'] ==
            //                                       ""
            //                                       ? "--"
            //                                       : state.userModel.residents![0].fName!,
            //                                   // NewHomeApp.userValues['residents']
            //                                   //           [apiprovider.getDropDownValue()]
            //                                   //       ['f_name'],
            //                                   style: TextStyle(color: Color(0xff001944)),
            //                                 ),
            //                               ],
            //                             ),
            //                             Container(
            //                               width: 100,
            //                               child: Column(
            //                                 crossAxisAlignment: CrossAxisAlignment.start,
            //                                 children: [
            //                                   const Text(
            //                                     "Date of Birth",
            //                                     style: TextStyle(color: Color(0xffABAFB8)),
            //                                   ),
            //                                   Text(
            //                                       state.userModel.residents![0].dob ==
            //                                           // NewHomeApp.userValues['residents'][
            //                                           //             apiprovider
            //                                           //                 .getDropDownValue()]
            //                                           //         ['dob'] ==
            //                                           ""
            //                                           ? "--"
            //                                           : state.userModel.residents![0].dob!,
            //                                       // NewHomeApp.userValues['residents'][
            //                                       //         apiprovider
            //                                       //             .getDropDownValue()]['dob'],
            //                                       style:
            //                                       TextStyle(color: Color(0xff001944)))
            //                                 ],
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       const SizedBox(
            //                         height: 16,
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.symmetric(horizontal: 16),
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 const Text(
            //                                   "Registration Date",
            //                                   style: TextStyle(color: Color(0xffABAFB8)),
            //                                 ),
            //                                 Text(
            //                                   state.userModel.residents![0].registrationDate!,
            //                                   // NewHomeApp.userValues['residents']
            //                                   //         [apiprovider.getDropDownValue()]
            //                                   //     ['registration_date'],
            //                                   style: TextStyle(
            //                                       color: Color(0xff001944),
            //                                       fontSize: 16,
            //                                       fontWeight: FontWeight.w500),
            //                                 ),
            //                               ],
            //                             ),
            //                             Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 Container(
            //                                   width: 100,
            //                                   child: const Text(
            //                                     "Rent",
            //                                     style: TextStyle(color: Color(0xffABAFB8)),
            //                                   ),
            //                                 ),
            //                                 Text(
            //                                   "₹ ${state.userModel.residents![0].rent}",
            //                                   // "₹ ${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['rent']}",
            //                                   style: TextStyle(
            //                                       color: Color(0xff001944),
            //                                       fontSize: 16,
            //                                       fontWeight: FontWeight.w500),
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       const SizedBox(
            //                         height: 16,
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.symmetric(horizontal: 16),
            //                         child: Row(
            //                           children: [
            //                             Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 const Text(
            //                                   "Room No./Bed No.",
            //                                   style: TextStyle(color: Color(0xffABAFB8)),
            //                                 ),
            //                                 Text(
            //                                   '${state.userModel.residents![0].roomName}/${state.userModel.residents![0].bedName}',
            //                                   // '${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['room_name']}/${NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['bed_name']}',
            //                                   style: TextStyle(
            //                                       color: Color(0xff001944),
            //                                       fontSize: 16,
            //                                       fontWeight: FontWeight.w500),
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       Spacer(),
            //                       Container(
            //                         width: double.infinity,
            //                         height: 50,
            //                         decoration: BoxDecoration(
            //                             color: Color(0xffD9E2FF).withOpacity(.2),
            //                             borderRadius: const BorderRadius.only(
            //                               bottomRight: Radius.circular(10),
            //                               bottomLeft: Radius.circular(10),
            //                             )),
            //                         child: Padding(
            //                           padding: const EdgeInsets.symmetric(horizontal: 16),
            //                           child: Row(
            //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                             children: [
            //                               const Text(
            //                                 "Rent History",
            //                                 style: TextStyle(fontWeight: FontWeight.bold),
            //                               ),
            //                               InkWell(
            //                                 onTap: () async {
            //                                   showDialog<String>(
            //                                     context: context,
            //                                     builder: (BuildContext context) =>
            //                                         AlertDialog(
            //                                           title: const Text('Rent History'),
            //                                           content: Column(
            //                                             mainAxisSize: MainAxisSize.min,
            //                                             children: [
            //                                               Container(
            //                                                 width: MediaQuery.of(context)
            //                                                     .size
            //                                                     .width,
            //                                                 child: Column(
            //                                                   children: [
            //                                                     const Row(
            //                                                       mainAxisAlignment:
            //                                                       MainAxisAlignment
            //                                                           .spaceBetween,
            //                                                       children: [
            //                                                         Expanded(
            //                                                           child: Text('From',
            //                                                               style: TextStyle(
            //                                                                   fontWeight:
            //                                                                   FontWeight
            //                                                                       .bold,
            //                                                                   fontSize: 12)),
            //                                                         ),
            //                                                         Expanded(
            //                                                           child: Text('To',
            //                                                               style: TextStyle(
            //                                                                   fontWeight:
            //                                                                   FontWeight
            //                                                                       .bold,
            //                                                                   fontSize: 12)),
            //                                                         ),
            //                                                         Flexible(
            //                                                           child: Text('Rent',
            //                                                               style: TextStyle(
            //                                                                   fontWeight:
            //                                                                   FontWeight
            //                                                                       .bold,
            //                                                                   fontSize: 12)),
            //                                                         ),
            //                                                       ],
            //                                                     ),
            //                                                     const Divider(
            //                                                       color: Colors.black,
            //                                                     ),
            //                                                     Column(
            //                                                       mainAxisSize:
            //                                                       MainAxisSize.min,
            //                                                       children: [
            //                                                         Container(
            //                                                           height:
            //                                                           MediaQuery.of(context)
            //                                                               .size
            //                                                               .height *
            //                                                               0.3,
            //                                                           child: ListView.builder(
            //                                                             shrinkWrap: true,
            //                                                             itemCount: state.userModel.residents![0].accommodation!
            //                                                             // itemCount: NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation']
            //                                                                 .length,
            //                                                             itemBuilder:
            //                                                                 (BuildContext, int index) {
            //                                                               return Row(
            //                                                                 mainAxisAlignment:
            //                                                                 MainAxisAlignment
            //                                                                     .spaceBetween,
            //                                                                 children: [
            //                                                                   Expanded(
            //                                                                       child: Text(
            //                                                                         state.userModel.residents![0].accommodation![index].fromDate
            //                                                                         // NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['from_date']
            //                                                                             .toString(),
            //                                                                         style: TextStyle(
            //                                                                             fontSize:
            //                                                                             12),
            //                                                                       )),
            //                                                                   Expanded(
            //                                                                       child: Text(state.userModel.residents![0].accommodation![index].toDate
            //                                                                       // child: Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['to_date']
            //                                                                           .toString())),
            //                                                                   Flexible(
            //                                                                       child: Text(state.userModel.residents![0].accommodation![index].rent
            //                                                                       // child: Text(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['accommodation'][index]['rent']
            //                                                                           .toString())),
            //                                                                 ],
            //                                                               );
            //                                                             },
            //                                                           ),
            //                                                         ),
            //                                                       ],
            //                                                     ),
            //                                                   ],
            //                                                 ),
            //                                               ),
            //                                             ],
            //                                           ),
            //                                         ),
            //                                   );
            //                                 },
            //                                 child: Container(
            //                                   width: 90,
            //                                   height: 34,
            //                                   padding: EdgeInsets.only(left: 10),
            //                                   alignment: Alignment.center,
            //                                   decoration: BoxDecoration(
            //                                       borderRadius: BorderRadius.circular(20),
            //                                       color: Color(0xffD9E2FF)),
            //                                   child: Container(
            //                                     child: const Row(
            //                                       mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                       children: [
            //                                         Text("Details",
            //                                             style: TextStyle(
            //                                                 fontWeight: FontWeight.w500)),
            //                                         Icon(
            //                                             Icons.keyboard_arrow_right_outlined)
            //                                       ],
            //                                     ),
            //                                   ),
            //                                 ),
            //                               )
            //                             ],
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //                 const SizedBox(height: 20,),
            //
            //                 // Change password
            //                 InkWell(
            //                   onTap: () async {
            //                     showChangePasswordDialog();
            //                   },
            //                   child: Container(
            //                     width: MediaQuery.of(context).size.width * 0.85,
            //                     //height: 200,
            //                     decoration: BoxDecoration(
            //                       // color: Color(0xff263B60),
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color: Colors.grey.withOpacity(0.7),
            //                           spreadRadius: 1,
            //                           blurRadius: 7,
            //                           offset: Offset(1, 1),
            //                         ),
            //                       ],
            //                     ),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Container(
            //                           width: double.infinity,
            //                           height: 50,
            //                           decoration: BoxDecoration(
            //                             //  color: Color(0xffD9E2FF).withOpacity(.2),
            //                               borderRadius: BorderRadius.only(
            //                                 bottomRight: Radius.circular(10),
            //                                 bottomLeft: Radius.circular(10),
            //                               )),
            //                           child: Padding(
            //                             padding: const EdgeInsets.symmetric(horizontal: 16),
            //                             child: Row(
            //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                               children: [
            //                                 Text(
            //                                   "Change Password",
            //                                   style: TextStyle(fontWeight: FontWeight.bold),
            //                                 ),
            //                                 Icon(Icons.arrow_forward_ios)
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(height: 20,),
            //
            //                 // Visitor Detail
            //                 InkWell(
            //                   onTap: () async {
            //                      /*_dialogContext(context);*/
            //                     Navigator.push(context,
            //                         MaterialPageRoute(builder: (context) => VisitorsDetails()));
            //                   },
            //                   child: Container(
            //                     width: MediaQuery.of(context).size.width * 0.85,
            //                     //height: 200,
            //                     decoration: BoxDecoration(
            //                       // color: Color(0xff263B60),
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color: Colors.grey.withOpacity(0.7),
            //                           spreadRadius: 1,
            //                           blurRadius: 7,
            //                           offset: Offset(1, 1),
            //                         ),
            //                       ],
            //                     ),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Container(
            //                           width: double.infinity,
            //                           height: 50,
            //                           decoration: BoxDecoration(
            //                             //  color: Color(0xffD9E2FF).withOpacity(.2),
            //                               borderRadius: BorderRadius.only(
            //                                 bottomRight: Radius.circular(10),
            //                                 bottomLeft: Radius.circular(10),
            //                               )),
            //                           child: Padding(
            //                             padding: const EdgeInsets.symmetric(horizontal: 16),
            //                             child: Row(
            //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                               children: [
            //                                 Text(
            //                                   "Visitor Detail",
            //                                   style: TextStyle(fontWeight: FontWeight.bold),
            //                                 ),
            //                                 Icon(Icons.arrow_forward_ios)
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(height: 20,),
            //
            //                 // Term and condition
            //                 InkWell(
            //                   onTap: () async {
            //                     showDialog<String>(
            //                       context: context,
            //                       barrierDismissible: false,
            //                       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            //                       builder: (BuildContext context) => WillPopScope(
            //                         onWillPop: () async => false,
            //                         child: AlertDialog(
            //                           elevation: 0,
            //                           backgroundColor: Colors.transparent,
            //                           content: Container(
            //                             child: Image.asset('assets/images/loading_anim.gif'),
            //                             height: 100,
            //                           ),
            //                         ),
            //                       ),
            //                     );
            //                     SharedPreferences prefs = await SharedPreferences.getInstance();
            //                     String branch_id = await prefs.getString("branch_id").toString();
            //                     TermsModel termsModel = await API.downloadTermsandconditionPdfApi(branch_id);
            //                     // print("download pdf value"+value.toString());
            //                     Navigator.pop(context);
            //
            //                 /*apiprovider.sendComplainHeader(Page2App.complaints_options[0]);
            //                 NewHomeApp.complainHead = NewHomeApp.userComplains['complainHead'];
            //                 Navigator.pushNamed(context, Page2App.id);*/
            //
            //                     Navigator.pushNamed(context, TermsConditions.id, arguments: termsModel);
            //                   },
            //                   child: Container(
            //                     width: MediaQuery.of(context).size.width * 0.85,
            //                     //height: 200,
            //                     decoration: BoxDecoration(
            //                       // color: Color(0xff263B60),
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color: Colors.grey.withOpacity(0.7),
            //                           spreadRadius: 1,
            //                           blurRadius: 7,
            //                           offset: Offset(1, 1),
            //                         ),
            //                       ],
            //                     ),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Container(
            //                           width: double.infinity,
            //                           height: 50,
            //                           decoration: BoxDecoration(
            //                             //  color: Color(0xffD9E2FF).withOpacity(.2),
            //                               borderRadius: BorderRadius.only(
            //                                 bottomRight: Radius.circular(10),
            //                                 bottomLeft: Radius.circular(10),
            //                               )),
            //                           child: Padding(
            //                             padding: const EdgeInsets.symmetric(horizontal: 16),
            //                             child: Row(
            //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                               children: [
            //                                 Text(
            //                                   "Terms & Conditions",
            //                                   style: TextStyle(fontWeight: FontWeight.bold),
            //                                 ),
            //                                 Icon(Icons.arrow_forward_ios)
            //                               ],
            //                             ),
            //                           ),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(height: 20,),
            //
            //                 // Logout button
            //
            //                 InkWell(
            //                   onTap: () async {
            //
            //
            //                     showDialog(
            //                         context: context,
            //                         builder: (context) => StatefulBuilder(
            //                             builder: (context, setState) {
            //                               return AlertDialog(
            //                                 insetPadding:
            //                                 const EdgeInsets.symmetric(
            //                                     horizontal: 10),
            //                                 title: const Text(
            //                                   "Are you sure ?",
            //                                   style: TextStyle(
            //                                       fontWeight: FontWeight.normal),
            //                                 ),
            //                                 actions: [
            //                                   TextButton(
            //                                       onPressed: () =>
            //                                           Navigator.pop(context),
            //                                       child: const Text("Cancel",
            //                                           style: TextStyle(
            //                                               color: Color(
            //                                                   0xffc56c86)))),
            //                                   TextButton(
            //                                     onPressed: () async {
            //                                       SharedPreferences prefs = await SharedPreferences.getInstance();
            //                                       String branch_id = await prefs.getString("branch_id").toString();
            //                                       String user_id = await prefs.getString("user_id").toString();
            //
            //                                       /*await API.logoutTenant(branch_id, user_id).then((value)  {
            //
            //                                   if(value['success']=="1"){*/
            //                                       prefs.setBool('isLoggedIn', false);
            //                                       prefs.remove("email");
            //                                       // Navigator.pushNamed(context, Login.id);
            //                                       Navigator.popUntil(context, (route) => false);
            //                                       Navigator.of(context).pushNamedAndRemoveUntil(Login.id, (Route<dynamic> route) => false);
            //                                       /*  }else{
            //                                     final snackbar = SnackBar(content: Text('Network issue, please try again !!',style: TextStyle(color: Colors.red),));
            //                                     ScaffoldMessenger.of(context).showSnackBar(snackbar);
            //                                   }
            //
            //                                 });*/
            //
            //
            //                                     },
            //                                     child: const Text(
            //                                       "Yes",
            //                                       style: TextStyle(
            //                                           color: Color(0xffc56c86)),
            //                                     ),
            //                                   )
            //                                 ],
            //                               );
            //                             }));
            //
            //
            //                   },
            //                   child: Container(
            //                     alignment: Alignment.center,
            //                     width: MediaQuery.of(context).size.width * 0.85,
            //                     height: 50,
            //                     decoration: BoxDecoration(
            //                       color: Color(0xff001944),
            //                       // color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       // border: Border.all(color: primaryColor),
            //                          boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.grey.withOpacity(0.4),
            //                   spreadRadius: 1,
            //                   blurRadius: 12,
            //                   offset: Offset(1, 1),
            //                 ),
            //               ],
            //                     ),
            //                     child: Text(
            //                       "Logout",
            //                       style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            //                     ),
            //                   ),
            //                 ),
            //
            //                 // InkWell(
            //                 //   onTap: () async {
            //                 //     showDialog(
            //                 //         context: context,
            //                 //         builder: (context) =>
            //                 //             StatefulBuilder(builder: (context, setState) {
            //                 //               return AlertDialog(
            //                 //                 insetPadding:
            //                 //                 const EdgeInsets.symmetric(horizontal: 10),
            //                 //                 title: const Text(
            //                 //                   "Are you sure ?",
            //                 //                   style:
            //                 //                   TextStyle(fontWeight: FontWeight.normal),
            //                 //                 ),
            //                 //                 actions: [
            //                 //                   TextButton(
            //                 //                       onPressed: () => Navigator.pop(context),
            //                 //                       child: const Text("Cancel",
            //                 //                           style: TextStyle(
            //                 //                               color: Color(0xffc56c86)))),
            //                 //                   TextButton(
            //                 //                     onPressed: () async {
            //                 //                       SharedPreferences prefs =
            //                 //                       await SharedPreferences.getInstance();
            //                 //                       String branch_id = await prefs
            //                 //                           .getString("branch_id")
            //                 //                           .toString();
            //                 //                       String user_id = await prefs
            //                 //                           .getString("user_id")
            //                 //                           .toString();
            //                 //
            //                 //                       await API
            //                 //                           .logoutTenant(branch_id, user_id)
            //                 //                           .then((value) {
            //                 //                         if (value['success'] == "1") {
            //                 //                           prefs.setBool('isLoggedIn', false);
            //                 //                           prefs.remove("email");
            //                 //                           // Navigator.pushNamed(context, Login.id);
            //                 //                           Navigator.popUntil(
            //                 //                               context, (route) => false);
            //                 //                           Navigator.of(context)
            //                 //                               .pushNamedAndRemoveUntil(
            //                 //                               Login.id,
            //                 //                                   (Route<dynamic> route) =>
            //                 //                               false);
            //                 //                         } else {
            //                 //                           final snackbar = SnackBar(
            //                 //                               content: Text(
            //                 //                                 'Network issue, please try again !!',
            //                 //                                 style: TextStyle(color: Colors.red),
            //                 //                               ));
            //                 //                           ScaffoldMessenger.of(context)
            //                 //                               .showSnackBar(snackbar);
            //                 //                         }
            //                 //                       });
            //                 //                     },
            //                 //                     child: const Text(
            //                 //                       "Yes",
            //                 //                       style:
            //                 //                       TextStyle(color: Color(0xffc56c86)),
            //                 //                     ),
            //                 //                   )
            //                 //                 ],
            //                 //               );
            //                 //             }));
            //                 //   },
            //                 //   child: Container(
            //                 //     alignment: Alignment.center,
            //                 //     width: MediaQuery.of(context).size.width * 0.85,
            //                 //     height: 50,
            //                 //     decoration: BoxDecoration(
            //                 //       color: Color(0xff001944),
            //                 //       // color: Colors.white,
            //                 //       borderRadius: BorderRadius.circular(10),
            //                 //       // border: Border.all(color: primaryColor),
            //                 //       boxShadow: [
            //                 //         BoxShadow(
            //                 //           color: Colors.grey.withOpacity(0.4),
            //                 //           spreadRadius: 1,
            //                 //           blurRadius: 12,
            //                 //           offset: Offset(1, 1),
            //                 //         ),
            //                 //       ],
            //                 //     ),
            //                 //     child: Text(
            //                 //       "Logout",
            //                 //       style: TextStyle(
            //                 //           fontWeight: FontWeight.w500, color: Colors.white),
            //                 //     ),
            //                 //   ),
            //                 // ),
            //                 const SizedBox(height: 20,),
            //
            //               ],
            //             ),
            //           ),
            //         ),
            //
            //       ],
            //     ),
            //   );
        
        
        
        
        
          }
          if(state is HomeError){
            return const SizedBox();
          }
          return const SizedBox();
        },),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,

        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: showLogoutDialog
                , child: const Text('Logout', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Product Sans'),),
                style: ElevatedButton.styleFrom(backgroundColor: Constant.bgTile),
              )
          ),
        ),
      ),
    );
  }

  // void showChangePasswordDialog() {
  //   showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => StatefulBuilder(
  //       builder: (context, setState) {
  //         return
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     AlertDialog(
  //                       insetPadding:
  //                           const EdgeInsets.symmetric(horizontal: 10),
  //                       title: const Row(
  //                         children: [
  //                           Text('Change Password'),
  //                           Spacer(),
  //                           /*GestureDetector(
  //                     onTap: () => Navigator.pop(context),
  //                     child: SvgPicture.asset("assets/images/ic_cancel_button.svg",
  //                       width: 25,),
  //                   )*/
  //                         ],
  //                       ),
  //                       content: SizedBox(
  //                         width: MediaQuery.of(context).size.width,
  //                         height: 140,
  //                         child: Column(
  //                           children: [
  //                             //Current Password TextField
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width,
  //                               height: 40,
  //                               child: TextFormField(
  //                                 controller: currentPasswordController,
  //                                 keyboardType: TextInputType.visiblePassword,
  //                                 obscureText: !isCurrentPassword!,
  //                                 decoration: InputDecoration(
  //                                     fillColor: Colors.grey,
  //                                     suffixIcon: IconButton(
  //                                       onPressed: () {
  //                                         setState(() {
  //                                           isCurrentPassword =
  //                                               !isCurrentPassword!;
  //                                         });
  //                                       },
  //                                       icon: isCurrentPassword!
  //                                           ? const Icon(
  //                                               Icons.visibility_off,
  //                                               color: Colors.grey,
  //                                             )
  //                                           : const Icon(
  //                                               Icons.visibility,
  //                                               color: Colors.grey,
  //                                             ),
  //                                     ),
  //                                     labelText: "Current Password",
  //                                     labelStyle:
  //                                         const TextStyle(color: Colors.grey),
  //                                     focusedBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(5),
  //                                         borderSide: const BorderSide(
  //                                             color: Colors.black, width: 2)),
  //                                     enabledBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(5),
  //                                         borderSide: const BorderSide(
  //                                             color: Colors.grey, width: 1))),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                             //New Password TextField
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width,
  //                               height: 40,
  //                               child: TextFormField(
  //                                 controller: newPasswordController,
  //                                 keyboardType: TextInputType.visiblePassword,
  //                                 obscureText: !isNewPassword!,
  //                                 decoration: InputDecoration(
  //                                     fillColor: Colors.grey,
  //                                     suffixIcon: IconButton(
  //                                       onPressed: () {
  //                                         setState(() {
  //                                           isNewPassword = !isNewPassword!;
  //                                         });
  //                                       },
  //                                       icon: isNewPassword!
  //                                           ? const Icon(
  //                                               Icons.visibility_off,
  //                                               color: Colors.grey,
  //                                             )
  //                                           : const Icon(
  //                                               Icons.visibility,
  //                                               color: Colors.grey,
  //                                             ),
  //                                     ),
  //                                     labelText: "New Password",
  //                                     labelStyle:
  //                                         const TextStyle(color: Colors.grey),
  //                                     focusedBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(5),
  //                                         borderSide: const BorderSide(
  //                                             color: Colors.black, width: 2)),
  //                                     enabledBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(5),
  //                                         borderSide: const BorderSide(
  //                                             color: Colors.grey, width: 1))),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                             //Confirm Password TextField
  //                             SizedBox(
  //                               width: MediaQuery.of(context).size.width,
  //                               height: 40,
  //                               child: TextFormField(
  //                                 controller: confirmPasswordController,
  //                                 keyboardType: TextInputType.visiblePassword,
  //                                 obscureText: !isConfirmPassword!,
  //                                 decoration: InputDecoration(
  //                                     fillColor: Colors.grey,
  //                                     suffixIcon: IconButton(
  //                                       onPressed: () {
  //                                         setState(() {
  //                                           isConfirmPassword =
  //                                               !isConfirmPassword!;
  //                                         });
  //                                       },
  //                                       icon: isConfirmPassword!
  //                                           ? const Icon(
  //                                               Icons.visibility_off,
  //                                               color: Colors.grey,
  //                                             )
  //                                           : const Icon(
  //                                               Icons.visibility,
  //                                               color: Colors.grey,
  //                                             ),
  //                                     ),
  //                                     labelText: "Confirm Password",
  //                                     labelStyle:
  //                                         const TextStyle(color: Colors.grey),
  //                                     focusedBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(5),
  //                                         borderSide: const BorderSide(
  //                                             color: Colors.black, width: 2)),
  //                                     enabledBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(5),
  //                                         borderSide: const BorderSide(
  //                                             color: Colors.grey, width: 1))),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       actions: <Widget>[
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             //Submit Button of Change Password
  //                             SizedBox(
  //                               width: 140,
  //                               height: 35,
  //                               child: ElevatedButton(
  //                                   style: ElevatedButton.styleFrom(
  //                                       backgroundColor: const Color(0xff001944),
  //                                       shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(20))),
  //                                   onPressed: () async {
  //                                     SharedPreferences prefs =
  //                                         await SharedPreferences.getInstance();
  //                                     String branch_id = await prefs
  //                                         .getString("branch_id")
  //                                         .toString();
  //                                     String user_id = await prefs
  //                                         .getString("id")
  //                                         .toString();
  //
  //                                     print("Current Password: " +
  //                                         currentPasswordController.text);
  //                                     print("New Password: " +
  //                                         newPasswordController.text);
  //                                     print("Confirm Password: " +
  //                                         confirmPasswordController.text);
  //                                     if (currentPasswordController
  //                                             .text.isEmpty &&
  //                                         newPasswordController.text.isEmpty &&
  //                                         confirmPasswordController
  //                                             .text.isEmpty) {
  //                                       Fluttertoast.showToast(
  //                                           msg:
  //                                               "Please type the password to change");
  //                                     } else if (newPasswordController
  //                                             .text.isEmpty &&
  //                                         confirmPasswordController
  //                                             .text.isEmpty) {
  //                                       Fluttertoast.showToast(
  //                                           msg:
  //                                               "Please type new and confirm password to change");
  //                                     } else if (confirmPasswordController.text
  //                                             .toString() !=
  //                                         newPasswordController.text
  //                                             .toString()) {
  //                                       Fluttertoast.showToast(
  //                                           msg:
  //                                               "Confirm password not match with new password");
  //                                     } else {
  //                                       API
  //                                           .changePasswordApi(
  //                                               context,
  //                                               branch_id,
  //                                               user_id,
  //                                               currentPasswordController.text,
  //                                               newPasswordController.text)
  //                                           .then((value) {
  //                                         if (value['success'] == '1') {
  //                                           Fluttertoast.showToast(
  //                                               msg: value['details']);
  //                                           Navigator.pop(context);
  //                                           Navigator.pop(context);
  //                                         } else {
  //                                           Fluttertoast.showToast(
  //                                               msg: value['details']);
  //                                         }
  //                                       });
  //                                     }
  //                                   },
  //                                   child: const Text(
  //                                     "Submit",
  //                                     style: TextStyle(color: Colors.white),
  //                                   )),
  //                             ),
  //                             //Cancel Button of Change Password
  //                             SizedBox(
  //                               width: 140,
  //                               height: 35,
  //                               child: ElevatedButton(
  //                                   style: ElevatedButton.styleFrom(
  //                                       backgroundColor: const Color(0xff001944),
  //                                       shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(20))),
  //                                   onPressed: () => Navigator.pop(context),
  //                                   child: const Text(
  //                                     "Cancel",
  //                                     style: TextStyle(color: Colors.white),
  //                                   )),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 );
  //       },
  //     ),
  //   );
  // }
}
