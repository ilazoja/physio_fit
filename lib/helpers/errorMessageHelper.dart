import 'package:flutter/services.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class ErrorMessageHelper {

  static String getErrorMessage(PlatformException e) {
    print(e.code + " : " + e.message);
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        return copy.invalidEmail;
      case 'ERROR_WRONG_PASSWORD':
        return copy.emailAndPasswordSignInError;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return copy.emailInUseError;
      case 'ERROR_USER_NOT_FOUND':
        return copy.userNotExistError;
      default:
        return e.message;
    }
  }

}