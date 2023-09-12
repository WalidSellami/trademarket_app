import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:trade_market_app/presentation/modules/homeModule/chat/ChatsScreen.dart';
import 'package:trade_market_app/presentation/modules/homeModule/SearchProductScreen.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    super.initState();
    if (CheckCubit.get(context).hasInternet) {
      AppCubit.get(context).getUserProfile();
      Future.delayed(const Duration(milliseconds: 800)).then((value) {
        if (AppCubit.get(context).userProfile?.isInfoComplete == false) {
          quickAlert(
            context: context,
            title: 'Done with success',
            type: QuickAlertType.success,
            text:
                'Don\'t forget to add your phone number and your address in the settings --> edit profile.',
            btnText: 'OK',
            onTap: () {
              AppCubit.get(context).confirmQuickAlert(context);
            },
          );
        }
      });
    } else {
      showFlutterToast(
          message: 'No Internet Connection',
          state: ToastStates.error,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var timeBackPressed = DateTime.now();
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ThemeCubit, ThemeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var themeCubit = ThemeCubit.get(context);

            return BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = AppCubit.get(context);

                return WillPopScope(
                  onWillPop: () async {
                    final difference = DateTime.now().difference(timeBackPressed);
                    final isWarning = difference >= const Duration(milliseconds: 500);
                    timeBackPressed = DateTime.now();

                    if (isWarning) {
                      showToast(
                        'Press back again to exit',
                        context: context,
                        backgroundColor: Colors.grey.shade800,
                        animation: StyledToastAnimation.scale,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.bottom,
                        animDuration: const Duration(milliseconds: 1500),
                        duration: const Duration(seconds: 3),
                        curve: Curves.elasticInOut,
                        reverseCurve: Curves.linear,
                      );

                      return false;
                    } else {
                      SystemNavigator.pop();
                      return true;
                    }
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: Text(
                        cubit.titles[cubit.currentIndex],
                      ),
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor:
                            themeCubit.isDark ? firstDarkColor : Colors.white,
                        statusBarIconBrightness: themeCubit.isDark
                            ? Brightness.light
                            : Brightness.dark,
                        systemNavigationBarColor: themeCubit.isDark
                            ? HexColor('191919')
                            : HexColor('f1f4f9'),
                        systemNavigationBarIconBrightness: themeCubit.isDark
                            ? Brightness.dark
                            : Brightness.light,
                      ),
                      actions: [
                        if ((cubit.currentIndex == 0) &&
                            (cubit.allProducts.length > 8))
                          Tooltip(
                            enableFeedback: true,
                            message: 'Search',
                            child: defaultIcon(
                                size: 26.0,
                                icon: EvaIcons.searchOutline,
                                onPress: () {
                                  if (checkCubit.hasInternet) {
                                    Navigator.of(context).push(createRoute(
                                        screen: const SearchProductScreen()));
                                  } else {
                                    showFlutterToast(
                                        message: 'No Internet Connection',
                                        state: ToastStates.error,
                                        context: context);
                                  }
                                },
                                radius: 50.0,
                                context: context),
                          ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        if (cubit.currentIndex == 0)
                          Tooltip(
                            enableFeedback: true,
                            message: 'Chats',
                            child: Material(
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.grey.shade800.withOpacity(.6)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(50.0),
                              child: InkWell(
                                onTap: () {
                                  if (checkCubit.hasInternet) {
                                    Navigator.of(context).push(createRoute(
                                        screen: const ChatsScreen()));
                                  } else {
                                    showFlutterToast(
                                        message: 'No Internet Connection',
                                        state: ToastStates.error,
                                        context: context);
                                  }
                                },
                                borderRadius: BorderRadius.circular(50.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 33.0,
                                    width: 33.0,
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            EvaIcons.messageCircleOutline,
                                            size: 26.0,
                                            color:
                                                ThemeCubit.get(context).isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        (cubit.numberNotice > 0)
                                            ? Badge(
                                                backgroundColor: redColor,
                                                alignment: Alignment.topRight,
                                                textColor: Colors.white,
                                                label: Text(
                                                  (cubit.numberNotice <= 99)
                                                      ? '${cubit.numberNotice}'
                                                      : '+99',
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 8.0,
                        ),
                      ],
                    ),
                    body: cubit.screens[cubit.currentIndex],
                    bottomNavigationBar: Container(
                      color: themeCubit.isDark
                          ? HexColor('191919')
                          : HexColor('f1f4f9'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: SalomonBottomBar(
                          selectedItemColor:
                              Theme.of(context).colorScheme.primary,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 200),
                          items: [
                            SalomonBottomBarItem(
                              icon: const Icon(
                                EvaIcons.homeOutline,
                                size: 26.0,
                              ),
                              title: const Text(
                                'Home',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              activeIcon: const Icon(
                                EvaIcons.home,
                                size: 28.0,
                              ),
                            ),
                            SalomonBottomBarItem(
                              icon: const Icon(
                                Icons.category_outlined,
                                size: 26.0,
                              ),
                              title: const Text(
                                'Categories',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              activeIcon: const Icon(
                                Icons.category_rounded,
                                size: 28.0,
                              ),
                            ),
                            SalomonBottomBarItem(
                                icon: const Icon(
                                  EvaIcons.starOutline,
                                  size: 26.0,
                                ),
                                title: const Text(
                                  'Favorites',
                                  style: TextStyle(
                                    fontFamily: 'Varela',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                activeIcon: const Icon(
                                  EvaIcons.star,
                                  size: 28.0,
                                )),
                            SalomonBottomBarItem(
                              icon: const Icon(
                                EvaIcons.settingsOutline,
                                size: 26.0,
                              ),
                              title: const Text(
                                'Settings',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              activeIcon: const Icon(
                                EvaIcons.settings,
                                size: 28.0,
                              ),
                            ),
                          ],
                          currentIndex: cubit.currentIndex,
                          onTap: (index) => cubit.changeBottomNav(index),
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
