import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class SplashScreen extends StatefulWidget {

  final Widget startWidget;

  const SplashScreen({super.key , required this.startWidget});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isAnimate = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {

      if(CheckCubit.get(context).hasInternet == true) {

        navigateAndNotReturn(context: context, screen: widget.startWidget);
        CheckCubit.get(context).changeScreen();

      }

    });


  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {
        if(state is CheckConnectionState) {
          if(CheckCubit.get(context).hasInternet == false) {
            Future.delayed(const Duration(milliseconds: 1500)).then((value) {
              showAlertConnection(context);
              setState(() {
                isAnimate = false;
              });
            });
          }
        }
      },
      builder: (context , state) {

        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: AvatarGlow(
              glowColor: HexColor('98b7ff'),
              endRadius: 150.0,
              duration: const Duration(milliseconds: 1400),
              repeat: true,
              curve: Curves.easeOut,
              animate: isAnimate,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: Image.asset('assets/images/logo.png',
               width: 170.0,
                height: 170.0,
              ),
            ),
          ),
        );
      },
    );
  }

  dynamic showAlertConnection(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0,),
            ),
            title: const Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content:  const Text(
              'You are currently offline!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: redColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}
