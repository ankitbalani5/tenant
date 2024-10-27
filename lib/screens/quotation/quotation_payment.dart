import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roomertenant/api/apitget.dart';
import 'package:roomertenant/model/pdfquote_model.dart';
import 'package:roomertenant/screens/newhome.dart';
import 'package:roomertenant/screens/quotation/quotation_bloc/quotation_bloc.dart';
import 'package:roomertenant/screens/quotation/quotation_bloc/quotation_event.dart';
import 'package:roomertenant/screens/quotation/quotation_bloc/quotation_state.dart';
import 'package:roomertenant/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotationPayment extends StatefulWidget {
  const QuotationPayment({Key? key}): super(key: key);

  @override
  State<QuotationPayment> createState() => _QuotationPaymentState();
}

class _QuotationPaymentState extends State<QuotationPayment> {

  var quotationContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuotationBloc>(
            create: (BuildContext context) => QuotationBloc(API())
        ),],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quotation Payment'),
          foregroundColor: Colors.white,
          backgroundColor:primaryColor,
          // foregroundColor: Colors.black,
        ),
        body: BlocProvider(
          create: (BuildContext context) => QuotationBloc(API(),)..add(LoadQuotationUserEvent()),
          child: quotationBlocBody(),
        ),
      ),
    );
  }
  Widget quotationBlocBody() {
    return BlocBuilder <QuotationBloc, QuotationState>(
        builder: (context, state) {
          quotationContext = context;
          if (state is QuotationLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is QuotationLoadedState) {
            QuotationModel quotationList = state.quotationDetail;
            return StatefulBuilder(
              builder: ((context, setState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: RefreshIndicator(
                    onRefresh: () async{
                      BlocProvider.of<QuotationBloc>(context).add(LoadQuotationUserEvent());
                    },
                    child: Center(
                      child: SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            quotationList!.pdfQuote!.isNotEmpty ?
                            Expanded(
                                child: ListView.builder(
                                    itemCount: quotationList!.pdfQuote!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.zero,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Rec ${quotationList!
                                                      .pdfQuote![index].id
                                                      .toString()}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                ),
                                                Text(
                                                  quotationList!.pdfQuote![index]
                                                      .receiptDate.toString(),
                                                  style: TextStyle(
                                                      color:
                                                      Color(0xffABAFB8)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8,),
                                            Text(
                                              "₹ ${quotationList!.pdfQuote![index]
                                                  .totalPay}",
                                              style: TextStyle(
                                                  color:
                                                  Color(0xff67BA6C),
                                                  fontSize: 18),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                TextButton(
                                                  style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.zero,),
                                                  onPressed: () async {
                                                    await _dialogCall(context,
                                                        quotationList.pdfQuote![index].id!.toString(),quotationContext
                                                    );
                                                  },
                                                  child: const Text("Upload",
                                                    style: TextStyle(
                                                        color: Color(0xff001944),
                                                        fontSize: 13),),),
                                                SizedBox(width: 10,),
                                                TextButton(
                                                  style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.zero,),
                                                  onPressed: () async {
                                                    showDialog<String>(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      barrierLabel: MaterialLocalizations
                                                          .of(context)
                                                          .modalBarrierDismissLabel,
                                                      builder: (BuildContext
                                                      context) =>
                                                          WillPopScope(
                                                            onWillPop: () async => false,
                                                            child: AlertDialog(
                                                              elevation: 0,
                                                              backgroundColor: Colors
                                                                  .transparent,
                                                              content: Container(
                                                                child: Image
                                                                    .asset(
                                                                    'assets/images/loading_anim.gif'),
                                                                height: 100,
                                                              ),
                                                            ),
                                                          ),
                                                    );
                                                    await openFile(
                                                      url: quotationList!.pdfQuote![index].url.toString(),
                                                      fileName:
                                                      "Rec:${quotationList!.pdfQuote![index].id}-${quotationList!.pdfQuote![index].receiptDate}.pdf",

                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Download",
                                                    style: TextStyle(
                                                        color: Color(0xff001944),
                                                        fontSize: 13),),
                                                  //color: Colors.red,
                                                ),
                                                quotationList!.pdfQuote![index].screenShortData!.length > 0
                                                    ? IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            StatefulBuilder(
                                                                builder:
                                                                    (context,
                                                                    setSate) {
                                                                  return AlertDialog(
                                                                    insetPadding:
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 10),
                                                                    title:
                                                                    Center(
                                                                      child:
                                                                      Text(
                                                                        "Payment Screenshot List",
                                                                        style: TextStyle(
                                                                            fontSize: 18),),
                                                                    ),
                                                                    content: Container(
                                                                      width: MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment
                                                                            .center,
                                                                        mainAxisSize: MainAxisSize
                                                                            .min,
                                                                        children: [
                                                                          Container(
                                                                            child: ListView
                                                                                .builder(
                                                                                shrinkWrap: true,
                                                                                itemCount: quotationList!.pdfQuote![index].screenShortData!.length,
                                                                                itemBuilder: (context, indexes) {
                                                                                  setupStatusapprove() async {
                                                                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                    prefs.setString('payment_status',
                                                                                      quotationList!.pdfQuote![index].screenShortData![indexes].paymentStatus.toString(),);
                                                                                    setState(() {});
                                                                                  }
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .symmetric(
                                                                                        horizontal: 0,
                                                                                        vertical: 0),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize
                                                                                          .min,
                                                                                      mainAxisAlignment: MainAxisAlignment
                                                                                          .start,
                                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                                          .start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                              .spaceBetween,
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Text(
                                                                                                  "Rec ${quotationList.pdfQuote![index].screenShortData![indexes].id.toString()}",
                                                                                                  style: TextStyle(
                                                                                                      fontSize: 16,
                                                                                                      fontWeight: FontWeight
                                                                                                          .bold),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Text(
                                                                                              quotationList!.pdfQuote![index].screenShortData![indexes].insertedAt.toString(),
                                                                                              style: TextStyle(
                                                                                                  color:
                                                                                                  Color(
                                                                                                      0xffABAFB8)),
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
                                                                                                    color: Color(
                                                                                                        0xffABAFB8),
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  quotationList!.pdfQuote![index].screenShortData![indexes].remark.toString(),
                                                                                                  style: TextStyle(
                                                                                                      fontWeight: FontWeight
                                                                                                          .bold),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'Payment Status : ',
                                                                                              style: TextStyle(
                                                                                                color: Color(
                                                                                                    0xffABAFB8),
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              quotationList!.pdfQuote![index].screenShortData![indexes].paymentStatus.toString(),
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight
                                                                                                      .bold),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,),

                                                                                        Image.network(
                                                                                          quotationList!.pdfQuote![index].screenShortData![indexes].screenShot.toString(),
                                                                                          width: 400,
                                                                                          height: 400,),
                                                                                        Divider(
                                                                                          thickness: 1,
                                                                                          color: Color(
                                                                                              0xffD9E2FF),
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
                                                                          style: ElevatedButton
                                                                              .styleFrom(
                                                                              backgroundColor: Color(
                                                                                  0xff001944),
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      20))),
                                                                          onPressed: () =>
                                                                              Navigator
                                                                                  .pop(
                                                                                  context),
                                                                          child: Text(
                                                                            "Close",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),))
                                                                    ],
                                                                  );
                                                                }));
                                                  },
                                                  icon: Image.asset(
                                                    "assets/images/credit-card.png",
                                                    width: 25,
                                                    height: 25,
                                                    color: Color(0xff001944),),)
                                                    : SizedBox()
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xffD9E2FF),
                                            )
                                          ],
                                        ),
                                      );
                                    })) : Center(
                              child: Container(
                                alignment: Alignment.center,


                                child: Text(
                                    "No data found !!"
                                ),
                              ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }
          if (state is QuotationErrorState) {
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

  Future<void> _dialogCall(BuildContext context, String id,var quotationcontext) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(id,quotationcontext);
        });
  }
}

class MyDialog extends StatefulWidget {
  String id; var quotationcontext;
  MyDialog(this.id,this.quotationcontext,{Key? key}): super(key: key);
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
                    branch_id, userId.toString(), remarkController.text, _storedImage!,widget.id,context).then((value){
                  Navigator.pop(context);
                  BlocProvider.of<QuotationBloc>(widget.quotationcontext).add(LoadQuotationUserEvent());
                  setState(() {});
                });
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
