import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/pages/SplashScreenPage.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  print("message: $message");
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  if (!kIsWeb) {
    Stripe.publishableKey = Constants.STRIPE_DEV_PUBLISH;

    Stripe.instance.applySettings();
  }

  if (!kIsWeb) {
    await Firebase.initializeApp();
    AndroidInitializationSettings("@mipmap/launcher_icon");
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  } else {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDSKJI2BYn8xeOZ8lIYkUpmS4dmkk4pju0",
        authDomain: "lisocash-9980b.firebaseapp.com",
        projectId: "lisocash-9980b",
        storageBucket: "lisocash-9980b.appspot.com",
        messagingSenderId: "845217810394",
        appId: "1:845217810394:web:2bb6ebb6b6fe499cda22e3",
        measurementId: "G-27HYJ139N3",
      ),
    );
  }

  runApp(RootMain());
}

class RootMain extends StatelessWidget {
  const RootMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.kTitleApplication,
      debugShowCheckedModeBanner: false,
      navigatorKey: Constants.navigatorKey,
      scaffoldMessengerKey: Constants.scaffoldKey,
      theme: ThemeData(
        primaryColor: Constants.kPrimaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Constants.kAccentColor,
          secondary: Constants.kSecondColor,
        ),
        useMaterial3: true,
        iconTheme: IconThemeData(color: Colors.white, size: 16.0),
        appBarTheme: AppBarTheme(elevation: 0.0, color: Constants.kAccentColor, centerTitle: true),
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Constants.kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Constants.kTextDefaultColor,
              displayColor: Constants.kTextDefaultColor,
              fontFamily: GoogleFonts.aBeeZee().fontFamily,
            ),
        cardColor: Colors.white,
      ),
      home: SplashScreenPage(), // SplashScreenPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr', ''),
        Locale('en', ''),
      ],
    );
  }
}
