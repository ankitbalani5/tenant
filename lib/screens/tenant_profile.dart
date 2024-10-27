import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';


class Page1App extends StatefulWidget {
  static const String id = "page1";
  Page1App({Key? key}) : super(key: key);
  @override
  _Page1AppState createState() => _Page1AppState();
}

class _Page1AppState extends State<Page1App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: [
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 140,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/man.png'),
                          iconSize: 80,
                          color: Colors.blue,
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.picture_as_pdf_rounded),
                      color: Colors.red,
                      iconSize: 25,
                      onPressed: () {
                        OpenFilex.open(
                            "/storage/emulated/0/Download/zucol_download.pdf");
                      }, // will be added
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Name'),
                    Divider(
                      color: Colors.black,
                      indent: 30,
                      endIndent: 30,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text('Contact')),
                          VerticalDivider(
                            color: Colors.black,
                            width: 20,
                          ),
                          Expanded(child: Text('Room/Bed\nR 497/Bed-00')),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text('Gender\n Male')),
                          VerticalDivider(
                            color: Colors.black,
                            width: 20,
                          ),
                          Expanded(child: Text('DOB')),
                          VerticalDivider(
                            color: Colors.black,
                            width: 20,
                          ),
                          Expanded(child: Text('Date of Regi\n 23-Sep-2021')),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text('Courses')),
                          VerticalDivider(
                            color: Colors.black,
                            width: 20,
                          ),
                          Expanded(child: Text('Institution')),
                          VerticalDivider(
                            color: Colors.black,
                            width: 20,
                          ),
                          Expanded(child: Text('Marital Status')),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
