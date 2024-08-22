import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_routes.dart';
import 'package:mealknight/models/menu.dart';
import 'package:mealknight/models/vendor.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/requests/product.request.dart';
import 'package:mealknight/requests/vendor.request.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:mealknight/views/pages/vendor_search/vendor_search.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../models/cart.dart';
import '../services/cart.service.dart';
import '../services/local_storage.service.dart';
import 'vendor_details.vm.dart';

class VendorDetailsWithMenuViewModel extends VendorDetailsViewModel {
  //
  VendorDetailsWithMenuViewModel(
    BuildContext context,
    this.vendor, {
    required this.tickerProvider,
  }) : super(context, vendor) {
    this.viewContext = context;
  }

  VendorRequest _vendorRequest = VendorRequest();
  CartServices cartServices = CartServices();

  Vendor? vendor;
  TickerProvider? tickerProvider;
  TabController? tabBarController;
  final currencySymbol = AppStrings.currencySymbol;
  int tabTextIndexSelected = 0;
  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};
  String selectedTabName = "All";
  int index = 0;

  void getVendorDetails() async {
    //
    setBusy(true);
    try {
      vendor = await _vendorRequest.vendorDetails(
        vendor!.id,
        params: {
          "type": "small",
        },
      );

      print("vendor menus ==> ${vendor!.menus.length}");
      //empty menu
      vendor!.menus.insert(
        0,
        Menu.fromJson(
          {
            "id": 0,
            "name": "All".tr(),
          },
        ),
      );

      getCartItems(false);
      updateUiComponents();
      clearErrors();
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }
    setBusy(false);
  }

  //
  updateUiComponents() {
    // Listen to tab index changes from external sources via this stream

    //
    if (!vendor!.hasSubcategories) {
      tabBarController = TabController(
          length: vendor!.menus.length,
          vsync: tickerProvider!,
          initialIndex: index);
// selectedTabName = menu.name;
      //
      loadMenuProduts();
      tabBarController?.addListener(_handleTabChange);
    } else {
      //nothing to do yet
    }
  }

  getCartItems(bool flag) async {
    final cartList = await LocalStorageService.prefs!.getString(
      CartServices.cartItemsKey,
    );

    if (cartList != null && cartList.isNotEmpty) {
      try {
        CartServices.productsInCart =
            (jsonDecode(cartList) as List).map((cartObject) {
          return Cart.fromJson(cartObject);
        }).toList();
        notifyListeners();
      } catch (error) {
        CartServices.productsInCart = [];
        if (flag) getVendorDetails();
      }
      if (flag && CartServices.productsInCart.isEmpty) {
        getVendorDetails();
      }
    } else {
      CartServices.productsInCart = [];
      if (flag) getVendorDetails();
      notifyListeners();
    }
    notifyListeners();
//    cartItemsCountStream.add(productsInCart.length);
  }

  getUpdateItem(Product addItem) async {
    //
    final cartList = await LocalStorageService.prefs!.getString(
      CartServices.cartItemsKey,
    );

    if (cartList != null) {
      try {
        CartServices.productsInCart =
            (jsonDecode(cartList) as List).map((cartObject) {
          return Cart.fromJson(cartObject);
        }).toList();

        int currentItemIndex = 0;
        bool flag = false;
        if (CartServices.productsInCart.isNotEmpty) {
          for (int i = 0; i < CartServices.productsInCart.length; i++) {
            if (addItem.id == CartServices.productsInCart[i].product!.id) {
              currentItemIndex = i;
              flag = true;
              notifyListeners();
            }
          }
          notifyListeners();
          if (flag) {
            CartServices.productsInCart[currentItemIndex].selectedQty =
                addItem.selectedQty;
            CartServices.productsInCart[currentItemIndex].product!.selectedQty =
                addItem.selectedQty;
            notifyListeners();
          }
          //CartServices.productsInCart.forEach((element) async {
          //   print('productsInCart 000===${addItem.selectedQty}=======${addItem.id}======${element.product!.id}');
          //   ///
          //   if(addItem.id == element.product!.id) {
          //     final canAdd = await CartUIServices.cartItemQtyUpdated(
          //       viewContext,
          //       addItem.selectedQty,
          //       element,
          //     );
          //     //
          //     if (!canAdd) {
          //       print(
          //           "updateCartItemQuantity ================================canAdd==$canAdd");
          //       addItem.selectedQty = element.selectedQty ?? 1;
          //       pageKey = GlobalKey<State>();
          //       notifyListeners();
          //       return;
          //     }
          //     element.selectedQty = addItem.selectedQty;
          //   }
          // });

          await CartServices.saveCartItems(CartServices.productsInCart);

          notifyListeners();
        }
      } catch (error) {
        CartServices.productsInCart = [];
      }
    } else {
      CartServices.productsInCart = [];
    }
//    cartItemsCountStream.add(productsInCart.length);
  }

  void _handleTabChange() {
    try {
      index = tabBarController!.index;
      selectedTabName = vendor!.menus[index].name;
      notifyListeners();
    } catch (E) {}
  }

  Future<Object> productSelected(Product product) async {
    //update delivery type for this particular product
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );

    notifyListeners();
    return result ?? false;
  }

  void uploadPrescription() {
    //
    Navigator.push(
        viewContext,
        MaterialPageRoute(
            builder: (context) => PharmacyUploadPrescription(vendor!)));
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    return refreshContollers[index];
  }

  loadMenuProduts() {
    refreshContollers = List.generate(
      vendor!.menus.length,
      (index) => RefreshController(),
    );
    refreshContollerKeys = List.generate(
      vendor!.menus.length,
      (index) => vendor!.menus[index].id,
    );
    for (var element in vendor!.menus) {
      loadMoreProducts(element.id);
      menuProductsQueryPages[element.id] = 1;
    }
  }

  loadMoreProducts(int id, {bool initialLoad = true}) async {
    int queryPage = menuProductsQueryPages[id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      menuProductsQueryPages[id] = queryPage;
      getRefreshController(id).refreshCompleted();
      setBusyForObject(id, true);
    } else {
      menuProductsQueryPages[id] = ++queryPage;
    }

    //load the products by subcategory id
    try {
      final mProducts = await _productRequest.getProdcuts(
        page: queryPage,
        queryParams: {
          "menu_id": id,
          "vendor_id": vendor!.id,
        },
      );

      //
      if (initialLoad) {
        menuProducts[id] = mProducts;
      } else {
        menuProducts[id]!.addAll(mProducts);
      }
    } catch (error) {
      print("load more error ==> $error");
    }

    //
    if (initialLoad) {
      setBusyForObject(id, false);
    } else {
      getRefreshController(id).loadComplete();
    }

    notifyListeners();
  }

  openVendorSearch() {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => VendorSearchPage(vendor!)));
  }

  void onFavoriteChange(bool isFavorite) {
    vendor?.isFavorite = isFavorite;
    notifyListeners();
  }
}
