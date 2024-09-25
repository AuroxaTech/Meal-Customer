import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/my_app.dart';
import 'package:mealknight/services/cart.service.dart';
import 'package:mealknight/services/local_storage.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/trial_service.dart';
import 'constants/app_languages.dart';
import 'firebase_options.dart';
import 'services/firebase.service.dart';
import 'services/general_app.service.dart';
import 'services/notification.service.dart';
import 'views/common_widget/app_header.dart';

// SSL handshake error
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  await runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await LocalizeAndTranslate.init(
        defaultType: LocalizationDefaultType.asDefined,
        supportedLanguageCodes: AppLanguages.codes,
        assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
      );

      await LocalStorageService.getPrefs();
      await CartServices.getCartItems();
      await NotificationService.initializeAwesomeNotification();
      await NotificationService.listenToActions();
      await FirebaseService().setUpFirebaseMessaging();
      FirebaseMessaging.onBackgroundMessage(
          GeneralAppService.onBackgroundMessageHandler);

      HttpOverrides.global = MyHttpOverrides();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String firstLaunchKey = 'first_launch';
      DateTime now = DateTime.now();

      // Check if firstLaunchKey exists
      String? firstLaunch = prefs.getString(firstLaunchKey);
      DateTime firstLaunchDate;
      if (firstLaunch == null) {
        // First time the app is run, store the current time
        prefs.setString(firstLaunchKey, now.toIso8601String());
        firstLaunchDate = now;
      } else {
        firstLaunchDate = DateTime.parse(firstLaunch);
      }

      // Calculate the difference in days
      int daysDifference = now.difference(firstLaunchDate).inDays;

      Widget appChild = (daysDifference >= 7) ? WhiteScreen() : MyApp();

      runApp(
        LocalizedApp(
          child: appChild,
        ),
      );
    },
        (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

String generateSha1(String input) {
  var bytes = utf8.encode(input);
  var digest = sha1.convert(bytes);
  return digest.toString();
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('SliverAppBar'),
            expandedHeight: 100.0,
            pinned: true,
            floating: true,
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 62),
              child: Container(
                height: 58,
                margin: const EdgeInsets.only(top: 4.0),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: const AppHeader(
                  type: "product",
                  subCategories: [],
                  vendorTypes: [],
                  hintText: "Search Pizza, Burger, Indian, etc.",
                  showFilter: false,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              for (int i = 0; i < 5; i++)
                ListTile(
                  title: Text('Item #$i'),
                ),
            ]),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
