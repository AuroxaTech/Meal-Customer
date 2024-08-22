import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/checkout.dart';
import 'package:mealknight/models/notification.dart';
import 'package:mealknight/models/order.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/views/pages/auth/forgot_password.page.dart';
import 'package:mealknight/views/pages/auth/login.page.dart';
import 'package:mealknight/views/pages/auth/register.page.dart';
import 'package:mealknight/views/pages/checkout/checkout.page.dart';
import 'package:mealknight/views/pages/delivery_address/delivery_addresses.page.dart';
import 'package:mealknight/views/pages/delivery_address/edit_delivery_addresses.page.dart';
import 'package:mealknight/views/pages/delivery_address/new_delivery_addresses.page.dart';
import 'package:mealknight/views/pages/favourite/favourites.page.dart';
import 'package:mealknight/views/pages/home/home.page.dart';
import 'package:mealknight/views/pages/order/orders_tracking.page.dart';
import 'package:mealknight/views/pages/profile/change_password.page.dart';
import 'package:mealknight/views/pages/vendor_details/vendor_details.page.dart';
import 'package:mealknight/views/pages/notification/notification_details.page.dart';
import 'package:mealknight/views/pages/notification/notifications.page.dart';
import 'package:mealknight/views/pages/onboarding.page.dart';
import 'package:mealknight/views/pages/order/orders_details.page.dart';
import 'package:mealknight/views/pages/product/product_details.page.dart';
import 'package:mealknight/views/pages/profile/edit_profile.page.dart';
import 'package:mealknight/views/pages/search/search.page.dart';
import 'package:mealknight/views/pages/wallet/wallet.page.dart';
import '../views/pages/cart/cart.page.dart';
import '../views/pages/order/orders.page.dart';
import '../views/pages/splash.page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (context) => const SplashPage());

    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => const OnboardingPage());

    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case AppRoutes.registerRoute:
      return MaterialPageRoute(builder: (context) => RegisterPage());

    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(builder: (context) => ForgotPasswordPage());

    case AppRoutes.homeRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(
            name: AppRoutes.homeRoute, arguments: {}),
        builder: (context) => const HomePage(),
      );

    //SEARCH
    case AppRoutes.search:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.search),
        builder: (context) => SearchPage(search: settings.arguments as Search),
      );

    //Product details
    case AppRoutes.product:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.product),
        builder: (context) =>
            ProductDetailsPage(product: settings.arguments as Product),
      );

    //Vendor details
    case AppRoutes.vendorDetails:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.vendorDetails),
        builder: (context) =>
            VendorDetailsPage(vendor: settings.arguments as Vendor),
      );

    //Cart page
    case AppRoutes.cartRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.cartRoute),
        builder: (context) => const CartPage(),
      );

    //Orders page
    case AppRoutes.ordersRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.ordersRoute),
        builder: (context) => const OrdersPage(),
      );

    //Checkout page
    case AppRoutes.checkoutRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.checkoutRoute),
        builder: (context) => CheckoutPage(
          checkout: settings.arguments as CheckOut,
        ),
      );

    //order details page
    case AppRoutes.orderDetailsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.orderDetailsRoute),
        builder: (context) => OrderDetailsPage(
          order: settings.arguments as Order,
        ),
      );
    //order tracking page
    case AppRoutes.orderTrackingRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.orderTrackingRoute),
        builder: (context) => OrderTrackingPage(
          order: settings.arguments as Order,
        ),
      );
    //chat page
    case AppRoutes.chatRoute:
      return FirestoreChat().chatPageWidget(
        settings.arguments as ChatEntity,
      );

    //
    case AppRoutes.editProfileRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.editProfileRoute),
        builder: (context) => const EditProfilePage(),
      );

    //change password
    case AppRoutes.changePasswordRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.changePasswordRoute),
        builder: (context) => const ChangePasswordPage(),
      );

    //Delivery addresses
    case AppRoutes.deliveryAddressesRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.deliveryAddressesRoute),
        builder: (context) => const DeliveryAddressesPage(),
      );
    case AppRoutes.newDeliveryAddressesRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.newDeliveryAddressesRoute),
        builder: (context) => NewDeliveryAddressesPage(
            isFromRegister: settings.arguments as bool),
      );
    case AppRoutes.editDeliveryAddressesRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.editDeliveryAddressesRoute),
        builder: (context) => EditDeliveryAddressesPage(
          deliveryAddress: settings.arguments as dynamic,
        ),
      );

    //wallets
    case AppRoutes.walletRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.walletRoute),
        builder: (context) => const WalletPage(),
      );

    //favourites
    case AppRoutes.favouritesRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.favouritesRoute),
        builder: (context) => const FavouritesPage(
          vendorTypes: [],
        ),
      );

    //profile settings/actions
    case AppRoutes.notificationsRoute:
      return MaterialPageRoute(
        settings:
            RouteSettings(name: AppRoutes.notificationsRoute, arguments: Map()),
        builder: (context) => const NotificationsPage(),
      );
    //
    case AppRoutes.notificationDetailsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(
            name: AppRoutes.notificationDetailsRoute, arguments: {}),
        builder: (context) {
          final args = settings.arguments;
          print("arguments $args");
          if (args is NotificationModel) {
            return NotificationDetailsPage(notification: args);
          } else {
            // Handle the case when arguments are null or not of type NotificationModel
            return const Scaffold(
              body: Center(
                child: Text('Invalid arguments'),
              ),
            );
          }
        },
      );

    default:
      return MaterialPageRoute(builder: (context) => const OnboardingPage());
  }
}
