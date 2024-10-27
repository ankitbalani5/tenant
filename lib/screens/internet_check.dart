import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'internetBloc/internet_bloc.dart';
import 'internetBloc/internet_state.dart';

class NetworkObserverBlock extends StatefulWidget {
  Widget child;
  NetworkObserverBlock({super.key, required this.child});

  @override
  State<NetworkObserverBlock> createState() => _NetworkObserverBlockState();
}

class _NetworkObserverBlockState extends State<NetworkObserverBlock> {
  void showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBlock, InternetState>(
        listener: (context, state) {
      if (state is InternetGainedState) {
        // showSnackBar("Internet Connected Successfully..", Colors.green);
      }
      if (state is InternetLostState) {
        // showSnackBar("Internet Disconnected..", Colors.red);
      }
    }, builder: (context, state) {
      if (state is InternetGainedState) {
        return widget.child;
      }
      if (state is InternetLostState) {
        return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/no_internet.json', // Path to your Lottie animation file
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                  animate: true,
                  repeat: true,
                  reverse: false,
                  frameRate: FrameRate(20),
                ),
                SizedBox(height: 20),
                Text(
                  "No Internet Connection.. ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),

                Text(
                  "No Internet connection found. Check your \nconnection or try again.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
