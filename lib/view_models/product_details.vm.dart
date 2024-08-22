import 'package:cool_alert/cool_alert.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mealknight/extensions/dynamic.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mealknight/constants/app_strings.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../models/cart.dart';
import '../models/option.dart';
import '../models/option_group.dart';
import '../models/product.dart';
import '../requests/favourite.request.dart';
import '../requests/product.request.dart';
import '../services/alert.service.dart';
import '../services/cart.service.dart';
import '../services/cart_ui.service.dart';
import 'base.view_model.dart';

class ProductDetailsViewModel extends MyBaseViewModel {
  ProductDetailsViewModel(BuildContext context, this.product) {
    viewContext = context;
    updatedSelectedQty(1);
  }

  //view related
  final productReviewsKey = GlobalKey();

  final ProductRequest _productRequest = ProductRequest();
  final FavouriteRequest _favouriteRequest = FavouriteRequest();
  RefreshController refreshController = RefreshController();
  int heatLevel = -1;

  Product product;
  List<Option> selectedProductOptions = [];
  List<int> selectedProductOptionsIDs = [];
  double subTotal = 0.0;
  double total = 0.0;
  bool backFlag = false;
  final currencySymbol = AppStrings.currencySymbol;

  void getProductDetails() async {
    setBusyForObject(product, true);
    try {
      final oldProductHeroTag = product.heroTag;
      product = await _productRequest.productDetails(product.id);
      product.heroTag = oldProductHeroTag;

      clearErrors();
      calculateTotal();
    } catch (error) {
      setError(error);
      toastError("$error");
    }
    setBusyForObject(product, false);
  }

  openVendorDetails() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: product.vendor,
    );
  }

  isOptionSelected(Option option) {
    return selectedProductOptionsIDs.contains(option.id);
  }

  toggleOptionSelection(OptionGroup optionGroup, Option option) {
    if (selectedProductOptionsIDs.contains(option.id)) {
      selectedProductOptionsIDs.remove(option.id);
      selectedProductOptions.remove(option);
    } else {
      //if it allows only one selection
      if (optionGroup.multiple == 0) {
        final foundOption = selectedProductOptions.firstOrNullWhere(
          (option) => option.optionGroupId == optionGroup.id,
        );
        selectedProductOptionsIDs.remove(foundOption?.id);
        selectedProductOptions.remove(foundOption);
      }
      //prevent selecting more than the max allowed
      if (optionGroup.maxOptions != null) {
        int selectedOptionsForGroup = selectedProductOptions
            .where((e) => e.optionGroupId == optionGroup.id)
            .length;
        if (selectedOptionsForGroup >= optionGroup.maxOptions!) {
          String errorMsg = "You can only select".tr();
          errorMsg += " ${optionGroup.maxOptions} ";
          errorMsg += "options for".tr();
          errorMsg += " ${optionGroup.name}";
          AlertService.error(text: errorMsg);
          return;
        }
      }

      selectedProductOptionsIDs.add(option.id);
      selectedProductOptions.add(option);
    }
    calculateTotal();
  }

  updatedSelectedQty(int qty) async {
    product.selectedQty = qty;
    calculateTotal();
  }

  calculateTotal() {
    //double productPrice = !product.showDiscount ? product.price : product.discountPrice;
    double productPrice = product.price;
    double totalOptionPrice = 0.0;
    for (var option in selectedProductOptions) {
      totalOptionPrice += option.price;
    }
    /*if (product.plusOption == 1 || selectedProductOptions.isEmpty) {
      subTotal = productPrice + totalOptionPrice;
    } else {
      subTotal = totalOptionPrice;
    }*/
    subTotal = productPrice + totalOptionPrice;

    if (product.selectedQty > 0) {
      total = subTotal * (product.selectedQty);
    } else {
      total = subTotal;
    }
    notifyListeners();
  }

  addToFavourite() async {
    setBusy(true);
    try {
      final apiResponse = await _favouriteRequest.makeFavourite(product.id);
      if (apiResponse.allGood) {
        product.isFavourite = true;
        AlertService.success(text: apiResponse.message);
      } else {
        viewContext.showToast(
          msg: "${apiResponse.message}",
          bgColor: Colors.red,
          textColor: Colors.white,
          position: VxToastPosition.top,
        );
      }
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  removeFromFavourite() async {
    setBusy(true);
    try {
      final apiResponse = await _favouriteRequest.removeFavourite(product.id);
      if (apiResponse.allGood) {
        //
        product.isFavourite = false;
        //
        AlertService.success(text: apiResponse.message);
      } else {
        viewContext.showToast(
          msg: "${apiResponse.message}",
          bgColor: Colors.red,
          textColor: Colors.white,
          position: VxToastPosition.top,
        );
      }
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //check if the option groups with required setting has an option selected
  optionGroupRequirementCheck() {
    //check if the option groups with required setting has an option selected
    bool optionGroupRequiredFail = false;
    OptionGroup? optionGroupRequired;
    //
    for (var optionGroup in product.optionGroups) {
      //
      optionGroupRequired = optionGroup;
      //
      final selectedOptionInOptionGroup =
          selectedProductOptions.firstOrNullWhere(
        (e) => e.optionGroupId == optionGroup.id,
      );

      //check if there is an option group that is required but customer is yet to select an option
      if (optionGroup.required == 1 && selectedOptionInOptionGroup == null) {
        optionGroupRequiredFail = true;
        break;
      }
    }
    if (optionGroupRequiredFail) {
      CoolAlert.show(
        context: viewContext,
        title: "Option required".tr(),
        text:
            "${"You are required to select at least one option of".tr()} ${optionGroupRequired?.name}",
        type: CoolAlertType.error,
      );

      throw "Option required".tr();
    }
  }

  Future<bool> addToCart({bool force = false, bool skip = false}) async {
    bool done = false;
    // if (heatLevel == -1) {
    //   backFlag = false;
    //   CoolAlert.show(
    //     showCancelBtn: false,
    //     context: viewContext,
    //     title: "Processing..".tr(),
    //     text: "Please choose heat level before adding to cart.".tr(),
    //     type: CoolAlertType.confirm,
    //     onConfirmBtnTap: () async {
    //       //Navigator.of(viewContext).pop();
    //     },
    //   );
    // } else {
      backFlag = true;
      product.selectedQty = 1;
      final cart = Cart();
      cart.price = subTotal;
      cart.product = product;
      cart.selectedQty = 1;
      cart.heatLevel = heatLevel;
      cart.options = selectedProductOptions;
      cart.optionsIds = selectedProductOptionsIDs;

      try {
        //check if the option groups with required setting has an option selected
        optionGroupRequirementCheck();
        setBusy(true);
        bool canAddToCart = await CartUIServices.handleCartEntry(
          viewContext,
          cart,
          product,
        );

        if (canAddToCart || force) {
          await CartServices.addToCart(cart);
          if (!skip) {
            done = await CoolAlert.show(
              context: viewContext,
              title: "Add to cart".tr(),
              text: "%s Added to cart".tr().fill([product.name]),
              type: CoolAlertType.success,
              showCancelBtn: true,
              confirmBtnColor: AppColor.primaryColor,
              confirmBtnText: "GO TO CART".tr(),
              confirmBtnTextStyle: viewContext.textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
              onConfirmBtnTap: () async {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pushNamed(viewContext, AppRoutes.cartRoute);
                });
                //Navigator.of(viewContext).pop(true);
                //viewContext.nextPage(CartPage());
              },
              cancelBtnText: "Keep Shopping".tr(),
              cancelBtnTextStyle: viewContext.textTheme.labelLarge,
            );
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
              addToCart(force: true);
            },
          );
        } else {
          //
          done = await CoolAlert.show(
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
              addToCart(force: true);
            },
          );
        }
      } catch (error) {
        setError(error);
      }
      setBusy(false);

    return done;
  }

  buyNow() async {
    try {
      //check if the option groups with required setting has an option selected
      optionGroupRequirementCheck();
      await addToCart(skip: true);
      Navigator.of(viewContext).pop();

      Navigator.pushNamed(viewContext, AppRoutes.cartRoute);
    } catch (error) {
      toastError("$error");
    }
  }
}
