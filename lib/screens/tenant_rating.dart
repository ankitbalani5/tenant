import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pinput/pinput.dart';
import 'package:roomertenant/model/TenantRatingModel.dart';
import 'package:roomertenant/screens/tenant_rating/tenant_rating_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apitget.dart';
import '../constant/constant.dart';

class TenantRating extends StatefulWidget {
  const TenantRating({super.key});

  @override
  State<TenantRating> createState() => _TenantRatingState();
}

class _TenantRatingState extends State<TenantRating> {
  TenantRatingModel? tenantRatingModel;

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
  }

  fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var mobile_no = pref.getString('mobile_no').toString();
    BlocProvider.of<TenantRatingBloc>(context).add(TenantRatingRefreshEvent(mobile_no));
    // tenantRatingModel = await API.tenantRating(mobile_no);
    // setState(() {
    //
    // });
  }

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
                      'Tenant Rating',
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
                child: BlocBuilder<TenantRatingBloc, TenantRatingState>(
                  builder: (context, state) {
                    if(state is TenantRatingLoading){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(state is TenantRatingSuccess){
                      return ListView.builder(
                        itemCount: state.tenantRatingModel.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Constant.bgTile,
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(state.tenantRatingModel.data![index].branchName.toString(), style: TextStyle(fontWeight: FontWeight.w500),),
                                        RatingBarIndicator(
                                          rating: double.parse(state.tenantRatingModel.data![index].rating.toString()), // Use the rating value from the property
                                          itemCount: 5,
                                          itemSize: 20.0,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                        ),
                                        // Text(state.tenantRatingModel.data![index].rating.toString()),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      children: [
                                        Text(state.tenantRatingModel.data![index].description.toString(),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(state.tenantRatingModel.data![index].insertedDate.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey),),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        },);
                    }
                    if(state is TenantRatingError){
                      return Center(child: Text(state.error),);
                    }
                    return SizedBox();

  },
),
              ),
          )
        ],
      ),
    );
  }
}
