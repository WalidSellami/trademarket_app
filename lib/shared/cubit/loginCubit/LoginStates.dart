import 'package:trade_market_app/data/models/userModel/UserModel.dart';

abstract class LoginStates {}

class InitialLoginState extends LoginStates {}


// Login With Email And Password
class LoadingLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {

  final String uId;
  final bool isEmailVerified;
  SuccessLoginState(this.uId, this.isEmailVerified);

}

class ErrorLoginState extends LoginStates {

  dynamic error;
  ErrorLoginState(this.error);

}



// Login With Google Account
class LoadingLoginWithGoogleAccountState extends LoginStates {}

class SuccessLoginWithGoogleAccountState extends LoginStates {

  final String uId;
  SuccessLoginWithGoogleAccountState(this.uId);

}

class ErrorLoginWithGoogleAccountState extends LoginStates {

  dynamic error;
  ErrorLoginWithGoogleAccountState(this.error);

}

class SuccessCreateUserLoginGoogleAccountState extends LoginStates {

  final UserModel model;
  SuccessCreateUserLoginGoogleAccountState(this.model);

}

class ErrorCreateUserLoginGoogleAccountState extends LoginStates {

  dynamic error;
  ErrorCreateUserLoginGoogleAccountState(this.error);

}
