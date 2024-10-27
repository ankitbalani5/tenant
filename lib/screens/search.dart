// import 'package:flutter/material.dart';
//
// import '../constant/constant.dart';
//
// class Search extends StatefulWidget {
//   const Search({super.key});
//
//   @override
//   State<Search> createState() => _SearchState();
// }
//
// class _SearchState extends State<Search> {
//   List occupancy = ['Single', 'Double', 'Triple', '3+'];
//   String pgFor = 'Boys';
//   String occupancySelect = 'Single';
//   double _currentSliderValue = 20.0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//           children: [
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 120,
//                 color: Constant.bgLight,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
//                   child: Row(
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Icon(
//                             Icons.arrow_back_ios,
//                             size: 18,
//                             color: Colors.white,
//                           )),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       const Text(
//                         'Search',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                             fontSize: 20),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Container
//             Positioned(
//                 top: 85,
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 20,),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: TextFormField(
//                             // initialValue: email??'',
//                             // controller: emailController,
//                             decoration: InputDecoration(
//                               suffixIconConstraints: const BoxConstraints(
//                                 minWidth: 40,
//                                 minHeight: 40,
//                               ),
//                               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               // suffixIcon: Padding(
//                               //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                               //   child: Icon(Icons.remove_red_eye_outlined)/*SvgPicture.asset('assets/interested/email.svg')*/,
//                               // ),
//
//                               label: const Text('Pune'),
//                               labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
//                               ),
//                             ),
//                             // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
//
//                           ),
//                         ),
//                         SizedBox(height: 20,),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: TextFormField(
//                             // initialValue: email??'',
//                             // controller: emailController,
//                             decoration: InputDecoration(
//                               suffixIconConstraints: const BoxConstraints(
//                                 minWidth: 40,
//                                 minHeight: 40,
//                               ),
//                               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               prefixIcon: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                                 child: Icon(Icons.pin_drop_outlined)/*SvgPicture.asset('assets/interested/email.svg')*/,
//                               ),
//
//                               label: const Text('Search upto localities or landmarks'),
//                               labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
//                               ),
//                             ),
//                             // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
//
//                           ),
//                         ),
//                         SizedBox(height: 40,),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                           child: Text('Looking For', style: TextStyle(color: Constant.bgText, fontSize: 18),),
//                         ),
//                         SizedBox(height: 10,),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             InkWell(
//                               onTap: (){
//                                 pgFor = 'Boys';
//                                 setState(() {
//
//                                 });
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                                 decoration: BoxDecoration(
//                                     color: pgFor == 'Boys' ? Constant.bgLight : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(20)
//                                 ),
//                                 child: Center(
//                                   child: Text('Boys', style: TextStyle(color: pgFor == 'Boys' ? Colors.white : Constant.bgLight),),
//                                 ),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: (){
//                                 pgFor = 'Girls';
//                                 setState(() {
//
//                                 });
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                                 decoration: BoxDecoration(
//                                     color: pgFor == 'Girls' ? Constant.bgLight : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(20)
//                                 ),
//                                 child: Center(
//                                   child: Text('Girls', style: TextStyle(color: pgFor == 'Girls' ? Colors.white : Constant.bgLight),),
//                                 ),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: (){
//                                 pgFor = 'Both';
//                                 setState(() {
//
//                                 });
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                                 decoration: BoxDecoration(
//                                   color: pgFor == 'Both' ? Constant.bgLight : Colors.grey.shade200,
//                                   borderRadius: BorderRadius.circular(20)
//                                 ),
//                                 child: Center(
//                                   child: Text('Both', style: TextStyle(color: pgFor == 'Both' ? Colors.white : Constant.bgLight),),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20,),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 30.0),
//                           child: Text('Occupancy', style: TextStyle(color: Constant.bgText, fontSize: 18),),
//                         ),
//                         const SizedBox(height: 10,),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Wrap(
//                             children: List.generate(occupancy.length, (index) {
//                               return InkWell(
//                                 onTap: (){
//                                   occupancySelect = occupancy[index];
//                                   setState(() {
//
//                                   });
//                                 },
//                                 child: Container(
//                                   margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                                   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                                   decoration: BoxDecoration(
//                                     color: occupancySelect == occupancy[index] ? Constant.bgLight : Colors.grey.shade200,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       occupancy[index],
//                                       style: TextStyle(
//                                         color: occupancySelect == occupancy[index] ? Colors.white : Constant.bgLight,
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                         const SizedBox(height: 20,),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 30.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('Price', style: TextStyle(color: Constant.bgText, fontSize: 18),),
//                               Text('₹ $_currentSliderValue', style: TextStyle(color: Constant.bgText, fontSize: 18))
//                             ],
//                           ),
//                         ),
//                     Slider(
//                       inactiveColor: Constant.bgLight,
//                       activeColor: Constant.bgLight,
//                       max: 100,
//                       min: 0,
//                       value: _currentSliderValue,
//                       label: _currentSliderValue.round().toString(),
//                       onChanged: (double value) {
//                         setState(() {
//                           print(_currentSliderValue);
//                           _currentSliderValue = value;
//                         });
//                       },
//                     ),
//                         SizedBox(width: 5,),
//                         InkWell(
//                           borderRadius: BorderRadius.circular(30),
//                           onTap: () async {
//                           },
//
//                           child: Container(
//
//                             // height: 40,
//                               padding: EdgeInsets.symmetric(horizontal: 22,vertical: 12),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(32),
//                                   color: Color(0xff6151FF)
//                               ),
//                               child: Text("SEND",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white),)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             )
//           ]
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../constant/constant.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List occupancy = ['Single', 'Double', 'Triple', '3+'];
  String pgFor = 'Boys';
  String occupancySelect = 'Single';
  double _currentSliderValue = 20.0;

  @override
  Widget build(BuildContext context) {
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
                      'Search',
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                label: const Text('Pune'),
                                labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Icon(Icons.pin_drop_outlined),
                                ),
                                label: const Text('Search upto localities or landmarks'),
                                labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text('Looking For', style: TextStyle(color: Constant.bgText, fontSize: 18),),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: (){
                                  pgFor = 'Boys';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: pgFor == 'Boys' ? Constant.bgLight : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: Text('Boys', style: TextStyle(color: pgFor == 'Boys' ? Colors.white : Constant.bgLight),),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  pgFor = 'Girls';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: pgFor == 'Girls' ? Constant.bgLight : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: Text('Girls', style: TextStyle(color: pgFor == 'Girls' ? Colors.white : Constant.bgLight),),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  pgFor = 'Both';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: pgFor == 'Both' ? Constant.bgLight : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: Text('Both', style: TextStyle(color: pgFor == 'Both' ? Colors.white : Constant.bgLight),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text('Occupancy', style: TextStyle(color: Constant.bgText, fontSize: 18),),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Wrap(
                              children: List.generate(occupancy.length, (index) {
                                return InkWell(
                                  onTap: (){
                                    occupancySelect = occupancy[index];
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: occupancySelect == occupancy[index] ? Constant.bgLight : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        occupancy[index],
                                        style: TextStyle(
                                          color: occupancySelect == occupancy[index] ? Colors.white : Constant.bgLight,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price', style: TextStyle(color: Constant.bgText, fontSize: 18),),
                                Text('₹ $_currentSliderValue', style: TextStyle(color: Constant.bgText, fontSize: 18))
                              ],
                            ),
                          ),
                          Slider(
                            inactiveColor: Constant.bgLight,
                            activeColor: Constant.bgLight,
                            max: 100,
                            min: 0,
                            value: _currentSliderValue,
                            label: _currentSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Padding to add some space from the edges
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        // Your onTap function
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(0xff6151FF),
                        ),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
