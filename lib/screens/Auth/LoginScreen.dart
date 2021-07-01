import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/config/AppValidation_rules.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/User.dart';
import 'package:senetunes/providers/AuthProvider.dart';
import 'package:senetunes/widgtes/Common/BaseBlocButton.dart';
import 'package:senetunes/widgtes/common/BaseAppIcon.dart';
import 'package:xml2json/xml2json.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with BaseMixins {
  final Map<String, String> formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var media;

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(
        focusColor: Colors.blue,
        labelText: $t(context, 'email'),
      ),
      validator: (value) => AppValidation(context).validateEmail(value),
      onSaved: (String value) {
        formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: $t(context, 'password'),
      ),
      validator: (value) => AppValidation(context).validatePassword(value),
      obscureText: true,
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
      final Map<String, dynamic> jsonMap = json.decode(transformer.toBadgerfish());
      if (response.statusCode != 200) {
        Flushbar(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          icon: Icon(
            Icons.error_outline,
            color: Theme.of(context).primaryColor,
          ),
          duration: Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text($t(context, 'wrong_credentials')),
          messageText: Text(jsonMap['error']['message']['\$']),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          $t(context, 'sign_in'),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Center(
        child: Container(
          height: media.height,
          padding: EdgeInsets.only(
              top: media.height / 20, left: media.height / 20, right: media.height / 20),
          child: Form(
            key: _formKey, //Works with statefull widget
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 90),
                  Center(child: BaseAppIcon(width: media.width * 0.5)),
                  SizedBox(height: 20.0),
                  _buildUsernameField(),
                  SizedBox(height: 10.0),
                  _buildPasswordField(),
                  SizedBox(height: 40.0),
                  BaseBlockButton(
                    isLoaded: provider.check,
                    color: Theme.of(context).primaryColor,
                    label: $t(context, 'sign_in'),
                    textColor: Colors.white,
                    onPressed: () => _handleSubmit(context, provider),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      FlatButton.icon(
                        icon: Icon(
                          EvilIcons.arrow_right,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          $t(
                            context,
                            'create_new_Account',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.registerRoute);
                          // Navigator.pushNamed(context, AppRoutes.webView,
                          //     arguments: Tuple2("Senetunes", "https://www.senetunes.com/fr/authentification?back=my-account"));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 14.0),
                  Center(
                    child: FlatButton(
                      child: Text(
                        $t(
                          context,
                          'skip',
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.home,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
