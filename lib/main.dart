import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:senetunes/config/AppProvider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/config/AppTheme.dart';
import 'package:senetunes/providers/ThemeProvider.dart';
import 'package:senetunes/screens/Auth/LoginScreen.dart';
import 'package:senetunes/screens/exploreScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/Applocalizations.dart';

void main() async {

    WidgetsFlutterBinding.ensureInitialized();
    await GlobalConfiguration().loadFromAsset("config");
    await FlutterDownloader.initialize(debug: true);
    await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  var status = await Permission.storage.status;
  if (!status.isGranted) {
  await Permission.storage.request();
  }
  bool loggedIn;
  await SharedPreferences.getInstance()
      .then((value) => value.getString('user') != null ? loggedIn = true : loggedIn = false);

  runApp(RekordApp(loggedIn));
}

class RekordApp extends StatelessWidget {
  // This widget is the root of your application.
  RekordApp(this.loggedIn);
  final bool loggedIn;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers(),
        child: Consumer<ThemeProvider>(
          builder: (context, value, child) {
            final isDark = context.watch<ThemeProvider>().darkMode;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Senetunes',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routes: AppRoutes().routes(),
              home: loggedIn ? ExploreScreen() : LoginScreen(),
              themeMode: value.darkMode ? ThemeMode.light : ThemeMode.dark,
              // List all of the app's supported locales here
              supportedLocales: [
                Locale('fr', 'FR'),
                Locale('en', 'EN'),
              ],
              // These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: [
                // A class which loads the translations from JSON files
                AppLocalizations.delegate,
                // Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) =>
                  AppLocalizations(locale).localeResolutionCallback(supportedLocales),
            );
          },
        ));
  }
}
