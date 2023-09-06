import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();


  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();


  bool isOldPassword = true;
  bool isNewPassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    oldPasswordController.addListener(() {
      setState(() {});
    });
    newPasswordController.addListener(() {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {

            if(state is SuccessChangePasswordAppState) {
              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
              Navigator.pop(context);
            }

            if(state is ErrorChangePasswordAppState) {
              if(state.error.toString().contains('wrong-password')) {
                showFlutterToast(message: '[firebase_auth/wrong-password] Old Password is wrong, enter the correct one.', state: ToastStates.error, context: context);
              } else {
                showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
              }
            }

          },
          builder: (context , state) {

            var cubit = AppCubit.get(context);

            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                  Navigator.pop(context);
                },
                title: 'Change Password',
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter your old password : ',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        defaultFormField(
                            label: 'Old Password',
                            controller: oldPasswordController,
                            type: TextInputType.visiblePassword,
                            focusNode: focusNode1,
                            isPassword: isOldPassword,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: isOldPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_rounded,
                            onPress: () {
                              setState(() {
                                isOldPassword = !isOldPassword;
                              });
                            },
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Old Password must not be empty';
                              }
                              if (value.length < 8) {
                                return 'Old Password must be at least 8 characters';
                              }
                              return null;
                            },
                            context: context),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text(
                          'Enter your new password : ',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        defaultFormField(
                            label: 'New Password',
                            controller: newPasswordController,
                            type: TextInputType.visiblePassword,
                            focusNode: focusNode2,
                            isPassword: isNewPassword,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: isNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_rounded,
                            onPress: () {
                              setState(() {
                                isNewPassword = !isNewPassword;
                              });
                            },
                            onSubmit: (value) {
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                              if(checkCubit.hasInternet) {
                                if(formKey.currentState!.validate()) {
                                  cubit.changePassword(
                                      oldPassword: oldPasswordController.text,
                                      newPassword: newPasswordController.text);
                                }
                              }
                              return null;
                            },
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'New Password must not be empty';
                              }
                              if (value.length < 8) {
                                return 'New Password must be at least 8 characters';
                              }
                              bool passwordValid = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~,.]).{8,}$')
                                  .hasMatch(value);
                              if (!passwordValid) {
                                return 'Enter a strong password with a mix of uppercase letters, lowercase letters, numbers, special characters(@#%&!?), and at least 8 characters';
                              }
                              return null;
                            },
                            context: context),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: ConditionalBuilder(
                            condition: state is! LoadingChangePasswordAppState,
                            builder: (context) => defaultButton(
                                text: 'Change'.toUpperCase(),
                                onPress: () {
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  if(checkCubit.hasInternet) {
                                    if(formKey.currentState!.validate()) {
                                      cubit.changePassword(
                                          oldPassword: oldPasswordController.text,
                                          newPassword: newPasswordController.text);
                                    }
                                  } else {
                                    showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                  }
                                },
                                context: context),
                            fallback: (context) => Center(child: CircularLoading(os: getOs())),
                          ),
                        )
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
