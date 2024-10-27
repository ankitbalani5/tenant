import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'internet_event.dart';
import 'internet_state.dart';

class InternetBlock extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetBlock() : super(InternetInitialState()) {
    // _checkConnectivity();

    // on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    // on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      print(":::::::::::::::::::::::::::::result is ::::::::::::::::::::::");
      print(result);
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        emit(InternetGainedState());
        print("check internet if called");
      } else {
        emit(InternetLostState());
        print("check internet else called");
      }
    });
  }

  // New method to check initial connectivity status
  Future<void> _checkConnectivity() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();
      print(">>>>>>>>>>>>>>>");
      print(connectivityResult);
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
      } else {
        add(InternetLostEvent());
      }
    } catch (e) {
      print("Error checking connectivity: $e");
      add(InternetLostEvent());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
