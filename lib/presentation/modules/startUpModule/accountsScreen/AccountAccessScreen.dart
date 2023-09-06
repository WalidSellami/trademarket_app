import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/layout/appLayout/AppLayout.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginCubit.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class AccountAccessScreen extends StatefulWidget {

  final String email;
  final String fullName;
  final String imageProfile;

  const AccountAccessScreen({super.key , required this.email , required this.fullName , required this.imageProfile});

  @override
  State<AccountAccessScreen> createState() => _AccountAccessScreenState();
}

class _AccountAccessScreenState extends State<AccountAccessScreen> {


  var passwordController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPassword = true;


  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<LoginCubit , LoginStates>(
          listener: (context , state) {

            if(state is ErrorLoginState) {
              showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);
            }

            if(state is SuccessLoginState) {
              showFlutterToast(message: 'Login done successfully', state: ToastStates.success, context: context);

              CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {

                uId = state.uId;

                navigateAndNotReturn(context: context, screen: const AppLayout());

              });
            }



          },
          builder: (context , state) {

            var cubit = LoginCubit.get(context);

            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                  Navigator.pop(context);
                },
                title: widget.fullName,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42.0,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            backgroundImage: NetworkImage(widget.imageProfile),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            label: 'Password',
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            focusNode: focusNode,
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
                              focusNode.unfocus();
                              if(checkCubit.hasInternet) {
                                if(formKey.currentState!.validate()) {
                                  cubit.userLogin(email: widget.email, password: passwordController.text);
                                }
                              } else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
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
                            },
                            context: context),
                        const SizedBox(
                          height: 40.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingLoginState,
                          builder: (context) =>  defaultButton(
                              text: 'Login'.toUpperCase(),
                              onPress: () {
                                focusNode.unfocus();
                                if(checkCubit.hasInternet) {
                                  if(formKey.currentState!.validate()) {
                                    cubit.userLogin(email: widget.email, password: passwordController.text);
                                  }
                                } else {
                                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                }
                              },
                              context: context),
                          fallback: (context) => Center(child: CircularLoading(os: getOs())),
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
