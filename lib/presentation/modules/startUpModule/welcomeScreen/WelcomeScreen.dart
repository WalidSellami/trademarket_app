import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/loginScreen/LoginScreen.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  int numberPressed = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      'assets/images/welcome.jpg',
                      width: double.infinity,
                      height: 350.0,
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (frame == null) {
                          return SizedBox(
                              width: double.infinity,
                              height: 350.0,
                              child: Center(child: CircularLoading(os: getOs())));
                        }
                        return child;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Welcome To ',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  logo(context),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Discover a wide range of products that cater to your every need and desire.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultSecondButton(
                      text: 'Get Started',
                      onPress: () {
                        if (checkCubit.hasInternet) {
                          getStarted(context);
                        } else {
                          showFlutterToast(
                              message: 'No Internet Connection',
                              state: ToastStates.error,
                              context: context);
                          alertPress(context);
                        }
                      },
                      context: context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getStarted(context) {
    CacheHelper.saveData(key: 'isStarted', value: true).then((value) {
      if (value == true) {
        navigateAndNotReturn(context: context, screen: const LoginScreen());
      }
    });
  }

  void alertPress(context) {
    numberPressed++;
    if(numberPressed == 3) {
      numberPressed = 0;
      showAlertCheckConnection(context);
    }
  }
}
