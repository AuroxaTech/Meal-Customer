import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mealknight/constants/api.dart';
import 'package:mealknight/constants/app_dynamic_link.dart';
import 'package:mealknight/constants/app_map_settings.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/cart.dart';
import 'package:mealknight/models/delivery_address.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/models/service.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/services/cart.service.dart';
import 'package:mealknight/services/cart_ui.service.dart';
import 'package:mealknight/services/geocoder.service.dart';
import 'package:mealknight/services/local_storage.service.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/services/navigation.service.dart';
import 'package:mealknight/utils/utils.dart';
import 'package:mealknight/view_models/payment.view_model.dart';
import 'package:mealknight/views/pages/auth/login.page.dart';
import 'package:mealknight/views/pages/service/service_details.page.dart';
import 'package:mealknight/views/pages/vendor/vendor_reviews.page.dart';
import 'package:mealknight/views/shared/ops_map.page.dart';
import 'package:mealknight/widgets/bottomsheets/delivery_address_picker.bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../requests/delivery_address.request.dart';
import 'vendor_distance.vm.dart';

class MyBaseViewModel extends BaseViewModel {
  late BuildContext viewContext;
  GlobalKey pageKey = GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  final formBuilderKey = GlobalKey<FormBuilderState>();
  GlobalKey genKey = GlobalKey();
  final currencySymbol = AppStrings.currencySymbol;
  DeliveryAddress? deliveryaddress = DeliveryAddress();
  String? firebaseVerificationId;
  VendorType? vendorType;
  Vendor? vendor;
  RefreshController refreshController = RefreshController();

  void initialise() {}

  void reloadPage() {
    pageKey = GlobalKey<State>();
    refreshController = RefreshController();
    notifyListeners();
    initialise();
  }

  openWebpageLink(String url) async {
    PaymentViewModel paymentViewModel = PaymentViewModel();
    paymentViewModel.viewContext = viewContext;
    await paymentViewModel.openWebpageLink(url);
  }

  //
  //open delivery address picker
  void pickDeliveryAddress({
    bool vendorCheckRequired = true,
    Function? onselected,
  }) {
    //
    showModalBottomSheet(
      context: viewContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DeliveryAddressPicker(
          vendorCheckRequired: vendorCheckRequired,
          allowOnMap: true,
          onSelectDeliveryAddress: (mDeliveryaddress) {
            print("called here");
            Navigator.of(viewContext).pop();
            deliveryaddress = mDeliveryaddress;
            notifyListeners();

            //
            final address = Address(
              coordinates: Coordinates(
                deliveryaddress?.latitude ?? 0.00,
                deliveryaddress?.longitude ?? 0.00,
              ),
              addressLine: deliveryaddress?.address,
            );
            //
            LocationService.currenctAddress = address;
            //
            LocationService.currenctAddressSubject.sink.add(address);

            //
            if (onselected != null) onselected();
          },
        );
      },
    );
  }

  //
  bool isAuthenticated() {
    return AuthServices.authenticated();
  }

  //
  void openLogin() async {
    print('LoginPage  ============= openLogin');
    viewContext.nextPage(LoginPage());
    notifyListeners();
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  //
  //
  Future<DeliveryAddress?> showDeliveryAddressPicker() async {
    //
    DeliveryAddress? selectedDeliveryAddress;

    //
    await showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeliveryAddressPicker(
          onSelectDeliveryAddress: (deliveryAddress) {
            Navigator.of(viewContext).pop();
            selectedDeliveryAddress = deliveryAddress;
          },
        );
      },
    );

    return selectedDeliveryAddress;
  }

  //
  Future<DeliveryAddress> getLocationCityName(
      DeliveryAddress deliveryAddress) async {
    final coordinates = Coordinates(
      deliveryAddress.latitude ?? 0.00,
      deliveryAddress.longitude ?? 0.00,
    );
    final addresses = await GeocoderService().findAddressesFromCoordinates(
      coordinates,
    );
    //loop through the addresses and get data
    for (var address in addresses) {
      //address
      deliveryAddress.address ??= address.addressLine;
      //name
      deliveryAddress.name ??= address.featureName;
      if (deliveryAddress.name == null || deliveryAddress.name!.isEmpty) {
        deliveryAddress.name = address.addressLine;
      }
      //city
      deliveryAddress.city ??= address.locality;
      if (deliveryAddress.city == null || deliveryAddress.city!.isEmpty) {
        deliveryAddress.city = address.subLocality;
      }
      //state
      deliveryAddress.state ??= address.adminArea;
      if (deliveryAddress.state == null || deliveryAddress.state!.isEmpty) {
        deliveryAddress.state = address.subAdminArea;
      }
      //country
      deliveryAddress.country ??= address.countryName;

      //break if all data is set
      if (deliveryAddress.address != null &&
          deliveryAddress.city != null &&
          deliveryAddress.state != null &&
          deliveryAddress.country != null) {
        break;
      }
    }
    //
    // deliveryAddress.city = addresses.first.locality;
    // deliveryAddress.state = addresses.first.adminArea;
    // deliveryAddress.country = addresses.first.countryName;
    return deliveryAddress;
  }

  addToCartDirectly(Product product, int qty, {bool force = false}) async {
    //
    if (qty <= 0) {
      //
      final mProductsInCart = CartServices.productsInCart;
      final previousProductIndex = mProductsInCart.indexWhere(
        (e) => e.product?.id == product.id,
      );
      //
      if (previousProductIndex >= 0) {
        mProductsInCart.removeAt(previousProductIndex);
        await CartServices.saveCartItems(mProductsInCart);
      }
      return;
    }
    //
    final cart = Cart();
    cart.price = (product.showDiscount ? product.discountPrice : product.price);
    product.selectedQty = qty;
    cart.product = product;
    cart.selectedQty = product.selectedQty;
    cart.options = product.selectedOptions ?? [];
    cart.optionsIds = product.selectedOptions!.map((e) => e.id).toList();

    //

    try {
      //
      bool canAddToCart = await CartUIServices.handleCartEntry(
        viewContext,
        cart,
        product,
      );

      if (canAddToCart || force) {
        //
        final mProductsInCart = CartServices.productsInCart;
        final previousProductIndex = mProductsInCart.indexWhere(
          (e) => e.product?.id == product.id,
        );
        //
        if (previousProductIndex >= 0) {
          mProductsInCart.removeAt(previousProductIndex);
          mProductsInCart.insert(previousProductIndex, cart);
          await CartServices.saveCartItems(mProductsInCart);
        } else {
          await CartServices.addToCart(cart);
        }
      } else if (product.isDigital) {
        //
        CoolAlert.show(
          context: viewContext,
          title: "Digital Product".tr(),
          text:
              "You can only buy/purchase digital products together with other digital products. Do you want to clear cart and add this product?"
                  .tr(),
          type: CoolAlertType.confirm,
          onConfirmBtnTap: () async {
            //
            Navigator.of(viewContext).pop();
            await CartServices.clearCart();
            addToCartDirectly(product, qty, force: true);
          },
        );
      } else {
        //
        CoolAlert.show(
          context: viewContext,
          title: "Different Vendor".tr(),
          text:
              "Are you sure you'd like to change vendors? Your current items in cart will be lost."
                  .tr(),
          type: CoolAlertType.confirm,
          onConfirmBtnTap: () async {
            //
            Navigator.of(viewContext).pop();
            await CartServices.clearCart();
            addToCartDirectly(product, qty, force: true);
          },
        );
      }
    } catch (error) {
      print("Cart Error 111=> $error");
      setError(error);
    }
  }

  //switch to use current location instead of selected delivery address
  void useUserLocation() {
    LocationService.geocodeCurrentLocation();
  }

  //
  openSearch({required String type, int showType = 4}) async {
    final search = Search(
      type: type,
      vendorType: vendorType,
      showType: showType,
    );
    final page = NavigationService().searchPageWidget(search);
    viewContext.nextPage(page);
  }

  openCart() async {
    Navigator.pushNamed(viewContext, AppRoutes.cartRoute);
  }

  //
  //
  productSelected(Product product) async {
    Navigator.pushNamed(
      viewContext,
      AppRoutes.product,
      arguments: product,
    );
  }

  servicePressed(Service service) async {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => ServiceDetailsPage(service)));
  }

  openVendorReviews() {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => VendorReviewsPage(vendor!)));
  }

  //show toast
  toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  toastError(String msg, {Toast? length}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> fetchCurrentLocation() async {
    try {
      List<DeliveryAddress> deliveryAddresses = [];
      bool flag = false;
      DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
      deliveryAddresses = await deliveryAddressRequest.getDeliveryAddresses();
      if (deliveryAddresses.isNotEmpty) {
        for (DeliveryAddress address in deliveryAddresses) {
          if (address.isDefault == 1) {
            flag = true;
            deliveryaddress = address;
          }
        }
      }
      if (!flag && deliveryAddresses.isNotEmpty) {
        flag = true;
        deliveryaddress = deliveryAddresses.first;
      }

      if (!flag) {
        Position currentLocation = await Geolocator.getCurrentPosition();
        //
        final address = await LocationService.addressFromCoordinates(
          lat: currentLocation.latitude,
          lng: currentLocation.longitude,
        );
        //
        LocationService.currenctAddress = address;
        if (address != null) {
          LocationService.currenctAddressSubject.sink.add(address);
        }
        deliveryaddress ??= DeliveryAddress();
        deliveryaddress!.address = address?.addressLine;
        deliveryaddress!.latitude = address?.coordinates?.latitude;
        deliveryaddress!.longitude = address?.coordinates?.longitude;
        deliveryaddress!.name = "Current Location".tr();
      }
      LocationService.deliveryaddress = deliveryaddress;
      final storagePref = await LocalStorageService.getPrefs();
      await storagePref.setString(
          "current_address", deliveryaddress?.address ?? '');

      VendorDistanceViewModel()
          .updateDeliveryAddress(deliveryaddress?.address ?? '');

      clearErrors();
    } catch (error) {
      setError(error);
    }
  }

  // NEW LOCATION PICKER
  Future<dynamic> newPlacePicker() async {
    //
    LatLng initialPosition = const LatLng(0.00, 0.00);
    double initialZoom = 0;
    if (LocationService.currenctAddress != null) {
      initialPosition = LatLng(
        LocationService.currenctAddress?.coordinates?.latitude ?? 0.00,
        LocationService.currenctAddress?.coordinates?.longitude ?? 0.00,
      );
      initialZoom = 90;
    }
    String? mapRegion;
    try {
      mapRegion = await Utils.getCurrentCountryCode();
    } catch (error) {
      print("Error getting sim country code => $error");
    }
    mapRegion ??= AppStrings.countryCode.trim().split(",").firstWhere(
      (e) => !e.toLowerCase().contains("auto"),
      orElse: () {
        return "";
      },
    );

    //
    if (!AppMapSettings.useGoogleOnApp) {
      return await Navigator.push(
          viewContext,
          MaterialPageRoute(
              builder: (context) => OPSMapPage(
                    region: mapRegion,
                    initialPosition: initialPosition,
                    useCurrentLocation: true,
                    initialZoom: initialZoom,
                  )));
    }
    //google maps
    return await Navigator.push(
      viewContext,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: AppStrings.googleMapApiKey,
          autocompleteLanguage: LocalizeAndTranslate.getLocale().languageCode,
          region: mapRegion,
          onPlacePicked: (result) {
            Navigator.of(context).pop(result);
          },
          initialPosition: initialPosition,
        ),
      ),
    );
  }

  //share
  shareProduct(Product product) async {
    setBusyForObject(shareProduct, true);
    String link = "${Api.appShareLink}/product/${product.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IOSParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
    await Share.share(shareLink);
    setBusyForObject(shareProduct, false);
  }

  shareVendor(Vendor vendor) async {
    setBusyForObject(shareVendor, true);
    String link = "${Api.appShareLink}/vendor/${vendor.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IOSParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
    await Share.share(shareLink);
    setBusyForObject(shareVendor, false);
  }

  shareService(Service service) async {
    //
    setBusyForObject(shareService, true);
    String link = "${Api.appShareLink}/service/${service.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IOSParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
    await Share.share(shareLink);
    setBusyForObject(shareService, false);
  }
}
