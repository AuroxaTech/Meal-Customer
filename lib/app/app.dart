import 'package:firestore_chat/views/firestore_chat.page.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_shared/stacked_shared.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../services/app.service.dart';
import '../services/auth.service.dart';
import '../services/cart.service.dart';
import '../services/firebase.service.dart';
import '../services/firebase_token.service.dart';
import '../services/geocoder.service.dart';
import '../ui/bottomsheets/generic_bottomsheet.dart';
import '../ui/dialogs/basic_dialog.dart';
import '../views/pages/auth/forgot_password.page.dart';
import '../views/pages/auth/login.page.dart';
import '../views/pages/auth/register.page.dart';
import '../views/pages/cart/cart.page.dart';
import '../views/pages/checkout/checkout.page.dart';
import '../views/pages/delivery_address/delivery_addresses.page.dart';
import '../views/pages/delivery_address/edit_delivery_addresses.page.dart';
import '../views/pages/delivery_address/new_delivery_addresses.page.dart';
import '../views/pages/favourite/favourites.page.dart';
import '../views/pages/home/home.page.dart';
import '../views/pages/notification/notification_details.page.dart';
import '../views/pages/notification/notifications.page.dart';
import '../views/pages/order/orders.page.dart';
import '../views/pages/order/orders_details.page.dart';
import '../views/pages/order/orders_tracking.page.dart';
import '../views/pages/product/product_details.page.dart';
import '../views/pages/profile/change_password.page.dart';
import '../views/pages/profile/edit_profile.page.dart';
import '../views/pages/search/search.page.dart';
import '../views/pages/splash.page.dart';
import '../views/pages/vendor/vendor.page.dart';
import '../views/pages/wallet/wallet.page.dart';
import '../views/pages/welcome/welcome.page.dart';

@StackedApp(
  bottomsheets: [
    StackedBottomsheet(classType: GenericBottomSheet),
  ],
  dialogs: [
    StackedDialog(classType: BasicDialog),
  ],
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: WelcomePage),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: RegisterPage),
    MaterialRoute(page: ChangePasswordPage),
    MaterialRoute(page: ForgotPasswordPage),
    MaterialRoute(page: EditProfilePage),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: NotificationsPage),
    MaterialRoute(page: NotificationDetailsPage),
    MaterialRoute(page: VendorPage),
    MaterialRoute(page: ProductDetailsPage),
    MaterialRoute(page: SearchPage),
    MaterialRoute(page: CartPage),
    MaterialRoute(page: CheckoutPage),
    MaterialRoute(page: OrdersPage),
    MaterialRoute(page: OrderDetailsPage),
    MaterialRoute(page: FirestoreChatPage),
    MaterialRoute(page: DeliveryAddressesPage),
    MaterialRoute(page: NewDeliveryAddressesPage),
    MaterialRoute(page: EditDeliveryAddressesPage),
    MaterialRoute(page: FavouritesPage),
    MaterialRoute(page: WalletPage),
    MaterialRoute(page: OrderTrackingPage),
  ],
  dependencies: [
    // Lazy singletons
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    // LazySingleton(
    //   classType: InformationService,
    //   dispose: disposeInformationService,
    // ),
    LazySingleton(
      classType: NavigationService,
      environments: {Environment.dev},
    ),
    LazySingleton(
        classType: NavigationService,
        environments: {Environment.dev},
        instanceName: 'instance1'),
    LazySingleton(
      classType: ThemeService,
      resolveUsing: ThemeService.getInstance,
    ),
    LazySingleton(classType: AuthServices),
    LazySingleton(classType: CartServices),
    LazySingleton(classType: AppService),
    LazySingleton(classType: FirebaseService),
    LazySingleton(classType: FirebaseTokenService),
    LazySingleton(classType: GeocoderService),
  ],
  logger: StackedLogger(),
  locatorName: 'exampleLocator',
  locatorSetupName: 'setupExampleLocator',
)
class App {
  /// This class has no puporse besides housing the annotation that generates the required functionality
}
