import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:senetunes/config/AppColors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:senetunes/config/AppConfig.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/config/AppTheme.dart';
import 'package:senetunes/config/AppValidation_rules.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/User.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/widgtes/Common/BaseBlocButton.dart';
import 'package:senetunes/widgtes/common/BaseAppIcon.dart';
import 'package:xml2json/xml2json.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with BaseMixins {
  final Map<String, String> formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var media;

  Widget _buildUsernameField() {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecorationStyle.defaultStyle.copyWith(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: SvgPicture.asset(
            "assets/icons/svg/email.svg",
            color: primary,
          ),
        ),
      ),
      validator: (value) => AppValidation(context).validateEmail(value),
      onSaved: (String value) {
        formData['email'] = value;
      },
    );
  }

  bool hidePass=true;
  Widget _buildPasswordField() {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 16),
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
            hidePass?Icons.remove_red_eye_outlined:Icons.visibility_off_outlined,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              hidePass=!hidePass;
            });
          },
        ),
      ),
      validator: (value) => AppValidation(context).validatePassword(value),
      obscureText: hidePass,
      onSaved: (String value) {
        formData['password'] = value;
      },
    );
  }

  _handleSubmit(BuildContext context, AuthProvider provider) async {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();

      //Call Auth Provider here...
      Response response = await provider.singInWithEmail(formData);
      var transformer = Xml2Json();
      transformer.parse(response.data);
      print(response.data);
      final Map<String, dynamic> jsonMap =
          json.decode(transformer.toBadgerfish());
      if (response.statusCode != 200) {
        Flushbar(
          backgroundColor:
              barColor.withOpacity(0.95),
          icon: Icon(
            Icons.error_outline,
            color: Theme.of(context).primaryColor,
          ),
          duration: Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'wrong_credentials'),style:TextStyle(color:white)),
          messageText: Text(jsonMap['error']['message']['\$'],style:TextStyle(color:white)),
        ).show(context);
      } else {
        provider.setUser(User.fromJson(jsonMap));
        Navigator.popAndPushNamed(context, AppRoutes.home);
        // Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    var provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: background,
      body: Container(
        // height:MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey, //Works with statefull widget
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      child: Container(color: Color.fromRGBO(18, 18, 18, 0.7)),
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
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: media.height / 20,
                        horizontal: media.height / 40),
                    // padding: EdgeInsets.only(
                    //     top: media.height / 20,
                    //     left: media.height / 20,
                    //     right: media.height / 20),
                    child: Column(
                      children: [
                        Text(
                          $t(context, 'sign_in'),
                          style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: 25),
                        ),
                        SizedBox(height: 20.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          heightFactor: 1,
                          child: Text(
                            $t(context, 'email'),
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        _buildUsernameField(),
                        SizedBox(height: 15.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          heightFactor: 1,
                          child: Text(
                            $t(context, 'password'),
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        _buildPasswordField(),
                        SizedBox(height: 40.0),
                        BaseBlockButton(
                          isLoaded: provider.check,
                          color: Theme.of(context).primaryColor,
                          radius: 100,
                          label: $t(context, 'sign_in'),
                          textColor: Colors.white,
                          onPressed: () => _handleSubmit(context, provider),
                        ),
                        SizedBox(height: 20.0),
                        Wrap(
                          spacing: 2,
                          children: [
                            // FlatButton.icon(
                            //   icon: Icon(
                            //     EvilIcons.arrow_right,
                            //     color: Theme.of(context).primaryColor,
                            //   ),
                            //    label:
                            Text(
                              $t(
                                context,
                                'no_Account',
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.white70),
                            ),
                            InkWell(
                              child: Text(
                                $t(
                                  context,
                                  'create_your_Account',
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.registerRoute);
                                // Navigator.pushNamed(context, AppRoutes.webView,
                                //     arguments: Tuple2("Senetunes", "https://www.senetunes.com/fr/authentification?back=my-account"));
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 14.0),
                        // Center(
                        //   child: FlatButton(
                        //     child: Text(
                        //       $t(
                        //         context,
                        //         'skip',
                        //       ),
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w300,
                        //           fontSize: 16,
                        //           color: Colors.grey,
                        //           ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.pushNamed(
                        //         context,
                        //         AppRoutes.home,
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
