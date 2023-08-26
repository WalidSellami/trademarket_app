
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/userModel/UserModel.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class RegisterCubit extends Cubit<RegisterStates> {

  RegisterCubit() : super(InitialRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String fullName,
    required String phone,
    required String address,
    required String email,
    required String password,
}) {

    emit(LoadingUserRegisterState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password).then((value) {

       userCreate(fullName: fullName, phone: phone, address: address, uId: value.user!.uid, email: email);

       CacheHelper.saveData(key: 'isGoogleSignIn', value: false).then((value) {
         isGoogleSignIn = false;
       });

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()}  ---> user register.');
      }

      emit(ErrorUserRegisterState(error));
    });




  }


  void userCreate({
    required String fullName,
    required String phone,
    required String address,
    required String uId,
    required String email,
}) async {

    var deviceToken = await getDeviceToken();

    UserModel model = UserModel(
      fullName: fullName,
      phone: phone,
      address: address,
      uId: uId,
      email: email,
      imageProfile: profile,
      senders: {},
      deviceToken: deviceToken,
      isInfoComplete: true,
    );

    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap()).then((value) {

      emit(SuccessUserCreateRegisterState(model));

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} ---> in user create account.');
      }

      emit(ErrorUserCreateRegisterState(error));
    });

  }



  void sendEmailVerification() {

    emit(LoadingSendEmailVerificationRegisterState());

    FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) {

      emit(SuccessSendEmailVerificationRegisterState());

    }).catchError((error) {


      emit(ErrorSendEmailVerificationRegisterState(error));

    });


  }


  bool isVisible = false;

  void autoVerifyEmail() {

    emit(LoadingAutoVerificationRegisterState());

    FirebaseAuth.instance.authStateChanges().listen((event) {

      FirebaseAuth.instance.currentUser?.reload().then((value) {

        if(event!.emailVerified) {

          isVisible = true;

        } else {

          isVisible = false;

        }

        emit(SuccessAutoVerificationRegisterState());

      });

      emit(SuccessAutoVerificationRegisterState());

    });

  }

  void deleteAccount() {

    emit(LoadingRemoveAccountRegisterState());

    FirebaseAuth.instance.currentUser?.delete().then((value) {

      FirebaseFirestore.instance.collection('users').doc(uId).delete();

      emit(SuccessRemoveAccountRegisterState());

    }).catchError((error) {

      emit(ErrorRemoveAccountRegisterState(error));

    });

  }

}