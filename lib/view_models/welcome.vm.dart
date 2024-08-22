import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mealknight/models/user.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/vendor_type.request.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/view_models/base.view_model.dart';

class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  Widget? selectedPage;
  List<VendorType> vendorTypes = [];
  VendorTypeRequest vendorTypeRequest = VendorTypeRequest();
  bool showGrid = true;
  StreamSubscription? authStateSub;
  int tabIconIndexSelected = 0;
  bool authenticated = false;
  User? currentUser;

  //String? currentAddress;

  //
  //
  initialise({bool initial = true}) async {
    setBusy(true);
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }

    if (!initial) {
      pageKey = GlobalKey();
      notifyListeners();
    }

    await getVendorTypes();
    setBusy(false);
    authenticated = await AuthServices.authenticated();
    if (authenticated) {
      currentUser = await AuthServices.getCurrentUser(force: true);
    } else {
      listenToAuth();
    }
    fetchCurrentLocation().then((value) {
      //updateAddress();
      getVendorTypes();
    });
  }

  /*updateAddress() async {
    final storagePref = await LocalStorageService.getPrefs();
    currentAddress = storagePref.getString("current_address");
    notifyListeners();
  }*/

  listenToAuth() {
    authStateSub = AuthServices.listenToAuthState().listen((event) {
      genKey = GlobalKey();
      notifyListeners();
    });
  }

  getVendorTypes() async {
    try {
      vendorTypes = await vendorTypeRequest.index();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    notifyListeners();
  }
}
