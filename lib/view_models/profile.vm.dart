import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:custom_faqs/custom_faqs.dart';
import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_ui_settings.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:mealknight/models/profile_list_model.dart';
import 'package:mealknight/resources/resources.dart';
import 'package:mealknight/view_models/payment.view_model.dart';
import 'package:mealknight/views/pages/loyalty/loyalty_point.page.dart';
import 'package:mealknight/views/pages/order/orders.page.dart';
import 'package:mealknight/views/pages/payment/payment_screen.dart';
import 'package:mealknight/views/pages/profile/account_delete.page.dart';
import 'package:mealknight/views/pages/splash.page.dart';
import 'package:mealknight/constants/api.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/requests/auth.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/widgets/bottomsheets/referral.bottomsheet.dart';
import 'package:mealknight/widgets/cards/language_selector.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/pages/help_type/help_type.page.dart';
import '../views/pages/profile/widget/language_selector_profile.dart';

class ProfileViewModel extends PaymentViewModel {
  //
  String appVersionInfo = "";
  bool authenticated = false;
  User? currentUser;

  //
  final AuthRequest _authRequest = AuthRequest();
  StreamSubscription? authStateListenerStream;

  List<ProfileListModel> profileList = [];

  ProfileViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    authenticated = await AuthServices.authenticated();
    if (authenticated) {
      currentUser = await AuthServices.getCurrentUser(force: true);
    } else {
      listenToAuthChange();
    }
    notifyListeners();

    profileList = [
      ProfileListModel(
          name: "Wallet".tr(),
          onTap: authenticated ? openWallet : openLogin,
          photo: AppIcons.wallet,
          visible: AppUISettings.allowWallet),
      ProfileListModel(
          name: "Promos".tr(),
          onTap: () {},
          photo: AppIcons.promo,
          visible: true),
      ProfileListModel(
          name: "Orders".tr(),
          onTap: authenticated ? myOrder : openLogin,
          photo: AppIcons.checkListIcon,
          visible: true),
      ProfileListModel(
          name: "Settings".tr(),
          onTap: authenticated ? openChangePassword : openLogin,
          photo: AppIcons.settingsIcon,
          visible: true),
      ProfileListModel(
          name: "Address".tr(),
          onTap: authenticated ? openDeliveryAddresses : openLogin,
          photo: AppIcons.homeAddress,
          visible: true),
      ProfileListModel(
          name: "Payments".tr(),
          onTap: authenticated ? openPayment : openLogin,
          photo: AppIcons.paymentIcon,
          visible: true),
      ProfileListModel(
          name: "About".tr(),
          onTap: openContactUs,
          photo: AppIcons.communicate,
          visible: true),
      ProfileListModel(
          name: "Referral".tr(),
          onTap: authenticated ? openRefer : openLogin,
          photo: AppIcons.referIcon,
          visible: true),
      ProfileListModel(
          name: "Help".tr(),
          onTap: openHelp,
          photo: AppIcons.livesupport,
          visible: true),
    ];
  }

  dispose() {
    super.dispose();
    authStateListenerStream?.cancel();
  }

  listenToAuthChange() {
    authStateListenerStream?.cancel();
    authStateListenerStream =
        AuthServices.listenToAuthState().listen((event) async {
      if (event != null && event) {
        authenticated = event;
        currentUser = await AuthServices.getCurrentUser(force: true);
        notifyListeners();
        authStateListenerStream?.cancel();
      }
    });
  }

  /**
   * Edit Profile
   */

  openEditProfile() async {
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.editProfileRoute,
    );

    if (result != null && result is bool && result) {
      initialise();
    }
  }

  openSetting() async {
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.editProfileRoute,
    );

    if (result != null && result is bool && result) {
      initialise();
    }
  }

  /**
   * Change Password
   */

  openChangePassword() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.changePasswordRoute,
    );
  }

  openLanguages() async {
    await showModalBottomSheet(
      context: viewContext,
      builder: (context) {
        return AppLanguageSelectorProfile();
      },
    );
  }

//
  openRefer() async {
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReferralBottomsheet(this),
    );
  }

  //
  openLoyaltyPoint() {
    viewContext.nextPage(LoyaltyPointPage());
  }

  void openWallet() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.walletRoute,
    );
  }

  /**
   * Delivery addresses
   */
  openDeliveryAddresses() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.deliveryAddressesRoute,
    );
  }

  openPayment() {
    Navigator.push(
      viewContext,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  myOrder() {
    Navigator.of(viewContext)
        .push(MaterialPageRoute(builder: (context) => OrdersPage()));
  }

  /**
   * Logout
   */
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      onConfirmBtnTap: () {
        Navigator.of(viewContext).pop();
        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.loading,
      title: "Logout".tr(),
      text: "Logging out Please wait...".tr(),
      barrierDismissible: false,
    );

    //
    final apiResponse = await _authRequest.logoutRequest();

    //
    Navigator.of(viewContext).pop();

    if (!apiResponse.allGood && apiResponse.code != 401) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Logout".tr(),
        text: apiResponse.message,
      );
    } else {
      //
      await AuthServices.logout();
      Navigator.of(viewContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openNotification() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.notificationsRoute,
    );
  }

  /**
   * App Rating & Review
   */
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (Platform.isAndroid) {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    } else if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    openWebpageLink(url);
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  openFaqs() {
    viewContext.nextPage(
      CustomFaqPage(
        title: 'Faqs'.tr(),
        link: Api.baseUrl + Api.faqs,
      ),
    );
  }

  //
  openContactUs() async {
    final url = Api.contactUs;
    openWebpageLink(url);
  }

  openHelp() async {
    viewContext.nextPage(
      HelpTypePage(),
    );
  }

  openLivesupport() async {
    final url = Api.inappSupport;
    openWebpageLink(url);
  }

  //
  changeLanguage() async {
    final result = await showModalBottomSheet(
      context: viewContext,
      builder: (context) {
        return const AppLanguageSelector();
      },
    );

    //
    if (result != null) {
      //pop all screen and open splash screen
      Navigator.of(viewContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openLogin() async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.loginRoute,
    );
    //
    initialise();
  }

  void shareReferralCode() {
    Share.share(
      "${"%s is inviting you to join %s via this referral code: %s".tr().fill(
        [
          currentUser!.name,
          AppStrings.appName,
          currentUser!.code,
        ],
      )}\n${AppStrings.androidDownloadLink}\n${AppStrings.iOSDownloadLink}\n",
    );
  }

  //
  deleteAccount() {
    viewContext.nextPage(const AccountDeletePage());
  }
}
