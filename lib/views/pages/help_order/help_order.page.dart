import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_font.dart';
import '../../../constants/app_images.dart';
import '../../../utils/ui_spacer.dart';
import '../../../view_models/orders.vm.dart';
import '../../../widgets/base.page.dart';
import '../../../widgets/custom_list_view.dart';
import '../../../widgets/states/empty.state.dart';
import '../../../widgets/states/error.state.dart';
import '../../../widgets/states/loading.shimmer.dart';
import '../../../widgets/states/order.empty.dart';
import '../help_category/help_category.page.dart';

class HelpOrderPage extends StatefulWidget {
  const HelpOrderPage({super.key});

  @override
  State<HelpOrderPage> createState() => _HelpOrderPageState();
}

class _HelpOrderPageState extends State<HelpOrderPage>
    with AutomaticKeepAliveClientMixin<HelpOrderPage>, WidgetsBindingObserver {
  late OrdersViewModel vm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vm.fetchMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    vm = OrdersViewModel(context);
    super.build(context);
    return BasePage(
      title: "Need Help",
      showLeadingAction: true,
      showAppBar: true,
      elevation: 0,
      appBarColor: context.theme.colorScheme.surface,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: Colors.white,
      isBackground: false,
      actions: [
        Image.asset(AppImages.cashier),
      ],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Select your order',
              style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  fontSize: 25,
                  color: AppColor.primaryColor),
            ),
          ),
          Expanded(
            child: ViewModelBuilder<OrdersViewModel>.reactive(
              viewModelBuilder: () => vm,
              onViewModelReady: (vm) => vm.initialise(),
              builder: (context, vm, child) {
                return VStack(
                  [
                    vm.isAuthenticated()
                        ? vm.isBusy? const LoadingShimmer(): CustomListView(
                            padding: const EdgeInsets.all(0),
                            canRefresh: true,
                            canPullUp: true,
                            refreshController: vm.refreshController,
                            onRefresh: vm.fetchMyOrders,
                            onLoading: () =>
                                vm.fetchMyOrders(initialLoading: false),
                            isLoading: vm.isBusy,
                            dataSet: vm.orders,
                            hasError: vm.hasError,
                            errorWidget: LoadingError(
                              onrefresh: vm.fetchMyOrders,
                            ),
                            //
                            emptyWidget: const EmptyOrder(),
                            itemBuilder: (context, index) {
                              //
                              final order = vm.orders[index];

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.primaryColor, width: 3.0),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                margin: const EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            order.vendor?.name ?? "",
                                            style: TextStyle(
                                                fontFamily: AppFonts.appFont,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.primaryColor),
                                          ),
                                        ),
                                        Text(
                                          "${order.total}\$",
                                          style: TextStyle(
                                              fontFamily: AppFonts.appFont,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.primaryColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Jiffy.parse(
                                                        "${order.createdAt}",
                                                        pattern:
                                                            "yyyy-MM-dd HH:mm")
                                                    .format(
                                                        pattern:
                                                            "d MMM, y  EEEE"),
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.appFont,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColor.primaryColor),
                                              ),
                                              Text(
                                                order.code,
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.appFont,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColor.primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            context.nextPage(
                                              HelpCategoryPage(order: order),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.primaryColor,
                                                  width: 3.0),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "Select",
                                              style: TextStyle(
                                                  fontFamily: AppFonts.appFont,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.primaryColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                UiSpacer.verticalSpace(space: 2),
                          ).expand()
                        : EmptyState(
                            auth: true,
                            showAction: true,
                            actionPressed: vm.openLogin,
                          ).py12().centered().expand(),
                  ],
                ).px20().pOnly(top: Vx.dp20);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
