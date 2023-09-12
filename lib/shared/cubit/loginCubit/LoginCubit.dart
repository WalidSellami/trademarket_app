import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trade_market_app/data/models/userModel/UserModel.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/loginCubit/LoginStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class LoginCubit extends Cubit<LoginStates> {

  LoginCubit() : super(InitialLoginState());

  static LoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password,
}) {

    emit(LoadingLoginState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) async {

        CacheHelper.saveData(key: 'isGoogleSignIn', value: false).then((value) {
          isGoogleSignIn = false;
        });

        var deviceToken = await getDeviceToken();

        FirebaseFirestore.instance.collection('users').doc(value.user?.uid).update({
          'device_token': deviceToken,
        });

        emit(SuccessLoginState(value.user!.uid, value.user!.emailVerified));

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} ---> in user login.');
      }

      emit(ErrorLoginState(error));

    });



  }



  // Already have account google signed
  // Future<void> signInWithGoogleAccount() async {
  //   emit(LoadingLoginWithGoogleAccountState());
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
  //
  //     CacheHelper.saveData(key: 'isGoogleSignIn', value: true).then((value) {
  //       isGoogleSignIn = true;
  //     });
  //
  //     var deviceToken = await getDeviceToken();
  //
  //     FirebaseFirestore.instance.collection('users').doc(value.user?.uid).update({
  //       'device_token': deviceToken,
  //     });
  //
  //     emit(SuccessLoginWithGoogleAccountState(value.user!.uid));
  //
  //   }).catchError((error) {
  //
  //     emit(ErrorLoginWithGoogleAccountState(error));
  //   });
  // }






  // For the first Time


  Future<void> signInWithGoogle(context) async {

    emit(LoadingLoginWithGoogleAccountState());

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // if(googleAuth == null) {
    //   emit(ErrorLoginWithGoogleAccountState('Error, Failed to login'));
    // }

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );


    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {


      FirebaseFirestore.instance.collection('users').doc(value.user?.uid).get().then((v) async {

        CacheHelper.saveData(key: 'isGoogleSignIn', value: true).then((value) {
          isGoogleSignIn = true;
        });


        if(v.data() == null) {

          userCreateGoogleAccount(
              fullName: value.user?.displayName,
              phone: value.user?.phoneNumber ?? 'Enter your phone',
              address: 'Enter your address',
              uId: value.user?.uid,
              email: value.user?.email,
              imageProfile: value.user?.photoURL);

        } else {

          var deviceToken = await getDeviceToken();

          FirebaseFirestore.instance.collection('users').doc(value.user?.uid).update({
            'device_token': deviceToken,
          });

          emit(SuccessLoginWithGoogleAccountState(value.user!.uid));

        }

      });

     }).catchError((error) {

       if(kDebugMode) {
         print('${error.toString()} ---> in user login with google account.');
       }
       
       emit(ErrorLoginWithGoogleAccountState(error));

     });
  }


  void userCreateGoogleAccount({
    required String? fullName,
    required String? phone,
    required String? address,
    required String? uId,
    required String? email,
    required String? imageProfile,
}) async {

    var deviceToken = await getDeviceToken();

    UserModel model = UserModel(
      fullName: fullName,
      email: email,
      address: address,
      phone: phone,
      uId: uId,
      imageProfile: imageProfile ?? profile,
      isInfoComplete: false,
      senders: {},
      deviceToken: deviceToken,
    );

    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap()).then((value) {

      emit(SuccessCreateUserLoginGoogleAccountState(model));

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} ---> in user create google account.');
      }

      emit(ErrorCreateUserLoginGoogleAccountState(error));

    });


  }




}