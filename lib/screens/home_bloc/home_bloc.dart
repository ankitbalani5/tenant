import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:roomertenant/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/apitget.dart';
import '../newhome.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  static dynamic userValues;
  static dynamic userComplains;
  HomeBloc() : super(HomeInitial()){
    on<HomeRefreshEvent>((event, emit) async {
      emit(HomeLoading());
      try{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('id');
        String branch_id = await prefs.getString("branch_id").toString();
       UserModel userValues = await API.user(prefs.getString('mobile_no').toString(),branch_id);


        // // Save user data to SharedPreferences
        // saveUserDataToSharedPreferences(userValues);

        for (int i = 0; i < userValues.residents!.length; i++) {
          API.userdatalist.add(userValues.residents![i]);
        }
        if(userValues == null){
          emit(HomeLoading());
        }else{
          emit(HomeSuccess(userValues));
        }
      }on SocketException{
        emit(HomeError('Please check your Internet connection'));
      } catch (error){
        emit(HomeError(error.toString()));
        print('error.................'+error.toString());
      }
    });
  }

  // // Save user data to SharedPreferences
  // static Future<void> saveUserDataToSharedPreferences(UserModel userValues) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Convert the UserModel to a JSON string
  //   String userDataString = jsonEncode(userValues.toJson());
  //   prefs.setString('userValues', userDataString);
  // }
  // }
  //
  // // Retrieve user data from SharedPreferences
  // static Future<UserModel?> getUserDataFromSharedPreferences() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userDataString = prefs.getString('userValues');
  //   if (userDataString != null) {
  //     // Parse the JSON string or any other format to get UserModel
  //     return UserModel.fromJson(userDataString);
  //   }
  //   return null;
  // }

}