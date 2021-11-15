import 'package:flutter/material.dart'; import 'package:senetunes/config/AppColors.dart';
import 'package:senetunes/config/AppConfig.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/mixins/BaseMixins.dart';
import 'package:senetunes/models/Media.dart';
import 'package:senetunes/screens/Auth/LoginScreen.dart';
import 'package:senetunes/widgtes/Common/BaseBlocButton.dart';
import 'package:senetunes/widgtes/Common/OutlineBorderButton.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with BaseMixins {
  @override
  void initState() {
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
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(
              "assets/Splash/welcome_background.png",
            ),
          ),
        ),
        padding: EdgeInsets.only(top: 50, left: 20, right: 15),
        alignment: Alignment.topCenter,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 220,
                child: Image.asset(
                  AppConfig.APP_LOGO,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(flex:2,child:SizedBox()),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  $t(
                    context,
                    'enjoy_best_music',
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),

              SizedBox(height: 35),
              BaseBlockButton(
                // isLoaded: provider.check,
                color: Theme.of(context).primaryColor,
                radius: 100,
                label: $t(context, 'sign_in'),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              OutlineBorderButton(
                // isLoaded: provider.check,
                // color: Theme.of(context).primaryColor,
                radius: 100,
                label: $t(context, 'create_new_Account'),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.registerRoute);
                },
              ),
              Expanded(child:SizedBox()),
            ]),
      ),
    );
  }
}
