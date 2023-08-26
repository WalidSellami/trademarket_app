
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class CheckCubit extends Cubit<CheckStates> {

  CheckCubit() : super(InitialCheckState());

  static CheckCubit get(context) => BlocProvider.of(context);


  bool hasInternet = false;
  bool isSplashScreen = true;

  void checkConnection() {

    InternetConnectionChecker().onStatusChange.listen((event) {

      final isConnected = event == InternetConnectionStatus.connected;

      hasInternet = isConnected;

      (!isSplashScreen) ? showSimpleNotification(
        (hasInternet) ? const Text(
          'You are connected with internet',
          style: TextStyle(
            fontSize: 17.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ) : const Text(
          'You are not connected with internet',
          style: TextStyle(
            fontSize: 17.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: (hasInternet) ? greenColor : Colors.red,
      ) : null;


      emit(CheckConnectionState());
    });


  }


  void changeScreen() {
    isSplashScreen = false;
    emit(ChangeScreenCheckState());
  }


}