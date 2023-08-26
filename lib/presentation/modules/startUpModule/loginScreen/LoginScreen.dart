import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/layout/appLayout/AppLayout.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/forgotPasswordScreen/ForgotPasswordScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/registerScreen/RegisterScreen.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginCubit.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  bool isPassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int numberPressed = 0;

  void alertPress(context) {
    numberPressed++;
    if(numberPressed == 3) {
      numberPressed = 0;
      showAlertCheckConnection(context);
    }
  }


  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {});
    });
    isSavedAccount = CacheHelper.getData(key: 'isSavedAccount');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ThemeCubit , ThemeStates>(
          listener: (context , state) {},
          builder: (context , state) {

            return BlocConsumer<LoginCubit , LoginStates>(
              listener: (context , state) {

                if(state is SuccessLoginState) {

                  showFlutterToast(message: 'Login done successfully', state: ToastStates.success, context: context);

                  CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {

                    uId = state.uId;

                    navigateAndNotReturn(context: context, screen: const AppLayout());

                  });

                }

                if(state is ErrorLoginState) {

                  showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);

                }

                // First sign in with google account
                if(state is SuccessCreateUserLoginGoogleAccountState) {

                  showFlutterToast(message: 'Login done successfully', state: ToastStates.success, context: context);

                  CacheHelper.saveData(key: 'uId', value: state.model.uId).then((value) {

                    uId = state.model.uId;

                    Navigator.pop(context);
                    navigateAndNotReturn(context: context, screen: const AppLayout());

                  });

                }


                // Already have account in firestore
                if(state is SuccessLoginWithGoogleAccountState) {
                  showFlutterToast(message: 'Login done successfully', state: ToastStates.success, context: context);

                  CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {

                    uId = state.uId;

                    Navigator.pop(context);
                    navigateAndNotReturn(context: context, screen: const AppLayout());

                  });
                }

                if(state is ErrorLoginWithGoogleAccountState) {

                  showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);
                  Navigator.pop(context);


                }

                if(state is ErrorCreateUserLoginGoogleAccountState) {

                  showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);
                  Navigator.pop(context);


                }

              },
              builder: (context , state) {

                var cubit = LoginCubit.get(context);

                return WillPopScope(
                  onWillPop: () async {
                    if(isSavedAccount == null) {
                      return showAlertExit(context);
                    }
                    return true;
                  },
                  child: Scaffold(
                    appBar: (isSavedAccount != null) ?
                    defaultAppBar(onPress: () {
                      Navigator.pop(context);
                    }) : AppBar(),
                    body: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                logo(context),
                                const SizedBox(
                                  height: 45.0,
                                ),
                                defaultFormField(
                                    label: 'Email',
                                    controller: emailController,
                                    type: TextInputType.emailAddress,
                                    focusNode: focusNode1,
                                    prefixIcon: Icons.email_outlined,
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email must not be empty';
                                      }
                                      bool emailValid = RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(value);
                                      if (!emailValid) {
                                        return 'Enter a valid email.';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                defaultFormField(
                                    label: 'Password',
                                    controller: passwordController,
                                    type: TextInputType.visiblePassword,
                                    focusNode: focusNode2,
                                    isPassword: isPassword,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    suffixIcon: isPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_rounded,
                                    onPress: () {
                                      setState(() {
                                        isPassword = !isPassword;
                                      });
                                    },
                                    onSubmit: (value) {
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      if(checkCubit.hasInternet) {
                                        if(formKey.currentState!.validate()) {
                                          cubit.userLogin(
                                              email: emailController.text,
                                              password: passwordController.text);
                                        }
                                      } else {
                                        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                        alertPress(context);
                                      }
                                      return null;
                                    },
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password must not be empty';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: defaultTextButton(
                                    text: 'Forgot Password?',
                                    onPress: () {
                                      if(checkCubit.hasInternet) {
                                        Navigator.of(context).push(createRoute(screen: const ForgotPasswordScreen()));
                                      } else {
                                        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                        alertPress(context);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                ConditionalBuilder(
                                  condition: state is! LoadingLoginState,
                                  builder: (context) => defaultButton(
                                      text: 'Login'.toUpperCase(),
                                      onPress: () {
                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        if(checkCubit.hasInternet) {
                                          if(formKey.currentState!.validate()) {
                                            cubit.userLogin(
                                                email: emailController.text,
                                                password: passwordController.text);
                                          }
                                        } else {
                                          showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                          alertPress(context);
                                        }

                                      },
                                      context: context),
                                  fallback: (context) => Center(child: CircularLoading(os: getOs())),
                                ),
                                const SizedBox(
                                  height: 35.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 0.8,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const Text(
                                      ' Or login with ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        thickness: 0.8,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tooltip(
                                      message: 'Google',
                                      enableFeedback: true,
                                      child: defaultIcon(
                                        radius: 12.0,
                                        padding: 16.0,
                                        size: 32.0,
                                        icon: EvaIcons.google,
                                        context: context,
                                        onPress: () {
                                          focusNode1.unfocus();
                                          focusNode2.unfocus();
                                          if(checkCubit.hasInternet) {
                                            // if(isFirstSignIn == null) {
                                              showLoading(context);
                                              cubit.signInWithGoogle(context);
                                            // } else {
                                            //   showLoading(context);
                                            //   cubit.signInWithGoogleAccount();
                                            // }
                                          } else {
                                            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                            alertPress(context);
                                          }
                                        },
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   width: 30.0,
                                    // ),
                                    // Tooltip(
                                    //   message: 'Facebook',
                                    //   enableFeedback: true,
                                    //   child: defaultIcon(
                                    //     icon: EvaIcons.facebook,
                                    //     radius: 12.0,
                                    //     padding: 14.0,
                                    //     size: 30.0,
                                    //     onPress: () {
                                    //        if(checkCubit.hasInternet) {
                                    //
                                    //        } else {
                                    //           showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                    //           alertPress(context);
                                    //       }
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 35.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    defaultTextButton(
                                      text: 'Register'.toUpperCase(),
                                      onPress: () {
                                        if(checkCubit.hasInternet) {
                                          Navigator.of(context).push(createRoute(screen: const RegisterScreen()));
                                        } else {
                                          showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                          alertPress(context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );

          },
        );
      },
    );
  }
}
