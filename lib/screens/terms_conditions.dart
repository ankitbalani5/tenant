
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import 'package:path_provider/path_provider.dart';

import '../constant/constant.dart';
import '../model/terms_model.dart';
import 'internet_check.dart';

class TermsConditions extends StatefulWidget {

   TermsConditions({Key? key,}) : super(key: key);
   static const String id = 'TermsConditions';

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  TermsModel? termsModel;
  List<Datum> textList = [] ;
  List<Datum> pdfList = [] ;

  Future getTermsList()async{
    final arguments = ModalRoute.of(context)?.settings.arguments ;
    termsModel = arguments as TermsModel;
    textList = [];
    pdfList = [];
     termsModel!.data?.forEach((element) {
      if(element.isPdf.toString() == "0"){
        textList.add(element);
      }else{
        pdfList.add(element);
      }
    });
     print(textList.toString());
     print(pdfList.toString());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getTermsList().then((value) => setState((){}));
    });

  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color(0xff001944),
        //   foregroundColor: Colors.white,
        //   title: Text("Terms & Conditions"),
        // ),
        body: NetworkObserverBlock(
          child: Stack(
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
                                'Terms & Conditions',
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
                            height: 45,
                            child: TabBar(
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                                color: Constant.bgLight/*Color(0xff001944)*/,
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(icon: Icon(Icons.text_snippet_outlined)),
                                Tab(icon: Icon(Icons.picture_as_pdf_outlined),
                                )],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TabBarView(
                              children: [
                               Padding(
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
                                          // print(pdfList[index].url.toString()+pdfList[index].tcPdf.toString());
                                          print(pdfList[index].tcPdf.toString());
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "* T & C ",/*Updated on ${pdfList[index].updatedAt.toString().split("T")[0]}*/
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
                                                    url: pdfList[index].tcPdf.toString(),/*+"/"+pdfList[index].tcPdf.toString()*/
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
                               ),
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

}



