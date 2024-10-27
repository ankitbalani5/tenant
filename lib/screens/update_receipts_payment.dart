import 'package:flutter/material.dart';

import '../constant/constant.dart';

class UpdateReceiptsPayment extends StatefulWidget {
  const UpdateReceiptsPayment({super.key});

  @override
  State<UpdateReceiptsPayment> createState() => _UpdateReceiptsPaymentState();
}

class _UpdateReceiptsPaymentState extends State<UpdateReceiptsPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Explore',
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
              child: Container(
                decoration: const BoxDecoration(
                    color: Constant.bgTile,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
                ),
                child: Column(
                  children: [
                    Text('Resident'),
                    TextFormField(

                    )
                  ],
                ),
              )
          )
        ],
      )
    );
  }
}
