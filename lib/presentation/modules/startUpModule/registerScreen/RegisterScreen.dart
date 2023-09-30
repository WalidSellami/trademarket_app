import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/emailVerificationScreen/EmailVerificationScreen.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterCubit.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterStates.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();

  bool isPassword = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {

            if(state is SuccessUserCreateRegisterState) {

              showFlutterToast(message: 'Register done successfully', state: ToastStates.success, context: context);

              uId = state.userModel.uId;

              RegisterCubit.get(context).sendEmailVerification();

              navigateAndNotReturn(context: context, screen: EmailVerificationScreen(userId: state.userModel.uId.toString(),));

            }

            if(state is ErrorUserRegisterState) {

              showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);

            }

            if(state is ErrorUserCreateRegisterState) {

              showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);

            }

          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);

            return Scaffold(
              appBar: defaultAppBar(
                  onPress: () {
                    Navigator.pop(context);
                  },
              ),
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
                            height: 35.0,
                          ),
                          const Text(
                            'Register now to join!',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(
                            height: 35.0,
                          ),
                          defaultFormField(
                              isAuth: true,
                              controller: nameController,
                              type: TextInputType.name,
                              label: 'Full Name',
                              focusNode: focusNode1,
                              prefixIcon: Icons.person,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full Name must not be empty.';
                                }
                                if (value.length < 4) {
                                  return 'Full Name must be at least 4 characters.';
                                }
                                bool validName =
                                    RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$')
                                        .hasMatch(value);
                                if (!validName) {
                                  return 'Enter a valid name --> (without (,-) and without only numbers).';
                                }
                                return null;
                              },
                              context: context),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                              isAuth: true,
                              label: 'Phone',
                              controller: phoneController,
                              type: TextInputType.phone,
                              focusNode: focusNode2,
                              prefixIcon: Icons.phone,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone must not be empty';
                                }
                                if (value.length < 9 || value.length > 10) {
                                  return 'Phone must be 9 or 10 numbers with 0 in the beginning.';
                                }

                                String firstLetter =
                                    value.substring(0, 1).toUpperCase();
                                if (firstLetter != '0') {
                                  return 'Phone must be starting with 0';
                                }
                                return null;
                              },
                              context: context),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                              isAuth: true,
                              label: 'Address',
                              controller: addressController,
                              type: TextInputType.streetAddress,
                              focusNode: focusNode3,
                              prefixIcon: EvaIcons.pinOutline,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Address must not be empty';
                                }
                                bool validAddress =
                                    RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$')
                                        .hasMatch(value);
                                if (!validAddress) {
                                  return 'Enter a valid address --> (without (,-) and without only numbers).';
                                }
                                return null;
                              },
                              context: context),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                              isAuth: true,
                              label: 'Email',
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              focusNode: focusNode4,
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
                              },
                              context: context),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                              isAuth: true,
                              label: 'Password',
                              controller: passwordController,
                              isPassword: isPassword,
                              type: TextInputType.visiblePassword,
                              focusNode: focusNode5,
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
                                if (checkCubit.hasInternet) {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                        fullName: nameController.text,
                                        phone: phoneController.text,
                                        address: addressController.text,
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                } else {
                                  showFlutterToast(
                                      message: 'No Internet Connection',
                                      state: ToastStates.error,
                                      context: context);
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
                            height: 35.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoadingUserRegisterState,
                            builder: (context) => defaultButton(
                                text: 'Register'.toUpperCase(),
                                onPress: () {
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  if (checkCubit.hasInternet) {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userRegister(
                                          fullName: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  } else {
                                    showFlutterToast(
                                        message: 'No Internet Connection',
                                        state: ToastStates.error,
                                        context: context);
                                  }
                                },
                                context: context),
                            fallback: (context) =>
                                Center(child: CircularLoading(os: getOs())),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
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
  }
}
