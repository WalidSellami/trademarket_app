abstract class ResetStates {}

class InitialResetState extends ResetStates {}

class LoadingSendEmailResetState extends ResetStates {}

class SuccessSendEmailResetState extends ResetStates {}

class ErrorSendEmailResetState extends ResetStates {

  dynamic error;
  ErrorSendEmailResetState(this.error);

}