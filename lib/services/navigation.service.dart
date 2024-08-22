import 'package:flutter/material.dart';
import 'package:mealknight/models/product.dart';
import 'package:mealknight/models/search.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/services/auth.service.dart';
import 'package:mealknight/views/pages/auth/login.page.dart';
import 'package:mealknight/views/pages/booking/booking.page.dart';
import 'package:mealknight/views/pages/commerce/commerce.page.dart';
import 'package:mealknight/views/pages/food/food.page.dart';
import 'package:mealknight/views/pages/grocery/grocery.page.dart';
import 'package:mealknight/views/pages/parcel/parcel.page.dart';
import 'package:mealknight/views/pages/pharmacy/pharmacy.page.dart';
import 'package:mealknight/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:mealknight/views/pages/product/product_details.page.dart';
import 'package:mealknight/views/pages/search/product_search.page.dart';
import 'package:mealknight/views/pages/search/search.page.dart';
import 'package:mealknight/views/pages/search/service_search.page.dart';
import 'package:mealknight/views/pages/service/service.page.dart';
import 'package:mealknight/views/pages/taxi/taxi.page.dart';
import 'package:mealknight/views/pages/vendor/vendor.page.dart';
import 'package:velocity_x/velocity_x.dart';

class NavigationService {
  static pageSelected(VendorType vendorType,
      {required BuildContext context,
      bool loadNext = true,
      required List<VendorType> vendorList}) async {
    Widget nextpage =
        vendorTypePage(vendorType, context: context, vendorList: vendorList);

    //
    if (vendorType.authRequired && !AuthServices.authenticated()) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  required: true,
                )),
      );

      if (result == null || !result) {
        return;
      }
    }
    //
    if (loadNext) {
      context.nextPage(nextpage);
    }
  }

  static Widget vendorTypePage(VendorType vendorType,
      {required BuildContext context, required List<VendorType> vendorList}) {
    Widget homeView = FoodPage(vendorType, vendorList);
    print("Vendor Type  : ${vendorType.slug}");
    /*switch (vendorType.slug) {
      case "parcel":
        homeView = ParcelPage(vendorType);
        break;
      case "grocery":
        homeView = GroceryPage(vendorType);
        break;
      case "food":
        homeView = FoodPage(vendorType, vendorList);
        break;
      case "pharmacy":
        homeView = PharmacyPage(vendorType);
        break;
      case "service":
        homeView = ServicePage(vendorType);
        break;
      case "booking":
        homeView = BookingPage(vendorType);
        break;
      case "taxi":
        homeView = TaxiPage(vendorType);
        break;
      case "commerce":
        homeView = CommercePage(vendorType);
        break;
      default:
        homeView = VendorPage(vendorType);
        break;
    }*/
    return homeView;
  }

  ///special for product page
  Widget productDetailsPageWidget(Product product) {
    if (!product.vendor.vendorType.isCommerce) {
      return ProductDetailsPage(
        product: product,
      );
    } else {
      return AmazonStyledCommerceProductDetailsPage(
        product: product,
      );
    }
  }

  Widget searchPageWidget(Search search) {
    debugPrint("searchPageWidget====${search.vendorType?.name}");
    if (search.vendorType == null) {
      return SearchPage(search: search);
    }
    //
    if (search.vendorType!.isProduct) {
      return ProductSearchPage(search: search);
    } else if (search.vendorType!.isService) {
      return ServiceSearchPage(search: search);
    } else if (search.vendorType!.isBooking) {
      return BookingPage(search.vendorType!);
    } else if (search.vendorType!.isGrocery) {
      return GroceryPage(search.vendorType!);
    } else {
      return SearchPage(search: search);
    }
  }
}
