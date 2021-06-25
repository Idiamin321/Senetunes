import '../mixins/BaseMixins.dart';

class AppValidation with BaseMixins {
  AppValidation(this.context);
  final context;
  String validateName(String value) {
    if (value.length < 1) return $t(context, 'enter_your_name');
    if (value.length < 3) return $t(context, 'name_must_must_be_2_characters_long');
    return null;
  }

  String validateLocation(String value) {
    if (value == null) return 'Select a location';
    return null;
  }

  String validateDateTime(value) {
    if (value == null) return 'Select Date & Time';
    return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return $t(context, 'enter_a_valid_email_address');
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length < 1) return $t(context, 'enter_your_password');
    if (value.length < 6) return $t(context, 'password_must_be_6_characters_long');
    return null;
  }

  String validateConfirmPassword(String value, String value2) {
    if (value.length < 1) return $t(context, 're_enter_your_password');
    if (value.length < 6) return $t(context, 'password_must_be_6_characters_long');
    if (value != value2) return $t(context, 'password_must_match');
    return null;
  }
}
