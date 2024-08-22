import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/service.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/requests/service.request.dart';
import 'package:mealknight/view_models/base.view_model.dart';
import 'package:mealknight/views/pages/service/service_details.page.dart';

class PopularServicesViewModel extends MyBaseViewModel {
  //
  ServiceRequest _serviceRequest = ServiceRequest();

  //
  List<Service> services = [];
  VendorType? vendorType;

  PopularServicesViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

  //
  initialise() async {
    setBusy(true);
    try {
      services = await _serviceRequest.getServices(
        byLocation: AppStrings.enableFatchByLocation,
        queryParams: {
          "vendor_type_id": vendorType?.id,
        },
      );
      clearErrors();
    } catch (error) {
      print("PopularServicesViewModel Error ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  //
  serviceSelected(Service service) {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => ServiceDetailsPage(service)));
  }
}
