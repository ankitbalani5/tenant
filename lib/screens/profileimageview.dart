import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageViewScreen extends StatefulWidget {
  String image;
  ProfileImageViewScreen({super.key,required this.image});

  @override
  State<ProfileImageViewScreen> createState() => _ChatImageViewScreenState();
}

class _ChatImageViewScreenState extends State<ProfileImageViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('${widget.image.toString()}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        //backgroundColor: Colors.white,
        body: Container(
            child: PhotoView(
              imageProvider: NetworkImage(
          'https://mydashboard.btroomer.com/${widget.image.toString()}',),
            )
        ),
        // bottomNavigationBar: Container(
        //   color: Colors.black,
        //   height: 50,
        //   width: double.maxFinite,
        // ),
        );
    }
}