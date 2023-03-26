import 'package:flutx/flutx.dart';

class Validation {
  String? validateCode(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter email";
    } else if (!FxStringValidator.numberValidator(text)) {
      return "Please enter valid Code";
    }
    return null;
  }

  String? validateEmail(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter email";
    } else if (!FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validateName(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter  name";
    }
    return null;
  }

  String? validatePassword(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringValidator.validateString(text,
        includeSpecialCharacter: true,
        includeAlphabet: true,
        includeDigit: true,
        minDigit: 1,
        minAlphabet: 1,
        minLength: 6,
        maxLength: 20)) {
      return "Password must have special character and number, minimum 6 chars";
    }
    return null;
  }

  String? validateMobile(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter Mobile";
    } else if (!FxStringValidator.validateString(text,
        includeDigit: true,
        minDigit: 8,
        maxDigit: 20,
        maxAlphabet: 0,
        minAlphabet: 0,
        includeAlphabet: false)) {
      return "Please enter valid mobile number";
    }
    return null;
  }

  String? validateAccount(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter account number";
    } else if (!FxStringValidator.numberValidator(text)) {
      return "Please enter valid account number";
    }
    return null;
  }

  String? validateAmount(String? text) {
    text = text!.trim();
    if (text.isEmpty) {
      return "Please enter amount";
    } else if (!FxStringValidator.numberValidator(text)) {
      return "Number only";
    }
    return null;
  }
}
