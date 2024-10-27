import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomertenant/constant/constant.dart';
import 'package:roomertenant/screens/eligibility_form.dart';
import 'package:roomertenant/screens/eqaro_bond.dart';
import 'package:roomertenant/screens/login.dart';
import 'package:roomertenant/widgets/navBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/apitget.dart';

class Eqaro extends StatefulWidget {
  const Eqaro({super.key});

  @override
  State<Eqaro> createState() => _EqaroState();
}

class _EqaroState extends State<Eqaro> {
  String? name;
  String? token;
  bool isloading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('pan_no');
    await pref.remove('adhaar_no');
    name = pref.getString('name');
    String branch_id = pref.getString('branch_id').toString();
    String res_id = pref.getString('tenant_id').toString();
    String pg_id = pref.getString('pg_id').toString();
    setState((){});
    print('name ----- ${name}');
    API.eqaro(branch_id, res_id, pg_id).then((value) {

      pref.setString('id', value.data![0].residentData!.user!.id.toString());
      pref.setString('propertyId', value.data![0].residentData!.user!.propertyId.toString());
      pref.setString('access_token', value.data![0].residentData!.access!.token.toString()).toString();
      pref.setString('dob', value.data![0].residentData!.user!.dob.toString());
      pref.setString('gender', value.data![0].residentData!.user!.gender.toString());
      pref.setString('landlord_id', value.data![0].landlordId.toString());
      pref.setString('productId', value.data![0].productId.toString());


      pref.setString('avatar', value.data![0].residentData!.user!.avatar.toString());
      token = pref.getString('access_token').toString();
      if(value.data![0].residentData!.user!.employmentDetails!.employment == "Student"){
        pref.setString('not_show_pan', "true");

      }
      print("updated token : ${token}");

      if(value.data![0].residentData!.user!.docs!.length>0)
        {
          value.data![0].residentData!.user!.docs!.map((e) {
            if(e.docType == 'adhaar'){
              //print("adhaar card id--${e.docId}");
              pref.setString('adhaar_no', e.docId.toString());

              pref.setString('aadhar_metadata', e.metadata.toString());
            }
            if(e.docType == 'pan'){
              //print("pan card--${e.docId}");
              pref.setString('pan_no', e.docId.toString());
            }
          }).toList();
        }



      if(value.data![0].residentData!.user!.aadharVerify.toString() == 'No'){
        isloading=false;
      }else{
        isloading=true;

        if(value.data![0].residentData!.user!.eqaroFinalVerification.toString() == "Yes"){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EqaroBond())).then((value) {
            Navigator.pop(context);
          });
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EligibilityForm()));

        }
      }
      setState(() {

      });
      print('token fetch---${token}');
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isloading){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  color: Constant.bgLight,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                    child: Row(
                      children: [
                        // InkWell(
                        //     onTap: () {
                        //       Navigator.pop(context);
                        //     },
                        //     child: const Icon(
                        //       Icons.arrow_back_ios,
                        //       size: 18,
                        //       color: Colors.white,
                        //     )),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Text(
                          'Aadhaar Verify',
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              Text('Welcome! ${name}', style: const TextStyle(color: Constant.bgLight, fontSize: 20, fontWeight: FontWeight.w500, ),),
                              const SizedBox(height: 20,),
                              const Text('This application should take no less than 3 minutes. As a part of the process, we will ask you to verify your Aadhaar to proceed.'),
                              const SizedBox(height: 20,),
                              const Text("You'll need to:", style: TextStyle(fontWeight: FontWeight.w500),),
                              const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Constant.bgLight.withOpacity(0.5), width: 1)
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified, color: Constant.bgLight),
                                    SizedBox(width: 10,),
                                    Text('Verify your Aadhaar and check your eligibility')
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Constant.bgLight.withOpacity(0.5), width: 1)
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified, color: Constant.bgLight),
                                    SizedBox(width: 10,),
                                    Text('Verify your employment details')
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Constant.bgLight.withOpacity(0.5), width: 1)
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified, color: Constant.bgLight,),
                                    SizedBox(width: 10,),
                                    Text('Add Applicant details, if you are a student')
                                  ],
                                ),
                              ),

                              // Expanded(
                              //   child: Align(
                              //       alignment: Alignment.bottomCenter,
                              //       child: BottomAppBar(
                              //         height: 30,
                              //         child: Center(child: Text('ablj')),)),
                              // )

                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                                  child: Center(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.verified_user, color: Constant.bgLight, size: 15,),
                                        SizedBox(width: 5,),
                                        Expanded(child: Text('Your data is safe with us. You can take'
                                            ' a look at our privacy policy here',
                                          style: TextStyle(color: Colors.grey, fontSize: 10),)),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {

                                    // final url = 'https://api.digitallocker.gov.in/public/oauth2/1/authorize?response_type=code&client_id=CE07F040&redirect_uri=https://sandbox.kyckart.com/page/digilocker-auth-complete&state=e02781b3425d1d94ef74ccfd570593c5';

                                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WebViewScreen(url: url)), (route) => false);

                                    //request_id should be save

                                    // FutureBuilder(
                                    //   future: API.verifyAadhar('token'),
                                    //   builder: (context, snapshot) {
                                    //     if(snapshot.hasData){
                                    //
                                    //     }
                                    //   },
                                    // );

                                    // 'https://api.digitallocker.gov.in/public/oauth2/1/authorize?response_type=code&client_id=CE07F040&redirect_uri=https://sandbox.kyckart.com/page/digilocker-auth-complete&state=e02781b3425d1d94ef74ccfd570593c5'

                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> EligibilityForm()));
                                    API.verifyAadhar(token.toString()/*'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NjBhNGU5OWNhMzBhZDAwMjgyMTc5ZDAiLCJpYXQiOjE3MTE5NjQwNjAsImV4cCI6MTcxMjEzNjg2MCwidHlwZSI6ImFjY2VzcyJ9.9qbFc545NtlB15iB5rUL9VE0ICvaJuaXD3CoKWtnH_Y'*/)
                                        .then((value) async{

                                      final Url = value.url;
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      final requested = pref.setString('requestId', value.requestId.toString());

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(url: Url.toString())));

                                    });

                                  },
                                  child: Container(
                                    height: 50,
                                    color: Constant.bgLight,
                                    child: const Center(child: Text('VERIFY AADHAAR', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          )

      );
    }

  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool isLoading = true;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     // ..addJavaScriptChannel('MessageChannel', onMessageReceived: (JavascriptMessage message) {
  //     //   // Handle the message received from JavaScript
  //     //   String response = message.message;
  //     //   print('Response from WebView: $response');
  //     // },)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           // Update loading bar.
  //         },
  //         onPageStarted: (String url) {
  //         },
  //         onPageFinished: (String url) {
  //           isLoading = false;
  //           setState(() {
  //
  //           });
  //         },
  //         onWebResourceError: (WebResourceError error) {},
  //         onNavigationRequest: (NavigationRequest request) {
  //           // if (request.url.startsWith('https://www.youtube.com/')) {
  //           //   return NavigationDecision.prevent;
  //           // }
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        backgroundColor: Colors.white,
        javascriptChannels: <JavascriptChannel>{
          // Define a JavascriptChannel to receive messages from JavaScript
          JavascriptChannel(
            name: 'MessageChannel',
            onMessageReceived: (JavascriptMessage message) {
              // Handle the message received from JavaScript
              String response = message.message;
              print('Response from WebView: $response');
            },
          ),
        },
        onPageStarted: (url) {
          CircularProgressIndicator(color: Colors.blue,);
        },
        onProgress: (progress) {
          CircularProgressIndicator(color: Colors.blue,);
        },

        onPageFinished: (String url) {
                    isLoading = false;
                    setState(() {

                    });
          // After the page is loaded, execute JavaScript to get response
          handleCallbackUrl(url);
          print('abcde');
          _webViewController.evaluateJavascript('''
            // Execute JavaScript code to get the response
            // For example, get the text content of an element with ID "response"
            var response = document.getElementById('response').innerText;
            // Send the response back to Flutter using the MessageChannel
            MessageChannel.postMessage(response);
          ''');
        },
      ),
    );
    //   Stack(
    //     children: [
    //       WebViewWidget(controller: controller),
    //       if (isLoading)
    //         const Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //     ],
    //   ),
    // );


  }
  handleCallbackUrl(url) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('access_token');
    final requestId = pref.getString('requestId');
    String branch_id = pref.getString('branch_id').toString();
    String res_id = pref.getString('tenant_id').toString();
    print('token:::${token}');
    print('requestId:::${requestId}');
    API.getEAadhaar(token.toString(), requestId.toString(), context, branch_id, res_id).then((value) {
    });
  }
}



// class WebViewScreen extends StatelessWidget {
//   final String url;
//   WebViewScreen({required this.url});
//
//   WebViewController controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
//   ..setNavigationDelegate(
//   NavigationDelegate(
//   onProgress: (int progress) {
//   // Update loading bar.
//   },
//   onPageStarted: (String url) {},
//   onPageFinished: (String url) {},
//   onWebResourceError: (WebResourceError error) {},
//   onNavigationRequest: (NavigationRequest request) {
//   if (request.url.startsWith('https://www.youtube.com/')) {
//   return NavigationDecision.prevent;
//   }
//   return NavigationDecision.navigate;
//   },
//   ),
//   )
//   ..loadRequest(Uri.parse(url));
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('WebView'),
//       ),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }