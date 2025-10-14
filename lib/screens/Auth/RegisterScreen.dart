import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppConfig.dart';

import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/config/AppTheme.dart';
import 'package:senetunes/config/AppValidation_rules.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/widgtes/Common/BaseBlocButton.dart';
import 'package:senetunes/widgtes/common/BaseAppIcon.dart';

class RegisterScreen extends StatefulWidget {
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with BaseMixins {
  DateTime birthday = DateTime.now();
  TextEditingController birthdayController = TextEditingController();
  final Map<String, dynamic> formData = {
    'firstname': null,
    'lastname': null,
    'email': null,
    'password': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  var media;

  Widget _buildFirstNameField() {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecorationStyle.defaultStyle.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          child: SvgPicture.asset(
            "assets/icons/svg/Nom.svg",
            color: primary,
          ),
        ),
      ),
      // decoration: InputDecoration(
      //   labelText: $t(context, 'f_name'),
      // ),
      validator: (value) => AppValidation(context).validateName(value),
      onSaved: (String value) {
        formData['firstname'] = value;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecorationStyle.defaultStyle.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          child: SvgPicture.asset(
            "assets/icons/svg/Nom.svg",
            color: primary,
          ),
        ),
      ),
      // decoration: InputDecoration(
      //   labelText: $t(context, 'l_name'),
      // ),
      validator: (value) => AppValidation(context).validateName(value),
      onSaved: (String value) {
        formData['lastname'] = value;
      },
    );
  }

  // Widget _buildBirthDayPicker() {
  //   return TextFormField(
  //     controller: birthdayController,
  //     onTap: () async {
  //       birthday = await showDatePicker(
  //           builder: (BuildContext context, Widget child) {
  //             return Theme(
  //               data: ThemeData.dark().copyWith(
  //                 colorScheme: ColorScheme.dark(
  //                   primary: primary,
  //                   onPrimary: Colors.white,
  //                 ),
  //               ),
  //               child: child,
  //             );
  //           },
  //           context: context,
  //           initialDate: birthday,
  //           lastDate: DateTime.now(),
  //           firstDate: DateTime(1940),
  //           locale: Locale.fromSubtags(languageCode: 'fr'));
  //       if (birthday == null) birthday = DateTime.now();
  //       setState(() {
  //         birthdayController.text = "${birthday.year}-${birthday.month}-${birthday.day}";
  //       });
  //     },
  //     decoration: InputDecoration(
  //       suffixIcon: Icon(
  //         Icons.calendar_today_outlined,
  //         color: primary,
  //       ),
  //       labelText: $t(context, 'birthday'),
  //     ),
  //     onSaved: (String value) {
  //       formData['birthday'] = value;
  //     },
  //   );
  // }

  Widget _buildEmailField() {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecorationStyle.defaultStyle.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          child: SvgPicture.asset(
            "assets/icons/svg/email.svg",
            color: primary,
          ),
        ),
      ),
      // decoration: InputDecoration(labelText: $t(context, 'email')),
      validator: (value) => AppValidation(context).validateEmail(value),
      onSaved: (String value) {
        formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      key: passKey,
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecorationStyle.defaultStyle.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          child: SvgPicture.asset(
            "assets/icons/svg/padlock.svg",
            color: primary,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hidePass
                ? Icons.remove_red_eye_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              hidePass = !hidePass;
            });
          },
        ),
      ),
      // decoration: InputDecoration(
      //     labelText: $t(context, 'password', value: 'Password')),
      validator: (value) => AppValidation(context).validatePassword(value),
      obscureText: hidePass,
      onSaved: (String value) {
        formData['passwd'] = value;
      },
    );
  }

  bool _termsChecked = false;
  bool errorShow = true;
  bool hidePass = true;
  bool hideConfirmPass = true;

  Widget _buildTermsCheck() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: ListTile(
        leading: Checkbox(
          activeColor: Theme.of(context).primaryColor,
          side: BorderSide(
            color: Colors.white,
            width: 1,
          ),
          // shape: RoundedRectangleBorder(
          //   side:
          // ),
          value: _termsChecked,
          onChanged: (bool value) => setState(() => _termsChecked = value),
        ),
        // controlAffinity: ListTileControlAffinity.leading,
        title: Text(
            $t(
              context,
              'terms',
            ),
            style: TextStyle(color: white)),
        subtitle: !errorShow
            ? Text(
                $t(
                  context,
                  'r_field',
                ),
                style: TextStyle(color: Color(0xFFe53935), fontSize: 12),
              )
            : null,
        dense: true,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecorationStyle.defaultStyle.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          child: SvgPicture.asset(
            "assets/icons/svg/padlock.svg",
            color: primary,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hideConfirmPass
                ? Icons.remove_red_eye_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              hideConfirmPass = !hideConfirmPass;
            });
          },
        ),
      ),
      // decoration: InputDecoration(labelText: $t(context, 'cnfrm_account')),
      validator: (value) => AppValidation(context)
          .validateConfirmPassword(value, passKey.currentState.value),
      obscureText: hideConfirmPass,
    );
  }

  _submit(BuildContext context, AuthProvider provider) {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      errorShow = _termsChecked;
    });

    if (_formKey.currentState.validate() && _termsChecked) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      // formData['AUTH_KEY'] = AppConfig.API_AUTH_KEY;

      provider.singUpWithEmail(formData).then((response) {
        Flushbar(
                backgroundColor: barColor.withOpacity(0.95),
                icon: Icon(
                  Icons.error_outline,
                  color: Theme.of(context).primaryColor,
                ),
                duration: Duration(seconds: 3),
                flushbarPosition: FlushbarPosition.TOP,
                titleText:
                    Text($t(context, 'ops'), style: TextStyle(color: white)),
                messageText: Text(response, style: TextStyle(color: white)),
              ).show(context);
        // Navigator.pushReplacementNamed(context, AppRoutes.confirmScreenRoute);
      });
    } else {
      //   If all data are not valid then start auto validation.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    var provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () => Navigator.pop(context),
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Theme.of(context).iconTheme.color,
      //     ),
      //   ),
      //   title: Text(
      //     $t(context, 'create_new_Account'),
      //     style: TextStyle(color: primary),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: Container(
        height: media.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(children: [
                        Container(
                          width: double.infinity,
                          height: 261,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: ExactAssetImage(
                                AppConfig.TOP_BACKGROUND,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          // color: Colors.red,
                        ),
                        Positioned.fill(
                          child:
                              Container(color: Color.fromRGBO(18, 18, 18, 0.7)),
                        ),
                        Align(
                          child: Container(
                            width: 220,
                            height: 261,
                            child: Image.asset(
                              AppConfig.APP_LOGO,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          $t(context, 'create_new_Account'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: 20),
                        ),
                      ),
                      // SizedBox(
                      //   height: 90,
                      // ),
                      // BaseAppIcon(
                      //   width: media.width * 0.5,
                      // ),

                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: media.height / 20,
                            horizontal: media.height / 40),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                heightFactor: 1,
                                child: Text(
                                  $t(context, 'f_name'),
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _buildFirstNameField(),
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                heightFactor: 1,
                                child: Text(
                                  $t(context, 'l_name'),
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _buildLastNameField(),
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                heightFactor: 1,
                                child: Text(
                                  $t(context, 'email'),
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              // _buildBirthDayPicker(),
                              _buildEmailField(),
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                heightFactor: 1,
                                child: Text(
                                  $t(context, 'password'),
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _buildPasswordField(),
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                heightFactor: 1,
                                child: Text(
                                  $t(context, 'cnfrm_account'),
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _buildConfirmPasswordField(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ),

                  _buildTermsCheck(),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: media.height / 40),
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: media.height / 20, vertical: 20),
                    child: BaseBlockButton(
                      isLoaded: provider.isLoaded,
                      color: Theme.of(context).primaryColor,
                      label: $t(context, 'create_new_Account'),
                      textColor: Colors.white,
                      radius: 100,
                      onPressed: () => _submit(context, provider),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
