import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/view_models/service.vm.dart';
import 'package:mealknight/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingPage extends StatefulWidget {
  const BookingPage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with AutomaticKeepAliveClientMixin<BookingPage> {
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(context, widget.vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          showCart: true,
          key: pageKey,
          body: VStack(
            [],
          ).scrollVertical(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
