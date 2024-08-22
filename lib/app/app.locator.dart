// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';
import 'package:stacked_themes/src/theme_service.dart';

import '../services/app.service.dart';
import '../services/auth.service.dart';
import '../services/cart.service.dart';
import '../services/firebase.service.dart';
import '../services/firebase_token.service.dart';
import '../services/geocoder.service.dart';

final exampleLocator = StackedLocator.instance;

Future<void> setupExampleLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  exampleLocator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  exampleLocator.registerLazySingleton(() => DialogService());
  exampleLocator.registerLazySingleton(() => BottomSheetService());
  exampleLocator
      .registerLazySingleton(() => NavigationService(), registerFor: {"dev"});
  exampleLocator.registerLazySingleton(() => NavigationService(),
      registerFor: {"dev"}, instanceName: 'instance1');
  exampleLocator.registerLazySingleton(() => ThemeService.getInstance());
  exampleLocator.registerLazySingleton(() => AuthServices());
  exampleLocator.registerLazySingleton(() => CartServices());
  exampleLocator.registerLazySingleton(() => AppService());
  exampleLocator.registerLazySingleton(() => FirebaseService());
  exampleLocator.registerLazySingleton(() => FirebaseTokenService());
  exampleLocator.registerLazySingleton(() => GeocoderService());
}
