// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firestore_chat/models/chat_entity.dart' as _i34;
import 'package:firestore_chat/views/firestore_chat.page.dart' as _i20;
import 'package:flutter/material.dart' as _i27;
import 'package:flutter/material.dart';
import 'package:mealknight/models/checkout.dart' as _i32;
import 'package:mealknight/models/notification.dart' as _i28;
import 'package:mealknight/models/order.dart' as _i33;
import 'package:mealknight/models/product.dart' as _i30;
import 'package:mealknight/models/search.dart' as _i31;
import 'package:mealknight/models/vendor_type.dart' as _i29;
import 'package:mealknight/views/pages/auth/forgot_password.page.dart' as _i7;
import 'package:mealknight/views/pages/auth/login.page.dart' as _i4;
import 'package:mealknight/views/pages/auth/register.page.dart' as _i5;
import 'package:mealknight/views/pages/cart/cart.page.dart' as _i16;
import 'package:mealknight/views/pages/checkout/checkout.page.dart' as _i17;
import 'package:mealknight/views/pages/delivery_address/delivery_addresses.page.dart'
as _i21;
import 'package:mealknight/views/pages/delivery_address/edit_delivery_addresses.page.dart'
as _i23;
import 'package:mealknight/views/pages/delivery_address/new_delivery_addresses.page.dart'
as _i22;
import 'package:mealknight/views/pages/favourite/favourites.page.dart' as _i24;
import 'package:mealknight/views/pages/home/home.page.dart' as _i10;
import 'package:mealknight/views/pages/notification/notification_details.page.dart'
as _i12;
import 'package:mealknight/views/pages/notification/notifications.page.dart'
as _i11;
import 'package:mealknight/views/pages/order/orders.page.dart' as _i18;
import 'package:mealknight/views/pages/order/orders_details.page.dart' as _i19;
import 'package:mealknight/views/pages/order/orders_tracking.page.dart' as _i26;
import 'package:mealknight/views/pages/product/product_details.page.dart'
as _i14;
import 'package:mealknight/views/pages/profile/change_password.page.dart'
as _i6;
import 'package:mealknight/views/pages/profile/edit_profile.page.dart' as _i8;
import 'package:mealknight/views/pages/search/search.page.dart' as _i15;
import 'package:mealknight/views/pages/splash.page.dart' as _i2;
import 'package:mealknight/views/pages/vendor/vendor.page.dart' as _i13;
import 'package:mealknight/views/pages/wallet/wallet.page.dart' as _i25;
import 'package:mealknight/views/pages/welcome/welcome.page.dart' as _i3;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i35;

class Routes {
  static const splashPage = '/';

  static const welcomePage = '/welcome-page';

  static const loginPage = '/login-page';

  static const registerPage = '/register-page';

  static const changePasswordPage = '/change-password-page';

  static const forgotPasswordPage = '/forgot-password-page';

  static const editProfilePage = '/edit-profile-page';

  static const homePage = '/home-page';

  static const notificationsPage = '/notifications-page';

  static const notificationDetailsPage = '/notification-details-page';

  static const vendorPage = '/vendor-page';

  static const productDetailsPage = '/product-details-page';

  static const searchPage = '/search-page';

  static const cartPage = '/cart-page';

  static const checkoutPage = '/checkout-page';

  static const ordersPage = '/orders-page';

  static const orderDetailsPage = '/order-details-page';

  static const firestoreChatPage = '/firestore-chat-page';

  static const deliveryAddressesPage = '/delivery-addresses-page';

  static const newDeliveryAddressesPage = '/new-delivery-addresses-page';

  static const editDeliveryAddressesPage = '/edit-delivery-addresses-page';

  static const favouritesPage = '/favourites-page';

  static const walletPage = '/wallet-page';

  static const orderTrackingPage = '/order-tracking-page';

  static const all = <String>{
    splashPage,
    welcomePage,
    loginPage,
    registerPage,
    changePasswordPage,
    forgotPasswordPage,
    editProfilePage,
    homePage,
    notificationsPage,
    notificationDetailsPage,
    vendorPage,
    productDetailsPage,
    searchPage,
    cartPage,
    checkoutPage,
    ordersPage,
    orderDetailsPage,
    firestoreChatPage,
    deliveryAddressesPage,
    newDeliveryAddressesPage,
    editDeliveryAddressesPage,
    favouritesPage,
    walletPage,
    orderTrackingPage,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.splashPage,
      page: _i2.SplashPage,
    ),
    _i1.RouteDef(
      Routes.welcomePage,
      page: _i3.WelcomePage,
    ),
    _i1.RouteDef(
      Routes.loginPage,
      page: _i4.LoginPage,
    ),
    _i1.RouteDef(
      Routes.registerPage,
      page: _i5.RegisterPage,
    ),
    _i1.RouteDef(
      Routes.changePasswordPage,
      page: _i6.ChangePasswordPage,
    ),
    _i1.RouteDef(
      Routes.forgotPasswordPage,
      page: _i7.ForgotPasswordPage,
    ),
    _i1.RouteDef(
      Routes.editProfilePage,
      page: _i8.EditProfilePage,
    ),
    _i1.RouteDef(
      Routes.homePage,
      page: _i10.HomePage,
    ),
    _i1.RouteDef(
      Routes.notificationsPage,
      page: _i11.NotificationsPage,
    ),
    _i1.RouteDef(
      Routes.notificationDetailsPage,
      page: _i12.NotificationDetailsPage,
    ),
    _i1.RouteDef(
      Routes.vendorPage,
      page: _i13.VendorPage,
    ),
    _i1.RouteDef(
      Routes.productDetailsPage,
      page: _i14.ProductDetailsPage,
    ),
    _i1.RouteDef(
      Routes.searchPage,
      page: _i15.SearchPage,
    ),
    _i1.RouteDef(
      Routes.cartPage,
      page: _i16.CartPage,
    ),
    _i1.RouteDef(
      Routes.checkoutPage,
      page: _i17.CheckoutPage,
    ),
    _i1.RouteDef(
      Routes.ordersPage,
      page: _i18.OrdersPage,
    ),
    _i1.RouteDef(
      Routes.orderDetailsPage,
      page: _i19.OrderDetailsPage,
    ),
    _i1.RouteDef(
      Routes.firestoreChatPage,
      page: _i20.FirestoreChatPage,
    ),
    _i1.RouteDef(
      Routes.deliveryAddressesPage,
      page: _i21.DeliveryAddressesPage,
    ),
    _i1.RouteDef(
      Routes.newDeliveryAddressesPage,
      page: _i22.NewDeliveryAddressesPage,
    ),
    _i1.RouteDef(
      Routes.editDeliveryAddressesPage,
      page: _i23.EditDeliveryAddressesPage,
    ),
    _i1.RouteDef(
      Routes.favouritesPage,
      page: _i24.FavouritesPage,
    ),
    _i1.RouteDef(
      Routes.walletPage,
      page: _i25.WalletPage,
    ),
    _i1.RouteDef(
      Routes.orderTrackingPage,
      page: _i26.OrderTrackingPage,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SplashPage(),
        settings: data,
      );
    },
    _i3.WelcomePage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.WelcomePage(),
        settings: data,
      );
    },
    _i4.LoginPage: (data) {
      final args = data.getArgs<LoginPageArguments>(
        orElse: () => const LoginPageArguments(),
      );
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i4.LoginPage(required: args.required, key: args.key),
        settings: data,
      );
    },
    _i5.RegisterPage: (data) {
      final args = data.getArgs<RegisterPageArguments>(
        orElse: () => const RegisterPageArguments(),
      );
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.RegisterPage(
            email: args.email,
            name: args.name,
            phone: args.phone,
            key: args.key),
        settings: data,
      );
    },
    _i6.ChangePasswordPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.ChangePasswordPage(),
        settings: data,
      );
    },
    _i7.ForgotPasswordPage: (data) {
      final args = data.getArgs<ForgotPasswordPageArguments>(
        orElse: () => const ForgotPasswordPageArguments(),
      );
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ForgotPasswordPage(key: args.key),
        settings: data,
      );
    },
    _i8.EditProfilePage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.EditProfilePage(),
        settings: data,
      );
    },
    _i10.HomePage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.HomePage(),
        settings: data,
      );
    },
    _i11.NotificationsPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.NotificationsPage(),
        settings: data,
      );
    },
    _i12.NotificationDetailsPage: (data) {
      final args =
      data.getArgs<NotificationDetailsPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.NotificationDetailsPage(
            notification: args.notification, key: args.key),
        settings: data,
      );
    },
    _i13.VendorPage: (data) {
      final args = data.getArgs<VendorPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i13.VendorPage(args.vendorType, key: args.key),
        settings: data,
      );
    },
    _i14.ProductDetailsPage: (data) {
      final args = data.getArgs<ProductDetailsPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i14.ProductDetailsPage(product: args.product, key: args.key),
        settings: data,
      );
    },
    _i15.SearchPage: (data) {
      final args = data.getArgs<SearchPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.SearchPage(
            key: args.key, search: args.search, showCancel: args.showCancel),
        settings: data,
      );
    },
    _i16.CartPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.CartPage(),
        settings: data,
      );
    },
    _i17.CheckoutPage: (data) {
      final args = data.getArgs<CheckoutPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i17.CheckoutPage(checkout: args.checkout, key: args.key),
        settings: data,
      );
    },
    _i18.OrdersPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.OrdersPage(),
        settings: data,
      );
    },
    _i19.OrderDetailsPage: (data) {
      final args = data.getArgs<OrderDetailsPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.OrderDetailsPage(
            order: args.order,
            isOrderTracking: args.isOrderTracking,
            key: args.key),
        settings: data,
      );
    },
    _i20.FirestoreChatPage: (data) {
      final args = data.getArgs<FirestoreChatPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i20.FirestoreChatPage(args.chatEntity, key: args.key),
        settings: data,
      );
    },
    _i21.DeliveryAddressesPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.DeliveryAddressesPage(),
        settings: data,
      );
    },
    _i22.NewDeliveryAddressesPage: (data) {
      final args = data.getArgs<NewDeliveryAddressesPageArguments>(
        orElse: () => const NewDeliveryAddressesPageArguments(),
      );
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i22.NewDeliveryAddressesPage(isFromRegister: args.isFromRegister),
        settings: data,
      );
    },
    _i23.EditDeliveryAddressesPage: (data) {
      final args = data.getArgs<EditDeliveryAddressesPageArguments>(
        orElse: () => const EditDeliveryAddressesPageArguments(),
      );
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => _i23.EditDeliveryAddressesPage(
            deliveryAddress: args.deliveryAddress, key: args.key),
        settings: data,
      );
    },
    _i24.FavouritesPage: (data) {
      final args = data.getArgs<FavouritesPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i24.FavouritesPage(key: args.key, vendorTypes: args.vendorTypes),
        settings: data,
      );
    },
    _i25.WalletPage: (data) {
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) => const _i25.WalletPage(),
        settings: data,
      );
    },
    _i26.OrderTrackingPage: (data) {
      final args = data.getArgs<OrderTrackingPageArguments>(nullOk: false);
      return _i27.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i26.OrderTrackingPage(order: args.order, key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class LoginPageArguments {
  const LoginPageArguments({
    this.required = false,
    this.key,
  });

  final bool required;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"required": "$required", "key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginPageArguments other) {
    if (identical(this, other)) return true;
    return other.required == required && other.key == key;
  }

  @override
  int get hashCode {
    return required.hashCode ^ key.hashCode;
  }
}

class RegisterPageArguments {
  const RegisterPageArguments({
    this.email,
    this.name,
    this.phone,
    this.key,
  });

  final String? email;

  final String? name;

  final String? phone;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"email": "$email", "name": "$name", "phone": "$phone", "key": "$key"}';
  }

  @override
  bool operator ==(covariant RegisterPageArguments other) {
    if (identical(this, other)) return true;
    return other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.key == key;
  }

  @override
  int get hashCode {
    return email.hashCode ^ name.hashCode ^ phone.hashCode ^ key.hashCode;
  }
}

class ForgotPasswordPageArguments {
  const ForgotPasswordPageArguments({this.key});

  final _i27.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ForgotPasswordPageArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LocationFetchPageArguments {
  const LocationFetchPageArguments({
    required this.child,
    this.key,
  });

  final _i27.Widget child;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"child": "$child", "key": "$key"}';
  }

  @override
  bool operator ==(covariant LocationFetchPageArguments other) {
    if (identical(this, other)) return true;
    return other.child == child && other.key == key;
  }

  @override
  int get hashCode {
    return child.hashCode ^ key.hashCode;
  }
}

class NotificationDetailsPageArguments {
  const NotificationDetailsPageArguments({
    required this.notification,
    this.key,
  });

  final _i28.NotificationModel notification;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"notification": "$notification", "key": "$key"}';
  }

  @override
  bool operator ==(covariant NotificationDetailsPageArguments other) {
    if (identical(this, other)) return true;
    return other.notification == notification && other.key == key;
  }

  @override
  int get hashCode {
    return notification.hashCode ^ key.hashCode;
  }
}

class VendorPageArguments {
  const VendorPageArguments({
    required this.vendorType,
    this.key,
  });

  final _i29.VendorType vendorType;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"vendorType": "$vendorType", "key": "$key"}';
  }

  @override
  bool operator ==(covariant VendorPageArguments other) {
    if (identical(this, other)) return true;
    return other.vendorType == vendorType && other.key == key;
  }

  @override
  int get hashCode {
    return vendorType.hashCode ^ key.hashCode;
  }
}

class ProductDetailsPageArguments {
  const ProductDetailsPageArguments({
    required this.product,
    this.key,
  });

  final _i30.Product? product;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"product": "$product", "key": "$key"}';
  }

  @override
  bool operator ==(covariant ProductDetailsPageArguments other) {
    if (identical(this, other)) return true;
    return other.product == product && other.key == key;
  }

  @override
  int get hashCode {
    return product.hashCode ^ key.hashCode;
  }
}

class SearchPageArguments {
  const SearchPageArguments({
    this.key,
    required this.search,
    this.showCancel = true,
  });

  final _i27.Key? key;

  final _i31.Search search;

  final bool showCancel;

  @override
  String toString() {
    return '{"key": "$key", "search": "$search", "showCancel": "$showCancel"}';
  }

  @override
  bool operator ==(covariant SearchPageArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.search == search &&
        other.showCancel == showCancel;
  }

  @override
  int get hashCode {
    return key.hashCode ^ search.hashCode ^ showCancel.hashCode;
  }
}

class CheckoutPageArguments {
  const CheckoutPageArguments({
    required this.checkout,
    this.key,
  });

  final _i32.CheckOut checkout;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"checkout": "$checkout", "key": "$key"}';
  }

  @override
  bool operator ==(covariant CheckoutPageArguments other) {
    if (identical(this, other)) return true;
    return other.checkout == checkout && other.key == key;
  }

  @override
  int get hashCode {
    return checkout.hashCode ^ key.hashCode;
  }
}

class OrderDetailsPageArguments {
  const OrderDetailsPageArguments({
    required this.order,
    this.isOrderTracking = false,
    this.key,
  });

  final _i33.Order order;

  final bool isOrderTracking;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"order": "$order", "isOrderTracking": "$isOrderTracking", "key": "$key"}';
  }

  @override
  bool operator ==(covariant OrderDetailsPageArguments other) {
    if (identical(this, other)) return true;
    return other.order == order &&
        other.isOrderTracking == isOrderTracking &&
        other.key == key;
  }

  @override
  int get hashCode {
    return order.hashCode ^ isOrderTracking.hashCode ^ key.hashCode;
  }
}

class FirestoreChatPageArguments {
  const FirestoreChatPageArguments({
    required this.chatEntity,
    this.key,
  });

  final _i34.ChatEntity chatEntity;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"chatEntity": "$chatEntity", "key": "$key"}';
  }

  @override
  bool operator ==(covariant FirestoreChatPageArguments other) {
    if (identical(this, other)) return true;
    return other.chatEntity == chatEntity && other.key == key;
  }

  @override
  int get hashCode {
    return chatEntity.hashCode ^ key.hashCode;
  }
}

class NewDeliveryAddressesPageArguments {
  const NewDeliveryAddressesPageArguments({this.isFromRegister});

  final bool? isFromRegister;

  @override
  String toString() {
    return '{"isFromRegister": "$isFromRegister"}';
  }

  @override
  bool operator ==(covariant NewDeliveryAddressesPageArguments other) {
    if (identical(this, other)) return true;
    return other.isFromRegister == isFromRegister;
  }

  @override
  int get hashCode {
    return isFromRegister.hashCode;
  }
}

class EditDeliveryAddressesPageArguments {
  const EditDeliveryAddressesPageArguments({
    this.deliveryAddress,
    this.key,
  });

  final dynamic deliveryAddress;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"deliveryAddress": "$deliveryAddress", "key": "$key"}';
  }

  @override
  bool operator ==(covariant EditDeliveryAddressesPageArguments other) {
    if (identical(this, other)) return true;
    return other.deliveryAddress == deliveryAddress && other.key == key;
  }

  @override
  int get hashCode {
    return deliveryAddress.hashCode ^ key.hashCode;
  }
}

class FavouritesPageArguments {
  const FavouritesPageArguments({
    this.key,
    required this.vendorTypes,
  });

  final _i27.Key? key;

  final List<_i29.VendorType> vendorTypes;

  @override
  String toString() {
    return '{"key": "$key", "vendorTypes": "$vendorTypes"}';
  }

  @override
  bool operator ==(covariant FavouritesPageArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.vendorTypes == vendorTypes;
  }

  @override
  int get hashCode {
    return key.hashCode ^ vendorTypes.hashCode;
  }
}

class OrderTrackingPageArguments {
  const OrderTrackingPageArguments({
    required this.order,
    this.key,
  });

  final _i33.Order order;

  final _i27.Key? key;

  @override
  String toString() {
    return '{"order": "$order", "key": "$key"}';
  }

  @override
  bool operator ==(covariant OrderTrackingPageArguments other) {
    if (identical(this, other)) return true;
    return other.order == order && other.key == key;
  }

  @override
  int get hashCode {
    return order.hashCode ^ key.hashCode;
  }
}

extension NavigatorStateExtension on _i35.NavigationService {
  Future<dynamic> navigateToSplashPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWelcomePage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.welcomePage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginPage({
    bool required = false,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginPage,
        arguments: LoginPageArguments(required: required, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterPage({
    String? email,
    String? name,
    String? phone,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.registerPage,
        arguments: RegisterPageArguments(
            email: email, name: name, phone: phone, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChangePasswordPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.changePasswordPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotPasswordPage({
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.forgotPasswordPage,
        arguments: ForgotPasswordPageArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEditProfilePage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.editProfilePage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomePage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homePage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNotificationsPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.notificationsPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNotificationDetailsPage({
    required _i28.NotificationModel notification,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.notificationDetailsPage,
        arguments: NotificationDetailsPageArguments(
            notification: notification, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVendorPage({
    required _i29.VendorType vendorType,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.vendorPage,
        arguments: VendorPageArguments(vendorType: vendorType, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProductDetailsPage({
    required _i30.Product? product,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.productDetailsPage,
        arguments: ProductDetailsPageArguments(product: product, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchPage({
    _i27.Key? key,
    required _i31.Search search,
    bool showCancel = true,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.searchPage,
        arguments: SearchPageArguments(
            key: key, search: search, showCancel: showCancel),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.cartPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCheckoutPage({
    required _i32.CheckOut checkout,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.checkoutPage,
        arguments: CheckoutPageArguments(checkout: checkout, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrdersPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.ordersPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderDetailsPage({
    required _i33.Order order,
    bool isOrderTracking = false,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderDetailsPage,
        arguments: OrderDetailsPageArguments(
            order: order, isOrderTracking: isOrderTracking, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFirestoreChatPage({
    required _i34.ChatEntity chatEntity,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.firestoreChatPage,
        arguments: FirestoreChatPageArguments(chatEntity: chatEntity, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDeliveryAddressesPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.deliveryAddressesPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewDeliveryAddressesPage({
    bool? isFromRegister,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.newDeliveryAddressesPage,
        arguments:
        NewDeliveryAddressesPageArguments(isFromRegister: isFromRegister),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEditDeliveryAddressesPage({
    dynamic deliveryAddress,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.editDeliveryAddressesPage,
        arguments: EditDeliveryAddressesPageArguments(
            deliveryAddress: deliveryAddress, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFavouritesPage({
    _i27.Key? key,
    required List<_i29.VendorType> vendorTypes,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.favouritesPage,
        arguments: FavouritesPageArguments(key: key, vendorTypes: vendorTypes),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWalletPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return navigateTo<dynamic>(Routes.walletPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderTrackingPage({
    required _i33.Order order,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderTrackingPage,
        arguments: OrderTrackingPageArguments(order: order, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWelcomePage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.welcomePage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginPage({
    bool required = false,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginPage,
        arguments: LoginPageArguments(required: required, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterPage({
    String? email,
    String? name,
    String? phone,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.registerPage,
        arguments: RegisterPageArguments(
            email: email, name: name, phone: phone, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChangePasswordPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.changePasswordPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotPasswordPage({
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.forgotPasswordPage,
        arguments: ForgotPasswordPageArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEditProfilePage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.editProfilePage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomePage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homePage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNotificationsPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.notificationsPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNotificationDetailsPage({
    required _i28.NotificationModel notification,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.notificationDetailsPage,
        arguments: NotificationDetailsPageArguments(
            notification: notification, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithVendorPage({
    required _i29.VendorType vendorType,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.vendorPage,
        arguments: VendorPageArguments(vendorType: vendorType, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProductDetailsPage({
    required _i30.Product? product,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.productDetailsPage,
        arguments: ProductDetailsPageArguments(product: product, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSearchPage({
    _i27.Key? key,
    required _i31.Search search,
    bool showCancel = true,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.searchPage,
        arguments: SearchPageArguments(
            key: key, search: search, showCancel: showCancel),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.cartPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCheckoutPage({
    required _i32.CheckOut checkout,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.checkoutPage,
        arguments: CheckoutPageArguments(checkout: checkout, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrdersPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.ordersPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderDetailsPage({
    required _i33.Order order,
    bool isOrderTracking = false,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderDetailsPage,
        arguments: OrderDetailsPageArguments(
            order: order, isOrderTracking: isOrderTracking, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFirestoreChatPage({
    required _i34.ChatEntity chatEntity,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.firestoreChatPage,
        arguments: FirestoreChatPageArguments(chatEntity: chatEntity, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDeliveryAddressesPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.deliveryAddressesPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewDeliveryAddressesPage({
    bool? isFromRegister,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.newDeliveryAddressesPage,
        arguments:
        NewDeliveryAddressesPageArguments(isFromRegister: isFromRegister),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEditDeliveryAddressesPage({
    dynamic deliveryAddress,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.editDeliveryAddressesPage,
        arguments: EditDeliveryAddressesPageArguments(
            deliveryAddress: deliveryAddress, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFavouritesPage({
    _i27.Key? key,
    required List<_i29.VendorType> vendorTypes,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.favouritesPage,
        arguments: FavouritesPageArguments(key: key, vendorTypes: vendorTypes),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWalletPage([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  ]) async {
    return replaceWith<dynamic>(Routes.walletPage,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderTrackingPage({
    required _i33.Order order,
    _i27.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderTrackingPage,
        arguments: OrderTrackingPageArguments(order: order, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
