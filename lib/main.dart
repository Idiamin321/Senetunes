// lib/main.dart
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:senetunes/config/AppProvider.dart';
import 'package:senetunes/config/AppRoutes.dart';
import 'package:senetunes/config/AppTheme.dart';
import 'package:senetunes/models/DownloadTaskInfo.dart';
import 'package:senetunes/providers/ThemeProvider.dart';
import 'package:senetunes/screens/Auth/WelcomeScreen.dart';
import 'package:senetunes/screens/exploreScreen.dart';

import 'config/Applocalizations.dart';

Future<void> _initDownloader() async {
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true, // retire en prod si warning
  );
}

Future<void> _initLocalNotifications() async {
  final plugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidInit =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings darwinInit = DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: darwinInit,
    macOS: darwinInit,
  );

  await plugin.initialize(initSettings);
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DownloadTaskInfoAdapter());
  }
  await Hive.openBox('downloads');
}

Future<void> _requestRuntimePermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }
}

Future<bool> _isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final user = prefs.getString('user');
  return (user != null && user.isNotEmpty);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("config");
  await _initDownloader();
  await _initLocalNotifications();
  await _initHive();
  await _requestRuntimePermissions();

  final loggedIn = await _isLoggedIn();

  runApp(RekordApp(loggedIn: loggedIn));
}

class RekordApp extends StatelessWidget {
  const RekordApp({super.key, required this.loggedIn});
  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Senetunes',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
            routes: AppRoutes().routes(),
            home: loggedIn ? const ExploreScreen() : const WelcomeScreen(),
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              return AppLocalizations(locale)
                  .localeResolutionCallback(supportedLocales);
            },
          );
        },
      ),
    );
  }
}
