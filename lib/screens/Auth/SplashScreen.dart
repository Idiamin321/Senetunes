import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppConfig.dart';
import 'package:senetunes/models/Media.dart';
import 'package:senetunes/screens/Auth/LoginScreen.dart';

import 'WelcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover,
            image: AssetImage(AppConfig.APP_BACKGROUND,),
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 250,
          child: Image.asset(
            AppConfig.APP_LOGO,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
