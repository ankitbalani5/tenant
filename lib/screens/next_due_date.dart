import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/newhome.dart';

class QrcodePage extends StatefulWidget {
  static const String id = 'qrcodepage';
  @override
  _QrcodePageState createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  final double coverHeight = 340;
  final double profileHeight = 510;
  @override
  Widget build(BuildContext context) {
    final bottom = profileHeight / 2;
    final cliptop = coverHeight - profileHeight / 2;
    return Scaffold(
      body: SafeArea(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Constant.bgLight/*const Color(0xff001944)*/,
                      margin: EdgeInsets.only(bottom: bottom),
                      width: MediaQuery.of(context).size.width,
                      height: coverHeight,
                      child: Column(
                        children: [
                          Row(children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 20.0, right: 20),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                              EdgeInsets.only(top: 20.0, left: 60),
                              child: Text(
                                "My QR code",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Positioned(
                        top: cliptop,
                        child: Card(
                          color: Colors.white,
                          child: Container(
                            height: 500,
                            width: 300,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  // NewHomeApp.userValues['pg_detail']["pg_name"],
                                  "${NewHomeApp.userValues.pgDetails.pgName}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Scan QR Code to Pay your Due Rent ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Image.asset("assets/images/image7.png"),
                                NewHomeApp.userValues.pgDetails.qrCode != ""
                               ? Image.network("${NewHomeApp.userValues.pgDetails.qrCode}")
                                : const SizedBox(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("Upi register name: ${NewHomeApp.userValues.pgDetails.upiRegisterName}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("UPI Id: ${NewHomeApp.userValues.pgDetails.upiId}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    InkWell(
                                        onTap: (){
                                          Clipboard.setData(ClipboardData(text: NewHomeApp.userValues.pgDetails.upiId.toString())).then((value) {
                                            Fluttertoast.showToast(
                                                msg: 'Copy Text',
                                                toastLength: Toast.LENGTH_SHORT,
                                                // gravity: set ? ToastGravity.TOP : ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: /*set ? Colors.red : */Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Text copied')));
                                            print(NewHomeApp.userValues.pgDetails.upiId.toString());
                                          });
                                        },
                                        child: Icon(Icons.copy, color: Colors.grey,))
                                  ],
                                ),
                                // SizedBox(height: 10,),
                                // InkWell(
                                //   onTap: (){
                                //     Clipboard.setData(ClipboardData(text: NewHomeApp.userValues.pgDetails.upiId.toString())).then((value) {
                                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Text copied')));
                                //       print(NewHomeApp.userValues.pgDetails.upiId.toString());
                                //     });
                                //   },
                                //   child: Container(
                                //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //       decoration: BoxDecoration(
                                //         color: Colors.grey.shade300,
                                //         borderRadius: BorderRadius.circular(12)
                                //       ),
                                //       child: Text('Copy UPI Id', style: TextStyle(),)),
                                // ),
                                const Spacer(),
                                // Container(
                                //   width:
                                //   MediaQuery.of(context).size.width * 0.70,
                                //   height: 50,
                                //   decoration: BoxDecoration(
                                //       color: Color(0xff001944),
                                //       borderRadius: BorderRadius.circular(10)),
                                //   child: const Center(
                                //     child: Text(
                                //       "Pay",
                                //       textAlign: TextAlign.center,
                                //       style: (TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 14,
                                //           fontWeight: FontWeight.w500)),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
