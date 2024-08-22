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
import 'constants/app_languages.dart';
import 'firebase_options.dart';
import 'services/firebase.service.dart';
import 'services/general_app.service.dart';
import 'services/notification.service.dart';
import 'views/common_widget/app_header.dart';

//ssll handshake error
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void _main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: TestApp(),
    ),
  );
}

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      //setting up firebase notifications
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await LocalizeAndTranslate.init(
        defaultType: LocalizationDefaultType.asDefined,
        supportedLanguageCodes: AppLanguages.codes,
        assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
      );

      //
      await LocalStorageService.getPrefs();
      await CartServices.getCartItems();
      //await NotificationService.clearIrrelevantNotificationChannels();
      await NotificationService.initializeAwesomeNotification();
      await NotificationService.listenToActions();
      await FirebaseService().setUpFirebaseMessaging();
      FirebaseMessaging.onBackgroundMessage(
          GeneralAppService.onBackgroundMessageHandler);

      //prevent ssl error
      HttpOverrides.global = MyHttpOverrides();
      //setting up crashlytics only for production
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // String input = "online.mealknight";
      // String sha1Hash = generateSha1(input);
      // print('SHA-1 hash of "$input": $sha1Hash');

      // Run app!
      runApp(
        const LocalizedApp(
          child: MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

String generateSha1(String input) {
  var bytes = utf8.encode(input); // Encode the input string to bytes
  var digest = sha1.convert(bytes); // Generate the SHA-1 hash
  return digest.toString(); // Return the hash as a string
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
          SliverList.list(children: [
            for (int i = 0; i < 5; i++)
              ListTile(
                title: Text('Item #$i'),
              ),
          ]),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
