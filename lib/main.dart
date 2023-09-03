import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:trade_market_app/data/models/dataModel/DataModel.dart';
import 'package:trade_market_app/presentation/layout/appLayout/AppLayout.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/loginScreen/LoginScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/accountsScreen/SavedAccountsScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/splashScreen/SplashScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/welcomeScreen/WelcomeScreen.dart';
import 'package:trade_market_app/shared/blocObserver/SimpleBlocObserver.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginCubit.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterCubit.dart';
import 'package:trade_market_app/shared/cubit/resetCubit/ResetCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';
import 'package:trade_market_app/shared/notification/Notifications.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';
import 'firebase_options.dart';



// Notification background
Future<void> handleBackgroundMessage(RemoteMessage message) async {

  Data data = Data.fromJson(message.data);

  if((data.title != null) && (data.message != null)) {

    await Notifications().getNotification(title: data.title ?? '', body: data.message ?? '');

  }

  if (kDebugMode) {
    print('Notification from Background');
  }

}


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();

  await Notifications().initialize();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  Notifications().onMessageListener();



  bool? isStarted = CacheHelper.getData(key: 'isStarted');

  var isDark = CacheHelper.getData(key: 'isDark');

  uId = CacheHelper.getData(key: 'uId');

  bool? isSavedAccount = CacheHelper.getData(key: 'isSavedAccount');

  isGoogleSignIn = CacheHelper.getData(key: 'isGoogleSignIn');


  Widget? widgetStart;

  if (isStarted != null) {

    if (uId != null) {

      widgetStart = const AppLayout();

    } else if(isSavedAccount != null) {

      widgetStart = const SavedAccountsScreen();

    } else {

      widgetStart = const LoginScreen();
    }

  } else {
    widgetStart = const WelcomeScreen();
  }


  runApp(MyApp(
    startWidget: widgetStart,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  final bool? isDark;

  const MyApp({super.key, this.startWidget , this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => CheckCubit()..checkConnection(),
        ),
        BlocProvider(
          create: (BuildContext context) => ThemeCubit()..changeThemeMode(isDark ?? false),
        ),
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ResetCubit(),
        ),
      ],
      child: BlocConsumer<ThemeCubit , ThemeStates>(
        listener: (context , state) {},
        builder: (context , state) {

          var cubit = ThemeCubit.get(context);

          return OverlaySupport.global(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
              home: SplashScreen(startWidget: startWidget!),
            ),
          );

        },
      ),
    );
  }
}
