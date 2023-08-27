import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/shared/cubit/resetCubit/ResetStates.dart';

class ResetCubit extends Cubit<ResetStates> {

  ResetCubit() : super(InitialResetState());

  static ResetCubit get(context) => BlocProvider.of(context);


  void sendEmailResetPassword({
    required String email,
}) {

    emit(LoadingSendEmailResetState());

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {

      emit(SuccessSendEmailResetState());

    }).catchError((error) {

      if(kDebugMode) {

        print('${error.toString()} --> in send email reset password.');
      }

      emit(ErrorSendEmailResetState(error));

    });



  }



}