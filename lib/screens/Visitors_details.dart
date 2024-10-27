import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/model/pdfquote_model.dart';
import 'package:roomertenant/model/visitor_model.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/userprofile.dart';
import 'package:roomertenant/screens/visitor_list/visitor_bloc/visitor_bloc.dart';
import 'package:roomertenant/screens/visitor_list/visitor_bloc/visitor_event.dart';
import 'package:roomertenant/screens/visitor_list/visitor_bloc/visitor_state.dart';
import 'package:roomertenant/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';
import 'internet_check.dart';

class VisitorsDetails extends StatefulWidget {
  const VisitorsDetails({Key? key}): super(key: key);

  @override
  State<VisitorsDetails> createState() => _VisitorsDetailsState();
}

class _VisitorsDetailsState extends State<VisitorsDetails> {
  var visitorContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VisitorBloc>(
            create: (BuildContext context) => VisitorBloc(API())
        ),],
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Visitor Details'),
        //   foregroundColor: Colors.white,
        //   backgroundColor:primaryColor,
        //   // foregroundColor: Colors.black,
        // ),
        body:  NetworkObserverBlock(
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
                          'Visitor Details',
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
              child: BlocProvider(
              create: (BuildContext context) => VisitorBloc(API(),)..add(LoadVisitorEvent()),
              child: visitorBlocBody(),
              ),)))
            ],
          ),
        )

      ),
    );
  }
  Widget visitorBlocBody() {
    return BlocBuilder <VisitorBloc, VisitorState>(
        builder: (context, state) {
          visitorContext = context;
          if (state is VisitorLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is VisitorLoadedState) {
            VisitorModel visitorList = state.visitorDetail;
            visitorList.data!.sort((a, b) => b.visitDate!.compareTo(a.visitDate!));

            return Scaffold(

              floatingActionButton: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: (){
                    _dialogContext(context,visitorContext);
                  },
                  child: const Icon(Icons.add,color: Colors.white),
                  backgroundColor: Constant.bgLight,
                  shape: RoundedRectangleBorder(/*side: BorderSide(width: 3,color: Colors.brown),*/borderRadius: BorderRadius.circular(100)),
                ),
              ),
              body: StatefulBuilder(
                builder: ((context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0),
                    child: RefreshIndicator(
                      onRefresh: () async{
                        BlocProvider.of<VisitorBloc>(context).add(LoadVisitorEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: Center(
                          child: SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                visitorList!.data!.isNotEmpty?
                                Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                        itemCount: visitorList!.data!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Constant.bgTile
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${visitorList!.data![index].visitorName.toString()}",
                                                            style: const TextStyle(
                                                                fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(visitorList!.data![index].visitDate.toString(),
                                                        style: const TextStyle(
                                                            color:
                                                            Color(0xffABAFB8)),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    "Aadhaar No: ${visitorList!.data![index].aadharNo}",
                                                    style: const TextStyle(
                                                        color:
                                                        Color(0xffABAFB8),fontSize: 14),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                            padding: EdgeInsets.zero),
                                                        onPressed: () async {
                                                          /*await _dialogCall(context,snapshot.data!.visitor![index].id!.toString(),
                                                                );*/
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext
                                                            context) =>
                                                                AlertDialog(
                                                                  insetPadding: EdgeInsets.all(16),
                                                                  title: const Text('Are you sure to Mark Visited ?',style: TextStyle(fontSize: 18),),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(context, 'No'),
                                                                      child: const Text('No'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () async{
                                                                        await API.removeVisitor(visitorList!.data![index].id.toString(),
                                                                            context).then((value) {
                                                                          if (value['success'] == '1') {
                                                                            print(value.toString() + " value");
                                                                            Fluttertoast.showToast(msg: value['details']);
                                                                            setState(() {});
                                                                          } else {
                                                                            Fluttertoast.showToast(msg: value['details']);
                                                                          }
                                                                        });
                                                                        BlocProvider.of<VisitorBloc>(visitorContext).add(LoadVisitorEvent());
                                                                        setState((){});
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const Text('YES'),
                                                                    ),
                                                                  ],
                                                                ),
                                                          );
                                                        }, child: Text("Mark Visited",style: TextStyle(color: Color(0xff001944),fontSize: 13),),),
                                                      const SizedBox(width: 10,),
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                            padding: EdgeInsets.zero),
                                                        onPressed: state.visitorDetail.data![index].document!.isNotEmpty ?() async {

                                                          showDialog<String>(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                                            builder: (BuildContext
                                                            context) =>
                                                                WillPopScope(
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
                                                            url: 'https://mydashboard.btroomer.com/${visitorList!.data![index].document.toString()}',
                                                            fileName:
                                                            "Rec:${visitorList!.data![index].id}-${visitorList!.data![index].visitDate}.jpg",

                                                          );
                                                          Navigator.of(context).pop();
                                                        } : (){
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Image Available')));
                                                        },
                                                        child: const Text("View Doc",style: TextStyle(color: Color(0xff001944),fontSize: 13),
                                                          //color: Colors.red,
                                                        ),
                                                        /*snapshot.data!.visitor![index].screenShortData!.length > 0
                                                         ? IconButton(
                                                              onPressed: (){
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) =>
                                                                        StatefulBuilder(builder:
                                                                            (context,
                                                                            setSate) {
                                                                          return AlertDialog(
                                                                            insetPadding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                            title:
                                                                            Center(
                                                                              child:
                                                                              Text("Payment Screenshot List",style: TextStyle(fontSize: 18),),
                                                                            ),
                                                                            content: Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Container(
                                                                                    child: ListView.builder(
                                                                                      shrinkWrap: true,
                                                                              itemCount: snapshot.data!.pdfQuote![index].screenShortData!.length,
                                                                                itemBuilder: (context, indexes) {
                                                                                  setupStatusapprove() async{
                                                                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                    prefs.setString('payment_status',snapshot.data!.pdfQuote![index].screenShortData![indexes].paymentStatus.toString(),);
                                                                                    setState(() {});
                                                                                  }
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                "Rec ${snapshot.data!.pdfQuote![index].screenShortData![indexes].id.toString()}",
                                                                                                style: TextStyle(
                                                                                                    fontSize: 16,
                                                                                                    fontWeight: FontWeight
                                                                                                        .bold),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Text( snapshot.data!.pdfQuote![index].screenShortData![indexes].insertedAt.toString(),
                                                                                            style: TextStyle(
                                                                                                color:
                                                                                                Color(0xffABAFB8)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 8,
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                'Remark : ',
                                                                                                style: TextStyle(
                                                                                                  color: Color(0xffABAFB8),
                                                                                                ),
                                                                                              ),
                                                                                              Text(snapshot.data!.pdfQuote![index].screenShortData![indexes].remark.toString(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 10,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            'Payment Status : ',
                                                                                            style: TextStyle(
                                                                                              color: Color(0xffABAFB8),
                                                                                            ),
                                                                                          ),
                                                                                          Text(snapshot.data!.pdfQuote![index].screenShortData![indexes].paymentStatus.toString(),
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(height: 10,),

                                                                                      Image.network(snapshot.data!.pdfQuote![index].screenShortData![indexes].screenShot.toString(),
                                                                                        width: 400,height: 400,),
                                                                                      Divider(
                                                                                        thickness: 1,
                                                                                        color: Color(0xffD9E2FF),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                                }),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(primary: Color(0xff001944),
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                                                                  onPressed: () => Navigator.pop(context),
                                                                                  child: Text("Close",style: TextStyle(color: Colors.white),))
                                                                            ],
                                                                          );
                                                                        }));
                                                              },
                                                              icon: Image.asset("assets/images/credit-card.png",
                                                                width: 30,height: 30,color: Color(0xff001944),),)
                                                              : SizedBox()*/
                                                      )
                                                    ],),
                                                  // const Divider(
                                                  //   thickness: 1,
                                                  //   color: Color(0xffD9E2FF),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          );
                                        })): Expanded(
                                          child: Center(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: const Text(
                                          "No data found !!"
                                              ),
                                            ),),
                                        ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }
          if (state is VisitorErrorState) {
            return Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.error),
                ),
              ),
            );
          }
          return Center(
            child: Container(
              child: Text("No Data is found for display"),
            ),
          );
        });
  }
  Future openFile({required String url, required String? fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) return;
    print('Path : ${file.path}');

    OpenFilex.open(file.path);
  }

  Future<File?> downloadFile(String url, String? name) async {
    final appstorage = await getApplicationDocumentsDirectory();
    final file = File('${appstorage.path}/$name');

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }
  File? _storedImage;
  String _storedImage1 = "";
  XFile? imageFileFromCamera;

  Future<void> _takePictureFromGallery() async {
    final picker = ImagePicker();
    final imageFileFromGallery = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFileFromGallery!.path);
      _storedImage1 = _storedImage.toString();
    });
    print('Image path:---- ${_storedImage}');
  }

  Future<void> _dialogCall(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(id);
        });
  }
  Future<void> _dialogContext(BuildContext context,var visitorcontext) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyOpenDialog(visitorcontext);
        });
  }
}

class MyOpenDialog extends StatefulWidget {
  var visitorcontext;
  MyOpenDialog(this.visitorcontext,{Key? key}): super(key: key);
  static dynamic visitorDetails;
  @override
  _MyOpenDialogState createState() => _MyOpenDialogState();
}

class _MyOpenDialogState extends State<MyOpenDialog> {

  var _formKey = GlobalKey<FormState>();
  File? _storedImage;
  String _storedImage1 = "";
  XFile? imageFileFromCamera;
  TextEditingController remarkController = TextEditingController();
  TextEditingController visitorNameController = TextEditingController();
  final TextEditingController visitDateController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();



  Future<void> _takePictureFromGallery() async {
    final picker = ImagePicker();
    final imageFileFromGallery = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    setState(() {
      if (imageFileFromGallery != null) {
        _storedImage = File(imageFileFromGallery.path);
        _storedImage1 = _storedImage!.path;
      } else {
        // Set _storedImage1 to a blank string when image is not chosen
        _storedImage1 = '';
      }
    });

    print('Image path: ${_storedImage}');
  }


  // Future<void> _takePictureFromGallery() async {
  //   final picker = ImagePicker();
  //   final imageFileFromGallery = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 600,
  //   );
  //   setState(() {
  //     _storedImage = File(imageFileFromGallery!.path);
  //     _storedImage1 = _storedImage.toString();
  //   });
  //   print('Image path:---- ${_storedImage}');
  // }
  Future onRefresh() async {
    MyOpenDialog.visitorDetails = await API().getVisitors();
  }
  DateTime _selectToday = DateTime.now();
  DateTime _visitDay = DateTime.now();
  void _visitDate() {
    showDatePicker(context: context, initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _visitDay = pickedDate;
        visitDateController.text = formatDate(_visitDay, [dd, '-', mm, '-', yyyy]);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      title: Center(
        child: Text("Add Visitor",style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w500),),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 5,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: TextFormField(
                        controller: visitorNameController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            label: Text('Visitor Name'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            )),
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'Enter visitor name';
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _visitDate();
                          visitDateController.text = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
                        });
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: TextFormField(
                          onTap: () {
                            _visitDate();
                          },
                          enabled: false,
                          controller: visitDateController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              label: Text('Visit Date'),
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              )),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please choose date';
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12),
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: aadharNumberController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            label: Text('Aadhaar Number'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            )),
                        validator: (value) {
                          if(value == null || value.isEmpty || value.length != 12){
                            return 'Aadhaar no should be 12 digit';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: TextFormField(
                        // inputFormatters: [
                        //   LengthLimitingTextInputFormatter(12),
                        //   FilteringTextInputFormatter.digitsOnly,
                        //   FilteringTextInputFormatter.singleLineFormatter
                        // ],
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: discriptionController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            label: Text('Discription'),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                            )),
                        validator: (value) {
                          if(value == null || value.isEmpty ){
                            return 'Please enter Discription';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Upload doc file',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              _takePictureFromGallery();

                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Color(0xff001944)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _storedImage != null
                                ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.file(
                                  _storedImage!,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            )
                                : Column(
                              children: [
                                Image.asset(
                                  "assets/images/gallery_01.png",
                                  width: 70,
                                ),
                                Text('Gallery',style: TextStyle(fontWeight: FontWeight.w500),)
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.bgButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ), // Background color
                ),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(visitorNameController.text.isNotEmpty && visitDateController.text.isNotEmpty &&
                        aadharNumberController.text.isNotEmpty){
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      String branch_id = await prefs.getString("branch_id").toString();
                      final userId = prefs.getString('tenant_id');
                      await API.visitorData( branch_id, userId.toString(), visitorNameController.text,
                          visitDateController.text, aadharNumberController.text, discriptionController.text, _storedImage1,
                          context).then((value) {
                        if (value['success'] == 1) {
                          print(value.toString() + " value");
                          Fluttertoast.showToast(msg: value['details']);
                          Navigator.pop(context);
                          BlocProvider.of<VisitorBloc>(widget.visitorcontext).add(LoadVisitorEvent());
                          print('https://mydashboard.btroomer.com/${_storedImage}');
                          setState(() {});
                        } else {
                          Fluttertoast.showToast(msg: value['details']);
                        }
                      });
                    } else {
                      await Fluttertoast.showToast(
                        msg: "Add Name and other Details",
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Color(0xff001944),
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                    }
                  }

                }, child: const Text("Submit",style: TextStyle(color: Colors.white),)),
            const SizedBox(width: 20,),
            SizedBox(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.bgButton, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",style: TextStyle(color: Colors.white),)),
            )
          ],
        )
      ],
    );
  }
}



class MyDialog extends StatefulWidget {
  String id;
  MyDialog(this.id,{Key? key}): super(key: key);
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  File? _storedImage;
  String _storedImage1 = "";
  XFile? imageFileFromCamera;
  TextEditingController remarkController = TextEditingController();

  Future<void> _takePictureFromGallery() async {
    final picker = ImagePicker();
    final imageFileFromGallery = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFileFromGallery!.path);
      _storedImage1 = _storedImage.toString();
    });
    print('Image path:---- ${_storedImage}');
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      title: Center(
        child: Text("Upload payment screenshot",style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w500),),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Document',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _takePictureFromGallery();
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Color(0xff001944)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _storedImage != null
                            ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(
                              _storedImage!,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          ),
                        )
                            : Column(
                          children: [
                            Image.asset(
                              "assets/images/gallery_01.png",
                              width: 70,
                            ),
                            Text('Gallery',style: TextStyle(fontWeight: FontWeight.w500),)
                          ],
                        ),
                      )),
                ),
                SizedBox(width: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: TextField(
                    controller: remarkController,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        label: Text('Remark'),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff001944),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ), // Background color
            ),
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              String payment_status = await prefs.getString("payment_status").toString();
              print("paymentstatus ${payment_status}");
              if(remarkController.text.isNotEmpty){
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                String branch_id = await prefs.getString("branch_id").toString();
                final userId = prefs.getString('id');
                await API.sendScreenShotImg(
                    branch_id, userId.toString(), remarkController.text, _storedImage!,widget.id,context);
                await Fluttertoast.showToast(
                  msg: "Screenshot Uploaded Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Color(0xff001944),
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
                Navigator.pop(context);
              } else {
                await Fluttertoast.showToast(
                  msg: "Select Image & add remark",
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Color(0xff001944),
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
              }
            }, child: Text("Submit",style: TextStyle(color: Colors.white),))
      ],
    );
  }
}
