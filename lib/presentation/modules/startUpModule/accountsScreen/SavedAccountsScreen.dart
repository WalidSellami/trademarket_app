import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/layout/appLayout/AppLayout.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/accountsScreen/AccountAccessScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/loginScreen/LoginScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/registerScreen/RegisterScreen.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginCubit.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class SavedAccountsScreen extends StatefulWidget {
  const SavedAccountsScreen({super.key});

  @override
  State<SavedAccountsScreen> createState() => _SavedAccountsScreenState();
}

class _SavedAccountsScreenState extends State<SavedAccountsScreen> {

  int numberPressed = 0;

  void alertPress(context) {
    numberPressed++;
    if(numberPressed == 3) {
      numberPressed = 0;
      showAlertCheckConnection(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(CheckCubit.get(context).hasInternet) {
          AppCubit.get(context).getSavedAccounts(context);
        }
        return BlocConsumer<CheckCubit, CheckStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var checkCubit = CheckCubit.get(context);

            return BlocConsumer<ThemeCubit , ThemeStates>(
              listener: (context , state) {},
              builder: (context , state) {

                return BlocConsumer<AppCubit, AppStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    var cubit = AppCubit.get(context);
                    var savedAccounts = cubit.savedAccounts;
                    var idSavedAccounts = cubit.idSavedAccounts;

                    return BlocConsumer<LoginCubit , LoginStates>(
                      listener: (context , state) {

                        if(state is ErrorLoginWithGoogleAccountState) {
                          showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);
                        }

                        if(state is SuccessLoginWithGoogleAccountState) {
                          showFlutterToast(message: 'Login done successfully', state: ToastStates.success, context: context);

                          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {

                            uId = state.uId;

                            Navigator.pop(context);
                            navigateAndNotReturn(context: context, screen: const AppLayout());

                          });
                        }


                      },
                      builder: (context , state) {

                        return WillPopScope(
                          onWillPop: () async {
                            return showAlertExit(context);
                          },
                          child: Scaffold(
                            appBar: AppBar(),
                            body: Center(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      logo(context),
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                      ConditionalBuilder(
                                        condition: savedAccounts.isNotEmpty,
                                        builder: (context) => ListView.separated(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                buildItemSavedAccount(savedAccounts[index],
                                                    idSavedAccounts[index], context),
                                            separatorBuilder: (context, index) => Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0,
                                              ),
                                              child: Divider(
                                                thickness: 0.8,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                            itemCount: savedAccounts.length),
                                        fallback: (context) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: CircularLoading(os: getOs()),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(6.0),
                                        onTap: () {
                                          if(checkCubit.hasInternet) {
                                            Navigator.of(context).push(createRoute(screen: const LoginScreen()));
                                          } else {
                                            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                            alertPress(context);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6.0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    color: Theme.of(context).colorScheme.primary),
                                                child: const Icon(
                                                  Icons.login_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(
                                                'Login with another account',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      defaultButton(
                                          text: 'Create new account'.toUpperCase(),
                                          onPress: () {
                                            if (checkCubit.hasInternet) {
                                              Navigator.of(context).push(
                                                  createRoute(screen: const RegisterScreen()));
                                            } else {
                                              showFlutterToast(
                                                  message: 'No Internet Connection',
                                                  state: ToastStates.error,
                                                  context: context);
                                              alertPress(context);
                                            }
                                          },
                                          context: context),
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

              },
            );
          },
        );
      }
    );
  }

  Widget buildItemSavedAccount(account, accountId, context) => InkWell(
        borderRadius: BorderRadius.circular(6.0,),
        onTap: () async {
          if (CheckCubit.get(context).hasInternet) {
            if (account['isGoogleSignIn'] == false) {
              Navigator.of(context).push(createRoute(screen: AccountAccessScreen(
                email: account['email'],
                fullName: account['full_name'],
                imageProfile: account['image_profile'],)));
            } else {
              showLoading(context);
              await LoginCubit.get(context).signInWithGoogleAccount();
            }
          } else {
            showFlutterToast(
                message: 'No Internet Connection',
                state: ToastStates.error,
                context: context);
            alertPress(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 8.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: NetworkImage('${account['image_profile']}'),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Text(
                  '${account['full_name']}',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  if (CheckCubit.get(context).hasInternet) {
                    AppCubit.get(context)
                        .deleteSavedAccount(userAccountId: accountId);
                  } else {
                    showFlutterToast(
                        message: 'No InternetConnection',
                        state: ToastStates.error,
                        context: context);
                    alertPress(context);
                  }
                },
                child: Tooltip(
                  message: 'Remove',
                  child: CircleAvatar(
                    radius: 18.0,
                    backgroundColor: ThemeCubit.get(context).isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.0,
                      color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
