import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/layout/appLayout/AppLayout.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/loginScreen/LoginScreen.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterCubit.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  int seconds = 300;

  int sec = 60;

  Timer? timer;

  Timer? anotherTimer;

  bool isLoading = false;

  void startPrincipleTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        removeAccount();
        showAlertVerification(context);
      }

      if (RegisterCubit.get(context).isVisible) {
        timer.cancel();
      }

      if (seconds == 60) {
        showFlutterToast(
            message: 'You have 1 minute left',
            state: ToastStates.warning,
            context: context);
      } else if (seconds == 10) {
        showFlutterToast(
            message: 'You have 10 seconds left ',
            state: ToastStates.warning,
            context: context);
      }
    });
  }

  void startTime() {
    anotherTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec > 0) {
        setState(() {
          sec--;
        });
      } else {
        timer.cancel();
      }

      if (RegisterCubit.get(context).isVisible) {
        timer.cancel();
      }

    });
  }

  @override
  void initState() {
    super.initState();
    startPrincipleTime();
    startTime();
  }

  @override
  void dispose() {
    timer?.cancel();
    anotherTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if(CheckCubit.get(context).hasInternet) {
        RegisterCubit.get(context).autoVerifyEmail();
      }
      return BlocConsumer<CheckCubit, CheckStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<RegisterCubit, RegisterStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = RegisterCubit.get(context);

              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Email Verification',
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: (!cubit.isVisible)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              EvaIcons.emailOutline,
                              size: 60.0,
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            const Text(
                              'Check Your Email',
                              style: TextStyle(
                                fontSize: 26.0,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Text.rich(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 19.0,
                                letterSpacing: 0.8,
                                height: 1.4,
                                fontWeight: FontWeight.bold,
                              ),
                              TextSpan(
                                  text:
                                      'We sent a verification link to your email, verify it to continue.\n\n',
                                  children: [
                                    TextSpan(
                                      text:
                                          'If you don\'t verify your email in 5 minutes, your account will be deleted.',
                                      style: TextStyle(
                                        color: redColor,
                                      ),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            (sec > 0)
                                ? Text(
                                    '$sec',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      color: (sec > 10)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : redColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : ConditionalBuilder(
                                    condition: state
                                        is! LoadingSendEmailVerificationRegisterState,
                                    builder: (context) => defaultTextButton(
                                      text: 'Resend-Link',
                                      onPress: () {
                                        if (checkCubit.hasInternet) {
                                          cubit.sendEmailVerification();
                                          Future.delayed(
                                                  const Duration(seconds: 1))
                                              .then((value) {
                                            setState(() {
                                              sec = 60;
                                            });
                                            startTime();
                                          });
                                        } else {
                                          showFlutterToast(
                                              message:
                                                  'No Internet Connection',
                                              state: ToastStates.error,
                                              context: context);
                                        }
                                      },
                                    ),
                                    fallback: (context) =>
                                        CircularLoading(os: getOs()),
                                  ),
                          ],
                        )
                      : Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                EvaIcons.checkmarkSquare2Outline,
                                size: 60.0,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              const Text(
                                'Email Verified',
                                style: TextStyle(
                                  fontSize: 26.0,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 45.0,
                              ),
                              (!isLoading) ? defaultSecondButton(
                                  text: 'Continue',
                                  onPress: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
                                      navigateAndNotReturn(context: context, screen: const AppLayout());
                                    });
                                  },
                                  context: context) : CircularLoading(os: getOs()),
                            ],
                          ),
                      ),
                ),
              );
            },
          );
        },
      );
    });
  }

  void removeAccount() {
    CacheHelper.removeData(key: 'uId').then((value) {
      if(value == true) {
        RegisterCubit.get(context).deleteAccount();
      }
    });
  }

  dynamic showAlertVerification(BuildContext context) {
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
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            title: Text(
              'Time is up!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: redColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Your email is not verified.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  navigateAndNotReturn(
                      context: context, screen: const LoginScreen());
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
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
