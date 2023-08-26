
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class ThemeCubit extends Cubit<ThemeStates> {

  ThemeCubit() : super(InitialThemeState());

  static ThemeCubit get(context) => BlocProvider.of(context);


  bool isDark = false;

  void changeThemeMode(value) {
    isDark = value;
    CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
      emit(ChangeModeThemeState());
    });

  }



}