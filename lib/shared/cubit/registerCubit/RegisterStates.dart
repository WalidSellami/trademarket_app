import 'package:trade_market_app/data/models/userModel/UserModel.dart';

abstract class RegisterStates {}

class InitialRegisterState extends RegisterStates {}

// Register
class LoadingUserRegisterState extends RegisterStates {}

class ErrorUserRegisterState extends RegisterStates {

  dynamic error;
  ErrorUserRegisterState(this.error);

}


// Create Register Account
class LoadingUserCreateRegisterState extends RegisterStates {}

class SuccessUserCreateRegisterState extends RegisterStates {
  final UserModel userModel;
  SuccessUserCreateRegisterState(this.userModel);
}

class ErrorUserCreateRegisterState extends RegisterStates {

  dynamic error;
  ErrorUserCreateRegisterState(this.error);

}



// Send Email Verification
class LoadingSendEmailVerificationRegisterState extends RegisterStates {}

class SuccessSendEmailVerificationRegisterState extends RegisterStates {}

class ErrorSendEmailVerificationRegisterState extends RegisterStates {

  dynamic error;
  ErrorSendEmailVerificationRegisterState(this.error);

}



// Auto Verification
class LoadingAutoVerificationRegisterState extends RegisterStates {}

class SuccessAutoVerificationRegisterState extends RegisterStates {}

class ErrorAutoVerificationRegisterState extends RegisterStates {

  dynamic error;
  ErrorAutoVerificationRegisterState(this.error);

}



// Remove Account
class LoadingRemoveAccountRegisterState extends RegisterStates {}

class SuccessRemoveAccountRegisterState extends RegisterStates {}

class ErrorRemoveAccountRegisterState extends RegisterStates {

  dynamic error;
  ErrorRemoveAccountRegisterState(this.error);

}
