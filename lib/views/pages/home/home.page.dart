import 'package:flutter/material.dart';
import 'package:mealknight/constants/app_colors.dart';
import 'package:mealknight/constants/app_images.dart';
import 'package:mealknight/constants/app_strings.dart';
import 'package:mealknight/models/vendor_type.dart';
import 'package:mealknight/services/location.service.dart';
import 'package:mealknight/services/navigation.service.dart';
import 'package:mealknight/constants/app_font.dart';
import 'package:mealknight/view_models/welcome.vm.dart';
import 'package:mealknight/views/pages/delivery_address/delivery_addresses.page.dart';
import 'package:mealknight/views/pages/home/Widget/HomeOptionWidget.dart';
import 'package:mealknight/views/pages/profile/profile.page.dart';
import 'package:mealknight/view_models/home.vm.dart';
import 'package:mealknight/views/pages/vendor/widgets/banners.view.dart';
import 'package:mealknight/widgets/states/loading.shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_routes.dart';
import '../../../models/search.dart';
import '../../../view_models/vendor_distance.vm.dart';
import '../../common_widget/app_header.dart';
import '../vendor/widgets/section_vendors.view.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel vm;
  VendorDistanceViewModel vendorDistanceViewModel = VendorDistanceViewModel();
  Future<void> locationListener() async {
    await LocationService.prepareLocationListener();
  }

  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        locationListener();
        vm.initialise();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
      viewModelBuilder: () => WelcomeViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      disposeViewModel: false,
      builder: (context, vm, child) {
        return Scaffold(
          body: Stack(
            children: [
              Image.asset(AppImages.homeBG,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            ).then((value) {
                              /*if (value != null) {
                                setState(() {
                                  vm.updateAddress();
                                });
                              }*/
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Image.asset(AppImages.userIcon, height: 45),
                          ),
                        ),
                        8.widthBox,
                        Expanded(
                          child: ValueListenableBuilder<String>(
                            valueListenable: vendorDistanceViewModel.myAddress,
                            builder: (BuildContext context, String myAddress,
                                child) {
                              return GestureDetector(
                                onTap: () {
                                  // Within the `FirstRoute` widget
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DeliveryAddressesPage()),
                                  ).then((value) {
                                    if (null != value && value) {
                                      //
                                      //vm.updateAddress();
                                      /*Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.splash,
                                    (Route<dynamic> route) => false,
                                  );*/
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0,
                                              3), // Offset in the y-axis to create a bottom shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          myAddress.isNotEmpty
                                              ? myAddress
                                              : 'Add Address',
                                          style: TextStyle(
                                              color: AppColor.primary,
                                              fontFamily: AppFonts.appFont,
                                              fontSize: 15),
                                        ),
                                      ),
                                      10.widthBox,
                                      myAddress.isEmpty
                                          ? Icon(Icons.expand_more,
                                              size: 18, color: AppColor.primary)
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        8.widthBox,
                        ValueListenableBuilder<bool>(
                          valueListenable: vendorDistanceViewModel.isPickup,
                          builder:
                              (BuildContext context, bool isPickup, child) {
                            return GestureDetector(
                              onTap: () {
                                vendorDistanceViewModel
                                    .onUpdatePickup(!isPickup);
                              },
                              child: Container(
                                width: 110.0,
                                height: 45.0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0,
                                            3), // Offset in the y-axis to create a bottom shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      decoration: BoxDecoration(
                                          color: !isPickup
                                              ? AppColor.primaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Image.asset(
                                        AppImages.car, // Repl
                                        height: 30.0,
                                      ),
                                    ),
                                    Container(
                                      width: 50.0,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: isPickup
                                              ? AppColor.primaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Image.asset(
                                        AppImages.walk, //
                                        height: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    expandedHeight: 120.0,
                    pinned: true,
                    floating: true,
                    bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 62),
                      child: Container(
                        // color: innerBoxIsScrolled ? Colors.white : Colors.transparent,
                        height: 58,
                        margin: const EdgeInsets.only(top: 4.0),
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child:vm.vendorTypes.isEmpty ? const SizedBox() : Builder(
                          builder: (context) {
                           // final vendorType = vm.vendorTypes.first;
                            return AppHeader(
                              type: "vendor",
                              vendorType: vm.vendorTypes.first,
                              subCategories: const [],
                              vendorTypes: vm.vendorTypes,
                              hintText: "Search Pizza, Burger, Indian, etc.",
                              showFilter: false,
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  SliverList.list(children: [
                    vm.isBusy
                        ? const LoadingShimmer().px20().h(150)
                        : Visibility(
                            visible: vm.vendorTypes.isNotEmpty,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: vm.vendorTypes.length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: 0),
                                itemBuilder: (BuildContext context, int index) {
                                  VendorType type = vm.vendorTypes[index];
                                  return HomeOptionWidget(
                                    title: type.name,
                                    icon: type.logo,
                                    onTap: () {
                                      final vendorType = vm.vendorTypes[index];
                                      NavigationService.pageSelected(
                                        vendorType,
                                        context: context,
                                        vendorList: vm.vendorTypes,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                    if (vm.vendorTypes.isNotEmpty)
                      15.heightBox
                    else
                      20.heightBox,
                    const Banners(vendorType: null),
                    SectionVendorsView(
                      vm.vendorType,
                      title: "Featured Stores",
                      scrollDirection: Axis.horizontal,
                      type: SearchFilterType.sales,
                      itemWidth: context.percentWidth * 55,
                      byLocation: AppStrings.enableFatchByLocation,
                    ),
                    const SizedBox(
                      height: 82.0,
                    ),
                  ]),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cartRoute);
              },
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  AppImages.shoppingCartShield,
                  height: 60,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
