import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/resetCubit/ResetCubit.dart';
import 'package:trade_market_app/shared/cubit/resetCubit/ResetStates.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  var emailController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  bool isSend = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ResetCubit , ResetStates>(
          listener: (context , state) {

            if(state is SuccessSendEmailResetState) {

              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);

              setState(() {
                isSend = true;
              });

            }

            if(state is ErrorSendEmailResetState) {

              setState(() {
                isSend = false;
              });

              showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);

            }

          },
          builder: (context , state) {

            var cubit = ResetCubit.get(context);

            return WillPopScope(
              onWillPop: () async {
                setState(() {
                  isSend = false;
                });
                return true;
              },
              child: Scaffold(
                appBar: defaultAppBar(
                    onPress: () {
                      Navigator.pop(context);
                    },
                    title: '',
                ),
                body: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: (!isSend) ? Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enter your email : ',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            label: 'Email',
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            focusNode: focusNode,
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
                          height: 60.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingSendEmailResetState,
                          builder: (context) => defaultButton(
                              text: 'Send'.toUpperCase(),
                              onPress: () {
                                if(checkCubit.hasInternet) {
                                  if(formKey.currentState!.validate()) {
                                    cubit.sendEmailResetPassword(email: emailController.text);
                                  }
                                }
                              },
                              context: context),
                          fallback: (context) => Center(child: CircularLoading(os: getOs())),
                        )
                      ],
                    ),
                  ) :
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          EvaIcons.emailOutline,
                          size: 60.0,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          'Check Your Email',
                          style: TextStyle(
                            fontSize: 26.0,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                            'We sent a link to your email to reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
