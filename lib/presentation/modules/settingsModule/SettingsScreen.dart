import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/presentation/modules/settingsModule/ChangePasswordScreen.dart';
import 'package:trade_market_app/presentation/modules/settingsModule/EditProfileScreen.dart';
import 'package:trade_market_app/presentation/modules/settingsModule/MyPhotosScreen.dart';
import 'package:trade_market_app/presentation/modules/settingsModule/MyProductsScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/accountsScreen/SavedAccountsScreen.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  void initState() {
    super.initState();
    isGoogleSignIn = CacheHelper.getData(key: 'isGoogleSignIn');
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

            var themeCubit = ThemeCubit.get(context);

            return  BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {

                if(state is SuccessSaveAccountAppState) {

                  CacheHelper.saveData(key: 'isSavedAccount', value: true).then((value) {
                    isSavedAccount = true;
                    logOut(context);
                  });
                }

                if(state is ErrorSaveAccountAppState) {
                  showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
                  Navigator.pop(context);
                }

              },
              builder: (context , state) {

                var cubit = AppCubit.get(context);
                var userProfile = cubit.userProfile;

                return Scaffold(
                  body: (checkCubit.hasInternet) ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showFullImage(userProfile?.imageProfile, 'image', context);
                                },
                                child: Hero(
                                  tag: 'image',
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    child: CircleAvatar(
                                      radius: 52.0,
                                      backgroundColor: themeCubit.isDark ? Colors.white : Colors.black,
                                      child: CircleAvatar(
                                        radius: 50.0,
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        backgroundImage: NetworkImage('${userProfile?.imageProfile}'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${userProfile?.fullName}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      '${userProfile?.email}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: themeCubit.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                '${userProfile?.phone}',
                                style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: themeCubit.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              const Icon(
                                EvaIcons.pinOutline,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                '${userProfile?.address}',
                                style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: themeCubit.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SwitchListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0,),
                            ),
                            enableFeedback: true,
                            activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(.3),
                            selected: themeCubit.isDark,
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: const Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: themeCubit.isDark,
                            onChanged: (value) {
                              themeCubit.changeThemeMode(value);
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0,),
                            ),
                            onTap: () {
                              Navigator.of(context).push(createSecondRoute(screen: const EditProfileScreen()));
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: const Icon(
                                EvaIcons.editOutline,
                                color: Colors.white,
                              ),
                            ),
                            title: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17.0,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0,),
                            ),
                            onTap: () {
                              Navigator.of(context).push(createSecondRoute(screen: const MyPhotosScreen()));
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: const Icon(
                                EvaIcons.imageOutline,
                                color: Colors.white,
                              ),
                            ),
                            title: const Text(
                              'My Photos',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17.0,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0,),
                            ),
                            onTap: () {
                              Navigator.of(context).push(createSecondRoute(screen: const MyProductsScreen()));
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: const Icon(
                                EvaIcons.cornerDownRightOutline,
                                color: Colors.white,
                              ),
                            ),
                            title: const Text(
                              'My Products',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17.0,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          if(isGoogleSignIn == false)
                            ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0,),
                              ),
                              onTap: () {
                                Navigator.of(context).push(createSecondRoute(screen: const ChangePasswordScreen()));
                              },
                              leading: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: const Icon(
                                  EvaIcons.lockOutline,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 17.0,
                              ),
                            ),
                          if(isGoogleSignIn == false)
                            const SizedBox(
                              height: 20.0,
                            ),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0,),
                            ),
                            onTap: () {
                                showAlertLogOut(context , userProfile?.fullName , userProfile?.email , userProfile?.imageProfile);
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: const Icon(
                                EvaIcons.logOutOutline,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 17.5,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ) :
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Internet',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          EvaIcons.wifiOffOutline,
                        ),
                      ],
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

  void logOut(context) {
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      FirebaseAuth.instance.signOut();
      CacheHelper.removeData(key: 'uId').then((value) {
        if(value == true) {
          Navigator.pop(context);
          navigateAndNotReturn(context: context, screen: const SavedAccountsScreen());
          AppCubit.get(context).currentIndex = 0;
        }
      });
    });

  }

  dynamic showAlertLogOut(BuildContext context, fullName , email , imageProfile) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        HapticFeedback.vibrate();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0,),
          ),
          title: const Text(
            'Do you want to log out ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showLoading(context);
                AppCubit.get(context).saveAccount(
                    fullName: fullName,
                    email: email,
                    imageProfile: imageProfile);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: redColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
