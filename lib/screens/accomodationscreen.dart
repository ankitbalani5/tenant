import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constant/constant.dart';
import 'home_bloc/home_bloc.dart';
import 'internet_check.dart';

class AccommodationScreen extends StatefulWidget {
  const AccommodationScreen({super.key});

  @override
  State<AccommodationScreen> createState() => _AccommodationScreenState();
}

class _AccommodationScreenState extends State<AccommodationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NetworkObserverBlock(
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
                        'Accommodation',
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
                  child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                    if(state is HomeLoading){
                      return const CircularProgressIndicator();
                    }
                    if(state is HomeSuccess){
                      return state.userModel.accommodation == null ? const SizedBox() :
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.userModel.accommodation!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.bgTile
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 220,
                                        child: Text(state.userModel.accommodation![index].branch.toString(),
                                          style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),)),
                                    // Text('Sanika Hostel'),
                                    Text(state.userModel.accommodation![index].room.toString(), style: const TextStyle(color: Colors.grey),),
                                    Text('₹ ${state.userModel.accommodation![index].rent.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, )),
        
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(state.userModel.accommodation![index].fromDate.toString(), style: const TextStyle(color: Colors.grey),),
                                    // SvgPicture.asset('assets/home/download.svg',)
                                  ],
                                ),
        
                              ],
                            ),
                          );
                        },);
                    }
                    if(state is HomeError){
                      return Center(child: Text(state.error),);
                    }
                    return const SizedBox();
                  },),
                ),
            )
          ],
        ),
      ),
    );
  }
}
