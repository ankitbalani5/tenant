import 'package:date_format/date_format.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/api/providerfuction.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/complain_bloc/complain_bloc.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/widgets/complainttab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../model/complain_model.dart';
import '../utils/utils.dart';
import '../widgets/whatsapphandler.dart';
import 'internet_check.dart';

class Page2App extends StatefulWidget {
  static const String id = "page2";
  bool isHomeNavigation;
  Page2App({Key? key, required bool this.isHomeNavigation,}) : super(key: key);
  static final myController = TextEditingController();
  static final searchController = TextEditingController();

  static List<ComplainHead> complaints_options = [];
  static List<String> items = [];
  static List<Complain> CompList = [];
  static List<Complain> PendingList = [];
  static List<Complain> RejectedList = [];
  @override
  _Page2AppState createState() => _Page2AppState();
}

class _Page2AppState extends State<Page2App> {
  var userId="";
  String? tenant_id;
  String? name;
  ComplainHead? _selectedDropDown;
  FocusNode _focusNode = FocusNode();
  TextEditingController dateinput = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  void initState() {
    String nowDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateinput.text = nowDate;
    complainApi();
    // TODO: implement initState
    super.initState();

    }

    Future onRefresh () async{
      BlocProvider.of<ComplainBloc>(context).add(ComplainRefreshEvent(tenant_id.toString()));
    }

  complainApi() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     // userId = prefs.getString('id')!;
     tenant_id = prefs.getString('tenant_id');
     name = prefs.getString('name')??'';
    BlocProvider.of<ComplainBloc>(context).add(ComplainRefreshEvent(tenant_id.toString()));
    setState(() {

    });
  }

  // void _showDialog() {
  //   // print(NewHomeApp.userComplains['complain']);
  //   //  print("dropdown value-------"+Page2App.dropdownValue.toString());
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
  //         statusBarColor: Colors.transparent, // Color for Android
  //         // statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
  //       ));
  //       return /*Consumer<APIprovider>(
  //         builder: (context, apiprovider, child) => */
  //         BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
  //           if(state is ComplainLoading){
  //             return Center(child: CircularProgressIndicator());
  //           }
  //           if(state is ComplainSuccess){
  //             Page2App.complaints_options = state.complainModel.complainHead!;
  //             // print(Page2App.complaints_options[0].headName);
  //
  //             return state.complainModel.complain!.isEmpty
  //                 ? Center(child: Text('No Complaints'))
  //                 :Form(
  //               key: _formKey,
  //               // autovalidate: _autovalidate,
  //               child:
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   StatefulBuilder(builder: (context, setState) {
  //                     return AlertDialog(
  //                       title: const Text('Complain box'),
  //                       content: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //
  //                           DropdownButtonHideUnderline(
  //                             child: DropdownButtonFormField<ComplainHead>(
  //                               focusNode: _focusNode,
  //                               value: _selectedDropDown,
  //                               // value: apiprovider.getComplainHeader().toString() == "" ? Page2App.dropdownValue : apiprovider.getComplainHeader().toString(),
  //                               isExpanded: true,
  //
  //                               onChanged: (ComplainHead? newValue) {
  //
  //                                 setState(() {
  //                                   _selectedDropDown = newValue!;
  //                                   print('selectdropdown...........${_selectedDropDown}');
  //                                 });
  //
  //
  //                                 // print(apiprovider.getUserID());
  //                                 // print(NewHomeApp.complainHead[Page2App.complaints_options
  //                                 //     .indexOf(apiprovider.getComplainHeader())]['id']);
  //                               },
  //                               validator: (value) => value == null ? 'field required' : null,
  //                               items: state.complainModel.complainHead!.map<DropdownMenuItem<ComplainHead>>((ComplainHead value) {
  //                                 return DropdownMenuItem<ComplainHead>(
  //                                   value: value,
  //                                   child: Text(value.headName.toString()),
  //                                 );
  //                               }).toList(),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: MediaQuery.of(context).size.height * 0.3,
  //                             width: MediaQuery.of(context).size.width,
  //                             child: TextFormField(
  //                               controller: Page2App.myController,
  //                               keyboardType: TextInputType.multiline,
  //                               maxLines: null,
  //                               decoration: InputDecoration(
  //                                   suffixIcon: IconButton(
  //                                     icon: const Icon(Icons.clear),
  //                                     onPressed: () {
  //                                       Page2App.myController.clear();
  //                                     },
  //                                   ),
  //                                   border: InputBorder.none,
  //                                   labelText: 'Enter your complain here...',
  //                                   labelStyle: TextStyle(color: Color(0xffABAFB8))
  //                               ),
  //                               validator: (value) {
  //                                 if(value == null || value.isEmpty){
  //                                   return 'Please enter your complain first';
  //                                 }
  //                                 return null;
  //                               },
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       actions: <Widget>[
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             TextButton(
  //                               child: const Text(
  //                                 "UPLOAD",
  //                                 style: TextStyle(color: Constant.bgText),
  //                               ),
  //
  //                               onPressed: () async {
  //                                 // Navigator.of(context).pop();
  //                                 // print(Page2App.myController.text);
  //                                 if(_formKey.currentState!.validate()){
  //                                   showDialog<String>(
  //                                     context: context,
  //                                     barrierDismissible: false,
  //                                     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //                                     builder: (BuildContext context) => WillPopScope(
  //                                       onWillPop: () async => false,
  //                                       child: AlertDialog(
  //                                         elevation: 0,
  //                                         backgroundColor: Colors.transparent,
  //                                         content: Container(
  //                                           child: Image.asset('assets/images/loading_anim.gif'),
  //                                           height: 100,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   );
  //
  //                                   await API.complainsupload(
  //                                     userId,
  //                                     Page2App.myController.text,
  //                                     _selectedDropDown!.id.toString(),
  //                                   );
  //                                   //apiprovider.sendUserID(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['tenant_id']);
  //                                   NewHomeApp.userComplains = await API.complains(userId);
  //                                   Page2App.complaints_options.clear();
  //                                   setState(() {
  //                                     NewHomeApp.complainHead = NewHomeApp.userComplains['complainHead'];
  //                                     for (var item in NewHomeApp.userComplains['complainHead']) {
  //                                       Page2App.complaints_options.add(item['head_name']);
  //                                       Page2App.CompList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Completed').toList();
  //                                       Page2App.PendingList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'In Process' || element['status'] == 'Pending').toList();
  //                                       Page2App.RejectedList =
  //                                           NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Rejected').toList();
  //                                     }
  //                                     //apiprovider.sendComplainHeader(Page2App.complaints_options[0]);
  //                                     // print(NewHomeApp.complainHead['complain']);
  //                                   });
  //                                   Navigator.pop(context);
  //                                   Page2App.myController.clear();
  //                                   Navigator.pop(context);
  //                                 }else {
  //                                   setState(() {
  //                                     _autovalidate = true; //enable realtime validation
  //                                   });
  //                                 }
  //
  //                                 // Navigator.popAndPushNamed(context, Page2App.id);
  //                               },
  //                             ),
  //                             TextButton(
  //                               child: const Text(
  //                                 "CANCEL",
  //                                 style: TextStyle(color: Color(0xffABAFB8)),
  //                               ),
  //                               onPressed: () {
  //                                 // print(NewHomeApp.userComplains['complain']);
  //                                 // Page2App.myController.clear();
  //                                 Navigator.of(context).pop();
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     );
  //                   },)
  //
  //                 ],
  //               ),
  //             );
  //           }
  //           if(state is ComplainError){
  //             return Center(child: Text(state.error),);
  //           }
  //           return SizedBox();
  //         },);
  //
  //       /*);*/
  //     },
  //   );
  // }
  // DateTime? _selectedDate;
  // TextEditingController _selectedDate = TextEditingController();

  // void _presentDatePicker() async {
  //   final now = DateTime.now();
  //   final firstDate = DateTime(now.year - 1, now.month, now.day);
  //   final pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: now,
  //       firstDate: firstDate,
  //       lastDate: now);
  //   // this line here, will only be executed once the value is available (acync and await)
  //   setState(() {
  //     // _selectedDate.text = now.toIso8601String();
  //     // _selectedDate.text = pickedDate;
  //   });
  // }

  void viewMoreSheet(Complain complain) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String image = pref.getString('image') ?? '';
    showModalBottomSheet(
      context: context, builder: (context) {

      return BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
        if(state is ComplainLoading){
          return Center(child: CircularProgressIndicator(),);
        }
        if(state is ComplainSuccess){
          return Container(
            height: 400,
            width: MediaQuery.of(context).size.width,

            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(48),
                                    child: Container(
                                        height: 48,
                                        width: 48,
                                        child: Image.network('https://dashboard.btroomer.com/${image}',
                                          loadingBuilder: (context, child, loadingProgress) =>
                                          (loadingProgress == null) ? child : CircularProgressIndicator(),
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            'assets/images/man.png',
                                            color: Colors.black,
                                            fit: BoxFit.fill,
                                          ),
                                        )/*SvgPicture.asset('assets/explore/person.svg')*/),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(name == 'null' ? '' : name.toString(), style: TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w700, fontSize: 20, color: Constant.bgText),)
                                ],
                              ),
                              Text(complain.complainDate.toString(), style: const TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff6F7894)))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(complain.headName == null || complain.headName == ''? '':
                              complain.headName.toString(), style: const TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w400, fontSize: 16, color: Constant.bgText)),
                          const SizedBox(height: 20,),
                          Text(complain.remark.toString(),
                              style: const TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff6F7894))),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.bgButton,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(color: Constant.bgButton, width: 2.0), // Adjust the width as needed
                            ),
                          ),
                          onPressed: () async{
                            launch(
                                "https://wa.me/?text=Complain: ${complain.headName.toString()}"
                                    "\nComplain Date: ${complain.complainDate.toString()}"
                                    "\nRemark: ${complain.remark.toString()}"
                            );
                            // await Whatsapp().openwhatsapp(context,
                            //     // number: '+91${8385894167}',
                            //     content:
                            //     'https://play.google.com/store/apps/details?id=com.zucol.roomertenant');
                            // _shareLinkcontroller.clear();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/complain/whatsapp.svg'),
                              // Icon(Icons.whatshot, color: Colors.white,),
                              const SizedBox(width: 10,),
                              const Text('WhatsApp', style: TextStyle(color: Colors.white, fontFamily: 'Product Sans', fontWeight: FontWeight.w700, fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        if(state is ComplainError){
          return Center(child: Text(state.error),);
        }
        return SizedBox();
      },);

    },);
  }

  void addComplainSheet(){
    Page2App.myController.clear();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('Add Complaints', style: TextStyle(
                      fontFamily: 'Product Sans',
                      color: Constant.bgText,
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                  ),
                  ),
                ),
                SizedBox(height: 20,),
                BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
                  if(state is ComplainLoading){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(state is ComplainSuccess){
                    Page2App.complaints_options = state.complainModel.complainHead!;
                    // _selectedDropDown=state.complainModel.complainHead![0];

                    // print(Page2App.complaints_options[0].headName);
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatefulBuilder(builder: (context, setState) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownSearch<ComplainHead>(
                                      validator: (value) => value == null ? 'field required' : null,
                                      dropdownDecoratorProps: DropDownDecoratorProps(
                                        dropdownSearchDecoration: InputDecoration(
                                            label: const Text('Select Category'),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                          ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  // gapPadding: 20,
                                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                              ),
                                        ),
                                      ),
                                      items: state.complainModel.complainHead!,
                                      itemAsString: (ComplainHead u) => u.headName!,
                                      onChanged: (ComplainHead? newValue) {
                                        setState(() {
                                          _selectedDropDown = newValue!;
                                          print('selectdropdown...........${_selectedDropDown}');
                                        });
                                      },
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            hintText: 'Search Categories',
                                          ),
                                        ),
                                      ),
                                      // onChanged: (newValue) async {
                                      //   setState(() {
                                      //     _selectedName = newValue;
                                      //     companyId = newValue!.companyId.toString();
                                      //
                                      //     print('on change api');
                                      //     print('companyId---$companyId');
                                      //     BlocProvider.of<DataTableBloc>(context).add(DataTableRefreshEvent(companyId.toString()));
                                      //   });
                                      // },
                                      // selectedItem: "Brazil",
                                    ),
                                    // DropdownButtonFormField<ComplainHead>(
                                    //   dropdownColor: Colors.white,
                                    //   isExpanded: false,
                                    //   borderRadius: BorderRadius.circular(0),
                                    //   // focusNode: _focusNode,
                                    //   // value: _selectedDropDown,
                                    //   // hint: const Text('Select Category'),
                                    //   style: const TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w400, fontSize: 16, color: Constant.bgGreyText/*Colors.black*/),
                                    //   decoration: InputDecoration(
                                    //     label: const Text('Select Category'),
                                    //     border: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(30),
                                    //         borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                    //     ),
                                    //
                                    //     // contentPadding:
                                    //     // EdgeInsets.fromLTRB(12, 10, 20, 20),
                                    //     contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    //     enabledBorder: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(30),
                                    //         // gapPadding: 20,
                                    //         borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                    //     ),
                                    //     // focusedBorder: OutlineInputBorder(
                                    //     //     borderRadius: BorderRadius.circular(30),
                                    //     //     borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                    //     // )
                                    //   ),
                                    //   // value: apiprovider.getComplainHeader().toString() == "" ? Page2App.dropdownValue : apiprovider.getComplainHeader().toString(),
                                    //   // isExpanded: false,
                                    //   onChanged: (ComplainHead? newValue) {
                                    //     setState(() {
                                    //       _selectedDropDown = newValue!;
                                    //       print('selectdropdown...........${_selectedDropDown}');
                                    //     });
                                    //   },
                                    //   validator: (value) => value == null ? 'field required' : null,
                                    //   items: state.complainModel.complainHead!.map<DropdownMenuItem<ComplainHead>>((ComplainHead value) {
                                    //     return DropdownMenuItem<ComplainHead>(
                                    //       value: value,
                                    //       child: Text(value.headName.toString()),
                                    //     );
                                    //   }).toList(),
                                    // ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(30),
                                    //     border: Border.all(color: Colors.grey.withOpacity(0.5))
                                    // ),
                                    child: TextFormField(
                                      controller: Page2App.myController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        label: Text('Description'),
                                        alignLabelWithHint: true,
                                        // suffixIcon: IconButton(
                                        //   icon: const Icon(Icons.clear,),
                                        //   onPressed: () {
                                        //     Page2App.myController.clear();
                                        //   },
                                        // ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: Constant.bgGreyText/*Colors.grey.withOpacity(0.5)*/)
                                        ),
                                        // hintText: 'Description',
                                        hintStyle: TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w400, fontSize: 16),
                                      ),
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return 'Please enter your complain first';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              Page2App.myController.clear();
                                              // setState((){});
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 12),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: const Center(child: Text('Cancel',
                                                style: TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w700,
                                                    fontSize: 16, color: Constant.bgText),)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: ()async {
                                              // Navigator.of(context).pop();
                                              // print(Page2App.myController.text);
                                              if(_formKey.currentState!.validate()){
                                                showDialog<String>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                                  builder: (BuildContext context) => WillPopScope(
                                                    onWillPop: () async => false,
                                                    child: AlertDialog(
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      content: Container(
                                                        child: Image.asset('assets/images/loading_anim.gif'),
                                                        height: 100,
                                                      ),
                                                    ),
                                                  ),
                                                );

                                                await API.complainsupload(
                                                  tenant_id,
                                                  Page2App.myController.text.replaceAll(new RegExp(r"\s+\b|\b\s")," "),
                                                  _selectedDropDown!.id.toString(),
                                                ).then((value) async {
                                                  if(value['success'] == 1){
                                                    // isVisible = false;
                                                    // otpVerify = true;
                                                    // process = false;
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.green,));
                                                    /*API.complains(tenant_id);*/

                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    // Page2App.complaints_options.clear();

                                                    BlocProvider.of<ComplainBloc>(context).add(ComplainRefreshEvent(tenant_id.toString()));
                                                    // ComplainHead _selectedDropDown;
                                                    Page2App.myController.clear();
                                                    _selectedDropDown = null;
                                                    setState((){});
                                                    // NewHomeApp.userComplains = await API.complains(tenant_id);
                                                    //  NewHomeApp.complainHead = NewHomeApp.userComplains['complainHead'];
                                                    // for (var item in NewHomeApp.userComplains['complainHead']) {
                                                    //      Page2App.complaints_options.add(item['head_name']);
                                                    //      Page2App.CompList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Completed').toList();
                                                    //      Page2App.PendingList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'In Process' || element['status'] == 'Pending').toList();
                                                    //      Page2App.RejectedList =
                                                    //          NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Rejected').toList();
                                                    //    }

                                                  }
                                                  else{
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['details']), backgroundColor: Colors.red,));
                                                    Page2App.myController.clear();
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }
                                                });
                                                //apiprovider.sendUserID(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['tenant_id']);
                                                // NewHomeApp.userComplains = await API.complains(tenant_id);
                                                // print('NewHomeApp.userComplains --------- ${NewHomeApp.userComplains['complainHead']}');
                                                // Page2App.complaints_options.clear();
                                                // setState(() {
                                                //   NewHomeApp.complainHead = NewHomeApp.userComplains['complainHead'];
                                                //   print('complainhead ------${NewHomeApp.complainHead}');
                                                //   for (var item in NewHomeApp.userComplains['complainHead']) {
                                                //     Page2App.complaints_options.add(item['head_name']);
                                                //     Page2App.CompList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Completed').toList();
                                                //     Page2App.PendingList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'In Process' || element['status'] == 'Pending').toList();
                                                //     Page2App.RejectedList =
                                                //         NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Rejected').toList();
                                                //   }
                                                //   //apiprovider.sendComplainHeader(Page2App.complaints_options[0]);
                                                //   // print(NewHomeApp.complainHead['complain']);
                                                // });
                                                // Navigator.pop(context);
                                                // Page2App.myController.clear();
                                                // Navigator.pop(context);
                                              }else {
                                                setState(() {
                                                  _autovalidate = true; //enable realtime validation
                                                });
                                              }

                                              // Navigator.popAndPushNamed(context, Page2App.id);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 12),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                color: Constant.bgButton,
                                              ),
                                              child: const Center(child: Text('Submit',
                                                style: TextStyle(fontFamily: 'Product Sans', fontWeight: FontWeight.w700,
                                                    fontSize: 16, color: Colors.white),)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                            //   AlertDialog(
                            //   title: const Text('Complain box'),
                            //   content: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //
                            //       DropdownButtonFormField<ComplainHead>(
                            //         focusNode: _focusNode,
                            //         value: _selectedDropDown,
                            //         // value: apiprovider.getComplainHeader().toString() == "" ? Page2App.dropdownValue : apiprovider.getComplainHeader().toString(),
                            //         isExpanded: true,
                            //
                            //         onChanged: (ComplainHead? newValue) {
                            //
                            //           setState(() {
                            //             _selectedDropDown = newValue!;
                            //             print('selectdropdown...........${_selectedDropDown}');
                            //           });
                            //
                            //
                            //           // print(apiprovider.getUserID());
                            //           // print(NewHomeApp.complainHead[Page2App.complaints_options
                            //           //     .indexOf(apiprovider.getComplainHeader())]['id']);
                            //         },
                            //         validator: (value) => value == null ? 'field required' : null,
                            //         items: state.complainModel.complainHead!.map<DropdownMenuItem<ComplainHead>>((ComplainHead value) {
                            //           return DropdownMenuItem<ComplainHead>(
                            //             value: value,
                            //             child: Text(value.headName.toString()),
                            //           );
                            //         }).toList(),
                            //       ),
                            //       SizedBox(
                            //         height: MediaQuery.of(context).size.height * 0.3,
                            //         width: MediaQuery.of(context).size.width,
                            //         child: TextFormField(
                            //           controller: Page2App.myController,
                            //           keyboardType: TextInputType.multiline,
                            //           maxLines: null,
                            //           decoration: InputDecoration(
                            //               suffixIcon: IconButton(
                            //                 icon: const Icon(Icons.clear),
                            //                 onPressed: () {
                            //                   Page2App.myController.clear();
                            //                 },
                            //               ),
                            //               border: InputBorder.none,
                            //               labelText: 'Enter your complain here...',
                            //               labelStyle: TextStyle(color: Color(0xffABAFB8))
                            //           ),
                            //           validator: (value) {
                            //             if(value == null || value.isEmpty){
                            //               return 'Please enter your complain first';
                            //             }
                            //             return null;
                            //           },
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   actions: <Widget>[
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: [
                            //         TextButton(
                            //           child: const Text(
                            //             "UPLOAD",
                            //             style: TextStyle(color: Constant.bgText),
                            //           ),
                            //
                            //           onPressed: () async {
                            //             // Navigator.of(context).pop();
                            //             // print(Page2App.myController.text);
                            //             if(_formKey.currentState!.validate()){
                            //               showDialog<String>(
                            //                 context: context,
                            //                 barrierDismissible: false,
                            //                 barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            //                 builder: (BuildContext context) => WillPopScope(
                            //                   onWillPop: () async => false,
                            //                   child: AlertDialog(
                            //                     elevation: 0,
                            //                     backgroundColor: Colors.transparent,
                            //                     content: Container(
                            //                       child: Image.asset('assets/images/loading_anim.gif'),
                            //                       height: 100,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               );
                            //
                            //               await API.complainsupload(
                            //                 userId,
                            //                 Page2App.myController.text,
                            //                 _selectedDropDown!.id.toString(),
                            //               );
                            //               //apiprovider.sendUserID(NewHomeApp.userValues['residents'][apiprovider.getDropDownValue()]['tenant_id']);
                            //               NewHomeApp.userComplains = await API.complains(userId);
                            //               Page2App.complaints_options.clear();
                            //               setState(() {
                            //                 NewHomeApp.complainHead = NewHomeApp.userComplains['complainHead'];
                            //                 for (var item in NewHomeApp.userComplains['complainHead']) {
                            //                   Page2App.complaints_options.add(item['head_name']);
                            //                   Page2App.CompList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Completed').toList();
                            //                   Page2App.PendingList = NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'In Process' || element['status'] == 'Pending').toList();
                            //                   Page2App.RejectedList =
                            //                       NewHomeApp.userComplains['complain'].where((element) => element['status'] == 'Rejected').toList();
                            //                 }
                            //                 //apiprovider.sendComplainHeader(Page2App.complaints_options[0]);
                            //                 // print(NewHomeApp.complainHead['complain']);
                            //               });
                            //               Navigator.pop(context);
                            //               Page2App.myController.clear();
                            //               Navigator.pop(context);
                            //             }else {
                            //               setState(() {
                            //                 _autovalidate = true; //enable realtime validation
                            //               });
                            //             }
                            //
                            //             // Navigator.popAndPushNamed(context, Page2App.id);
                            //           },
                            //         ),
                            //         TextButton(
                            //           child: const Text(
                            //             "CANCEL",
                            //             style: TextStyle(color: Color(0xffABAFB8)),
                            //           ),
                            //           onPressed: () {
                            //             // print(NewHomeApp.userComplains['complain']);
                            //             // Page2App.myController.clear();
                            //             Navigator.of(context).pop();
                            //           },
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // );
                          },)

                        ],
                      ),
                    );
                  }
                  if(state is ComplainError){
                    return Center(child: Text(state.error),);
                  }
                  return SizedBox();
                },)

              ],
            ),
          )
              ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,));
    return Scaffold(
      body: NetworkObserverBlock(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  color: Constant.bgLight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                    child: Row(
                      children: [
                        /*InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                              color: Colors.white,
                            )),*/
                        widget.isHomeNavigation == false? IconButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 22,),) : SizedBox(width: 10,),
                        const Text(
                          'Complaints',
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: BlocBuilder<ComplainBloc, ComplainState>(
                          builder: (context, state) {
                            if(state is ComplainLoading){
                              return const Center(child: CircularProgressIndicator());
                            }
                            if(state is ComplainSuccess){
                              return state.complainModel.complain![0].id!.isEmpty
                                  ? const Center(child: Text('No Complain'))
                              : Column(
                                children: [
                                  // const SizedBox(height: 10,),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: state.complainModel.complain!.length,
                                      itemBuilder: (context, index) {
                                        return state.complainModel.complain![index].id!.isEmpty ? SizedBox() : Column(
                                          children: [
                                            const SizedBox(height: 10,),
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              // margin: const EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: Constant.bgTile
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                // crossAxisAlignment: CrossAxisAlignment.,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(state.complainModel.complain![index].headName.toString().toString()??'', style: const TextStyle(
                                                          overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w700,
                                                          fontSize: 14, fontFamily: 'Product Sans')),
                                                      SizedBox(
                                                        width: 240,
                                                        child: Text(state.complainModel.complain![index].remark.toString()??'',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis,
                                                            fontSize: 14, fontFamily: 'Product Sans', color: Constant.bgText)),
                                                      ),
                                                      Text(state.complainModel.complain![index].id.toString()??'', style: TextStyle(overflow: TextOverflow.ellipsis,),),
                                                      Text(state.complainModel.complain![index].complainDate.toString()??'', style: const TextStyle(
                                                          overflow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12, fontFamily: 'Product Sans', color: Color(0xff6F7894))),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(state.complainModel.complain![index].complainStatus == null || state.complainModel.complain![index].complainStatus == ''? '':
                                                        state.complainModel.complain![index].complainStatus.toString()??'', style: TextStyle(fontWeight: FontWeight.w700,
                                                          fontSize: 14, fontFamily: 'Product Sans', color: state.complainModel.complain![index].
                                                          complainStatus.toString() == 'Pending'
                                                              ? Color(0xffF8D636)
                                                              : state.complainModel.complain![index].complainStatus.toString() == 'Completed' ? Colors.green : Colors.red),),
                                                      const SizedBox(height: 35,),
                                                      InkWell(
                                                        borderRadius: BorderRadius.circular(12),
                                                        onTap: (){
                                                          viewMoreSheet(state.complainModel.complain![index]);
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: Constant.bgBtnLight,
                                                              borderRadius: BorderRadius.circular(12)
                                                          ),
                                                          child: const Text('View more', style: TextStyle(fontWeight: FontWeight.w400,
                                                              fontSize: 12, fontFamily: 'Product Sans', color: Constant.bgText),),
                                                        ),
                                                      )
                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },),
                                  )

                                ],
                              );
                            }
                            if(state is ComplainError){
                              return Center(child: Container(
                                child: Text(state.error),
                              ),);
                            }
                            return SizedBox();
                        },)

                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
      // BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
      //   if(state is ComplainLoading){
      //     return Center(child: CircularProgressIndicator());
      //   }
      //   if(state is ComplainSuccess){
      //     Page2App.items = List<String>.generate(state.complainModel.complain!.length, (i) => '${i + 1}');
      //     Page2App.CompList = state.complainModel.complain!.where((element) => element.status == 'Completed').toList();
      //     Page2App.PendingList = state.complainModel.complain!.where((element) => element.status == 'In Process' || element.status == 'Pending').toList();
      //     Page2App.RejectedList = state.complainModel.complain!.where((element) => element.status == 'Rejected').toList();
      //     return Container(
      //       // color: Color(0xfff3f2f7),
      //       height: MediaQuery.of(context).size.height,
      //       child: TabBarView(
      //         children: [
      //           TabApp(page2item: Page2App.items, page2complist: Page2App.CompList, isPending:false),
      //           TabApp(page2item: Page2App.items, page2complist: Page2App.PendingList, isPending:true),
      //           TabApp(page2item: Page2App.items, page2complist: Page2App.RejectedList, isPending:false),
      //         ],
      //       ),
      //     );
      //   }
      //   if(state is ComplainError){
      //     return SizedBox();
      //   }
      //   return SizedBox();
      // },),

      /*),*/
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: /*_showDialog*/addComplainSheet,
        child: const Icon(Icons.add,color: Colors.white, ),
        backgroundColor: Constant.bgLight,
      ),
    );
  }
}
