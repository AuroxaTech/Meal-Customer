import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mealknight/models/address.dart';
import 'package:mealknight/view_models/ops_map.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OPSAutocompleteTextField extends StatelessWidget {
  const OPSAutocompleteTextField({
    required this.onselected,
    this.textEditingController,
    this.inputDecoration,
    required this.debounceTime,
    super.key,
  });

  final Function(Address) onselected;
  final TextEditingController? textEditingController;
  final InputDecoration? inputDecoration;
  final int debounceTime;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OPSMapViewModel>.reactive(
      viewModelBuilder: () => OPSMapViewModel(context),
      builder: (ctx, vm, child) {
        return TypeAheadField<Address>(
          retainOnLoading: false,
          debounceDuration: Duration(milliseconds: debounceTime),
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller, // note how the controller is passed
              focusNode: focusNode,
              decoration: inputDecoration ??
                  InputDecoration(
                    hintText: 'Search address'.tr(),
                  ),
            );
          },
          suggestionsCallback: (String search) async {
            if (search.length > 2) {
              return await vm.fetchPlaces(search);
            }
            return [];
          },
          itemBuilder: (BuildContext context, Address suggestion) {
            return ListTile(
              title: "${suggestion.addressLine}".text.base.semiBold.make(),
              subtitle: "${suggestion.adminArea}".text.sm.make(),
            );
          },
          emptyBuilder: (ctx) {
            return "No Address found".tr().text.make().p12();
          },
          onSelected: (Address address) async {
            final mAddress = await vm.fetchPlaceDetails(address);
            this.onselected(mAddress);
          },
        );
      },
    );
  }
}
